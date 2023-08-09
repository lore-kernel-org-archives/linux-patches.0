Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D9C6131
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67625C0760F;
	Wed,  9 Aug 2023 10:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578230;
	bh=rEOiI8k5Szh/jR8bd9HQQ9Yf2LVJmgeAEpeDgZIvWsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTZKSCVNTFkeF3aFE2PDAH0LHo0yHSD++j7aUNA7+FLiAZAhsqB7omUZr4df2rrzN
	 qMfYWshIcS5g/wB3RdSl9MKS3EM48wsDK7lFPDllsOvdHFwtUV+wm/h/nFY1zzItHx
	 EewpEmooLekd3YPaTEpn/1z7Wb6Si3/hNvX4Y7Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 151/165] clk: mediatek: mt8183: Add back SSPM related clocks
Date: Wed,  9 Aug 2023 12:41:22 +0200
Message-ID: <20230809103647.720532884@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 1eb8d61ac5c9c7ec56bb96d433532807509b9288 ]

This reverts commit 860690a93ef23b567f781c1b631623e27190f101.

On the MT8183, the SSPM related clocks were removed claiming a lack of
usage. This however causes some issues when the driver was converted to
the new simple-probe mechanism. This mechanism allocates enough space
for all the clocks defined in the clock driver, not the highest index
in the DT binding. This leads to out-of-bound writes if their are holes
in the DT binding or the driver (due to deprecated or unimplemented
clocks). These errors can go unnoticed and cause memory corruption,
leading to crashes in unrelated areas, or nothing at all. KASAN will
detect them.

Add the SSPM related clocks back to the MT8183 clock driver to fully
implement the DT binding. The SSPM clocks are for the power management
co-processor, and should never be turned off. They are marked as such.

Fixes: 3f37ba7cc385 ("clk: mediatek: mt8183: Convert all remaining clocks to common probe")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20230719074251.1219089-1-wenst@chromium.org
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt8183.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/clk/mediatek/clk-mt8183.c b/drivers/clk/mediatek/clk-mt8183.c
index 2336a1b69c093..3b605c30e8494 100644
--- a/drivers/clk/mediatek/clk-mt8183.c
+++ b/drivers/clk/mediatek/clk-mt8183.c
@@ -328,6 +328,14 @@ static const char * const atb_parents[] = {
 	"syspll_d5"
 };
 
