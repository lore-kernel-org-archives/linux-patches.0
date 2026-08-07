Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F110938E8AD;
	Fri,  7 Aug 2026 14:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113918; cv=none; b=TWN1hKxpNgTVmoWO4wFjJ93ytnxB4wlwbJJWo75d3GvhhHBf+Ox3jGccc+J5llHXDth8FHRG04ZHtKCj68VsbJy5pZEHnes8FNormXMYOq/e3N8e/PRMZ1XsrDIj6T/Pc7cuOO2s5pms2L5nD/EpWmq8/JXPHchAyNT2GqxDQFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113918; c=relaxed/simple;
	bh=AEAlfj76OCna2+kfVIk9TJFBXCHpXv26rDYtpBJFhfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdZ0d8fac0Ocif4VsiQFXqFxUv01M4Qs+N9gOXiKBjlyBNt3aL8RCoLL8n3pKpRkmfu+FDIc9K82mQLGnAoNaNaZ1qmcA81QzhDgWj0+cLGnB15K1fAEQ1M0j25q3PldagKtE9DjlLeatnvP3XG093dmbrc1CEYOIH9e8u9CLsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02vQEJH7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02vQEJH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9435D1F000E9;
	Fri,  7 Aug 2026 14:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113914;
	bh=APQmFPWBMdQX+PDeWRIdw4MAFEAljscOpjMZ/Tza/9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=02vQEJH7DYwFW7X+RY7GjBOXxuDvYZFyCv5GVegZ/gOBK8a15tBOdcWPuPFh1sFfh
	 QYp0mDqNOPGBzDq55h1nlHVLkF35Cgmz2r/q78gHgf46nzVZGiwlqxQS9SWKFXfXJz
	 FEhmsNN2nQb5AAAi97UKu9phG3Jtbz0ggs6+KFLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Looijmans <mike.looijmans@topic.nl>,
	Michal Simek <michal.simek@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/337] phy-zynqmp: Postpone getting clock rate until actually needed
Date: Fri,  7 Aug 2026 16:33:58 +0200
Message-ID: <20260807143419.279116270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Looijmans <mike.looijmans@topic.nl>

[ Upstream commit 065d5885f6180c534b7b176847b3e008f4e11850 ]

At probe time the driver would display the following error and abort:
  xilinx-psgtr fd400000.phy: Invalid rate 0 for reference clock 0

At probe time, the associated GTR driver (e.g. SATA or PCIe) hasn't
initialized the clock yet, so clk_get_rate() likely returns 0 if the clock
is programmable. So this driver only works if the clock is fixed.

The PHY driver doesn't need to know the clock frequency at probe yet, so
wait until the associated driver initializes the lane before requesting the
clock rate setting.

