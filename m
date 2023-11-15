Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DB43C48C
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0MdsBP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67429C433C7;
	Wed, 15 Nov 2023 19:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077233;
	bh=up7fZ31QCWbqgxJNJ0+kn6TS89NMpw0ZVNX1iSBaqro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0MdsBP5qYXkC7kfM9IfH0afQ7aTQ0rafxYKTMNSy9TXAUCzM4RRH47EUFy1ku4tM
	 n7zLeiL8CtkKPjVpxfiWjSuNCBIv1ix2GZvXMtkXERhSu9Rv+CWvZxCwd/lUQdXn8i
	 ZghoPW50ImmRkPKri6QwEOv/jA70qUbanQJ7QGRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/603] clk: qcom: gcc-msm8996: Remove RPM bus clocks
Date: Wed, 15 Nov 2023 14:11:46 -0500
Message-ID: <20231115191624.328523833@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 4afda5f6bcdf673ef2556fcfa458daf3a5a648d8 ]

The GCC driver contains clocks that are owned (meaning configured and
scaled) by the RPM core.

Remove them from Linux to stop interjecting the RPM's logic.

Fixes: b1e010c0730a ("clk: qcom: Add MSM8996 Global Clock Control (GCC) driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230830-topic-rpmbusclocks8996gcc-v1-1-9e99bedcdc3b@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-msm8996.c | 237 +--------------------------------
 1 file changed, 5 insertions(+), 232 deletions(-)

diff --git a/drivers/clk/qcom/gcc-msm8996.c b/drivers/clk/qcom/gcc-msm8996.c
index 14dcc3f036683..e7b03a17514a5 100644
--- a/drivers/clk/qcom/gcc-msm8996.c
+++ b/drivers/clk/qcom/gcc-msm8996.c
@@ -244,71 +244,6 @@ static const struct clk_parent_data gcc_xo_gpll0_gpll4_gpll0_early_div[] = {
 	{ .hw = &gpll0_early_div.hw }
 };
 
-static const struct freq_tbl ftbl_system_noc_clk_src[] = {
-	F(19200000, P_XO, 1, 0, 0),
-	F(50000000, P_GPLL0_EARLY_DIV, 6, 0, 0),
-	F(100000000, P_GPLL0, 6, 0, 0),
-	F(150000000, P_GPLL0, 4, 0, 0),
-	F(200000000, P_GPLL0, 3, 0, 0),
-	F(240000000, P_GPLL0, 2.5, 0, 0),
-	{ }
-};
-
-static struct clk_rcg2 system_noc_clk_src = {
-	.cmd_rcgr = 0x0401c,
-	.hid_width = 5,
-	.parent_map = gcc_xo_gpll0_gpll0_early_div_map,
-	.freq_tbl = ftbl_system_noc_clk_src,
-	.clkr.hw.init = &(struct clk_init_data){
-		.name = "system_noc_clk_src",
-		.parent_data = gcc_xo_gpll0_gpll0_early_div,
-		.num_parents = ARRAY_SIZE(gcc_xo_gpll0_gpll0_early_div),
-		.ops = &clk_rcg2_ops,
-	},
-};
-
-static const struct freq_tbl ftbl_config_noc_clk_src[] = {
-	F(19200000, P_XO, 1, 0, 0),
-	F(37500000, P_GPLL0, 16, 0, 0),
-	F(75000000, P_GPLL0, 8, 0, 0),
-	{ }
-};
-
-static struct clk_rcg2 config_noc_clk_src = {
-	.cmd_rcgr = 0x0500c,
-	.hid_width = 5,
-	.parent_map = gcc_xo_gpll0_map,
-	.freq_tbl = ftbl_config_noc_clk_src,
-	.clkr.hw.init = &(struct clk_init_data){
-		.name = "config_noc_clk_src",
-		.parent_data = gcc_xo_gpll0,
-		.num_parents = ARRAY_SIZE(gcc_xo_gpll0),
-		.ops = &clk_rcg2_ops,
-	},
-};
-
-static const struct freq_tbl ftbl_periph_noc_clk_src[] = {
-	F(19200000, P_XO, 1, 0, 0),
-	F(37500000, P_GPLL0, 16, 0, 0),
-	F(50000000, P_GPLL0, 12, 0, 0),
-	F(75000000, P_GPLL0, 8, 0, 0),
-	F(100000000, P_GPLL0, 6, 0, 0),
-	{ }
-};
-
-static struct clk_rcg2 periph_noc_clk_src = {
-	.cmd_rcgr = 0x06014,
-	.hid_width = 5,
-	.parent_map = gcc_xo_gpll0_map,
-	.freq_tbl = ftbl_periph_noc_clk_src,
-	.clkr.hw.init = &(struct clk_init_data){
-		.name = "periph_noc_clk_src",
-		.parent_data = gcc_xo_gpll0,
-		.num_parents = ARRAY_SIZE(gcc_xo_gpll0),
-		.ops = &clk_rcg2_ops,
-	},
-};
-
 static const struct freq_tbl ftbl_usb30_master_clk_src[] = {
 	F(19200000, P_XO, 1, 0, 0),
 	F(120000000, P_GPLL0, 5, 0, 0),
@@ -1297,11 +1232,7 @@ static struct clk_branch gcc_mmss_noc_cfg_ahb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_mmss_noc_cfg_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&config_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT | CLK_IGNORE_UNUSED,
+			.flags = CLK_IGNORE_UNUSED,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1464,11 +1395,6 @@ static struct clk_branch gcc_usb_phy_cfg_ahb2phy_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_usb_phy_cfg_ahb2phy_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&periph_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1498,11 +1424,6 @@ static struct clk_branch gcc_sdcc1_ahb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_sdcc1_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&periph_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1549,11 +1470,6 @@ static struct clk_branch gcc_sdcc2_ahb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_sdcc2_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&periph_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1583,11 +1499,6 @@ static struct clk_branch gcc_sdcc3_ahb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_sdcc3_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&periph_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1617,11 +1528,6 @@ static struct clk_branch gcc_sdcc4_ahb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_sdcc4_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&periph_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1635,11 +1541,6 @@ static struct clk_branch gcc_blsp1_ahb_clk = {
 		.enable_mask = BIT(17),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_blsp1_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&periph_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1977,11 +1878,6 @@ static struct clk_branch gcc_blsp2_ahb_clk = {
 		.enable_mask = BIT(15),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_blsp2_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&periph_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2318,11 +2214,6 @@ static struct clk_branch gcc_pdm_ahb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pdm_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&periph_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2353,11 +2244,6 @@ static struct clk_branch gcc_prng_ahb_clk = {
 		.enable_mask = BIT(13),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_prng_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&config_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2370,11 +2256,6 @@ static struct clk_branch gcc_tsif_ahb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_tsif_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&periph_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2422,11 +2303,6 @@ static struct clk_branch gcc_boot_rom_ahb_clk = {
 		.enable_mask = BIT(10),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_boot_rom_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&config_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2520,11 +2396,6 @@ static struct clk_branch gcc_pcie_0_slv_axi_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pcie_0_slv_axi_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&system_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2537,11 +2408,6 @@ static struct clk_branch gcc_pcie_0_mstr_axi_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pcie_0_mstr_axi_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&system_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2554,11 +2420,6 @@ static struct clk_branch gcc_pcie_0_cfg_ahb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pcie_0_cfg_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&config_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2606,11 +2467,6 @@ static struct clk_branch gcc_pcie_1_slv_axi_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pcie_1_slv_axi_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&system_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2623,11 +2479,6 @@ static struct clk_branch gcc_pcie_1_mstr_axi_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pcie_1_mstr_axi_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&system_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2640,11 +2491,6 @@ static struct clk_branch gcc_pcie_1_cfg_ahb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pcie_1_cfg_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&config_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2692,11 +2538,6 @@ static struct clk_branch gcc_pcie_2_slv_axi_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pcie_2_slv_axi_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&system_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2709,11 +2550,6 @@ static struct clk_branch gcc_pcie_2_mstr_axi_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pcie_2_mstr_axi_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&system_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2726,11 +2562,6 @@ static struct clk_branch gcc_pcie_2_cfg_ahb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pcie_2_cfg_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&config_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2778,11 +2609,6 @@ static struct clk_branch gcc_pcie_phy_cfg_ahb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_pcie_phy_cfg_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&config_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -2829,11 +2655,6 @@ static struct clk_branch gcc_ufs_ahb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_ufs_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&config_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -3060,11 +2881,7 @@ static struct clk_branch gcc_aggre0_snoc_axi_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_aggre0_snoc_axi_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&system_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT | CLK_IS_CRITICAL,
+			.flags = CLK_IS_CRITICAL,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -3077,11 +2894,7 @@ static struct clk_branch gcc_aggre0_cnoc_ahb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_aggre0_cnoc_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&config_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT | CLK_IS_CRITICAL,
+			.flags = CLK_IS_CRITICAL,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -3094,11 +2907,7 @@ static struct clk_branch gcc_smmu_aggre0_axi_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_smmu_aggre0_axi_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&system_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT | CLK_IS_CRITICAL,
+			.flags = CLK_IS_CRITICAL,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -3111,11 +2920,7 @@ static struct clk_branch gcc_smmu_aggre0_ahb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_smmu_aggre0_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&config_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT | CLK_IS_CRITICAL,
+			.flags = CLK_IS_CRITICAL,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -3162,10 +2967,6 @@ static struct clk_branch gcc_dcc_ahb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_dcc_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&config_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -3178,10 +2979,6 @@ static struct clk_branch gcc_aggre0_noc_mpu_cfg_ahb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_aggre0_noc_mpu_cfg_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&config_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -3194,11 +2991,6 @@ static struct clk_branch gcc_qspi_ahb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_qspi_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&periph_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
-			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -3347,10 +3139,6 @@ static struct clk_branch gcc_mss_cfg_ahb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_mss_cfg_ahb_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&config_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -3363,10 +3151,6 @@ static struct clk_branch gcc_mss_mnoc_bimc_axi_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_mss_mnoc_bimc_axi_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&system_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -3379,10 +3163,6 @@ static struct clk_branch gcc_mss_snoc_axi_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_mss_snoc_axi_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&system_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -3395,10 +3175,6 @@ static struct clk_branch gcc_mss_q6_bimc_axi_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "gcc_mss_q6_bimc_axi_clk",
-			.parent_hws = (const struct clk_hw*[]){
-				&system_noc_clk_src.clkr.hw,
-			},
-			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -3495,9 +3271,6 @@ static struct clk_regmap *gcc_msm8996_clocks[] = {
 	[GPLL0] = &gpll0.clkr,
 	[GPLL4_EARLY] = &gpll4_early.clkr,
 	[GPLL4] = &gpll4.clkr,
-	[SYSTEM_NOC_CLK_SRC] = &system_noc_clk_src.clkr,
-	[CONFIG_NOC_CLK_SRC] = &config_noc_clk_src.clkr,
-	[PERIPH_NOC_CLK_SRC] = &periph_noc_clk_src.clkr,
 	[USB30_MASTER_CLK_SRC] = &usb30_master_clk_src.clkr,
 	[USB30_MOCK_UTMI_CLK_SRC] = &usb30_mock_utmi_clk_src.clkr,
 	[USB3_PHY_AUX_CLK_SRC] = &usb3_phy_aux_clk_src.clkr,
-- 
2.42.0



