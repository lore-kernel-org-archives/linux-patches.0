Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCA63F1AB9;
	Wed, 20 May 2026 17:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296945; cv=none; b=qmsTwygUjHuqyRlUvjolIv1kPkLs2mn0hHTKzVAlbb9sWdA+6T/1Z/kPPPB/4veP1EO4MhccP1uS6EXl7SKbqRedraPjp4zQ0REZlcSVdIAq+OiTpgqVLj0WDyqrlS47i/BlZ5QLdFTmkYM6APPFc5gfvhw/fPeA0QgBYSP4XUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296945; c=relaxed/simple;
	bh=srTXkIcB76AHnl9BdoN35MZgSOYe1UCOGwIKhbyHrng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VMR0Uyw8oW/7IPmzu+sg7ihC/ieYbP7hP+B3XKYyqRR3HRkv1D9Gqze3LQGWXXDmp0rDnfyFDdjeqIM+ZsUaG63Jt46Aq8ouK/NKDmtFF4py6c2IZYmrTHtnDyF2dtsK/LCI45XbcU0rt2WUUgwoKb8JOMEJK8hJBNCFLXQ8w6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBMgmQox; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBMgmQox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304551F000E9;
	Wed, 20 May 2026 17:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296943;
	bh=zU9PzC43CSf+XGJGZctXc+HLrsVMNl0ZY7fy6GrpwI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBMgmQox55Nuq+5ZX6oQZwPf0SLZuov2pJjEWUocb+mNi1g+3nLRjLd4u8TzgyJGr
	 S+fJbtskT1uw75qNlyuzt6yTSq5Ebssa3+rpoFh+iLnJSj6ncJ5cUAHnum79RcbVBk
	 R9TzFPWYmsUwsn42X9koY0N2JnoQzCEatBWKIHbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0990/1146] net/sched: sch_cake: annotate data-races in cake_dump_stats() (II)
Date: Wed, 20 May 2026 18:20:40 +0200
Message-ID: <20260520162210.637699443@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 91a96427b93b9ba27413077b7e825d2fefbfa134 ]

cake_dump_stats() runs without qdisc spinlock being held.

In this second patch, I add READ_ONCE()/WRITE_ONCE() annotations
for the following fields:

- bulk_flow_count
- unresponsive_flow_count
- max_skblen
- flow_quantum

Other annotations are added in following patches, to ease code review.

Fixes: 046f6fd5daef ("sched: Add Common Applications Kept Enhanced (cake) qdisc")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: "Toke Høiland-Jørgensen" <toke@toke.dk>
Link: https://patch.msgid.link/20260427083606.459355-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cake.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index ac82fe7aafcb3..a164464f63d18 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1590,7 +1590,8 @@ static unsigned int cake_drop(struct Qdisc *sch, struct sk_buff **to_free)
 	}
 
 	if (cobalt_queue_full(&flow->cvars, &b->cparams, now))
-		b->unresponsive_flow_count++;
+		WRITE_ONCE(b->unresponsive_flow_count,
+			   b->unresponsive_flow_count + 1);
 
 	len = qdisc_pkt_len(skb);
 	q->buffer_used      -= skb->truesize;
@@ -1795,7 +1796,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 
 	if (unlikely(len > b->max_skblen))
