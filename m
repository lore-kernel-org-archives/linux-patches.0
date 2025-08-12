Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BC62FE597;
	Tue, 12 Aug 2025 18:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024581; cv=none; b=Shg4uqU2NTYWjIEYJChxh0UrEpxBZNAvhZL/mJvfha+dJpTOz3PzfyMS8RP1jMXfScyyNNNulkGq1rGfl3g+Vh3iUPHT+Z8O0k69s7ebgvm1fwPqXKnDtdPiMvgPZRvNEYnViB4A4WZf/CxC0jtpID0WIDd6NHuncYzE+QBIAaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024581; c=relaxed/simple;
	bh=hkiusbDpJCVLcyjoFVpWUZGxPGB6QrmX37dGN0/m2pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUjOJoZFFjpHHpLCpjVMqonhs8WHJoiPo4ybpO4OU4tzkFfyg4rIze5gZN5lXC8SkJ/o/2YTMFVoWBL0ig3X8MeeGeM8fmRZ6QKAKvutduL3rzsjSf96Px9LnX+yjpamYj3QAWZHJ/W0I4uO1gAVBJiZThFTjD7UELY5+jqSH1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rByGCUuP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rByGCUuP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1ADEC4CEF6;
	Tue, 12 Aug 2025 18:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024580;
	bh=hkiusbDpJCVLcyjoFVpWUZGxPGB6QrmX37dGN0/m2pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rByGCUuPcGiUKUWTlr/0bMFsOqt1AV8qXmP7rEI9p14phF0MhMALc+fD2nzExsdja
	 iOsJqN/6ZyRXHWXeW7f5uX1zToD206yliExbE4d5hi9foH1KYuURmGPyob4W/9+oV2
	 oOvLlutH/Zu1H2lZKm/qrhYVGx2tqcJAHunm/His=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Drew Fustini <fustini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 414/627] clk: thead: th1520-ap: Describe mux clocks with clk_mux
Date: Tue, 12 Aug 2025 19:31:49 +0200
Message-ID: <20250812173435.026404748@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <ziyao@disroot.org>

[ Upstream commit 54edba916e2913b0893b0f6404b73155d48374ea ]

Mux clocks are now described with a customized ccu_mux structure
consisting of ccu_internal and ccu_common substructures, and registered
later with devm_clk_hw_register_mux_parent_data_table(). As this helper
always allocates a new clk_hw structure, it's extremely hard to use mux
clocks as parents statically by clk_hw pointers, since CCF has no
knowledge about the clk_hw structure embedded in ccu_mux.

This scheme already causes issues for clock c910, which takes a mux
clock, c910-i0, as a possible parent. With mainline U-Boot that
reparents c910 to c910-i0 at boottime, c910 is considered as an orphan
by CCF.

This patch refactors handling of mux clocks, embeds a clk_mux structure
in ccu_mux directly. Instead of calling devm_clk_hw_register_mux_*(),
we could register mux clocks on our own without allocating any new
clk_hw pointer, fixing c910 clock's issue.

Fixes: ae81b69fd2b1 ("clk: thead: Add support for T-Head TH1520 AP_SUBSYS clocks")
Signed-off-by: Yao Zi <ziyao@disroot.org>
Signed-off-by: Drew Fustini <fustini@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/thead/clk-th1520-ap.c | 95 ++++++++++++-------------------
 1 file changed, 37 insertions(+), 58 deletions(-)

