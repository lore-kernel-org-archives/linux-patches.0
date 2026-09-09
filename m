Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3C057D221;
	Wed,  9 Sep 2026 14:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963669; cv=none; b=XUScqYaZU1+oBNcF5PfJxoMIuOD4KFRTjxLQCtBcnw2dwmZWe0h1D968WABjfk3wBRSXAcmI3K7cCmmONpjHKbA1B4obp/4l++CdiRpZdsVWAZWp0AAhYt6n/FGgEeJsfaRPb5t91MiD2rfeN08WJK+tefolzwL1hjpIRcVmfqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963669; c=relaxed/simple;
	bh=L4vp3o9NBJFXrtkwoF7zeYqqOnPLGRJkg0JF0ssJDSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXaQlOkxZHc/EiYCpA4mFrDSkNMeqU/agGyd7uAyiJnZrlDjon09f9EWZD4/ae/Waz4TuizQHdsmqNHOqH/Q3wvtwl+6g2M+huemNGoauaY5qK/1/lwNV4gEs906jXcnlshh9amnca0mpEMT6swkqoI8lIqvceyhDrhZXVmx/zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jm7NsIbf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jm7NsIbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF811F00A3A;
	Wed,  9 Sep 2026 14:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963667;
	bh=WG3LRJATOvJqcn2wRtKwk6biHYF8a0DRlWw1qna/Q8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jm7NsIbf2WqOYWNbgNZOY/wzzlGKfab3QTkmdc8eYczrdNbQ8Xb18rgyLJzhWkxyT
	 13uYgeu7zH0gUUCEUXVT8GN3smRPeKxaCeNIbbYB3TMJdKI/smJ4Yl1wlanV0npRxn
	 6X9kQMiv243oD9fZg2K5rKPowZKHVxzId04cFV7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.18 156/583] clk: qcom: gcc-mdm9607: Drop incorrect BIMC PLL and related clocks
Date: Wed,  9 Sep 2026 15:37:21 +0200
Message-ID: <20260909134243.606359986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit e111ddda092ad961870a634e4c9263c10a3e8485 upstream.

The gcc-mdm9607 driver was originally based on gcc-msm8916, but a closer
match nowadays is gcc-msm8909. Looking at the differences between
gcc-mdm9607 and gcc-msm8909, there is quite some confusion around the
definitions for the BIMC PLL.

It turns out the BIMC PLL on MDM9607 is actually an Alpha PLL just like on
MSM8909. We can vote for it using BIT(2), which explains why BIT(3) was
used for GPLL2.

In practice, the BIMC PLL is exclusively controlled by the RPM firmware and
Linux should not touch it. So far, it was defined to model the full clock
hierarchy, but even in read-only mode with CLK_GET_RATE_NOCACHE this is
problematic since the RPM will silently change the clock parents without
notifying Linux about it. The clock framework reads the clock parent only
once during boot, so the resulting rates will still be often wrong.

Follow the example of more recent SoCs and drop the BIMC PLL and all
remaining related clocks to avoid reporting stale status data. This means
we cannot determine the rate of these clocks anymore. This is not a big
problem in practice, since these are NoC-related clocks that are
independently managed through the interconnect subsystem.

Cc: stable@vger.kernel.org
Fixes: 48b7253264ea ("clk: qcom: Add MDM9607 GCC driver")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260706-qcom-clk-mdm9607-fixes-v2-8-745565101869@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-mdm9607.c |  125 -----------------------------------------
 1 file changed, 1 insertion(+), 124 deletions(-)

