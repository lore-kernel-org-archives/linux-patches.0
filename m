Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D1A186E43;
	Sun,  1 Sep 2024 16:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209218; cv=none; b=UH7L/Yw+PFNcO8hFwMRSo4kib8a7xsMxYqVjdOB06Pestxiklt8p5776zKkMfwIwQ3u1viTcwmkoLW9sVtNCygtWdr0LoSNH3U/KvqfHQqeyw1lgfpQVrlgYtzTkVN//632qxaRs3wlAd23qm6VFeQ88NDSl35YHsQih5JRvqWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209218; c=relaxed/simple;
	bh=20eS1IvRcBjFhIP3bEYHLBbx32KM6nBANUDOiMJoWPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMigO96kqLSxeKtFIy3YhCOLKM393rsZJVjXBb6/+4t1KhshdyN0dVX7rbqhoo5cwHTl/puFfqmxZCIV07KofbTkusMwRsSRh2P+MhbipWY8QqnFD25MgY26cslK33Dwlh9yJ9f931hzjtmW10C18IzB1o73zdgFd7F92PMp1g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCq5y1YB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCq5y1YB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0286AC4CEC3;
	Sun,  1 Sep 2024 16:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209218;
	bh=20eS1IvRcBjFhIP3bEYHLBbx32KM6nBANUDOiMJoWPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCq5y1YBzQvjXtzuLh7fUl+qklBbRD0I2yuYtsssMHzNEcDKEur26Mbowrqs2o5L3
	 xoV4T8yk2gEPzhVAreUMV9OyX0P31O9XM5SLG90XR+LI+RKvqlKRcNK31NJTKIOGnB
	 fCgkw3QgAS6Xv7DJxj8o9wCbq5cP4XZ9K94+DnW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piyush Mehta <piyush.mehta@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 37/71] phy: xilinx: add runtime PM support
Date: Sun,  1 Sep 2024 18:17:42 +0200
Message-ID: <20240901160803.292752837@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piyush Mehta <piyush.mehta@amd.com>

[ Upstream commit b3db66f624468ab4a0385586bc7f4221e477d6b2 ]

Added Runtime power management support to the xilinx phy driver and using
DEFINE_RUNTIME_DEV_PM_OPS new macros allows the compiler to remove the
unused dev_pm_ops structure and related functions if !CONFIG_PM without
the need to mark the functions __maybe_unused.

Signed-off-by: Piyush Mehta <piyush.mehta@amd.com>
Link: https://lore.kernel.org/r/20230613140250.3018947-2-piyush.mehta@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 5af9b304bc60 ("phy: xilinx: phy-zynqmp: Fix SGMII linkup failure on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/xilinx/phy-zynqmp.c | 35 ++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/phy/xilinx/phy-zynqmp.c b/drivers/phy/xilinx/phy-zynqmp.c
index 9be9535ad7ab7..964d8087fcf46 100644
--- a/drivers/phy/xilinx/phy-zynqmp.c
+++ b/drivers/phy/xilinx/phy-zynqmp.c
@@ -21,6 +21,7 @@
 #include <linux/of.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/slab.h>
 
 #include <dt-bindings/phy/phy.h>
@@ -821,7 +822,7 @@ static struct phy *xpsgtr_xlate(struct device *dev,
  * Power Management
  */
 
-static int __maybe_unused xpsgtr_suspend(struct device *dev)
+static int xpsgtr_runtime_suspend(struct device *dev)
 {
 	struct xpsgtr_dev *gtr_dev = dev_get_drvdata(dev);
 	unsigned int i;
@@ -836,7 +837,7 @@ static int __maybe_unused xpsgtr_suspend(struct device *dev)
 	return 0;
 }
 
-static int __maybe_unused xpsgtr_resume(struct device *dev)
+static int xpsgtr_runtime_resume(struct device *dev)
 {
 	struct xpsgtr_dev *gtr_dev = dev_get_drvdata(dev);
 	unsigned int icm_cfg0, icm_cfg1;
@@ -877,10 +878,8 @@ static int __maybe_unused xpsgtr_resume(struct device *dev)
 	return err;
 }
 
-static const struct dev_pm_ops xpsgtr_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(xpsgtr_suspend, xpsgtr_resume)
-};
-
+static DEFINE_RUNTIME_DEV_PM_OPS(xpsgtr_pm_ops, xpsgtr_runtime_suspend,
+				 xpsgtr_runtime_resume, NULL);
 /*
  * Probe & Platform Driver
  */
@@ -1006,6 +1005,16 @@ static int xpsgtr_probe(struct platform_device *pdev)
 		ret = PTR_ERR(provider);
 		goto err_clk_put;
 	}
+
+	pm_runtime_set_active(gtr_dev->dev);
+	pm_runtime_enable(gtr_dev->dev);
+
+	ret = pm_runtime_resume_and_get(gtr_dev->dev);
+	if (ret < 0) {
+		pm_runtime_disable(gtr_dev->dev);
+		goto err_clk_put;
+	}
+
 	return 0;
 
 err_clk_put:
@@ -1015,6 +1024,17 @@ static int xpsgtr_probe(struct platform_device *pdev)
 	return ret;
 }
 
+static int xpsgtr_remove(struct platform_device *pdev)
+{
+	struct xpsgtr_dev *gtr_dev = platform_get_drvdata(pdev);
+
+	pm_runtime_disable(gtr_dev->dev);
+	pm_runtime_put_noidle(gtr_dev->dev);
+	pm_runtime_set_suspended(gtr_dev->dev);
+
+	return 0;
+}
+
 static const struct of_device_id xpsgtr_of_match[] = {
 	{ .compatible = "xlnx,zynqmp-psgtr", },
 	{ .compatible = "xlnx,zynqmp-psgtr-v1.1", },
@@ -1024,10 +1044,11 @@ MODULE_DEVICE_TABLE(of, xpsgtr_of_match);
 
 static struct platform_driver xpsgtr_driver = {
 	.probe = xpsgtr_probe,
+	.remove	= xpsgtr_remove,
 	.driver = {
 		.name = "xilinx-psgtr",
 		.of_match_table	= xpsgtr_of_match,
-		.pm =  &xpsgtr_pm_ops,
+		.pm =  pm_ptr(&xpsgtr_pm_ops),
 	},
 };
 
-- 
2.43.0



