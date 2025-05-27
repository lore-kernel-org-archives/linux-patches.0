Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2584F27D766;
	Tue, 27 May 2025 17:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368531; cv=none; b=mfImQKWnMtGNyYLL3V/8HacnjLmzIakAUlVA+O9L8VLsi0MSYMKuOsmZ4K3TFAwXJ86REe1JMyxs/gbJdVZIjPKMeAT9TiPZ8oTxRZGesoQjTd/7ZZ1tq9UnKbdP9eWTqm8+gHQd4RF81ivmBlwF2w7IDOA0lOEMcM8uZzGSfZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368531; c=relaxed/simple;
	bh=KAOcxV4GYjOFGMoFhN09Hu8tPLmOvu/5wtn7eELketM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plQtFLn30K9V9v9cQnDwPLhDiBe6J8BbllSCUSXJkxPTPnx2E2CWMvl1og701NZWkqYACGTzeIG2pvBD89iX0UB8GaN/85n0uuedXl2je/XK5aqtdXDDYZHjREWF5THGXwpQheexd0QnntYyPBHCpa6lS6ChwUAOtxIHD8+znGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQpy1xSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQpy1xSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B68C4CEE9;
	Tue, 27 May 2025 17:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368531;
	bh=KAOcxV4GYjOFGMoFhN09Hu8tPLmOvu/5wtn7eELketM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQpy1xSR47L/3PWbg/x4tFTi7JDm04ta3mvJd0Al3xmNF4qZ0dE4euVNqJut4Zhca
	 DeXr9Ks09Fjn5+x1B6KuNVBGcLEuY9BNQ7mrqBpRnpbtH4rKAhk/8kW1YuTKBoPcJr
	 rycxuT8m2uyTOTIQHA+8eIyECI9/MD/wRB0mnr50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Axel Forsman <axfo@kvaser.com>,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.14 735/783] can: kvaser_pciefd: Fix echo_skb race
Date: Tue, 27 May 2025 18:28:52 +0200
Message-ID: <20250527162543.056487034@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Forsman <axfo@kvaser.com>

commit 8256e0ca601051933e9395746817f3801fa9a6bf upstream.

The functions kvaser_pciefd_start_xmit() and
kvaser_pciefd_handle_ack_packet() raced to stop/wake TX queues and
get/put echo skbs, as kvaser_pciefd_can->echo_lock was only ever taken
when transmitting and KCAN_TX_NR_PACKETS_CURRENT gets decremented
prior to handling of ACKs. E.g., this caused the following error:

    can_put_echo_skb: BUG! echo_skb 5 is occupied!

Instead, use the synchronization helpers in netdev_queues.h. As those
piggyback on BQL barriers, start updating in-flight packets and bytes
counts as well.

Cc: stable@vger.kernel.org
Signed-off-by: Axel Forsman <axfo@kvaser.com>
Tested-by: Jimmy Assarsson <extja@kvaser.com>
Reviewed-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://patch.msgid.link/20250520114332.8961-3-axfo@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/kvaser_pciefd.c |   93 +++++++++++++++++++++++++---------------
 1 file changed, 59 insertions(+), 34 deletions(-)

--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -16,6 +16,7 @@
 #include <linux/netdevice.h>
 #include <linux/pci.h>
 #include <linux/timer.h>
+#include <net/netdev_queues.h>
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Kvaser AB <support@kvaser.com>");
@@ -410,10 +411,13 @@ struct kvaser_pciefd_can {
 	void __iomem *reg_base;
 	struct can_berr_counter bec;
 	u8 cmd_seq;
+	u8 tx_max_count;
+	u8 tx_idx;
+	u8 ack_idx;
 	int err_rep_cnt;
-	int echo_idx;
+	unsigned int completed_tx_pkts;
+	unsigned int completed_tx_bytes;
 	spinlock_t lock; /* Locks sensitive registers (e.g. MODE) */
-	spinlock_t echo_lock; /* Locks the message echo buffer */
 	struct timer_list bec_poll_timer;
 	struct completion start_comp, flush_comp;
 };
