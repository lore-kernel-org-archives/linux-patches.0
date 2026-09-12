Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E9F37FF6D;
	Sat, 12 Sep 2026 08:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200822; cv=none; b=RmHxRFZYum/m1TjajWvC8/Ku4F10iIDzr/59HNT6zQ/r77KHGc7YIYSemG9n9pHfCFjd2KjcnufIINfuSu9x1y0CNCfC6zAdmlHIoU8UsNuLSC1UMSEihkIPSllCeVX9t9Ad0SWIEvaVwtY5o1r1YgA0LUE6+bdkHHnK5XitjGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200822; c=relaxed/simple;
	bh=005N4xr5kKmNHd3c2xguYszByk4HCOBWZVU5KXeyYlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWXnmh+umOLsHsa8Blq9ig808F2wHFyHNHpbVj+zFcinASYbBzFGPS5bxhSDAiKaWWTjg/422ebuDibkGeaARU4Y2qCZ3w+rt7LbPAQ2dJBpX5lhPj//kQaUrLuyKX+2K08eAClpUABinXak9LtydOca8g/2tpxPK3/JEx2obcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hgfu0Ryc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hgfu0Ryc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB561F000FF;
	Sat, 12 Sep 2026 08:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200821;
	bh=qYaGY0XxfhSJExs5hizm8s/0gYu0WNxrVwOSxIKpCnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hgfu0Ryci0Rg2Y/w8vxPWWZ9HEFI1XIRVQey6+sc/MwibWtSt3f05zNcs4S2PUTsi
	 bcEu6epkpWcG3Oj5VS3V4GhVsSGBXb7ephQhP3gc/9bWe1D+FLppoBNldlaQ5JspNN
	 Ttht215qxfmxaafMEYZTOQ4TU6DNsAjUgvSyA0sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0826/1815] clk: qcom: negcc-nord: use clk_regmap_phy_mux for USB3 pipe clock srcs
Date: Sat, 12 Sep 2026 08:42:56 +0200
Message-ID: <20260912065708.303393701@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <taniya.das@oss.qualcomm.com>

[ Upstream commit a5c2859ffe9c8e033e2df1ef62357fa5692008f1 ]

ne_gcc_usb3_prim_phy_pipe_clk_src and ne_gcc_usb3_sec_phy_pipe_clk_src
are 2-bit muxes selecting between a PHY-sourced USB3 pipe clock and
BI_TCXO, implemented with clk_regmap_mux_closest_ops. This requires
manual parent switching and does not park the mux on the reference
clock when the clock is disabled.

Convert both to clk_regmap_phy_mux with clk_regmap_phy_mux_ops, which
automatically parks the mux on the XO/ref source on disable and
restores the PHY parent on enable, matching the existing UFS symbol
clock conversions in this driver.

Fixes: a4f780cd5c7a ("clk: qcom: gcc: Add multiple global clock controller driver for Nord SoC")
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Tested-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260716-b4-nord-pipe-clk-fixes-v1-2-e4f583633356@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/negcc-nord.c | 49 +++++++++--------------------------
 1 file changed, 12 insertions(+), 37 deletions(-)

diff --git a/drivers/clk/qcom/negcc-nord.c b/drivers/clk/qcom/negcc-nord.c
index 3427a0375373c..57b90f11bc068 100644
--- a/drivers/clk/qcom/negcc-nord.c
+++ b/drivers/clk/qcom/negcc-nord.c
@@ -16,7 +16,6 @@
 #include "clk-rcg.h"
 #include "clk-regmap.h"
 #include "clk-regmap-divider.h"
-#include "clk-regmap-mux.h"
 #include "clk-regmap-phy-mux.h"
 #include "common.h"
 #include "gdsc.h"
