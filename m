Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D8B1DA4C;
	Tue, 10 Sep 2024 10:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965158; cv=none; b=ZtshzUxXCwYt9a/Bewbm576WfX83iihzc+Rnfkh55R8ezzg223AogQcUP4baE9lshed1b6wjx52GF/ZgotkHoYwB+Ia2GxEEZD2pZ+TGwjAh9ErECeiTXtbpKfVQMe5RuoQQCTK3TrLAlx3ck/sAl8PmUTzKOt9taP4NUeW9oO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965158; c=relaxed/simple;
	bh=Ee2qPGsf4k2If/216VbpP0er17voOAdctm64G9Uoleg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hhq5v0qZ0pwt8SpzBDGnheHFLDdZOKF9Mwqi4YgUDos4uznAXvQ/ozXNWVkX2+ERuL/iMnKn/dBtkU6cu+BnPQZNLrF+vHn7hBW4qW8oe7l/k5i23bts3yS7c3jmPqIR402ne15IyTMpvfw+Av4YhgHa+Vsa6b4RTq+C0xif3D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1BzVZ6u6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1BzVZ6u6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D526C4CEC3;
	Tue, 10 Sep 2024 10:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965157;
	bh=Ee2qPGsf4k2If/216VbpP0er17voOAdctm64G9Uoleg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1BzVZ6u6uUg0B6n+5nevNHyd90hI6Dj7UBN1zlB6yW3BNwYbmQYYM1VqbJrjUJLeU
	 +9cfNGG19oEIUsRwTbPBC+yZcY1nSoZ44zCA7+0pFx1BCWWCGG+aOcVtimOOV3lcy5
	 b6wSlB31s4bvrrk9qDhUOdDQeMge1Abx1qWnt8lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/186] net: usb: dont write directly to netdev->dev_addr
Date: Tue, 10 Sep 2024 11:33:34 +0200
Message-ID: <20240910092559.477267772@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 2674e7ea22ba0e22a2d1603bd51e0b8f6442a267 ]

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Manually fix all net/usb drivers without separate maintainers.

v2: catc does DMA to the buffer, leave the conversion to Oliver

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: bab8eb0dd4cb ("usbnet: modern method to get random MAC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/ch9200.c      | 4 +++-
 drivers/net/usb/cx82310_eth.c | 5 +++--
 drivers/net/usb/kaweth.c      | 3 +--
 drivers/net/usb/mcs7830.c     | 4 +++-
 drivers/net/usb/sierra_net.c  | 6 ++++--
 drivers/net/usb/sr9700.c      | 4 +++-
 drivers/net/usb/sr9800.c      | 5 +++--
 drivers/net/usb/usbnet.c      | 6 ++++--
 8 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/net/usb/ch9200.c b/drivers/net/usb/ch9200.c
index d7f3b70d5477..f69d9b902da0 100644
--- a/drivers/net/usb/ch9200.c
+++ b/drivers/net/usb/ch9200.c
@@ -336,6 +336,7 @@ static int ch9200_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	int retval = 0;
 	unsigned char data[2];
+	u8 addr[ETH_ALEN];
 
 	retval = usbnet_get_endpoints(dev, intf);
 	if (retval)
@@ -383,7 +384,8 @@ static int ch9200_bind(struct usbnet *dev, struct usb_interface *intf)
 	retval = control_write(dev, REQUEST_WRITE, 0, MAC_REG_CTRL, data, 0x02,
 			       CONTROL_TIMEOUT_MS);
 
-	retval = get_mac_address(dev, dev->net->dev_addr);
+	retval = get_mac_address(dev, addr);
+	eth_hw_addr_set(dev->net, addr);
 
 	return retval;
 }
diff --git a/drivers/net/usb/cx82310_eth.c b/drivers/net/usb/cx82310_eth.c
index c4568a491dc4..79a47e2fd437 100644
--- a/drivers/net/usb/cx82310_eth.c
+++ b/drivers/net/usb/cx82310_eth.c
@@ -146,6 +146,7 @@ static int cx82310_bind(struct usbnet *dev, struct usb_interface *intf)
 	u8 link[3];
 	int timeout = 50;
 	struct cx82310_priv *priv;
