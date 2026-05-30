Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EBF29B799;
	Sat, 30 May 2026 18:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164745; cv=none; b=kqIQnjhtQy1vzEc712RLvUwrs5qpeGcxt13At9KSYHUaZdC0+hihlv6hucOAXNcvL+vSh6vYvV/c8KZOPvDXNhrRPbuv8Nw0MxrGWzNZGmtYKSWIBdDfifOoiO3Skfcvd+hpmwRaqYhiQ3cAqVsZa94CVZqAMeHpwr6en6B3EGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164745; c=relaxed/simple;
	bh=1uS2AgbUH5bOL673vJaA9hzJ7/OE2Y+gkWZfubgMS0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQR4h4FaadeJgXMG9T7WPDDomWL5U2mbBgb5I+jtKX+N5mzy3lmw+NzDAEtMrzP0JhMCrpZMud4UoLgbAvX56utxBwox+5cL49mO8McTshFn9AR10zhoTA6JVF/J+s4Ph0riG+DZjX7LWzczma7QLuV5aDt7bZxANRqxrgHcL1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=niSA7/mk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="niSA7/mk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A871F00893;
	Sat, 30 May 2026 18:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164744;
	bh=WLfPazNIsDGd3+wVO+RIsj5XXL9v6zUpvGudAcqtCq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=niSA7/mkvuIFAsWtHNq6vSp6zCCwbutRrVGhWoxsATrDV9Si4nM9YGQuc8V097sSx
	 bHT4u9v+px9IoWVPKqqgvrWOewd4laUT1tTDa7C0hU5U3WbsZ3kmryMa2HTehzRP5B
	 XZJwbDjdX2mrr6mYl5XGFh/EwtqG/ekCC7orehZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 646/776] net/sched: sch_pie: annotate more data-races in pie_dump_stats()
Date: Sat, 30 May 2026 18:06:00 +0200
Message-ID: <20260530160256.630849176@linuxfoundation.org>
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
index 1e4c84535c0e3..ad0d8c892f120 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -215,16 +215,14 @@ void pie_process_dequeue(struct sk_buff *skb, struct pie_params *params,
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
 
@@ -372,7 +370,7 @@ void pie_calculate_probability(struct pie_params *params, struct pie_vars *vars,
 	if (qdelay > (PSCHED_NS2TICKS(250 * NSEC_PER_MSEC)))
 		delta += MAX_PROB / (100 / 2);
 
-	vars->prob += delta;
+	WRITE_ONCE(vars->prob, vars->prob + delta);
 
 	if (delta > 0) {
 		/* prevent overflow */
@@ -397,7 +395,7 @@ void pie_calculate_probability(struct pie_params *params, struct pie_vars *vars,
 
 	if (qdelay == 0 && qdelay_old == 0 && update_prob)
 		/* Reduce drop probability to 98.4% */
-		vars->prob -= vars->prob / 64;
+		WRITE_ONCE(vars->prob, vars->prob - vars->prob / 64);
 
 	WRITE_ONCE(vars->qdelay, qdelay);
 	vars->backlog_old = backlog;
@@ -493,7 +491,7 @@ static int pie_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 {
 	struct pie_sched_data *q = qdisc_priv(sch);
 	struct tc_pie_xstats st = {
-		.prob		= q->vars.prob << BITS_PER_BYTE,
+		.prob		= READ_ONCE(q->vars.prob) << BITS_PER_BYTE,
 		.delay		= ((u32)PSCHED_TICKS2NS(READ_ONCE(q->vars.qdelay))) /
 				   NSEC_PER_USEC,
 		.packets_in	= READ_ONCE(q->stats.packets_in),
@@ -504,7 +502,7 @@ static int pie_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 	};
 
 	/* avg_dq_rate is only valid if dq_rate_estimator is enabled */
-	st.dq_rate_estimating = q->params.dq_rate_estimator;
+	st.dq_rate_estimating = READ_ONCE(q->params.dq_rate_estimator);
 
 	/* unscale and return dq_rate in bytes per sec */
 	if (st.dq_rate_estimating)
-- 
2.53.0