@@ -41,8 +40,6 @@ enum {
 	P_UFS_PHY_RX_SYMBOL_0_CLK,
 	P_UFS_PHY_RX_SYMBOL_1_CLK,
 	P_UFS_PHY_TX_SYMBOL_0_CLK,
-	P_USB3_PHY_SEC_WRAPPER_NE_GCC_USB31_PIPE_CLK,
-	P_USB3_PHY_WRAPPER_NE_GCC_USB31_PIPE_CLK,
 };
 
 static struct clk_alpha_pll ne_gcc_gpll0 = {
@@ -165,26 +162,6 @@ static const struct clk_parent_data ne_gcc_parent_data_5[] = {
 	{ .index = DT_BI_TCXO },
 };
 
-static const struct parent_map ne_gcc_parent_map_6[] = {
-	{ P_USB3_PHY_WRAPPER_NE_GCC_USB31_PIPE_CLK, 0 },
-	{ P_BI_TCXO, 2 },
-};
-
-static const struct clk_parent_data ne_gcc_parent_data_6[] = {
-	{ .index = DT_USB3_PHY_WRAPPER_NE_GCC_USB31_PIPE_CLK },
-	{ .index = DT_BI_TCXO },
-};
-
-static const struct parent_map ne_gcc_parent_map_7[] = {
-	{ P_USB3_PHY_SEC_WRAPPER_NE_GCC_USB31_PIPE_CLK, 0 },
-	{ P_BI_TCXO, 2 },
-};
-
-static const struct clk_parent_data ne_gcc_parent_data_7[] = {
-	{ .index = DT_USB3_PHY_SEC_WRAPPER_NE_GCC_USB31_PIPE_CLK },
-	{ .index = DT_BI_TCXO },
-};
-
 static struct clk_regmap_phy_mux ne_gcc_ufs_phy_rx_symbol_0_clk_src = {
 	.reg = 0x33068,
 	.clkr = {
@@ -227,32 +204,30 @@ static struct clk_regmap_phy_mux ne_gcc_ufs_phy_tx_symbol_0_clk_src = {
 	},
 };
 
-static struct clk_regmap_mux ne_gcc_usb3_prim_phy_pipe_clk_src = {
+static struct clk_regmap_phy_mux ne_gcc_usb3_prim_phy_pipe_clk_src = {
 	.reg = 0x2a078,
-	.shift = 0,
-	.width = 2,
-	.parent_map = ne_gcc_parent_map_6,
 	.clkr = {
 		.hw.init = &(const struct clk_init_data) {
 			.name = "ne_gcc_usb3_prim_phy_pipe_clk_src",
-			.parent_data = ne_gcc_parent_data_6,
-			.num_parents = ARRAY_SIZE(ne_gcc_parent_data_6),
-			.ops = &clk_regmap_mux_closest_ops,
+			.parent_data = &(const struct clk_parent_data){
+				.index = DT_USB3_PHY_WRAPPER_NE_GCC_USB31_PIPE_CLK,
+			},
+			.num_parents = 1,
+			.ops = &clk_regmap_phy_mux_ops,
 		},
 	},
 };
 
-static struct clk_regmap_mux ne_gcc_usb3_sec_phy_pipe_clk_src = {
+static struct clk_regmap_phy_mux ne_gcc_usb3_sec_phy_pipe_clk_src = {
 	.reg = 0x2c078,
-	.shift = 0,
-	.width = 2,
-	.parent_map = ne_gcc_parent_map_7,
 	.clkr = {
 		.hw.init = &(const struct clk_init_data) {
 			.name = "ne_gcc_usb3_sec_phy_pipe_clk_src",
-			.parent_data = ne_gcc_parent_data_7,
-			.num_parents = ARRAY_SIZE(ne_gcc_parent_data_7),
-			.ops = &clk_regmap_mux_closest_ops,
+			.parent_data = &(const struct clk_parent_data){
+				.index = DT_USB3_PHY_SEC_WRAPPER_NE_GCC_USB31_PIPE_CLK,
+			},
+			.num_parents = 1,
+			.ops = &clk_regmap_phy_mux_ops,
 		},
 	},
 };
-- 
2.53.0



