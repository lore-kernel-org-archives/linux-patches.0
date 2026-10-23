Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775053;
	b=5U49PkNS2/kDS5AtcI3j5GH/P8sFSBMAMxlPHYyM2Oud8Y+4JK+XK4St0ldbA99Yhagu
	 56F4py44Gkx1AUhC13DNaICu/6mk3EgEFsPJC/3Fi9i6t0ktRxqF0FU8fnfaDGezFFUu4
	 LE78av9kfdfMC2qeXKKAoxnEHAqiGxtKBGTMpux3XJ0PjIHOUEuHJTTVHCXpvDHEN/bZH
	 8ioIFWmrPXGPAG6YcsgkZkfkCOy7kcdmsWWYWPs1GM/OlFFQRae8rYqVWkw1x9hOC4npn
	 5Nsok9ofnTrOnP8vScogsRIwn/TUJD2yd93B1c5ZTGb8g986ks+84aOMd9c7q74wSkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qp+yr5BtRHRP/7J2ondWZIz2kKER/wdl/0xNd3LQZUc=;
	b=xwn3D91p3VuEZavTfnboiPAKBBUN1FRETP41D/DkFk2o0p9pLWDBI1ajHa2XwZE6VzBV
	 jWO9hH2kurEDTuEWyxdtdQlkMAVV5gI5q3eExh4ufpFfem2gRCvRbc9wWRCVls0cdmcpO
	 msX9jT05WixErrN11Qj6+Q2YyGA6wQv8P1dj6frT1C4KfXa5NgyU47fzHGPNXoe6b7D4r
	 slvTjU2ISpArrUKGtK6Jx/nYIT/aC10hvVxDRVARy7/Ui7xnEo9GpYVN8MsEE7qaZZFPy
	 gUDomVCJRXXRkfn9mQTYvxpsyxKlThmoEJsa/qQITgcSmiZYDg/sJZcYvqlZAN5mWOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CvUCTDTj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA554606A31A;
	Fri, 23 Oct 2026 17:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CvUCTDTj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD831F01825;
	Fri, 23 Oct 2026 17:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775052;
	bh=Qp+yr5BtRHRP/7J2ondWZIz2kKER/wdl/0xNd3LQZUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CvUCTDTjvemY/GzC1iIJMdgSnXdFdX1EenfEJhUAloUZqA1M7s/n1DG5Y/ZlGvMXM
	 V3wR1sgrrYiQOdQdqPZ3S/nIEX3qXVP2OQy/t/d8e62yVG4nb0GB75jbKh/Vdlitd4
	 eS9CH2P9KsLMnvaJcGG1fqe/ryq+3Fb0k87nFACs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Koichiro Den <den@valinux.co.jp>,
	Eric Dumazet <edumazet@google.com>
Subject: [PATCH 7.2 214/242] net: ntb_netdev: Fix statistics races
Date: Fri, 23 Oct 2026 18:40:56 +0200
Message-ID: <20261023163718.866536023@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

commit 545b63503c696c4ce0663b3fcd37f41169aec1eb upstream.

ntb_netdev updates shared net_device stats from per-QP RX and TX
callbacks. Once multiple queues are enabled, concurrent updates can be
lost.

Use per-CPU tstats for packet and byte counters and DEV_STATS_INC() for
less frequent drop and error counters. Callbacks can run synchronously
in the xmit path or asynchronously from a tasklet or the memcpy kthread.
Pin TX updates against migration in the kthread path. Use the IRQ-safe
u64_stats helpers because netpoll can invoke the synchronous path with
IRQs disabled.

Let the core manage tstats while keeping transport teardown after
unregister_netdev(), outside RTNL. RCU lets unregister wait for TX
completions already updating stats, while later completions only consume
the skb and skip accounting and queue wake.

Fixes: 24d9e73c7e00 ("net: ntb_netdev: Support ethtool channels for multi-queue")
Cc: stable@vger.kernel.org
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260830151617.3546585-1-den@valinux.co.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ntb_netdev.c |   47 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 13 deletions(-)

