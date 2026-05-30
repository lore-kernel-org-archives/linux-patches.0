Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3A4263F44;
	Sat, 30 May 2026 17:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161756; cv=none; b=Qb8HWIFD6s2Lb2NLksszNjC1Ffve3yh7cu7o2FderyiTOsIU93HS/tCKK8nan23nB3JQtCRUxYW2xmf9ZjIu+Vktun5iTnzTO4kR6oiVOZTeu0Bt0fAXQKbtysEOkSiv2YOxXztbN3dMWzPYIcAM1nO+O5Zjejoh5phrfZZnnXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161756; c=relaxed/simple;
	bh=U6rzrY30oMCJjWrQo+B9SntMVQR5tX68rcYUpygU5CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/ZmqEzsl7pclqVf1NeZ5r4ByVldMigJ7yKPUy5PSZftTyvwwobpr7j0ZHjucAr0oiJ/4hHeg6/PYwbSCLnQOn96kFnDqrxB15xnyAXE9INF4mZzw3I3UPXQteuuWHuB/ykXqrOVt0ZEuia7IcnRAraBIYuoEmapYNVhaYPVljs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7RJbJo3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7RJbJo3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804A21F00893;
	Sat, 30 May 2026 17:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161755;
	bh=pDMhPSv5Fm33pWi+eYPo3s5AvK9MNhwkcPeZX7upwyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I7RJbJo3BCjqlo4XbDQVkRzA3cTibXK7AQ9Sphbf43a3AmpzOcoWQV3+E9U0+2XvN
	 nVfeZ9FwRdc3nLxhz2KftmLiY/JDWrzcLvVHUGElDjUeU7PVnKfWpLJcLgo2Ma0xuT
	 x/cGza5Ufjb/+gk+nTEPXmSGc60oVybB01ZJB1Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 717/969] net/sched: sch_sfb: annotate data-races in sfb_dump_stats()
Date: Sat, 30 May 2026 18:04:01 +0200
Message-ID: <20260530160320.336602345@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



