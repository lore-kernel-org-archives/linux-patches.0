Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDC233AD85
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302749; cv=none; b=Ydw8If5VTqrmVC1hPZ5ROH+UvjOl/a7f5zHJL6WmKysyfRyho3sN9qDE6EFzsC2H6JUd9pWfuO42XlnwRxMeX3G/akn72UFEfioiorwXVK8o7AMEA/per39UQu0oo42U28w4mh7aBvdCqpOdiTNmHftEP9gZg68auzhkExz5YJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302749; c=relaxed/simple;
	bh=WVcsJsEkOlSWs5Vtw380uILTu8y02yzpj3kAuCkGFMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkDgb+gsmqWa8an2GRw7STOh1ScyA9mgp2a+RFqXd449p0gFsc/9V89zjse4fJwqOD3IvEOKFhl3u9scZXn61qrixX5SUq01oTtqCeCESkTPjcXeJkUobfq6w/4zJoaubHO9AD9OFJ3aw1hE3No9LyOD7AjuWtAOTQYJr8tOdIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uzkUyIbZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uzkUyIbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D94AC19425;
	Sat, 28 Feb 2026 18:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302749;
	bh=WVcsJsEkOlSWs5Vtw380uILTu8y02yzpj3kAuCkGFMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzkUyIbZaRDbMMHfgQBiBt89yRdcjXDT5fR7wTQojDpSUFde7ZAJtiV+uXA5fK8nm
	 +aoq4kRVjdZK474J+FzFE8B/jl8O0KPXUaJj3ImqmoLB8sjZJIJDOHv96QlHFyQn0u
	 WES1h1olxhQtXilT03J+U74YIfTAWJGhUEFKbk7NYzUvYhe89FJFJQfbukU9AGJtyn
	 rLyzxLEBDdLESiqr4MD2eIK2Nwd1UpnbBUKBUhJpfCoZkxgKuEkiwAGbcJLMKTx3PN
	 794d56kWysAdSyPOEHmCH2Yldaf53nkewM5AvcgF/PiiM04E0lEg0nheg/ELnAwPbA
	 YSlzmvLyhK08w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/147] clk: qcom: dispcc-sdm845: convert to parent data
Date: Sat, 28 Feb 2026 13:17:05 -0500
Message-ID: <20260228181736.1605592-117-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 7acd22512907c3afe07cfd759d47a5f8eb8fb04f ]

