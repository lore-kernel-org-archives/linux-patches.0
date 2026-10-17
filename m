Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4D63AA4F1;
	Sat, 17 Oct 2026 16:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254904; cv=none; b=qb+KFzRhCtuLRuHFCpEDmj9irYWxcIHmFWxJwLxXkSLg52bd3lR0E257HOENRzW/0V/Z2zlVf+yXn3BVz4PPFYm9VlZTQLb70wNR456D6wrn9Q9cxeRoQxI4Our4uX+AJabt0NGyZ4vn/h9ZGxdSTYnx07Dhxq6tVnwO1evLa7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254904; c=relaxed/simple;
	bh=+BcTQ139Q966FJOaGy8mnHoFx/x6nQ8HpyuINuQIZ6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dUauIQHnL2ld9dVPSlCEW5e0dyJNeWmBQ0LhedgEE6mq76C0piuqaV5eKjwP3k3pDRHS2MzQNh/Yxbi1L+oLJknJQwMkz8Gv0BAp72HJik809dypAvOBTiePV1XeGWV6sejzo5hu9PofbzGC7qmp9G1bXGR7xa2etghNbY3YmVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hRKL77qo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hRKL77qo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F6B1F000C6;
	Sat, 17 Oct 2026 16:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254903;
	bh=2FP6wr2LRI+8grclvEvXXg2TpGghv1xwl4EDRApUo58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hRKL77qouOvfvjfF369wVNUuNEZzJWY+ZiZ2FWcnfSRwRPn+FCMViBf4jXQUwmvIx
	 qqX2RwJYJbPDm3bimT96/0OYlD9bKlqwFcSroDPvbWJT5nHdKSyl69bGeCKnoxEyJJ
	 vawy5oSpbAlerF0gccSOCTvL2bS1/JtCc4FpRSas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Victor Nogueira <victor@mojatatu.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 598/869] net_sched: sch_fq: add three drop_reason
Date: Sat, 17 Oct 2026 17:57:19 +0200
Message-ID: <20261017160052.376712508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5765c7f6e3173eb894889a29963a497aeb721c5e ]

Add three new drop_reason, more precise than generic QDISC_DROP:

"tc -s qd" show aggregate counters, it might be more useful
to use drop_reason infrastructure for bug hunting.

1) SKB_DROP_REASON_FQ_BAND_LIMIT
   Whenever a packet is added while its band limit is hit.
   Corresponding value in "tc -s qd" is bandX_drops XXXX

2) SKB_DROP_REASON_FQ_HORIZON_LIMIT
   Whenever a packet has a timestamp too far in the future.
   Corresponding value in "tc -s qd" is horizon_drops XXXX

3) SKB_DROP_REASON_FQ_FLOW_LIMIT
   Whenever a flow has reached its limit.
   Corresponding value in "tc -s qd" is flows_plimit XXXX

Tested:
tc qd replace dev eth1 root fq flow_limit 10 limit 100000
perf record -a -e skb:kfree_skb sleep 1; perf script

      udp_stream   12329 [004]   216.929492: skb:kfree_skb: skbaddr=0xffff888eabe17e00 rx_sk=(nil) protocol=34525 location=__dev_queue_xmit+0x9d9 reason: FQ_FLOW_LIMIT
      udp_stream   12385 [006]   216.929593: skb:kfree_skb: skbaddr=0xffff888ef8827f00 rx_sk=(nil) protocol=34525 location=__dev_queue_xmit+0x9d9 reason: FQ_FLOW_LIMIT
      udp_stream   12389 [005]   216.929871: skb:kfree_skb: skbaddr=0xffff888ecb9ba500 rx_sk=(nil) protocol=34525 location=__dev_queue_xmit+0x9d9 reason: FQ_FLOW_LIMIT
      udp_stream   12316 [009]   216.930398: skb:kfree_skb: skbaddr=0xffff888eca286b00 rx_sk=(nil) protocol=34525 location=__dev_queue_xmit+0x9d9 reason: FQ_FLOW_LIMIT
      udp_stream   12400 [008]   216.930490: skb:kfree_skb: skbaddr=0xffff888eabf93d00 rx_sk=(nil) protocol=34525 location=__dev_queue_xmit+0x9d9 reason: FQ_FLOW_LIMIT

tc qd replace dev eth1 root fq flow_limit 100 limit 10000
perf record -a -e skb:kfree_skb sleep 1; perf script

      udp_stream   18074 [001]  1058.318040: skb:kfree_skb: skbaddr=0xffffa23c881fc000 rx_sk=(nil) protocol=34525 location=__dev_queue_xmit+0x9d9 reason: FQ_BAND_LIMIT
      udp_stream   18126 [005]  1058.320651: skb:kfree_skb: skbaddr=0xffffa23c6aad4000 rx_sk=(nil) protocol=34525 location=__dev_queue_xmit+0x9d9 reason: FQ_BAND_LIMIT
      udp_stream   18118 [006]  1058.321065: skb:kfree_skb: skbaddr=0xffffa23df0d48a00 rx_sk=(nil) protocol=34525 location=__dev_queue_xmit+0x9d9 reason: FQ_BAND_LIMIT
      udp_stream   18074 [001]  1058.321126: skb:kfree_skb: skbaddr=0xffffa23c881ffa00 rx_sk=(nil) protocol=34525 location=__dev_queue_xmit+0x9d9 reason: FQ_BAND_LIMIT
      udp_stream   15815 [003]  1058.321224: skb:kfree_skb: skbaddr=0xffffa23c9835db00 rx_sk=(nil) protocol=34525 location=__dev_queue_xmit+0x9d9 reason: FQ_BAND_LIMIT

