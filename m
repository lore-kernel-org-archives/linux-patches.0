Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1093B1BD005;
	Tue,  2 Jul 2024 17:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941594; cv=none; b=saXV1ryz3AsSkNi1OH6BoMN0rfKgYQxeUCkKTCKVaciN6b87sYRuKpLS7jRsqfvWKSXVn9e7qgGZumnLjqqkMsdZH35G7yr1YSXADTJG3K9PxBiSbQR+OxAu703OL1c4r9EisVGkOBE3ONz+s8EliR/C3VrWbQ9aFCzHY1R24VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941594; c=relaxed/simple;
	bh=C8lCJXRQTt1eRPHBhLK4B57jZsyLqxCii8knjmFBo1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSGzg4ZhCAWkN+lfu2ObfG2jEg/yor711xUmYf+fysGibLhG7a06fb1AuDmG8p+pphivtNWCBJB6SYPByRrXLMNeI1KNuEdvhyXfZe2W6VBi8H6neNIW/GSjXuXXwmB8mRC2gTEXsdLklUR6TkQYn37+2aH0WPWdLtkMPvXrh/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvhbgusa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvhbgusa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75694C116B1;
	Tue,  2 Jul 2024 17:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941593;
	bh=C8lCJXRQTt1eRPHBhLK4B57jZsyLqxCii8knjmFBo1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvhbgusadbWL7yu1SqS3o7sI3ZW7jUAJ6b0MSIeOvEoCCbmUguCBICXniFoa5gY4P
	 WsAwX8tdmpMG0YtNFP/FWagmTiqnsKtk1DWmRGo9uLBE5V43jdeYYMhccU63UU5349
	 awAiuibC+dPE6sY5LNRxB6k4LKGrE1Ak0/iAYkBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitor Soares <vitor.soares@toradex.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 111/128] can: mcp251xfd: fix infinite loop when xmit fails
Date: Tue,  2 Jul 2024 19:05:12 +0200
Message-ID: <20240702170230.420544455@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitor Soares <vitor.soares@toradex.com>

commit d8fb63e46c884c898a38f061c2330f7729e75510 upstream.

When the mcp251xfd_start_xmit() function fails, the driver stops
processing messages, and the interrupt routine does not return,
running indefinitely even after killing the running application.

Error messages:
[  441.298819] mcp251xfd spi2.0 can0: ERROR in mcp251xfd_start_xmit: -16
[  441.306498] mcp251xfd spi2.0 can0: Transmit Event FIFO buffer not empty. (seq=0x000017c7, tef_tail=0x000017cf, tef_head=0x000017d0, tx_head=0x000017d3).
... and repeat forever.

The issue can be triggered when multiple devices share the same SPI
interface. And there is concurrent access to the bus.

The problem occurs because tx_ring->head increments even if
mcp251xfd_start_xmit() fails. Consequently, the driver skips one TX
package while still expecting a response in
mcp251xfd_handle_tefif_one().

Resolve the issue by starting a workqueue to write the tx obj
synchronously if err = -EBUSY. In case of another error, decrement
tx_ring->head, remove skb from the echo stack, and drop the message.

Fixes: 55e5b97f003e ("can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN")
Cc: stable@vger.kernel.org
Signed-off-by: Vitor Soares <vitor.soares@toradex.com>
Link: https://lore.kernel.org/all/20240517134355.770777-1-ivitro@gmail.com
[mkl: use more imperative wording in patch description]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c |   14 +++++-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c   |   55 +++++++++++++++++++++----
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h      |    5 ++
 3 files changed, 65 insertions(+), 9 deletions(-)

