Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B163C1963;
	Sat, 30 May 2026 18:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164676; cv=none; b=qbcMISI9HJ00+E0RM2sdDZ7Dzyyq7My+tiOqS/m+4/awRH3G1SB0ta03c2wkdiio13t2POb+14U0uqH6mbL8bSX56DL2znemjA4+s6e7oyUcL3nByecU9lNqADZiwHvluwCRnTkcKhobUmelPP7pYidyb19j3ulCrt6EfytK2eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164676; c=relaxed/simple;
	bh=j4dMF6ohLdgr4kyH02q7Zdtty+OxSnD1D93rlhZvC00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J91AJB8Ay0ZV6wvs3taWYxUOPpl5aNtTCdQs+xUFy6W7sqYyOPOYDUHMsO5FTl3xFx6KyWHz0zk8m1+TySFWFicdgFqp7xhqarJvP5o1FMHQNhOCnR5uMdF17U2VyOZarw8zVKV0+O64km5jEnwaIhEwm1dxzAl7lLr2YDc2esc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1AIc7Gko; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1AIc7Gko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BCF1F00893;
	Sat, 30 May 2026 18:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164674;
	bh=Yvq2laxsqL5kARdo29F7U71dUj/If5HwNntyQQspYII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1AIc7GkouJwi7o1qiUwRwFDe4u4qp6SCX5pjlpDcLn08GqMn+ulXNAyIg1Ka+EhUr
	 SdcfC+liPTf7ei6vQMez01YA3auYMd5h7yzchG1qXbGbhtbQK5MfgQChCGARghtKBU
	 rpILlx3Tj2Hto6911gdplZ0UjoaKmg5nQaBUBXm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 586/776] net/sched: sch_pie: annotate data-races in pie_dump_stats()
Date: Sat, 30 May 2026 18:05:00 +0200
Message-ID: <20260530160255.217576468@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5154561d9b119f781249f8e845fecf059b38b483 ]

pie_dump_stats() only runs with RTNL held,
reading fields that can be changed in qdisc fast path.

Add READ_ONCE()/WRITE_ONCE() annotations.

Alternative would be to acquire the qdisc spinlock, but our long-term
goal is to make qdisc dump operations lockless as much as we can.

tc_pie_xstats fields don't need to be latched atomically,
otherwise this bug would have been caught earlier.

Fixes: edb09eb17ed8 ("net: sched: do not acquire qdisc spinlock in qdisc/class stats dump")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260421142944.4009941-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/pie.h   |  2 +-
 net/sched/sch_pie.c | 38 +++++++++++++++++++-------------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/net/pie.h b/include/net/pie.h
index 3fe2361e03b46..f6fd51e2b7daa 100644
--- a/include/net/pie.h
+++ b/include/net/pie.h
@@ -104,7 +104,7 @@ static inline void pie_vars_init(struct pie_vars *vars)
 	vars->dq_tstamp = DTIME_INVALID;
 	vars->accu_prob = 0;
 	vars->dq_count = DQCOUNT_INVALID;
-	vars->avg_dq_rate = 0;
+	WRITE_ONCE(vars->avg_dq_rate, 0);
 }
 
 static inline struct pie_skb_cb *get_pie_cb(const struct sk_buff *skb)
diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index 67ce65af52b5c..1e4c84535c0e3 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -89,7 +89,7 @@ static int pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	bool enqueue = false;
 
 	if (unlikely(qdisc_qlen(sch) >= sch->limit)) {
-		q->stats.overlimit++;
+		WRITE_ONCE(q->stats.overlimit, q->stats.overlimit + 1);
 		goto out;
 	}
 
@@ -101,7 +101,7 @@ static int pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		/* If packet is ecn capable, mark it if drop probability
 		 * is lower than 10%, else drop it.
 		 */
-		q->stats.ecn_mark++;
+		WRITE_ONCE(q->stats.ecn_mark, q->stats.ecn_mark + 1);
 		enqueue = true;
 	}
 
@@ -111,15 +111,15 @@ static int pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		if (!q->params.dq_rate_estimator)
 			pie_set_enqueue_time(skb);
 
-		q->stats.packets_in++;
+		WRITE_ONCE(q->stats.packets_in, q->stats.packets_in + 1);
 		if (qdisc_qlen(sch) > q->stats.maxq)
