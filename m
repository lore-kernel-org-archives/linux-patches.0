Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D699226888;
	Mon, 23 Jun 2025 22:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716652; cv=none; b=MWIGyQFjDQ/wi6h3o0TfJrXuE7RgXSmSftqFVitNtajcGpi4h35B0jMgjMtbjgZnXAFYbXUV2EXmbkIfgSzcBTxKf9EJn435dIGNmoHBoPi7GxZuegXu6vvdsFDd2B7rSjWyXi8dByrq1FXD/k6W2GWZ54L6gYB+DEZEmNugRV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716652; c=relaxed/simple;
	bh=3YHIuV9yJG4l9/XpH+n51KMXXUxeMIZi7b3xGVN1ejM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V5UQ31tJ11pjbLmQekzI6nzPmcPq2ublXPZCEfvJODHPg58m9gyGUwxTfSg9zkj9JLZDPDQzJ5ztSMfBylLHIznTtxDjO7IlvHxEDwClNnbt8QWn4Kz4HFmJc2CT9bormiTJJhHZvSbZKVS422ZVY7aatmllnWKb0f4hZSd/hlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wjd3nQyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wjd3nQyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EACC4CEEA;
	Mon, 23 Jun 2025 22:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716652;
	bh=3YHIuV9yJG4l9/XpH+n51KMXXUxeMIZi7b3xGVN1ejM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wjd3nQyZ+reXMuTMobjJ4Y3TM7B7C0PzoEv9W8eT8648aqJfCvll/7zvK4un5c6qU
	 Fr4jgrrkR3+C2Fp/aXI+Z+SW8J8NjTk5n5ifKWSQoEFD09oUstRyiPNXI40WetXvGh
	 72Xw5rsND4LClIrLSydL+gli+nYOQjYgVYArwBRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 272/414] usbnet: asix AX88772: leave the carrier control to phylink
Date: Mon, 23 Jun 2025 15:06:49 +0200
Message-ID: <20250623130648.829089215@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Hałasa <khalasa@piap.pl>

[ Upstream commit 4145f00227ee80f21ab274e9cd9c09758e9bcf3d ]

ASIX AX88772B based USB 10/100 Ethernet adapter doesn't come
up ("carrier off"), despite the built-in 100BASE-FX PHY positive link
indication. The internal PHY is configured (using EEPROM) in fixed
100 Mbps full duplex mode.

The primary problem appears to be using carrier_netif_{on,off}() while,
at the same time, delegating carrier management to phylink. Use only the
latter and remove "manual control" in the asix driver.

I don't have any other AX88772 board here, but the problem doesn't seem
specific to a particular board or settings - it's probably
timing-dependent.

Remove unused asix_adjust_link() as well.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/m3plhmdfte.fsf_-_@t19.piap.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/asix.h         |  1 -
 drivers/net/usb/asix_common.c  | 22 ----------------------
 drivers/net/usb/asix_devices.c | 17 ++++-------------
 3 files changed, 4 insertions(+), 36 deletions(-)

diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
index 74162190bccc1..8531b804021aa 100644
--- a/drivers/net/usb/asix.h
+++ b/drivers/net/usb/asix.h
@@ -224,7 +224,6 @@ int asix_write_rx_ctl(struct usbnet *dev, u16 mode, int in_pm);
 
 u16 asix_read_medium_status(struct usbnet *dev, int in_pm);
 int asix_write_medium_mode(struct usbnet *dev, u16 mode, int in_pm);
-void asix_adjust_link(struct net_device *netdev);
 
 int asix_write_gpio(struct usbnet *dev, u16 value, int sleep, int in_pm);
 
diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index 72ffc89b477ad..7fd763917ae2c 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -414,28 +414,6 @@ int asix_write_medium_mode(struct usbnet *dev, u16 mode, int in_pm)
 	return ret;
 }
 
