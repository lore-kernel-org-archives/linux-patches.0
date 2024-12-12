Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102C915696E;
	Thu, 12 Dec 2024 17:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024867; cv=none; b=sFR+T0APgJSHWEVQEJms9TZ9L3JGw/gLE4CMMSUHKMwsvEkngChGf8XtkKuorHJEzhLzt3wQ3/GHeRoH5v3ro/25p2NkcXOj+YTlaUsmxBss4dYg1rzCok1AxKPk54H0V/Cg4WsQsH+T+2WJ/X+oauY4hXl9XzNB+pcakOU6yTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024867; c=relaxed/simple;
	bh=Xuiz2+rhRNH8rjyjZlm9HNgdwdIvaVEKNkwcOKdGzto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCsi2pFtn3hEyY+ux4NGJbVLPEG6QZOYjUS+4lH89k8KQxKY0pe4uY7KULZn/OAysQdJ4H8j8AYx2DsO76uU5HF6j2z/pHXIuNrRqBAAnTLLIvI9prnTf07LqW1HwBYVluHuEgsGz9ySYRTksMUG6azF5gYjfzxoFBB4mHofLlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gk4ucTm9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gk4ucTm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8780EC4CECE;
	Thu, 12 Dec 2024 17:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024866;
	bh=Xuiz2+rhRNH8rjyjZlm9HNgdwdIvaVEKNkwcOKdGzto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gk4ucTm9K+vK2WFOEtd7tQa+ld4Iy+A2FlwaM0IvH4w6/jDWdZBL0PSa6mA6Lvnj8
	 tNGcr0TvjHTHOrNdT46fACmIJjqTtVz5QI042ltMoyfpnlV3bpXJ9tvY1pDcNXYKWY
	 +1HwABfs7OpEcuZUZV/o4mfrAYhEvu4X7fq4RF+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Valentin Schneider <valentin.schneider@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 438/459] sched/fair: Add NOHZ balancer flag for nohz.next_balance updates
Date: Thu, 12 Dec 2024 16:02:56 +0100
Message-ID: <20241212144311.056682412@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valentin Schneider <valentin.schneider@arm.com>

[ Upstream commit efd984c481abb516fab8bafb25bf41fd9397a43c ]

A following patch will trigger NOHZ idle balances as a means to update
nohz.next_balance. Vincent noted that blocked load updates can have
non-negligible overhead, which should be avoided if the intent is to only
update nohz.next_balance.

Add a new NOHZ balance kick flag, NOHZ_NEXT_KICK. Gate NOHZ blocked load
update by the presence of NOHZ_STATS_KICK - currently all NOHZ balance
kicks will have the NOHZ_STATS_KICK flag set, so no change in behaviour is
expected.

Suggested-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lkml.kernel.org/r/20210823111700.2842997-2-valentin.schneider@arm.com
Stable-dep-of: ff47a0acfcce ("sched/fair: Check idle_cpu() before need_resched() to detect ilb CPU turning busy")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c  | 24 ++++++++++++++----------
 kernel/sched/sched.h |  8 +++++++-
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8121cfd60b8fb..e2116e3d593ec 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10438,7 +10438,7 @@ static void nohz_balancer_kick(struct rq *rq)
 		goto out;
 
 	if (rq->nr_running >= 2) {
-		flags = NOHZ_KICK_MASK;
+		flags = NOHZ_STATS_KICK | NOHZ_BALANCE_KICK;
 		goto out;
 	}
 
@@ -10452,7 +10452,7 @@ static void nohz_balancer_kick(struct rq *rq)
 		 * on.
 		 */
 		if (rq->cfs.h_nr_running >= 1 && check_cpu_capacity(rq, sd)) {
-			flags = NOHZ_KICK_MASK;
+			flags = NOHZ_STATS_KICK | NOHZ_BALANCE_KICK;
 			goto unlock;
 		}
 	}
@@ -10466,7 +10466,7 @@ static void nohz_balancer_kick(struct rq *rq)
 		 */
 		for_each_cpu_and(i, sched_domain_span(sd), nohz.idle_cpus_mask) {
 			if (sched_asym_prefer(i, cpu)) {
-				flags = NOHZ_KICK_MASK;
+				flags = NOHZ_STATS_KICK | NOHZ_BALANCE_KICK;
 				goto unlock;
 			}
 		}
