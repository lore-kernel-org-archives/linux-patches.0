Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1D7DDB1;
	Thu, 13 Jun 2024 11:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278991; cv=none; b=jUwOXY1ijv5A+/k195IQz0eulJInp75p0h3xPzQXrR72vFZkm2flqbV2RoVyJ3tvbY0yv3UlS00S5509V/0ZUX8gDd6NHPRMKZkP0kVwcNVfVp0ssEWm6kQONnFvtzN8cOvbKzHT7ahipFp5MBDOpcscudYQB20ZIDf3ax5qIX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278991; c=relaxed/simple;
	bh=ao1WvIM8ZSh6HpOsGFmFpPbgLinQDLxVaCBtVEIa/10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+axc+PCSnP2Uqwo4jT31UIwQQF9YeifNJWtgYGb7OjwLTG4LKPE8/UIWbIWovX4mPbzAccBaz/wJ5+uZ9/GPhvJL25sFnnWmweyQzb6kFUkxvU8PK8WwMl6XAJrVU4VOl6x3enwBE1UOe7ZfExHbqXgCVuJfS5AOIpBeX2vpZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fzy5ooOE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fzy5ooOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D08C2BBFC;
	Thu, 13 Jun 2024 11:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278990;
	bh=ao1WvIM8ZSh6HpOsGFmFpPbgLinQDLxVaCBtVEIa/10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fzy5ooOEfqlLfsMfAQZRY0D8BWsPzg1UwCin90ovNxjxujnH5Y3hs7wQ7c8vY6uJU
	 l/w58xWg4PQ3V9ywkUwcJsV1gk6E1HB8z/HXNJBzabBM2hURYDXfX9Ek/p8BvcLX+y
	 o9t9FHs9ps+jmlqNEtE/AXYIzo8sLMbi9m+CCzbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Edich <andre.edich@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 138/213] smsc95xx: use usbnet->driver_priv
Date: Thu, 13 Jun 2024 13:33:06 +0200
Message-ID: <20240613113233.319683235@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

From: Andre Edich <andre.edich@microchip.com>

[ Upstream commit ad90a73f0236c41f7a2dedc2e75c7b5a364eb93e ]

Using `void *driver_priv` instead of `unsigned long data[]` is more
straightforward way to recover the `struct smsc95xx_priv *` from the
`struct net_device *`.

