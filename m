Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305FD4028C2;
	Wed, 20 May 2026 18:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302914; cv=none; b=XGewOStu0WJ7iSfImTyNME2fplYzrOn8gRWWsAZbpF13dCDptZ5LwiNZk6uQ7PNDo039meXRV0YGMQjHYCvEcllFIZxyHnIBRdjeeV0zTv9yDHRVIuxmMU6MrwtJNZP3bgPgwMbGhVEyc/30yjzuRkGRnlZvDfYEk5okZERQSsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302914; c=relaxed/simple;
	bh=1CR7lDl0OYTDrAbfC8BVG3wI4kBqX9BOExyvRBFumoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwMdD/BDN9TP1pXtsxIjF5JDdlwE0B1b96/Oybikwmheno09zfuVo+1Rlum20ArjUzCrLM7D70vJO03kw3X0TPC+bhK36PGAiJ8cd4PkYwpXK8G+jEpjmT/sbPep6bFWWyCJMgufXxAtRwf9dsugJYAMplNhkgVqEn+xIW5clac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJ8RYO/o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJ8RYO/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342FC1F000E9;
	Wed, 20 May 2026 18:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302911;
	bh=Nl5d+QxLamcpaBEFPQC9UfjiXZpZCL5ukWDG6uKGNbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zJ8RYO/o9jgliNW+FOTtEASmstg4+Qu5ZKoRAciXry4ma9xOx7oRtmzqdeIWEg6VF
	 rxTTuD9bGgCmnaWaWqa5FWm7mpuODyE14UrdgGTz3OEDwQ38eTguHgZHn1DE5dvxzP
	 D/Mr5PviZya9/MZz76oSX+kKqNBICm9jM6H2Vuec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 448/508] net/sched: sch_pie: annotate more data-races in pie_dump_stats()
Date: Wed, 20 May 2026 18:24:31 +0200
Message-ID: <20260520162108.304529962@linuxfoundation.org>
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
index 4c69b44fc3aa8..6ca4dd77a29c7 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -212,16 +212,14 @@ void pie_process_dequeue(struct sk_buff *skb, struct pie_params *params,
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
 
@@ -369,7 +367,7 @@ void pie_calculate_probability(struct pie_params *params, struct pie_vars *vars,
 	if (qdelay > (PSCHED_NS2TICKS(250 * NSEC_PER_MSEC)))
 		delta += MAX_PROB / (100 / 2);
 
-	vars->prob += delta;
+	WRITE_ONCE(vars->prob, vars->prob + delta);
 
 	if (delta > 0) {
 		/* prevent overflow */
@@ -394,7 +392,7 @@ void pie_calculate_probability(struct pie_params *params, struct pie_vars *vars,
 
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



