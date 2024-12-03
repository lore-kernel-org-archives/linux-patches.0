Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0E71F75AC;
	Tue,  3 Dec 2024 16:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241660; cv=none; b=HBcr0UYTp5rPLxLGZbnlRTu5VYM1MvOGCQ6Fy8LTc2Nji+b6QRmPZGH331YmXJNhqbZFHIA0/x5HBzdQ1Ay/UMS62dbyMOvkIpp81PgvP0d0G5JBO5i+ohknt9eGn3XY2BLVlo3vmZ7Zo1dCCeK515ouJowJIzQWz7lwbUNG1SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241660; c=relaxed/simple;
	bh=C81ZVxQb9D1qlei+9YgNfqnzMESFRbeCPowNH34zFLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IzA2HhPWf4jeT8nddhMSKxg2H0crUSVsl3BHaZtLVYfu2AOCA24atMldWjnozOHLxsqUaUvoT8xaSs8ugpyHojQFZXhQ7rCiYyns2s8EIzipam7bJf5MnPDN+k8glW48Zt24cVCFa30+iak99rau183GKRqCcKRsTAUQbnqDV0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BYbP7yGa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BYbP7yGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD07DC4CECF;
	Tue,  3 Dec 2024 16:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241660;
	bh=C81ZVxQb9D1qlei+9YgNfqnzMESFRbeCPowNH34zFLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BYbP7yGakLy0Qq3UdC8y1XmktOdwWEaafmjAqPHW5UE37D6Kb0t0EmaQg77VZ+ADq
	 wxTtjZCFlo4e73O5pH4a2tehu7GpVKpI3KIZ76je9bFMXhdFOjvHNkqs6cH8viKRLi
	 2hwhQev0B7santfaPe4oYN2/kfm0khVbNH2ZaW2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 451/826] clk: en7523: move clock_register in hw_init callback
Date: Tue,  3 Dec 2024 15:42:58 +0100
Message-ID: <20241203144801.351467662@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit b8bdfc666bc5f58caf46e67b615132fccbaca3d4 ]

Move en7523_register_clocks routine in hw_init callback.
Introduce en7523_clk_hw_init callback for EN7523 SoC.
This is a preliminary patch to differentiate IO mapped region between
EN7523 and EN7581 SoCs in order to access chip-scu IO region
<0x1fa20000 0x384> on EN7581 SoC as syscon device since it contains
miscellaneous registers needed by multiple devices (clock, pinctrl ..).

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/20241112-clk-en7581-syscon-v2-3-8ada5e394ae4@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: f98eded9e9ab ("clk: en7523: fix estimation of fixed rate for EN7581")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-en7523.c | 82 ++++++++++++++++++++++++----------------
 1 file changed, 50 insertions(+), 32 deletions(-)

diff --git a/drivers/clk/clk-en7523.c b/drivers/clk/clk-en7523.c
index ec6716844fdcf..da112c9fe8ef9 100644
--- a/drivers/clk/clk-en7523.c
+++ b/drivers/clk/clk-en7523.c
@@ -78,7 +78,8 @@ struct en_clk_soc_data {
 		const u16 *idx_map;
 		u16 idx_map_nr;
 	} reset;
-	int (*hw_init)(struct platform_device *pdev, void __iomem *np_base);
+	int (*hw_init)(struct platform_device *pdev,
+		       struct clk_hw_onecell_data *clk_data);
 };
 
 static const u32 gsw_base[] = { 400000000, 500000000 };
@@ -406,20 +407,6 @@ static void en7581_pci_disable(struct clk_hw *hw)
 	usleep_range(1000, 2000);
 }
 
-static int en7581_clk_hw_init(struct platform_device *pdev,
-			      void __iomem *np_base)
-{
-	u32 val;
-
-	val = readl(np_base + REG_NP_SCU_SSTR);
-	val &= ~(REG_PCIE_XSI0_SEL_MASK | REG_PCIE_XSI1_SEL_MASK);
-	writel(val, np_base + REG_NP_SCU_SSTR);
-	val = readl(np_base + REG_NP_SCU_PCIC);
-	writel(val | 3, np_base + REG_NP_SCU_PCIC);
-
-	return 0;
-}
-
 static void en7523_register_clocks(struct device *dev, struct clk_hw_onecell_data *clk_data,
 				   void __iomem *base, void __iomem *np_base)
 {
@@ -449,6 +436,49 @@ static void en7523_register_clocks(struct device *dev, struct clk_hw_onecell_dat
 	clk_data->num = EN7523_NUM_CLOCKS;
 }
 
+static int en7523_clk_hw_init(struct platform_device *pdev,
+			      struct clk_hw_onecell_data *clk_data)
+{
+	void __iomem *base, *np_base;
+
+	base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	np_base = devm_platform_ioremap_resource(pdev, 1);
+	if (IS_ERR(np_base))
+		return PTR_ERR(np_base);
+
+	en7523_register_clocks(&pdev->dev, clk_data, base, np_base);
+
+	return 0;
+}
+
+static int en7581_clk_hw_init(struct platform_device *pdev,
+			      struct clk_hw_onecell_data *clk_data)
+{
+	void __iomem *base, *np_base;
+	u32 val;
+
+	base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	np_base = devm_platform_ioremap_resource(pdev, 1);
+	if (IS_ERR(np_base))
+		return PTR_ERR(np_base);
+
+	en7523_register_clocks(&pdev->dev, clk_data, base, np_base);
+
+	val = readl(np_base + REG_NP_SCU_SSTR);
+	val &= ~(REG_PCIE_XSI0_SEL_MASK | REG_PCIE_XSI1_SEL_MASK);
+	writel(val, np_base + REG_NP_SCU_SSTR);
+	val = readl(np_base + REG_NP_SCU_PCIC);
+	writel(val | 3, np_base + REG_NP_SCU_PCIC);
+
+	return 0;
+}
+
 static int en7523_reset_update(struct reset_controller_dev *rcdev,
 			       unsigned long id, bool assert)
 {
@@ -543,31 +573,18 @@ static int en7523_clk_probe(struct platform_device *pdev)
 	struct device_node *node = pdev->dev.of_node;
 	const struct en_clk_soc_data *soc_data;
 	struct clk_hw_onecell_data *clk_data;
-	void __iomem *base, *np_base;
 	int r;
 
-	base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-
-	np_base = devm_platform_ioremap_resource(pdev, 1);
-	if (IS_ERR(np_base))
-		return PTR_ERR(np_base);
-
-	soc_data = device_get_match_data(&pdev->dev);
-	if (soc_data->hw_init) {
-		r = soc_data->hw_init(pdev, np_base);
-		if (r)
-			return r;
-	}
-
 	clk_data = devm_kzalloc(&pdev->dev,
 				struct_size(clk_data, hws, EN7523_NUM_CLOCKS),
 				GFP_KERNEL);
 	if (!clk_data)
 		return -ENOMEM;
 
-	en7523_register_clocks(&pdev->dev, clk_data, base, np_base);
+	soc_data = device_get_match_data(&pdev->dev);
+	r = soc_data->hw_init(pdev, clk_data);
+	if (r)
+		return r;
 
 	r = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 	if (r)
@@ -590,6 +607,7 @@ static const struct en_clk_soc_data en7523_data = {
 		.prepare = en7523_pci_prepare,
 		.unprepare = en7523_pci_unprepare,
 	},
+	.hw_init = en7523_clk_hw_init,
 };
 
 static const struct en_clk_soc_data en7581_data = {
-- 
2.43.0



