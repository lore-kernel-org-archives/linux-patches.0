Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5EE18C913;
	Tue, 10 Sep 2024 10:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962564; cv=none; b=EZkOQyOEN6sbdUxlI3e1EImZckmNE3AI/nCxgRgKH5MS4fTgrlLrOHDN0QjqsV3dDQx/mwPg0XlJ4qha5HLQoxdEWT/XDf+yIiwxFEMuLxVxnM0HkgLu15RuF/ihwaM89M0WPT8IEe9NRZRRU5j+vcbWWU7ykTL0X9ffLGaVvgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962564; c=relaxed/simple;
	bh=0EPPkxMTyfPfECd0+5LdNElXui3bQRPGTd98q/IsZgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIwincHzssh9zzumxOFmR9d4x9RGT7RBsoUgEuUmzhdxZSZPJmDOHyVKvjH7EX6tL92VvrrJvjSF1yae8dig0SW49ptM3HyPOcTU4KyMHQGxKNrcwbVNvnnX8I3Y7Q4oTDe81HORInt3AaBoJ9rHJxO7F05j50Ax2GqnDBZrQPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dw+tqzM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dw+tqzM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11555C4CEC6;
	Tue, 10 Sep 2024 10:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962564;
	bh=0EPPkxMTyfPfECd0+5LdNElXui3bQRPGTd98q/IsZgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dw+tqzM3XG29NGlALook0xPw30eJFmj1KyqSY/u6hpuEdEqGIj/qaj+AeQt+wjXiG
	 knAse+Wvv4GQ9mpFcKauy8kWSsmMEpqaV1Gj2msD5wlRTLT/CxcMgzbO0zjbzKW7lv
	 2VC68sTBW8gyxTCPPazpgkArn2wspQMRWg5qb6Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Baker <len.baker@gmx.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/121] drivers/net/usb: Remove all strcpy() uses
Date: Tue, 10 Sep 2024 11:32:14 +0200
Message-ID: <20240910092548.635466426@linuxfoundation.org>
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

From: Len Baker <len.baker@gmx.com>

[ Upstream commit 493c3ca6bd754d8587604496eb814f72e933075d ]

strcpy() performs no bounds checking on the destination buffer. This
could result in linear overflows beyond the end of the buffer, leading
to all kinds of misbehaviors. The safe replacement is strscpy().

Signed-off-by: Len Baker <len.baker@gmx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bab8eb0dd4cb ("usbnet: modern method to get random MAC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/ipheth.c | 2 +-
 drivers/net/usb/usbnet.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 73ad78f47763..9887eb282beb 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -443,7 +443,7 @@ static int ipheth_probe(struct usb_interface *intf,
 
 	netdev->netdev_ops = &ipheth_netdev_ops;
 	netdev->watchdog_timeo = IPHETH_TX_TIMEOUT;
-	strcpy(netdev->name, "eth%d");
+	strscpy(netdev->name, "eth%d", sizeof(netdev->name));
 
 	dev = netdev_priv(netdev);
 	dev->udev = udev;
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index bc37e268a15e..bf018f7ca445 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1711,7 +1711,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	dev->interrupt_count = 0;
 
 	dev->net = net;
-	strcpy (net->name, "usb%d");
+	strscpy(net->name, "usb%d", sizeof(net->name));
 	memcpy (net->dev_addr, node_id, sizeof node_id);
 
 	/* rx and tx sides can use different message sizes;
@@ -1738,13 +1738,13 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 		if ((dev->driver_info->flags & FLAG_ETHER) != 0 &&
 		    ((dev->driver_info->flags & FLAG_POINTTOPOINT) == 0 ||
 		     (net->dev_addr [0] & 0x02) == 0))
-			strcpy (net->name, "eth%d");
+			strscpy(net->name, "eth%d", sizeof(net->name));
 		/* WLAN devices should always be named "wlan%d" */
 		if ((dev->driver_info->flags & FLAG_WLAN) != 0)
-			strcpy(net->name, "wlan%d");
+			strscpy(net->name, "wlan%d", sizeof(net->name));
 		/* WWAN devices should always be named "wwan%d" */
 		if ((dev->driver_info->flags & FLAG_WWAN) != 0)
-			strcpy(net->name, "wwan%d");
+			strscpy(net->name, "wwan%d", sizeof(net->name));
 
 		/* devices that cannot do ARP */
 		if ((dev->driver_info->flags & FLAG_NOARP) != 0)
-- 
2.43.0



