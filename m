Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A1B2EAE6;
	Mon, 23 Dec 2024 16:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969890; cv=none; b=ltvmpFYrqbxRPcCXBbuLv5W2XEZfinB5LEcq0pGXIl8Y1xidW0awckbmTOvKKLE0Y7frWWeyOaHDj8E9/O4bxMN5wEOlPoiyaN2YCedCGQ1eeONw6nLUer7gvay33ojLQEIenMEBdTgukIJAC4cLDi/KoCzFQT5z5tFN1n1mHcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969890; c=relaxed/simple;
	bh=ZO4UrOCfGH8X/nDoWdibvzrpr2c5eXPiHbXol5mVRPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3xS0v8XwF/e0hzg2k5Kr86/A3mZMM8oyoQcv8oUtaw+Xqj8VQFknXvDS2WuULJ0alP0Pk25MmIsd14huppNw3wcFY8mQl3aJlOrX7PZQ02jf0ENSEo9RdyytEmHqBwnyFJmF9bVAjOREY3y4HuhaE/g3aF2XHj+11EtmaB772I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHMUGRKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHMUGRKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5846C4CED3;
	Mon, 23 Dec 2024 16:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969890;
	bh=ZO4UrOCfGH8X/nDoWdibvzrpr2c5eXPiHbXol5mVRPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHMUGRKvvyAzA8o5gOdJOmpFlncib9rQ7GeWmyCJArQ92sZLg1UjXQapqRA/QzuLu
	 wyXYgOovOohXeSe8s2Roc6N+mUZWkOeJq1m7AqW9yCqWIc0kM32ihi3tUG5iDQGQSr
	 +nL+5ELWdA8+lb7ScGniHMqbt9y2+CS0BSg9XT1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/160] net: renesas: rswitch: rework ts tags management
Date: Mon, 23 Dec 2024 16:57:34 +0100
Message-ID: <20241223155410.338082776@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 09117110e3dd..f86fcecb91a8 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -547,7 +547,6 @@ static int rswitch_gwca_ts_queue_alloc(struct rswitch_private *priv)
 	desc = &gq->ts_ring[gq->ring_size];
 	desc->desc.die_dt = DT_LINKFIX;
 	rswitch_desc_set_dptr(&desc->desc, gq->ring_dma);
-	INIT_LIST_HEAD(&priv->gwca.ts_info_list);
 
 	return 0;
 }
@@ -1003,9 +1002,10 @@ static int rswitch_gwca_request_irqs(struct rswitch_private *priv)
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
@@ -1015,23 +1015,28 @@ static void rswitch_ts(struct rswitch_private *priv)
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
@@ -1576,8 +1581,9 @@ static int rswitch_open(struct net_device *ndev)
 static int rswitch_stop(struct net_device *ndev)
 {
 	struct rswitch_device *rdev = netdev_priv(ndev);
-	struct rswitch_gwca_ts_info *ts_info, *ts_info2;
+	struct sk_buff *ts_skb;
 	unsigned long flags;
+	unsigned int tag;
 
 	netif_tx_stop_all_queues(ndev);
 
@@ -1594,12 +1600,13 @@ static int rswitch_stop(struct net_device *ndev)
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
@@ -1612,20 +1619,17 @@ static bool rswitch_ext_desc_set_info1(struct rswitch_device *rdev,
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
index e020800dcc57..d8d4ed7d7f8b 100644
--- a/drivers/net/ethernet/renesas/rswitch.h
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -972,14 +972,6 @@ struct rswitch_gwca_queue {
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
@@ -989,7 +981,6 @@ struct rswitch_gwca {
 	struct rswitch_gwca_queue *queues;
 	int num_queues;
 	struct rswitch_gwca_queue ts_queue;
-	struct list_head ts_info_list;
 	DECLARE_BITMAP(used, RSWITCH_MAX_NUM_QUEUES);
 	u32 tx_irq_bits[RSWITCH_NUM_IRQ_REGS];
 	u32 rx_irq_bits[RSWITCH_NUM_IRQ_REGS];
@@ -997,6 +988,7 @@ struct rswitch_gwca {
 };
 
 #define NUM_QUEUES_PER_NDEV	2
+#define TS_TAGS_PER_PORT	256
 struct rswitch_device {
 	struct rswitch_private *priv;
 	struct net_device *ndev;
@@ -1004,7 +996,8 @@ struct rswitch_device {
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



