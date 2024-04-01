Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D9143AD6;
	Mon,  1 Apr 2024 15:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986929; cv=none; b=L4Y7RWjGXVS29PB6DnT1Y9vJd5cFljNS+8G8fXRV9OHztuKorz7sY9JneE5PlNWJRuH9m5NX/JktqpINLiYdxJNoofeIFbArh+BhZG5GO1lWOGHAWRUahZ09SyiCmyREIknLDZmN1K3qzHJF6US9AQhQjy6MIpeUzfc+WN/A5vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986929; c=relaxed/simple;
	bh=dXnIzZH4xk8ZrcuWl0LKRS0aNgKTIjoTvw1K0LA3vV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBCEURGZIt2XIp9wvf2iMqDvW2VXIL/+SZcWrcC4OK9pfkXb0oSGkesESaVM9i+cuxlzjgyGjmX8FZ9v8jzahXSSZ0hpJ8bRTdijbDsd1O7Xs9cceAGY/QhXLAqwJVP6Y6xv36iavJ6tzpXDZQfF5MrMB5r6P/ATNOFlz+/tPjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffg1MXXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffg1MXXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1337BC433F1;
	Mon,  1 Apr 2024 15:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986929;
	bh=dXnIzZH4xk8ZrcuWl0LKRS0aNgKTIjoTvw1K0LA3vV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffg1MXXOwHu+SkMT8dZrHso9vPZar3W9wi5uReySL5z0TT7f+BhCsGd4g1XgpKQ4+
	 AGaYU+O5u0LZfNXhtrys/pXbkwiPOCePT3LtN3KHi7CguxPAd7LsgPfebFH0bVf81m
	 vXfUN66RY7tdqM5WVAcipBbS5D5qWS6QMBkZGCnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Chang <waynec@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 129/399] usb: gadget: tegra-xudc: Fix USB3 PHY retrieval logic
Date: Mon,  1 Apr 2024 17:41:35 +0200
Message-ID: <20240401152553.038818603@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Chang <waynec@nvidia.com>

[ Upstream commit 84fa943d93c31ee978355e6c6c69592dae3c9f59 ]

This commit resolves an issue in the tegra-xudc USB gadget driver that
incorrectly fetched USB3 PHY instances. The problem stemmed from the
assumption of a one-to-one correspondence between USB2 and USB3 PHY
names and their association with physical USB ports in the device tree.

Previously, the driver associated USB3 PHY names directly with the USB3
instance number, leading to mismatches when mapping the physical USB
ports. For instance, if using USB3-1 PHY, the driver expect the
corresponding PHY name as 'usb3-1'. However, the physical USB ports in
the device tree were designated as USB2-0 and USB3-0 as we only have
one device controller, causing a misalignment.

This commit rectifies the issue by adjusting the PHY naming logic.
Now, the driver correctly correlates the USB2 and USB3 PHY instances,
allowing the USB2-0 and USB3-1 PHYs to form a physical USB port pair
while accurately reflecting their configuration in the device tree by
naming them USB2-0 and USB3-0, respectively.

The change ensures that the PHY and PHY names align appropriately,
resolving the mismatch between physical USB ports and their associated
names in the device tree.

Fixes: b4e19931c98a ("usb: gadget: tegra-xudc: Support multiple device modes")
Cc: stable@vger.kernel.org
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20240307030328.1487748-3-waynec@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/tegra-xudc.c | 39 ++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/gadget/udc/tegra-xudc.c b/drivers/usb/gadget/udc/tegra-xudc.c
index cb85168fd00c2..7aa46d426f31b 100644
--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -3491,8 +3491,8 @@ static void tegra_xudc_device_params_init(struct tegra_xudc *xudc)
 
 static int tegra_xudc_phy_get(struct tegra_xudc *xudc)
 {
-	int err = 0, usb3;
-	unsigned int i;
+	int err = 0, usb3_companion_port;
+	unsigned int i, j;
 
 	xudc->utmi_phy = devm_kcalloc(xudc->dev, xudc->soc->num_phys,
 					   sizeof(*xudc->utmi_phy), GFP_KERNEL);
@@ -3520,7 +3520,7 @@ static int tegra_xudc_phy_get(struct tegra_xudc *xudc)
 		if (IS_ERR(xudc->utmi_phy[i])) {
 			err = PTR_ERR(xudc->utmi_phy[i]);
 			dev_err_probe(xudc->dev, err,
-				      "failed to get usb2-%d PHY\n", i);
+				"failed to get PHY for phy-name usb2-%d\n", i);
 			goto clean_up;
 		} else if (xudc->utmi_phy[i]) {
 			/* Get usb-phy, if utmi phy is available */
@@ -3539,19 +3539,30 @@ static int tegra_xudc_phy_get(struct tegra_xudc *xudc)
 		}
 
 		/* Get USB3 phy */
-		usb3 = tegra_xusb_padctl_get_usb3_companion(xudc->padctl, i);
-		if (usb3 < 0)
+		usb3_companion_port = tegra_xusb_padctl_get_usb3_companion(xudc->padctl, i);
+		if (usb3_companion_port < 0)
 			continue;
 
-		snprintf(phy_name, sizeof(phy_name), "usb3-%d", usb3);
-		xudc->usb3_phy[i] = devm_phy_optional_get(xudc->dev, phy_name);
-		if (IS_ERR(xudc->usb3_phy[i])) {
-			err = PTR_ERR(xudc->usb3_phy[i]);
-			dev_err_probe(xudc->dev, err,
-				      "failed to get usb3-%d PHY\n", usb3);
-			goto clean_up;
-		} else if (xudc->usb3_phy[i])
-			dev_dbg(xudc->dev, "usb3-%d PHY registered", usb3);
+		for (j = 0; j < xudc->soc->num_phys; j++) {
+			snprintf(phy_name, sizeof(phy_name), "usb3-%d", j);
+			xudc->usb3_phy[i] = devm_phy_optional_get(xudc->dev, phy_name);
+			if (IS_ERR(xudc->usb3_phy[i])) {
+				err = PTR_ERR(xudc->usb3_phy[i]);
+				dev_err_probe(xudc->dev, err,
+					"failed to get PHY for phy-name usb3-%d\n", j);
+				goto clean_up;
+			} else if (xudc->usb3_phy[i]) {
+				int usb2_port =
+					tegra_xusb_padctl_get_port_number(xudc->utmi_phy[i]);
+				int usb3_port =
+					tegra_xusb_padctl_get_port_number(xudc->usb3_phy[i]);
+				if (usb3_port == usb3_companion_port) {
+					dev_dbg(xudc->dev, "USB2 port %d is paired with USB3 port %d for device mode port %d\n",
+					 usb2_port, usb3_port, i);
+					break;
+				}
+			}
+		}
 	}
 
 	return err;
-- 
2.43.0



