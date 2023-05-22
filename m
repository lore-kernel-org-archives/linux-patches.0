Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9224171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2594FC433D2;
	Mon, 22 May 2023 19:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784793;
	bh=dZcncFoOgw/eH7UVCrXpSIV9X+sT3A0DOP87tB3c8zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aF6aVmCZG+zm3DAEe7yOdd87Pz3UMe+77bqR2pZF4wLOlffX0Mkb/VQdenNPKeggU
	 p1ywVZRl9+qrJBqMx4f2s60SBx22Gm0kXor/RWwVOj7gpNDQltZMqQ08jSmI5EPBlp
	 Ap7K13cs9rOJdaa1T5XrvS5pjilJKtqv7/AHYjxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Legoll <vincent.legoll@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 187/364] clk: rockchip: rk3588: make gate linked clocks critical
Date: Mon, 22 May 2023 20:08:12 +0100
Message-Id: <20230522190417.408348679@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit 64042c28c3bb6729df8e2fda89bc7ebbe3790907 ]

RK3588 has a couple of hardware blocks called Native Interface Unit
(NIU) that gate the clocks to devices behind them. Effectively this
means that some clocks require two parent clocks being enabled.
Downstream implemented this by using a separate clock driver
("clk-link") for them, which enables the second clock using PM
framework.

In the upstream kernel we are currently missing support for the second
parent. The information about it is in the GATE_LINK() macro as
linkname, but that is not used. Thus the second parent clock is not
properly enabled. So far this did not really matter, since these clocks
are mostly required for the more advanced IP blocks, that are not yet
supported upstream. As this is about to change we need a fix. There
are three options available:

1. Properly implement support for having two parent clocks in the
   clock framework.
2. Mark the affected clocks CLK_IGNORE_UNUSED, so that they are not
   disabled. This wastes some power, but keeps the hack contained
   within the clock driver. Going from this to the first solution
   is easy once that has been implemented.
3. Enabling the extra clock in the consumer driver. This leaks some
   implementation details into DT.

This patch implements the second option as an intermediate solution
until the first one is available. I used an alias for CLK_IS_CRITICAL,
so that it's easy to see which clocks are not really critical once
the clock framework supports a better way to implement this.

Tested-by: Vincent Legoll <vincent.legoll@gmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://lore.kernel.org/r/20230403193250.108693-2-sebastian.reichel@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3588.c | 42 +++++++++++++++++++------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3588.c b/drivers/clk/rockchip/clk-rk3588.c
index b7ce3fbd6fa6a..6994165e03957 100644
--- a/drivers/clk/rockchip/clk-rk3588.c
+++ b/drivers/clk/rockchip/clk-rk3588.c
@@ -13,15 +13,25 @@
 #include "clk.h"
 
 /*
- * GATE with additional linked clock. Downstream enables the linked clock
- * (via runtime PM) whenever the gate is enabled. The downstream implementation
- * does this via separate clock nodes for each of the linked gate clocks,
- * which leaks parts of the clock tree into DT. It is unclear why this is
- * actually needed and things work without it for simple use cases. Thus
- * the linked clock is ignored for now.
+ * Recent Rockchip SoCs have a new hardware block called Native Interface
+ * Unit (NIU), which gates clocks to devices behind them. These effectively
+ * need two parent clocks.
+ *
+ * Downstream enables the linked clock via runtime PM whenever the gate is
+ * enabled. This implementation uses separate clock nodes for each of the
+ * linked gate clocks, which leaks parts of the clock tree into DT.
+ *
+ * The GATE_LINK macro instead takes the second parent via 'linkname', but
+ * ignores the information. Once the clock framework is ready to handle it, the
+ * information should be passed on here. But since these clocks are required to
+ * access multiple relevant IP blocks, such as PCIe or USB, we mark all linked
+ * clocks critical until a better solution is available. This will waste some
+ * power, but avoids leaking implementation details into DT or hanging the
+ * system.
  */
 #define GATE_LINK(_id, cname, pname, linkname, f, o, b, gf) \
 	GATE(_id, cname, pname, f, o, b, gf)
+#define RK3588_LINKED_CLK		CLK_IS_CRITICAL
 
 
 #define RK3588_GRF_SOC_STATUS0		0x600
