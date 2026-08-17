Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D20E8834;
	Mon, 17 Aug 2026 15:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979752; cv=none; b=rmB86epDHkedeHJrel1bfPx3ttoXcxLkduCZ1cLC6LDXzLIjj7AXGnhKFFIVATgvSxyYyfPSTCs6Inhr369dUjwZywmx5bAo9yUv+ykv9sTTxxqU3pMhZtImAttqPm2+2y8xrfBqa7cfmyGWcav2P99MyQ42j57Av0sViVHyM/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979752; c=relaxed/simple;
	bh=IlUQrYwEeCTlZ0z1TzAE7ZlsxAyfWrSaWemTemTS070=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqAW4GMv7oh4HOmc5MS1XWgkVI+TtCKMzmTIKjjcW7XBc2glA6hGg9HNRqyKrEPMlWeOXNbG24u2clyq0fQu3KsnpIK29wq2Twu/eKzUUDZf+wHGdr2NrOpDde7x2UjySMgjMHqaVPgLjEigwL9ro1My8JO6wc18m5EElV9K+FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dk6SD1cZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dk6SD1cZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A421F000E9;
	Mon, 17 Aug 2026 15:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979751;
	bh=XjHIlZqa/RZgEgk7K7Lcz1zIoK70ZDye9CvmwkHYzG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dk6SD1cZOXP0A8z6Z/+b8hZQ/YzXeRZq7K4/sbLis96JYZN/JKC5cQNnlXLlV7GUe
	 HprMkiihw34UEMGh4QTy1hPm86W81RR+hEMCDlxyBAXn/jIi6o39a2rOd8aNSxdfc+
	 pLpAN9sZZ50v0doGKri+CyOo4Z7frNIIhU9HJGHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Looijmans <mike.looijmans@topic.nl>,
	Michal Simek <michal.simek@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 318/609] phy-zynqmp: Postpone getting clock rate until actually needed
Date: Mon, 17 Aug 2026 15:30:14 +0200
Message-ID: <20260817132554.880510959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 00ceeca2a395f..61dc831f778dd 100644
--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -228,7 +228,6 @@ struct xpsgtr_phy {
  * @siou: siou base address
  * @gtr_mutex: mutex for locking
  * @phys: PHY lanes
- * @refclk_sscs: spread spectrum settings for the reference clocks
  * @clk: reference clocks
  * @tx_term_fix: fix for GT issue
  * @saved_icm_cfg0: stored value of ICM CFG0 register
@@ -241,7 +240,6 @@ struct xpsgtr_dev {
 	void __iomem *siou;
 	struct mutex gtr_mutex; /* mutex for locking */
 	struct xpsgtr_phy phys[NUM_LANES];
-	const struct xpsgtr_ssc *refclk_sscs[NUM_LANES];
 	struct clk *clk[NUM_LANES];
 	bool tx_term_fix;
 	unsigned int saved_icm_cfg0;
@@ -384,13 +382,40 @@ static int xpsgtr_wait_pll_lock(struct phy *phy)
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
@@ -432,6 +457,8 @@ static void xpsgtr_configure_pll(struct xpsgtr_phy *gtr_phy)
 	xpsgtr_clr_set_phy(gtr_phy, L0_PLL_SS_STEP_SIZE_3_MSB,
 			   STEP_SIZE_3_MASK, (step_size & STEP_SIZE_3_MASK) |
 			   FORCE_STEP_SIZE | FORCE_STEPS);
+
+	return 0;
 }
 
 /* Configure the lane protocol. */
@@ -644,7 +671,10 @@ static int xpsgtr_phy_init(struct phy *phy)
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
@@ -855,8 +885,7 @@ static struct phy *xpsgtr_xlate(struct device *dev,
 	}
 
 	refclk = args->args[3];
-	if (refclk >= ARRAY_SIZE(gtr_dev->refclk_sscs) ||
-	    !gtr_dev->refclk_sscs[refclk]) {
+	if (refclk >= ARRAY_SIZE(gtr_dev->clk)) {
 		dev_err(dev, "Invalid reference clock number %u\n", refclk);
 		return ERR_PTR(-EINVAL);
 	}
@@ -932,9 +961,7 @@ static int xpsgtr_get_ref_clocks(struct xpsgtr_dev *gtr_dev)
 {
 	unsigned int refclk;
 
-	for (refclk = 0; refclk < ARRAY_SIZE(gtr_dev->refclk_sscs); ++refclk) {
-		unsigned long rate;
-		unsigned int i;
+	for (refclk = 0; refclk < ARRAY_SIZE(gtr_dev->clk); ++refclk) {
 		struct clk *clk;
 		char name[8];
 
@@ -950,29 +977,6 @@ static int xpsgtr_get_ref_clocks(struct xpsgtr_dev *gtr_dev)
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