In addition to allowing the driver to be used with programmable clocks,
this also reduces the driver's runtime memory footprint by removing an
array of pointers from struct xpsgtr_phy.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
Acked-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/20250428063648.22034-1-mike.looijmans@topic.nl
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: e4779e2a16d6 ("phy: zynqmp: fix clock error handling in xpsgtr_phy_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/xilinx/phy-zynqmp.c | 70 +++++++++++++++++----------------
 1 file changed, 37 insertions(+), 33 deletions(-)

diff --git a/drivers/phy/xilinx/phy-zynqmp.c b/drivers/phy/xilinx/phy-zynqmp.c
index e6579002f1146..6fcbdff760b32 100644
--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -222,7 +222,6 @@ struct xpsgtr_phy {
  * @siou: siou base address
  * @gtr_mutex: mutex for locking
  * @phys: PHY lanes
- * @refclk_sscs: spread spectrum settings for the reference clocks
  * @clk: reference clocks
  * @tx_term_fix: fix for GT issue
  * @saved_icm_cfg0: stored value of ICM CFG0 register
@@ -235,7 +234,6 @@ struct xpsgtr_dev {
 	void __iomem *siou;
 	struct mutex gtr_mutex; /* mutex for locking */
 	struct xpsgtr_phy phys[NUM_LANES];
-	const struct xpsgtr_ssc *refclk_sscs[NUM_LANES];
 	struct clk *clk[NUM_LANES];
 	bool tx_term_fix;
 	unsigned int saved_icm_cfg0;
@@ -398,13 +396,40 @@ static int xpsgtr_wait_pll_lock(struct phy *phy)
 	return ret;
 }
 
+/* Get the spread spectrum (SSC) settings for the reference clock rate */
+static const struct xpsgtr_ssc *xpsgtr_find_sscs(struct xpsgtr_phy *gtr_phy)
+{
+	unsigned long rate;
+	struct clk *clk;
+	unsigned int i;
+
+	clk = gtr_phy->dev->clk[gtr_phy->refclk];
+	rate = clk_get_rate(clk);
+
+	for (i = 0 ; i < ARRAY_SIZE(ssc_lookup); i++) {
+		/* Allow an error of 100 ppm */
+		unsigned long error = ssc_lookup[i].refclk_rate / 10000;
+
+		if (abs(rate - ssc_lookup[i].refclk_rate) < error)
+			return &ssc_lookup[i];
+	}
+
+	dev_err(gtr_phy->dev->dev, "Invalid rate %lu for reference clock %u\n",
+		rate, gtr_phy->refclk);
+
+	return NULL;
+}
+
 /* Configure PLL and spread-sprectrum clock. */
-static void xpsgtr_configure_pll(struct xpsgtr_phy *gtr_phy)
+static int xpsgtr_configure_pll(struct xpsgtr_phy *gtr_phy)
 {
 	const struct xpsgtr_ssc *ssc;
 	u32 step_size;
 
-	ssc = gtr_phy->dev->refclk_sscs[gtr_phy->refclk];
+	ssc = xpsgtr_find_sscs(gtr_phy);
+	if (!ssc)
+		return -EINVAL;
+
 	step_size = ssc->step_size;
 
 	xpsgtr_clr_set(gtr_phy->dev, PLL_REF_SEL(gtr_phy->lane),
@@ -446,6 +471,8 @@ static void xpsgtr_configure_pll(struct xpsgtr_phy *gtr_phy)
 	xpsgtr_clr_set_phy(gtr_phy, L0_PLL_SS_STEP_SIZE_3_MSB,
 			   STEP_SIZE_3_MASK, (step_size & STEP_SIZE_3_MASK) |
 			   FORCE_STEP_SIZE | FORCE_STEPS);
+
+	return 0;
 }
 
 /* Configure the lane protocol. */
@@ -658,7 +685,10 @@ static int xpsgtr_phy_init(struct phy *phy)
 	 * Configure the PLL, the lane protocol, and perform protocol-specific
 	 * initialization.
 	 */
-	xpsgtr_configure_pll(gtr_phy);
+	ret = xpsgtr_configure_pll(gtr_phy);
+	if (ret)
+		goto out;
+
 	xpsgtr_lane_set_protocol(gtr_phy);
 
 	switch (gtr_phy->protocol) {
@@ -823,8 +853,7 @@ static struct phy *xpsgtr_xlate(struct device *dev,
 	}
 
 	refclk = args->args[3];
-	if (refclk >= ARRAY_SIZE(gtr_dev->refclk_sscs) ||
-	    !gtr_dev->refclk_sscs[refclk]) {
+	if (refclk >= ARRAY_SIZE(gtr_dev->clk)) {
 		dev_err(dev, "Invalid reference clock number %u\n", refclk);
 		return ERR_PTR(-EINVAL);
 	}
@@ -928,9 +957,7 @@ static int xpsgtr_get_ref_clocks(struct xpsgtr_dev *gtr_dev)
 {
 	unsigned int refclk;
 
-	for (refclk = 0; refclk < ARRAY_SIZE(gtr_dev->refclk_sscs); ++refclk) {
-		unsigned long rate;
-		unsigned int i;
+	for (refclk = 0; refclk < ARRAY_SIZE(gtr_dev->clk); ++refclk) {
 		struct clk *clk;
 		char name[8];
 
@@ -946,29 +973,6 @@ static int xpsgtr_get_ref_clocks(struct xpsgtr_dev *gtr_dev)
 			continue;
 
 		gtr_dev->clk[refclk] = clk;
-
-		/*
-		 * Get the spread spectrum (SSC) settings for the reference
-		 * clock rate.
-		 */
-		rate = clk_get_rate(clk);
-
-		for (i = 0 ; i < ARRAY_SIZE(ssc_lookup); i++) {
-			/* Allow an error of 100 ppm */
-			unsigned long error = ssc_lookup[i].refclk_rate / 10000;
-
-			if (abs(rate - ssc_lookup[i].refclk_rate) < error) {
-				gtr_dev->refclk_sscs[refclk] = &ssc_lookup[i];
-				break;
-			}
-		}
-
-		if (i == ARRAY_SIZE(ssc_lookup)) {
-			dev_err(gtr_dev->dev,
-				"Invalid rate %lu for reference clock %u\n",
-				rate, refclk);
-			return -EINVAL;
-		}
 	}
 
 	return 0;
-- 
2.53.0



