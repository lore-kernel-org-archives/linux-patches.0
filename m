Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3221CACE4;
	Mon, 14 Oct 2024 15:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919648; cv=none; b=VTUW9DLaf0C9UQlWyganwd4TpH7TQmxn7S2b7x6+eG/e4XcLMN5Ydmab8tc01bKRzDg/GEr1wfx5kW51f5ules0MzQdnHrHwrIn9F7e80ewZg7jeMv0oH2WNjhFCEmIzabYpvRonCc99cXcMxnNkqV4LkPPE6otiPnt7/L+coQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919648; c=relaxed/simple;
	bh=d3CBh4BXCrbWa3Q11AjiIQwXw1yLvfBnfjBNpqvgOWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nK01CSVk0w28r9vWeoOUYNZ8MJWsBl38ooEwLBTtN0BXTWJ+L7+R+xvOoGynR820yeNnYek/qLK/kBPHjrJBY0WDAvZFiqQMDM+/ThoeE/Mi16Baviu0TFbJEUxEqEX9MJ0s/wnz3B+7sY5E7HCJ+6KWFh2tjJKjoUEhrC0VM5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ObZ0C18h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ObZ0C18h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB411C4CED2;
	Mon, 14 Oct 2024 15:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919648;
	bh=d3CBh4BXCrbWa3Q11AjiIQwXw1yLvfBnfjBNpqvgOWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ObZ0C18hGOLD8kRXWIzvOUBNmDEipl1BsgAZHqJkhz5LN3jIqxvEHakeUYJ3do6//
	 qARSqgRopVLTzjqPUHhJCbRf/zhF2KW6tQKxf5qq0GSzeoN2x4GEDkFDIAX51w4ALb
	 tRkFOh/h9dARDg7rCigunxWXXg8MwJi/JpyQMEeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Lee Jones <lee@kernel.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 637/798] clk: imx6ul: add ethernet refclock mux support
Date: Mon, 14 Oct 2024 16:19:51 +0200
Message-ID: <20241014141243.066548149@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 4e197ee880c24ecb63f7fe17449b3653bc64b03c ]

Add ethernet refclock mux support and set it to internal clock by
default. This configuration will not affect existing boards.

clock tree before this patch:
fec1 <- enet1_ref_125m (gate) <- enet1_ref (divider) <-,
                                                       |- pll6_enet
fec2 <- enet2_ref_125m (gate) <- enet2_ref (divider) <-´

after this patch:
fec1 <- enet1_ref_sel(mux) <- enet1_ref_125m (gate) <- ...
               `--<> enet1_ref_pad                      |- pll6_enet
fec2 <- enet2_ref_sel(mux) <- enet2_ref_125m (gate) <- ...
               `--<> enet2_ref_pad

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Lee Jones <lee@kernel.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20230131084642.709385-17-o.rempel@pengutronix.de
Stable-dep-of: 32c055ef563c ("clk: imx6ul: fix clock parent for IMX6UL_CLK_ENETx_REF_SEL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx6ul.c                | 26 +++++++++++++++++++++
 include/dt-bindings/clock/imx6ul-clock.h    |  6 ++++-
 include/linux/mfd/syscon/imx6q-iomuxc-gpr.h |  6 +++--
 3 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/imx/clk-imx6ul.c b/drivers/clk/imx/clk-imx6ul.c
index 777c4d2b87b3f..3e802befa2d4d 100644
--- a/drivers/clk/imx/clk-imx6ul.c
+++ b/drivers/clk/imx/clk-imx6ul.c
@@ -10,6 +10,7 @@
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
@@ -94,6 +95,17 @@ static const struct clk_div_table video_div_table[] = {
 	{ }
 };
 
+static const char * enet1_ref_sels[] = { "enet1_ref_125m", "enet1_ref_pad", };
+static const u32 enet1_ref_sels_table[] = { IMX6UL_GPR1_ENET1_TX_CLK_DIR,
+					    IMX6UL_GPR1_ENET1_CLK_SEL };
+static const u32 enet1_ref_sels_table_mask = IMX6UL_GPR1_ENET1_TX_CLK_DIR |
+					     IMX6UL_GPR1_ENET1_CLK_SEL;
+static const char * enet2_ref_sels[] = { "enet2_ref_125m", "enet2_ref_pad", };
+static const u32 enet2_ref_sels_table[] = { IMX6UL_GPR1_ENET2_TX_CLK_DIR,
+					    IMX6UL_GPR1_ENET2_CLK_SEL };
+static const u32 enet2_ref_sels_table_mask = IMX6UL_GPR1_ENET2_TX_CLK_DIR |
+					     IMX6UL_GPR1_ENET2_CLK_SEL;
+
 static u32 share_count_asrc;
 static u32 share_count_audio;
 static u32 share_count_sai1;
@@ -472,6 +484,17 @@ static void __init imx6ul_clocks_init(struct device_node *ccm_node)
 	/* mask handshake of mmdc */
 	imx_mmdc_mask_handshake(base, 0);
 
+	hws[IMX6UL_CLK_ENET1_REF_PAD] = imx_obtain_fixed_of_clock(ccm_node, "enet1_ref_pad", 0);
+
+	hws[IMX6UL_CLK_ENET1_REF_SEL] = imx_clk_gpr_mux("enet1_ref_sel", "fsl,imx6ul-iomuxc-gpr",
+				IOMUXC_GPR1, enet1_ref_sels, ARRAY_SIZE(enet1_ref_sels),
+				enet1_ref_sels_table, enet1_ref_sels_table_mask);
+	hws[IMX6UL_CLK_ENET2_REF_PAD] = imx_obtain_fixed_of_clock(ccm_node, "enet2_ref_pad", 0);
+
+	hws[IMX6UL_CLK_ENET2_REF_SEL] = imx_clk_gpr_mux("enet2_ref_sel", "fsl,imx6ul-iomuxc-gpr",
+				IOMUXC_GPR1, enet2_ref_sels, ARRAY_SIZE(enet2_ref_sels),
+				enet2_ref_sels_table, enet2_ref_sels_table_mask);
+
 	imx_check_clk_hws(hws, IMX6UL_CLK_END);
 
 	of_clk_add_hw_provider(np, of_clk_hw_onecell_get, clk_hw_data);
@@ -516,6 +539,9 @@ static void __init imx6ul_clocks_init(struct device_node *ccm_node)
 		clk_set_parent(hws[IMX6ULL_CLK_EPDC_PRE_SEL]->clk, hws[IMX6UL_CLK_PLL3_PFD2]->clk);
 
 	clk_set_parent(hws[IMX6UL_CLK_ENFC_SEL]->clk, hws[IMX6UL_CLK_PLL2_PFD2]->clk);
+
+	clk_set_parent(hws[IMX6UL_CLK_ENET1_REF_SEL]->clk, hws[IMX6UL_CLK_ENET_REF]->clk);
+	clk_set_parent(hws[IMX6UL_CLK_ENET2_REF_SEL]->clk, hws[IMX6UL_CLK_ENET2_REF]->clk);
 }
 
 CLK_OF_DECLARE(imx6ul, "fsl,imx6ul-ccm", imx6ul_clocks_init);
