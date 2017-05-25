using Hermetic
using DataStructures
using Base.Test



## lexicographic ordering for m = 3, k = 3

L =  [0     0     0
      0     0     1
      0     1     0
      1     0     0
      0     0     2
      0     1     1
      0     2     0
      1     0     1
      1     1     0
      2     0     0
      0     0     3
      0     1     2
      0     2     1
      0     3     0
      1     0     2
      1     1     1
      1     2     0
      2     0     1
      2     1     0
      3     0     0]


x = [0,0,0]
for j = 1:19
    Hermetic.mono_next_grlex!(x, 3)
    println("Checking glxr ordering: ", j+1)
    @test x == vec(L[j+1,:])
end

XX = zeros(Int, 20, 3);
Hermetic.mono_grlex!(XX, 3)
@test XX == L



He_table = OrderedDict([
              (1, [0, 1.]),
              (2, [-1., 0, 1]),
              (3, [0., -3, 0, 1]),
              (4, [3., 0, -6, 0, 1]),
              (5, [0., 15, 0, -10, 0, 1]),
              (6, [-15., 0, 45, 0, -15, 0, 1]),
              (7, [0, -105, 0, 105, 0, -21, 0, 1]),
              (8, [105, 0, -420, 0, 210, 0, -28, 0, 1]),
              (9, [0, 945, 0, -1260, 0, 378, 0, -36, 0, 1]),
              (10,[-945, 0, 4725, 0, -3150, 0, 630, 0, -45, 0, 1])
             ])

Hen_table = OrderedDict([
              (1, [0,1.]),
              (2, [-0.707107, 0, 0.707107]),
              (3, [0, -1.22474, 0, 0.408248]),
              (4, [0.612372, 0, -1.22474, 0, 0.204124]),
              (5, [0, 1.36931, 0, -0.912871, 0, 0.0912871]),
              (6, [-0.559017, 0, 1.67705, 0, -0.559017, 0, 0.0372678]),
              (7, [0, -1.47902, 0, 1.47902, 0, -0.295804, 0, 0.0140859]),
              (8, [0.522913, 0, -2.09165, 0, 1.04583, 0, -0.139443, 0, 0.00498012]),
              (9, [0, 1.56874, 0, -2.09165, 0, 0.627495, 0, -0.0597614, 0, 0.00166004]),
              (10,[-0.496078, 0, 2.48039, 0, -1.65359, 0, 0.330719, 0, -0.0236228, 0, 0.000524951])
                         ])

for i = enumerate(He_table)
    o, c, e = Hermetic.He_coefficients(i[1])
    @test i[2][:2][e + 1] == c
end

for i = enumerate(Hen_table)
    o, c, e = Hermetic.Hen_coefficients(i[1])
    @test_approx_eq_eps i[2][:2][e + 1] c 1e-05
end

## Hen_value


## Hen(j, 2) j = 0:10
Hen_2 = [1., 2., 2.1213203435596424, 0.8164965809277261,
         -1.0206207261596576, -1.6431676725154982, -0.4099457958749614,
         1.2113877651108738, 1.2400496821844333, -0.31540754968546497,
         -1.3758956718849784]

## Hen(j, -2) j = 0:10
Hen_m2 = [1.,-2.,2.121320344,-0.8164965809,-1.020620726,1.643167673,
          -0.4099457959,-1.211387765,1.240049682,0.3154075497,-1.375895672]


## Hen(j, 1.2) j = 0:10
Hen_12 = [1.,1.2,0.3111269837,-0.7642407997,-0.7279883516,0.2928782059,
          0.8080398352,0.09533989072,-0.7154027646,-0.3760484168,0.5359903132]

## Hen(j, -1.2) j = 0:10
Hen_m12 = [1.,-1.2,0.3111269837,0.7642407997,-0.7279883516,-0.2928782059,
           0.8080398352,-0.09533989072,-0.7154027646,0.3760484168,0.5359903132]


for j = 0:10
    @test_approx_eq_eps [Hen_2[j+1]]   Hermetic.Hen_value(j, [2.]) 1e-8
    @test_approx_eq_eps [Hen_m2[j+1]]  Hermetic.Hen_value(j, [-2.]) 1e-8
    @test_approx_eq_eps [Hen_12[j+1]]  Hermetic.Hen_value(j, [1.2]) 1e-8
    @test_approx_eq_eps [Hen_m12[j+1]] Hermetic.Hen_value(j, [-1.2]) 1e-8