tc -s -d qd sh dev eth1
qdisc fq 8023: root refcnt 257 limit 10000p flow_limit 100p buckets 1024 orphan_mask 1023
 bands 3 priomap 1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1 weights 589824 196608 65536 quantum 18Kb
 initial_quantum 92120b low_rate_threshold 550Kbit refill_delay 40ms
 timer_slack 10us horizon 10s horizon_drop
 Sent 492439603330 bytes 336953991 pkt (dropped 61724094, overlimits 0 requeues 4463)
 backlog 14611228b 9995p requeues 4463
  flows 2965 (inactive 1151 throttled 0) band0_pkts 0 band1_pkts 9993 band2_pkts 0
  gc 6347 highprio 0 fastpath 30 throttled 5 latency 2.32us flows_plimit 7403693
 band1_drops 54320401

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20241204171950.89829-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5b483f7791b0 ("net/sched: act_ife: Only operate on Ethernet frames")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dropreason-core.h | 18 ++++++++++++++++++
 include/net/sch_generic.h     |  8 ++++++++
 net/sched/sch_fq.c            | 14 ++++++++++----
 3 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/include/net/dropreason-core.h b/include/net/dropreason-core.h
index f8f4d2b77e6ac..31e0cc1b64ff1 100644
--- a/include/net/dropreason-core.h
+++ b/include/net/dropreason-core.h
@@ -60,6 +60,9 @@
 	FN(TC_EGRESS)			\
 	FN(SECURITY_HOOK)		\
 	FN(QDISC_DROP)			\
+	FN(FQ_BAND_LIMIT)		\
+	FN(FQ_HORIZON_LIMIT)		\
+	FN(FQ_FLOW_LIMIT)		\
 	FN(CPU_BACKLOG)			\
 	FN(XDP)				\
 	FN(TC_INGRESS)			\
@@ -316,6 +319,21 @@ enum skb_drop_reason {
 	 * failed to enqueue to current qdisc)
 	 */
 	SKB_DROP_REASON_QDISC_DROP,
+	/**
+	 * @SKB_DROP_REASON_FQ_BAND_LIMIT: dropped by fq qdisc when per band
+	 * limit is reached.
+	 */
+	SKB_DROP_REASON_FQ_BAND_LIMIT,
+	/**
+	 * @SKB_DROP_REASON_FQ_HORIZON_LIMIT: dropped by fq qdisc when packet
+	 * timestamp is too far in the future.
+	 */
+	SKB_DROP_REASON_FQ_HORIZON_LIMIT,
+	/**
+	 * @SKB_DROP_REASON_FQ_FLOW_LIMIT: dropped by fq qdisc when a flow
+	 * exceeds its limits.
+	 */
+	SKB_DROP_REASON_FQ_FLOW_LIMIT,
 	/**
 	 * @SKB_DROP_REASON_CPU_BACKLOG: failed to enqueue the skb to the per CPU
 	 * backlog queue. This can be caused by backlog queue full (see
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index d174283373470..016d9cf827069 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1320,6 +1320,14 @@ static inline int qdisc_drop(struct sk_buff *skb, struct Qdisc *sch,
 	return NET_XMIT_DROP;
 }
 
+static inline int qdisc_drop_reason(struct sk_buff *skb, struct Qdisc *sch,
+				    struct sk_buff **to_free,
+				    enum skb_drop_reason reason)
+{
+	tcf_set_drop_reason(skb, reason);
+	return qdisc_drop(skb, sch, to_free);
+}
+
 static inline int qdisc_drop_all(struct sk_buff *skb, struct Qdisc *sch,
 				 struct sk_buff **to_free)
 {
diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index d06e12d16b0e5..cf70468b67607 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -535,6 +535,8 @@ static bool fq_packet_beyond_horizon(const struct sk_buff *skb,
 	return unlikely((s64)skb->tstamp > (s64)(now + q->horizon));
 }
 
+#define FQDR(reason) SKB_DROP_REASON_FQ_##reason
+
 static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		      struct sk_buff **to_free)
 {
@@ -546,7 +548,8 @@ static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	band = fq_prio2band(q->prio2band, skb->priority & TC_PRIO_MAX);
 	if (unlikely(q->band_pkt_count[band] >= sch->limit)) {
 		q->stat_band_drops[band]++;
-		return qdisc_drop(skb, sch, to_free);
+		return qdisc_drop_reason(skb, sch, to_free,
+					 FQDR(BAND_LIMIT));
 	}
 
 	now = ktime_get_ns();
@@ -556,8 +559,9 @@ static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		/* Check if packet timestamp is too far in the future. */
 		if (fq_packet_beyond_horizon(skb, q, now)) {
 			if (q->horizon_drop) {
-					q->stat_horizon_drops++;
-					return qdisc_drop(skb, sch, to_free);
+				q->stat_horizon_drops++;
+				return qdisc_drop_reason(skb, sch, to_free,
+							 FQDR(HORIZON_LIMIT));
 			}
 			q->stat_horizon_caps++;
 			skb->tstamp = now + q->horizon;
@@ -570,7 +574,8 @@ static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	if (f != &q->internal) {
 		if (unlikely(f->qlen >= q->flow_plimit)) {
 			q->stat_flows_plimit++;
-			return qdisc_drop(skb, sch, to_free);
+			return qdisc_drop_reason(skb, sch, to_free,
+						 FQDR(FLOW_LIMIT));
 		}
 
 		if (fq_flow_is_detached(f)) {
@@ -595,6 +600,7 @@ static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	return NET_XMIT_SUCCESS;
 }
+#undef FQDR
 
 static void fq_check_throttled(struct fq_sched_data *q, u64 now)
 {
-- 
2.53.0