-		b->max_skblen = len;
+		WRITE_ONCE(b->max_skblen, len);
 
 	if (qdisc_pkt_segs(skb) > 1 && q->config->rate_flags & CAKE_FLAG_SPLIT_GSO) {
 		struct sk_buff *segs, *nskb;
@@ -1930,7 +1931,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		 */
 		flow->set = CAKE_SET_BULK;
 		WRITE_ONCE(b->sparse_flow_count, b->sparse_flow_count - 1);
-		b->bulk_flow_count++;
+		WRITE_ONCE(b->bulk_flow_count, b->bulk_flow_count + 1);
 
 		cake_inc_srchost_bulk_flow_count(b, flow, q->config->flow_mode);
 		cake_inc_dsthost_bulk_flow_count(b, flow, q->config->flow_mode);
@@ -2150,7 +2151,7 @@ static struct sk_buff *cake_dequeue(struct Qdisc *sch)
 		if (flow->set == CAKE_SET_SPARSE) {
 			if (flow->head) {
 				WRITE_ONCE(b->sparse_flow_count, b->sparse_flow_count - 1);
-				b->bulk_flow_count++;
+				WRITE_ONCE(b->bulk_flow_count, b->bulk_flow_count + 1);
 
 				cake_inc_srchost_bulk_flow_count(b, flow, q->config->flow_mode);
 				cake_inc_dsthost_bulk_flow_count(b, flow, q->config->flow_mode);
@@ -2177,7 +2178,8 @@ static struct sk_buff *cake_dequeue(struct Qdisc *sch)
 		if (!skb) {
 			/* this queue was actually empty */
 			if (cobalt_queue_empty(&flow->cvars, &b->cparams, now))
-				b->unresponsive_flow_count--;
+				WRITE_ONCE(b->unresponsive_flow_count,
+					   b->unresponsive_flow_count - 1);
 
 			if (flow->cvars.p_drop || flow->cvars.count ||
 			    ktime_before(now, flow->cvars.drop_next)) {
@@ -2187,7 +2189,7 @@ static struct sk_buff *cake_dequeue(struct Qdisc *sch)
 				list_move_tail(&flow->flowchain,
 					       &b->decaying_flows);
 				if (flow->set == CAKE_SET_BULK) {
-					b->bulk_flow_count--;
+					WRITE_ONCE(b->bulk_flow_count, b->bulk_flow_count - 1);
 
 					cake_dec_srchost_bulk_flow_count(b, flow, q->config->flow_mode);
 					cake_dec_dsthost_bulk_flow_count(b, flow, q->config->flow_mode);
@@ -2206,7 +2208,7 @@ static struct sk_buff *cake_dequeue(struct Qdisc *sch)
 				    flow->set == CAKE_SET_SPARSE_WAIT) {
 					WRITE_ONCE(b->sparse_flow_count, b->sparse_flow_count - 1);
 				} else if (flow->set == CAKE_SET_BULK) {
-					b->bulk_flow_count--;
+					WRITE_ONCE(b->bulk_flow_count, b->bulk_flow_count - 1);
 
 					cake_dec_srchost_bulk_flow_count(b, flow, q->config->flow_mode);
 					cake_dec_dsthost_bulk_flow_count(b, flow, q->config->flow_mode);
@@ -2329,9 +2331,9 @@ static void cake_set_rate(struct cake_tin_data *b, u64 rate, u32 mtu,
 	u8  rate_shft = 0;
 	u64 rate_ns = 0;
 
-	b->flow_quantum = 1514;
 	if (rate) {
-		b->flow_quantum = max(min(rate >> 12, 1514ULL), 300ULL);
+		WRITE_ONCE(b->flow_quantum,
+			   max(min(rate >> 12, 1514ULL), 300ULL));
 		rate_shft = 34;
 		rate_ns = ((u64)NSEC_PER_SEC) << rate_shft;
 		rate_ns = div64_u64(rate_ns, max(MIN_RATE, rate));
@@ -2339,8 +2341,10 @@ static void cake_set_rate(struct cake_tin_data *b, u64 rate, u32 mtu,
 			rate_ns >>= 1;
 			rate_shft--;
 		}
-	} /* else unlimited, ie. zero delay */
-
+	} else {
+		/* else unlimited, ie. zero delay */
+		WRITE_ONCE(b->flow_quantum, 1514);
+	}
 	b->tin_rate_bps  = rate;
 	b->tin_rate_ns   = rate_ns;
 	b->tin_rate_shft = rate_shft;
@@ -3056,11 +3060,11 @@ static int cake_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 
 		PUT_TSTAT_U32(SPARSE_FLOWS, READ_ONCE(b->sparse_flow_count) +
 					    READ_ONCE(b->decaying_flow_count));
-		PUT_TSTAT_U32(BULK_FLOWS, b->bulk_flow_count);
-		PUT_TSTAT_U32(UNRESPONSIVE_FLOWS, b->unresponsive_flow_count);
-		PUT_TSTAT_U32(MAX_SKBLEN, b->max_skblen);
+		PUT_TSTAT_U32(BULK_FLOWS, READ_ONCE(b->bulk_flow_count));
+		PUT_TSTAT_U32(UNRESPONSIVE_FLOWS, READ_ONCE(b->unresponsive_flow_count));
+		PUT_TSTAT_U32(MAX_SKBLEN, READ_ONCE(b->max_skblen));
 
-		PUT_TSTAT_U32(FLOW_QUANTUM, b->flow_quantum);
+		PUT_TSTAT_U32(FLOW_QUANTUM, READ_ONCE(b->flow_quantum));
 		nla_nest_end(d->skb, ts);
 	}
 
-- 
2.53.0



