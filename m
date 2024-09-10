Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C276717BEAE;
	Tue, 10 Sep 2024 09:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961139; cv=none; b=XorbMLbHflkbg1JK9URpnU9V6k0V6oRWPDgctS064EnRbroz2vX4NfjzjOsn0iY7Yim7DKLP8/h7eSq3U1unZupbUruWCXON769Qm0iW0O1sObrcG0rMBIFByTBp8jPDJeGHx92dAqJF4K9yIAVKHsSPuRkTyN0ka4kV9+dxlTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961139; c=relaxed/simple;
	bh=DUKpPNo4/8LNXEIMpYC31GDvl8aqNJmdnuVIeoiKKWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2IJtds+l4umZpmgwWEa8tQIdVihKiynxKE16tZ2dtkz4EEJTi0BUQtHuDg3EX3CB1euoSeDRDXKcnYaRLW012prRPbf7Y+5ZqlzPtrzXwmxkb5fXAM/cTAUB4gBlupYwuRt/twE190BASQ5DFbQYCTfT4fqhalNiSw3z3AQjsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLx1l7PL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLx1l7PL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DC4C4CEC3;
	Tue, 10 Sep 2024 09:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961139;
	bh=DUKpPNo4/8LNXEIMpYC31GDvl8aqNJmdnuVIeoiKKWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLx1l7PLUj6LPyI8ZWg+cNv47kM4jGH9jInuljsja1qMACZjPJiq6r3VmRctcmlCJ
	 2T1m+tnzJW1VrASAcB8CmxPVlPqLs8Wdfrzg/dxqbYBs7I7mIgxU2Y+23qp0yG4nhF
	 znJyRZ9l0FNe6LRizKtJdxaCp4tb0Hti5B0ad7R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Baker <len.baker@gmx.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/96] drivers/net/usb: Remove all strcpy() uses
Date: Tue, 10 Sep 2024 11:31:41 +0200
Message-ID: <20240910092543.244008170@linuxfoundation.org>
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
index cea005cc7b2a..5e8fd2aa1888 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -497,7 +497,7 @@ static int ipheth_probe(struct usb_interface *intf,
 
 	netdev->netdev_ops = &ipheth_netdev_ops;
 	netdev->watchdog_timeo = IPHETH_TX_TIMEOUT;
-	strcpy(netdev->name, "eth%d");
+	strscpy(netdev->name, "eth%d", sizeof(netdev->name));
 
 	dev = netdev_priv(netdev);
 	dev->udev = udev;
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index f7f037b399a7..8065af844410 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1722,7 +1722,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	dev->interrupt_count = 0;
 
 	dev->net = net;
-	strcpy (net->name, "usb%d");
+	strscpy(net->name, "usb%d", sizeof(net->name));
 	memcpy (net->dev_addr, node_id, sizeof node_id);
 
 	/* rx and tx sides can use different message sizes;
@@ -1749,13 +1749,13 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
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



