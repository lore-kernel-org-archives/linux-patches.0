Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FBB13BC0C;
	Mon, 23 Dec 2024 16:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970324; cv=none; b=SAq/cTLSBaACkPTgOtH1TWyXE5kySGvvOtZpH2ggTMKYVwwk9f7ew1wSib37IxAsXgR12UJJMC2VSfr92/xEkvk7ek1Fk+yhyqlViGuDT4T1/G5LktEkiHchGneADOvy8OR/6bQ+xcur28hNddIchfZ5yhjDTIDekBFyxkpmzvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970324; c=relaxed/simple;
	bh=Q4w4RLxUAkGdhFaybT7GMPl2rSP48Ln1GYP4hJzjzag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7EcfY4nBkP7zUZxP7imNpaVS66ZQc1/1eJYmCq0Csu0+2+Sj1um0QBvmJmWxdnIspvZpNk67KlJa0bz/ZIfSvXAgrz2D5SrtFJ5CQtjnCS/htTD1u/e0j7DpJkRVMGqmGVImN0zZPHMvDMXi3twmV+vXSVPjQbdNOA/SSZB974=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDz/Jihr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDz/Jihr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE51AC4CED3;
	Mon, 23 Dec 2024 16:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970324;
	bh=Q4w4RLxUAkGdhFaybT7GMPl2rSP48Ln1GYP4hJzjzag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qDz/Jihr9gEMcYJe4+tlcJGx/sRX83taToecMAmK7zhcbnrD6OcQH3IQ91++iKsbR
	 p917N3MN4zfJwr0DAazpgSlmZfHBcNFNL8Os8Jhh0bPWU4FAAR9hgNqeS+Tb8gVRjw
	 Fiiqy6kB/Qx8SHpzIpY4T40qSjbFuid9eJLziY+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/116] net: renesas: rswitch: rework ts tags management
Date: Mon, 23 Dec 2024 16:58:39 +0100
Message-ID: <20241223155401.463474181@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Yushchenko <nikita.yoush@cogentembedded.com>

[ Upstream commit 922b4b955a03d19fea98938f33ef0e62d01f5159 ]

The existing linked list based implementation of how ts tags are
assigned and managed is unsafe against concurrency and corner cases:
- element addition in tx processing can race against element removal
  in ts queue completion,
- element removal in ts queue completion can race against element
  removal in device close,
- if a large number of frames gets added to tx queue without ts queue
  completions in between, elements with duplicate tag values can get
  added.

Use a different implementation, based on per-port used tags bitmaps and
saved skb arrays.

Safety for addition in tx processing vs removal in ts completion is
provided by:

    tag = find_first_zero_bit(...);
    smp_mb();
    <write rdev->ts_skb[tag]>
    set_bit(...);

  vs

    <read rdev->ts_skb[tag]>
    smp_mb();
    clear_bit(...);

Safety for removal in ts completion vs removal in device close is
provided by using atomic read-and-clear for rdev->ts_skb[tag]:

    ts_skb = xchg(&rdev->ts_skb[tag], NULL);
    if (ts_skb)
        <handle it>

Fixes: 33f5d733b589 ("net: renesas: rswitch: Improve TX timestamp accuracy")
Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Link: https://patch.msgid.link/20241212062558.436455-1-nikita.yoush@cogentembedded.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/rswitch.c | 74 ++++++++++++++------------
 drivers/net/ethernet/renesas/rswitch.h | 13 ++---
 2 files changed, 42 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 8abad9bb629e..54aa56c84133 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -546,7 +546,6 @@ static int rswitch_gwca_ts_queue_alloc(struct rswitch_private *priv)
 	desc = &gq->ts_ring[gq->ring_size];
 	desc->desc.die_dt = DT_LINKFIX;
 	rswitch_desc_set_dptr(&desc->desc, gq->ring_dma);
-	INIT_LIST_HEAD(&priv->gwca.ts_info_list);
 
 	return 0;
 }
