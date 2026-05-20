Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5719635AC18;
	Wed, 20 May 2026 17:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297541; cv=none; b=KGWgP5bDpnYPuhyXcGXEX4zepgx6vvskY0JL0CqCIcm7NWSpeYmveUlq7Qo+NAO3v+B/B+VfOlwe4dkeBEw0wYNsGXReN3Ksl9puViBnw/j/3qcAnex9lmFQPKOQkoiUmKYQeWvg3duLYsLIprvhOY+VDK73VmZ2CwwlkHzjn+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297541; c=relaxed/simple;
	bh=XzSLkbovYVDJooLQFancuZlk0bVPM1TfbQONOFEnV1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8ojjrtmUk7gP3JNfpd4Nq7JC9ty730QOQbquyrlTw4uVRNG4sEVgCGouC7dor86Khj4ydXuDIvgUkWBXl+Av8QcRFqOP7geZE9ipyluNbXTIN/NFfy6AS1jYzXATOiNI+Jh90VxlHHYcYrO21TjX4Lx7Joo6soGFuzD5ClO8G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MB2lszr6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MB2lszr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2BE1F000E9;
	Wed, 20 May 2026 17:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297540;
	bh=cATB/uBEBpr33/OnWEsl529eQNUM0ZbbTqTPqddaR9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MB2lszr6AjySZs+PWJWyd27a1RPEsdC1X5sme5UoXVd3yEReX+1G6NfgHlVW0Lo2N
	 pzDnnxcxDjyI/XovpJ2+9nnschZ3AHD6iUtYEohz90N0KW/Ye+gDP7Zn2aspsXIDaA
	 mbrcOdygPidAyL3La3yjYJR3XQSk+KaVLh8wma9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heitor Alves de Siqueira <halves@igalia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 069/957] wifi: libertas: use USB anchors for tracking in-flight URBs
Date: Wed, 20 May 2026 18:09:12 +0200
Message-ID: <20260520162136.061104495@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heitor Alves de Siqueira <halves@igalia.com>

[ Upstream commit a57f35fc19add4dfe33703af575a2c19c2cef9c7 ]