@@ -1446,7 +1456,7 @@ static struct rockchip_clk_branch rk3588_clk_branches[] __initdata = {
 	COMPOSITE_NODIV(HCLK_NVM_ROOT,  "hclk_nvm_root", mux_200m_100m_50m_24m_p, 0,
 			RK3588_CLKSEL_CON(77), 0, 2, MFLAGS,
 			RK3588_CLKGATE_CON(31), 0, GFLAGS),
-	COMPOSITE(ACLK_NVM_ROOT, "aclk_nvm_root", gpll_cpll_p, 0,
+	COMPOSITE(ACLK_NVM_ROOT, "aclk_nvm_root", gpll_cpll_p, RK3588_LINKED_CLK,
 			RK3588_CLKSEL_CON(77), 7, 1, MFLAGS, 2, 5, DFLAGS,
 			RK3588_CLKGATE_CON(31), 1, GFLAGS),
 	GATE(ACLK_EMMC, "aclk_emmc", "aclk_nvm_root", 0,
@@ -1675,13 +1685,13 @@ static struct rockchip_clk_branch rk3588_clk_branches[] __initdata = {
 			RK3588_CLKGATE_CON(42), 9, GFLAGS),
 
 	/* vdpu */
-	COMPOSITE(ACLK_VDPU_ROOT, "aclk_vdpu_root", gpll_cpll_aupll_p, 0,
+	COMPOSITE(ACLK_VDPU_ROOT, "aclk_vdpu_root", gpll_cpll_aupll_p, RK3588_LINKED_CLK,
 			RK3588_CLKSEL_CON(98), 5, 2, MFLAGS, 0, 5, DFLAGS,
 			RK3588_CLKGATE_CON(44), 0, GFLAGS),
 	COMPOSITE_NODIV(ACLK_VDPU_LOW_ROOT, "aclk_vdpu_low_root", mux_400m_200m_100m_24m_p, 0,
 			RK3588_CLKSEL_CON(98), 7, 2, MFLAGS,
 			RK3588_CLKGATE_CON(44), 1, GFLAGS),
-	COMPOSITE_NODIV(HCLK_VDPU_ROOT, "hclk_vdpu_root", mux_200m_100m_50m_24m_p, 0,
+	COMPOSITE_NODIV(HCLK_VDPU_ROOT, "hclk_vdpu_root", mux_200m_100m_50m_24m_p, RK3588_LINKED_CLK,
 			RK3588_CLKSEL_CON(98), 9, 2, MFLAGS,
 			RK3588_CLKGATE_CON(44), 2, GFLAGS),
 	COMPOSITE(ACLK_JPEG_DECODER_ROOT, "aclk_jpeg_decoder_root", gpll_cpll_aupll_spll_p, 0,
@@ -1732,9 +1742,9 @@ static struct rockchip_clk_branch rk3588_clk_branches[] __initdata = {
 	COMPOSITE(ACLK_RKVENC0_ROOT, "aclk_rkvenc0_root", gpll_cpll_npll_p, 0,
 			RK3588_CLKSEL_CON(102), 7, 2, MFLAGS, 2, 5, DFLAGS,
 			RK3588_CLKGATE_CON(47), 1, GFLAGS),
-	GATE(HCLK_RKVENC0, "hclk_rkvenc0", "hclk_rkvenc0_root", 0,
+	GATE(HCLK_RKVENC0, "hclk_rkvenc0", "hclk_rkvenc0_root", RK3588_LINKED_CLK,
 			RK3588_CLKGATE_CON(47), 4, GFLAGS),
-	GATE(ACLK_RKVENC0, "aclk_rkvenc0", "aclk_rkvenc0_root", 0,
+	GATE(ACLK_RKVENC0, "aclk_rkvenc0", "aclk_rkvenc0_root", RK3588_LINKED_CLK,
 			RK3588_CLKGATE_CON(47), 5, GFLAGS),
 	COMPOSITE(CLK_RKVENC0_CORE, "clk_rkvenc0_core", gpll_cpll_aupll_npll_p, 0,
 			RK3588_CLKSEL_CON(102), 14, 2, MFLAGS, 9, 5, DFLAGS,
@@ -1744,10 +1754,10 @@ static struct rockchip_clk_branch rk3588_clk_branches[] __initdata = {
 			RK3588_CLKGATE_CON(48), 6, GFLAGS),
 
 	/* vi */
-	COMPOSITE(ACLK_VI_ROOT, "aclk_vi_root", gpll_cpll_npll_aupll_spll_p, 0,
+	COMPOSITE(ACLK_VI_ROOT, "aclk_vi_root", gpll_cpll_npll_aupll_spll_p, RK3588_LINKED_CLK,
 			RK3588_CLKSEL_CON(106), 5, 3, MFLAGS, 0, 5, DFLAGS,
 			RK3588_CLKGATE_CON(49), 0, GFLAGS),
-	COMPOSITE_NODIV(HCLK_VI_ROOT, "hclk_vi_root", mux_200m_100m_50m_24m_p, 0,
+	COMPOSITE_NODIV(HCLK_VI_ROOT, "hclk_vi_root", mux_200m_100m_50m_24m_p, RK3588_LINKED_CLK,
 			RK3588_CLKSEL_CON(106), 8, 2, MFLAGS,
 			RK3588_CLKGATE_CON(49), 1, GFLAGS),
 	COMPOSITE_NODIV(PCLK_VI_ROOT, "pclk_vi_root", mux_100m_50m_24m_p, 0,
@@ -1919,10 +1929,10 @@ static struct rockchip_clk_branch rk3588_clk_branches[] __initdata = {
 	COMPOSITE(ACLK_VOP_ROOT, "aclk_vop_root", gpll_cpll_dmyaupll_npll_spll_p, 0,
 			RK3588_CLKSEL_CON(110), 5, 3, MFLAGS, 0, 5, DFLAGS,
 			RK3588_CLKGATE_CON(52), 0, GFLAGS),
-	COMPOSITE_NODIV(ACLK_VOP_LOW_ROOT, "aclk_vop_low_root", mux_400m_200m_100m_24m_p, 0,
+	COMPOSITE_NODIV(ACLK_VOP_LOW_ROOT, "aclk_vop_low_root", mux_400m_200m_100m_24m_p, RK3588_LINKED_CLK,
 			RK3588_CLKSEL_CON(110), 8, 2, MFLAGS,
 			RK3588_CLKGATE_CON(52), 1, GFLAGS),
-	COMPOSITE_NODIV(HCLK_VOP_ROOT, "hclk_vop_root", mux_200m_100m_50m_24m_p, 0,
+	COMPOSITE_NODIV(HCLK_VOP_ROOT, "hclk_vop_root", mux_200m_100m_50m_24m_p, RK3588_LINKED_CLK,
 			RK3588_CLKSEL_CON(110), 10, 2, MFLAGS,
 			RK3588_CLKGATE_CON(52), 2, GFLAGS),
 	COMPOSITE_NODIV(PCLK_VOP_ROOT, "pclk_vop_root", mux_100m_50m_24m_p, 0,
@@ -2425,7 +2435,7 @@ static struct rockchip_clk_branch rk3588_clk_branches[] __initdata = {
 
 	GATE_LINK(ACLK_ISP1_PRE, "aclk_isp1_pre", "aclk_isp1_root", "aclk_vi_root", 0, RK3588_CLKGATE_CON(26), 6, GFLAGS),
 	GATE_LINK(HCLK_ISP1_PRE, "hclk_isp1_pre", "hclk_isp1_root", "hclk_vi_root", 0, RK3588_CLKGATE_CON(26), 8, GFLAGS),
-	GATE_LINK(HCLK_NVM, "hclk_nvm", "hclk_nvm_root", "aclk_nvm_root", 0, RK3588_CLKGATE_CON(31), 2, GFLAGS),
+	GATE_LINK(HCLK_NVM, "hclk_nvm", "hclk_nvm_root", "aclk_nvm_root", RK3588_LINKED_CLK, RK3588_CLKGATE_CON(31), 2, GFLAGS),
 	GATE_LINK(ACLK_USB, "aclk_usb", "aclk_usb_root", "aclk_vo1usb_top_root", 0, RK3588_CLKGATE_CON(42), 2, GFLAGS),
 	GATE_LINK(HCLK_USB, "hclk_usb", "hclk_usb_root", "hclk_vo1usb_top_root", 0, RK3588_CLKGATE_CON(42), 3, GFLAGS),
 	GATE_LINK(ACLK_JPEG_DECODER_PRE, "aclk_jpeg_decoder_pre", "aclk_jpeg_decoder_root", "aclk_vdpu_root", 0, RK3588_CLKGATE_CON(44), 7, GFLAGS),
-- 
2.39.2



