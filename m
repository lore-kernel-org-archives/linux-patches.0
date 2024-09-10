Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D917E18A6D1;
	Tue, 10 Sep 2024 09:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961142; cv=none; b=PSJJ5UetJzCeh64t83MwQmQoNnd+Q98a7BruotxR4QMhUgoAiY8G1/8l1pPvcZ0V2WPOlLzKJ3CUEHbI0WjoiE6Tza/+X78lUYHbx0xEFVfSKRrosyREDHJBTCoYJi8VAShzkJMqlR5uuLlZgN6Z3HxWlmYQ5g5T22uZCcCg9Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961142; c=relaxed/simple;
	bh=3VddG/ko3tKJf5GwCDhOhyTdmSdsx/hnQaN+el5pv7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTgrynPlmeV7R/zl0SgJm3U8tz4d5P9VtbEpyL4PVaNykFq85Y/WpptbxzicCc/KCTkaCGlFl1D6wyzr5bpQPvjs54o+d6UXBmXdYT2e3Xt9nd584R2RM2OYl+4dvEZMgWqF8+bSPmFJFwIi1VI+oqGlRv9+Xl44Nuikpq7UKq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2K4B6mU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2K4B6mU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603D9C4CEC3;
	Tue, 10 Sep 2024 09:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961142;
	bh=3VddG/ko3tKJf5GwCDhOhyTdmSdsx/hnQaN+el5pv7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2K4B6mUO5Kt4NA+QzHPaojZLoc26xr1J70isM72nlmzQTzONIPKVTsuhNmeYt782
	 U9m4uk6/0SFY+ZaWw4oc8jmgDS0U/mk/FjoHXYYzWV8Qfs1XqriIq+7xBoB4FK+r6l
	 vNT9IGs9LEDmK/AEPom2z79St1VT0mIl1ztkAp88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/96] net: usb: dont write directly to netdev->dev_addr
Date: Tue, 10 Sep 2024 11:31:42 +0200
Message-ID: <20240910092543.292446577@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 9df3c1ffff35..6ed8da85b081 100644
--- a/drivers/net/usb/ch9200.c
+++ b/drivers/net/usb/ch9200.c
@@ -338,6 +338,7 @@ static int ch9200_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	int retval = 0;
 	unsigned char data[2];
+	u8 addr[ETH_ALEN];
 
 	retval = usbnet_get_endpoints(dev, intf);
 	if (retval)
@@ -385,7 +386,8 @@ static int ch9200_bind(struct usbnet *dev, struct usb_interface *intf)
 	retval = control_write(dev, REQUEST_WRITE, 0, MAC_REG_CTRL, data, 0x02,
 			       CONTROL_TIMEOUT_MS);
 
-	retval = get_mac_address(dev, dev->net->dev_addr);
+	retval = get_mac_address(dev, addr);
+	eth_hw_addr_set(dev->net, addr);
 
 	return retval;
 }
diff --git a/drivers/net/usb/cx82310_eth.c b/drivers/net/usb/cx82310_eth.c
index 6a9a5e540b09..2efa33eb1f73 100644
--- a/drivers/net/usb/cx82310_eth.c
+++ b/drivers/net/usb/cx82310_eth.c
@@ -161,6 +161,7 @@ static int cx82310_bind(struct usbnet *dev, struct usb_interface *intf)
 	u8 link[3];
 	int timeout = 50;
 	struct cx82310_priv *priv;