Convert the clock driver to specify parent data rather than parent
names, to actually bind using 'clock-names' specified in the DTS rather
than global clock names.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20210405224743.590029-12-dmitry.baryshkov@linaro.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: a1d63493634e ("clk: qcom: dispcc-sdm845: Enable parents for pixel clocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sdm845.c | 216 ++++++++++++++++---------------
 1 file changed, 109 insertions(+), 107 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sdm845.c b/drivers/clk/qcom/dispcc-sdm845.c
index 8cd8174ac9aa7..a71e103553bbb 100644
--- a/drivers/clk/qcom/dispcc-sdm845.c
+++ b/drivers/clk/qcom/dispcc-sdm845.c
@@ -33,6 +33,21 @@ enum {
 	P_DP_PHY_PLL_VCO_DIV_CLK,
 };
 
+static struct clk_alpha_pll disp_cc_pll0 = {
+	.offset = 0x0,
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
+	.clkr = {
+		.hw.init = &(struct clk_init_data){
+			.name = "disp_cc_pll0",
+			.parent_data = &(const struct clk_parent_data){
+				.fw_name = "bi_tcxo", .name = "bi_tcxo",
+			},
+			.num_parents = 1,
+			.ops = &clk_alpha_pll_fabia_ops,
+		},
+	},
+};
+
 static const struct parent_map disp_cc_parent_map_0[] = {
 	{ P_BI_TCXO, 0 },
 	{ P_DSI0_PHY_PLL_OUT_BYTECLK, 1 },
@@ -40,11 +55,11 @@ static const struct parent_map disp_cc_parent_map_0[] = {
 	{ P_CORE_BI_PLL_TEST_SE, 7 },
 };
 
-static const char * const disp_cc_parent_names_0[] = {
-	"bi_tcxo",
-	"dsi0_phy_pll_out_byteclk",
-	"dsi1_phy_pll_out_byteclk",
-	"core_bi_pll_test_se",
+static const struct clk_parent_data disp_cc_parent_data_0[] = {
+	{ .fw_name = "bi_tcxo", .name = "bi_tcxo" },
+	{ .fw_name = "dsi0_phy_pll_out_byteclk", .name = "dsi0_phy_pll_out_byteclk" },
+	{ .fw_name = "dsi1_phy_pll_out_byteclk", .name = "dsi1_phy_pll_out_byteclk" },
+	{ .fw_name = "core_bi_pll_test_se", .name = "core_bi_pll_test_se" },
 };
 
 static const struct parent_map disp_cc_parent_map_1[] = {
@@ -54,11 +69,11 @@ static const struct parent_map disp_cc_parent_map_1[] = {
 	{ P_CORE_BI_PLL_TEST_SE, 7 },
 };
 
-static const char * const disp_cc_parent_names_1[] = {
-	"bi_tcxo",
-	"dp_link_clk_divsel_ten",
-	"dp_vco_divided_clk_src_mux",
-	"core_bi_pll_test_se",
+static const struct clk_parent_data disp_cc_parent_data_1[] = {
+	{ .fw_name = "bi_tcxo", .name = "bi_tcxo" },
+	{ .fw_name = "dp_link_clk_divsel_ten", .name = "dp_link_clk_divsel_ten" },
+	{ .fw_name = "dp_vco_divided_clk_src_mux", .name = "dp_vco_divided_clk_src_mux" },
+	{ .fw_name = "core_bi_pll_test_se", .name = "core_bi_pll_test_se" },
 };
 
 static const struct parent_map disp_cc_parent_map_2[] = {
@@ -66,9 +81,9 @@ static const struct parent_map disp_cc_parent_map_2[] = {
 	{ P_CORE_BI_PLL_TEST_SE, 7 },
 };
 
-static const char * const disp_cc_parent_names_2[] = {
-	"bi_tcxo",
-	"core_bi_pll_test_se",
+static const struct clk_parent_data disp_cc_parent_data_2[] = {
+	{ .fw_name = "bi_tcxo", .name = "bi_tcxo" },
+	{ .fw_name = "core_bi_pll_test_se", .name = "core_bi_pll_test_se" },
 };
 
 static const struct parent_map disp_cc_parent_map_3[] = {
@@ -79,12 +94,12 @@ static const struct parent_map disp_cc_parent_map_3[] = {
 	{ P_CORE_BI_PLL_TEST_SE, 7 },
 };
 
-static const char * const disp_cc_parent_names_3[] = {
-	"bi_tcxo",
-	"disp_cc_pll0",
-	"gcc_disp_gpll0_clk_src",
-	"gcc_disp_gpll0_div_clk_src",
-	"core_bi_pll_test_se",
+static const struct clk_parent_data disp_cc_parent_data_3[] = {
+	{ .fw_name = "bi_tcxo", .name = "bi_tcxo" },
+	{ .hw = &disp_cc_pll0.clkr.hw },
+	{ .fw_name = "gcc_disp_gpll0_clk_src", .name = "gcc_disp_gpll0_clk_src" },
+	{ .fw_name = "gcc_disp_gpll0_div_clk_src", .name = "gcc_disp_gpll0_div_clk_src" },
+	{ .fw_name = "core_bi_pll_test_se", .name = "core_bi_pll_test_se" },
 };
 
 static const struct parent_map disp_cc_parent_map_4[] = {
@@ -94,24 +109,11 @@ static const struct parent_map disp_cc_parent_map_4[] = {
 	{ P_CORE_BI_PLL_TEST_SE, 7 },
 };
 
-static const char * const disp_cc_parent_names_4[] = {
-	"bi_tcxo",
-	"dsi0_phy_pll_out_dsiclk",
-	"dsi1_phy_pll_out_dsiclk",
-	"core_bi_pll_test_se",
-};
-
-static struct clk_alpha_pll disp_cc_pll0 = {
-	.offset = 0x0,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_FABIA],
-	.clkr = {
-		.hw.init = &(struct clk_init_data){
-			.name = "disp_cc_pll0",
-			.parent_names = (const char *[]){ "bi_tcxo" },
-			.num_parents = 1,
-			.ops = &clk_alpha_pll_fabia_ops,
-		},
-	},
+static const struct clk_parent_data disp_cc_parent_data_4[] = {
+	{ .fw_name = "bi_tcxo", .name = "bi_tcxo" },
+	{ .fw_name = "dsi0_phy_pll_out_dsiclk", .name = "dsi0_phy_pll_out_dsiclk" },
+	{ .fw_name = "dsi1_phy_pll_out_dsiclk", .name = "dsi1_phy_pll_out_dsiclk" },
+	{ .fw_name = "core_bi_pll_test_se", .name = "core_bi_pll_test_se" },
 };
 
 /* Return the HW recalc rate for idle use case */
@@ -122,8 +124,8 @@ static struct clk_rcg2 disp_cc_mdss_byte0_clk_src = {
 	.parent_map = disp_cc_parent_map_0,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "disp_cc_mdss_byte0_clk_src",
-		.parent_names = disp_cc_parent_names_0,
-		.num_parents = 4,
+		.parent_data = disp_cc_parent_data_0,
+		.num_parents = ARRAY_SIZE(disp_cc_parent_data_0),
 		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_byte2_ops,
 	},
@@ -137,8 +139,8 @@ static struct clk_rcg2 disp_cc_mdss_byte1_clk_src = {
 	.parent_map = disp_cc_parent_map_0,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "disp_cc_mdss_byte1_clk_src",
-		.parent_names = disp_cc_parent_names_0,
-		.num_parents = 4,
+		.parent_data = disp_cc_parent_data_0,
+		.num_parents = ARRAY_SIZE(disp_cc_parent_data_0),
 		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_byte2_ops,
 	},
@@ -157,8 +159,8 @@ static struct clk_rcg2 disp_cc_mdss_dp_aux_clk_src = {
 	.freq_tbl = ftbl_disp_cc_mdss_dp_aux_clk_src,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "disp_cc_mdss_dp_aux_clk_src",
-		.parent_names = disp_cc_parent_names_2,
-		.num_parents = 2,
+		.parent_data = disp_cc_parent_data_2,
+		.num_parents = ARRAY_SIZE(disp_cc_parent_data_2),
 		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_rcg2_ops,
 	},
@@ -171,8 +173,8 @@ static struct clk_rcg2 disp_cc_mdss_dp_crypto_clk_src = {
 	.parent_map = disp_cc_parent_map_1,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "disp_cc_mdss_dp_crypto_clk_src",
-		.parent_names = disp_cc_parent_names_1,
-		.num_parents = 4,
+		.parent_data = disp_cc_parent_data_1,
+		.num_parents = ARRAY_SIZE(disp_cc_parent_data_1),
 		.ops = &clk_byte2_ops,
 	},
 };
@@ -184,8 +186,8 @@ static struct clk_rcg2 disp_cc_mdss_dp_link_clk_src = {
 	.parent_map = disp_cc_parent_map_1,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "disp_cc_mdss_dp_link_clk_src",
-		.parent_names = disp_cc_parent_names_1,
-		.num_parents = 4,
+		.parent_data = disp_cc_parent_data_1,
+		.num_parents = ARRAY_SIZE(disp_cc_parent_data_1),
 		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_byte2_ops,
 	},
@@ -198,8 +200,8 @@ static struct clk_rcg2 disp_cc_mdss_dp_pixel1_clk_src = {
 	.parent_map = disp_cc_parent_map_1,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "disp_cc_mdss_dp_pixel1_clk_src",
-		.parent_names = disp_cc_parent_names_1,
-		.num_parents = 4,
+		.parent_data = disp_cc_parent_data_1,
+		.num_parents = ARRAY_SIZE(disp_cc_parent_data_1),
 		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_dp_ops,
 	},
@@ -212,8 +214,8 @@ static struct clk_rcg2 disp_cc_mdss_dp_pixel_clk_src = {
 	.parent_map = disp_cc_parent_map_1,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "disp_cc_mdss_dp_pixel_clk_src",
-		.parent_names = disp_cc_parent_names_1,
-		.num_parents = 4,
+		.parent_data = disp_cc_parent_data_1,
+		.num_parents = ARRAY_SIZE(disp_cc_parent_data_1),
 		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_dp_ops,
 	},
@@ -232,8 +234,8 @@ static struct clk_rcg2 disp_cc_mdss_esc0_clk_src = {
 	.freq_tbl = ftbl_disp_cc_mdss_esc0_clk_src,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "disp_cc_mdss_esc0_clk_src",
-		.parent_names = disp_cc_parent_names_0,
-		.num_parents = 4,
+		.parent_data = disp_cc_parent_data_0,
+		.num_parents = ARRAY_SIZE(disp_cc_parent_data_0),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -246,8 +248,8 @@ static struct clk_rcg2 disp_cc_mdss_esc1_clk_src = {
 	.freq_tbl = ftbl_disp_cc_mdss_esc0_clk_src,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "disp_cc_mdss_esc1_clk_src",
-		.parent_names = disp_cc_parent_names_0,
-		.num_parents = 4,
+		.parent_data = disp_cc_parent_data_0,
+		.num_parents = ARRAY_SIZE(disp_cc_parent_data_0),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -273,8 +275,8 @@ static struct clk_rcg2 disp_cc_mdss_mdp_clk_src = {
 	.freq_tbl = ftbl_disp_cc_mdss_mdp_clk_src,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "disp_cc_mdss_mdp_clk_src",
-		.parent_names = disp_cc_parent_names_3,
-		.num_parents = 5,
+		.parent_data = disp_cc_parent_data_3,
+		.num_parents = ARRAY_SIZE(disp_cc_parent_data_3),
 		.ops = &clk_rcg2_shared_ops,
 	},
 };
@@ -287,8 +289,8 @@ static struct clk_rcg2 disp_cc_mdss_pclk0_clk_src = {
 	.parent_map = disp_cc_parent_map_4,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "disp_cc_mdss_pclk0_clk_src",
-		.parent_names = disp_cc_parent_names_4,
-		.num_parents = 4,
+		.parent_data = disp_cc_parent_data_4,
+		.num_parents = ARRAY_SIZE(disp_cc_parent_data_4),
 		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_pixel_ops,
 	},
@@ -302,8 +304,8 @@ static struct clk_rcg2 disp_cc_mdss_pclk1_clk_src = {
 	.parent_map = disp_cc_parent_map_4,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "disp_cc_mdss_pclk1_clk_src",
-		.parent_names = disp_cc_parent_names_4,
-		.num_parents = 4,
+		.parent_data = disp_cc_parent_data_4,
+		.num_parents = ARRAY_SIZE(disp_cc_parent_data_4),
 		.flags = CLK_SET_RATE_PARENT,
 		.ops = &clk_pixel_ops,
 	},
@@ -326,8 +328,8 @@ static struct clk_rcg2 disp_cc_mdss_rot_clk_src = {
 	.freq_tbl = ftbl_disp_cc_mdss_rot_clk_src,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "disp_cc_mdss_rot_clk_src",
-		.parent_names = disp_cc_parent_names_3,
-		.num_parents = 5,
+		.parent_data = disp_cc_parent_data_3,
+		.num_parents = ARRAY_SIZE(disp_cc_parent_data_3),
 		.ops = &clk_rcg2_shared_ops,
 	},
 };
@@ -340,8 +342,8 @@ static struct clk_rcg2 disp_cc_mdss_vsync_clk_src = {
 	.freq_tbl = ftbl_disp_cc_mdss_esc0_clk_src,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "disp_cc_mdss_vsync_clk_src",
-		.parent_names = disp_cc_parent_names_2,
-		.num_parents = 2,
+		.parent_data = disp_cc_parent_data_2,
+		.num_parents = ARRAY_SIZE(disp_cc_parent_data_2),
 		.ops = &clk_rcg2_ops,
 	},
 };
@@ -381,8 +383,8 @@ static struct clk_branch disp_cc_mdss_byte0_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_byte0_clk",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_byte0_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_byte0_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -399,8 +401,8 @@ static struct clk_regmap_div disp_cc_mdss_byte0_div_clk_src = {
 	.clkr = {
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_byte0_div_clk_src",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_byte0_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_byte0_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.ops = &clk_regmap_div_ops,
@@ -417,8 +419,8 @@ static struct clk_branch disp_cc_mdss_byte0_intf_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_byte0_intf_clk",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_byte0_div_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_byte0_div_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -436,8 +438,8 @@ static struct clk_branch disp_cc_mdss_byte1_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_byte1_clk",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_byte1_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_byte1_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -454,8 +456,8 @@ static struct clk_regmap_div disp_cc_mdss_byte1_div_clk_src = {
 	.clkr = {
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_byte1_div_clk_src",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_byte1_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_byte1_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.ops = &clk_regmap_div_ops,
@@ -472,8 +474,8 @@ static struct clk_branch disp_cc_mdss_byte1_intf_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_byte1_intf_clk",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_byte1_div_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_byte1_div_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -490,8 +492,8 @@ static struct clk_branch disp_cc_mdss_dp_aux_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_dp_aux_clk",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_dp_aux_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_dp_aux_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -508,8 +510,8 @@ static struct clk_branch disp_cc_mdss_dp_crypto_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_dp_crypto_clk",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_dp_crypto_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_dp_crypto_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -526,8 +528,8 @@ static struct clk_branch disp_cc_mdss_dp_link_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_dp_link_clk",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_dp_link_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_dp_link_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -545,8 +547,8 @@ static struct clk_branch disp_cc_mdss_dp_link_intf_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_dp_link_intf_clk",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_dp_link_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_dp_link_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.ops = &clk_branch2_ops,
@@ -562,8 +564,8 @@ static struct clk_branch disp_cc_mdss_dp_pixel1_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_dp_pixel1_clk",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_dp_pixel1_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_dp_pixel1_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -580,8 +582,8 @@ static struct clk_branch disp_cc_mdss_dp_pixel_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_dp_pixel_clk",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_dp_pixel_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_dp_pixel_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -598,8 +600,8 @@ static struct clk_branch disp_cc_mdss_esc0_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_esc0_clk",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_esc0_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_esc0_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -616,8 +618,8 @@ static struct clk_branch disp_cc_mdss_esc1_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_esc1_clk",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_esc1_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_esc1_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -634,8 +636,8 @@ static struct clk_branch disp_cc_mdss_mdp_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_mdp_clk",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_mdp_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_mdp_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -652,8 +654,8 @@ static struct clk_branch disp_cc_mdss_mdp_lut_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_mdp_lut_clk",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_mdp_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_mdp_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.ops = &clk_branch2_ops,
@@ -670,8 +672,8 @@ static struct clk_branch disp_cc_mdss_pclk0_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_pclk0_clk",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_pclk0_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_pclk0_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -689,8 +691,8 @@ static struct clk_branch disp_cc_mdss_pclk1_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_pclk1_clk",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_pclk1_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_pclk1_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -707,8 +709,8 @@ static struct clk_branch disp_cc_mdss_rot_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_rot_clk",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_rot_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_rot_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -738,8 +740,8 @@ static struct clk_branch disp_cc_mdss_rscc_vsync_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_rscc_vsync_clk",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_vsync_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_vsync_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
@@ -756,8 +758,8 @@ static struct clk_branch disp_cc_mdss_vsync_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "disp_cc_mdss_vsync_clk",
-			.parent_names = (const char *[]){
-				"disp_cc_mdss_vsync_clk_src",
+			.parent_hws = (const struct clk_hw*[]){
+				&disp_cc_mdss_vsync_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
 			.flags = CLK_SET_RATE_PARENT,
-- 
2.51.0

