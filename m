Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30931F669E;
	Tue,  3 Dec 2024 15:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239004; cv=none; b=PoAEV3Mdx47CGBRs8RfNFUp/SsV0nJATz+r7HCFg6Lsrh9D43y87Hi7ZDzszTtkABLl57amsaPBoLbht4qcE1lL4Ib4BXcpf4Z3tb7MBJGLdjE6wxTiXa+oEjn3wPCqhfu+Thc/6BTB2gMspdvp6b2xVmhCs7h7lG+WRQKHUUxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239004; c=relaxed/simple;
	bh=YoOeaXPXQm9H8tyh6PvE6Bayi4G7N+wpe0ShEkh3lFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lxs+ME3qQKI1XTl/cKlapeiJGLMzy8xOFxZDleSNtigerNMPni5oCA0MiVdc6mBelFydHCJ8usBDYin5ZrkcbU8qWy+5CGXxHJegxDWnOZ8WGXJJ6XzKEGmgHNot55MnQI93iKbprNk4MzSX49CpDaxGXCvaDH8X+30wPYhAfc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZZSw0hV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZZSw0hV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF22C4CECF;
	Tue,  3 Dec 2024 15:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239004;
	bh=YoOeaXPXQm9H8tyh6PvE6Bayi4G7N+wpe0ShEkh3lFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZZSw0hV17dtIgC39/xgB6ZEf45bT5P40wLndnaxudbRi9PZW+BGH0J4EPbId5jda
	 DZIBErbZzNrb5q+XL4cO9c4UEC8LdQIOWXtqMnStdXLoAhwG7WeylGESS07qAPigSW
	 inFh2PLkwjK4MJi0f7+sNkg4rMl+WNQNZNqX+v4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 470/817] clk: en7523: introduce chip_scu regmap
Date: Tue,  3 Dec 2024 15:40:42 +0100
Message-ID: <20241203144014.218671781@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit f72fc22038dd544fa4d39c06e8c81c09c0041ed4 ]

Introduce chip_scu regmap pointer since EN7581 SoC will access chip-scu
memory area via a syscon node. Remove first memory region mapping
for EN7581 SoC. This patch does not introduce any backward incompatibility
since the dts for EN7581 SoC is not upstream yet.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/20241112-clk-en7581-syscon-v2-4-8ada5e394ae4@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: f98eded9e9ab ("clk: en7523: fix estimation of fixed rate for EN7581")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-en7523.c | 81 ++++++++++++++++++++++++++++++----------
 1 file changed, 61 insertions(+), 20 deletions(-)

diff --git a/drivers/clk/clk-en7523.c b/drivers/clk/clk-en7523.c
index da112c9fe8ef9..7f83cbce01eeb 100644
--- a/drivers/clk/clk-en7523.c
+++ b/drivers/clk/clk-en7523.c
@@ -3,8 +3,10 @@
 #include <linux/delay.h>
 #include <linux/clk-provider.h>
 #include <linux/io.h>
+#include <linux/mfd/syscon.h>
 #include <linux/platform_device.h>
 #include <linux/property.h>
+#include <linux/regmap.h>
 #include <linux/reset-controller.h>
 #include <dt-bindings/clock/en7523-clk.h>
 #include <dt-bindings/reset/airoha,en7581-reset.h>
@@ -247,15 +249,11 @@ static const u16 en7581_rst_map[] = {
 	[EN7581_XPON_MAC_RST]		= RST_NR_PER_BANK + 31,
 };
 
-static unsigned int en7523_get_base_rate(void __iomem *base, unsigned int i)
+static u32 en7523_get_base_rate(const struct en_clk_desc *desc, u32 val)
 {
-	const struct en_clk_desc *desc = &en7523_base_clks[i];
-	u32 val;
-
 	if (!desc->base_bits)
 		return desc->base_value;
 
-	val = readl(base + desc->base_reg);
 	val >>= desc->base_shift;
 	val &= (1 << desc->base_bits) - 1;
 
@@ -265,16 +263,11 @@ static unsigned int en7523_get_base_rate(void __iomem *base, unsigned int i)
 	return desc->base_values[val];
 }
 