+	u8 addr[ETH_ALEN];
 
 	/* avoid ADSL modems - continue only if iProduct is "USB NET CARD" */
 	if (usb_string(udev, udev->descriptor.iProduct, buf, sizeof(buf)) > 0
@@ -202,12 +203,12 @@ static int cx82310_bind(struct usbnet *dev, struct usb_interface *intf)
 		goto err;
 
 	/* get the MAC address */
-	ret = cx82310_cmd(dev, CMD_GET_MAC_ADDR, true, NULL, 0,
-			  dev->net->dev_addr, ETH_ALEN);
+	ret = cx82310_cmd(dev, CMD_GET_MAC_ADDR, true, NULL, 0, addr, ETH_ALEN);
 	if (ret) {
 		netdev_err(dev->net, "unable to read MAC address: %d\n", ret);
 		goto err;
 	}
+	eth_hw_addr_set(dev->net, addr);
 
 	/* start (does not seem to have any effect?) */
 	ret = cx82310_cmd(dev, CMD_START, false, NULL, 0, NULL, 0);
diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index 144c686b4333..9b2bc1993ece 100644
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -1044,8 +1044,7 @@ static int kaweth_probe(
 		goto err_all_but_rxbuf;
 
 	memcpy(netdev->broadcast, &bcast_addr, sizeof(bcast_addr));
-	memcpy(netdev->dev_addr, &kaweth->configuration.hw_addr,
-               sizeof(kaweth->configuration.hw_addr));
+	eth_hw_addr_set(netdev, (u8 *)&kaweth->configuration.hw_addr);
 
 	netdev->netdev_ops = &kaweth_netdev_ops;
 	netdev->watchdog_timeo = KAWETH_TX_TIMEOUT;
diff --git a/drivers/net/usb/mcs7830.c b/drivers/net/usb/mcs7830.c
index 7e40e2e2f372..57281296ba2c 100644
--- a/drivers/net/usb/mcs7830.c
+++ b/drivers/net/usb/mcs7830.c
@@ -480,17 +480,19 @@ static const struct net_device_ops mcs7830_netdev_ops = {
 static int mcs7830_bind(struct usbnet *dev, struct usb_interface *udev)
 {
 	struct net_device *net = dev->net;
+	u8 addr[ETH_ALEN];
 	int ret;
 	int retry;
 
 	/* Initial startup: Gather MAC address setting from EEPROM */
 	ret = -EINVAL;
 	for (retry = 0; retry < 5 && ret; retry++)
-		ret = mcs7830_hif_get_mac_address(dev, net->dev_addr);
+		ret = mcs7830_hif_get_mac_address(dev, addr);
 	if (ret) {
 		dev_warn(&dev->udev->dev, "Cannot read MAC address\n");
 		goto out;
 	}
+	eth_hw_addr_set(net, addr);
 
 	mcs7830_data_set_multicast(net);
 
diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index 0abd257b634c..777f672f288c 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -669,6 +669,7 @@ static int sierra_net_bind(struct usbnet *dev, struct usb_interface *intf)
 		0x00, 0x00, SIERRA_NET_HIP_MSYNC_ID, 0x00};
 	static const u8 shdwn_tmplate[sizeof(priv->shdwn_msg)] = {
 		0x00, 0x00, SIERRA_NET_HIP_SHUTD_ID, 0x00};
+	u8 mod[2];
 
 	dev_dbg(&dev->udev->dev, "%s", __func__);
 
@@ -698,8 +699,9 @@ static int sierra_net_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->net->netdev_ops = &sierra_net_device_ops;
 
 	/* change MAC addr to include, ifacenum, and to be unique */
-	dev->net->dev_addr[ETH_ALEN-2] = atomic_inc_return(&iface_counter);
-	dev->net->dev_addr[ETH_ALEN-1] = ifacenum;
+	mod[0] = atomic_inc_return(&iface_counter);
+	mod[1] = ifacenum;
+	dev_addr_mod(dev->net, ETH_ALEN - 2, mod, 2);
 
 	/* prepare shutdown message template */
 	memcpy(priv->shdwn_msg, shdwn_tmplate, sizeof(priv->shdwn_msg));
diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index 8d2e3daf03cf..1ec11a08820d 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -326,6 +326,7 @@ static int sr9700_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	struct net_device *netdev;
 	struct mii_if_info *mii;
+	u8 addr[ETH_ALEN];
 	int ret;
 
 	ret = usbnet_get_endpoints(dev, intf);
@@ -356,11 +357,12 @@ static int sr9700_bind(struct usbnet *dev, struct usb_interface *intf)
 	 * EEPROM automatically to PAR. In case there is no EEPROM externally,
 	 * a default MAC address is stored in PAR for making chip work properly.
 	 */
-	if (sr_read(dev, SR_PAR, ETH_ALEN, netdev->dev_addr) < 0) {
+	if (sr_read(dev, SR_PAR, ETH_ALEN, addr) < 0) {
 		netdev_err(netdev, "Error reading MAC address\n");
 		ret = -ENODEV;
 		goto out;
 	}
+	eth_hw_addr_set(netdev, addr);
 
 	/* power up and reset phy */
 	sr_write_reg(dev, SR_PRR, PRR_PHY_RST);
diff --git a/drivers/net/usb/sr9800.c b/drivers/net/usb/sr9800.c
index a5332e99102a..351e0edcda2a 100644
--- a/drivers/net/usb/sr9800.c
+++ b/drivers/net/usb/sr9800.c
@@ -731,6 +731,7 @@ static int sr9800_bind(struct usbnet *dev, struct usb_interface *intf)
 	struct sr_data *data = (struct sr_data *)&dev->data;
 	u16 led01_mux, led23_mux;
 	int ret, embd_phy;
+	u8 addr[ETH_ALEN];
 	u32 phyid;
 	u16 rx_ctl;
 
@@ -756,12 +757,12 @@ static int sr9800_bind(struct usbnet *dev, struct usb_interface *intf)
 	}
 
 	/* Get the MAC address */
-	ret = sr_read_cmd(dev, SR_CMD_READ_NODE_ID, 0, 0, ETH_ALEN,
-			  dev->net->dev_addr);
+	ret = sr_read_cmd(dev, SR_CMD_READ_NODE_ID, 0, 0, ETH_ALEN, addr);
 	if (ret < 0) {
 		netdev_dbg(dev->net, "Failed to read MAC address: %d\n", ret);
 		return ret;
 	}
+	eth_hw_addr_set(dev->net, addr);
 	netdev_dbg(dev->net, "mac addr : %pM\n", dev->net->dev_addr);
 
 	/* Initialize MII structure */
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 01f80aea1605..e87d3108ef05 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -148,12 +148,13 @@ EXPORT_SYMBOL_GPL(usbnet_get_endpoints);
 
 int usbnet_get_ethernet_addr(struct usbnet *dev, int iMACAddress)
 {
+	u8		addr[ETH_ALEN];
 	int 		tmp = -1, ret;
 	unsigned char	buf [13];
 
 	ret = usb_string(dev->udev, iMACAddress, buf, sizeof buf);
 	if (ret == 12)
-		tmp = hex2bin(dev->net->dev_addr, buf, 6);
+		tmp = hex2bin(addr, buf, 6);
 	if (tmp < 0) {
 		dev_dbg(&dev->udev->dev,
 			"bad MAC string %d fetch, %d\n", iMACAddress, tmp);
@@ -161,6 +162,7 @@ int usbnet_get_ethernet_addr(struct usbnet *dev, int iMACAddress)
 			ret = -EINVAL;
 		return ret;
 	}
+	eth_hw_addr_set(dev->net, addr);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(usbnet_get_ethernet_addr);
@@ -1694,7 +1696,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 
 	dev->net = net;
 	strscpy(net->name, "usb%d", sizeof(net->name));
-	memcpy (net->dev_addr, node_id, sizeof node_id);
+	eth_hw_addr_set(net, node_id);
 
 	/* rx and tx sides can use different message sizes;
 	 * bind() should set rx_urb_size in that case.
-- 
2.43.0