-			q->stats.maxq = qdisc_qlen(sch);
+			WRITE_ONCE(q->stats.maxq, qdisc_qlen(sch));
 
 		return qdisc_enqueue_tail(skb, sch);
 	}
 
 out:
-	q->stats.dropped++;
+	WRITE_ONCE(q->stats.dropped, q->stats.dropped + 1);
 	q->vars.accu_prob = 0;
 	return qdisc_drop(skb, sch, to_free);
 }
@@ -263,11 +263,11 @@ void pie_process_dequeue(struct sk_buff *skb, struct pie_params *params,
 			count = count / dtime;
 
 			if (vars->avg_dq_rate == 0)
-				vars->avg_dq_rate = count;
+				WRITE_ONCE(vars->avg_dq_rate, count);
 			else
-				vars->avg_dq_rate =
+				WRITE_ONCE(vars->avg_dq_rate,
 				    (vars->avg_dq_rate -
-				     (vars->avg_dq_rate >> 3)) + (count >> 3);
+				     (vars->avg_dq_rate >> 3)) + (count >> 3));
 
 			/* If the queue has receded below the threshold, we hold
 			 * on to the last drain rate calculated, else we reset
@@ -377,7 +377,7 @@ void pie_calculate_probability(struct pie_params *params, struct pie_vars *vars,
 	if (delta > 0) {
 		/* prevent overflow */
 		if (vars->prob < oldprob) {
-			vars->prob = MAX_PROB;
+			WRITE_ONCE(vars->prob, MAX_PROB);
 			/* Prevent normalization error. If probability is at
 			 * maximum value already, we normalize it here, and
 			 * skip the check to do a non-linear drop in the next
@@ -388,7 +388,7 @@ void pie_calculate_probability(struct pie_params *params, struct pie_vars *vars,
 	} else {
 		/* prevent underflow */
 		if (vars->prob > oldprob)
-			vars->prob = 0;
+			WRITE_ONCE(vars->prob, 0);
 	}
 
 	/* Non-linear drop in probability: Reduce drop probability quickly if
@@ -399,7 +399,7 @@ void pie_calculate_probability(struct pie_params *params, struct pie_vars *vars,
 		/* Reduce drop probability to 98.4% */
 		vars->prob -= vars->prob / 64;
 
-	vars->qdelay = qdelay;
+	WRITE_ONCE(vars->qdelay, qdelay);
 	vars->backlog_old = backlog;
 
 	/* We restart the measurement cycle if the following conditions are met
@@ -494,21 +494,21 @@ static int pie_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 	struct pie_sched_data *q = qdisc_priv(sch);
 	struct tc_pie_xstats st = {
 		.prob		= q->vars.prob << BITS_PER_BYTE,
-		.delay		= ((u32)PSCHED_TICKS2NS(q->vars.qdelay)) /
+		.delay		= ((u32)PSCHED_TICKS2NS(READ_ONCE(q->vars.qdelay))) /
 				   NSEC_PER_USEC,
-		.packets_in	= q->stats.packets_in,
-		.overlimit	= q->stats.overlimit,
-		.maxq		= q->stats.maxq,
-		.dropped	= q->stats.dropped,
-		.ecn_mark	= q->stats.ecn_mark,
+		.packets_in	= READ_ONCE(q->stats.packets_in),
+		.overlimit	= READ_ONCE(q->stats.overlimit),
+		.maxq		= READ_ONCE(q->stats.maxq),
+		.dropped	= READ_ONCE(q->stats.dropped),
+		.ecn_mark	= READ_ONCE(q->stats.ecn_mark),
 	};
 
 	/* avg_dq_rate is only valid if dq_rate_estimator is enabled */
 	st.dq_rate_estimating = q->params.dq_rate_estimator;
 
 	/* unscale and return dq_rate in bytes per sec */
-	if (q->params.dq_rate_estimator)
-		st.avg_dq_rate = q->vars.avg_dq_rate *
+	if (st.dq_rate_estimating)
+		st.avg_dq_rate = READ_ONCE(q->vars.avg_dq_rate) *
 				 (PSCHED_TICKS_PER_SEC) >> PIE_SCALE;
 
 	return gnet_stats_copy_app(d, &st, sizeof(st));
-- 
2.53.0



