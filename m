Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26000421EF4;
	Wed, 20 May 2026 18:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302766; cv=none; b=Hfi3AyHBqs+10NjBLUvCA3R92YPITJ2SR4RLE/1tU+AiqLrw6v+YkabV1iizjSBKCNM78i5Q7w6oEz3wjeJZAdprr5AdwIjsa6rTrCzyXq0mGxs7vkKk++Y4F9wvodjInxWsxpDIFE0Roq8GvAR574vyJ3lMKpW4g3Qi6qQF8vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302766; c=relaxed/simple;
	bh=Ce8pvB1ZGgsZ0xOkSOQ0GSyidY277ZKwm5Yv5COaXoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5NjuFvzz7HHDyQtHgOYErLa8vZsX6INF0uigRyh5DwRn+GVyDFTq9Qy1CFKte1Fkoix2imyKcyFJbjk5+xvks0mpVECZX4WmC9i6s0ewBFfLQmsb+RXHKFoqcL0mup0+yAa9EDa2qxGuIRqVFPOQAtVyOO59PJJMAP7scekAUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYyepb3o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYyepb3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205FF1F000E9;
	Wed, 20 May 2026 18:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302764;
	bh=mFLiZ2Sx0O7npNzAWQT7fXfwCD+vDWSq94pV96I7Lr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JYyepb3ovnT+2gtVoF0uAeLJRUUOi+zKPmtv4iLoqXwXqwbiZw8/DHUAui5Aj6WGh
	 beYNs73ohXfepfhxubUQKWicjItcz43P8tXXjCFrbroyfPU5i3V36jc/zetS7+mplU
	 ol893UwRUnOpgaSNYO4jQ8FBpPvGyXMFq8jCpCCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 350/508] net/sched: sch_sfb: annotate data-races in sfb_dump_stats()
Date: Wed, 20 May 2026 18:22:53 +0200
Message-ID: <20260520162106.220942412@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1ada03fdef82d3d7d2edb9dcd3acc91917675e48 ]

sfb_dump_stats() only runs with RTNL held,
reading fields that can be changed in qdisc fast path.

Add READ_ONCE()/WRITE_ONCE() annotations.

Alternative would be to acquire the qdisc spinlock, but our long-term
goal is to make qdisc dump operations lockless as much as we can.

tc_sfb_xstats fields don't need to be latched atomically,
otherwise this bug would have been caught earlier.

Fixes: edb09eb17ed8 ("net: sched: do not acquire qdisc spinlock in qdisc/class stats dump")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260421141655.3953721-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_sfb.c | 54 +++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 1871a1c0224d4..ce67826fdf9b6 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -130,7 +130,7 @@ static void increment_one_qlen(u32 sfbhash, u32 slot, struct sfb_sched_data *q)
 
 		sfbhash >>= SFB_BUCKET_SHIFT;
 		if (b[hash].qlen < 0xFFFF)
-			b[hash].qlen++;
+			WRITE_ONCE(b[hash].qlen, b[hash].qlen + 1);
 		b += SFB_NUMBUCKETS; /* next level */
 	}
 }
@@ -159,7 +159,7 @@ static void decrement_one_qlen(u32 sfbhash, u32 slot,
 
 		sfbhash >>= SFB_BUCKET_SHIFT;
 		if (b[hash].qlen > 0)
-			b[hash].qlen--;
+			WRITE_ONCE(b[hash].qlen, b[hash].qlen - 1);
 		b += SFB_NUMBUCKETS; /* next level */
 	}
 }
@@ -179,12 +179,12 @@ static void decrement_qlen(const struct sk_buff *skb, struct sfb_sched_data *q)
 
 static void decrement_prob(struct sfb_bucket *b, struct sfb_sched_data *q)
 {
-	b->p_mark = prob_minus(b->p_mark, q->decrement);
+	WRITE_ONCE(b->p_mark, prob_minus(b->p_mark, q->decrement));
 }
 
 static void increment_prob(struct sfb_bucket *b, struct sfb_sched_data *q)
 {
-	b->p_mark = prob_plus(b->p_mark, q->increment);
+	WRITE_ONCE(b->p_mark, prob_plus(b->p_mark, q->increment));
 }
 
 static void sfb_zero_all_buckets(struct sfb_sched_data *q)