Signed-off-by: Andre Edich <andre.edich@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 52a2f0608366 ("net: usb: smsc95xx: fix changing LED_SEL bit value updated from EEPROM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/smsc95xx.c | 61 +++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 33 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index de45a6209c2e6..ec233d033f5cd 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -469,7 +469,7 @@ static unsigned int smsc95xx_hash(char addr[ETH_ALEN])
 static void smsc95xx_set_multicast(struct net_device *netdev)
 {
 	struct usbnet *dev = netdev_priv(netdev);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	unsigned long flags;
 	int ret;
 
@@ -564,7 +564,7 @@ static int smsc95xx_phy_update_flowcontrol(struct usbnet *dev, u8 duplex,
 
 static int smsc95xx_link_reset(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	struct mii_if_info *mii = &dev->mii;
 	struct ethtool_cmd ecmd = { .cmd = ETHTOOL_GSET };
 	unsigned long flags;
@@ -634,7 +634,7 @@ static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
 
 static void set_carrier(struct usbnet *dev, bool link)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 
 	if (pdata->link_ok == link)
 		return;
@@ -763,7 +763,7 @@ static void smsc95xx_ethtool_get_wol(struct net_device *net,
 				     struct ethtool_wolinfo *wolinfo)
 {
 	struct usbnet *dev = netdev_priv(net);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 
 	wolinfo->supported = SUPPORTED_WAKE;
 	wolinfo->wolopts = pdata->wolopts;
@@ -773,7 +773,7 @@ static int smsc95xx_ethtool_set_wol(struct net_device *net,
 				    struct ethtool_wolinfo *wolinfo)
 {
 	struct usbnet *dev = netdev_priv(net);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int ret;
 
 	if (wolinfo->wolopts & ~SUPPORTED_WAKE)
@@ -812,7 +812,7 @@ static int get_mdix_status(struct net_device *net)
 static void set_mdix_status(struct net_device *net, __u8 mdix_ctrl)
 {
 	struct usbnet *dev = netdev_priv(net);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int buf;
 
 	if ((pdata->chip_id == ID_REV_CHIP_ID_9500A_) ||
@@ -861,7 +861,7 @@ static int smsc95xx_get_link_ksettings(struct net_device *net,
 				       struct ethtool_link_ksettings *cmd)
 {
 	struct usbnet *dev = netdev_priv(net);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int retval;
 
 	retval = usbnet_get_link_ksettings(net, cmd);
@@ -876,7 +876,7 @@ static int smsc95xx_set_link_ksettings(struct net_device *net,
 				       const struct ethtool_link_ksettings *cmd)
 {
 	struct usbnet *dev = netdev_priv(net);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int retval;
 
 	if (pdata->mdix_ctrl != cmd->base.eth_tp_mdix_ctrl)
@@ -958,7 +958,7 @@ static int smsc95xx_set_mac_address(struct usbnet *dev)
 /* starts the TX path */
 static int smsc95xx_start_tx_path(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	unsigned long flags;
 	int ret;
 
@@ -978,7 +978,7 @@ static int smsc95xx_start_tx_path(struct usbnet *dev)
 /* Starts the Receive path */
 static int smsc95xx_start_rx_path(struct usbnet *dev, int in_pm)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	unsigned long flags;
 
 	spin_lock_irqsave(&pdata->mac_cr_lock, flags);
@@ -1035,7 +1035,7 @@ static int smsc95xx_phy_initialize(struct usbnet *dev)
 
 static int smsc95xx_reset(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 read_buf, write_buf, burst_cap;
 	int ret = 0, timeout;
 
@@ -1263,7 +1263,7 @@ static const struct net_device_ops smsc95xx_netdev_ops = {
 
 static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 {
-	struct smsc95xx_priv *pdata = NULL;
+	struct smsc95xx_priv *pdata;
 	u32 val;
 	int ret;
 
@@ -1275,13 +1275,12 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 		return ret;
 	}
 
-	dev->data[0] = (unsigned long)kzalloc(sizeof(struct smsc95xx_priv),
-					      GFP_KERNEL);
-
-	pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
 
+	dev->driver_priv = pdata;
+
 	spin_lock_init(&pdata->mac_cr_lock);
 
 	/* LAN95xx devices do not alter the computed checksum of 0 to 0xffff.
@@ -1344,15 +1343,11 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 
 static void smsc95xx_unbind(struct usbnet *dev, struct usb_interface *intf)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
-
-	if (pdata) {
-		cancel_delayed_work_sync(&pdata->carrier_check);
-		netif_dbg(dev, ifdown, dev->net, "free pdata\n");
-		kfree(pdata);
-		pdata = NULL;
-		dev->data[0] = 0;
-	}
+	struct smsc95xx_priv *pdata = dev->driver_priv;
+
+	cancel_delayed_work_sync(&pdata->carrier_check);
+	netif_dbg(dev, ifdown, dev->net, "free pdata\n");
+	kfree(pdata);
 }
 
 static u32 smsc_crc(const u8 *buffer, size_t len, int filter)
@@ -1402,7 +1397,7 @@ static int smsc95xx_link_ok_nopm(struct usbnet *dev)
 
 static int smsc95xx_enter_suspend0(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 val;
 	int ret;
 
@@ -1441,7 +1436,7 @@ static int smsc95xx_enter_suspend0(struct usbnet *dev)
 
 static int smsc95xx_enter_suspend1(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 val;
 	int ret;
 
@@ -1488,7 +1483,7 @@ static int smsc95xx_enter_suspend1(struct usbnet *dev)
 
 static int smsc95xx_enter_suspend2(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 val;
 	int ret;
 
@@ -1510,7 +1505,7 @@ static int smsc95xx_enter_suspend2(struct usbnet *dev)
 
 static int smsc95xx_enter_suspend3(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 val;
 	int ret;
 
@@ -1549,7 +1544,7 @@ static int smsc95xx_enter_suspend3(struct usbnet *dev)
 
 static int smsc95xx_autosuspend(struct usbnet *dev, u32 link_up)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int ret;
 
 	if (!netif_running(dev->net)) {
@@ -1597,7 +1592,7 @@ static int smsc95xx_autosuspend(struct usbnet *dev, u32 link_up)
 static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct usbnet *dev = usb_get_intfdata(intf);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 val, link_up;
 	int ret;
 
@@ -1868,7 +1863,7 @@ static int smsc95xx_resume(struct usb_interface *intf)
 	u32 val;
 
 	BUG_ON(!dev);
-	pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	pdata = dev->driver_priv;
 	suspend_flags = pdata->suspend_flags;
 
 	netdev_dbg(dev->net, "resume suspend_flags=0x%02x\n", suspend_flags);
@@ -2079,7 +2074,7 @@ static struct sk_buff *smsc95xx_tx_fixup(struct usbnet *dev,
 
 static int smsc95xx_manage_power(struct usbnet *dev, int on)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 
 	dev->intf->needs_remote_wakeup = on;
 
-- 
2.43.0



