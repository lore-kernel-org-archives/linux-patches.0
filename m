Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3A6315785;
	Sat, 12 Sep 2026 13:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221531; cv=none; b=NqrBUp3PaUWZUNlGSkgBvJt39eozJVXpNr6WEuBHl2qiYzWWmF2wz5vDCI/iniVRcLEJBz1VamK1w8fS0u9T6/TWoxjatDGzr2mjxiIbJoTLUOg8TTHtijS2ZkwXmq0PAsRkWGhVyGRGuOjif00p6y3x1jRHxeoqhHAsfbX2HkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221531; c=relaxed/simple;
	bh=6fWEVEHKzIRpowB/tPZfduOnUI86MTOF3WRXMMEDFts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqIJv47+AHd093652cT30ITnprhy8/v2ayPNz5HJSplfPRNJLd355CYNSFJSlgSIdsqtk8dYRP/K+wXYR2CQtBygHSRWiL3fFu9b22SLDcK+DAzezZmem+R/kwceWb5C1dTg7bsNTyHKD9IxSPukvIZwR1y3VN72K12xTu2uV3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjbSkIv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjbSkIv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634581F000FF;
	Sat, 12 Sep 2026 13:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221530;
	bh=ZoJWyZXyUNcfr9GN9Ca5a3lOdA9V4qUl9/9eQ5phxvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjbSkIv2q1b8PPlzyc6vWvTb4WuVlZyuLEKhv7iHIzkhx+R/9mJC0YbfqKPA/V7hu
	 a8ghbWCAT+hORfNT/9u1LvbSKu9septYze8L7W/DD5zuiPTbXOIF+5wm/W//e98OV7
	 s8qo0OSD1IiL8Rwk00MxpRIx5X/KvaGX8Kp5gHGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephan Gerhold <stephan@gerhold.net>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 0402/1424] clk: qcom: gcc-mdm9607: Drop incorrect apss_tcu_clk_src
Date: Sat, 12 Sep 2026 08:47:14 +0200
Message-ID: <20260912065616.288689158@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan@gerhold.net>

commit 38d06956f60675f906dc3f5b70b3b52103b86a7d upstream.

This clock does not exist on the specified address on MDM9607.
Reading/writing the registers always results in 0 or crashes. The math in
the frequency table is also broken. GPLL2 on MDM9607 runs at 480 MHz, so:

 - F(155000000, P_GPLL2, 6, 0, 0), // 480 MHz/6 = 80 MHz, not 155 MHz
 - F(310000000, P_GPLL2, 3, 0, 0), // 480 MHz/3 = 160 MHz, not 310 MHz

Presumably, this definition was mistakenly copied as-is from gcc-msm8916
(which uses 930 MHz for GPLL2). There are no branch consumers of this root
clock inside gcc-mdm9607 (notably, gcc_apss_tcu_clk has bimc_ddr_clk_src as
parent instead of this clock), so we can just drop it.

It seems like this clock does exist on this SoC on a different address, but
since there is no user and reference code for it, it is still better to
drop it.

Cc: stable@vger.kernel.org
Fixes: 48b7253264ea ("clk: qcom: Add MDM9607 GCC driver")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20260706-qcom-clk-mdm9607-fixes-v2-6-745565101869@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-mdm9607.c |   35 -----------------------------------
 1 file changed, 35 deletions(-)

--- a/drivers/clk/qcom/gcc-mdm9607.c
+++ b/drivers/clk/qcom/gcc-mdm9607.c
@@ -158,20 +158,6 @@ static const struct clk_parent_data gcc_
 	{ .hw = &gpll2.clkr.hw },
 };
 
-static const struct parent_map gcc_xo_gpll0_gpll1_gpll2_map[] = {
-	{ P_XO, 0 },
-	{ P_GPLL0, 1 },
-	{ P_GPLL1, 2 },
-	{ P_GPLL2, 3 },
-};
-
-static const struct clk_parent_data gcc_xo_gpll0_gpll1_gpll2[] = {
-	{ .fw_name = "xo" },
-	{ .hw = &gpll0.clkr.hw },
-	{ .hw = &gpll1_vote.hw },
-	{ .hw = &gpll2.clkr.hw },
-};
-
 static const struct freq_tbl ftbl_apss_ahb_clk[] = {
 	F(19200000, P_XO, 1, 0, 0),
 	F(50000000, P_GPLL0, 16, 0, 0),
@@ -674,26 +660,6 @@ static struct clk_rcg2 sdcc2_apps_clk_sr
 	},
 };
 
-static const struct freq_tbl ftbl_gcc_apss_tcu_clk[] = {
-	F(155000000, P_GPLL2, 6, 0, 0),
-	F(310000000, P_GPLL2, 3, 0, 0),
-	F(400000000, P_GPLL0, 2, 0, 0),
-	{ }
-};
-
-static struct clk_rcg2 apss_tcu_clk_src = {
-	.cmd_rcgr = 0x1207c,
-	.hid_width = 5,
-	.parent_map = gcc_xo_gpll0_gpll1_gpll2_map,
-	.freq_tbl = ftbl_gcc_apss_tcu_clk,
-	.clkr.hw.init = &(struct clk_init_data){
-		.name = "apss_tcu_clk_src",
-		.parent_data = gcc_xo_gpll0_gpll1_gpll2,
-		.num_parents = 4,
-		.ops = &clk_rcg2_ops,
-	},
-};
-
 static const struct freq_tbl ftbl_gcc_usb_hs_system_clk[] = {
 	F(19200000, P_XO, 1, 0, 0),
 	F(57140000, P_GPLL0, 14, 0, 0),
@@ -1511,7 +1477,6 @@ static struct clk_regmap *gcc_mdm9607_cl
 	[PDM2_CLK_SRC] = &pdm2_clk_src.clkr,
 	[SDCC1_APPS_CLK_SRC] = &sdcc1_apps_clk_src.clkr,
 	[SDCC2_APPS_CLK_SRC] = &sdcc2_apps_clk_src.clkr,
-	[APSS_TCU_CLK_SRC] = &apss_tcu_clk_src.clkr,
 	[USB_HS_SYSTEM_CLK_SRC] = &usb_hs_system_clk_src.clkr,
 	[GCC_BLSP1_AHB_CLK] = &gcc_blsp1_ahb_clk.clkr,
 	[GCC_BLSP1_SLEEP_CLK] = &gcc_blsp1_sleep_clk.clkr,


