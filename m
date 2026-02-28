Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F5C34A76A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302766; cv=none; b=h0mN0OUy6QUFhyti88tyfwhI6TtVriC+usldEyJBGhBUyRsg4h28Gmjg+gBGTbAGsWaAa7JlbI4p3nCZK5+denQeXAUR4BeHU/JSPYl0X4Rsin6SQ7ZP1GuglvRyKQthGdY+7mIaTWX3AZ1/JE+EKVfDPWLUdvNsBCt2wxdJDJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302766; c=relaxed/simple;
	bh=MKhO2WtWug21pFFBZoSx1HSG9huN4oWmczmDO+juHGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqTlE+OSOUz75Ktghj88WWgF1Xh/6fHBSHB5cqJjj4TYAck9n9aCyHB5iqXHXDvEwNSH8q1okjLAJFFAekd8Uzx8wqIWUWXPzmvYd01/7EnOojS0CEWKlZsIJAXB+rKE9ukCtgn5esOpCRdVNOJZf7xKvS66QrLPj6q5lVwfsgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZkXpF8FN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZkXpF8FN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4699CC19423;
	Sat, 28 Feb 2026 18:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302766;
	bh=MKhO2WtWug21pFFBZoSx1HSG9huN4oWmczmDO+juHGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZkXpF8FNxlYaBvzyecTJM46rPnzJad2cX+7TjcTHleaSJ3r00ZXgKiJkXvxF278Xy
	 jY/buEjWloNDFTWKAACbSehfqjGL6G8tBeKVObvqMgvMaHlf4tRj8sxdBFYUOdItuz
	 qM2KUKd5W9kpIfXr8t4PvwM0dDpCKr/5ypMgdGAni8XLT4uBQ1tYzAMOvzaOXxWoWz
	 8tU3m6BSkz6Jkt5wd3r7yeABP5G6ayb7jULKDbmeDmfl79mprxaE5x5zxU2PSUCHTM
	 J300I46xfUIQC5k5v6udKYUYzB/GkAoQf0NLtMTKAtkivBNk4q/5mc6eZxkC4daO/B
	 c5N4D45atFAiA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Oliver Neukum <oneukum@suse.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 138/147] usbb: catc: use correct API for MAC addresses
Date: Sat, 28 Feb 2026 13:17:26 -0500
Message-ID: <20260228181736.1605592-138-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 7ce9a701ac8f44798e46dede02b924504dc65a5c ]

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

In the case of catc we need a new temporary buffer to conform
to the rules for DMA coherency. That in turn necessitates
a reworking of error handling in probe().

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9e7021d2aeae ("net: usb: catc: enable basic endpoint checking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/catc.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/catc.c b/drivers/net/usb/catc.c
index 97ba67042d126..6502f78aeddaa 100644
--- a/drivers/net/usb/catc.c
+++ b/drivers/net/usb/catc.c
@@ -770,17 +770,23 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
 	struct net_device *netdev;
 	struct catc *catc;
 	u8 broadcast[ETH_ALEN];
-	int pktsz, ret;
+	u8 *macbuf;
+	int pktsz, ret = -ENOMEM;
+
+	macbuf = kmalloc(ETH_ALEN, GFP_KERNEL);
+	if (!macbuf)
+		goto error;
 
 	if (usb_set_interface(usbdev,
 			intf->altsetting->desc.bInterfaceNumber, 1)) {
 		dev_err(dev, "Can't set altsetting 1.\n");
-		return -EIO;
+		ret = -EIO;
+		goto fail_mem;;
 	}
 
 	netdev = alloc_etherdev(sizeof(struct catc));
 	if (!netdev)
-		return -ENOMEM;
+		goto fail_mem;
 
 	catc = netdev_priv(netdev);
 
@@ -870,7 +876,8 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
 	  
 		dev_dbg(dev, "Getting MAC from SEEROM.\n");
 	  
-		catc_get_mac(catc, netdev->dev_addr);
+		catc_get_mac(catc, macbuf);
+		eth_hw_addr_set(netdev, macbuf);
 		
 		dev_dbg(dev, "Setting MAC into registers.\n");
 	  
@@ -899,7 +906,8 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
 	} else {
 		dev_dbg(dev, "Performing reset\n");
 		catc_reset(catc);
-		catc_get_mac(catc, netdev->dev_addr);
+		catc_get_mac(catc, macbuf);
+		eth_hw_addr_set(netdev, macbuf);
 		
 		dev_dbg(dev, "Setting RX Mode\n");
 		catc->rxmode[0] = RxEnable | RxPolarity | RxMultiCast;
@@ -917,6 +925,7 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
 	if (ret)
 		goto fail_clear_intfdata;
 
+	kfree(macbuf);
 	return 0;
 
 fail_clear_intfdata:
@@ -927,6 +936,9 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
 	usb_free_urb(catc->rx_urb);
 	usb_free_urb(catc->irq_urb);
 	free_netdev(netdev);
+fail_mem:
+	kfree(macbuf);
+error:
 	return ret;
 }
 
-- 
2.51.0

