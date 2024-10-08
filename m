Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEE81DEFE3;
	Tue,  8 Oct 2024 13:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393907; cv=none; b=VYRXufOTXU3/k5CtGtofedCNoh09zVSF6jdKD9ucJf4u6jv+mqq8ScLtcens9TjUzmITbaRWeqFqleQvAqkFm3gycliBfgQ1JbDQRXDA8IlsCz/VzvUO39PJLN6lB1zYcNf6ulgv++dbz9nd6GZhpE8KQWjCRMEA6InzLuU5SAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393907; c=relaxed/simple;
	bh=Uq6CmhkBhsWKaDveF76dwQtZXoeQMda+SlmHVjjHg+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HV0qDGkerIraJN5+A6MvMVW9z9rzcTHi8vhhEPn3C14oF4/nTMllLvBr2gNEFmLV3/2QSEjVLMQLUrdorgPFWf+D9xNfkofadJoKVRjeyL9+WLQogHdO6p3HQaOtcnBDRNV36RGF+F+f93EGp2hP6I1wL1PHXXM2q1Oa2ZuHr9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtvvXgRw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtvvXgRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAE5C4CECC;
	Tue,  8 Oct 2024 13:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393907;
	bh=Uq6CmhkBhsWKaDveF76dwQtZXoeQMda+SlmHVjjHg+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KtvvXgRw7jno2jzlJG3+nxgnGUhvBctRY+51sIN0f+SGbv3DWyxlvtzmuZZAVl3da
	 4qNVfwm3kA8WU7yzTybnl+teBLiLSyHlriu+4nyJUtbktuQdaFN7lHqU4pmiDofWom
	 1E5vVMJlNCiyht5UbXuiLpZUApfwCqTlxFOtzBd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 288/386] clk: qcom: gcc-sm8150: De-register gcc_cpuss_ahb_clk_src
Date: Tue,  8 Oct 2024 14:08:53 +0200
Message-ID: <20241008115640.719619114@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>

commit bab0c7a0bc586e736b7cd2aac8e6391709a70ef2 upstream.

The branch clocks of gcc_cpuss_ahb_clk_src are marked critical
and hence these clocks vote on XO blocking the suspend.
De-register these clocks and its source as there is no rate
setting happening on them.

Fixes: 4433594bbe5d ("clk: qcom: gcc: Add global clock controller driver for SC8180x")
Cc: stable@vger.kernel.org
Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Link: https://lore.kernel.org/r/20240812-gcc-sc8180x-fixes-v2-5-8b3eaa5fb856@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-sc8180x.c |   63 -----------------------------------------
 1 file changed, 63 deletions(-)

--- a/drivers/clk/qcom/gcc-sc8180x.c
+++ b/drivers/clk/qcom/gcc-sc8180x.c
@@ -260,28 +260,6 @@ static const struct clk_parent_data gcc_
 	{ .hw = &gpll0_out_even.clkr.hw },
 };
 
-static const struct freq_tbl ftbl_gcc_cpuss_ahb_clk_src[] = {
-	F(19200000, P_BI_TCXO, 1, 0, 0),
-	F(50000000, P_GPLL0_OUT_MAIN, 12, 0, 0),
-	F(100000000, P_GPLL0_OUT_MAIN, 6, 0, 0),
-	{ }
-};
-
-static struct clk_rcg2 gcc_cpuss_ahb_clk_src = {
-	.cmd_rcgr = 0x48014,
-	.mnd_width = 0,
-	.hid_width = 5,
-	.parent_map = gcc_parent_map_0,
-	.freq_tbl = ftbl_gcc_cpuss_ahb_clk_src,
-	.clkr.hw.init = &(struct clk_init_data){
-		.name = "gcc_cpuss_ahb_clk_src",
-		.parent_data = gcc_parents_0,
-		.num_parents = ARRAY_SIZE(gcc_parents_0),
-		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_ops,
-	},
-};
-
 static const struct freq_tbl ftbl_gcc_emac_ptp_clk_src[] = {
 	F(19200000, P_BI_TCXO, 1, 0, 0),
 	F(50000000, P_GPLL0_OUT_EVEN, 6, 0, 0),
@@ -1599,25 +1577,6 @@ static struct clk_branch gcc_cfg_noc_usb
 	},
 };
 