--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1618,11 +1618,20 @@ static int mcp251xfd_open(struct net_dev
 	clear_bit(MCP251XFD_FLAGS_DOWN, priv->flags);
 	can_rx_offload_enable(&priv->offload);
 
+	priv->wq = alloc_ordered_workqueue("%s-mcp251xfd_wq",
+					   WQ_FREEZABLE | WQ_MEM_RECLAIM,
+					   dev_name(&spi->dev));
+	if (!priv->wq) {
+		err = -ENOMEM;
+		goto out_can_rx_offload_disable;
+	}
+	INIT_WORK(&priv->tx_work, mcp251xfd_tx_obj_write_sync);
+
 	err = request_threaded_irq(spi->irq, NULL, mcp251xfd_irq,
 				   IRQF_SHARED | IRQF_ONESHOT,
 				   dev_name(&spi->dev), priv);
 	if (err)
-		goto out_can_rx_offload_disable;
+		goto out_destroy_workqueue;
 
 	err = mcp251xfd_chip_interrupts_enable(priv);
 	if (err)
@@ -1634,6 +1643,8 @@ static int mcp251xfd_open(struct net_dev
 
  out_free_irq:
 	free_irq(spi->irq, priv);
+ out_destroy_workqueue:
+	destroy_workqueue(priv->wq);
  out_can_rx_offload_disable:
 	can_rx_offload_disable(&priv->offload);
 	set_bit(MCP251XFD_FLAGS_DOWN, priv->flags);
@@ -1661,6 +1672,7 @@ static int mcp251xfd_stop(struct net_dev
 	hrtimer_cancel(&priv->tx_irq_timer);
 	mcp251xfd_chip_interrupts_disable(priv);
 	free_irq(ndev->irq, priv);
+	destroy_workqueue(priv->wq);
 	can_rx_offload_disable(&priv->offload);
 	mcp251xfd_timestamp_stop(priv);
 	mcp251xfd_chip_stop(priv, CAN_STATE_STOPPED);
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c
@@ -131,6 +131,39 @@ mcp251xfd_tx_obj_from_skb(const struct m
 	tx_obj->xfer[0].len = len;
 }
 
+static void mcp251xfd_tx_failure_drop(const struct mcp251xfd_priv *priv,
+				      struct mcp251xfd_tx_ring *tx_ring,
+				      int err)
+{
+	struct net_device *ndev = priv->ndev;
+	struct net_device_stats *stats = &ndev->stats;
+	unsigned int frame_len = 0;
+	u8 tx_head;
+
+	tx_ring->head--;
+	stats->tx_dropped++;
+	tx_head = mcp251xfd_get_tx_head(tx_ring);
+	can_free_echo_skb(ndev, tx_head, &frame_len);
+	netdev_completed_queue(ndev, 1, frame_len);
+	netif_wake_queue(ndev);
+
+	if (net_ratelimit())
+		netdev_err(priv->ndev, "ERROR in %s: %d\n", __func__, err);
+}
+
+void mcp251xfd_tx_obj_write_sync(struct work_struct *work)
+{
+	struct mcp251xfd_priv *priv = container_of(work, struct mcp251xfd_priv,
+						   tx_work);
+	struct mcp251xfd_tx_obj *tx_obj = priv->tx_work_obj;
+	struct mcp251xfd_tx_ring *tx_ring = priv->tx;
+	int err;
+
+	err = spi_sync(priv->spi, &tx_obj->msg);
+	if (err)
+		mcp251xfd_tx_failure_drop(priv, tx_ring, err);
+}
+
 static int mcp251xfd_tx_obj_write(const struct mcp251xfd_priv *priv,
 				  struct mcp251xfd_tx_obj *tx_obj)
 {
@@ -162,6 +195,11 @@ static bool mcp251xfd_tx_busy(const stru
 	return false;
 }
 
+static bool mcp251xfd_work_busy(struct work_struct *work)
+{
+	return work_busy(work);
+}
+
 netdev_tx_t mcp251xfd_start_xmit(struct sk_buff *skb,
 				 struct net_device *ndev)
 {
@@ -175,7 +213,8 @@ netdev_tx_t mcp251xfd_start_xmit(struct
 	if (can_dev_dropped_skb(ndev, skb))
 		return NETDEV_TX_OK;
 
-	if (mcp251xfd_tx_busy(priv, tx_ring))
+	if (mcp251xfd_tx_busy(priv, tx_ring) ||
+	    mcp251xfd_work_busy(&priv->tx_work))
 		return NETDEV_TX_BUSY;
 
 	tx_obj = mcp251xfd_get_tx_obj_next(tx_ring);
@@ -193,13 +232,13 @@ netdev_tx_t mcp251xfd_start_xmit(struct
 		netdev_sent_queue(priv->ndev, frame_len);
 
 	err = mcp251xfd_tx_obj_write(priv, tx_obj);
-	if (err)
-		goto out_err;
-
-	return NETDEV_TX_OK;
-
- out_err:
-	netdev_err(priv->ndev, "ERROR in %s: %d\n", __func__, err);
+	if (err == -EBUSY) {
+		netif_stop_queue(ndev);
+		priv->tx_work_obj = tx_obj;
+		queue_work(priv->wq, &priv->tx_work);
+	} else if (err) {
+		mcp251xfd_tx_failure_drop(priv, tx_ring, err);
+	}
 
 	return NETDEV_TX_OK;
 }
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -628,6 +628,10 @@ struct mcp251xfd_priv {
 	struct mcp251xfd_rx_ring *rx[MCP251XFD_FIFO_RX_NUM];
 	struct mcp251xfd_tx_ring tx[MCP251XFD_FIFO_TX_NUM];
 
+	struct workqueue_struct *wq;
+	struct work_struct tx_work;
+	struct mcp251xfd_tx_obj *tx_work_obj;
+
 	DECLARE_BITMAP(flags, __MCP251XFD_FLAGS_SIZE__);
 
 	u8 rx_ring_num;
@@ -934,6 +938,7 @@ void mcp251xfd_skb_set_timestamp(const s
 void mcp251xfd_timestamp_init(struct mcp251xfd_priv *priv);
 void mcp251xfd_timestamp_stop(struct mcp251xfd_priv *priv);
 
+void mcp251xfd_tx_obj_write_sync(struct work_struct *work);
 netdev_tx_t mcp251xfd_start_xmit(struct sk_buff *skb,
 				 struct net_device *ndev);
 


