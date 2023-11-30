Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BD154F93;
	Thu, 30 Nov 2023 16:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ih5hJW9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44022C433C8;
	Thu, 30 Nov 2023 16:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361637;
	bh=n1iI7QZjOXlSBMYafIXom3N2vOcnFTSaQTPPieQEYOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ih5hJW9OEHF4AaHZlGk3JfWxVyMshgh2cpapmq9I4sul1ByDuxqq4kyr5OIHeVBED
	 RClcCppBIvNISXlkvmHSmlN0UuFO3VAF0tswP6K08wjaLhLNYIR0D1nquE8nBB0Jcf
	 IjSDdEilmrHPOPnTEu0ITUxkxfh7agJwjH4SaH7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Stanley Chang <stanley_chang@realtek.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>
Subject: [PATCH 6.6 100/112] USB: xhci-plat: fix legacy PHY double init
Date: Thu, 30 Nov 2023 16:22:27 +0000
Message-ID: <20231130162143.476052654@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 16b7e0cccb243033de4406ffb4d892365041a1e7 upstream.

Commits 7b8ef22ea547 ("usb: xhci: plat: Add USB phy support") and
9134c1fd0503 ("usb: xhci: plat: Add USB 3.0 phy support") added support
for looking up legacy PHYs from the sysdev devicetree node and
initialising them.

This broke drivers such as dwc3 which manages PHYs themself as the PHYs
would now be initialised twice, something which specifically can lead to
resources being left enabled during suspend (e.g. with the
usb_phy_generic PHY driver).

As the dwc3 driver uses driver-name matching for the xhci platform
device, fix this by only looking up and initialising PHYs for devices
that have been matched using OF.

Note that checking that the platform device has a devicetree node would
currently be sufficient, but that could lead to subtle breakages in case
anyone ever tries to reuse an ancestor's node.

Fixes: 7b8ef22ea547 ("usb: xhci: plat: Add USB phy support")
Fixes: 9134c1fd0503 ("usb: xhci: plat: Add USB 3.0 phy support")
Cc: stable@vger.kernel.org      # 4.1
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Stanley Chang <stanley_chang@realtek.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Tested-by: Stanley Chang <stanley_chang@realtek.com>
Link: https://lore.kernel.org/r/20231103164323.14294-1-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-plat.c |   50 +++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 20 deletions(-)

--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/usb/phy.h>
 #include <linux/slab.h>
@@ -148,7 +149,7 @@ int xhci_plat_probe(struct platform_devi
 	int			ret;
 	int			irq;
 	struct xhci_plat_priv	*priv = NULL;
-
+	bool			of_match;
 
 	if (usb_disabled())
 		return -ENODEV;
@@ -253,16 +254,23 @@ int xhci_plat_probe(struct platform_devi
 					 &xhci->imod_interval);
 	}
 
-	hcd->usb_phy = devm_usb_get_phy_by_phandle(sysdev, "usb-phy", 0);
-	if (IS_ERR(hcd->usb_phy)) {
-		ret = PTR_ERR(hcd->usb_phy);
-		if (ret == -EPROBE_DEFER)
-			goto disable_clk;
-		hcd->usb_phy = NULL;
-	} else {
-		ret = usb_phy_init(hcd->usb_phy);
-		if (ret)
-			goto disable_clk;
+	/*
+	 * Drivers such as dwc3 manages PHYs themself (and rely on driver name
+	 * matching for the xhci platform device).
+	 */
+	of_match = of_match_device(pdev->dev.driver->of_match_table, &pdev->dev);
+	if (of_match) {
+		hcd->usb_phy = devm_usb_get_phy_by_phandle(sysdev, "usb-phy", 0);
+		if (IS_ERR(hcd->usb_phy)) {
+			ret = PTR_ERR(hcd->usb_phy);
+			if (ret == -EPROBE_DEFER)
+				goto disable_clk;
+			hcd->usb_phy = NULL;
+		} else {
+			ret = usb_phy_init(hcd->usb_phy);
+			if (ret)
+				goto disable_clk;
+		}
 	}
 
 	hcd->tpl_support = of_usb_host_tpl_support(sysdev->of_node);
@@ -285,15 +293,17 @@ int xhci_plat_probe(struct platform_devi
 			goto dealloc_usb2_hcd;
 		}
 
-		xhci->shared_hcd->usb_phy = devm_usb_get_phy_by_phandle(sysdev,
-			    "usb-phy", 1);
-		if (IS_ERR(xhci->shared_hcd->usb_phy)) {
-			xhci->shared_hcd->usb_phy = NULL;
-		} else {
-			ret = usb_phy_init(xhci->shared_hcd->usb_phy);
-			if (ret)
-				dev_err(sysdev, "%s init usb3phy fail (ret=%d)\n",
-					    __func__, ret);
+		if (of_match) {
+			xhci->shared_hcd->usb_phy = devm_usb_get_phy_by_phandle(sysdev,
+										"usb-phy", 1);
+			if (IS_ERR(xhci->shared_hcd->usb_phy)) {
+				xhci->shared_hcd->usb_phy = NULL;
+			} else {
+				ret = usb_phy_init(xhci->shared_hcd->usb_phy);
+				if (ret)
+					dev_err(sysdev, "%s init usb3phy fail (ret=%d)\n",
+						__func__, ret);
+			}
 		}
 
 		xhci->shared_hcd->tpl_support = hcd->tpl_support;


