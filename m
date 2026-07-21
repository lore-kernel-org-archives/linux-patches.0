Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4163C6A57;
	Tue, 21 Jul 2026 18:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657349; cv=none; b=XHF5xacd/bj49oozvzM2maUnrlblM04nuVwqXFWJognxtt3UYh/rYpLxoQKbMTyl/syHcPae8Ga/AJHv/0EDpXit8Az7/KI3mkj6ToNZeUgzq5bUxD+DJYLlTkCfgUKNWLsCf0e88RQEmGPH9XIo/kvZStrNJA1+8g0W5S4luYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657349; c=relaxed/simple;
	bh=+PMKb5WaJughbzmwl4qQDvi26mu06Ij9k2O/ogX7kZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYouB8H4yh95AMUfzSszQdfpCF4EiQtgs2M96F9xPCoD0g5bytzqnwC1AqATg+HEQC5t/JqA0Sk+mZ+x8SGIEwdmhdNMYFKr0FJTNFGC4iCKffoZL2R1os034j0gCZlnusOJqgSJFlYbYadUY/FrbgQc8R/sHbOYCMeDwlKmu68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZAyIIBT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZAyIIBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5891F00A3D;
	Tue, 21 Jul 2026 18:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657348;
	bh=nyqK03g4Ro2utYqpaMZjciRuNKqPCyUEmwE0ZbzMBEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZAyIIBTm3rul3zZu8pgbIzHzmoiG8ecqh9Duobgmr104HptZDYqyloSW8X6v3pwR
	 GzDRfG5Ek+2KQdhSdxehtjvTRvxDVSgfbaDvKdseJFtGDzJuG1qQhLo4ddobHI6DHa
	 N3HK1oHOmZroX268lZzrUJzP+MSdJWF9YmwWNlNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Ying <victor.liu@nxp.com>,
	Felix Gu <ustc.gu@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0730/1611] phy: freescale: phy-fsl-imx8qm-lvds-phy: Fix missing pm_runtime_disable() on probe error path
Date: Tue, 21 Jul 2026 17:14:06 +0200
Message-ID: <20260721152531.800705436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 799e7cf2f0b50b34660b5ffce0f7d8dec376a0d5 ]

If mixel_lvds_phy_reset() fails in probe after pm_runtime_enable(),
the function returns directly without calling pm_runtime_disable(),
leaving runtime PM permanently enabled for the device.

Fix this by using devm_pm_runtime_enable() so that cleanup is
automatic on any probe failure or driver unbind. This also allows
removing the manual err label and the .remove callback.

Fixes: 06ff622d61d2 ("phy: freescale: Add i.MX8qm Mixel LVDS PHY support")
Acked-by: Liu Ying <victor.liu@nxp.com>
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260605-lvds-v2-1-3ce7539d1104@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../phy/freescale/phy-fsl-imx8qm-lvds-phy.c   | 24 ++++++-------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/phy/freescale/phy-fsl-imx8qm-lvds-phy.c b/drivers/phy/freescale/phy-fsl-imx8qm-lvds-phy.c
index 7aef2f59e8eb4a..c366d765d6508e 100644
--- a/drivers/phy/freescale/phy-fsl-imx8qm-lvds-phy.c
+++ b/drivers/phy/freescale/phy-fsl-imx8qm-lvds-phy.c
@@ -347,7 +347,9 @@ static int mixel_lvds_phy_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(dev, priv);
 
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
 
 	ret = mixel_lvds_phy_reset(dev);
 	if (ret) {
@@ -357,17 +359,15 @@ static int mixel_lvds_phy_probe(struct platform_device *pdev)
 
 	for (i = 0; i < PHY_NUM; i++) {
 		lvds_phy = devm_kzalloc(dev, sizeof(*lvds_phy), GFP_KERNEL);
-		if (!lvds_phy) {
-			ret = -ENOMEM;
-			goto err;
-		}
+		if (!lvds_phy)
+			return -ENOMEM;
 
 		phy = devm_phy_create(dev, NULL, &mixel_lvds_phy_ops);
 		if (IS_ERR(phy)) {
 			ret = PTR_ERR(phy);
 			dev_err(dev, "failed to create PHY for channel%d: %d\n",
 				i, ret);
-			goto err;
+			return ret;
 		}
 
 		lvds_phy->phy = phy;
@@ -381,19 +381,10 @@ static int mixel_lvds_phy_probe(struct platform_device *pdev)
 	if (IS_ERR(phy_provider)) {
 		ret = PTR_ERR(phy_provider);
 		dev_err(dev, "failed to register PHY provider: %d\n", ret);
-		goto err;
+		return ret;
 	}
 
 	return 0;
-err:
-	pm_runtime_disable(dev);
-
-	return ret;
-}
-
-static void mixel_lvds_phy_remove(struct platform_device *pdev)
-{
-	pm_runtime_disable(&pdev->dev);
 }
 
 static int __maybe_unused mixel_lvds_phy_runtime_suspend(struct device *dev)
@@ -434,7 +425,6 @@ MODULE_DEVICE_TABLE(of, mixel_lvds_phy_of_match);
 
 static struct platform_driver mixel_lvds_phy_driver = {
 	.probe = mixel_lvds_phy_probe,
-	.remove = mixel_lvds_phy_remove,
 	.driver = {
 		.pm = &mixel_lvds_phy_pm_ops,
 		.name = "mixel-lvds-phy",
-- 
2.53.0