@@ -202,11 +202,14 @@ static u32 sfb_compute_qlen(u32 *prob_r, u32 *avgpm_r, const struct sfb_sched_da
 	const struct sfb_bucket *b = &q->bins[q->slot].bins[0][0];
 
 	for (i = 0; i < SFB_LEVELS * SFB_NUMBUCKETS; i++) {
-		if (qlen < b->qlen)
-			qlen = b->qlen;
-		totalpm += b->p_mark;
-		if (prob < b->p_mark)
-			prob = b->p_mark;
+		u32 b_qlen = READ_ONCE(b->qlen);
+		u32 b_mark = READ_ONCE(b->p_mark);
+
+		if (qlen < b_qlen)
+			qlen = b_qlen;
+		totalpm += b_mark;
+		if (prob < b_mark)
+			prob = b_mark;
 		b++;
 	}
 	*prob_r = prob;
@@ -294,7 +297,8 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	if (unlikely(sch->q.qlen >= q->limit)) {
 		qdisc_qstats_overlimit(sch);
-		q->stats.queuedrop++;
+		WRITE_ONCE(q->stats.queuedrop,
+			   q->stats.queuedrop + 1);
 		goto drop;
 	}
 
@@ -347,7 +351,8 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	if (unlikely(minqlen >= q->max)) {
 		qdisc_qstats_overlimit(sch);
-		q->stats.bucketdrop++;
+		WRITE_ONCE(q->stats.bucketdrop,
+			   q->stats.bucketdrop + 1);
 		goto drop;
 	}
 
@@ -373,7 +378,8 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		}
 		if (sfb_rate_limit(skb, q)) {
 			qdisc_qstats_overlimit(sch);
-			q->stats.penaltydrop++;
+			WRITE_ONCE(q->stats.penaltydrop,
+				   q->stats.penaltydrop + 1);
 			goto drop;
 		}
 		goto enqueue;
@@ -388,14 +394,17 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			 * In either case, we want to start dropping packets.
 			 */
 			if (r < (p_min - SFB_MAX_PROB / 2) * 2) {
-				q->stats.earlydrop++;
+				WRITE_ONCE(q->stats.earlydrop,
+					   q->stats.earlydrop + 1);
 				goto drop;
 			}
 		}
 		if (INET_ECN_set_ce(skb)) {
-			q->stats.marked++;
+			WRITE_ONCE(q->stats.marked,
+				   q->stats.marked + 1);
 		} else {
-			q->stats.earlydrop++;
+			WRITE_ONCE(q->stats.earlydrop,
+				   q->stats.earlydrop + 1);
 			goto drop;
 		}
 	}
@@ -408,7 +417,8 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		sch->q.qlen++;
 		increment_qlen(&cb, q);
 	} else if (net_xmit_drop_count(ret)) {
-		q->stats.childdrop++;
+		WRITE_ONCE(q->stats.childdrop,
+			   q->stats.childdrop + 1);
 		qdisc_qstats_drop(sch);
 	}
 	return ret;
@@ -597,12 +607,12 @@ static int sfb_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 {
 	struct sfb_sched_data *q = qdisc_priv(sch);
 	struct tc_sfb_xstats st = {
-		.earlydrop = q->stats.earlydrop,
-		.penaltydrop = q->stats.penaltydrop,
-		.bucketdrop = q->stats.bucketdrop,
-		.queuedrop = q->stats.queuedrop,
-		.childdrop = q->stats.childdrop,
-		.marked = q->stats.marked,
+		.earlydrop = READ_ONCE(q->stats.earlydrop),
+		.penaltydrop = READ_ONCE(q->stats.penaltydrop),
+		.bucketdrop = READ_ONCE(q->stats.bucketdrop),
+		.queuedrop = READ_ONCE(q->stats.queuedrop),
+		.childdrop = READ_ONCE(q->stats.childdrop),
+		.marked = READ_ONCE(q->stats.marked),
 	};
 
 	st.maxqlen = sfb_compute_qlen(&st.maxprob, &st.avgprob, q);
-- 
2.53.0



