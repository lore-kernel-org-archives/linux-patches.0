Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A810F29E11A;
	Sat, 30 May 2026 18:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166602; cv=none; b=WqhfZh+kDQzcSJdGUstl1fuGfT77BrGB69tq9kpTtX+cCT9W/Z6qiqVswPmxz40cfuxcwscEQeb26f28DzTwOiXUA3pFp9QsKawAm56GdKRpZOQ2SL2Ym6tVPxkQq092SpA6xI3vAdt/XQJgNNIaoOHBN2YvgkFc1xioQrc5gX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166602; c=relaxed/simple;
	bh=R5bABUT/j1sbuP9ilZyPZxRXzC4mgZSyv7R/tgqTaco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESwQcke5ZhcCXKvUYt3rsNNifH/1AaRz4oO316sj3k7NRsmMbsJ7OPNwHcTgpAX1awnK4kOjmjxzaskIYve9/2z2O/vr6sGyc1GbHPfkSXWVxPD2wXSCHmjhMORRtbaYO7gAQGfDzObpoLpWBTdFHuGktYAbJZTIgt5IYVtU9Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JimzXUVv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JimzXUVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78381F00893;
	Sat, 30 May 2026 18:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166601;
	bh=aYDu3QzJWxmQLsQQu/qjkQ+piFR0WVj5lH+l9iD7vJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JimzXUVvVY8ho0ox+5gQHOaO6o2j5STxKRi7rf1d77VTHfQ173a0AsOKnYz5aspB5
	 +U/9dKWVUIEnOZEuKUU+niNnTP+k3fH2HSU7MSoJ1FRS11/DtsDDB/m+cWXaXuMB+j
	 75UNvwELKFEIQF2P6Slgl9OPcI59bUGpD9TKr0AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Kanzenbach <kurt@linutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 415/589] taprio: Handle short intervals and large packets
Date: Sat, 30 May 2026 18:04:56 +0200
Message-ID: <20260530160235.657559624@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Kanzenbach <kurt@linutronix.de>

[ Upstream commit 497cc00224cfaff89282ec8bfdfb8b797415f72a ]

When using short intervals e.g. below one millisecond, large packets won't be
transmitted at all. The software implementations checks whether the packet can
be fit into the remaining interval. Therefore, it takes the packet length and
the transmission speed into account. That is correct.

However, for large packets it may be that the transmission time exceeds the
interval resulting in no packet transmission. The same situation works fine with
hardware offloading applied.

The problem has been observed with the following schedule and iperf3:

|tc qdisc replace dev lan1 parent root handle 100 taprio \
|   num_tc 8 \
|   map 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 7 \
|   queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
|   base-time $base \
|   sched-entry S 0x40 500000 \
|   sched-entry S 0xbf 500000 \
|   clockid CLOCK_TAI \
|   flags 0x00

[...]

|root@tsn:~# iperf3 -c 192.168.2.105
|Connecting to host 192.168.2.105, port 5201
|[  5] local 192.168.2.121 port 52610 connected to 192.168.2.105 port 5201
|[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
|[  5]   0.00-1.00   sec  45.2 KBytes   370 Kbits/sec    0   1.41 KBytes
|[  5]   1.00-2.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes

After debugging, it seems that the packet length stored in the SKB is about
7000-8000 bytes. Using a 100 Mbit/s link the transmission time is about 600us
which larger than the interval of 500us.

Therefore, segment the SKB into smaller chunks if the packet is too big. This
yields similar results than the hardware offload:

|root@tsn:~# iperf3 -c 192.168.2.105
|Connecting to host 192.168.2.105, port 5201
|- - - - - - - - - - - - - - - - - - - - - - - - -
|[ ID] Interval           Transfer     Bitrate         Retr
|[  5]   0.00-10.00  sec  48.9 MBytes  41.0 Mbits/sec    0             sender
|[  5]   0.00-10.02  sec  48.7 MBytes  40.7 Mbits/sec                  receiver

Furthermore, the segmentation can be skipped for the full offload case, as the
driver or the hardware is expected to handle this.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 105425b1969c ("net/sched: taprio: fix use-after-free in advance_sched() on schedule switch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 64 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 54 insertions(+), 10 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 16ab7b1480661..66348b1083ed5 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -415,18 +415,10 @@ static long get_packet_txtime(struct sk_buff *skb, struct Qdisc *sch)
 	return txtime;
 }
 
-static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
-			  struct sk_buff **to_free)
+static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
+			      struct Qdisc *child, struct sk_buff **to_free)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
-	struct Qdisc *child;
-	int queue;
-
-	queue = skb_get_queue_mapping(skb);
-
-	child = q->qdiscs[queue];
-	if (unlikely(!child))
-		return qdisc_drop(skb, sch, to_free);
 
 	/* sk_flags are only safe to use on full sockets. */
 	if (skb->sk && sk_fullsock(skb->sk) && sock_flag(skb->sk, SOCK_TXTIME)) {
@@ -444,6 +436,58 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return qdisc_enqueue(skb, child, to_free);
 }
 
+static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+			  struct sk_buff **to_free)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct Qdisc *child;
+	int queue;
+
+	queue = skb_get_queue_mapping(skb);
+
+	child = q->qdiscs[queue];
+	if (unlikely(!child))
+		return qdisc_drop(skb, sch, to_free);
+
+	/* Large packets might not be transmitted when the transmission duration
+	 * exceeds any configured interval. Therefore, segment the skb into
+	 * smaller chunks. Skip it for the full offload case, as the driver
+	 * and/or the hardware is expected to handle this.
+	 */
+	if (skb_is_gso(skb) && !FULL_OFFLOAD_IS_ENABLED(q->flags)) {
+		unsigned int slen = 0, numsegs = 0, len = qdisc_pkt_len(skb);
+		netdev_features_t features = netif_skb_features(skb);
+		struct sk_buff *segs, *nskb;
+		int ret;
+
+		segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+		if (IS_ERR_OR_NULL(segs))
+			return qdisc_drop(skb, sch, to_free);
+
+		skb_list_walk_safe(segs, segs, nskb) {
+			skb_mark_not_on_list(segs);
+			qdisc_skb_cb(segs)->pkt_len = segs->len;
+			slen += segs->len;
+
+			ret = taprio_enqueue_one(segs, sch, child, to_free);
+			if (ret != NET_XMIT_SUCCESS) {
+				if (net_xmit_drop_count(ret))
+					qdisc_qstats_drop(sch);
+			} else {
+				numsegs++;
+			}
+		}
+
+		if (numsegs > 1)
+			qdisc_tree_reduce_backlog(sch, 1 - numsegs, len - slen);
+		consume_skb(skb);
+
+		return numsegs > 0 ? NET_XMIT_SUCCESS : NET_XMIT_DROP;
+	}
+
+	return taprio_enqueue_one(skb, sch, child, to_free);
+}
+
 static struct sk_buff *taprio_peek_soft(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
-- 
2.53.0