@@ -714,6 +718,9 @@ static int kvaser_pciefd_open(struct net
 	int ret;
 	struct kvaser_pciefd_can *can = netdev_priv(netdev);
 
+	can->tx_idx = 0;
+	can->ack_idx = 0;
+
 	ret = open_candev(netdev);
 	if (ret)
 		return ret;
@@ -745,21 +752,26 @@ static int kvaser_pciefd_stop(struct net
 		del_timer(&can->bec_poll_timer);
 	}
 	can->can.state = CAN_STATE_STOPPED;
+	netdev_reset_queue(netdev);
 	close_candev(netdev);
 
 	return ret;
 }
 
+static unsigned int kvaser_pciefd_tx_avail(const struct kvaser_pciefd_can *can)
+{
+	return can->tx_max_count - (READ_ONCE(can->tx_idx) - READ_ONCE(can->ack_idx));
+}
+
 static int kvaser_pciefd_prepare_tx_packet(struct kvaser_pciefd_tx_packet *p,
-					   struct kvaser_pciefd_can *can,
+					   struct can_priv *can, u8 seq,
 					   struct sk_buff *skb)
 {
 	struct canfd_frame *cf = (struct canfd_frame *)skb->data;
 	int packet_size;
-	int seq = can->echo_idx;
 
 	memset(p, 0, sizeof(*p));
-	if (can->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
+	if (can->ctrlmode & CAN_CTRLMODE_ONE_SHOT)
 		p->header[1] |= KVASER_PCIEFD_TPACKET_SMS;
 
 	if (cf->can_id & CAN_RTR_FLAG)
@@ -782,7 +794,7 @@ static int kvaser_pciefd_prepare_tx_pack
 	} else {
 		p->header[1] |=
 			FIELD_PREP(KVASER_PCIEFD_RPACKET_DLC_MASK,
-				   can_get_cc_dlc((struct can_frame *)cf, can->can.ctrlmode));
+				   can_get_cc_dlc((struct can_frame *)cf, can->ctrlmode));
 	}
 
 	p->header[1] |= FIELD_PREP(KVASER_PCIEFD_PACKET_SEQ_MASK, seq);
@@ -797,22 +809,24 @@ static netdev_tx_t kvaser_pciefd_start_x
 					    struct net_device *netdev)
 {
 	struct kvaser_pciefd_can *can = netdev_priv(netdev);
-	unsigned long irq_flags;
 	struct kvaser_pciefd_tx_packet packet;
+	unsigned int seq = can->tx_idx & (can->can.echo_skb_max - 1);
+	unsigned int frame_len;
 	int nr_words;
-	u8 count;
 
 	if (can_dev_dropped_skb(netdev, skb))
 		return NETDEV_TX_OK;
+	if (!netif_subqueue_maybe_stop(netdev, 0, kvaser_pciefd_tx_avail(can), 1, 1))
+		return NETDEV_TX_BUSY;
 
-	nr_words = kvaser_pciefd_prepare_tx_packet(&packet, can, skb);
+	nr_words = kvaser_pciefd_prepare_tx_packet(&packet, &can->can, seq, skb);
 
-	spin_lock_irqsave(&can->echo_lock, irq_flags);
 	/* Prepare and save echo skb in internal slot */
-	can_put_echo_skb(skb, netdev, can->echo_idx, 0);
-
-	/* Move echo index to the next slot */
-	can->echo_idx = (can->echo_idx + 1) % can->can.echo_skb_max;
+	WRITE_ONCE(can->can.echo_skb[seq], NULL);
+	frame_len = can_skb_get_frame_len(skb);
+	can_put_echo_skb(skb, netdev, seq, frame_len);
+	netdev_sent_queue(netdev, frame_len);
+	WRITE_ONCE(can->tx_idx, can->tx_idx + 1);
 
 	/* Write header to fifo */
 	iowrite32(packet.header[0],
@@ -836,14 +850,7 @@ static netdev_tx_t kvaser_pciefd_start_x
 			     KVASER_PCIEFD_KCAN_FIFO_LAST_REG);
 	}
 
-	count = FIELD_GET(KVASER_PCIEFD_KCAN_TX_NR_PACKETS_CURRENT_MASK,
-			  ioread32(can->reg_base + KVASER_PCIEFD_KCAN_TX_NR_PACKETS_REG));
-	/* No room for a new message, stop the queue until at least one
-	 * successful transmit
-	 */
-	if (count >= can->can.echo_skb_max || can->can.echo_skb[can->echo_idx])
-		netif_stop_queue(netdev);
-	spin_unlock_irqrestore(&can->echo_lock, irq_flags);
+	netif_subqueue_maybe_stop(netdev, 0, kvaser_pciefd_tx_avail(can), 1, 1);
 
 	return NETDEV_TX_OK;
 }
