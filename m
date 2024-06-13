Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01652148855;
	Thu, 13 Jun 2024 12:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280231; cv=none; b=EnzBNsyavv2H9on/ABwz6TZPFCJVdrpcun9z3178SwJJVNO+Q+q6fjcsh+xYtf9He4dPqb48MaMdM+Sw68BE23/KMrcBZ0DADQsUs+qeCPagR7QZKJwylRCgJdh6CPcHSDZYTDo2/mtvZ/5SDYSG6L3OIRbZ9GKvcOdruxCi/VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280231; c=relaxed/simple;
	bh=ZTokSd4B+2Xu7zqTZK4WkSZzqQfRDK+s0V5c8iyiI1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOFcMH4pqGyrmySMiMg0aUyf6PbwBMdBWFOHdfjkrYRs0DoZU7UxTxYl2lUi5cUJiSx2NNPyzZj6jsVTBe9yBE6kaRAQ1eBh7AynY/zL+iec+mgEvcvxKtc3huZIKWWClMEpOsip2bNlNAbJr8XA7L6WpVnPYiYrRkB7BCOAt8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSN328jd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSN328jd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F78DC2BBFC;
	Thu, 13 Jun 2024 12:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280230;
	bh=ZTokSd4B+2Xu7zqTZK4WkSZzqQfRDK+s0V5c8iyiI1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSN328jdEUQ+EIa0nX6VnGd9FibZmCHYLsDE9yTu6pj853WQSjPlsGBadjV9/r1kO
	 98CJqcgPpBil65m22Aii9Sdzb3fwICVaykzBl0Ldr1GzmEk2ttYF7A3nO962qVW/bj
	 A20k/U8hEpZI7e0uLNzfhU3+VRDmSwpf4EOphx9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Edich <andre.edich@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 155/202] smsc95xx: use usbnet->driver_priv
Date: Thu, 13 Jun 2024 13:34:13 +0200
Message-ID: <20240613113233.733304422@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6fe6edc59623d..7fe5673e256e6 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -457,7 +457,7 @@ static unsigned int smsc95xx_hash(char addr[ETH_ALEN])
 static void smsc95xx_set_multicast(struct net_device *netdev)
 {
 	struct usbnet *dev = netdev_priv(netdev);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	unsigned long flags;
 	int ret;
 
@@ -552,7 +552,7 @@ static int smsc95xx_phy_update_flowcontrol(struct usbnet *dev, u8 duplex,
 
 static int smsc95xx_link_reset(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	struct mii_if_info *mii = &dev->mii;
 	struct ethtool_cmd ecmd = { .cmd = ETHTOOL_GSET };
 	unsigned long flags;
@@ -620,7 +620,7 @@ static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
 
 static void set_carrier(struct usbnet *dev, bool link)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 
 	if (pdata->link_ok == link)
 		return;
@@ -749,7 +749,7 @@ static void smsc95xx_ethtool_get_wol(struct net_device *net,
 				     struct ethtool_wolinfo *wolinfo)
 {
 	struct usbnet *dev = netdev_priv(net);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 
 	wolinfo->supported = SUPPORTED_WAKE;
 	wolinfo->wolopts = pdata->wolopts;
@@ -759,7 +759,7 @@ static int smsc95xx_ethtool_set_wol(struct net_device *net,
 				    struct ethtool_wolinfo *wolinfo)
 {
 	struct usbnet *dev = netdev_priv(net);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int ret;
 
 	if (wolinfo->wolopts & ~SUPPORTED_WAKE)
@@ -798,7 +798,7 @@ static int get_mdix_status(struct net_device *net)
 static void set_mdix_status(struct net_device *net, __u8 mdix_ctrl)
 {
 	struct usbnet *dev = netdev_priv(net);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int buf;
 
 	if ((pdata->chip_id == ID_REV_CHIP_ID_9500A_) ||
@@ -847,7 +847,7 @@ static int smsc95xx_get_link_ksettings(struct net_device *net,
 				       struct ethtool_link_ksettings *cmd)
 {
 	struct usbnet *dev = netdev_priv(net);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int retval;
 
 	retval = usbnet_get_link_ksettings(net, cmd);
@@ -862,7 +862,7 @@ static int smsc95xx_set_link_ksettings(struct net_device *net,
 				       const struct ethtool_link_ksettings *cmd)
 {
 	struct usbnet *dev = netdev_priv(net);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int retval;
 
 	if (pdata->mdix_ctrl != cmd->base.eth_tp_mdix_ctrl)
@@ -944,7 +944,7 @@ static int smsc95xx_set_mac_address(struct usbnet *dev)
 /* starts the TX path */
 static int smsc95xx_start_tx_path(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	unsigned long flags;
 	int ret;
 
@@ -964,7 +964,7 @@ static int smsc95xx_start_tx_path(struct usbnet *dev)
 /* Starts the Receive path */
 static int smsc95xx_start_rx_path(struct usbnet *dev, int in_pm)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	unsigned long flags;
 
 	spin_lock_irqsave(&pdata->mac_cr_lock, flags);
@@ -1021,7 +1021,7 @@ static int smsc95xx_phy_initialize(struct usbnet *dev)
 
 static int smsc95xx_reset(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 read_buf, write_buf, burst_cap;
 	int ret = 0, timeout;
 
@@ -1249,7 +1249,7 @@ static const struct net_device_ops smsc95xx_netdev_ops = {
 
 static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 {
-	struct smsc95xx_priv *pdata = NULL;
+	struct smsc95xx_priv *pdata;
 	u32 val;
 	int ret;
 
@@ -1261,13 +1261,12 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
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
@@ -1330,15 +1329,11 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 
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
@@ -1388,7 +1383,7 @@ static int smsc95xx_link_ok_nopm(struct usbnet *dev)
 
 static int smsc95xx_enter_suspend0(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 val;
 	int ret;
 
@@ -1427,7 +1422,7 @@ static int smsc95xx_enter_suspend0(struct usbnet *dev)
 
 static int smsc95xx_enter_suspend1(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 val;
 	int ret;
 
@@ -1474,7 +1469,7 @@ static int smsc95xx_enter_suspend1(struct usbnet *dev)
 
 static int smsc95xx_enter_suspend2(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 val;
 	int ret;
 
@@ -1496,7 +1491,7 @@ static int smsc95xx_enter_suspend2(struct usbnet *dev)
 
 static int smsc95xx_enter_suspend3(struct usbnet *dev)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 val;
 	int ret;
 
@@ -1535,7 +1530,7 @@ static int smsc95xx_enter_suspend3(struct usbnet *dev)
 
 static int smsc95xx_autosuspend(struct usbnet *dev, u32 link_up)
 {
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int ret;
 
 	if (!netif_running(dev->net)) {
@@ -1583,7 +1578,7 @@ static int smsc95xx_autosuspend(struct usbnet *dev, u32 link_up)
 static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct usbnet *dev = usb_get_intfdata(intf);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 val, link_up;
 	int ret;
 
@@ -1854,7 +1849,7 @@ static int smsc95xx_resume(struct usb_interface *intf)
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



