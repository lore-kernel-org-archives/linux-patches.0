Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E04B6D17;
	Tue, 22 Jul 2025 14:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193159; cv=none; b=OaKiQQOsMgZM72CUjLYA++776sXGn1dNxmZbGUZNYxb8v2lJ3Dv+wfAowdFgtCWOK4xFMzZ+Q68wKg+r4h6qIft0XgKyZbPkepfIn8xSqTWeEt/VAB/VKkbAtj0G6Hv00pGPNKEFAlTmN/y9alO/QK6Jf2njcPBKixATUE2nDKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193159; c=relaxed/simple;
	bh=3/oZrc267OLhX8qf3htsE+io1qqYA3FqNiXqlW628R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRb7c78kIp5LAzVvMRiEvrnjzNwb4DKHx3prNeqNBHkI6F7hu29a/38z8+IZDxP8qoWrUl+psALTGRsMwwmU4jlt6LZmgw8kLPmoo3jO0ZEZUG5yzmYliU9atVvNd1cp48UNyAtWSy9+nhLPCKJpq6pQBKej3M5qwKWmfoGJdJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxxAV+6Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxxAV+6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919BBC4CEEB;
	Tue, 22 Jul 2025 14:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193159;
	bh=3/oZrc267OLhX8qf3htsE+io1qqYA3FqNiXqlW628R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zxxAV+6YXo3Ldk6pyPGdBaM1ibFetPD+x3CpqW9LM41MyQly2NZRhyilzJ+SvP/Cw
	 G6vvMhe0GKuCW9ev+QZnH4PxfX+p6HRTLKixWoMq0TeZrACXk3w0xxakWhAyyI/LAk
	 NLDpopwdvUyTvvcuVEd6DUpFnR1g+UfGRROJV9S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Chang <waynec@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.15 001/187] phy: tegra: xusb: Fix unbalanced regulator disable in UTMI PHY mode
Date: Tue, 22 Jul 2025 15:42:51 +0200
Message-ID: <20250722134345.816609544@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -782,13 +782,15 @@ static int tegra186_xusb_padctl_vbus_ove
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
@@ -799,14 +801,34 @@ static int tegra186_xusb_padctl_id_overr
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
@@ -826,27 +848,20 @@ static int tegra186_utmi_phy_set_mode(st
 
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
 