--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -127,8 +127,10 @@ static void ntb_netdev_rx_handler(struct
 {
 	struct ntb_netdev_queue *q = qp_data;
 	struct ntb_netdev *dev = q->ntdev;
+	struct pcpu_sw_netstats *tstats;
 	struct sk_buff *skb, *new_skb;
 	struct net_device *ndev;
+	unsigned long flags;
 	int rc;
 
 	ndev = dev->ndev;
@@ -139,17 +141,20 @@ static void ntb_netdev_rx_handler(struct
 	netdev_dbg(ndev, "%s: %d byte payload received\n", __func__, len);
 
 	if (len < 0) {
-		ndev->stats.rx_errors++;
-		ndev->stats.rx_length_errors++;
+		DEV_STATS_INC(ndev, rx_errors);
+		DEV_STATS_INC(ndev, rx_length_errors);
 		goto enqueue_again;
 	}
 
-	ndev->stats.rx_packets++;
-	ndev->stats.rx_bytes += len;
+	tstats = this_cpu_ptr(ndev->tstats);
+	flags = u64_stats_update_begin_irqsave(&tstats->syncp);
+	u64_stats_inc(&tstats->rx_packets);
+	u64_stats_add(&tstats->rx_bytes, len);
+	u64_stats_update_end_irqrestore(&tstats->syncp, flags);
 
 	new_skb = netdev_alloc_skb(ndev, ndev->mtu + ETH_HLEN);
 	if (!new_skb) {
-		ndev->stats.rx_dropped++;
+		DEV_STATS_INC(ndev, rx_dropped);
 		goto enqueue_again;
 	}
 
@@ -166,8 +171,8 @@ enqueue_again:
 	rc = ntb_transport_rx_enqueue(qp, skb, skb->data, ndev->mtu + ETH_HLEN);
 	if (rc) {
 		dev_kfree_skb_any(skb);
-		ndev->stats.rx_errors++;
-		ndev->stats.rx_fifo_errors++;
+		DEV_STATS_INC(ndev, rx_errors);
+		DEV_STATS_INC(ndev, rx_fifo_errors);
 	}
 }
 
@@ -210,25 +215,39 @@ static void ntb_netdev_tx_handler(struct
 {
 	struct ntb_netdev_queue *q = qp_data;
 	struct ntb_netdev *dev = q->ntdev;
+	struct pcpu_sw_netstats *tstats;
 	struct net_device *ndev;
 	struct sk_buff *skb;
+	unsigned long flags;
+	bool registered;
 
 	ndev = dev->ndev;
 	skb = data;
 	if (!skb || !ndev)
 		return;
 
+	rcu_read_lock();
+	registered = READ_ONCE(ndev->reg_state) == NETREG_REGISTERED;
+	if (!registered)
+		goto free_skb;
+
 	if (len > 0) {
-		ndev->stats.tx_packets++;
-		ndev->stats.tx_bytes += skb->len;
+		/* The memcpy kthread can migrate, so pin the per-CPU update. */
+		tstats = get_cpu_ptr(ndev->tstats);
+		flags = u64_stats_update_begin_irqsave(&tstats->syncp);
+		u64_stats_inc(&tstats->tx_packets);
+		u64_stats_add(&tstats->tx_bytes, skb->len);
+		u64_stats_update_end_irqrestore(&tstats->syncp, flags);
+		put_cpu_ptr(ndev->tstats);
 	} else {
-		ndev->stats.tx_errors++;
-		ndev->stats.tx_aborted_errors++;
+		DEV_STATS_INC(ndev, tx_errors);
+		DEV_STATS_INC(ndev, tx_aborted_errors);
 	}
 
+free_skb:
 	dev_kfree_skb_any(skb);
 
-	if (ntb_transport_tx_free_entry(qp) >= tx_start) {
+	if (registered && ntb_transport_tx_free_entry(qp) >= tx_start) {
 		/* Make sure anybody stopping the queue after this sees the new
 		 * value of ntb_transport_tx_free_entry()
 		 */
@@ -237,6 +256,7 @@ static void ntb_netdev_tx_handler(struct
 		    ntb_transport_link_query(q->qp))
 			netif_wake_subqueue(ndev, q->qid);
 	}
+	rcu_read_unlock();
 }
 
 static const struct ntb_queue_handlers ntb_netdev_handlers = {
@@ -277,7 +297,7 @@ static netdev_tx_t ntb_netdev_start_xmit
 
 drop:
 	dev_kfree_skb_any(skb);
-	ndev->stats.tx_dropped++;
+	DEV_STATS_INC(ndev, tx_dropped);
 	return NETDEV_TX_OK;
 }
 
@@ -647,6 +667,7 @@ static int ntb_netdev_probe(struct devic
 	}
 
 	ndev->features = NETIF_F_HIGHDMA;
+	ndev->pcpu_stat_type = NETDEV_PCPU_STAT_TSTATS;
 
 	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 


