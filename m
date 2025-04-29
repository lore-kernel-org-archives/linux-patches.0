Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13997253B7E;
	Tue, 29 Apr 2025 18:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950270; cv=none; b=Cr/JXLSBPbTTpcFLV2VYyA9Qe80Qt4dwC+iwwJrUjv1XPcyvtnY6YIRqt5nzeUhRxkCB9fkLkzJZNbQ1hCHn7q2jbig9A9kDrDTVX+WaE8BDC9vc4PI3tM4NzUc7BLLGwK+HN9ATLQA477cZ635LU0c1QRHbRAy7mE3Q4KY4ZVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950270; c=relaxed/simple;
	bh=BEi/E6WzJE638lrwAfYKISuZ8OA7F50My/w1EkUgOeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYh7rJBPGP5L6ZaN85MgiR6HM3HPt/fJEnsvDh6woxN5zHdqiEeYlTxHOfqRQaslXuhpbgZqlX1tDuDCHUtU/qYPoqtiHR3GZB4QzOWDwFEpSflxScqR8k7rP3hO7RX4D2vdbpuBnW1BWaZQIwXY2VFyBy/L+46yf1ke9rjs0EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnJfkXL/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnJfkXL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F128C4CEE9;
	Tue, 29 Apr 2025 18:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950269;
	bh=BEi/E6WzJE638lrwAfYKISuZ8OA7F50My/w1EkUgOeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BnJfkXL/IIMWK2nYGOIwjpbmCq1HgjXWc1FQ5/Qss4/Tnco7Cz8KBh3ZKb9SNZwtk
	 2vzxvNhjsEUYJlmrn95xELRJRShTxG6312EYb18NyQK5u+wozIo1jjlurO7V+zhJKs
	 5YXik7fh6lGdLLn211ugYNYw9yoV8MMuzG7/51+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Ingo Molnar <mingo@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/204] sched/topology: Consolidate and clean up access to a CPUs max compute capacity
Date: Tue, 29 Apr 2025 18:42:10 +0200
Message-ID: <20250429161101.132702300@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 7bc263840bc3377186cb06b003ac287bb2f18ce2 ]

Remove the rq::cpu_capacity_orig field and use arch_scale_cpu_capacity()
instead.

The scheduler uses 3 methods to get access to a CPU's max compute capacity:

 - arch_scale_cpu_capacity(cpu) which is the default way to get a CPU's capacity.

 - cpu_capacity_orig field which is periodically updated with
   arch_scale_cpu_capacity().

 - capacity_orig_of(cpu) which encapsulates rq->cpu_capacity_orig.

There is no real need to save the value returned by arch_scale_cpu_capacity()
in struct rq. arch_scale_cpu_capacity() returns:

 - either a per_cpu variable.

 - or a const value for systems which have only one capacity.

Remove rq::cpu_capacity_orig and use arch_scale_cpu_capacity() everywhere.

No functional changes.

