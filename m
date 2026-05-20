Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C943C6A5C;
	Wed, 20 May 2026 17:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297076; cv=none; b=hJ1U87NLHvNfCBTkQzF1Zy5pbPzBe9a2vT+H9EWUalsCv5iDww5B6PIFTYYWpEEnpDi1zkdQWtJIQ4v4RM5oD7ksYPdx0I+8ZZMnLtD7G9OzgTHUOo5BmjjKHIi/8xnMgCwSrRgksQkX/jBfuRfyp/X1Ao3TfUtFa/6pWROfnCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297076; c=relaxed/simple;
	bh=QiuSIJks/im+KylqlSpOG7k6W1V75uJlUQcd47aAWZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kiL95TSL7flsVOSxI/AooVJmIYoVETYnC3G3NPeXqQePwouflxOMIasXGOD9fmNdxhRccTtUqJ6j2lthQGwMr0hO/ILzEB8PBA0xWggybDny40CogkiV2JmCmquB50axH8etIg2xxyQcvOVZxRDu9PNRw7tLFwNEIzo+C+pl0Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQWbEVWb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQWbEVWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD331F000E9;
	Wed, 20 May 2026 17:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297075;
	bh=Vztf8gTI/72N3pxenzds5pQ/H3nshz49csVWVPLeGq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQWbEVWbmwXQerfqQKbVYv1pfovokyweKAdtGi3Vi4tUT+fP7lSwz++glgc3/IrdH
	 An3oiBpmogoWJ4Rwtp7ZwYxQJsuZvAdC6dBzjSXAvbO+P08pMWLPfGniKGqJYMCHlN
	 YFEft6qCcSHU4+RTh/gFsBhdAZRk4V7k78b8rGk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1039/1146] net/sched: sch_pie: annotate more data-races in pie_dump_stats()
Date: Wed, 20 May 2026 18:21:29 +0200
Message-ID: <20260520162211.744641532@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 6d4106e8df94c0c52cf3ca6a6a0d01567fb3844e ]

My prior patch missed few READ_ONCE()/WRITE_ONCE() annotations.

Fixes: 5154561d9b11 ("net/sched: sch_pie: annotate data-races in pie_dump_stats()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260430080056.35104-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_pie.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index 73650200482f4..40149edecbd5a 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -219,16 +219,14 @@ void pie_process_dequeue(struct sk_buff *skb, struct pie_params *params,
 	 * packet timestamp.
 	 */
 	if (!params->dq_rate_estimator) {
-		vars->qdelay = now - pie_get_enqueue_time(skb);
+		WRITE_ONCE(vars->qdelay,
+			   backlog ? now - pie_get_enqueue_time(skb) : 0);
 
 		if (vars->dq_tstamp != DTIME_INVALID)
 			dtime = now - vars->dq_tstamp;
 
 		vars->dq_tstamp = now;
 
-		if (backlog == 0)
-			vars->qdelay = 0;
-
 		if (dtime == 0)
 			return;
 
@@ -376,7 +374,7 @@ void pie_calculate_probability(struct pie_params *params, struct pie_vars *vars,
 	if (qdelay > (PSCHED_NS2TICKS(250 * NSEC_PER_MSEC)))
 		delta += MAX_PROB / (100 / 2);
 
-	vars->prob += delta;
+	WRITE_ONCE(vars->prob, vars->prob + delta);
 
 	if (delta > 0) {
 		/* prevent overflow */
@@ -401,7 +399,7 @@ void pie_calculate_probability(struct pie_params *params, struct pie_vars *vars,
 
 	if (qdelay == 0 && qdelay_old == 0 && update_prob)
 		/* Reduce drop probability to 98.4% */
-		vars->prob -= vars->prob / 64;
+		WRITE_ONCE(vars->prob, vars->prob - vars->prob / 64);
 
 	WRITE_ONCE(vars->qdelay, qdelay);
 	vars->backlog_old = backlog;
@@ -501,7 +499,7 @@ static int pie_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 {
 	struct pie_sched_data *q = qdisc_priv(sch);
 	struct tc_pie_xstats st = {
-		.prob		= q->vars.prob << BITS_PER_BYTE,
+		.prob		= READ_ONCE(q->vars.prob) << BITS_PER_BYTE,
 		.delay		= ((u32)PSCHED_TICKS2NS(READ_ONCE(q->vars.qdelay))) /
 				   NSEC_PER_USEC,
 		.packets_in	= READ_ONCE(q->stats.packets_in),
@@ -512,7 +510,7 @@ static int pie_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 	};
 
 	/* avg_dq_rate is only valid if dq_rate_estimator is enabled */
-	st.dq_rate_estimating = q->params.dq_rate_estimator;
+	st.dq_rate_estimating = READ_ONCE(q->params.dq_rate_estimator);
 
 	/* unscale and return dq_rate in bytes per sec */
 	if (st.dq_rate_estimating)
-- 
2.53.0



