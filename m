Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC1417BEAE;
	Tue, 10 Sep 2024 09:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961137; cv=none; b=hdyoxindGUraibZQpfaKEXybZu8pGQxELke+jt4dWlA9vi3CcBP9gvt/ib5cBgAXyJsA68pnM9ZrQ8z/wa3yi9TINQDF4h2uQI1xReAFp9berjYBB7Z1mNW6WlIp5Jno20y57okif2QA8FV2Zy8MCKDv9/lD57pcNP8QjO8+e8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961137; c=relaxed/simple;
	bh=A59LweOLwfqns3/h2eXLeAVcmEYzhsOcHtwlf3IqIpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAuX9JPTpXddDdxjw54N/0MfHTVPn06z/FhFKrE/MzZ/RNSdjOKMf29d5a3FG59xp3CN6BcDIHM4LbjVtwZOjPSOC4kiuVOzbERneIItCcF8PV+60bRHz7CwWEIWfXQRs7xkLEqBAetI0vRb3NXXEv0Jz28RV1IGV7skN/l2EdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTQ9GjbB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTQ9GjbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8E9C4CEC3;
	Tue, 10 Sep 2024 09:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961136;
	bh=A59LweOLwfqns3/h2eXLeAVcmEYzhsOcHtwlf3IqIpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FTQ9GjbBJp+IP/2w4/hPQGRbN5eXRgmuwWDE7yr3/vRLjHtqAN+6E3LpPf3/FD17M
	 N+8JOSKIYPxaspdvh52UpqZMCOhoN4Jw31nI4mjt+KYNxuBpk8WCCHfZMs0McCQw4l
	 ZHzTuwqbEdlZKyuYX56ibp7qu9QIGSvvz5oiNrEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Zary <linux@zary.sk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/96] cx82310_eth: re-enable ethernet mode after router reboot
Date: Tue, 10 Sep 2024 11:31:40 +0200
Message-ID: <20240910092543.204410809@linuxfoundation.org>
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
index dfbdea22fbad..6a9a5e540b09 100644
--- a/drivers/net/usb/cx82310_eth.c
+++ b/drivers/net/usb/cx82310_eth.c
@@ -52,6 +52,11 @@ enum cx82310_status {
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
@@ -127,6 +132,23 @@ static int cx82310_cmd(struct usbnet *dev, enum cx82310_cmd cmd, bool reply,
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
@@ -138,6 +160,7 @@ static int cx82310_bind(struct usbnet *dev, struct usb_interface *intf)
 	struct usb_device *udev = dev->udev;
 	u8 link[3];
 	int timeout = 50;
+	struct cx82310_priv *priv;
 
 	/* avoid ADSL modems - continue only if iProduct is "USB NET CARD" */
 	if (usb_string(udev, udev->descriptor.iProduct, buf, sizeof(buf)) > 0
@@ -164,6 +187,15 @@ static int cx82310_bind(struct usbnet *dev, struct usb_interface *intf)
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
@@ -180,12 +212,8 @@ static int cx82310_bind(struct usbnet *dev, struct usb_interface *intf)
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
@@ -202,13 +230,19 @@ static int cx82310_bind(struct usbnet *dev, struct usb_interface *intf)
 
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
@@ -223,6 +257,7 @@ static int cx82310_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 {
 	int len;
 	struct sk_buff *skb2;
+	struct cx82310_priv *priv = dev->driver_priv;
 
 	/*
 	 * If the last skb ended with an incomplete packet, this skb contains
@@ -257,7 +292,10 @@ static int cx82310_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
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



