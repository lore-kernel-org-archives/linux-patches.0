Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9327D2E36E8;
	Tue, 22 Jul 2025 13:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753191982; cv=none; b=hOJf1paA80kh3hmsyUHUQmu0QPlfJDblZrkxYQVTS3HaeEtEF0kRpkrJlam7yESbypOuG9h0Q33khU2v47+YVIUu1IE9axqa3E9OFgrypDLGh0H5RryaixWv+1FUrqGJ/FHpHU2AQwz1nhFByz4lm6Eg8/SNvExZpzDdb9VtdIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753191982; c=relaxed/simple;
	bh=pYe71XyNOxcL9Q4tUg+NlrSaas45/8podPjJGfk4RFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/fDheIq67zQCnT3j5/d3j8G/EtZMALVo8KIE9VSU9sstwRIMT3ABbze5fZitxRSKCkVjeBvNfC/4IshZlvWNraUU5zXllzVBkjIbOFFjemVOul56wK+aiF6HVk7ICj7MepNQCpYba1X4+0KltjmVTgp+fcjujpr3jnahxZj8xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IzKFbPSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IzKFbPSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CCCC4CEEB;
	Tue, 22 Jul 2025 13:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753191982;
	bh=pYe71XyNOxcL9Q4tUg+NlrSaas45/8podPjJGfk4RFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IzKFbPSglFQyY2GDI6zhXy7YjrTwKkqcPnbGld19De6gJZAC2C2yim3k1Iz9bYiIR
	 TbWrV8zgQzMyZPFFrdflUeCj9Crof5Tz7cUxU2W1TCgJQ+/VkpBdClFF/cTFtBdtxc
	 anps2eUZj+22czD7NLsidhX7wegGy6XKfuqfQoaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Chang <waynec@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 01/79] phy: tegra: xusb: Fix unbalanced regulator disable in UTMI PHY mode
Date: Tue, 22 Jul 2025 15:43:57 +0200
Message-ID: <20250722134328.441045784@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit cefc1caee9dd06c69e2d807edc5949b329f52b22 upstream.

When transitioning from USB_ROLE_DEVICE to USB_ROLE_NONE, the code
assumed that the regulator should be disabled. However, if the regulator
is marked as always-on, regulator_is_enabled() continues to return true,
leading to an incorrect attempt to disable a regulator which is not
enabled.

This can result in warnings such as:

[  250.155624] WARNING: CPU: 1 PID: 7326 at drivers/regulator/core.c:3004
_regulator_disable+0xe4/0x1a0
[  250.155652] unbalanced disables for VIN_SYS_5V0

To fix this, we move the regulator control logic into
tegra186_xusb_padctl_id_override() function since it's directly related
to the ID override state. The regulator is now only disabled when the role
transitions from USB_ROLE_HOST to USB_ROLE_NONE, by checking the VBUS_ID
register. This ensures that regulator enable/disable operations are
properly balanced and only occur when actually transitioning to/from host
mode.

Fixes: 49d46e3c7e59 ("phy: tegra: xusb: Add set_mode support for UTMI phy on Tegra186")
Cc: stable@vger.kernel.org
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20250502092606.2275682-1-waynec@nvidia.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/tegra/xusb-tegra186.c |   59 +++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 22 deletions(-)

--- a/drivers/phy/tegra/xusb-tegra186.c
+++ b/drivers/phy/tegra/xusb-tegra186.c
@@ -719,13 +719,15 @@ static int tegra186_xusb_padctl_vbus_ove
 }
 
 static int tegra186_xusb_padctl_id_override(struct tegra_xusb_padctl *padctl,
-					    bool status)
+					    struct tegra_xusb_usb2_port *port, bool status)
 {
-	u32 value;
+	u32 value, id_override;
+	int err = 0;
 
 	dev_dbg(padctl->dev, "%s id override\n", status ? "set" : "clear");
 
 	value = padctl_readl(padctl, USB2_VBUS_ID);
+	id_override = value & ID_OVERRIDE(~0);
 
 	if (status) {
 		if (value & VBUS_OVERRIDE) {
@@ -736,14 +738,34 @@ static int tegra186_xusb_padctl_id_overr
 			value = padctl_readl(padctl, USB2_VBUS_ID);
 		}
 
-		value &= ~ID_OVERRIDE(~0);
-		value |= ID_OVERRIDE_GROUNDED;
+		if (id_override != ID_OVERRIDE_GROUNDED) {
+			value &= ~ID_OVERRIDE(~0);
+			value |= ID_OVERRIDE_GROUNDED;
+			padctl_writel(padctl, value, USB2_VBUS_ID);
+
+			err = regulator_enable(port->supply);
+			if (err) {
+				dev_err(padctl->dev, "Failed to enable regulator: %d\n", err);
+				return err;
+			}
+		}
 	} else {
-		value &= ~ID_OVERRIDE(~0);
-		value |= ID_OVERRIDE_FLOATING;
-	}
+		if (id_override == ID_OVERRIDE_GROUNDED) {
+			/*
+			 * The regulator is disabled only when the role transitions
+			 * from USB_ROLE_HOST to USB_ROLE_NONE.
+			 */
+			err = regulator_disable(port->supply);
+			if (err) {
+				dev_err(padctl->dev, "Failed to disable regulator: %d\n", err);
+				return err;
+			}
 
-	padctl_writel(padctl, value, USB2_VBUS_ID);
+			value &= ~ID_OVERRIDE(~0);
+			value |= ID_OVERRIDE_FLOATING;
+			padctl_writel(padctl, value, USB2_VBUS_ID);
+		}
+	}
 
 	return 0;
 }
@@ -763,27 +785,20 @@ static int tegra186_utmi_phy_set_mode(st
 
 	if (mode == PHY_MODE_USB_OTG) {
 		if (submode == USB_ROLE_HOST) {
-			tegra186_xusb_padctl_id_override(padctl, true);
-
-			err = regulator_enable(port->supply);
+			err = tegra186_xusb_padctl_id_override(padctl, port, true);
+			if (err)
+				goto out;
 		} else if (submode == USB_ROLE_DEVICE) {
 			tegra186_xusb_padctl_vbus_override(padctl, true);
 		} else if (submode == USB_ROLE_NONE) {
-			/*
-			 * When port is peripheral only or role transitions to
-			 * USB_ROLE_NONE from USB_ROLE_DEVICE, regulator is not
-			 * enabled.
-			 */
-			if (regulator_is_enabled(port->supply))
-				regulator_disable(port->supply);
-
-			tegra186_xusb_padctl_id_override(padctl, false);
+			err = tegra186_xusb_padctl_id_override(padctl, port, false);
+			if (err)
+				goto out;
 			tegra186_xusb_padctl_vbus_override(padctl, false);
 		}
 	}
-
+out:
 	mutex_unlock(&padctl->lock);
-
 	return err;
 }
 


