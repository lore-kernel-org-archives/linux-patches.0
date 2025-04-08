Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF14A25FA29;
	Tue,  8 Apr 2025 11:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111403; cv=none; b=rrMlw286ia2ozjjQvPXmhDJs3CVcekZNBajYlP0sYoYkwckOo9ylhcVHTQURRrdRxE41nOJNoHA1Bl0rf8OaE6tlnL8ImnxXK2l2UEzTjrsoI/zhIi6Dt6cUv8qW38xqdLRlHAsOxWOuX5R+YKguQ8d/5GEUp9AGJSueSZ6jPuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111403; c=relaxed/simple;
	bh=i1qjzxeRKCekvXnpY5hRsUCxeh1f29+OHnK/7by+Qwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQTAOiwO05Wi7CpDhVMXqCrKink+ml0BGhJ3cokxI084f6vPXMeZnblwPS5WhoF15M6fCC7FlehjyhNyKW4viup7hon0NTCB+FnuC2fxf1lLm4rwaRdE1roH6QHo19SvJM0XFp9PHN/cyIcMRswE7WmGC3Q1DHSKnsujQ91QP0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zA0/lubv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zA0/lubv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDBDC4CEE5;
	Tue,  8 Apr 2025 11:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111403;
	bh=i1qjzxeRKCekvXnpY5hRsUCxeh1f29+OHnK/7by+Qwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zA0/lubvWBXQt5drGayO184l0Ef8h3HeBv9gOI6LI6o+l8FZ12yXFeqYqqfs7bPgA
	 uCakPnkjnFe4xT8aON7Fo6+cALddmbw3XJu0/Wn85Jorn3m5RZvgvE3yv63QXoIoOZ
	 ppC528rKLL8GiGuaa0FkgQOqCJfY5D62da4JWSXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 383/731] clk: qcom: gcc-x1e80100: Unregister GCC_GPU_CFG_AHB_CLK/GCC_DISP_XO_CLK
Date: Tue,  8 Apr 2025 12:44:40 +0200
Message-ID: <20250408104923.185082685@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit b60521eff227ef459e03879cbea2b2bd85a8d7af ]

The GPU clock is required for CPU access to GPUSS registers. It was
previously decided (on this and many more platforms) that the added
overhead/hassle introduced by keeping track of it would not bring much
measurable improvement in the power department.

The display clock is basically the same story over again.

Now, we're past that discussion and this commit is not trying to change
that. Instead, the clocks are both force-enabled in .probe *and*
registered with the common clock framework, resulting in them being
toggled off after ignore_unused.

Unregister said clocks to fix breakage when clk_ignore_unused is absent
(as it should be).

Fixes: 161b7c401f4b ("clk: qcom: Add Global Clock controller (GCC) driver for X1E80100")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250111-topic-x1e_fixups-v1-1-77dc39237c12@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-x1e80100.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/drivers/clk/qcom/gcc-x1e80100.c b/drivers/clk/qcom/gcc-x1e80100.c
index 7288af845434d..009f39139b644 100644
--- a/drivers/clk/qcom/gcc-x1e80100.c
+++ b/drivers/clk/qcom/gcc-x1e80100.c
@@ -2564,19 +2564,6 @@ static struct clk_branch gcc_disp_hf_axi_clk = {
 	},
 };
 
-static struct clk_branch gcc_disp_xo_clk = {
-	.halt_reg = 0x27018,
-	.halt_check = BRANCH_HALT,
-	.clkr = {
-		.enable_reg = 0x27018,
-		.enable_mask = BIT(0),
-		.hw.init = &(const struct clk_init_data) {
-			.name = "gcc_disp_xo_clk",
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
 static struct clk_branch gcc_gp1_clk = {
 	.halt_reg = 0x64000,
 	.halt_check = BRANCH_HALT,
@@ -2631,21 +2618,6 @@ static struct clk_branch gcc_gp3_clk = {
 	},
 };
 
-static struct clk_branch gcc_gpu_cfg_ahb_clk = {
-	.halt_reg = 0x71004,
-	.halt_check = BRANCH_HALT_VOTED,
-	.hwcg_reg = 0x71004,
-	.hwcg_bit = 1,
-	.clkr = {
-		.enable_reg = 0x71004,
-		.enable_mask = BIT(0),
-		.hw.init = &(const struct clk_init_data) {
-			.name = "gcc_gpu_cfg_ahb_clk",
-			.ops = &clk_branch2_ops,
-		},
-	},
-};
-
 static struct clk_branch gcc_gpu_gpll0_cph_clk_src = {
 	.halt_check = BRANCH_HALT_DELAY,
 	.clkr = {
@@ -6268,7 +6240,6 @@ static struct clk_regmap *gcc_x1e80100_clocks[] = {
 	[GCC_CNOC_PCIE_TUNNEL_CLK] = &gcc_cnoc_pcie_tunnel_clk.clkr,
 	[GCC_DDRSS_GPU_AXI_CLK] = &gcc_ddrss_gpu_axi_clk.clkr,
 	[GCC_DISP_HF_AXI_CLK] = &gcc_disp_hf_axi_clk.clkr,
-	[GCC_DISP_XO_CLK] = &gcc_disp_xo_clk.clkr,
 	[GCC_GP1_CLK] = &gcc_gp1_clk.clkr,
 	[GCC_GP1_CLK_SRC] = &gcc_gp1_clk_src.clkr,
 	[GCC_GP2_CLK] = &gcc_gp2_clk.clkr,
@@ -6281,7 +6252,6 @@ static struct clk_regmap *gcc_x1e80100_clocks[] = {
 	[GCC_GPLL7] = &gcc_gpll7.clkr,
 	[GCC_GPLL8] = &gcc_gpll8.clkr,
 	[GCC_GPLL9] = &gcc_gpll9.clkr,
-	[GCC_GPU_CFG_AHB_CLK] = &gcc_gpu_cfg_ahb_clk.clkr,
 	[GCC_GPU_GPLL0_CPH_CLK_SRC] = &gcc_gpu_gpll0_cph_clk_src.clkr,
 	[GCC_GPU_GPLL0_DIV_CPH_CLK_SRC] = &gcc_gpu_gpll0_div_cph_clk_src.clkr,
 	[GCC_GPU_MEMNOC_GFX_CLK] = &gcc_gpu_memnoc_gfx_clk.clkr,
-- 
2.39.5



