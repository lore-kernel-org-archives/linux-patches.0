Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BE313E02A;
	Fri,  9 Oct 2026 14:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555303; cv=none; b=Cti08hHu22iiWYpxSqaFSu4XAlNa8a5IMnFoZv+WqrBtGMZIOq/e/uIO6zUSmhn9WUGlIVWVCPukcaG9fO2EroVgR34nAzidADF3uNkKKhaz0IA1glCKE37+DIMRy97XuFHG1EjSzHG8YXGWr9d+iywN2f7YFlPR/Kv4d3nFuKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555303; c=relaxed/simple;
	bh=D2YVV+ULn40UMM7tbFGiM9y8FocOgBelcW9dOt1N06M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBQnKT07vumR3XrPS6ErWEtd+WCaa3qvcdt+TNxONamO16oDVPzHOLJq71YRDhECcjasdGFckm2TNDMQjv92c2e0ahovI+yiBQM9+Q8R0yjdk18mepY/y7t+HfHnyydFAcbgyuVn21L18VwKY54BWxnpuRzCMKpIIgXnNr58o0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSmw+l0K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSmw+l0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C471F000FF;
	Fri,  9 Oct 2026 14:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555296;
	bh=J99butS/K/GwYT+rf/kHhKUDDrpTXovVblT214/2Gk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kSmw+l0KZZJOV6yhF/tD9P8pY5ESY4if2WYq6tcfXSdP3ylcb2JLZrUznMO199w/Q
	 ptrx324odYyjX8FJlPRR3oiFxDvF8ZRPd8gpN9YO2n0afTNuevS/OcFpzTHI8EoxSP
	 2gRyoTBabfDsZXV4dN2FynAUqUOyk00onD4dqJA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 005/428] sched/fair: Avoid creating misfits during cache-aware balancing
Date: Fri,  9 Oct 2026 16:05:42 +0200
Message-ID: <20261009140946.143303830@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Chen <tim.c.chen@linux.intel.com>

[ Upstream commit f0d243a96f2684ad771d678767d17972cf840bd7 ]

Cache-aware load balancing biases tasks toward their preferred LLC. On
asymmetric CPU capacity systems (e.g. big.LITTLE) the destination LLC may
contain CPUs that are too small to run the task. Pulling the task there
turns it into a misfit, trading a cache-locality gain for a capacity loss
that's more detrimental to performance.

Guard both cache-aware migration entry points against this:

 - can_migrate_llc_task(): forbid the LLC migration when the task fits its
   source CPU but would not fit the destination CPU.
 - alb_break_llc(): veto the active balance under the same condition so the
   runnable task is not pushed onto a CPU that cannot accommodate it.

Both checks are gated with checks for hybrid processors, so symmetric
systems are unaffected. Tasks that already do not fit their source CPU
are left to the existing LLC policy, since the move cannot make their
fitness worse (this also preserves misfit up-migration to bigger CPUs).

Additionally, if there are misfit tasks found in the load balancing
classification phase, prioritize misfit task migrations
over LLC load aggregation on asymmetric systems. A better fitting
CPU will boost performance more than better cache locality.

Reviewed-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Tested-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/edbb2503d554c63dc9b72e201fb4a17e1cb119e7.camel@linux.intel.com
Stable-dep-of: d6013e2465d9 ("sched/cache: Honor migrate_llc_task semantics in active load balance, to fix LLC mis-scheduling bug")
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 50 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index db34eb74804d4..ad560e59610f4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10651,18 +10651,41 @@ static enum llc_mig can_migrate_llc(int src_cpu, int dst_cpu,
 	return mig_llc;
 }
 
+static inline bool task_misfits_asym_cpu(struct lb_env *env, struct task_struct *p)
+{
+	/*
+	 * On asymmetric CPU capacity domains, do not let cache-aware
+	 * balancing pull the task onto a destination CPU that cannot
+	 * accommodate it. Doing so would turn the task into a misfit on
+	 * the destination, trading a cache-locality gain for a capacity
+	 * loss. If the task already does not fit its source CPU, the move
+	 * cannot make things worse, so let the LLC preference decide.
+	 */
+	if ((env->sd->flags & SD_ASYM_CPUCAPACITY) && p &&
+	    !task_fits_cpu(p, env->dst_cpu) &&
+	    task_fits_cpu(p, env->src_cpu))
+		return true;
+
+	return false;
+}
+
 /*
  * Check if task p can migrate from source LLC to
  * destination LLC in terms of cache aware load balance.
  */
-static enum llc_mig can_migrate_llc_task(int src_cpu, int dst_cpu,
+static enum llc_mig can_migrate_llc_task(struct lb_env *env,
 					 struct task_struct *p)
 {
 	struct sched_cache_group *grp;
 	struct mm_struct *mm;
 	bool to_pref;
-	int cpu;
+	int cpu, src_cpu, dst_cpu;
+
+	if (task_misfits_asym_cpu(env, p))
+		return mig_forbid;
 
+	src_cpu = env->src_cpu;
+	dst_cpu = env->dst_cpu;
 	mm = p->mm;
 	if (!mm)
 		return mig_unrestricted;
@@ -10723,6 +10746,14 @@ alb_break_llc(struct lb_env *env)
 		unsigned long util = 0;
 		struct task_struct *cur;
 
+		/*
+		 * Migrating misfit tasks from current CPU
+		 * to CPU with a better fit.
+		 * Prioritize that over LLC preference.
+		 */
+		if (env->migration_type == migrate_misfit)
+			return false;
+
 		if (env->src_rq->nr_running <= 1)
 			return true;
 
@@ -10730,7 +10761,8 @@ alb_break_llc(struct lb_env *env)
 		if (cur && cur->sched_class == &fair_sched_class)
 			util = task_util(cur);
 
-		if (can_migrate_llc(env->src_cpu, env->dst_cpu,
+		if (task_misfits_asym_cpu(env, cur) ||
+		    can_migrate_llc(env->src_cpu, env->dst_cpu,
 				    util, false) == mig_forbid)
 			return true;
 	}
@@ -10770,8 +10802,7 @@ static bool migrate_degrades_llc(struct task_struct *p, struct lb_env *env)
 	    READ_ONCE(p->preferred_llc) != llc_id(env->dst_cpu))
 		return true;
 
-	if (can_migrate_llc_task(env->src_cpu,
-				 env->dst_cpu, p) != mig_forbid)
+	if (can_migrate_llc_task(env, p) != mig_forbid)
 		return false;
 
 	return true;
@@ -11834,6 +11865,15 @@ static inline bool llc_balance(struct lb_env *env, struct sg_lb_stats *sgs,
 	if (env->sd->flags & SD_SHARE_LLC)
 		return false;
 
+	/*
+	 * On asymmetric domains, group_misfit_task_load
+	 * should be prioritized to move tasks to CPU that fit them
+	 * over aggregating tasks to their preferred LLC.
+	 */
+	if ((env->sd->flags & SD_ASYM_CPUCAPACITY) &&
+	    sgs->group_misfit_task_load)
+		return false;
+
 	/*
 	 * Skip cache aware tagging if nr_balanced_failed is sufficiently high.
 	 * Threshold of cache_nice_tries is set to 1 higher than nr_balance_failed
-- 
2.53.0



