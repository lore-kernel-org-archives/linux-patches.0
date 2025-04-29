Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298FF3FFD;
	Tue, 29 Apr 2025 18:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949682; cv=none; b=mCtSAUR7b4olHSKZ2F5OwqN/vfEz6cHDAvcC8stWyEwFjh8E3NogxKHx7Un5QoSgbrFPC8XiHxdkP4KDOjqwe6QCL15FpkJ10mLAsiT/gaM9MbO8MuFWMdPDP+UFTYI7547NrkqSFG3qrAtnEtxZzLyrs4esdKUY3uMw+9ZeS7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949682; c=relaxed/simple;
	bh=ZHMNslZZ8qBJBXpBND6YOEZGbaZsRSbmfrCksF/2VJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2C5R2VhmOH5qnQfPJpzuHhNv2Gjt9UI4hcPQ2qQJZA0/Dpo/fVQNkIoMivBoZbO76bc+0FAHrtSi5Fmizla8c8s9Pgqnj5wv7ivfLclMNmQmjqsg2Ho3nOXYEGXLoIgAdD10atMSBQRy3vSQKHPE+n/umHwRZgVVZ1z3MTU8zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPLwURz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPLwURz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB39C4CEE3;
	Tue, 29 Apr 2025 18:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949682;
	bh=ZHMNslZZ8qBJBXpBND6YOEZGbaZsRSbmfrCksF/2VJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPLwURz9gXp126inLABddWxUKBQ+yIAGktJIySqORRzfOwQWmNfk1U/8NofmkvHmD
	 xtBXvYAjszOlkZwUsiOAWyTfeRSkqGrsJcGgeWweU0swGJXlYW0CrAU0UlU32Q5sNe
	 TSbjaWba8np34aGI02qlh8+nq7Qowv5oiM1AClD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/167] clk: renesas: rzg2l: Add struct clk_hw_data
Date: Tue, 29 Apr 2025 18:42:10 +0200
Message-ID: <20250429161052.649050491@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 97c1c4ccda76d2919775d748cf223637cf0e82ae ]

Add clk_hw_data struct that keeps the core part of the clock data.
sd_hw_data embeds a member of type struct clk_hw_data along with other
members (in the next commits).  This commit prepares the field for
refactoring the SD MUX clock driver.

Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230929053915.1530607-9-claudiu.beznea@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Stable-dep-of: 7f22a298d926 ("clk: renesas: r9a07g043: Fix HP clock source for RZ/Five")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzg2l-cpg.c | 52 +++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 18 deletions(-)

diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index 5617040f307c4..2d298d94e1d85 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -59,13 +59,29 @@
 
 #define MAX_VCLK_FREQ		(148500000)
 
