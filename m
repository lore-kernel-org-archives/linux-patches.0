Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A2626AC1;
	Sun,  1 Sep 2024 17:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210451; cv=none; b=eGiFqF36I1KmiXkrO/xyW6zNi3wYt2q6gZ+j5sTOUQ9oi7vKZU19QgHYcFx6miDCyiJZgdNFOwUfogKxZpjRhiMGUnJVV+sqDiWs8/RxJqBhv6StMyExr7DAxuwLF8stiX+L/jtVecU4ZXrrveV7NYEjz/Y3iwWcAY9W9u/VZ8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210451; c=relaxed/simple;
	bh=aEoFf7/wnOLYAVkl6vO13WnvUyXYe5ysbTC0eBScbVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tz+HJT9lCdw1mesbIkQ0tjp3V5MOJet4b5cq+FwasdzHcdmzu6P+8QkyQRH87TQ3yhqY1GwK8oH3hl2961pEr18dwHqKzOCF6eHg63tFJaAfaUnkiUSRq2cs4p7t6EOPMjnkIfjC0BXmw+OLGJGUi2zs38Po5VYt+L2Y687CGjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2uunlpE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2uunlpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7BCC4CEC3;
	Sun,  1 Sep 2024 17:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210451;
	bh=aEoFf7/wnOLYAVkl6vO13WnvUyXYe5ysbTC0eBScbVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2uunlpEKjasJB/LPddLc8DTio7Ong8ATUwzPClFIp4dNcimwSUdODyWkJvkPMVFg
	 mhZTr2GXjgRthvc2Rwy9FuyUzhJzGVeDD8pVcVsc9wiUOTFlMA+ZKdVlOgzrCxrBGm
	 J9Ylwfq9Of7FhVCvW4055Zw8IIZ4OyBPwNIuVSqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piyush Mehta <piyush.mehta@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 193/215] phy: xilinx: phy-zynqmp: dynamic clock support for power-save
Date: Sun,  1 Sep 2024 18:18:25 +0200
Message-ID: <20240901160830.651902786@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piyush Mehta <piyush.mehta@amd.com>

[ Upstream commit 25d70083351318b44ae699d92c042dcb18a738ea ]

Enabling clock for all the lanes consumes power even PHY is active or
inactive. To resolve this, enable/disable clocks in phy_init/phy_exit.

By default clock is disabled for all the lanes. Whenever phy_init called
from USB, SATA, or display driver, etc. It enabled the required clock
for requested lane. On phy_exit cycle, it disabled clock for the active
PHYs.

During the suspend/resume cycle, each USB/ SATA/ display driver called
phy_exit/phy_init individually. It disabled clock on exit, and enabled
on initialization for the active PHYs.

Signed-off-by: Piyush Mehta <piyush.mehta@amd.com>
Link: https://lore.kernel.org/r/20230613140250.3018947-3-piyush.mehta@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 5af9b304bc60 ("phy: xilinx: phy-zynqmp: Fix SGMII linkup failure on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/xilinx/phy-zynqmp.c | 61 ++++++++-------------------------
 1 file changed, 15 insertions(+), 46 deletions(-)

diff --git a/drivers/phy/xilinx/phy-zynqmp.c b/drivers/phy/xilinx/phy-zynqmp.c
index 964d8087fcf46..a8782aad62ca4 100644
--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -573,6 +573,10 @@ static int xpsgtr_phy_init(struct phy *phy)
 
 	mutex_lock(&gtr_dev->gtr_mutex);
 
+	/* Configure and enable the clock when peripheral phy_init call */
+	if (clk_prepare_enable(gtr_dev->clk[gtr_phy->lane]))
+		goto out;
+
 	/* Skip initialization if not required. */
 	if (!xpsgtr_phy_init_required(gtr_phy))
 		goto out;
@@ -617,9 +621,13 @@ static int xpsgtr_phy_init(struct phy *phy)
 static int xpsgtr_phy_exit(struct phy *phy)
 {
 	struct xpsgtr_phy *gtr_phy = phy_get_drvdata(phy);
+	struct xpsgtr_dev *gtr_dev = gtr_phy->dev;
 
 	gtr_phy->skip_phy_init = false;
 
+	/* Ensure that disable clock only, which configure for lane */
+	clk_disable_unprepare(gtr_dev->clk[gtr_phy->lane]);
+
 	return 0;
 }
 
