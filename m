Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6C03093D7;
	Mon,  1 Dec 2025 11:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588355; cv=none; b=ZI7HohegCxGAx3DjYT+c8yBfv3xQvRu/ruvuUjPwln6gOH5mDdOK7JBqGQTeMut2347z5/3/WzC90wCczqMKccrAbiutM0mL5ioGSanjpSF+Uqb62PF3VlRSjBkfTfFar0lusbj2qZfMIJRLjLkqPqtXxjWifvSx1T8mlpbXXhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588355; c=relaxed/simple;
	bh=AOzZ9ESo29y8jD16W4AVtQ878LG89katFzWYl9I3X+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThJRvzG+GPqa5u+y6Sqq0YDavLQ98xTn/z5XhfKK7snzavE0ifIK372yltkZ5a/OtZpRTxhKlri5l26Ubd1wHEe04wYQwaQlPAjdz+2manxeXIMUdFXBWMAOr1af5mJTAYdI1663P4PFMeY1FdGfhuVGx7fcQfdPGLBwF7GZ8e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ah014dsZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ah014dsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C1AC116D0;
	Mon,  1 Dec 2025 11:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588355;
	bh=AOzZ9ESo29y8jD16W4AVtQ878LG89katFzWYl9I3X+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ah014dsZQMhfh9/fdQbawlpmB5MQsm3P8vpgv2IBg1idAQ5TjvpC3nKPkYP+1ZfB1
	 /LMlScZTN/qCbqqJ5MaMaV/ynWKh7HKxXzATHZCvenPfAVQVvavlz1OVA9izygCy7A
	 0gfDwW69FxXIkjf3+ayZtlREplhH4EC1qDmMoNNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runcheng Lu <runcheng.lu@hpmicro.com>,
	Vincent Mailhol <mailhol@kernel.org>,
	Celeste Liu <uwu@coelacanthus.name>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 020/187] can: gs_usb: increase max interface to U8_MAX
Date: Mon,  1 Dec 2025 12:22:08 +0100
Message-ID: <20251201112241.985227265@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Celeste Liu <uwu@coelacanthus.name>

commit 2a27f6a8fb5722223d526843040f747e9b0e8060 upstream

This issue was found by Runcheng Lu when develop HSCanT USB to CAN FD
converter[1]. The original developers may have only 3 interfaces
device to test so they write 3 here and wait for future change.

During the HSCanT development, we actually used 4 interfaces, so the
limitation of 3 is not enough now. But just increase one is not
future-proofed. Since the channel index type in gs_host_frame is u8,
just make canch[] become a flexible array with a u8 index, so it
naturally constraint by U8_MAX and avoid statically allocate 256
pointer for every gs_usb device.

[1]: https://github.com/cherry-embedded/HSCanT-hardware

Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Reported-by: Runcheng Lu <runcheng.lu@hpmicro.com>
Cc: stable@vger.kernel.org
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Signed-off-by: Celeste Liu <uwu@coelacanthus.name>
Link: https://patch.msgid.link/20250930-gs-usb-max-if-v5-1-863330bf6666@coelacanthus.name
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -156,10 +156,6 @@ struct gs_host_frame {
 #define GS_MAX_TX_URBS 10
 /* Only launch a max of GS_MAX_RX_URBS usb requests at a time. */
 #define GS_MAX_RX_URBS 30
-/* Maximum number of interfaces the driver supports per device.
- * Current hardware only supports 2 interfaces. The future may vary.
- */
-#define GS_MAX_INTF 2
 
 struct gs_tx_context {
 	struct gs_can *dev;
@@ -190,10 +186,11 @@ struct gs_can {
 
 /* usb interface struct */
 struct gs_usb {
-	struct gs_can *canch[GS_MAX_INTF];
 	struct usb_anchor rx_submitted;
 	struct usb_device *udev;
 	u8 active_channels;
+	u8 channel_cnt;
+	struct gs_can *canch[];
 };
 
 /* 'allocate' a tx context.
@@ -321,7 +318,7 @@ static void gs_usb_receive_bulk_callback
 	}
 
 	/* device reports out of range channel id */
-	if (hf->channel >= GS_MAX_INTF)
+	if (hf->channel >= usbcan->channel_cnt)
 		goto device_detach;
 
 	dev = usbcan->canch[hf->channel];
@@ -409,7 +406,7 @@ static void gs_usb_receive_bulk_callback
 	/* USB failure take down all interfaces */
 	if (rc == -ENODEV) {
  device_detach:
-		for (rc = 0; rc < GS_MAX_INTF; rc++) {
+		for (rc = 0; rc < usbcan->channel_cnt; rc++) {
 			if (usbcan->canch[rc])
 				netif_device_detach(usbcan->canch[rc]->netdev);
 		}
@@ -991,20 +988,22 @@ static int gs_usb_probe(struct usb_inter
 	icount = dconf->icount + 1;
 	dev_info(&intf->dev, "Configuring for %d interfaces\n", icount);
 
-	if (icount > GS_MAX_INTF) {
+	if (icount > type_max(typeof(dev->channel_cnt))) {
 		dev_err(&intf->dev,
-			"Driver cannot handle more that %d CAN interfaces\n",
-			GS_MAX_INTF);
+			"Driver cannot handle more that %u CAN interfaces\n",
+			type_max(typeof(dev->channel_cnt)));
 		kfree(dconf);
 		return -EINVAL;
 	}
 
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	dev = kzalloc(struct_size(dev, canch, icount), GFP_KERNEL);
 	if (!dev) {
 		kfree(dconf);
 		return -ENOMEM;
 	}
 
+	dev->channel_cnt = icount;
+
 	init_usb_anchor(&dev->rx_submitted);
 
 	usb_set_intfdata(intf, dev);
@@ -1045,7 +1044,7 @@ static void gs_usb_disconnect(struct usb
 		return;
 	}
 
-	for (i = 0; i < GS_MAX_INTF; i++)
+	for (i = 0; i < dev->channel_cnt; i++)
 		if (dev->canch[i])
 			gs_destroy_candev(dev->canch[i]);
 