diff --git a/drivers/clk/thead/clk-th1520-ap.c b/drivers/clk/thead/clk-th1520-ap.c
index 42feb4bb6329..485b1d5cfd18 100644
--- a/drivers/clk/thead/clk-th1520-ap.c
+++ b/drivers/clk/thead/clk-th1520-ap.c
@@ -42,8 +42,9 @@ struct ccu_common {
 };
 
 struct ccu_mux {
-	struct ccu_internal	mux;
-	struct ccu_common	common;
+	int			clkid;
+	u32			reg;
+	struct clk_mux		mux;
 };
 
 struct ccu_gate {
@@ -75,6 +76,17 @@ struct ccu_pll {
 		.flags	= _flags,					\
 	}
 
+#define TH_CCU_MUX(_name, _parents, _shift, _width)			\
+	{								\
+		.mask		= GENMASK(_width - 1, 0),		\
+		.shift		= _shift,				\
+		.hw.init	= CLK_HW_INIT_PARENTS_DATA(		\
+					_name,				\
+					_parents,			\
+					&clk_mux_ops,			\
+					0),				\
+	}
+
 #define CCU_GATE(_clkid, _struct, _name, _parent, _reg, _gate, _flags)	\
 	struct ccu_gate _struct = {					\
 		.enable	= _gate,					\
@@ -94,13 +106,6 @@ static inline struct ccu_common *hw_to_ccu_common(struct clk_hw *hw)
 	return container_of(hw, struct ccu_common, hw);
 }
 
-static inline struct ccu_mux *hw_to_ccu_mux(struct clk_hw *hw)
-{
-	struct ccu_common *common = hw_to_ccu_common(hw);
-
-	return container_of(common, struct ccu_mux, common);
-}
-
 static inline struct ccu_pll *hw_to_ccu_pll(struct clk_hw *hw)
 {
 	struct ccu_common *common = hw_to_ccu_common(hw);
@@ -415,32 +420,20 @@ static const struct clk_parent_data c910_i0_parents[] = {
 };
 
 static struct ccu_mux c910_i0_clk = {
-	.mux	= TH_CCU_ARG(1, 1),
-	.common	= {
-		.clkid		= CLK_C910_I0,
-		.cfg0		= 0x100,
-		.hw.init	= CLK_HW_INIT_PARENTS_DATA("c910-i0",
-					      c910_i0_parents,
-					      &clk_mux_ops,
-					      0),
-	}
+	.clkid	= CLK_C910_I0,
+	.reg	= 0x100,
+	.mux	= TH_CCU_MUX("c910-i0", c910_i0_parents, 1, 1),
 };
 
 static const struct clk_parent_data c910_parents[] = {
-	{ .hw = &c910_i0_clk.common.hw },
+	{ .hw = &c910_i0_clk.mux.hw },
 	{ .hw = &cpu_pll1_clk.common.hw }
 };
 
 static struct ccu_mux c910_clk = {
-	.mux	= TH_CCU_ARG(0, 1),
-	.common	= {
-		.clkid		= CLK_C910,
-		.cfg0		= 0x100,
-		.hw.init	= CLK_HW_INIT_PARENTS_DATA("c910",
-					      c910_parents,
-					      &clk_mux_ops,
-					      0),
-	}
+	.clkid	= CLK_C910,
+	.reg	= 0x100,
+	.mux	= TH_CCU_MUX("c910", c910_parents, 0, 1),
 };
 
 static const struct clk_parent_data ahb2_cpusys_parents[] = {
@@ -924,15 +917,9 @@ static const struct clk_parent_data uart_sclk_parents[] = {
 };
 
 static struct ccu_mux uart_sclk = {
-	.mux	= TH_CCU_ARG(0, 1),
-	.common	= {
-		.clkid          = CLK_UART_SCLK,
-		.cfg0		= 0x210,
-		.hw.init	= CLK_HW_INIT_PARENTS_DATA("uart-sclk",
-					      uart_sclk_parents,
-					      &clk_mux_ops,
-					      0),
-	}
+	.clkid	= CLK_UART_SCLK,
+	.reg	= 0x210,
+	.mux	= TH_CCU_MUX("uart-sclk", uart_sclk_parents, 0, 1),
 };
 
 static struct ccu_common *th1520_pll_clks[] = {
@@ -969,10 +956,10 @@ static struct ccu_common *th1520_div_clks[] = {
 	&dpu1_clk.common,
 };
 
-static struct ccu_common *th1520_mux_clks[] = {
-	&c910_i0_clk.common,
-	&c910_clk.common,
-	&uart_sclk.common,
+static struct ccu_mux *th1520_mux_clks[] = {
+	&c910_i0_clk,
+	&c910_clk,
+	&uart_sclk,
 };
 
 static struct ccu_common *th1520_gate_clks[] = {
@@ -1074,7 +1061,7 @@ static const struct regmap_config th1520_clk_regmap_config = {
 struct th1520_plat_data {
 	struct ccu_common **th1520_pll_clks;
 	struct ccu_common **th1520_div_clks;
-	struct ccu_common **th1520_mux_clks;
+	struct ccu_mux	  **th1520_mux_clks;
 	struct ccu_common **th1520_gate_clks;
 
 	int nr_clks;
@@ -1161,23 +1148,15 @@ static int th1520_clk_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < plat_data->nr_mux_clks; i++) {
-		struct ccu_mux *cm = hw_to_ccu_mux(&plat_data->th1520_mux_clks[i]->hw);
-		const struct clk_init_data *init = cm->common.hw.init;
-
-		plat_data->th1520_mux_clks[i]->map = map;
-		hw = devm_clk_hw_register_mux_parent_data_table(dev,
-								init->name,
-								init->parent_data,
-								init->num_parents,
-								0,
-								base + cm->common.cfg0,
-								cm->mux.shift,
-								cm->mux.width,
-								0, NULL, NULL);
-		if (IS_ERR(hw))
-			return PTR_ERR(hw);
+		struct ccu_mux *cm = plat_data->th1520_mux_clks[i];
+
+		cm->mux.reg = base + cm->reg;
+
+		ret = devm_clk_hw_register(dev, &cm->mux.hw);
+		if (ret)
+			return ret;
 
-		priv->hws[cm->common.clkid] = hw;
+		priv->hws[cm->clkid] = &cm->mux.hw;
 	}
 
 	for (i = 0; i < plat_data->nr_gate_clks; i++) {
-- 
2.39.5



