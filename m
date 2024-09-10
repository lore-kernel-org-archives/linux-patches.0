Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5613218FDB0;
	Tue, 10 Sep 2024 10:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962532; cv=none; b=VRazgigyrccICpf1NYF3OGOLfH4uIoCRHgedJ5QsfHQFRzQjO2pbuAiS62JwsARKcBid+EYCBdPSCC3uwoqk9SIbUKSmTf9eHBZX5RzhrgHF68mlUN/GB6ZCyaugzdf/+fbDxPEdW/Ut0Pdr2TfkWAj6zQK8eXT/7GzvabTD2wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962532; c=relaxed/simple;
	bh=1RCGrKyY03JM1dpr8uTmlqCXS6KKh/zegw/MiAUnbBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsEfpIq9+XFRt51IQr5EPzEL5X9xS6UCtBClcad0o1nyIkMbF1Qht32HoxQIa+7Qs2pcADaK8YHWNlsyBpPaxeliHy30tjdPbQ53t5WuZiQBzzhlSRN6dHY+VJw5e57G5lTau1t5Iae0ccPx1xjzxravV+3JXe/7XpJYaw1BTiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09muwfgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09muwfgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA3CC4CEC3;
	Tue, 10 Sep 2024 10:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962532;
	bh=1RCGrKyY03JM1dpr8uTmlqCXS6KKh/zegw/MiAUnbBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09muwfgpvYZqFEP7QdoOOFpX8Gps0SnljX56lI0uB5nV4QrVbe7lCgYlNDwBlyRgE
	 i6VfsZN6sPHxzhfjj0KFNBUCz01XMNaU7soGO2mML3jK1KvLTOhUetl1fWWf5z1qiy
	 jO4de6sfAJGEQiHNfuNEboBAv33kymey865+dI/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Zary <linux@zary.sk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/121] cx82310_eth: re-enable ethernet mode after router reboot
Date: Tue, 10 Sep 2024 11:32:13 +0200
Message-ID: <20240910092548.577297718@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

From: Ondrej Zary <linux@zary.sk>

[ Upstream commit ca139d76b0d9e59d18f2d2ec8f0d81b82acd6808 ]

When the router is rebooted without a power cycle, the USB device
remains connected but its configuration is reset. This results in
a non-working ethernet connection with messages like this in syslog:
	usb 2-2: RX packet too long: 65535 B

Re-enable ethernet mode when receiving a packet with invalid size of
0xffff.

Signed-off-by: Ondrej Zary <linux@zary.sk>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: bab8eb0dd4cb ("usbnet: modern method to get random MAC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cx82310_eth.c | 50 ++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/cx82310_eth.c b/drivers/net/usb/cx82310_eth.c
index 32b08b18e120..043679311399 100644
--- a/drivers/net/usb/cx82310_eth.c
+++ b/drivers/net/usb/cx82310_eth.c
@@ -40,6 +40,11 @@ enum cx82310_status {
 #define CX82310_MTU	1514
 #define CMD_EP		0x01
 
+struct cx82310_priv {
+	struct work_struct reenable_work;
+	struct usbnet *dev;
+};
+
 /*
  * execute control command
  *  - optionally send some data (command parameters)
@@ -115,6 +120,23 @@ static int cx82310_cmd(struct usbnet *dev, enum cx82310_cmd cmd, bool reply,
 	return ret;
 }
 
+static int cx82310_enable_ethernet(struct usbnet *dev)
+{
+	int ret = cx82310_cmd(dev, CMD_ETHERNET_MODE, true, "\x01", 1, NULL, 0);
+
+	if (ret)
+		netdev_err(dev->net, "unable to enable ethernet mode: %d\n",
+			   ret);
+	return ret;
+}
+
+static void cx82310_reenable_work(struct work_struct *work)
+{
+	struct cx82310_priv *priv = container_of(work, struct cx82310_priv,
+						 reenable_work);
+	cx82310_enable_ethernet(priv->dev);
+}
+
 #define partial_len	data[0]		/* length of partial packet data */
 #define partial_rem	data[1]		/* remaining (missing) data length */
 #define partial_data	data[2]		/* partial packet data */
@@ -126,6 +148,7 @@ static int cx82310_bind(struct usbnet *dev, struct usb_interface *intf)
 	struct usb_device *udev = dev->udev;
 	u8 link[3];
 	int timeout = 50;
+	struct cx82310_priv *priv;
 
 	/* avoid ADSL modems - continue only if iProduct is "USB NET CARD" */
 	if (usb_string(udev, udev->descriptor.iProduct, buf, sizeof(buf)) > 0
@@ -152,6 +175,15 @@ static int cx82310_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (!dev->partial_data)
 		return -ENOMEM;
 
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		ret = -ENOMEM;
+		goto err_partial;
+	}
+	dev->driver_priv = priv;
+	INIT_WORK(&priv->reenable_work, cx82310_reenable_work);
+	priv->dev = dev;
+
 	/* wait for firmware to become ready (indicated by the link being up) */
 	while (--timeout) {
 		ret = cx82310_cmd(dev, CMD_GET_LINK_STATUS, true, NULL, 0,
@@ -168,12 +200,8 @@ static int cx82310_bind(struct usbnet *dev, struct usb_interface *intf)
 	}
 
 	/* enable ethernet mode (?) */
-	ret = cx82310_cmd(dev, CMD_ETHERNET_MODE, true, "\x01", 1, NULL, 0);
-	if (ret) {
-		dev_err(&udev->dev, "unable to enable ethernet mode: %d\n",
-			ret);
+	if (cx82310_enable_ethernet(dev))
 		goto err;
-	}
 
 	/* get the MAC address */
 	ret = cx82310_cmd(dev, CMD_GET_MAC_ADDR, true, NULL, 0,
@@ -190,13 +218,19 @@ static int cx82310_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	return 0;
 err:
+	kfree(dev->driver_priv);
+err_partial:
 	kfree((void *)dev->partial_data);
 	return ret;
 }
 
 static void cx82310_unbind(struct usbnet *dev, struct usb_interface *intf)
 {
+	struct cx82310_priv *priv = dev->driver_priv;
+
 	kfree((void *)dev->partial_data);
+	cancel_work_sync(&priv->reenable_work);
+	kfree(dev->driver_priv);
 }
 
 /*
@@ -211,6 +245,7 @@ static int cx82310_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 {
 	int len;
 	struct sk_buff *skb2;
+	struct cx82310_priv *priv = dev->driver_priv;
 
 	/*
 	 * If the last skb ended with an incomplete packet, this skb contains
@@ -245,7 +280,10 @@ static int cx82310_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			break;
 		}
 
-		if (len > CX82310_MTU) {
+		if (len == 0xffff) {
+			netdev_info(dev->net, "router was rebooted, re-enabling ethernet mode");
+			schedule_work(&priv->reenable_work);
+		} else if (len > CX82310_MTU) {
 			dev_err(&dev->udev->dev, "RX packet too long: %d B\n",
 				len);
 			return 0;
-- 
2.43.0