diff --git a/include/dt-bindings/clock/imx6ul-clock.h b/include/dt-bindings/clock/imx6ul-clock.h
index b44920f1edb0d..66239ebc0e233 100644
--- a/include/dt-bindings/clock/imx6ul-clock.h
+++ b/include/dt-bindings/clock/imx6ul-clock.h
@@ -257,7 +257,11 @@
 #define IMX6UL_CLK_GPIO5		248
 #define IMX6UL_CLK_MMDC_P1_IPG		249
 #define IMX6UL_CLK_ENET1_REF_125M	250
+#define IMX6UL_CLK_ENET1_REF_SEL	251
+#define IMX6UL_CLK_ENET1_REF_PAD	252
+#define IMX6UL_CLK_ENET2_REF_SEL	253
+#define IMX6UL_CLK_ENET2_REF_PAD	254
 
-#define IMX6UL_CLK_END			251
+#define IMX6UL_CLK_END			255
 
 #endif /* __DT_BINDINGS_CLOCK_IMX6UL_H */
diff --git a/include/linux/mfd/syscon/imx6q-iomuxc-gpr.h b/include/linux/mfd/syscon/imx6q-iomuxc-gpr.h
index d4b5e527a7a3b..09c6b3184bb04 100644
--- a/include/linux/mfd/syscon/imx6q-iomuxc-gpr.h
+++ b/include/linux/mfd/syscon/imx6q-iomuxc-gpr.h
@@ -451,8 +451,10 @@
 #define IMX6SX_GPR12_PCIE_RX_EQ_2			(0x2 << 0)
 
 /* For imx6ul iomux gpr register field define */
-#define IMX6UL_GPR1_ENET1_CLK_DIR		(0x1 << 17)
-#define IMX6UL_GPR1_ENET2_CLK_DIR		(0x1 << 18)
+#define IMX6UL_GPR1_ENET2_TX_CLK_DIR		BIT(18)
+#define IMX6UL_GPR1_ENET1_TX_CLK_DIR		BIT(17)
+#define IMX6UL_GPR1_ENET2_CLK_SEL		BIT(14)
+#define IMX6UL_GPR1_ENET1_CLK_SEL		BIT(13)
 #define IMX6UL_GPR1_ENET1_CLK_OUTPUT		(0x1 << 17)
 #define IMX6UL_GPR1_ENET2_CLK_OUTPUT		(0x1 << 18)
 #define IMX6UL_GPR1_ENET_CLK_DIR		(0x3 << 17)
-- 
2.43.0



