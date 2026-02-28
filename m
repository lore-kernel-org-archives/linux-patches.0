Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587E8346FA0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302257; cv=none; b=iyCpt2KT32GHBkoXW+fTSqCzZS/GeRZ0157lPTtZq49dOMNACqqsdk2O5ZipDvrwBeU3z0DxM/v1VNrkvoBgykg37raZMbSSf1rvobYO9F+TSeOpGq2KyJYdVlOHLc7S1Rlh1OjKouW7SQltFnnaveVCfB8joXqKgzn5PmGUm7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302257; c=relaxed/simple;
	bh=LRQ1iczmYPE7XT+j1t48YBVLzm7buiJbeSYIUIrY8I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozjttVL3pGg3mUetmzFVe0g9IT56XjI1Q38MLTFxz6+hb6fMrtwog7XGUfBm05E3n3L1XT2sOpTX3F7ULzcbKdKvgJ0mThxFjvVa8ZXU1Kosw/TcRhhF1Ons0P7a/le4eKyiJkGCRGKfxzj/zwQcMsF6kOebdpXMYeMV9kuNVug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GccVjTum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GccVjTum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9C4C19423;
	Sat, 28 Feb 2026 18:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302257;
	bh=LRQ1iczmYPE7XT+j1t48YBVLzm7buiJbeSYIUIrY8I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GccVjTum0BSw+djvvTd9cOU5phe/q0avGwQxHReCz9Mj58sAc32lwT1R9qFa97/9x
	 wyMMkUk1pE/jvAMff9gJ/vAnhH5rnv0Oaad2pIM5Xbrckx++ch0H7oqMmt56hKcwpr
	 ZT3iY/IFCsLVZak9a/BI0f+okPivNsuABMex1cA0bb2J1XKZjbaRmoPB8tWLb0sN1v
	 AlnDfIzZjKoaxdje/H07kx4mnaNBiEq3H6+darGoA/MZrYLxVOiTrtNHkiMy0CI1nI
	 JHnngCcXOFdR6Fshp3c+OkLl6kGBmkF34nyD2ButwJV0Cii3qHEA5K94dJ8lrKyoWQ
	 q/I4JbeINA1/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 271/283] net: usb: catc: enable basic endpoint checking
Date: Sat, 28 Feb 2026 13:06:53 -0500
Message-ID: <20260228180709.1583486-271-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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