@@ -825,15 +833,11 @@ static struct phy *xpsgtr_xlate(struct device *dev,
 static int xpsgtr_runtime_suspend(struct device *dev)
 {
 	struct xpsgtr_dev *gtr_dev = dev_get_drvdata(dev);
-	unsigned int i;
 
 	/* Save the snapshot ICM_CFG registers. */
 	gtr_dev->saved_icm_cfg0 = xpsgtr_read(gtr_dev, ICM_CFG0);
 	gtr_dev->saved_icm_cfg1 = xpsgtr_read(gtr_dev, ICM_CFG1);
 
-	for (i = 0; i < ARRAY_SIZE(gtr_dev->clk); i++)
-		clk_disable_unprepare(gtr_dev->clk[i]);
-
 	return 0;
 }
 
@@ -843,13 +847,6 @@ static int xpsgtr_runtime_resume(struct device *dev)
 	unsigned int icm_cfg0, icm_cfg1;
 	unsigned int i;
 	bool skip_phy_init;
-	int err;
-
-	for (i = 0; i < ARRAY_SIZE(gtr_dev->clk); i++) {
-		err = clk_prepare_enable(gtr_dev->clk[i]);
-		if (err)
-			goto err_clk_put;
-	}
 
 	icm_cfg0 = xpsgtr_read(gtr_dev, ICM_CFG0);
 	icm_cfg1 = xpsgtr_read(gtr_dev, ICM_CFG1);
@@ -870,12 +867,6 @@ static int xpsgtr_runtime_resume(struct device *dev)
 		gtr_dev->phys[i].skip_phy_init = skip_phy_init;
 
 	return 0;
-
-err_clk_put:
-	while (i--)
-		clk_disable_unprepare(gtr_dev->clk[i]);
-
-	return err;
 }
 
 static DEFINE_RUNTIME_DEV_PM_OPS(xpsgtr_pm_ops, xpsgtr_runtime_suspend,
@@ -887,7 +878,6 @@ static DEFINE_RUNTIME_DEV_PM_OPS(xpsgtr_pm_ops, xpsgtr_runtime_suspend,
 static int xpsgtr_get_ref_clocks(struct xpsgtr_dev *gtr_dev)
 {
 	unsigned int refclk;
-	int ret;
 
 	for (refclk = 0; refclk < ARRAY_SIZE(gtr_dev->refclk_sscs); ++refclk) {
 		unsigned long rate;
@@ -898,19 +888,14 @@ static int xpsgtr_get_ref_clocks(struct xpsgtr_dev *gtr_dev)
 		snprintf(name, sizeof(name), "ref%u", refclk);
 		clk = devm_clk_get_optional(gtr_dev->dev, name);
 		if (IS_ERR(clk)) {
-			ret = dev_err_probe(gtr_dev->dev, PTR_ERR(clk),
-					    "Failed to get reference clock %u\n",
-					    refclk);
-			goto err_clk_put;
+			return dev_err_probe(gtr_dev->dev, PTR_ERR(clk),
+					     "Failed to get ref clock %u\n",
+					     refclk);
 		}
 
 		if (!clk)
 			continue;
 
-		ret = clk_prepare_enable(clk);
-		if (ret)
-			goto err_clk_put;
-
 		gtr_dev->clk[refclk] = clk;
 
 		/*
@@ -930,18 +915,11 @@ static int xpsgtr_get_ref_clocks(struct xpsgtr_dev *gtr_dev)
 			dev_err(gtr_dev->dev,
 				"Invalid rate %lu for reference clock %u\n",
 				rate, refclk);
-			ret = -EINVAL;
-			goto err_clk_put;
+			return -EINVAL;
 		}
 	}
 
 	return 0;
-
-err_clk_put:
-	while (refclk--)
-		clk_disable_unprepare(gtr_dev->clk[refclk]);
-
-	return ret;
 }
 
 static int xpsgtr_probe(struct platform_device *pdev)
@@ -950,7 +928,6 @@ static int xpsgtr_probe(struct platform_device *pdev)
 	struct xpsgtr_dev *gtr_dev;
 	struct phy_provider *provider;
 	unsigned int port;
-	unsigned int i;
 	int ret;
 
 	gtr_dev = devm_kzalloc(&pdev->dev, sizeof(*gtr_dev), GFP_KERNEL);
@@ -990,8 +967,7 @@ static int xpsgtr_probe(struct platform_device *pdev)
 		phy = devm_phy_create(&pdev->dev, np, &xpsgtr_phyops);
 		if (IS_ERR(phy)) {
 			dev_err(&pdev->dev, "failed to create PHY\n");
-			ret = PTR_ERR(phy);
-			goto err_clk_put;
+			return PTR_ERR(phy);
 		}
 
 		gtr_phy->phy = phy;
@@ -1002,8 +978,7 @@ static int xpsgtr_probe(struct platform_device *pdev)
 	provider = devm_of_phy_provider_register(&pdev->dev, xpsgtr_xlate);
 	if (IS_ERR(provider)) {
 		dev_err(&pdev->dev, "registering provider failed\n");
-		ret = PTR_ERR(provider);
-		goto err_clk_put;
+		return PTR_ERR(provider);
 	}
 
 	pm_runtime_set_active(gtr_dev->dev);
@@ -1012,16 +987,10 @@ static int xpsgtr_probe(struct platform_device *pdev)
 	ret = pm_runtime_resume_and_get(gtr_dev->dev);
 	if (ret < 0) {
 		pm_runtime_disable(gtr_dev->dev);
-		goto err_clk_put;
+		return ret;
 	}
 
 	return 0;
-
-err_clk_put:
-	for (i = 0; i < ARRAY_SIZE(gtr_dev->clk); i++)
-		clk_disable_unprepare(gtr_dev->clk[i]);
-
-	return ret;
 }
 
 static int xpsgtr_remove(struct platform_device *pdev)
-- 
2.43.0



