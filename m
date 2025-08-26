Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9789433EAF9;
	Tue, 26 Aug 2025 13:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214197; cv=none; b=dW6817wAE4DKikrsniG0JKp0bs671UAJQ44zy4K7NfTABjeEyD+a0HBS6VZ9VvRuSTOOxbKNdmX8ejwWPJcTJOQGQQwGN0fmtNgbTZ0m39PbWzJfZ6iSvb7gQC7RN6EDJFXUKGeD3CP8bM5v4kGNlIxYKF90eKRMUbjKf47a8T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214197; c=relaxed/simple;
	bh=UFpw/8AlgxjhfZIrFwbUBRUY07q4QIv1XZ/jtoCbll0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezw3TEF3bV9Z82XjuYWyMn7WckTj6FQTf2cj0cuW1xYPt++bx6gLA3KHvxghlcDVKjCztSPB3A0Ik6EA0RDyTZJ9GHeWMluppqTy/s4jRqcMtfzAjbwT58keIRoNB39kLbcLENmpjlGIquwWaKoDF4oQZIqsextNk/66oiG+og0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IGxLaVEA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGxLaVEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2651AC4CEF1;
	Tue, 26 Aug 2025 13:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214197;
	bh=UFpw/8AlgxjhfZIrFwbUBRUY07q4QIv1XZ/jtoCbll0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGxLaVEA8pABKKhT+ZJOP7Lan5IgYMoBLhDlPwzHyEEmVlZal5rapCQZr0ASavZwt
	 U5FHa0BWX9eskO4giiGrMCZXg9vqbopPa3QYRJlYF0ppJ9uPSdUWfw0alQoR3c7TbR
	 ntaYz0rW0WPYKC/KfdKBI0sVYV2QQ/1Hv26esrrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 015/482] net: usb: asix_devices: add phy_mask for ax88772 mdio bus
Date: Tue, 26 Aug 2025 13:04:28 +0200
Message-ID: <20250826110931.163697386@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

commit 4faff70959d51078f9ee8372f8cff0d7045e4114 upstream.

Without setting phy_mask for ax88772 mdio bus, current driver may create
at most 32 mdio phy devices with phy address range from 0x00 ~ 0x1f.
DLink DUB-E100 H/W Ver B1 is such a device. However, only one main phy
device will bind to net phy driver. This is creating issue during system
suspend/resume since phy_polling_mode() in phy_state_machine() will
directly deference member of phydev->drv for non-main phy devices. Then
NULL pointer dereference issue will occur. Due to only external phy or
internal phy is necessary, add phy_mask for ax88772 mdio bus to workarnoud
the issue.

Closes: https://lore.kernel.org/netdev/20250806082931.3289134-1-xu.yang_2@nxp.com
Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20250811092931.860333-1-xu.yang_2@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/asix_devices.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -676,6 +676,7 @@ static int ax88772_init_mdio(struct usbn
 	priv->mdio->read = &asix_mdio_bus_read;
 	priv->mdio->write = &asix_mdio_bus_write;
 	priv->mdio->name = "Asix MDIO Bus";
+	priv->mdio->phy_mask = ~(BIT(priv->phy_addr) | BIT(AX_EMBD_PHY_ADDR));
 	/* mii bus name is usb-<usb bus number>-<usb device number> */
 	snprintf(priv->mdio->id, MII_BUS_ID_SIZE, "usb-%03d:%03d",
 		 dev->udev->bus->busnum, dev->udev->devnum);


