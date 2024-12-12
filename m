Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA5A223E66;
	Thu, 12 Dec 2024 17:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024855; cv=none; b=D7vVo27n4XGjxlrkIZYw28pjwUKigVN4+L807f7bujW2mgtnlsN+OW1IjiZJHOqd/Jj7TsvozIc6Rwmm2HrYxL4/9aTJWauXEkm+JH6G2+BNrlVqXEf/LffGXmmL1vACBP2Y/3I2Hqy9kWluKxjoZA38KbAqXOJtSZUQg6qyPTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024855; c=relaxed/simple;
	bh=tYz58C+7rVVLS3D6oE5ebDStkKvWuzyIgmMqEI9ek+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0iFDpSTKclaxRO8fGK3TsyIC1Ptcfy3IvlW2aJkqbSr/jR4t8ya5rexohKCFKadc/zA0QFSIdmO/iqBpPMDdCeycGjlaI2YiTTSgmwvzbiVwPqTrOW8GZucXMh0bzbJWLGGby8c/g/O8/KMPdHFfGiE4qnrgCM251DzVSOmjWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIlJz1mN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIlJz1mN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96187C4CECE;
	Thu, 12 Dec 2024 17:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024855;
	bh=tYz58C+7rVVLS3D6oE5ebDStkKvWuzyIgmMqEI9ek+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BIlJz1mN6qG1jEh4YxCaYIV6nnZCXoUie59M32D4sLuHDa665QCLwk0stv0fe87Sb
	 Ky9aYBeh3eYMrol9zGngO9gwFFbQKLpVRG9L0S+EMsJzz0qAmFETQdsDQrtvdhHUnY
	 Ui3bYdSsvHFJFiqc+oqtOgFIM1DhdmxEPnqrUs84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Valentin Schneider <valentin.schneider@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 434/459] sched/fair: Remove update of blocked load from newidle_balance
Date: Thu, 12 Dec 2024 16:02:52 +0100
Message-ID: <20241212144310.900514370@linuxfoundation.org>
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

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 0826530de3cbdc89e60a89e86def94a5f0fc81ca ]

newidle_balance runs with both preempt and irq disabled which prevent
local irq to run during this period. The duration for updating the
blocked load of CPUs varies according to the number of CPU cgroups
with non-decayed load and extends this critical period to an uncontrolled
level.

Remove the update from newidle_balance and trigger a normal ILB that
will take care of the update instead.

This reduces the IRQ latency from O(nr_cgroups * nr_nohz_cpus) to
O(nr_cgroups).

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lkml.kernel.org/r/20210224133007.28644-2-vincent.guittot@linaro.org
Stable-dep-of: ff47a0acfcce ("sched/fair: Check idle_cpu() before need_resched() to detect ilb CPU turning busy")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 33 +++++----------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a6a755aec32b5..a6e34c58cee92 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7621,8 +7621,6 @@ enum migration_type {
 #define LBF_NEED_BREAK	0x02
 #define LBF_DST_PINNED  0x04
 #define LBF_SOME_PINNED	0x08
-#define LBF_NOHZ_STATS	0x10
-#define LBF_NOHZ_AGAIN	0x20
 
 struct lb_env {
 	struct sched_domain	*sd;
@@ -8695,9 +8693,6 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	for_each_cpu_and(i, sched_group_span(group), env->cpus) {
 		struct rq *rq = cpu_rq(i);
 
-		if ((env->flags & LBF_NOHZ_STATS) && update_nohz_stats(rq, false))
-			env->flags |= LBF_NOHZ_AGAIN;
-
 		sgs->group_load += cpu_load(rq);
 		sgs->group_util += cpu_util(i);
 		sgs->group_runnable += cpu_runnable(rq);
@@ -9230,11 +9225,6 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 	struct sg_lb_stats tmp_sgs;
 	int sg_status = 0;
 
-#ifdef CONFIG_NO_HZ_COMMON
-	if (env->idle == CPU_NEWLY_IDLE && READ_ONCE(nohz.has_blocked))
-		env->flags |= LBF_NOHZ_STATS;
-#endif
-
 	do {
 		struct sg_lb_stats *sgs = &tmp_sgs;
 		int local_group;
@@ -9271,14 +9261,6 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 	/* Tag domain that child domain prefers tasks go to siblings first */
 	sds->prefer_sibling = child && child->flags & SD_PREFER_SIBLING;
 
-#ifdef CONFIG_NO_HZ_COMMON
-	if ((env->flags & LBF_NOHZ_AGAIN) &&
-	    cpumask_subset(nohz.idle_cpus_mask, sched_domain_span(env->sd))) {
-
-		WRITE_ONCE(nohz.next_blocked,
-			   jiffies + msecs_to_jiffies(LOAD_AVG_PERIOD));
-	}
-#endif
 
 	if (env->sd->flags & SD_NUMA)
 		env->fbq_type = fbq_classify_group(&sds->busiest_stat);
@@ -10803,16 +10785,11 @@ static void nohz_newidle_balance(struct rq *this_rq)
 	    time_before(jiffies, READ_ONCE(nohz.next_blocked)))
 		return;
 
-	raw_spin_unlock(&this_rq->lock);
 	/*
-	 * This CPU is going to be idle and blocked load of idle CPUs
-	 * need to be updated. Run the ilb locally as it is a good
-	 * candidate for ilb instead of waking up another idle CPU.
-	 * Kick an normal ilb if we failed to do the update.
+	 * Blocked load of idle CPUs need to be updated.
+	 * Kick an ILB to update statistics.
 	 */
-	if (!_nohz_idle_balance(this_rq, NOHZ_STATS_KICK, CPU_NEWLY_IDLE))
-		kick_ilb(NOHZ_STATS_KICK);
-	raw_spin_lock(&this_rq->lock);
+	kick_ilb(NOHZ_STATS_KICK);
 }
 
 #else /* !CONFIG_NO_HZ_COMMON */
@@ -10873,8 +10850,6 @@ static int newidle_balance(struct rq *this_rq, struct rq_flags *rf)
 			update_next_balance(sd, &next_balance);
 		rcu_read_unlock();
 
-		nohz_newidle_balance(this_rq);
-
 		goto out;
 	}
 
@@ -10940,6 +10915,8 @@ static int newidle_balance(struct rq *this_rq, struct rq_flags *rf)
 
 	if (pulled_task)
 		this_rq->idle_stamp = 0;
+	else
+		nohz_newidle_balance(this_rq);
 
 	rq_repin_lock(this_rq, rf);
 
-- 
2.43.0