@@ -970,6 +977,8 @@ static int kvaser_pciefd_setup_can_ctrls
 		can->kv_pcie = pcie;
 		can->cmd_seq = 0;
 		can->err_rep_cnt = 0;
+		can->completed_tx_pkts = 0;
+		can->completed_tx_bytes = 0;
 		can->bec.txerr = 0;
 		can->bec.rxerr = 0;
 
@@ -983,11 +992,10 @@ static int kvaser_pciefd_setup_can_ctrls
 		tx_nr_packets_max =
 			FIELD_GET(KVASER_PCIEFD_KCAN_TX_NR_PACKETS_MAX_MASK,
 				  ioread32(can->reg_base + KVASER_PCIEFD_KCAN_TX_NR_PACKETS_REG));
+		can->tx_max_count = min(KVASER_PCIEFD_CAN_TX_MAX_COUNT, tx_nr_packets_max - 1);
 
 		can->can.clock.freq = pcie->freq;
-		can->can.echo_skb_max = min(KVASER_PCIEFD_CAN_TX_MAX_COUNT, tx_nr_packets_max - 1);
-		can->echo_idx = 0;
-		spin_lock_init(&can->echo_lock);
+		can->can.echo_skb_max = roundup_pow_of_two(can->tx_max_count);
 		spin_lock_init(&can->lock);
 
 		can->can.bittiming_const = &kvaser_pciefd_bittiming_const;
@@ -1512,19 +1520,21 @@ static int kvaser_pciefd_handle_ack_pack
 		netdev_dbg(can->can.dev, "Packet was flushed\n");
 	} else {
 		int echo_idx = FIELD_GET(KVASER_PCIEFD_PACKET_SEQ_MASK, p->header[0]);
-		int len;
-		u8 count;
+		unsigned int len, frame_len = 0;
 		struct sk_buff *skb;
 
+		if (echo_idx != (can->ack_idx & (can->can.echo_skb_max - 1)))
+			return 0;
 		skb = can->can.echo_skb[echo_idx];
-		if (skb)
-			kvaser_pciefd_set_skb_timestamp(pcie, skb, p->timestamp);
-		len = can_get_echo_skb(can->can.dev, echo_idx, NULL);
-		count = FIELD_GET(KVASER_PCIEFD_KCAN_TX_NR_PACKETS_CURRENT_MASK,
-				  ioread32(can->reg_base + KVASER_PCIEFD_KCAN_TX_NR_PACKETS_REG));
+		if (!skb)
+			return 0;
+		kvaser_pciefd_set_skb_timestamp(pcie, skb, p->timestamp);
+		len = can_get_echo_skb(can->can.dev, echo_idx, &frame_len);
 
-		if (count < can->can.echo_skb_max && netif_queue_stopped(can->can.dev))
-			netif_wake_queue(can->can.dev);
+		/* Pairs with barrier in kvaser_pciefd_start_xmit() */
+		smp_store_release(&can->ack_idx, can->ack_idx + 1);
+		can->completed_tx_pkts++;
+		can->completed_tx_bytes += frame_len;
 
 		if (!one_shot_fail) {
 			can->can.dev->stats.tx_bytes += len;
@@ -1640,11 +1650,26 @@ static int kvaser_pciefd_read_buffer(str
 {
 	int pos = 0;
 	int res = 0;
+	unsigned int i;
 
 	do {
 		res = kvaser_pciefd_read_packet(pcie, &pos, dma_buf);
 	} while (!res && pos > 0 && pos < KVASER_PCIEFD_DMA_SIZE);
 
+	/* Report ACKs in this buffer to BQL en masse for correct periods */
+	for (i = 0; i < pcie->nr_channels; ++i) {
+		struct kvaser_pciefd_can *can = pcie->can[i];
+
+		if (!can->completed_tx_pkts)
+			continue;
+		netif_subqueue_completed_wake(can->can.dev, 0,
+					      can->completed_tx_pkts,
+					      can->completed_tx_bytes,
+					      kvaser_pciefd_tx_avail(can), 1);
+		can->completed_tx_pkts = 0;
+		can->completed_tx_bytes = 0;
+	}
+
 	return res;
 }
 


