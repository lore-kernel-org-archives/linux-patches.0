Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AC747A6B;
	Mon,  1 Apr 2024 17:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990952; cv=none; b=ZBVD5X9yCVPHyIVVD8+Po4BYQZ4ZgQ4emjILFGEFJ/3yEc0lAcudNiLm9n8Yv+pdebDdyyRlnZN32/vsYHiizoAHkx+5NHThSDYvvVcMAW3nYzl/z7plk9tmfoD+EvzyE8zW7n6FWOBmuPRzZf3XAO/ug2Y2r+7KRhoCJ0I+Llo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990952; c=relaxed/simple;
	bh=RfnBzRUoBwZlbxzIXRF3lzdHcDi6KgZVnjKhN0yhO+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmYRxAeNEP18rfzJsqruPnPK6ATD0BIe/VSj7Dl2lz0+dLYmt5lAHQSBW5AlSqGQJnWIEKNhuS7IgMhKZm4cguSZyaVlmvfuBFkqlk3USbf9XHzxKJ5TjjZaYMN0uCqprgX3CwripTFirWJpS+dSNEEVqFTr71sF623GNn8lAzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qatoFXHf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qatoFXHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A566C433F1;
	Mon,  1 Apr 2024 17:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990952;
	bh=RfnBzRUoBwZlbxzIXRF3lzdHcDi6KgZVnjKhN0yhO+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qatoFXHfOXROUTq5nPWUpS3UJmvIG2HS8VCN7ApAz+qYgGzq+Ak2MVs8CHqUqkGsG
	 R4Ak9t5x9myOqB0KkvJhP07uLXju/+um3SLeSFABlx08QqV5RjuY0UqodwOMF4WOW/
	 qoyNTomX3PH2coClvM+w/ncoCiGg7kuQyQ1g/Sh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Chang <waynec@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/272] usb: gadget: tegra-xudc: Fix USB3 PHY retrieval logic
Date: Mon,  1 Apr 2024 17:44:39 +0200
Message-ID: <20240401152533.399687141@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
index a8cadc45c65aa..fd7a9535973ed 100644
--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -3486,8 +3486,8 @@ static void tegra_xudc_device_params_init(struct tegra_xudc *xudc)
 
 static int tegra_xudc_phy_get(struct tegra_xudc *xudc)
 {
-	int err = 0, usb3;
-	unsigned int i;
+	int err = 0, usb3_companion_port;
+	unsigned int i, j;
 
 	xudc->utmi_phy = devm_kcalloc(xudc->dev, xudc->soc->num_phys,
 					   sizeof(*xudc->utmi_phy), GFP_KERNEL);
@@ -3515,7 +3515,7 @@ static int tegra_xudc_phy_get(struct tegra_xudc *xudc)
 		if (IS_ERR(xudc->utmi_phy[i])) {
 			err = PTR_ERR(xudc->utmi_phy[i]);
 			dev_err_probe(xudc->dev, err,
-				      "failed to get usb2-%d PHY\n", i);
+				"failed to get PHY for phy-name usb2-%d\n", i);
 			goto clean_up;
 		} else if (xudc->utmi_phy[i]) {
 			/* Get usb-phy, if utmi phy is available */
@@ -3534,19 +3534,30 @@ static int tegra_xudc_phy_get(struct tegra_xudc *xudc)
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



