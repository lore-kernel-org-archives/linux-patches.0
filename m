Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F355C1EEE6;
	Sat, 13 Jan 2024 10:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjzzYk9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4B7C433F1;
	Sat, 13 Jan 2024 10:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705140111;
	bh=Atn6UmQ/0lGOmHNTSOIstE+hv30Z4WBEAvy0PwZQprM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WjzzYk9VoM4wv7RFcV7ys9e98diRoxhKO8478l8ocLSzGugvP/MKdMy5DbWzV3X5t
	 NNrjounIhcZoW6wZkAW/iNvBUVKYutVTYz4Vf2aHNNkhoFpZiCLIKRJUPXwWfKBuPZ
	 dsYyN5YsRxOCVooiWJ5EDX9NCC7yhbMPU67X6wAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justinpopo6@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jeffery Miller <jefferymiller@google.com>
Subject: [PATCH 5.15 58/59] net: usb: ax88179_178a: remove redundant init code
Date: Sat, 13 Jan 2024 10:50:29 +0100
Message-ID: <20240113094211.057567457@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094209.301672391@linuxfoundation.org>
References: <20240113094209.301672391@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justinpopo6@gmail.com>

commit 9718f9ce5b86e2f4e6364762018980f0222c2e5e upstream.

Bind and reset are basically doing the same thing. Remove the duplicate
code and have bind call into reset.

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Jeffery Miller <jefferymiller@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c |   85 +----------------------------------------
 1 file changed, 4 insertions(+), 81 deletions(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -164,6 +164,8 @@
 	#define GMII_PHY_PGSEL_PAGE3	0x0003
 	#define GMII_PHY_PGSEL_PAGE5	0x0005
 
+static int ax88179_reset(struct usbnet *dev);
+
 struct ax88179_data {
 	u8  eee_enabled;
 	u8  eee_active;
@@ -1308,47 +1310,12 @@ static void ax88179_get_mac_addr(struct
 
 static int ax88179_bind(struct usbnet *dev, struct usb_interface *intf)
 {
-	u8 buf[5];
-	u16 *tmp16;
-	u8 *tmp;
 	struct ax88179_data *ax179_data = (struct ax88179_data *)dev->data;
-	struct ethtool_eee eee_data;
 
 	usbnet_get_endpoints(dev, intf);
 
-	tmp16 = (u16 *)buf;
-	tmp = (u8 *)buf;
-
 	memset(ax179_data, 0, sizeof(*ax179_data));
 
-	/* Power up ethernet PHY */
-	*tmp16 = 0;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL, 2, 2, tmp16);
-	*tmp16 = AX_PHYPWR_RSTCTL_IPRL;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL, 2, 2, tmp16);
-	msleep(200);
-
-	*tmp = AX_CLK_SELECT_ACS | AX_CLK_SELECT_BCS;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, tmp);
-	msleep(100);
-
-	/* Read MAC address from DTB or asix chip */
-	ax88179_get_mac_addr(dev);
-	memcpy(dev->net->perm_addr, dev->net->dev_addr, ETH_ALEN);
-
-	/* RX bulk configuration */
-	memcpy(tmp, &AX88179_BULKIN_SIZE[0], 5);
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_RX_BULKIN_QCTRL, 5, 5, tmp);
-
-	dev->rx_urb_size = 1024 * 20;
-
-	*tmp = 0x34;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PAUSE_WATERLVL_LOW, 1, 1, tmp);
-
-	*tmp = 0x52;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PAUSE_WATERLVL_HIGH,
-			  1, 1, tmp);
-
 	dev->net->netdev_ops = &ax88179_netdev_ops;
 	dev->net->ethtool_ops = &ax88179_ethtool_ops;
 	dev->net->needed_headroom = 8;
@@ -1369,46 +1336,7 @@ static int ax88179_bind(struct usbnet *d
 	dev->net->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 				 NETIF_F_RXCSUM;
 
-	/* Enable checksum offload */
-	*tmp = AX_RXCOE_IP | AX_RXCOE_TCP | AX_RXCOE_UDP |
-	       AX_RXCOE_TCPV6 | AX_RXCOE_UDPV6;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_RXCOE_CTL, 1, 1, tmp);
-
-	*tmp = AX_TXCOE_IP | AX_TXCOE_TCP | AX_TXCOE_UDP |
-	       AX_TXCOE_TCPV6 | AX_TXCOE_UDPV6;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, tmp);
-
-	/* Configure RX control register => start operation */
-	*tmp16 = AX_RX_CTL_DROPCRCERR | AX_RX_CTL_IPE | AX_RX_CTL_START |
-		 AX_RX_CTL_AP | AX_RX_CTL_AMALL | AX_RX_CTL_AB;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_RX_CTL, 2, 2, tmp16);
-
-	*tmp = AX_MONITOR_MODE_PMETYPE | AX_MONITOR_MODE_PMEPOL |
-	       AX_MONITOR_MODE_RWMP;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MONITOR_MOD, 1, 1, tmp);
-
-	/* Configure default medium type => giga */
-	*tmp16 = AX_MEDIUM_RECEIVE_EN | AX_MEDIUM_TXFLOW_CTRLEN |
-		 AX_MEDIUM_RXFLOW_CTRLEN | AX_MEDIUM_FULL_DUPLEX |
-		 AX_MEDIUM_GIGAMODE;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
-			  2, 2, tmp16);
-
-	ax88179_led_setting(dev);
-
-	ax179_data->eee_enabled = 0;
-	ax179_data->eee_active = 0;
-
-	ax88179_disable_eee(dev);
-
-	ax88179_ethtool_get_eee(dev, &eee_data);
-	eee_data.advertised = 0;
-	ax88179_ethtool_set_eee(dev, &eee_data);
-
-	/* Restart autoneg */
-	mii_nway_restart(&dev->mii);
-
-	usbnet_link_change(dev, 0, 0);
+	ax88179_reset(dev);
 
 	return 0;
 }
@@ -1697,6 +1625,7 @@ static int ax88179_reset(struct usbnet *
 
 	/* Read MAC address from DTB or asix chip */
 	ax88179_get_mac_addr(dev);
+	memcpy(dev->net->perm_addr, dev->net->dev_addr, ETH_ALEN);
 
 	/* RX bulk configuration */
 	memcpy(tmp, &AX88179_BULKIN_SIZE[0], 5);
@@ -1711,12 +1640,6 @@ static int ax88179_reset(struct usbnet *
 	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PAUSE_WATERLVL_HIGH,
 			  1, 1, tmp);
 
-	dev->net->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			      NETIF_F_RXCSUM;
-
-	dev->net->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				 NETIF_F_RXCSUM;
-
 	/* Enable checksum offload */
 	*tmp = AX_RXCOE_IP | AX_RXCOE_TCP | AX_RXCOE_UDP |
 	       AX_RXCOE_TCPV6 | AX_RXCOE_UDPV6;


