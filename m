Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF311094C
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F6CC4339B;
	Mon,  8 May 2023 11:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545060;
	bh=662a+hvJE//CO7HoujKSuJ39qhzOwLPrsJ2lgpb74q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2QatsxoatEz5HCZeNzLadlEG6fq0y5WmClydb4McOB5L+MKFmE8ThxiQeZ3eHRRW
	 55f3pduQqUuT9KKA2CY1818JpLyo0rKluRotTfnP1HAIuIJ7xQYmI+CcvX7OW6ueWt
	 vWRaRCi4wHoGL2sVtaEv5NxGSseIfDKQI2/Dhq+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 580/694] clk: mediatek: mt8135: Properly use CLK_IS_CRITICAL flag
Date: Mon,  8 May 2023 11:46:55 +0200
Message-Id: <20230508094453.767067396@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit f4f9a9c003b52ea3cffda186753bfb3e37b970f8 ]

Instead of calling clk_prepare_enable() for clocks that shall stay
enabled, use the CLK_IS_CRITICAL flag, which purpose is exactly that.

Fixes: a8aede794843 ("clk: mediatek: Add basic clocks for Mediatek MT8135.")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20230306140543.1813621-52-angelogioacchino.delregno@collabora.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt8135.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/mediatek/clk-mt8135.c b/drivers/clk/mediatek/clk-mt8135.c
index 97a115d2c3daa..a39ad58e27418 100644
--- a/drivers/clk/mediatek/clk-mt8135.c
+++ b/drivers/clk/mediatek/clk-mt8135.c
@@ -2,6 +2,8 @@
 /*
  * Copyright (c) 2014 MediaTek Inc.
  * Author: James Liao <jamesjj.liao@mediatek.com>
+ * Copyright (c) 2023 Collabora, Ltd.
+ *               AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
  */
 
 #include <linux/clk.h>
@@ -390,7 +392,7 @@ static const struct mtk_composite top_muxes[] __initconst = {
 	MUX_GATE(CLK_TOP_GCPU_SEL, "gcpu_sel", gcpu_parents, 0x0164, 24, 3, 31),
 	/* CLK_CFG_9 */
 	MUX_GATE(CLK_TOP_DPI1_SEL, "dpi1_sel", dpi1_parents, 0x0168, 0, 2, 7),
-	MUX_GATE(CLK_TOP_CCI_SEL, "cci_sel", cci_parents, 0x0168, 8, 3, 15),
+	MUX_GATE_FLAGS(CLK_TOP_CCI_SEL, "cci_sel", cci_parents, 0x0168, 8, 3, 15, CLK_IS_CRITICAL),
 	MUX_GATE(CLK_TOP_APLL_SEL, "apll_sel", apll_parents, 0x0168, 16, 3, 23),
 	MUX_GATE(CLK_TOP_HDMIPLL_SEL, "hdmipll_sel", hdmipll_parents, 0x0168, 24, 2, 31),
 };
@@ -404,6 +406,10 @@ static const struct mtk_gate_regs infra_cg_regs = {
 #define GATE_ICG(_id, _name, _parent, _shift)	\
 	GATE_MTK(_id, _name, _parent, &infra_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
 
+#define GATE_ICG_AO(_id, _name, _parent, _shift)	\
+	GATE_MTK_FLAGS(_id, _name, _parent, &infra_cg_regs, _shift,	\
+		       &mtk_clk_gate_ops_setclr, CLK_IS_CRITICAL)
+
 static const struct mtk_gate infra_clks[] __initconst = {
 	GATE_ICG(CLK_INFRA_PMIC_WRAP, "pmic_wrap_ck", "axi_sel", 23),
 	GATE_ICG(CLK_INFRA_PMICSPI, "pmicspi_ck", "pmicspi_sel", 22),
@@ -411,7 +417,7 @@ static const struct mtk_gate infra_clks[] __initconst = {
 	GATE_ICG(CLK_INFRA_CCIF0_AP_CTRL, "ccif0_ap_ctrl", "axi_sel", 20),
 	GATE_ICG(CLK_INFRA_KP, "kp_ck", "axi_sel", 16),
 	GATE_ICG(CLK_INFRA_CPUM, "cpum_ck", "cpum_tck_in", 15),
-	GATE_ICG(CLK_INFRA_M4U, "m4u_ck", "mem_sel", 8),
+	GATE_ICG_AO(CLK_INFRA_M4U, "m4u_ck", "mem_sel", 8),
 	GATE_ICG(CLK_INFRA_MFGAXI, "mfgaxi_ck", "axi_sel", 7),
 	GATE_ICG(CLK_INFRA_DEVAPC, "devapc_ck", "axi_sel", 6),
 	GATE_ICG(CLK_INFRA_AUDIO, "audio_ck", "aud_intbus_sel", 5),
@@ -534,8 +540,6 @@ static void __init mtk_topckgen_init(struct device_node *node)
 				    ARRAY_SIZE(top_muxes), base,
 				    &mt8135_clk_lock, clk_data);
 
-	clk_prepare_enable(clk_data->hws[CLK_TOP_CCI_SEL]->clk);
-
 	r = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 	if (r)
 		pr_err("%s(): could not register clock provider: %d\n",
@@ -553,8 +557,6 @@ static void __init mtk_infrasys_init(struct device_node *node)
 	mtk_clk_register_gates(NULL, node, infra_clks,
 			       ARRAY_SIZE(infra_clks), clk_data);
 
-	clk_prepare_enable(clk_data->hws[CLK_INFRA_M4U]->clk);
-
 	r = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 	if (r)
 		pr_err("%s(): could not register clock provider: %d\n",
-- 
2.39.2