--- a/drivers/clk/qcom/gcc-mdm9607.c
+++ b/drivers/clk/qcom/gcc-mdm9607.c
@@ -26,7 +26,6 @@
 
 enum {
 	P_XO,
-	P_BIMC,
 	P_GPLL0,
 	P_GPLL1,
 	P_GPLL2,
@@ -121,7 +120,7 @@ static struct clk_alpha_pll gpll2_early
 	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
 	.clkr = {
 		.enable_reg = 0x45000,
-		.enable_mask = BIT(3), /* Yeah, apparently it's not 2 */
+		.enable_mask = BIT(3), /* BIT(2) is used for BIMC PLL */
 		.hw.init = &(struct clk_init_data)
 		{
 			.name = "gpll2_early",
@@ -178,68 +177,6 @@ static struct clk_rcg2 apss_ahb_clk_src
 	},
 };
 
-static struct clk_pll bimc_pll = {
-	.l_reg = 0x23004,
-	.m_reg = 0x23008,
-	.n_reg = 0x2300c,
-	.config_reg = 0x23010,
-	.mode_reg = 0x23000,
-	.status_reg = 0x2301c,
-	.status_bit = 17,
-	.clkr.hw.init = &(struct clk_init_data){
-		.name = "bimc_pll",
-		.parent_data = &(const struct clk_parent_data){
-			.fw_name = "xo",
-		},
-		.num_parents = 1,
-		.ops = &clk_pll_ops,
-	},
-};
-
-static struct clk_regmap bimc_pll_vote = {
-	.enable_reg = 0x45000,
-	.enable_mask = BIT(3),
-	.hw.init = &(struct clk_init_data){
-		.name = "bimc_pll_vote",
-		.parent_hws = (const struct clk_hw *[]){ &bimc_pll.clkr.hw },
-		.num_parents = 1,
-		.ops = &clk_pll_vote_ops,
-	},
-};
-
-static const struct parent_map gcc_xo_gpll0_bimc_map[] = {
-	{ P_XO, 0 },
-	{ P_GPLL0, 1 },
-	{ P_BIMC, 2 },
-};
-
-static const struct clk_parent_data gcc_xo_gpll0_bimc[] = {
-	{ .fw_name = "xo" },
-	{ .hw = &gpll0.clkr.hw },
-	{ .hw = &bimc_pll_vote.hw },
-};
-
-static const struct freq_tbl ftbl_pcnoc_bfdcd_clk_src[] = {
-	F(19200000, P_XO, 1, 0, 0),
-	F(50000000, P_GPLL0, 16, 0, 0),
-	F(100000000, P_GPLL0, 8, 0, 0),
-	{ }
-};
-
-static struct clk_rcg2 pcnoc_bfdcd_clk_src = {
-	.cmd_rcgr = 0x27000,
-	.freq_tbl = ftbl_pcnoc_bfdcd_clk_src,
-	.hid_width = 5,
-	.parent_map = gcc_xo_gpll0_bimc_map,
-	.clkr.hw.init = &(struct clk_init_data){
-		.name = "pcnoc_bfdcd_clk_src",
-		.parent_data = gcc_xo_gpll0_bimc,
-		.num_parents = ARRAY_SIZE(gcc_xo_gpll0_bimc),
-		.ops = &clk_rcg2_ops,
-		.flags = CLK_IS_CRITICAL,
-	},
-};
-
 static const struct freq_tbl ftbl_gcc_blsp1_qup1_6_i2c_apps_clk[] = {
 	F(19200000, P_XO, 1, 0, 0),
 	F(50000000, P_GPLL0, 16, 0, 0),
@@ -735,8 +672,6 @@ static struct clk_branch gcc_blsp1_ahb_c
 		.enable_mask = BIT(10),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_blsp1_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &pcnoc_bfdcd_clk_src.clkr.hw },
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1038,8 +973,6 @@ static struct clk_branch gcc_boot_rom_ah
 		.enable_mask = BIT(7),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_boot_rom_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &pcnoc_bfdcd_clk_src.clkr.hw },
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1053,9 +986,6 @@ static struct clk_branch gcc_crypto_ahb_
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_crypto_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &pcnoc_bfdcd_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1069,9 +999,6 @@ static struct clk_branch gcc_crypto_axi_
 		.enable_mask = BIT(1),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_crypto_axi_clk",
