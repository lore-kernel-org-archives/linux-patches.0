Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19801BDDE;
	Wed,  3 Jan 2024 17:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZI1PJMkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396C5C433C7;
	Wed,  3 Jan 2024 17:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301623;
	bh=gcDd5YkCmCMk627nWi9lxJ5lzVVYhJQDeCXhEeytWWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZI1PJMkZ4gKepHkIkp6p1+drVKqaxRb3+l99SEItNh4qnGa9fdwvt+LaKMXDrm4+/
	 8hlNxV7vy1yz8kJvEYPdUZRpygmywzGNwXUuu//dCYJqvwrJrQtEcsq8xf1HuaHDeu
	 ByqFkVVAzygAO6q0K8kHm0vy40DhBAoIdWOcTrpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justinpopo6@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 78/95] net: usb: ax88179_178a: wol optimizations
Date: Wed,  3 Jan 2024 17:55:26 +0100
Message-ID: <20240103164905.729905960@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
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

[ Upstream commit 5050531610a64f08461e0c309db80ca51b779fd5 ]

- Check if wol is supported on reset instead of everytime get_wol
is called.
- Save wolopts in private data instead of relying on the HW to save it.
- Defer enabling WoL until suspend instead of enabling it everytime
set_wol is called.

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: aef05e349bfd ("net: usb: ax88179_178a: avoid failed operations when device is disconnected")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/ax88179_178a.c | 52 ++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index bd258c4e13948..49d97ad376654 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -170,6 +170,8 @@ struct ax88179_data {
 	u16 rxctl;
 	u16 reserved;
 	u8 in_pm;
+	u32 wol_supported;
+	u32 wolopts;
 };
 
 struct ax88179_int_data {
@@ -399,6 +401,7 @@ ax88179_phy_write_mmd_indirect(struct usbnet *dev, u16 prtad, u16 devad,
 static int ax88179_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct usbnet *dev = usb_get_intfdata(intf);
+	struct ax88179_data *priv = dev->driver_priv;
 	u16 tmp16;
 	u8 tmp8;
 
@@ -406,6 +409,19 @@ static int ax88179_suspend(struct usb_interface *intf, pm_message_t message)
 
 	usbnet_suspend(intf, message);
 
+	/* Enable WoL */
+	if (priv->wolopts) {
+		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MONITOR_MOD,
+				 1, 1, &tmp8);
+		if (priv->wolopts & WAKE_PHY)
+			tmp8 |= AX_MONITOR_MODE_RWLC;
+		if (priv->wolopts & WAKE_MAGIC)
+			tmp8 |= AX_MONITOR_MODE_RWMP;
+
+		ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MONITOR_MOD,
+				  1, 1, &tmp8);
+	}
+
 	/* Disable RX path */
 	ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
 			 2, 2, &tmp16);
@@ -504,40 +520,22 @@ static void
 ax88179_get_wol(struct net_device *net, struct ethtool_wolinfo *wolinfo)
 {
 	struct usbnet *dev = netdev_priv(net);
-	u8 opt;
-
-	if (ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MONITOR_MOD,
-			     1, 1, &opt) < 0) {
-		wolinfo->supported = 0;
-		wolinfo->wolopts = 0;
-		return;
-	}
+	struct ax88179_data *priv = dev->driver_priv;
 
-	wolinfo->supported = WAKE_PHY | WAKE_MAGIC;
-	wolinfo->wolopts = 0;
-	if (opt & AX_MONITOR_MODE_RWLC)
-		wolinfo->wolopts |= WAKE_PHY;
-	if (opt & AX_MONITOR_MODE_RWMP)
-		wolinfo->wolopts |= WAKE_MAGIC;
+	wolinfo->supported = priv->wol_supported;
+	wolinfo->wolopts = priv->wolopts;
 }
 
 static int
 ax88179_set_wol(struct net_device *net, struct ethtool_wolinfo *wolinfo)
 {
 	struct usbnet *dev = netdev_priv(net);
-	u8 opt = 0;
+	struct ax88179_data *priv = dev->driver_priv;
 
-	if (wolinfo->wolopts & ~(WAKE_PHY | WAKE_MAGIC))
+	if (wolinfo->wolopts & ~(priv->wol_supported))
 		return -EINVAL;
 
-	if (wolinfo->wolopts & WAKE_PHY)
-		opt |= AX_MONITOR_MODE_RWLC;
-	if (wolinfo->wolopts & WAKE_MAGIC)
-		opt |= AX_MONITOR_MODE_RWMP;
-
-	if (ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MONITOR_MOD,
-			      1, 1, &opt) < 0)
-		return -EINVAL;
+	priv->wolopts = wolinfo->wolopts;
 
 	return 0;
 }
@@ -1727,6 +1725,12 @@ static int ax88179_reset(struct usbnet *dev)
 	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
 			  2, 2, tmp16);
 
+	/* Check if WoL is supported */
+	ax179_data->wol_supported = 0;
+	if (ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MONITOR_MOD,
+			     1, 1, &tmp) > 0)
+		ax179_data->wol_supported = WAKE_MAGIC | WAKE_PHY;
+
 	ax88179_led_setting(dev);
 
 	ax179_data->eee_enabled = 0;
-- 
2.43.0