end


## Polynomials add test

function poly_add_test()
    m  = 3
    o1 = 6
    c1 = [7.0, - 5.0, 9.0, 11.0, 0.0, - 13.0]
    e1 = [1, 2, 4, 5, 12, 33]

    o2 = 5
    c2 = [2.0, 3.0, -8.0, 4.0, 9.0]
    e2 = [1, 3, 4, 30, 33]

    println("Add two polynomials")
    println("P(X) = P1(X) + P2(X)")
    println("")
    Hermetic.polynomial_print(m, o1, c1, e1, title = "P1(X) = ")
    Hermetic.polynomial_print(m, o2, c2, e2, title = "P2(X) = ")

    o, c, e = Hermetic.polynomial_add(o1, c1, e1, o2, c2, e2)
    Hermetic.polynomial_print(m, o, c, e, title = "P1(X) + P2(X) = ")
    @test o == 7
    @test c == [9.0, -5.0, 3.0, 1.0, 11.0, 4.0, -4.0]
    @test e == [1 2 3 4 5 30 33]

end

function poly_mul_test()
    m  = 3
    o1 = 4
    c1 = [2.0, 3.0, 4.0, 5.0]
    e1 = [  1,   3,   4,   6]

    o2 = 2
    c2 = [6.0, 7.0]
    e2 = [  2,   5]

    println("Multiply two polynomials")
    println("P(X) = P1(X) * P2(X)")
    println("")
    Hermetic.polynomial_print(m, o1, c1, e1, title = "P1(X) = ")
    Hermetic.polynomial_print(m, o2, c2, e2, title = "P2(X) = ")

    o, c, e = Hermetic.polynomial_mul(m, o1, c1, e1, o2, c2, e2)
    Hermetic.polynomial_print(m, o, c, e, title = "P1(X) * P2(X) = ")
    @test o == 7
    @test c == [8.0,9.0,9.0,10.0,21.0,11.0,12.0]
    @test e == [2, 5, 6, 8, 12, 15, 22]
end



p = ProductPoly(2, 4)
setcoef!(p, [1, .1, .2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1, 1.2, 1.3, 1.4])
@test p.c == [1, .1, .2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1, 1.2, 1.3, 1.4]


monomial_exponent = [0 0
                     0 1
                     1 0
                     0 2
                     1 1
                     2 0
                     0 3
                     1 2
                     2 1
                     3 0
                     0 4
                     1 3
                     2 2
                     3 1
                     4 0]

L = Hermetic.mono_grlex!(Array{Int}(15, 2), 2)