@@ -934,9 +933,10 @@ static int rswitch_gwca_request_irqs(struct rswitch_private *priv)
 static void rswitch_ts(struct rswitch_private *priv)
 {
 	struct rswitch_gwca_queue *gq = &priv->gwca.ts_queue;
-	struct rswitch_gwca_ts_info *ts_info, *ts_info2;
 	struct skb_shared_hwtstamps shhwtstamps;
 	struct rswitch_ts_desc *desc;
+	struct rswitch_device *rdev;
+	struct sk_buff *ts_skb;
 	struct timespec64 ts;
 	unsigned int num;
 	u32 tag, port;
@@ -946,23 +946,28 @@ static void rswitch_ts(struct rswitch_private *priv)
 		dma_rmb();
 
 		port = TS_DESC_DPN(__le32_to_cpu(desc->desc.dptrl));
-		tag = TS_DESC_TSUN(__le32_to_cpu(desc->desc.dptrl));
-
-		list_for_each_entry_safe(ts_info, ts_info2, &priv->gwca.ts_info_list, list) {
-			if (!(ts_info->port == port && ts_info->tag == tag))
-				continue;
-
-			memset(&shhwtstamps, 0, sizeof(shhwtstamps));
-			ts.tv_sec = __le32_to_cpu(desc->ts_sec);
-			ts.tv_nsec = __le32_to_cpu(desc->ts_nsec & cpu_to_le32(0x3fffffff));
-			shhwtstamps.hwtstamp = timespec64_to_ktime(ts);
-			skb_tstamp_tx(ts_info->skb, &shhwtstamps);
-			dev_consume_skb_irq(ts_info->skb);
-			list_del(&ts_info->list);
-			kfree(ts_info);
-			break;
-		}
+		if (unlikely(port >= RSWITCH_NUM_PORTS))
+			goto next;
+		rdev = priv->rdev[port];
 
+		tag = TS_DESC_TSUN(__le32_to_cpu(desc->desc.dptrl));
+		if (unlikely(tag >= TS_TAGS_PER_PORT))
+			goto next;
+		ts_skb = xchg(&rdev->ts_skb[tag], NULL);
+		smp_mb(); /* order rdev->ts_skb[] read before bitmap update */
+		clear_bit(tag, rdev->ts_skb_used);
+
+		if (unlikely(!ts_skb))
+			goto next;
+
+		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+		ts.tv_sec = __le32_to_cpu(desc->ts_sec);
+		ts.tv_nsec = __le32_to_cpu(desc->ts_nsec & cpu_to_le32(0x3fffffff));
+		shhwtstamps.hwtstamp = timespec64_to_ktime(ts);
+		skb_tstamp_tx(ts_skb, &shhwtstamps);
+		dev_consume_skb_irq(ts_skb);
+
+next:
 		gq->cur = rswitch_next_queue_index(gq, true, 1);
 		desc = &gq->ts_ring[gq->cur];
 	}