@@ -10479,7 +10479,7 @@ static void nohz_balancer_kick(struct rq *rq)
 		 * to run the misfit task on.
 		 */
 		if (check_misfit_status(rq, sd)) {
-			flags = NOHZ_KICK_MASK;
+			flags = NOHZ_STATS_KICK | NOHZ_BALANCE_KICK;
 			goto unlock;
 		}
 
@@ -10506,7 +10506,7 @@ static void nohz_balancer_kick(struct rq *rq)
 		 */
 		nr_busy = atomic_read(&sds->nr_busy_cpus);
 		if (nr_busy > 1) {
-			flags = NOHZ_KICK_MASK;
+			flags = NOHZ_STATS_KICK | NOHZ_BALANCE_KICK;
 			goto unlock;
 		}
 	}
@@ -10653,7 +10653,8 @@ static bool _nohz_idle_balance(struct rq *this_rq, unsigned int flags,
 	 * setting the flag, we are sure to not clear the state and not
 	 * check the load of an idle cpu.
 	 */
-	WRITE_ONCE(nohz.has_blocked, 0);
+	if (flags & NOHZ_STATS_KICK)
+		WRITE_ONCE(nohz.has_blocked, 0);
 
 	/*
 	 * Ensures that if we miss the CPU, we must see the has_blocked
@@ -10675,13 +10676,15 @@ static bool _nohz_idle_balance(struct rq *this_rq, unsigned int flags,
 		 * balancing owner will pick it up.
 		 */
 		if (need_resched()) {
-			has_blocked_load = true;
+			if (flags & NOHZ_STATS_KICK)
+				has_blocked_load = true;
 			goto abort;
 		}
 
 		rq = cpu_rq(balance_cpu);
 
-		has_blocked_load |= update_nohz_stats(rq);
+		if (flags & NOHZ_STATS_KICK)
+			has_blocked_load |= update_nohz_stats(rq);
 
 		/*
 		 * If time for next balance is due,
@@ -10712,8 +10715,9 @@ static bool _nohz_idle_balance(struct rq *this_rq, unsigned int flags,
 	if (likely(update_next_balance))
 		nohz.next_balance = next_balance;
 
-	WRITE_ONCE(nohz.next_blocked,
-		now + msecs_to_jiffies(LOAD_AVG_PERIOD));
+	if (flags & NOHZ_STATS_KICK)
+		WRITE_ONCE(nohz.next_blocked,
+			   now + msecs_to_jiffies(LOAD_AVG_PERIOD));
 
 	/* The full idle balance loop has been done */
 	ret = true;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 66e3ecb7c10e4..5f17507bd66b8 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2293,12 +2293,18 @@ extern void cfs_bandwidth_usage_dec(void);
 #define NOHZ_BALANCE_KICK_BIT	0
 #define NOHZ_STATS_KICK_BIT	1
 #define NOHZ_NEWILB_KICK_BIT	2
+#define NOHZ_NEXT_KICK_BIT	3
 
+/* Run rebalance_domains() */
 #define NOHZ_BALANCE_KICK	BIT(NOHZ_BALANCE_KICK_BIT)
+/* Update blocked load */
 #define NOHZ_STATS_KICK		BIT(NOHZ_STATS_KICK_BIT)
+/* Update blocked load when entering idle */
 #define NOHZ_NEWILB_KICK	BIT(NOHZ_NEWILB_KICK_BIT)
+/* Update nohz.next_balance */
+#define NOHZ_NEXT_KICK		BIT(NOHZ_NEXT_KICK_BIT)
 
-#define NOHZ_KICK_MASK	(NOHZ_BALANCE_KICK | NOHZ_STATS_KICK)
+#define NOHZ_KICK_MASK	(NOHZ_BALANCE_KICK | NOHZ_STATS_KICK | NOHZ_NEXT_KICK)
 
 #define nohz_flags(cpu)	(&cpu_rq(cpu)->nohz_flags)
 
-- 
2.43.0



