Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A19079C1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065C8C433C1;
	Wed, 30 Nov 2022 18:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834188;
	bh=dYd0xNwVf/TCWsrYuhU5F0XcagIG0+K2uZYMlvknrEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=na/2jAdL+u4Z7Cbb4pfa6sMHUmnNqshkKW93Q/CK5Hd6LKigmWtwjhufvWWbKu49+
	 8objCyjdurcv5bwe5cmELHc/tA+C7XesfmanHhLLi/h0/psCQO//XmLRy+Vl4hyz7Q
	 9EbPqk4xrHrU5d1gOt1TzfDbRQzGZL3t9BuvYoZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rhett Aultman <rhett.aultman@samsara.com>,
	Vasanth Sadhasivan <vasanth.sadhasivan@samsara.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.0 161/289] can: gs_usb: remove dma allocations
Date: Wed, 30 Nov 2022 19:22:26 +0100
Message-Id: <20221130180547.784552105@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vasanth Sadhasivan <vasanth.sadhasivan@samsara.com>

commit 62f102c0d1563ff6a31082f5d83b886ad2ff7ca0 upstream.

DMA allocated buffers are a precious resource. If there is no need for
DMA allocations, then it might be worth to use non-dma allocated
buffers.

After testing the gs_usb driver with and without DMA allocation, there
does not seem to be a significant change in latency or CPU utilization
either way. Therefore, DMA allocation is not necessary and removed.

Internal buffers used within urbs were managed and freed manually.
These buffers are no longer needed to be managed by the driver. The
URB_FREE_BUFFER flag, allows for the buffers in question to be
automatically freed.

Co-developed-by: Rhett Aultman <rhett.aultman@samsara.com>
Signed-off-by: Rhett Aultman <rhett.aultman@samsara.com>
Signed-off-by: Vasanth Sadhasivan <vasanth.sadhasivan@samsara.com>
Link: https://lore.kernel.org/all/20220920154724.861093-2-rhett.aultman@samsara.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |   39 ++++++---------------------------------
 1 file changed, 6 insertions(+), 33 deletions(-)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -268,8 +268,6 @@ struct gs_can {
 
 	struct usb_anchor tx_submitted;
 	atomic_t active_tx_urbs;
-	void *rxbuf[GS_MAX_RX_URBS];
-	dma_addr_t rxbuf_dma[GS_MAX_RX_URBS];
 };
 
 /* usb interface struct */
@@ -587,9 +585,6 @@ static void gs_usb_xmit_callback(struct
 
 	if (urb->status)
 		netdev_info(netdev, "usb xmit fail %u\n", txc->echo_id);
-
-	usb_free_coherent(urb->dev, urb->transfer_buffer_length,
-			  urb->transfer_buffer, urb->transfer_dma);
 }
 
 static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
@@ -618,8 +613,7 @@ static netdev_tx_t gs_can_start_xmit(str
 	if (!urb)
 		goto nomem_urb;
 
-	hf = usb_alloc_coherent(dev->udev, dev->hf_size_tx, GFP_ATOMIC,
-				&urb->transfer_dma);
+	hf = kmalloc(dev->hf_size_tx, GFP_ATOMIC);
 	if (!hf) {
 		netdev_err(netdev, "No memory left for USB buffer\n");
 		goto nomem_hf;
@@ -663,7 +657,7 @@ static netdev_tx_t gs_can_start_xmit(str
 			  hf, dev->hf_size_tx,
 			  gs_usb_xmit_callback, txc);
 
-	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+	urb->transfer_flags |= URB_FREE_BUFFER;
 	usb_anchor_urb(urb, &dev->tx_submitted);
 
 	can_put_echo_skb(skb, netdev, idx, 0);
@@ -678,8 +672,6 @@ static netdev_tx_t gs_can_start_xmit(str
 		gs_free_tx_context(txc);
 
 		usb_unanchor_urb(urb);
-		usb_free_coherent(dev->udev, urb->transfer_buffer_length,
-				  urb->transfer_buffer, urb->transfer_dma);
 
 		if (rc == -ENODEV) {
 			netif_device_detach(netdev);
@@ -699,8 +691,7 @@ static netdev_tx_t gs_can_start_xmit(str
 	return NETDEV_TX_OK;
 
  badidx:
-	usb_free_coherent(dev->udev, urb->transfer_buffer_length,
-			  urb->transfer_buffer, urb->transfer_dma);
+	kfree(hf);
  nomem_hf:
 	usb_free_urb(urb);
 
@@ -744,7 +735,6 @@ static int gs_can_open(struct net_device
 		for (i = 0; i < GS_MAX_RX_URBS; i++) {
 			struct urb *urb;
 			u8 *buf;
-			dma_addr_t buf_dma;
 
 			/* alloc rx urb */
 			urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -752,10 +742,8 @@ static int gs_can_open(struct net_device
 				return -ENOMEM;
 
 			/* alloc rx buffer */
-			buf = usb_alloc_coherent(dev->udev,
-						 dev->parent->hf_size_rx,
-						 GFP_KERNEL,
-						 &buf_dma);
+			buf = kmalloc(dev->parent->hf_size_rx,
+				      GFP_KERNEL);
 			if (!buf) {
 				netdev_err(netdev,
 					   "No memory left for USB buffer\n");
@@ -763,8 +751,6 @@ static int gs_can_open(struct net_device
 				return -ENOMEM;
 			}
 
-			urb->transfer_dma = buf_dma;
-
 			/* fill, anchor, and submit rx urb */
 			usb_fill_bulk_urb(urb,
 					  dev->udev,
@@ -773,7 +759,7 @@ static int gs_can_open(struct net_device
 					  buf,
 					  dev->parent->hf_size_rx,
 					  gs_usb_receive_bulk_callback, parent);
-			urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+			urb->transfer_flags |= URB_FREE_BUFFER;
 
 			usb_anchor_urb(urb, &parent->rx_submitted);
 
@@ -786,17 +772,10 @@ static int gs_can_open(struct net_device
 					   "usb_submit failed (err=%d)\n", rc);
 
 				usb_unanchor_urb(urb);
-				usb_free_coherent(dev->udev,
-						  sizeof(struct gs_host_frame),
-						  buf,
-						  buf_dma);
 				usb_free_urb(urb);
 				break;
 			}
 
-			dev->rxbuf[i] = buf;
-			dev->rxbuf_dma[i] = buf_dma;
-
 			/* Drop reference,
 			 * USB core will take care of freeing it
 			 */
@@ -854,7 +833,6 @@ static int gs_can_close(struct net_devic
 	int rc;
 	struct gs_can *dev = netdev_priv(netdev);
 	struct gs_usb *parent = dev->parent;
-	unsigned int i;
 
 	netif_stop_queue(netdev);
 
@@ -862,11 +840,6 @@ static int gs_can_close(struct net_devic
 	parent->active_channels--;
 	if (!parent->active_channels) {
 		usb_kill_anchored_urbs(&parent->rx_submitted);
-		for (i = 0; i < GS_MAX_RX_URBS; i++)
-			usb_free_coherent(dev->udev,
-					  sizeof(struct gs_host_frame),
-					  dev->rxbuf[i],
-					  dev->rxbuf_dma[i]);
 	}
 
 	/* Stop sending URBs */