Some performance tests on Arm64:

  - small SMP device (hikey): no noticeable changes
  - HMP device (RB5):         hackbench shows minor improvement (1-2%)
  - large smp (thx2):         hackbench and tbench shows minor improvement (1%)

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lore.kernel.org/r/20231009103621.374412-2-vincent.guittot@linaro.org
Stable-dep-of: 79443a7e9da3 ("cpufreq/sched: Explicitly synchronize limits_changed flag handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/scheduler/sched-capacity.rst | 13 +++++++------
 kernel/sched/core.c                        |  2 +-
 kernel/sched/cpudeadline.c                 |  2 +-
 kernel/sched/deadline.c                    |  4 ++--
 kernel/sched/fair.c                        | 18 ++++++++----------
 kernel/sched/rt.c                          |  2 +-
 kernel/sched/sched.h                       |  6 ------
 kernel/sched/topology.c                    |  7 +++++--
 8 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/Documentation/scheduler/sched-capacity.rst b/Documentation/scheduler/sched-capacity.rst
index e2c1cf7431588..de414b33dd2ab 100644
--- a/Documentation/scheduler/sched-capacity.rst
+++ b/Documentation/scheduler/sched-capacity.rst
@@ -39,14 +39,15 @@ per Hz, leading to::
 -------------------
 
 Two different capacity values are used within the scheduler. A CPU's
-``capacity_orig`` is its maximum attainable capacity, i.e. its maximum
-attainable performance level. A CPU's ``capacity`` is its ``capacity_orig`` to
-which some loss of available performance (e.g. time spent handling IRQs) is
-subtracted.
+``original capacity`` is its maximum attainable capacity, i.e. its maximum
+attainable performance level. This original capacity is returned by
+the function arch_scale_cpu_capacity(). A CPU's ``capacity`` is its ``original
+capacity`` to which some loss of available performance (e.g. time spent
+handling IRQs) is subtracted.
 
 Note that a CPU's ``capacity`` is solely intended to be used by the CFS class,
-while ``capacity_orig`` is class-agnostic. The rest of this document will use
-the term ``capacity`` interchangeably with ``capacity_orig`` for the sake of
+while ``original capacity`` is class-agnostic. The rest of this document will use
+the term ``capacity`` interchangeably with ``original capacity`` for the sake of
 brevity.
 
 1.3 Platform examples
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8c5f75af07db0..41f035744683b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10048,7 +10048,7 @@ void __init sched_init(void)
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->rd = NULL;
-		rq->cpu_capacity = rq->cpu_capacity_orig = SCHED_CAPACITY_SCALE;
+		rq->cpu_capacity = SCHED_CAPACITY_SCALE;
 		rq->balance_callback = &balance_push_callback;
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index 57c92d751bcd7..95baa12a10293 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -131,7 +131,7 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 			if (!dl_task_fits_capacity(p, cpu)) {
 				cpumask_clear_cpu(cpu, later_mask);
 
-				cap = capacity_orig_of(cpu);
+				cap = arch_scale_cpu_capacity(cpu);
 
 				if (cap > max_cap ||
 				    (cpu == task_cpu(p) && cap == max_cap)) {
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 6c639e48e49a9..a15cf7969953a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -132,7 +132,7 @@ static inline unsigned long __dl_bw_capacity(const struct cpumask *mask)
 	int i;
 
 	for_each_cpu_and(i, mask, cpu_active_mask)
-		cap += capacity_orig_of(i);
+		cap += arch_scale_cpu_capacity(i);
 
 	return cap;
 }
@@ -144,7 +144,7 @@ static inline unsigned long __dl_bw_capacity(const struct cpumask *mask)
 static inline unsigned long dl_bw_capacity(int i)
 {
 	if (!sched_asym_cpucap_active() &&
-	    capacity_orig_of(i) == SCHED_CAPACITY_SCALE) {
+	    arch_scale_cpu_capacity(i) == SCHED_CAPACITY_SCALE) {
 		return dl_bw_cpus(i) << SCHED_CAPACITY_SHIFT;
 	} else {
 		RCU_LOCKDEP_WARN(!rcu_read_lock_sched_held(),
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2808dbdd03847..050cc41585f8b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4951,7 +4951,7 @@ static inline void util_est_update(struct cfs_rq *cfs_rq,
 	 * To avoid overestimation of actual task utilization, skip updates if
 	 * we cannot grant there is idle time in this CPU.
 	 */
-	if (task_util(p) > capacity_orig_of(cpu_of(rq_of(cfs_rq))))
+	if (task_util(p) > arch_scale_cpu_capacity(cpu_of(rq_of(cfs_rq))))
 		return;
 
 	/*
@@ -4999,14 +4999,14 @@ static inline int util_fits_cpu(unsigned long util,
 		return fits;
 
 	/*
-	 * We must use capacity_orig_of() for comparing against uclamp_min and
+	 * We must use arch_scale_cpu_capacity() for comparing against uclamp_min and
 	 * uclamp_max. We only care about capacity pressure (by using
 	 * capacity_of()) for comparing against the real util.
 	 *
 	 * If a task is boosted to 1024 for example, we don't want a tiny
 	 * pressure to skew the check whether it fits a CPU or not.
 	 *
-	 * Similarly if a task is capped to capacity_orig_of(little_cpu), it
+	 * Similarly if a task is capped to arch_scale_cpu_capacity(little_cpu), it
 	 * should fit a little cpu even if there's some pressure.
 	 *
 	 * Only exception is for thermal pressure since it has a direct impact
@@ -5018,7 +5018,7 @@ static inline int util_fits_cpu(unsigned long util,
 	 * For uclamp_max, we can tolerate a drop in performance level as the
 	 * goal is to cap the task. So it's okay if it's getting less.
 	 */
-	capacity_orig = capacity_orig_of(cpu);
+	capacity_orig = arch_scale_cpu_capacity(cpu);
 	capacity_orig_thermal = capacity_orig - arch_scale_thermal_pressure(cpu);
 
 	/*
@@ -7515,7 +7515,7 @@ select_idle_capacity(struct task_struct *p, struct sched_domain *sd, int target)
 		 * Look for the CPU with best capacity.
 		 */
 		else if (fits < 0)
-			cpu_cap = capacity_orig_of(cpu) - thermal_load_avg(cpu_rq(cpu));
+			cpu_cap = arch_scale_cpu_capacity(cpu) - thermal_load_avg(cpu_rq(cpu));
 
 		/*
 		 * First, select CPU which fits better (-1 being better than 0).
@@ -7757,7 +7757,7 @@ cpu_util(int cpu, struct task_struct *p, int dst_cpu, int boost)
 		util = max(util, util_est);
 	}
 
-	return min(util, capacity_orig_of(cpu));
+	return min(util, arch_scale_cpu_capacity(cpu));
 }
 
 unsigned long cpu_util_cfs(int cpu)
@@ -9544,8 +9544,6 @@ static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 	unsigned long capacity = scale_rt_capacity(cpu);
 	struct sched_group *sdg = sd->groups;
 
-	cpu_rq(cpu)->cpu_capacity_orig = arch_scale_cpu_capacity(cpu);
-
 	if (!capacity)
 		capacity = 1;
 
@@ -9621,7 +9619,7 @@ static inline int
 check_cpu_capacity(struct rq *rq, struct sched_domain *sd)
 {
 	return ((rq->cpu_capacity * sd->imbalance_pct) <
-				(rq->cpu_capacity_orig * 100));
+				(arch_scale_cpu_capacity(cpu_of(rq)) * 100));
 }
 
 /*
@@ -9632,7 +9630,7 @@ check_cpu_capacity(struct rq *rq, struct sched_domain *sd)
 static inline int check_misfit_status(struct rq *rq, struct sched_domain *sd)
 {
 	return rq->misfit_task_load &&
-		(rq->cpu_capacity_orig < rq->rd->max_cpu_capacity ||
+		(arch_scale_cpu_capacity(rq->cpu) < rq->rd->max_cpu_capacity ||
 		 check_cpu_capacity(rq, sd));
 }
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index b89223a973168..91b1ee0d81fce 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -519,7 +519,7 @@ static inline bool rt_task_fits_capacity(struct task_struct *p, int cpu)
 	min_cap = uclamp_eff_value(p, UCLAMP_MIN);
 	max_cap = uclamp_eff_value(p, UCLAMP_MAX);
 
-	cpu_cap = capacity_orig_of(cpu);
+	cpu_cap = arch_scale_cpu_capacity(cpu);
 
 	return cpu_cap >= min(min_cap, max_cap);
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d48c6a292a83d..f84b2e9feeb6d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1048,7 +1048,6 @@ struct rq {
 	struct sched_domain __rcu	*sd;
 
 	unsigned long		cpu_capacity;
-	unsigned long		cpu_capacity_orig;
 
 	struct balance_callback *balance_callback;
 
@@ -2985,11 +2984,6 @@ static inline void cpufreq_update_util(struct rq *rq, unsigned int flags) {}
 #endif
 
 #ifdef CONFIG_SMP
-static inline unsigned long capacity_orig_of(int cpu)
-{
-	return cpu_rq(cpu)->cpu_capacity_orig;
-}
-
 /**
  * enum cpu_util_type - CPU utilization type
  * @FREQUENCY_UTIL:	Utilization used to select frequency
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 2ed884bb36213..c61698cff0f3a 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2486,12 +2486,15 @@ build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *att
 	/* Attach the domains */
 	rcu_read_lock();
 	for_each_cpu(i, cpu_map) {
+		unsigned long capacity;
+
 		rq = cpu_rq(i);
 		sd = *per_cpu_ptr(d.sd, i);
 
+		capacity = arch_scale_cpu_capacity(i);
 		/* Use READ_ONCE()/WRITE_ONCE() to avoid load/store tearing: */
-		if (rq->cpu_capacity_orig > READ_ONCE(d.rd->max_cpu_capacity))
-			WRITE_ONCE(d.rd->max_cpu_capacity, rq->cpu_capacity_orig);
+		if (capacity > READ_ONCE(d.rd->max_cpu_capacity))
+			WRITE_ONCE(d.rd->max_cpu_capacity, capacity);
 
 		cpu_attach_domain(sd, d.rd, i);
 	}
-- 
2.39.5