-static u32 en7523_get_div(void __iomem *base, int i)
+static u32 en7523_get_div(const struct en_clk_desc *desc, u32 val)
 {
-	const struct en_clk_desc *desc = &en7523_base_clks[i];
-	u32 reg, val;
-
 	if (!desc->div_bits)
 		return 1;
 
-	reg = desc->div_reg ? desc->div_reg : desc->base_reg;
-	val = readl(base + reg);
 	val >>= desc->div_shift;
 	val &= (1 << desc->div_bits) - 1;
 
@@ -416,9 +409,12 @@ static void en7523_register_clocks(struct device *dev, struct clk_hw_onecell_dat
 
 	for (i = 0; i < ARRAY_SIZE(en7523_base_clks); i++) {
 		const struct en_clk_desc *desc = &en7523_base_clks[i];
+		u32 reg = desc->div_reg ? desc->div_reg : desc->base_reg;
+		u32 val = readl(base + desc->base_reg);
 
-		rate = en7523_get_base_rate(base, i);
-		rate /= en7523_get_div(base, i);
+		rate = en7523_get_base_rate(desc, val);
+		val = readl(base + reg);
+		rate /= en7523_get_div(desc, val);
 
 		hw = clk_hw_register_fixed_rate(dev, desc->name, NULL, 0, rate);
 		if (IS_ERR(hw)) {
@@ -454,21 +450,66 @@ static int en7523_clk_hw_init(struct platform_device *pdev,
 	return 0;
 }
 
+static void en7581_register_clocks(struct device *dev, struct clk_hw_onecell_data *clk_data,
+				   struct regmap *map, void __iomem *base)
+{
+	struct clk_hw *hw;
+	u32 rate;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(en7523_base_clks); i++) {
+		const struct en_clk_desc *desc = &en7523_base_clks[i];
+		u32 val, reg = desc->div_reg ? desc->div_reg : desc->base_reg;
+		int err;
+
+		err = regmap_read(map, desc->base_reg, &val);
+		if (err) {
+			pr_err("Failed reading fixed clk rate %s: %d\n",
+			       desc->name, err);
+			continue;
+		}
+		rate = en7523_get_base_rate(desc, val);
+
+		err = regmap_read(map, reg, &val);
+		if (err) {
+			pr_err("Failed reading fixed clk div %s: %d\n",
+			       desc->name, err);
+			continue;
+		}
+		rate /= en7523_get_div(desc, val);
+
+		hw = clk_hw_register_fixed_rate(dev, desc->name, NULL, 0, rate);
+		if (IS_ERR(hw)) {
+			pr_err("Failed to register clk %s: %ld\n",
+			       desc->name, PTR_ERR(hw));
+			continue;
+		}
+
+		clk_data->hws[desc->id] = hw;
+	}
+
+	hw = en7523_register_pcie_clk(dev, base);
+	clk_data->hws[EN7523_CLK_PCIE] = hw;
+
+	clk_data->num = EN7523_NUM_CLOCKS;
+}
+
 static int en7581_clk_hw_init(struct platform_device *pdev,
 			      struct clk_hw_onecell_data *clk_data)
 {
-	void __iomem *base, *np_base;
+	void __iomem *np_base;
+	struct regmap *map;
 	u32 val;
 
-	base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
+	map = syscon_regmap_lookup_by_compatible("airoha,en7581-chip-scu");
+	if (IS_ERR(map))
+		return PTR_ERR(map);
 
-	np_base = devm_platform_ioremap_resource(pdev, 1);
+	np_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(np_base))
 		return PTR_ERR(np_base);
 
-	en7523_register_clocks(&pdev->dev, clk_data, base, np_base);
+	en7581_register_clocks(&pdev->dev, clk_data, map, np_base);
 
 	val = readl(np_base + REG_NP_SCU_SSTR);
 	val &= ~(REG_PCIE_XSI0_SEL_MASK | REG_PCIE_XSI1_SEL_MASK);
@@ -545,7 +586,7 @@ static int en7523_reset_register(struct platform_device *pdev,
 	if (!soc_data->reset.idx_map_nr)
 		return 0;
 
-	base = devm_platform_ioremap_resource(pdev, 2);
+	base = devm_platform_ioremap_resource(pdev, 1);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-- 
2.43.0