The libertas driver currently handles URB lifecycles manually, which
makes it non-trivial to check if specific URBs are pending or not. Add
anchors for TX/RX URBs, and use those to track in-flight requests.

Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Link: https://patch.msgid.link/20260313-libertas-usb-anchors-v1-1-915afbe988d7@igalia.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 7c5c2b661bdb ("wifi: libertas: don't kill URBs in interrupt context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/marvell/libertas/if_usb.c    | 27 ++++++++++++-------
 .../net/wireless/marvell/libertas/if_usb.h    |  3 +++
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
index 924ab93b7b671..60bfff523b918 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -114,8 +114,8 @@ static void if_usb_write_bulk_callback(struct urb *urb)
 static void if_usb_free(struct if_usb_card *cardp)
 {
 	/* Unlink tx & rx urb */
-	usb_kill_urb(cardp->tx_urb);
-	usb_kill_urb(cardp->rx_urb);
+	usb_kill_anchored_urbs(&cardp->tx_submitted);
+	usb_kill_anchored_urbs(&cardp->rx_submitted);
 
 	usb_free_urb(cardp->tx_urb);
 	cardp->tx_urb = NULL;
@@ -221,6 +221,9 @@ static int if_usb_probe(struct usb_interface *intf,
 		     udev->descriptor.bDeviceSubClass,
 		     udev->descriptor.bDeviceProtocol);
 
+	init_usb_anchor(&cardp->rx_submitted);
+	init_usb_anchor(&cardp->tx_submitted);
+
 	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
 		endpoint = &iface_desc->endpoint[i].desc;
 		if (usb_endpoint_is_bulk_in(endpoint)) {
@@ -426,7 +429,7 @@ static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload, uint16_t nb
 		goto tx_ret;
 	}
 
-	usb_kill_urb(cardp->tx_urb);
+	usb_kill_anchored_urbs(&cardp->tx_submitted);
 
 	usb_fill_bulk_urb(cardp->tx_urb, cardp->udev,
 			  usb_sndbulkpipe(cardp->udev,
@@ -435,8 +438,10 @@ static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload, uint16_t nb
 
 	cardp->tx_urb->transfer_flags |= URB_ZERO_PACKET;
 
+	usb_anchor_urb(cardp->tx_urb, &cardp->tx_submitted);
 	if ((ret = usb_submit_urb(cardp->tx_urb, GFP_ATOMIC))) {
 		lbs_deb_usbd(&cardp->udev->dev, "usb_submit_urb failed: %d\n", ret);
+		usb_unanchor_urb(cardp->tx_urb);
 	} else {
 		lbs_deb_usb2(&cardp->udev->dev, "usb_submit_urb success\n");
 		ret = 0;
@@ -467,8 +472,10 @@ static int __if_usb_submit_rx_urb(struct if_usb_card *cardp,
 			  cardp);
 
 	lbs_deb_usb2(&cardp->udev->dev, "Pointer for rx_urb %p\n", cardp->rx_urb);
+	usb_anchor_urb(cardp->rx_urb, &cardp->rx_submitted);
 	if ((ret = usb_submit_urb(cardp->rx_urb, GFP_ATOMIC))) {
 		lbs_deb_usbd(&cardp->udev->dev, "Submit Rx URB failed: %d\n", ret);
+		usb_unanchor_urb(cardp->rx_urb);
 		kfree_skb(skb);
 		cardp->rx_skb = NULL;
 		ret = -1;
@@ -838,8 +845,8 @@ static void if_usb_prog_firmware(struct lbs_private *priv, int ret,
 	}
 
 	/* Cancel any pending usb business */
-	usb_kill_urb(cardp->rx_urb);
-	usb_kill_urb(cardp->tx_urb);
+	usb_kill_anchored_urbs(&cardp->rx_submitted);
+	usb_kill_anchored_urbs(&cardp->tx_submitted);
 
 	cardp->fwlastblksent = 0;
 	cardp->fwdnldover = 0;
@@ -869,8 +876,8 @@ static void if_usb_prog_firmware(struct lbs_private *priv, int ret,
 	if (cardp->bootcmdresp == BOOT_CMD_RESP_NOT_SUPPORTED) {
 		/* Return to normal operation */
 		ret = -EOPNOTSUPP;
-		usb_kill_urb(cardp->rx_urb);
-		usb_kill_urb(cardp->tx_urb);
+		usb_kill_anchored_urbs(&cardp->rx_submitted);
+		usb_kill_anchored_urbs(&cardp->tx_submitted);
 		if (if_usb_submit_rx_urb(cardp) < 0)
 			ret = -EIO;
 		goto done;
@@ -900,7 +907,7 @@ static void if_usb_prog_firmware(struct lbs_private *priv, int ret,
 	wait_event_interruptible(cardp->fw_wq, cardp->surprise_removed || cardp->fwdnldover);
 
 	timer_delete_sync(&cardp->fw_timeout);
-	usb_kill_urb(cardp->rx_urb);
+	usb_kill_anchored_urbs(&cardp->rx_submitted);
 
 	if (!cardp->fwdnldover) {
 		pr_info("failed to load fw, resetting device!\n");
@@ -960,8 +967,8 @@ static int if_usb_suspend(struct usb_interface *intf, pm_message_t message)
 		goto out;
 
 	/* Unlink tx & rx urb */
-	usb_kill_urb(cardp->tx_urb);
-	usb_kill_urb(cardp->rx_urb);
+	usb_kill_anchored_urbs(&cardp->tx_submitted);
+	usb_kill_anchored_urbs(&cardp->rx_submitted);
 
  out:
 	return ret;
diff --git a/drivers/net/wireless/marvell/libertas/if_usb.h b/drivers/net/wireless/marvell/libertas/if_usb.h
index 7d0daeb33c3f7..a0cd36197c2b0 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.h
+++ b/drivers/net/wireless/marvell/libertas/if_usb.h
@@ -48,6 +48,9 @@ struct if_usb_card {
 	struct urb *rx_urb, *tx_urb;
 	struct lbs_private *priv;
 
+	struct usb_anchor rx_submitted;
+	struct usb_anchor tx_submitted;
+
 	struct sk_buff *rx_skb;
 
 	uint8_t ep_in;
-- 
2.53.0



