Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDAC29B8D0;
	Wed, 20 May 2026 17:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299701; cv=none; b=JbH2Zl+SQyA5dNrGgDKMy1nqNQ4X0xGsynbfd24xwfbQVZSnJ21Glc4fjis3ue21H3tqHaE6Ko+KXlQaiu0bmmOjVEOsdIgzuLggtLZPwO30Id0sMqnrGQn2Vg5+cjQHH+w5uIHafOdLrzUdk2+3ylWfDOYD8rc8FUGIuYmCNVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299701; c=relaxed/simple;
	bh=YDQ5BrifFKzCCMqeCv6U91V0WLDeNTUTxXwdPW2TLUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upt/63FFKjXSEtFMnzhJi+sK4ZtNK4T/jnuEB6ZgJwA472NkmvvPTjb/DwJk/cDe/j0II7xdYzAk/ksHxvw2wiZQEKAkqS3zKi3YXcZsmn38fWg31S+VBmXO8bsSLyVWyv/eEL9MEp1/6RMYXYrN6maVyFtTQXTYAsXhhcpKKrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKMQPrmU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKMQPrmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6B01F000E9;
	Wed, 20 May 2026 17:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299700;
	bh=iBZpTvXYadTSsoMNTpp8dyr4QfGyg1nepZn6vR94JKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sKMQPrmUpXZD7RE5FYYEVrUHVmOMSj9qSLWNx1YaYCX5H7Oa02cTyk0rRf0EQQ6oQ
	 Ilco0IA5yhdyYATAuWVqT++8cVWh1bRS3KSDE2HggaEa9nDHgOgWhY0tvVu7AEPPon
	 grk0D0zVtVlh3M4NOxb94LvmvcfZHPXA0Dck/L5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 871/957] net/sched: sch_pie: annotate more data-races in pie_dump_stats()
Date: Wed, 20 May 2026 18:22:34 +0200
Message-ID: <20260520162153.455913436@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