for j = 1:p.o
    ## Hack to have tests pass both on v0.4.x and on v0.5.x
    ## due to https://github.com/JuliaLang/julia/issues/5949
    @test all(Hermetic.mono_unrank_grlex(p.m, p.e[j]) .== L[j:j,:]')
end

mono_exp_coef = [monomial_exponent [1, .1, .2, 0.3,
                  0.4, 0.5, 0.6,
                  0.7, 0.8, 0.9,
                  1, 1.1, 1.2, 1.3, 1.4]]

for j = 1:p.o
    @test all([Hermetic.mono_unrank_grlex(p.m, p.e[j]); p.c[j]] .== mono_exp_coef[j:j,:]')
end

## Evaluation tests

## values[i][j] are the value of the polynomial at r[i] and s[j] where
## r = -1:.1:1 and s = -1:.1:1


@test polyval(p, [0. 0.]) == [p.c[1]]
@test polyval(p, [1. 1.]) == [sum(p.c)]

r = -1:.1:1
s = -1:.1:1

values = (
          [4.9, 4.1886, 3.6176, 3.1636, 2.8056, 2.525, 2.3056, 2.1336, 1.9976,
           1.8886, 1.8, 1.7276, 1.6696, 1.6266, 1.6016, 1.6, 1.6296, 1.7006,
           1.8256, 2.0196, 2.3],
          [4.07914, 3.4516, 2.95536, 2.56768, 2.26822,
           2.03904, 1.8646, 1.73176, 1.62978, 1.55032, 1.48744, 1.4376, 1.39966,
           1.37488, 1.36692, 1.38184, 1.4281, 1.51656, 1.66048, 1.87552,
           2.17974],
          [3.43424, 2.88058, 2.4496, 2.11922, 1.86976, 1.68394,
           1.54688, 1.4461, 1.37152, 1.31546, 1.27264, 1.24018, 1.2176, 1.20682,
           1.21216, 1.24034, 1.30048, 1.4041, 1.56512, 1.79986, 2.12704],
          [2.93434, 2.44536, 2.07092, 1.7896, 1.58238, 1.43264, 1.32616,
           1.25112, 1.1981, 1.16008, 1.13244, 1.11296, 1.10182, 1.1016, 1.11728,
           1.15624, 1.22826, 1.34552, 1.5226, 1.77648, 2.12654],
          [2.55184, 2.11912, 1.79328, 1.55356, 1.3816, 1.26144, 1.17952, 1.12468,
           1.08816, 1.0636, 1.04704, 1.03692, 1.03408, 1.04176, 1.0656, 1.11364,
           1.19632, 1.32648, 1.51936, 1.7926, 2.16624],
          [2.2625, 1.8784, 1.594, 1.3892, 1.2463, 1.15, 1.0874, 1.048,
           1.0237, 1.0088, 1., 0.9964, 0.9995, 1.0132, 1.0438, 1.1,
           1.1929, 1.336,
           1.5452, 1.8388, 2.2375],
          [2.04544, 1.7031, 1.45376, 1.27798, 1.15872, 1.08134, 1.0336,
           1.00566, 0.99008, 0.98182, 0.97824, 0.9791, 0.98656, 1.00518,
           1.04192, 1.10614, 1.2096, 1.36646, 1.59328, 1.90902, 2.33504],
          [1.88314, 1.57648, 1.3566, 1.20472, 1.10446, 1.04184, 1.00528,
           0.9856, 0.97602, 0.97216, 0.97204, 0.97608, 0.9871, 1.01032, 1.05336,
           1.12624, 1.24138, 1.4136, 1.66012, 2.00056, 2.45694],
          [1.76144, 1.48516, 1.28992, 1.1576, 1.07248, 1.02124, 0.99296,
           0.97912, 0.9736,  0.97268, 0.97504, 0.98176, 0.99632, 1.0246,
           1.07488, 1.15784, 1.28656, 1.47652, 1.7456, 2.11408,
           2.60464],
          [1.66954, 1.41912, 1.24448, 1.12816, 1.0551, 1.01264, 0.99052,
           0.98088, 0.97826, 0.9796, 0.98424, 0.99392, 1.01278, 1.04736,
           1.1066, 1.20184, 1.34682, 1.55768, 1.85296, 2.2536, 2.78294],
          [1.6, 1.3717, 1.2144, 1.1113, 1.048, 1.0125, 0.9952, 0.9889,
           0.9888, 0.9925, 1., 1.0137, 1.0384, 1.0813, 1.152, 1.2625,
           1.4272, 1.6629, 1.9888, 2.4265, 3.],
          [1.54874, 1.3396, 1.19716, 1.10528, 1.05022, 1.02064, 1.0076,
           1.00456, 1.00738, 1.01432, 1.02604, 1.0456, 1.07846, 1.13248,
           1.21792, 1.34744, 1.5361,
           1.80136, 2.16308, 2.64352, 3.26734],
          [1.51504, 1.32288, 1.1936,
           1.11172, 1.06416, 1.04024, 1.03168, 1.0326, 1.03952, 1.05136,
           1.06944, 1.09748, 1.1416, 1.21032, 1.31456, 1.46764, 1.68528, 1.9856,
           2.38912, 2.91876, 3.59984],
          [1.50154, 1.32496, 1.20792, 1.1356,
           1.09558, 1.07784, 1.07476, 1.08112, 1.0941, 1.11328, 1.14064,
           1.18056, 1.23982, 1.3276, 1.45548, 1.63744, 1.88986, 2.23152, 2.6836,
           3.26968, 4.01574],
          [1.51424, 1.35262, 1.24768, 1.18526, 1.1536,
           1.14334, 1.14752, 1.16158, 1.18336, 1.2131, 1.25344, 1.30942,
           1.38848, 1.50046, 1.6576, 1.87454, 2.16832, 2.55838, 3.06656, 3.7171,
           4.53664],
           [1.5625, 1.416, 1.3238, 1.2724, 1.2507, 1.25, 1.264,
           1.2888, 1.3229, 1.3672, 1.425, 1.502, 1.6063, 1.7484, 1.9412, 2.2,
           2.5425, 2.9888, 3.5614, 4.2852, 5.1875],
          [1.65904, 1.5286, 1.45056, 1.41208, 1.40272, 1.41444, 1.4416,
           1.48096, 1.53168, 1.59532,
           1.67584, 1.7796, 1.91536, 2.09428, 2.32992, 2.63824, 3.0376, 3.54876,
           4.19488, 5.00152, 5.99664],
          [1.81994, 1.70728, 1.6456, 1.62272,
           1.62886, 1.65664, 1.70108, 1.7596, 1.83202, 1.92056, 2.02984,
           2.16688, 2.3411, 2.56432, 2.85076, 3.21704, 3.68218, 4.2676, 4.99712,
           5.89696, 6.99574],
          [2.06464, 1.97226, 1.92992, 1.9261, 1.95168,
           1.99994, 2.06656, 2.14962, 2.2496, 2.36938, 2.51424, 2.69186,
           2.91232, 3.1881, 3.53408, 3.96754, 4.50816, 5.17802, 6.0016, 7.00578,
           8.21984],
          [2.41594, 2.34712, 2.32788, 2.34736, 2.3971, 2.47104,
           2.56552, 2.67928, 2.81346, 2.9716, 3.15964, 3.38592, 3.66118,
           3.99856, 4.4136, 4.92424, 5.55082, 6.31608, 7.24516, 8.3656,
           9.70734],
          [2.9, 2.8588, 2.8672, 2.915, 2.9944, 3.1, 3.2288, 3.3802,
           3.556, 3.7604, 4., 4.2838, 4.6232, 5.032, 5.5264, 6.125, 6.8488,
           7.7212, 8.768, 10.0174, 11.5])



for j = enumerate(s)
    for i = enumerate(r)
        @test polyval(p, [j[2] i[2]])≈[values[j[1]][i[1]]]
    end
end

## Construct a matrix of evaluation point

X = [repeat(collect(s), inner = [length(s)]) repeat(collect(r), outer = [length(s)])]
v = vcat([values[j] for j = 1:length(values)]...)

E = polyval(p, X)

for j = 1:size(E, 1)
    @test E[j]≈v[j]
end



## Test product of product polynomial

q = p*p

coef_q = [1, 1/5, 2/5, 61/100, 21/25, 26/25, 63/50, 8/5, 93/50, 2, 221/100,
          141/50, 33/10, 7/2, 341/100, 14/25, 38/25, 58/25, 131/50, 58/25,
          73/50, 24/25, 23/10, 81/20, 126/25, 249/50, 193/50, 221/100, 6/5,
          68/25, 229/50, 34/5, 37/5, 31/5, 229/50, 63/25, 1, 11/5, 361/100,
          131/25, 71/10, 31/5, 101/20, 91/25, 49/25]

for j in 1:p.o
    @test q.c[j]≈coef_q[j]
end

@test polyval(q, [0 0.]) == [1.0]
@test polyval(q, [1 1.]) == [132.25]

values =
    ([24.0100000000000051159,17.5443699600000009298,13.08702976000000184342,10.0083649599999979785,7.8713913599999978388,6.3756249999999976552,5.3157913599999986332,4.5522489599999982346,3.99040575999999935775,3.5668099599999991689,3.23999999999999932498,2.98460175999999943741,2.7875641600000000686,2.6458275599999994121,2.56512255999999894129,2.5599999999999996092,2.6555961599999990952,2.8920403600000001987,3.3328153600000010037,4.07878416000000232344,5.2899999999999991473],
     [16.6393831395999995948,11.9135425600000033342,8.7341527296000034397,6.59298058240000095509,5.14482196840000138849,4.15768412160000000455,3.47673316000000021120,2.99899269759999986817,2.65618284839999940772,2.4034921024000004408,2.2124777535999995415,2.06669376000000015736,1.9590481155999996954,1.8902950143999996957,1.86847028639999979127,1.90948178559999992565,2.0394696100000002659,2.2999542336000002862,2.7571938304000007669,3.5175752704000009530,4.7512664676000007091],
     [11.79400437760000563969,8.2977411364000026595,6.0005401600000007889,4.49109340840000115236,3.49600245760000127859,2.8356539236000006809,2.3928377344000000271,2.0912052100000000365,1.88106711040000029733,1.7304350116000002391,1.6196125695999998850,1.53804643240000005200,1.4825497599999999387,1.45641451240000008305,1.4693318655999998423,1.5384433155999999165,1.6912482304000002742,1.9714968100000003215,2.4496006144000022076,3.23949601960000244105,4.5242991616000001187],
     [8.6103512355999978212,5.97978552959999998251,4.2887096463999982987,3.2026681599999986538,2.5039264643999996629,2.05245736959999902638,1.7587003455999994372,1.5653012543999995643,1.4354436099999998699,1.34578560639999955661,1.2824203535999998405,1.2386799615999999347,1.21400731240000014921,1.2135225599999999169,1.24831459840000014161,1.33689093759999977351,1.50862262760000032102,1.8104240704000007511,2.31831076000000058102,3.1558811904000023674,4.5221723715999972981],
     [6.5118873856000014655,4.49066957440000091850,3.2158531584000007442,2.4135486736000002495,1.9088185599999998310,1.5912308735999998177,1.3912674303999996717,1.26490510239999975894,1.18409218559999995790,1.1312449599999996330,1.0962927615999999986,1.0752030864000001742,1.0693214463999998198,1.08526389759999997153,1.13550335999999973957,1.2401940495999999037,1.43118154240000006183,1.75954919040000135055,2.30845480960000148940,3.2134147600000013689,4.69259573760000048281],
     [5.11890625000000110134,3.5283865600000003937,2.5408360000000000944,1.9298766400000000321,1.55326368999999986364,1.3224999999999997868,1.1824387599999999221,1.0983040000000001690,1.0479616899999997237,1.0176774399999999332,1.0000000000000000000,0.9928129599999998556,0.9990002499999997010,1.02657423999999974917,1.0895184400000001990,1.2099999999999997424,1.4230104100000002809,1.7848960000000013704,2.38764304000000127104,3.38118544000000342820,5.0064062499999995026],
     [4.18382479360000036905,2.9005496100000001114,2.11341813760000052369,1.63323288039999980903,1.3426320383999998942,1.1692961955999998658,1.0683289599999996611,1.0113520356000000877,0.9802584063999999486,0.9639705123999998682,0.9569534976000000359,0.9586368100000001169,0.9733006335999997427,1.01038683239999982355,1.0855972863999998612,1.2235456995999998142,1.4631321600000000149,1.8672129316000012356,2.5385411584000006080,3.64435736040000302083,5.4524118015999993858],
     [3.5462162595999999759,2.4852891904000005141,1.84036356000000012045,1.4513502783999994161,1.2198318915999999401,1.0854305855999997199,1.0105878783999999726,0.9714073599999998310,0.9526150404000000016,0.94509506559999978403,0.9448617616000000163,0.9527321664000001356,0.9743664099999999051,1.0207465023999997555,1.1095672896000001728,1.26841653760000028228,1.5410243044000002666,1.9982649600000017553,2.7559984144000009287,4.0022403136000042068,6.0365541636000017434],
     [3.10267087359999971241,2.2057002256000006746,1.6638936063999998360,1.3400377599999999667,1.15021335040000027838,1.04293113759999989121,0.98596956159999993297,0.9586759743999999639,0.94789695999999978859,0.9461063824000000011,0.9507030015999997641,0.9638526976000001412,0.9926535423999996999,1.04980516000000001497,1.1553670144000001141,1.3405934656000000338,1.65523663360000039546,2.18011131040000138981,3.0471193600000008317,4.4693342464000034298,6.78414952960000139370],
     [2.7873638116000001297,2.01390157440000061584,1.5487304704000000033,1.2727449855999997119,1.1132360099999998315,1.02543976959999993959,0.9811298703999998816,0.9621255743999999055,0.9569926276000000342,0.9596161600000000513,0.9687283775999999680,0.9878769664000002226,1.0257233284000000229,1.0969629695999996155,1.2245635599999999954,1.44441938560000004976,1.8139241124000002880,2.4263669824000011488,3.4334607616000014652,5.0787129600000042728,7.74475504359999966653],
     [2.5600000000000004974,1.8815608900000004855,1.4747673599999997496,1.23498768999999986029,1.0983040000000001690,1.0251562499999999911,0.9904230399999999213,0.9779232100000000427,0.97772544000000005671,0.9850562499999998556,1.0000000000000000000,1.02758769000000005356,1.0782745599999998820,1.16920968999999974614,1.3271040000000002834,1.5939062499999998579,2.0368998400000006832,2.7652364100000017544,3.9553254400000015245,5.8879022500000033347,9.0000000000000000000],
     [2.39859558760000002309,1.7945281600000009270,1.4331920655999998981,1.2216438783999996609,1.1029620483999997838,1.04170600959999992696,1.01525776000000012012,1.00914079360000030761,1.01481446440000033782,1.0288450623999998434,1.0527580816000001729,1.0932793600000001444,1.1630759715999998694,1.2825109503999998495,1.4833291264000008081,1.8155945536000004381,2.3596032100000008391,3.2448978496000027150,4.6789150864000017549,6.9881979904000051107,10.6755106755999999990],
     [2.29534620159999969147,1.7500114943999995898,1.42468095999999988521,1.23592135839999950342,1.1324365056000000873,1.08209925759999969763,1.06436362240000037538,1.06626276000000030919,1.08060183040000001853,1.1053578496000000531,1.1437019136000003972,1.2044623504000004921,1.30325056000000039091,1.46487450240000005586,1.7280679936000009622,2.1539671696000000090,2.8401686784000017560,3.9426073600000046682,5.70789437440000302360,8.5191599376000084476,12.9588480256000053714],
     [2.25462237160000089631,1.7555190016000004061,1.4590707264000002397,1.28958735999999984934,1.20029553640000008485,1.1617390655999997318,1.1551090575999998222,1.1688204544000002638,1.1970548099999995806,1.2393923584000001714,1.3010596096000002220,1.39372191360000008409,1.5371536324000003582,1.7625217599999996043,2.1184220304000001001,2.6812097536000005782,3.57157081960000111209,4.9796815104000025087,7.20170896000000393400,10.6908073024000103146,16.1261677476000002684],
     [2.2929227776000007388,1.8295808644000004506,1.55670538240000033703,1.4048412675999999433,1.33079296000000035782,1.30722635560000011168,1.31680215040000025972,1.3492680964000005606,1.40034088960000047130,1.4716116100000000699,1.57111183360000072895,1.71458073640000074889,1.9278767104000005261,2.2513802116000012354,2.7476377600000021495,3.5139002116000019882,4.7016116224000024104,6.54530822440000736862,9.4037902336000058767,13.8168324100000159405,20.58110248960000987495],
     [2.4414062500000000000,2.0050559999999997274,1.7524464400000001607,1.6190017599999999565,1.5642504899999998269,1.56249999999999955591,1.59769600000000000506,1.6610054399999998331,1.7500644100000000147,1.8692358399999999818,2.0306250000000001243,2.2560039999999998983,2.58019969000000015669,3.0569025599999997134,3.7682574400000010684,4.83999999999999896971,6.4643062500000025850,8.9329254400000071001,12.6835699600000015863,18.3629390400000112038,26.9101562500000000000],
     [2.7524137216000004180,2.3366179599999998828,2.1041243136000002956,1.9939699263999999257,1.96762339840000044511,2.00064051360000050295,2.07821056000000048414,2.1932425216000006607,2.3460436224000003058,2.54504590240000094781,2.80843970560000144587,3.16697616000000170544,3.66860392960000147866,4.3860087184000011717,5.4285272064000045233,6.9603102976000030822,9.22701376000000728084,12.59369753760000953946,17.5970182144000091284,25.01520231040002073541,35.9596912896000162618],
     [3.3121816036000013561,2.9148049984000010681,2.7079993600000005216,2.6332201984000018768,2.6531848996000011454,2.7444560896000016470,2.8936731664000019393,3.0961921600000024135,3.35629728040000241407,3.68855071360000286163,4.12025042560000365199,4.69536893440000380195,5.4807492100000043678,6.57573706240000621648,8.1268325776000089888,10.34934636160000742677,13.55844955240001503682,18.2124097600000212083,24.9712082944000250961,34.7741372416000444900,48.94037814760002902403],
     [4.26273832959999943171,3.88980950760000032673,3.72459120639999952118,3.7098612100000005753,3.8090548224000002620,3.9997600036000000578,4.2706702336000015308,4.6208661444000025398,5.0607001600000005581,5.6139615844000019251,6.3214027776000021319,7.2461102596000035447,8.4816077824000064567,10.16398161000000222032,12.4897214464000079204,15.74137365160000356923,20.32350658560001122055,26.8118911204000198722,36.0192025600000178542,49.0809534084000347320,67.56576962560002641567],
     [5.8367660836000041513,5.5089722944000012461,5.41902529440000346739,5.51009896960000489230,5.7460884100000040320,6.1060386816000038479,6.58189287040000614581,7.1785413184000042008,7.91555717160000504862,8.8304065600000072322,9.9833249296000090567,11.46445424640000965155,13.4042389924000122647,15.9884820736000090591,19.4798649600000217674,24.24813957760001059683,30.8116026724000278136,39.8928665664000376978,52.49234342560005472933,69.98326336000006619997,94.2324498756000394906],
     [8.4100000000000001421,8.1727374399999970223,8.2208358399999976740,8.4972250000000002501,8.9664313599999978521,9.6099999999999976552,10.4251494399999984353,11.42575203999999899906,12.6451360000000008199,14.1406081599999975396,16.0000000000000000000,18.3509424400000007438,21.37397824000000667866,25.32102400000000130831,30.5410969600000079538,37.5156250000000000000,46.90606144000000909955,59.6169294400000211454,76.87782400000001814533,100.34830276000003834724,132.25000000000000000000])

for j = enumerate(s)
    for i = enumerate(r)
        @test polyval(q, [j[2] i[2]])≈[values[j[1]][i[1]]]
    end
end


## Adding polynomial

a = p + p

coef_a = [2, 0.2, 0.4, 0.6, 0.8, 1., 1.2, 1.4, 1.6, 1.8, 2, 2.2, 2.4, 2.6, 2.8]

for j in 1:p.o
    @test a.c[j]≈coef_a[j]
end

values =
    ([9.800000,8.377200,7.235200,6.327200,5.611200,5.050000,4.611200,4.267200,3.995200,3.777200,3.600000,3.455200,3.339200,3.253200,3.203200,3.200000,3.259200,3.401200,3.651200,4.039200,4.600000],
     [8.158280,6.903200,5.910720,5.135360,4.536440,4.078080,3.729200,3.463520,3.259560,3.100640,2.974880,2.875200,2.799320,2.749760,2.733840,2.763680,2.856200,3.033120,3.320960,3.751040,4.359480],
     [6.868480,5.761160,4.899200,4.238440,3.739520,3.367880,3.093760,2.892200,2.743040,2.630920,2.545280,2.480360,2.435200,2.413640,2.424320,2.480680,2.600960,2.808200,3.130240,3.599720,4.254080],
     [5.868680,4.890720,4.141840,3.579200,3.164760,2.865280,2.652320,2.502240,2.396200,2.320160,2.264880,2.225920,2.203640,2.203200,2.234560,2.312480,2.456520,2.691040,3.045200,3.552960,4.253080],
     [5.103680,4.238240,3.586560,3.107120,2.763200,2.522880,2.359040,2.249360,2.176320,2.127200,2.094080,2.073840,2.068160,2.083520,2.131200,2.227280,2.392640,2.652960,3.038720,3.585200,4.332480],
     [4.525000,3.756800,3.188000,2.778400,2.492600,2.300000,2.174800,2.096000,2.047400,2.017600,2.000000,1.992800,1.999000,2.026400,2.087600,2.200000,2.385800,2.672000,3.090400,3.677600,4.475000],
     [4.090880,3.406200,2.907520,2.555960,2.317440,2.162680,2.067200,2.011320,1.980160,1.963640,1.956480,1.958200,1.973120,2.010360,2.083840,2.212280,2.419200,2.732920,3.186560,3.818040,4.670080],
     [3.766280,3.152960,2.713200,2.409440,2.208920,2.083680,2.010560,1.971200,1.952040,1.944320,1.944080,1.952160,1.974200,2.020640,2.106720,2.252480,2.482760,2.827200,3.320240,4.001120,4.913880],
     [3.522880,2.970320,2.579840,2.315200,2.144960,2.042480,1.985920,1.958240,1.947200,1.945360,1.950080,1.963520,1.992640,2.049200,2.149760,2.315680,2.573120,2.953040,3.491200,4.228160,5.209280],
     [3.339080,2.838240,2.488960,2.256320,2.110200,2.025280,1.981040,1.961760,1.956520,1.959200,1.968480,1.987840,2.025560,2.094720,2.213200,2.403680,2.693640,3.115360,3.705920,4.507200,5.565880],
     [3.200000,2.743400,2.428800,2.222600,2.096000,2.025000,1.990400,1.977800,1.977600,1.985000,2.000000,2.027400,2.076800,2.162600,2.304000,2.525000,2.854400,3.325800,3.977600,4.853000,6.000000],
     [3.097480,2.679200,2.394320,2.210560,2.100440,2.041280,2.015200,2.009120,2.014760,2.028640,2.052080,2.091200,2.156920,2.264960,2.435840,2.694880,3.072200,3.602720,4.326160,5.287040,6.534680],
     [3.030080,2.645760,2.387200,2.223440,2.128320,2.080480,2.063360,2.065200,2.079040,2.102720,2.138880,2.194960,2.283200,2.420640,2.629120,2.935280,3.370560,3.971200,4.778240,5.837520,7.199680],
     [3.003080,2.649920,2.415840,2.271200,2.191160,2.155680,2.149520,2.162240,2.188200,2.226560,2.281280,2.361120,2.479640,2.655200,2.910960,3.274880,3.779720,4.463040,5.367200,6.539360,8.031480],
     [3.028480,2.705240,2.495360,2.370520,2.307200,2.286680,2.295040,2.323160,2.366720,2.426200,2.506880,2.618840,2.776960,3.000920,3.315200,3.749080,4.336640,5.116760,6.133120,7.434200,9.073280],
     [3.125000,2.832000,2.647600,2.544800,2.501400,2.500000,2.528000,2.577600,2.645800,2.734400,2.850000,3.004000,3.212600,3.496800,3.882400,4.400000,5.085000,5.977600,7.122800,8.570400,10.375000],
     [3.318080,3.057200,2.901120,2.824160,2.805440,2.828880,2.883200,2.961920,3.063360,3.190640,3.351680,3.559200,3.830720,4.188560,4.659840,5.276480,6.075200,7.097520,8.389760,10.003040,11.993280],
     [3.639880,3.414560,3.291200,3.245440,3.257720,3.313280,3.402160,3.519200,3.664040,3.841120,4.059680,4.333760,4.682200,5.128640,5.701520,6.434080,7.364360,8.535200,9.994240,11.793920,13.991480],
     [4.129280,3.944520,3.859840,3.852200,3.903360,3.999880,4.133120,4.299240,4.499200,4.738760,5.028480,5.383720,5.824640,6.376200,7.068160,7.935080,9.016320,10.356040,12.003200,14.011560,16.439680],
     [4.831880,4.694240,4.655760,4.694720,4.794200,4.942080,5.131040,5.358560,5.626920,5.943200,6.319280,6.771840,7.322360,7.997120,8.827200,9.848480,11.101640,12.632160,14.490320,16.731200,19.4146800],
     [5.800000,5.717600,5.734400,5.830000,5.988800,6.200000,6.457600,6.760400,7.112000,7.520800,8.000000,8.567600,9.246400,10.064000,11.052800,12.250000,13.697600,15.442400,17.536000,20.034800,23.000000])

for j = enumerate(s)
    for i = enumerate(r)
        @test polyval(a, [j[2] i[2]])≈[values[j[1]][i[1]]]
    end
end

## Scale

s = 2.*p

for j = 1:s.o
    @test s.c[j] == 2*p.c[j]
end

scale!(p, 2);

for j = 1:s.o
    @test s.c[j] == p.c[j]
end

## differentiate a polynomial
m = 2
o = 4
c = [2.0, 3.0, 4.0, 5.0]
e = [1, 10, 12, 32]

dif = [2, 1]

#Hermetic.polynomial_print(m, o, c, e)
out = Hermetic.polynomial_dif(m, o, c, e, dif)

@test out == (1,[120.0],[12])

##### Integrate

p = ProductPoly(2, 4)
setcoef!(p, [1, .1, .2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1, 1.2, 1.3, 1.4])

@test integrate(p) == 10.2
@test Hermetic.integrate_polynomial(p.m, p.o, p.c, p.e) == 10.2

@test Hermetic.integrate_polynomial_times_xn(p.m, p.o, p.c, p.e, 1.0) == [3.6, 2.7]
@test Hermetic.integrate_polynomial_times_xn(p.m, p.o, p.c, p.e, 2.0) == [30.4, 25.2]
@test Hermetic.integrate_polynomial_times_xn(p.m, p.o, p.c, p.e, 3.0)≈[16.2, 11.7]