-/* For CPUSS functionality the AHB clock needs to be left enabled */
-static struct clk_branch gcc_cpuss_ahb_clk = {
-	.halt_reg = 0x48000,
-	.halt_check = BRANCH_HALT_VOTED,
-	.clkr = {
-		.enable_reg = 0x52004,
-		.enable_mask = BIT(21),
-		.hw.init = &(struct clk_init_data){
-			.name = "gcc_cpuss_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){
-				      &gcc_cpuss_ahb_clk_src.clkr.hw
-			},
-			.num_parents = 1,
-			.flags = CLK_IS_CRITICAL | CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
 static struct clk_branch gcc_cpuss_rbcpr_clk = {
 	.halt_reg = 0x48008,
 	.halt_check = BRANCH_HALT,
@@ -3150,25 +3109,6 @@ static struct clk_branch gcc_sdcc4_apps_
 	},
 };
 
-/* For CPUSS functionality the SYS NOC clock needs to be left enabled */
-static struct clk_branch gcc_sys_noc_cpuss_ahb_clk = {
-	.halt_reg = 0x4819c,
-	.halt_check = BRANCH_HALT_VOTED,
-	.clkr = {
-		.enable_reg = 0x52004,
-		.enable_mask = BIT(0),
-		.hw.init = &(struct clk_init_data){
-			.name = "gcc_sys_noc_cpuss_ahb_clk",
-			.parent_hws = (const struct clk_hw *[]){
-				      &gcc_cpuss_ahb_clk_src.clkr.hw
-			},
-			.num_parents = 1,
-			.flags = CLK_IS_CRITICAL | CLK_SET_RATE_PARENT,
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
 static struct clk_branch gcc_tsif_ahb_clk = {
 	.halt_reg = 0x36004,
 	.halt_check = BRANCH_HALT,
@@ -4258,8 +4198,6 @@ static struct clk_regmap *gcc_sc8180x_cl
 	[GCC_CFG_NOC_USB3_MP_AXI_CLK] = &gcc_cfg_noc_usb3_mp_axi_clk.clkr,
 	[GCC_CFG_NOC_USB3_PRIM_AXI_CLK] = &gcc_cfg_noc_usb3_prim_axi_clk.clkr,
 	[GCC_CFG_NOC_USB3_SEC_AXI_CLK] = &gcc_cfg_noc_usb3_sec_axi_clk.clkr,
-	[GCC_CPUSS_AHB_CLK] = &gcc_cpuss_ahb_clk.clkr,
-	[GCC_CPUSS_AHB_CLK_SRC] = &gcc_cpuss_ahb_clk_src.clkr,
 	[GCC_CPUSS_RBCPR_CLK] = &gcc_cpuss_rbcpr_clk.clkr,
 	[GCC_DDRSS_GPU_AXI_CLK] = &gcc_ddrss_gpu_axi_clk.clkr,
 	[GCC_DISP_HF_AXI_CLK] = &gcc_disp_hf_axi_clk.clkr,
@@ -4396,7 +4334,6 @@ static struct clk_regmap *gcc_sc8180x_cl
 	[GCC_SDCC4_AHB_CLK] = &gcc_sdcc4_ahb_clk.clkr,
 	[GCC_SDCC4_APPS_CLK] = &gcc_sdcc4_apps_clk.clkr,
 	[GCC_SDCC4_APPS_CLK_SRC] = &gcc_sdcc4_apps_clk_src.clkr,
-	[GCC_SYS_NOC_CPUSS_AHB_CLK] = &gcc_sys_noc_cpuss_ahb_clk.clkr,
 	[GCC_TSIF_AHB_CLK] = &gcc_tsif_ahb_clk.clkr,
 	[GCC_TSIF_INACTIVITY_TIMERS_CLK] = &gcc_tsif_inactivity_timers_clk.clkr,
 	[GCC_TSIF_REF_CLK] = &gcc_tsif_ref_clk.clkr,