+static const char * const sspm_parents[] = {
+	"clk26m",
+	"univpll_d2_d4",
+	"syspll_d2_d2",
+	"univpll_d2_d2",
+	"syspll_d3"
+};
+
 static const char * const dpi0_parents[] = {
 	"clk26m",
 	"tvdpll_d2",
@@ -506,6 +514,9 @@ static const struct mtk_mux top_muxes[] = {
 	/* CLK_CFG_6 */
 	MUX_GATE_CLR_SET_UPD(CLK_TOP_MUX_ATB, "atb_sel",
 		atb_parents, 0xa0, 0xa4, 0xa8, 0, 2, 7, 0x004, 24),
+	MUX_GATE_CLR_SET_UPD_FLAGS(CLK_TOP_MUX_SSPM, "sspm_sel",
+				   sspm_parents, 0xa0, 0xa4, 0xa8, 8, 3, 15, 0x004, 25,
+				   CLK_IS_CRITICAL | CLK_SET_RATE_PARENT),
 	MUX_GATE_CLR_SET_UPD(CLK_TOP_MUX_DPI0, "dpi0_sel",
 		dpi0_parents, 0xa0, 0xa4, 0xa8, 16, 4, 23, 0x004, 26),
 	MUX_GATE_CLR_SET_UPD(CLK_TOP_MUX_SCAM, "scam_sel",
@@ -671,10 +682,18 @@ static const struct mtk_gate_regs infra3_cg_regs = {
 	GATE_MTK(_id, _name, _parent, &infra2_cg_regs, _shift,	\
 		&mtk_clk_gate_ops_setclr)
 
+#define GATE_INFRA2_FLAGS(_id, _name, _parent, _shift, _flag)	\
+	GATE_MTK_FLAGS(_id, _name, _parent, &infra2_cg_regs, 	\
+		       _shift, &mtk_clk_gate_ops_setclr, _flag)
+
 #define GATE_INFRA3(_id, _name, _parent, _shift)		\
 	GATE_MTK(_id, _name, _parent, &infra3_cg_regs, _shift,	\
 		&mtk_clk_gate_ops_setclr)
 
+#define GATE_INFRA3_FLAGS(_id, _name, _parent, _shift, _flag)	\
+	GATE_MTK_FLAGS(_id, _name, _parent, &infra3_cg_regs, 	\
+		       _shift, &mtk_clk_gate_ops_setclr, _flag)
+
 static const struct mtk_gate infra_clks[] = {
 	/* INFRA0 */
 	GATE_INFRA0(CLK_INFRA_PMIC_TMR, "infra_pmic_tmr", "axi_sel", 0),
@@ -746,7 +765,11 @@ static const struct mtk_gate infra_clks[] = {
 	GATE_INFRA2(CLK_INFRA_UNIPRO_TICK, "infra_unipro_tick", "fufs_sel", 12),
 	GATE_INFRA2(CLK_INFRA_UFS_MP_SAP_BCLK, "infra_ufs_mp_sap_bck", "fufs_sel", 13),
 	GATE_INFRA2(CLK_INFRA_MD32_BCLK, "infra_md32_bclk", "axi_sel", 14),
+	/* infra_sspm is main clock in co-processor, should not be closed in Linux. */
+	GATE_INFRA2_FLAGS(CLK_INFRA_SSPM, "infra_sspm", "sspm_sel", 15, CLK_IS_CRITICAL),
 	GATE_INFRA2(CLK_INFRA_UNIPRO_MBIST, "infra_unipro_mbist", "axi_sel", 16),
+	/* infra_sspm_bus_hclk is main clock in co-processor, should not be closed in Linux. */
+	GATE_INFRA2_FLAGS(CLK_INFRA_SSPM_BUS_HCLK, "infra_sspm_bus_hclk", "axi_sel", 17, CLK_IS_CRITICAL),
 	GATE_INFRA2(CLK_INFRA_I2C5, "infra_i2c5", "i2c_sel", 18),
 	GATE_INFRA2(CLK_INFRA_I2C5_ARBITER, "infra_i2c5_arbiter", "i2c_sel", 19),
 	GATE_INFRA2(CLK_INFRA_I2C5_IMM, "infra_i2c5_imm", "i2c_sel", 20),
@@ -764,6 +787,10 @@ static const struct mtk_gate infra_clks[] = {
 	GATE_INFRA3(CLK_INFRA_MSDC0_SELF, "infra_msdc0_self", "msdc50_0_sel", 0),
 	GATE_INFRA3(CLK_INFRA_MSDC1_SELF, "infra_msdc1_self", "msdc50_0_sel", 1),
 	GATE_INFRA3(CLK_INFRA_MSDC2_SELF, "infra_msdc2_self", "msdc50_0_sel", 2),
+	/* infra_sspm_26m_self is main clock in co-processor, should not be closed in Linux. */
+	GATE_INFRA3_FLAGS(CLK_INFRA_SSPM_26M_SELF, "infra_sspm_26m_self", "f_f26m_ck", 3, CLK_IS_CRITICAL),
+	/* infra_sspm_32k_self is main clock in co-processor, should not be closed in Linux. */
+	GATE_INFRA3_FLAGS(CLK_INFRA_SSPM_32K_SELF, "infra_sspm_32k_self", "f_f26m_ck", 4, CLK_IS_CRITICAL),
 	GATE_INFRA3(CLK_INFRA_UFS_AXI, "infra_ufs_axi", "axi_sel", 5),
 	GATE_INFRA3(CLK_INFRA_I2C6, "infra_i2c6", "i2c_sel", 6),
 	GATE_INFRA3(CLK_INFRA_AP_MSDC0, "infra_ap_msdc0", "msdc50_hclk_sel", 7),
-- 
2.40.1