@@ -1505,8 +1510,9 @@ static int rswitch_open(struct net_device *ndev)
 static int rswitch_stop(struct net_device *ndev)
 {
 	struct rswitch_device *rdev = netdev_priv(ndev);
-	struct rswitch_gwca_ts_info *ts_info, *ts_info2;
+	struct sk_buff *ts_skb;
 	unsigned long flags;
+	unsigned int tag;
 
 	netif_tx_stop_all_queues(ndev);
 
@@ -1523,12 +1529,13 @@ static int rswitch_stop(struct net_device *ndev)
 	if (bitmap_empty(rdev->priv->opened_ports, RSWITCH_NUM_PORTS))
 		iowrite32(GWCA_TS_IRQ_BIT, rdev->priv->addr + GWTSDID);
 
-	list_for_each_entry_safe(ts_info, ts_info2, &rdev->priv->gwca.ts_info_list, list) {
-		if (ts_info->port != rdev->port)
-			continue;
-		dev_kfree_skb_irq(ts_info->skb);
-		list_del(&ts_info->list);
-		kfree(ts_info);
+	for (tag = find_first_bit(rdev->ts_skb_used, TS_TAGS_PER_PORT);
+	     tag < TS_TAGS_PER_PORT;
+	     tag = find_next_bit(rdev->ts_skb_used, TS_TAGS_PER_PORT, tag + 1)) {
+		ts_skb = xchg(&rdev->ts_skb[tag], NULL);
+		clear_bit(tag, rdev->ts_skb_used);
+		if (ts_skb)
+			dev_kfree_skb(ts_skb);
 	}
 
 	return 0;
@@ -1541,20 +1548,17 @@ static bool rswitch_ext_desc_set_info1(struct rswitch_device *rdev,
 	desc->info1 = cpu_to_le64(INFO1_DV(BIT(rdev->etha->index)) |
 				  INFO1_IPV(GWCA_IPV_NUM) | INFO1_FMT);
 	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
-		struct rswitch_gwca_ts_info *ts_info;
+		unsigned int tag;
 
-		ts_info = kzalloc(sizeof(*ts_info), GFP_ATOMIC);
-		if (!ts_info)
+		tag = find_first_zero_bit(rdev->ts_skb_used, TS_TAGS_PER_PORT);
+		if (tag == TS_TAGS_PER_PORT)
 			return false;
+		smp_mb(); /* order bitmap read before rdev->ts_skb[] write */
+		rdev->ts_skb[tag] = skb_get(skb);
+		set_bit(tag, rdev->ts_skb_used);
 
 		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
-		rdev->ts_tag++;
-		desc->info1 |= cpu_to_le64(INFO1_TSUN(rdev->ts_tag) | INFO1_TXC);
-
-		ts_info->skb = skb_get(skb);
-		ts_info->port = rdev->port;
-		ts_info->tag = rdev->ts_tag;
-		list_add_tail(&ts_info->list, &rdev->priv->gwca.ts_info_list);
+		desc->info1 |= cpu_to_le64(INFO1_TSUN(tag) | INFO1_TXC);
 
 		skb_tx_timestamp(skb);
 	}
diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
index f2d1cd47187d..0c93ef16b43e 100644
--- a/drivers/net/ethernet/renesas/rswitch.h
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -965,14 +965,6 @@ struct rswitch_gwca_queue {
 	};
 };
 
-struct rswitch_gwca_ts_info {
-	struct sk_buff *skb;
-	struct list_head list;
-
-	int port;
-	u8 tag;
-};
-
 #define RSWITCH_NUM_IRQ_REGS	(RSWITCH_MAX_NUM_QUEUES / BITS_PER_TYPE(u32))
 struct rswitch_gwca {
 	unsigned int index;
@@ -982,7 +974,6 @@ struct rswitch_gwca {
 	struct rswitch_gwca_queue *queues;
 	int num_queues;
 	struct rswitch_gwca_queue ts_queue;
-	struct list_head ts_info_list;
 	DECLARE_BITMAP(used, RSWITCH_MAX_NUM_QUEUES);
 	u32 tx_irq_bits[RSWITCH_NUM_IRQ_REGS];
 	u32 rx_irq_bits[RSWITCH_NUM_IRQ_REGS];
@@ -990,6 +981,7 @@ struct rswitch_gwca {
 };
 
 #define NUM_QUEUES_PER_NDEV	2
+#define TS_TAGS_PER_PORT	256
 struct rswitch_device {
 	struct rswitch_private *priv;
 	struct net_device *ndev;
@@ -997,7 +989,8 @@ struct rswitch_device {
 	void __iomem *addr;
 	struct rswitch_gwca_queue *tx_queue;
 	struct rswitch_gwca_queue *rx_queue;
-	u8 ts_tag;
+	struct sk_buff *ts_skb[TS_TAGS_PER_PORT];
+	DECLARE_BITMAP(ts_skb_used, TS_TAGS_PER_PORT);
 	bool disabled;
 
 	int port;
-- 
2.39.5



