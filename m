Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3706836BCDE;
	Wed, 20 May 2026 18:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301390; cv=none; b=TyGHKZRFtpLw+Gvrno53rtLxhAizPNvFT/6LyyZktn+woIzP+Hkus08TaaMF/p9zcjQ/duD1dd77lsNTyXUbvlIADEwt67G9FP5wV6vLlvsPwrA/RuMBoNuooA7WyclOJxngvUJT4NvHtVzsIkewzOuLqJ3n1ZuFqrFApaUAIKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301390; c=relaxed/simple;
	bh=V6Ou+uM56SKm+riMw4Yspd+BcoFHXwdOuaPkg0b7lPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qD7L+KFz/cdmXKXyA9DcD/5NjHbVT86F8/+Q2gZTeaociwDxDmCWcppO417FY3/1bFog90+GUUtwhJ/coZoS6murxM+uaW+e4Rdi6ygcNFa8yY24VO1TfAoV/7lZiJpzVQiQzhpDluMHSLLT4VG9LvmpRc/iLniej7pUoKjHU8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJ1yhvsv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJ1yhvsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2371C1F000E9;
	Wed, 20 May 2026 18:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301388;
	bh=AYsF3Y2sw7ZeyESD+fd6JI/NLgqJLrDxqLs8kUM2nLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WJ1yhvsvkC+7R4M9uAel+RQeiHCBKRH22LndF/jOjlD2kvvf3v6Sd172zf/KvfiZq
	 H+qkaSUGiH/IAJPJHNiqVKvCpbuZ4/tdxEGHC9WgSgNxKFdhe4p2siRn1x8TpXeb4V
	 G6PAolCDQYXG82OUbEfvbk3Y9u5HwE37XzeIIcpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 537/666] net/sched: sch_choke: annotate data-races in choke_dump_stats()
Date: Wed, 20 May 2026 18:22:28 +0200
Message-ID: <20260520162122.910219764@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d3aeb889dcbd78e95f500d383799a23d949796e0 ]

choke_dump_stats() only runs with RTNL held.
It reads fields that can be changed in qdisc fast path.
Add READ_ONCE()/WRITE_ONCE() annotations.

Fixes: edb09eb17ed8 ("net: sched: do not acquire qdisc spinlock in qdisc/class stats dump")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260423062839.2524324-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_choke.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index 757b89292e7e6..87d92b2a74441 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -229,7 +229,7 @@ static int choke_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 		/* Draw a packet at random from queue and compare flow */
 		if (choke_match_random(q, skb, &idx)) {
-			q->stats.matched++;
+			WRITE_ONCE(q->stats.matched, q->stats.matched + 1);
 			choke_drop_by_idx(sch, idx, to_free);
 			goto congestion_drop;
 		}
@@ -241,11 +241,13 @@ static int choke_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			qdisc_qstats_overlimit(sch);
 			if (use_harddrop(q) || !use_ecn(q) ||
 			    !INET_ECN_set_ce(skb)) {
-				q->stats.forced_drop++;
+				WRITE_ONCE(q->stats.forced_drop,
+					   q->stats.forced_drop + 1);
 				goto congestion_drop;
 			}
 
-			q->stats.forced_mark++;
+			WRITE_ONCE(q->stats.forced_mark,
+				   q->stats.forced_mark + 1);
 		} else if (++q->vars.qcount) {
 			if (red_mark_probability(p, &q->vars, q->vars.qavg)) {
 				q->vars.qcount = 0;
@@ -253,11 +255,13 @@ static int choke_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 				qdisc_qstats_overlimit(sch);
 				if (!use_ecn(q) || !INET_ECN_set_ce(skb)) {
-					q->stats.prob_drop++;
+					WRITE_ONCE(q->stats.prob_drop,
+					           q->stats.prob_drop + 1);
 					goto congestion_drop;
 				}
 
-				q->stats.prob_mark++;
+				WRITE_ONCE(q->stats.prob_mark,
+					   q->stats.prob_mark + 1);
 			}
 		} else
 			q->vars.qR = red_random(p);
@@ -272,7 +276,7 @@ static int choke_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		return NET_XMIT_SUCCESS;
 	}
 
-	q->stats.pdrop++;
+	WRITE_ONCE(q->stats.pdrop, q->stats.pdrop + 1);
 	return qdisc_drop(skb, sch, to_free);
 
 congestion_drop:
@@ -461,10 +465,12 @@ static int choke_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 {
 	struct choke_sched_data *q = qdisc_priv(sch);
 	struct tc_choke_xstats st = {
-		.early	= q->stats.prob_drop + q->stats.forced_drop,
-		.marked	= q->stats.prob_mark + q->stats.forced_mark,
-		.pdrop	= q->stats.pdrop,
-		.matched = q->stats.matched,
+		.early	= READ_ONCE(q->stats.prob_drop) +
+			  READ_ONCE(q->stats.forced_drop),
+		.marked	= READ_ONCE(q->stats.prob_mark) +
+			  READ_ONCE(q->stats.forced_mark),
+		.pdrop	= READ_ONCE(q->stats.pdrop),
+		.matched = READ_ONCE(q->stats.matched),
 	};
 
 	return gnet_stats_copy_app(d, &st, sizeof(st));
-- 
2.53.0