-			.parent_hws = (const struct clk_hw *[]){ &pcnoc_bfdcd_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1145,9 +1072,6 @@ static struct clk_branch gcc_mss_cfg_ahb
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_mss_cfg_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &pcnoc_bfdcd_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1175,9 +1099,6 @@ static struct clk_branch gcc_pdm_ahb_clk
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pdm_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &pcnoc_bfdcd_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1191,9 +1112,6 @@ static struct clk_branch gcc_prng_ahb_cl
 		.enable_mask = BIT(8),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_prng_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &pcnoc_bfdcd_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1206,9 +1124,6 @@ static struct clk_branch gcc_sdcc1_ahb_c
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_sdcc1_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &pcnoc_bfdcd_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1236,9 +1151,6 @@ static struct clk_branch gcc_sdcc2_ahb_c
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_sdcc2_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &pcnoc_bfdcd_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1259,19 +1171,6 @@ static struct clk_branch gcc_sdcc2_apps_
 	},
 };
 
-static struct clk_rcg2 bimc_ddr_clk_src = {
-	.cmd_rcgr = 0x32004,
-	.hid_width = 5,
-	.parent_map = gcc_xo_gpll0_bimc_map,
-	.clkr.hw.init = &(struct clk_init_data){
-		.name = "bimc_ddr_clk_src",
-		.parent_data = gcc_xo_gpll0_bimc,
-		.num_parents = 3,
-		.ops = &clk_rcg2_ops,
-		.flags = CLK_GET_RATE_NOCACHE,
-	},
-};
-
 static struct clk_branch gcc_mss_q6_bimc_axi_clk = {
 	.halt_reg = 0x49004,
 	.clkr = {
@@ -1279,9 +1178,6 @@ static struct clk_branch gcc_mss_q6_bimc
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_mss_q6_bimc_axi_clk",
-			.parent_hws = (const struct clk_hw *[]){ &bimc_ddr_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1295,8 +1191,6 @@ static struct clk_branch gcc_apss_tcu_cl
 		.enable_mask = BIT(1),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_apss_tcu_clk",
-			.parent_hws = (const struct clk_hw *[]){ &bimc_ddr_clk_src.clkr.hw },
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1310,9 +1204,6 @@ static struct clk_branch gcc_smmu_cfg_cl
 		.enable_mask = BIT(12),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_smmu_cfg_clk",
-			.parent_hws = (const struct clk_hw *[]){ &pcnoc_bfdcd_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1360,9 +1251,6 @@ static struct clk_branch gcc_usb_hs_phy_
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_usb_hs_phy_cfg_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &pcnoc_bfdcd_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1375,9 +1263,6 @@ static struct clk_branch gcc_usb_hs_ahb_
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_usb_hs_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &pcnoc_bfdcd_clk_src.clkr.hw },
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1406,8 +1291,6 @@ static struct clk_branch gcc_apss_ahb_cl
 		.enable_mask = BIT(14),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_apss_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){ &pcnoc_bfdcd_clk_src.clkr.hw },
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1421,8 +1304,6 @@ static struct clk_branch gcc_apss_axi_cl
 		.enable_mask = BIT(13),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_apss_axi_clk",
-			.parent_hws = (const struct clk_hw *[]){ &pcnoc_bfdcd_clk_src.clkr.hw },
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1435,10 +1316,6 @@ static struct clk_regmap *gcc_mdm9607_cl
 	[GPLL1_VOTE] = &gpll1_vote,
 	[GPLL2] = &gpll2.clkr,
 	[GPLL2_EARLY] = &gpll2_early.clkr,
-	[BIMC_PLL] = &bimc_pll.clkr,
-	[BIMC_PLL_VOTE] = &bimc_pll_vote,
-	[BIMC_DDR_CLK_SRC] = &bimc_ddr_clk_src.clkr,
-	[PCNOC_BFDCD_CLK_SRC] = &pcnoc_bfdcd_clk_src.clkr,
 	[APSS_AHB_CLK_SRC] = &apss_ahb_clk_src.clkr,
 	[BLSP1_QUP1_I2C_APPS_CLK_SRC] = &blsp1_qup1_i2c_apps_clk_src.clkr,
 	[BLSP1_QUP1_SPI_APPS_CLK_SRC] = &blsp1_qup1_spi_apps_clk_src.clkr,