-struct sd_hw_data {
+/**
+ * struct clk_hw_data - clock hardware data
+ * @hw: clock hw
+ * @conf: clock configuration (register offset, shift, width)
+ * @priv: CPG private data structure
+ */
+struct clk_hw_data {
 	struct clk_hw hw;
 	u32 conf;
 	struct rzg2l_cpg_priv *priv;
 };
 
-#define to_sd_hw_data(_hw)	container_of(_hw, struct sd_hw_data, hw)
+#define to_clk_hw_data(_hw)	container_of(_hw, struct clk_hw_data, hw)
+
+/**
+ * struct sd_hw_data - SD clock hardware data
+ * @hw_data: clock hw data
+ */
+struct sd_hw_data {
+	struct clk_hw_data hw_data;
+};
+
+#define to_sd_hw_data(_hw)	container_of(_hw, struct sd_hw_data, hw_data)
 
 struct rzg2l_pll5_param {
 	u32 pl5_fracin;
@@ -187,10 +203,10 @@ static int rzg2l_cpg_sd_clk_mux_determine_rate(struct clk_hw *hw,
 
 static int rzg2l_cpg_sd_clk_mux_set_parent(struct clk_hw *hw, u8 index)
 {
-	struct sd_hw_data *hwdata = to_sd_hw_data(hw);
-	struct rzg2l_cpg_priv *priv = hwdata->priv;
-	u32 off = GET_REG_OFFSET(hwdata->conf);
-	u32 shift = GET_SHIFT(hwdata->conf);
+	struct clk_hw_data *clk_hw_data = to_clk_hw_data(hw);
+	struct rzg2l_cpg_priv *priv = clk_hw_data->priv;
+	u32 off = GET_REG_OFFSET(clk_hw_data->conf);
+	u32 shift = GET_SHIFT(clk_hw_data->conf);
 	const u32 clk_src_266 = 2;
 	u32 msk, val, bitmask;
 	unsigned long flags;
@@ -207,7 +223,7 @@ static int rzg2l_cpg_sd_clk_mux_set_parent(struct clk_hw *hw, u8 index)
 	 * The clock mux has 3 input clocks(533 MHz, 400 MHz, and 266 MHz), and
 	 * the index to value mapping is done by adding 1 to the index.
 	 */
-	bitmask = (GENMASK(GET_WIDTH(hwdata->conf) - 1, 0) << shift) << 16;
+	bitmask = (GENMASK(GET_WIDTH(clk_hw_data->conf) - 1, 0) << shift) << 16;
 	msk = off ? CPG_CLKSTATUS_SELSDHI1_STS : CPG_CLKSTATUS_SELSDHI0_STS;
 	spin_lock_irqsave(&priv->rmw_lock, flags);
 	if (index != clk_src_266) {
@@ -236,12 +252,12 @@ static int rzg2l_cpg_sd_clk_mux_set_parent(struct clk_hw *hw, u8 index)
 
 static u8 rzg2l_cpg_sd_clk_mux_get_parent(struct clk_hw *hw)
 {
-	struct sd_hw_data *hwdata = to_sd_hw_data(hw);
-	struct rzg2l_cpg_priv *priv = hwdata->priv;
-	u32 val = readl(priv->base + GET_REG_OFFSET(hwdata->conf));
+	struct clk_hw_data *clk_hw_data = to_clk_hw_data(hw);
+	struct rzg2l_cpg_priv *priv = clk_hw_data->priv;
+	u32 val = readl(priv->base + GET_REG_OFFSET(clk_hw_data->conf));
 
-	val >>= GET_SHIFT(hwdata->conf);
-	val &= GENMASK(GET_WIDTH(hwdata->conf) - 1, 0);
+	val >>= GET_SHIFT(clk_hw_data->conf);
+	val &= GENMASK(GET_WIDTH(clk_hw_data->conf) - 1, 0);
 
 	return val ? val - 1 : 0;
 }
@@ -257,17 +273,17 @@ rzg2l_cpg_sd_mux_clk_register(const struct cpg_core_clk *core,
 			      void __iomem *base,
 			      struct rzg2l_cpg_priv *priv)
 {
-	struct sd_hw_data *clk_hw_data;
+	struct sd_hw_data *sd_hw_data;
 	struct clk_init_data init;
 	struct clk_hw *clk_hw;
 	int ret;
 
-	clk_hw_data = devm_kzalloc(priv->dev, sizeof(*clk_hw_data), GFP_KERNEL);
-	if (!clk_hw_data)
+	sd_hw_data = devm_kzalloc(priv->dev, sizeof(*sd_hw_data), GFP_KERNEL);
+	if (!sd_hw_data)
 		return ERR_PTR(-ENOMEM);
 
-	clk_hw_data->priv = priv;
-	clk_hw_data->conf = core->conf;
+	sd_hw_data->hw_data.priv = priv;
+	sd_hw_data->hw_data.conf = core->conf;
 
 	init.name = GET_SHIFT(core->conf) ? "sd1" : "sd0";
 	init.ops = &rzg2l_cpg_sd_clk_mux_ops;
@@ -275,7 +291,7 @@ rzg2l_cpg_sd_mux_clk_register(const struct cpg_core_clk *core,
 	init.num_parents = core->num_parents;
 	init.parent_names = core->parent_names;
 
-	clk_hw = &clk_hw_data->hw;
+	clk_hw = &sd_hw_data->hw_data.hw;
 	clk_hw->init = &init;
 
 	ret = devm_clk_hw_register(priv->dev, clk_hw);
-- 
2.39.5