+	u8 addr[ETH_ALEN];
 
 	/* avoid ADSL modems - continue only if iProduct is "USB NET CARD" */
 	if (usb_string(udev, udev->descriptor.iProduct, buf, sizeof(buf)) > 0
@@ -216,12 +217,12 @@ static int cx82310_bind(struct usbnet *dev, struct usb_interface *intf)
 		goto err;
 
 	/* get the MAC address */
-	ret = cx82310_cmd(dev, CMD_GET_MAC_ADDR, true, NULL, 0,
-			  dev->net->dev_addr, ETH_ALEN);
+	ret = cx82310_cmd(dev, CMD_GET_MAC_ADDR, true, NULL, 0, addr, ETH_ALEN);
 	if (ret) {
 		dev_err(&udev->dev, "unable to read MAC address: %d\n", ret);
 		goto err;
 	}
+	eth_hw_addr_set(dev->net, addr);
 
 	/* start (does not seem to have any effect?) */
 	ret = cx82310_cmd(dev, CMD_START, false, NULL, 0, NULL, 0);
diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index 913e50bab0a2..b05154fad3ce 100644
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -1139,8 +1139,7 @@ static int kaweth_probe(
 		goto err_all_but_rxbuf;
 
 	memcpy(netdev->broadcast, &bcast_addr, sizeof(bcast_addr));
-	memcpy(netdev->dev_addr, &kaweth->configuration.hw_addr,
-               sizeof(kaweth->configuration.hw_addr));
+	eth_hw_addr_set(netdev, (u8 *)&kaweth->configuration.hw_addr);
 
 	netdev->netdev_ops = &kaweth_netdev_ops;
 	netdev->watchdog_timeo = KAWETH_TX_TIMEOUT;
diff --git a/drivers/net/usb/mcs7830.c b/drivers/net/usb/mcs7830.c
index c0f52a622964..c304ce4abaa4 100644
--- a/drivers/net/usb/mcs7830.c
+++ b/drivers/net/usb/mcs7830.c
@@ -493,17 +493,19 @@ static const struct net_device_ops mcs7830_netdev_ops = {
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
index c43087e06696..4226ad0f11f3 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -686,6 +686,7 @@ static int sierra_net_bind(struct usbnet *dev, struct usb_interface *intf)
 		0x00, 0x00, SIERRA_NET_HIP_MSYNC_ID, 0x00};
 	static const u8 shdwn_tmplate[sizeof(priv->shdwn_msg)] = {
 		0x00, 0x00, SIERRA_NET_HIP_SHUTD_ID, 0x00};
+	u8 mod[2];
 
 	dev_dbg(&dev->udev->dev, "%s", __func__);
 
@@ -715,8 +716,9 @@ static int sierra_net_bind(struct usbnet *dev, struct usb_interface *intf)
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
index 1f11c56ccd5c..1f4b2fabb5e6 100644
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
index a5ff7df10505..485a50d9f281 100644
--- a/drivers/net/usb/sr9800.c
+++ b/drivers/net/usb/sr9800.c
@@ -732,6 +732,7 @@ static int sr9800_bind(struct usbnet *dev, struct usb_interface *intf)
 	struct sr_data *data = (struct sr_data *)&dev->data;
 	u16 led01_mux, led23_mux;
 	int ret, embd_phy;
+	u8 addr[ETH_ALEN];
 	u32 phyid;
 	u16 rx_ctl;
 
@@ -757,12 +758,12 @@ static int sr9800_bind(struct usbnet *dev, struct usb_interface *intf)
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
index 8065af844410..16225654d88c 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -163,12 +163,13 @@ EXPORT_SYMBOL_GPL(usbnet_get_endpoints);
 
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
@@ -176,6 +177,7 @@ int usbnet_get_ethernet_addr(struct usbnet *dev, int iMACAddress)
 			ret = -EINVAL;
 		return ret;
 	}
+	eth_hw_addr_set(dev->net, addr);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(usbnet_get_ethernet_addr);
@@ -1723,7 +1725,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 
 	dev->net = net;
 	strscpy(net->name, "usb%d", sizeof(net->name));
-	memcpy (net->dev_addr, node_id, sizeof node_id);
+	eth_hw_addr_set(net, node_id);
 
 	/* rx and tx sides can use different message sizes;
 	 * bind() should set rx_urb_size in that case.
-- 
2.43.0



