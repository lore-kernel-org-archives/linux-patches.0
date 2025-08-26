Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3686FC1D;
	Tue, 26 Aug 2025 12:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212570; cv=none; b=fMO9ZPSu0KRkKXhVYm8rJeWOwIBNScyBmVlonFdUUBZdy69aPBihGo5AIklfyyEFfyBveR3KyBbKW6p9dXECoutl5efE8qRf5+Bu2eydxEV5UqkaL+y1wgkgKNTyq1ekshQQAD/pTDoLHMAc/+XLnKaBrN1Epvg4t3y0gxhyou0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212570; c=relaxed/simple;
	bh=/uy4f2xDZ3NJTGgd2m2QRGOsoN6yW4yZnQOzhpN1dbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+1/JAN71HUDZIHjVdHb+3pTnujXEVZNYizPu8nyejEK+PQlZAMgzvha5tM6FN3Kx/Tmk395Kbt8Q1zfvTaQMSqxycfaTNNbCKmkAWJiNAI0/qFe4tfimgVKO4H6qa3AvP51BvTBePfMF1BdkoUCKuC7G7CCnNFlquUtMRtidb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BImCyuJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BImCyuJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC632C4CEF1;
	Tue, 26 Aug 2025 12:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212570;
	bh=/uy4f2xDZ3NJTGgd2m2QRGOsoN6yW4yZnQOzhpN1dbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BImCyuJcSS0UDvlZohKJ354nfGpXQYhBC0Jst6KskAO0sv9sw7HEJ2dOEspMxuauP
	 5KC14jHjsCJg4dXP7AXdaLs03UqT9rcLCb+FiOY8U78XeL4vloa6R3gENW1IqKX7F9
	 ycYceb/KturNUPWpBGPUb1tZRZGUgVR2EWt1ZlX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 020/587] net: usb: asix_devices: add phy_mask for ax88772 mdio bus
Date: Tue, 26 Aug 2025 13:02:49 +0200
Message-ID: <20250826110953.469903269@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