-/* set MAC link settings according to information from phylib */
-void asix_adjust_link(struct net_device *netdev)
-{
-	struct phy_device *phydev = netdev->phydev;
-	struct usbnet *dev = netdev_priv(netdev);
-	u16 mode = 0;
-
-	if (phydev->link) {
-		mode = AX88772_MEDIUM_DEFAULT;
-
-		if (phydev->duplex == DUPLEX_HALF)
-			mode &= ~AX_MEDIUM_FD;
-
-		if (phydev->speed != SPEED_100)
-			mode &= ~AX_MEDIUM_PS;
-	}
-
-	asix_write_medium_mode(dev, mode, 0);
-	phy_print_status(phydev);
-	usbnet_link_change(dev, phydev->link, 0);
-}
-
 int asix_write_gpio(struct usbnet *dev, u16 value, int sleep, int in_pm)
 {
 	int ret;
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index da24941a6e444..9b0318fb50b55 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -752,7 +752,6 @@ static void ax88772_mac_link_down(struct phylink_config *config,
 	struct usbnet *dev = netdev_priv(to_net_dev(config->dev));
 
 	asix_write_medium_mode(dev, 0, 0);
-	usbnet_link_change(dev, false, false);
 }
 
 static void ax88772_mac_link_up(struct phylink_config *config,
@@ -783,7 +782,6 @@ static void ax88772_mac_link_up(struct phylink_config *config,
 		m |= AX_MEDIUM_RFC;
 
 	asix_write_medium_mode(dev, m, 0);
-	usbnet_link_change(dev, true, false);
 }
 
 static const struct phylink_mac_ops ax88772_phylink_mac_ops = {
@@ -1350,10 +1348,9 @@ static const struct driver_info ax88772_info = {
 	.description = "ASIX AX88772 USB 2.0 Ethernet",
 	.bind = ax88772_bind,
 	.unbind = ax88772_unbind,
-	.status = asix_status,
 	.reset = ax88772_reset,
 	.stop = ax88772_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR | FLAG_MULTI_PACKET,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_MULTI_PACKET,
 	.rx_fixup = asix_rx_fixup_common,
 	.tx_fixup = asix_tx_fixup,
 };
@@ -1362,11 +1359,9 @@ static const struct driver_info ax88772b_info = {
 	.description = "ASIX AX88772B USB 2.0 Ethernet",
 	.bind = ax88772_bind,
 	.unbind = ax88772_unbind,
-	.status = asix_status,
 	.reset = ax88772_reset,
 	.stop = ax88772_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
-	         FLAG_MULTI_PACKET,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_MULTI_PACKET,
 	.rx_fixup = asix_rx_fixup_common,
 	.tx_fixup = asix_tx_fixup,
 	.data = FLAG_EEPROM_MAC,
@@ -1376,11 +1371,9 @@ static const struct driver_info lxausb_t1l_info = {
 	.description = "Linux Automation GmbH USB 10Base-T1L",
 	.bind = ax88772_bind,
 	.unbind = ax88772_unbind,
-	.status = asix_status,
 	.reset = ax88772_reset,
 	.stop = ax88772_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
-		 FLAG_MULTI_PACKET,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_MULTI_PACKET,
 	.rx_fixup = asix_rx_fixup_common,
 	.tx_fixup = asix_tx_fixup,
 	.data = FLAG_EEPROM_MAC,
@@ -1412,10 +1405,8 @@ static const struct driver_info hg20f9_info = {
 	.description = "HG20F9 USB 2.0 Ethernet",
 	.bind = ax88772_bind,
 	.unbind = ax88772_unbind,
-	.status = asix_status,
 	.reset = ax88772_reset,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
-	         FLAG_MULTI_PACKET,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_MULTI_PACKET,
 	.rx_fixup = asix_rx_fixup_common,
 	.tx_fixup = asix_tx_fixup,
 	.data = FLAG_EEPROM_MAC,
-- 
2.39.5



