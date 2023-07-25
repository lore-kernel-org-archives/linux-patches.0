Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBFF15AC5
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55592C433C8;
	Tue, 25 Jul 2023 10:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282781;
	bh=p86FKTaCv156ZBMTJC2vFEVIUJWfeMNtL7FQCSkegt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYR7Sm/Lt6e1m5fRzfHwlWFJdOPDA+1ALjWa9nBCGjMWJDkQxRYV1KM0xb8naUCOc
	 Ccx/XqpnN8HYryNyVddy0hjGmGMwM0mQ6PusaO6xXBf4kP6xDKo+yu1b6lLSNy58Fv
	 AmeS1W5wnh2ZbKiSwqHf4URnv8rRSGLOLY63XLvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Whittington <git@jbrengineering.co.uk>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 024/183] can: gs_usb: gs_can_open(): improve error handling
Date: Tue, 25 Jul 2023 12:44:12 +0200
Message-ID: <20230725104508.763623999@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 2603be9e8167ddc7bea95dcfab9ffc33414215aa upstream.

The gs_usb driver handles USB devices with more than 1 CAN channel.
The RX path for all channels share the same bulk endpoint (the
transmitted bulk data encodes the channel number). These per-device
resources are allocated and submitted by the first opened channel.

During this allocation, the resources are either released immediately
in case of a failure or the URBs are anchored. All anchored URBs are
finally killed with gs_usb_disconnect().

Currently, gs_can_open() returns with an error if the allocation of a
URB or a buffer fails. However, if usb_submit_urb() fails, the driver
continues with the URBs submitted so far, even if no URBs were
successfully submitted.

Treat every error as fatal and free all allocated resources
immediately.

Switch to goto-style error handling, to prepare the driver for more
per-device resource allocation.

Cc: stable@vger.kernel.org
Cc: John Whittington <git@jbrengineering.co.uk>
Link: https://lore.kernel.org/all/20230716-gs_usb-fix-time-stamp-counter-v1-1-9017cefcd9d5@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -833,6 +833,7 @@ static int gs_can_open(struct net_device
 		.mode = cpu_to_le32(GS_CAN_MODE_START),
 	};
 	struct gs_host_frame *hf;
+	struct urb *urb = NULL;
 	u32 ctrlmode;
 	u32 flags = 0;
 	int rc, i;
@@ -858,13 +859,14 @@ static int gs_can_open(struct net_device
 
 	if (!parent->active_channels) {
 		for (i = 0; i < GS_MAX_RX_URBS; i++) {
-			struct urb *urb;
 			u8 *buf;
 
 			/* alloc rx urb */
 			urb = usb_alloc_urb(0, GFP_KERNEL);
-			if (!urb)
-				return -ENOMEM;
+			if (!urb) {
+				rc = -ENOMEM;
+				goto out_usb_kill_anchored_urbs;
+			}
 
 			/* alloc rx buffer */
 			buf = kmalloc(dev->parent->hf_size_rx,
@@ -872,8 +874,8 @@ static int gs_can_open(struct net_device
 			if (!buf) {
 				netdev_err(netdev,
 					   "No memory left for USB buffer\n");
-				usb_free_urb(urb);
-				return -ENOMEM;
+				rc = -ENOMEM;
+				goto out_usb_free_urb;
 			}
 
 			/* fill, anchor, and submit rx urb */
@@ -896,9 +898,7 @@ static int gs_can_open(struct net_device
 				netdev_err(netdev,
 					   "usb_submit failed (err=%d)\n", rc);
 
-				usb_unanchor_urb(urb);
-				usb_free_urb(urb);
-				break;
+				goto out_usb_unanchor_urb;
 			}
 
 			/* Drop reference,
@@ -944,7 +944,8 @@ static int gs_can_open(struct net_device
 		if (dev->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
 			gs_usb_timestamp_stop(dev);
 		dev->can.state = CAN_STATE_STOPPED;
-		return rc;
+
+		goto out_usb_kill_anchored_urbs;
 	}
 
 	parent->active_channels++;
@@ -952,6 +953,18 @@ static int gs_can_open(struct net_device
 		netif_start_queue(netdev);
 
 	return 0;
+
+out_usb_unanchor_urb:
+	usb_unanchor_urb(urb);
+out_usb_free_urb:
+	usb_free_urb(urb);
+out_usb_kill_anchored_urbs:
+	if (!parent->active_channels)
+		usb_kill_anchored_urbs(&dev->tx_submitted);
+
+	close_candev(netdev);
+
+	return rc;
 }
 
 static int gs_can_close(struct net_device *netdev)


