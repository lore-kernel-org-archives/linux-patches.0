Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB5B32ED2A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301936; cv=none; b=t6vGZLsFNqiUsXXSVZLtDN5VXAU5hp+oioULt9wKvk/yL/OyvtviDsLPpw11JmZAgnZMjkaKBQ1bwomMUhkTqt6GMytudCj1fjWIByLMOn/XI9iV/vTYouqokcI4P36L0GYbGfKTpIVyyKbKjgjG0bvCQd7KDZaXr7v8NilcieM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301936; c=relaxed/simple;
	bh=LRQ1iczmYPE7XT+j1t48YBVLzm7buiJbeSYIUIrY8I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCKZxPBaju1yBMq82tpZt3B2pNffYycJ0X0IDBRWR9p4ooi72O4GOo86QWcdG3/T3VISj+ZVDzLt5/W/XtjFrVXXgT7iyuroANfCOhl5DN4zKlpMSJ0eHKFDIgAux16MxB7gaUd0sR8c5yu26yAzHtAsidQeDmKkWGGEUDgOA0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nBwHH2AR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nBwHH2AR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAB0C19423;
	Sat, 28 Feb 2026 18:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301936;
	bh=LRQ1iczmYPE7XT+j1t48YBVLzm7buiJbeSYIUIrY8I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nBwHH2ARep4JGcA5obZ2ylwHn51wVq5488Gsd8mUqwXs79JB+FFzxHRnjVk4glJRa
	 1/U/G+bzhgR1s0+NTi+IJTvh8lOx4QM7bQODWHc6JpuYYFkRTIU98IP/Mh5yl8tSjb
	 fj3+oUOou7txA053KUwJy+1lNdBNJnfN4jVZHuha6UMYBt668hVjlUX6UcNFMB+zZt
	 3oagTolb/QA6AFhQOrr8IAguShJz6JB9k03w7kT/997CKXF+eiBvUQOoSYyVNTRE27
	 omEhEatF69TRjH/UegkvPxTTGm5Ni0gYQ5YXd73yUvxMTqkZd+B7N3x8L4P9BsfWUk
	 8cvy/d3tLUYgQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 372/385] net: usb: catc: enable basic endpoint checking
Date: Sat, 28 Feb 2026 12:59:54 -0500
Message-ID: <20260228180011.1568201-372-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit 9e7021d2aeae57c323a6f722ed7915686cdcc123 ]

catc_probe() fills three URBs with hardcoded endpoint pipes without
verifying the endpoint descriptors:

  - usb_sndbulkpipe(usbdev, 1) and usb_rcvbulkpipe(usbdev, 1) for TX/RX
  - usb_rcvintpipe(usbdev, 2) for interrupt status

A malformed USB device can present these endpoints with transfer types
that differ from what the driver assumes.

Add a catc_usb_ep enum for endpoint numbers, replacing magic constants
throughout. Add usb_check_bulk_endpoints() and usb_check_int_endpoints()
calls after usb_set_interface() to verify endpoint types before use,
rejecting devices with mismatched descriptors at probe time.

Similar to
- commit 90b7f2961798 ("net: usb: rtl8150: enable basic endpoint checking")
which fixed the issue in rtl8150.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Simon Horman <horms@kernel.org>
Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Link: https://patch.msgid.link/20260212214154.3609844-1-n7l8m4@u.northwestern.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/catc.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/catc.c b/drivers/net/usb/catc.c
index ff439ef535ac9..98346cb4ece01 100644
--- a/drivers/net/usb/catc.c
+++ b/drivers/net/usb/catc.c
@@ -64,6 +64,16 @@ static const char driver_name[] = "catc";
 #define CTRL_QUEUE		16	/* Max control requests in flight (power of two) */
 #define RX_PKT_SZ		1600	/* Max size of receive packet for F5U011 */
 
+/*
+ * USB endpoints.
+ */
+
+enum catc_usb_ep {
+	CATC_USB_EP_CONTROL	= 0,
+	CATC_USB_EP_BULK	= 1,
+	CATC_USB_EP_INT_IN	= 2,
+};
+
 /*
  * Control requests.
  */
@@ -772,6 +782,13 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
 	u8 broadcast[ETH_ALEN];
 	u8 *macbuf;
 	int pktsz, ret = -ENOMEM;
+	static const u8 bulk_ep_addr[] = {
+		CATC_USB_EP_BULK | USB_DIR_OUT,
+		CATC_USB_EP_BULK | USB_DIR_IN,
+		0};
+	static const u8 int_ep_addr[] = {
+		CATC_USB_EP_INT_IN | USB_DIR_IN,
+		0};
 
 	macbuf = kmalloc(ETH_ALEN, GFP_KERNEL);
 	if (!macbuf)
@@ -784,6 +801,14 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
 		goto fail_mem;
 	}
 
+	/* Verify that all required endpoints are present */
+	if (!usb_check_bulk_endpoints(intf, bulk_ep_addr) ||
+	    !usb_check_int_endpoints(intf, int_ep_addr)) {
+		dev_err(dev, "Missing or invalid endpoints\n");
+		ret = -ENODEV;
+		goto fail_mem;
+	}
+
 	netdev = alloc_etherdev(sizeof(struct catc));
 	if (!netdev)
 		goto fail_mem;
@@ -828,14 +853,14 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
 	usb_fill_control_urb(catc->ctrl_urb, usbdev, usb_sndctrlpipe(usbdev, 0),
 		NULL, NULL, 0, catc_ctrl_done, catc);
 
-	usb_fill_bulk_urb(catc->tx_urb, usbdev, usb_sndbulkpipe(usbdev, 1),
-		NULL, 0, catc_tx_done, catc);
+	usb_fill_bulk_urb(catc->tx_urb, usbdev, usb_sndbulkpipe(usbdev, CATC_USB_EP_BULK),
+			  NULL, 0, catc_tx_done, catc);
 
-	usb_fill_bulk_urb(catc->rx_urb, usbdev, usb_rcvbulkpipe(usbdev, 1),
-		catc->rx_buf, pktsz, catc_rx_done, catc);
+	usb_fill_bulk_urb(catc->rx_urb, usbdev, usb_rcvbulkpipe(usbdev, CATC_USB_EP_BULK),
+			  catc->rx_buf, pktsz, catc_rx_done, catc);
 
-	usb_fill_int_urb(catc->irq_urb, usbdev, usb_rcvintpipe(usbdev, 2),
-                catc->irq_buf, 2, catc_irq_done, catc, 1);
+	usb_fill_int_urb(catc->irq_urb, usbdev, usb_rcvintpipe(usbdev, CATC_USB_EP_INT_IN),
+			 catc->irq_buf, 2, catc_irq_done, catc, 1);
 
 	if (!catc->is_f5u011) {
 		u32 *buf;
-- 
2.51.0

