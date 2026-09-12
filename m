Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AA538AC8A;
	Sat, 12 Sep 2026 19:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242562; cv=none; b=MrQuEzhQ3KQtNTHiH/y4dHUBX5OhXPlr2NmXzt1vbukv9zBQ/H7I+s3LDuA2A1Mlk48f7Kllhq7MbEQGJaCfyUG2+yZ9pHr8l2CNzZ5uzltJRa2/F49IijdXsULrEY3GOdEwmDFSFO2trH2I/b9g+xQEs/Vwdkury0qYa/g1VxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242562; c=relaxed/simple;
	bh=QHQTPcFEnF5p6Frc2OB9Z8b1sH8PCcEk8EZvNk27CXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DeIekwIXCBkw6RWCfzYSJDSKxDsvHBWe4HbZG98b1cw8lA/14ADDHj1Xxf9HMDFGfneSMrPDU0Kxy/MOo1u3fd0g5bbn9Olh7Lb+lePhtxZwNpGirZ/o7nBd2oE+V9QD0kJ3V5i360HnsnabEzPkABWRXRsGct0Qvkra78oJkUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nUWtQ3WO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nUWtQ3WO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4221F000FF;
	Sat, 12 Sep 2026 19:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242561;
	bh=e/DocyDpCgP3iogE/SJJtJ0Pfmr1L0YSsXranItv2gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nUWtQ3WOfuec18jgTSgCJQvv8xKMNm7vMOak1yrQw1UII17Vtje/2dlPd0soWKzBi
	 RkHIajlzJOtJfzzWw6bScsUCzZItOho6tqbDg+KW19VSIiYTrmypartCvCla+J4yrp
	 MEZV5BWWWoeSBIhPM4KBGjJVXwTrwHcrnPqalnK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 447/798] cpufreq: schedutil: Add util to struct sg_cpu
Date: Sat, 12 Sep 2026 09:01:15 +0200
Message-ID: <20260912065527.385449598@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit ca6827de4b67367e73fdf43d2ea0a0064423edfb ]

Instead of passing util and max between functions while computing the
utilization and capacity, store the former in struct sg_cpu (along
with the latter and bw_dl).

This will allow the current utilization value to be compared with the
one obtained previously (which is requisite for some code changes to
follow this one), but also it causes the code to look slightly more
consistent and cleaner.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Stable-dep-of: db53c573d31d ("cpufreq: intel_pstate: Fix setting minimum P-state at init time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/cpufreq_schedutil.c | 42 +++++++++++++++-----------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index f622abeed65b4..8df584b2af900 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -53,6 +53,7 @@ struct sugov_cpu {
 	unsigned int		iowait_boost;
 	u64			last_update;
 
+	unsigned long		util;
 	unsigned long		bw_dl;
 	unsigned long		max;
 
@@ -310,16 +311,15 @@ unsigned long schedutil_cpu_util(int cpu, unsigned long util_cfs,
 	return min(max, util);
 }
 
-static unsigned long sugov_get_util(struct sugov_cpu *sg_cpu)
+static void sugov_get_util(struct sugov_cpu *sg_cpu)
 {
 	struct rq *rq = cpu_rq(sg_cpu->cpu);
-	unsigned long util = cpu_util_cfs(rq);
 	unsigned long max = arch_scale_cpu_capacity(sg_cpu->cpu);
 
 	sg_cpu->max = max;
 	sg_cpu->bw_dl = cpu_bw_dl(rq);
-
-	return schedutil_cpu_util(sg_cpu->cpu, util, max, FREQUENCY_UTIL, NULL);
+	sg_cpu->util = schedutil_cpu_util(sg_cpu->cpu, cpu_util_cfs(rq), max,
+					  FREQUENCY_UTIL, NULL);
 }
 
 /**
@@ -396,8 +396,6 @@ static void sugov_iowait_boost(struct sugov_cpu *sg_cpu, u64 time,
  * sugov_iowait_apply() - Apply the IO boost to a CPU.
  * @sg_cpu: the sugov data for the cpu to boost
  * @time: the update time from the caller
- * @util: the utilization to (eventually) boost
- * @max: the maximum value the utilization can be boosted to
  *
  * A CPU running a task which woken up after an IO operation can have its
  * utilization boosted to speed up the completion of those IO operations.
@@ -411,18 +409,17 @@ static void sugov_iowait_boost(struct sugov_cpu *sg_cpu, u64 time,
  * This mechanism is designed to boost high frequently IO waiting tasks, while
  * being more conservative on tasks which does sporadic IO operations.
  */
-static unsigned long sugov_iowait_apply(struct sugov_cpu *sg_cpu, u64 time,
-					unsigned long util, unsigned long max)
+static void sugov_iowait_apply(struct sugov_cpu *sg_cpu, u64 time)
 {
 	unsigned long boost;
 
 	/* No boost currently required */
 	if (!sg_cpu->iowait_boost)
-		return util;
+		return;
 
 	/* Reset boost if the CPU appears to have been idle enough */
 	if (sugov_iowait_reset(sg_cpu, time, false))
-		return util;
+		return;
 
 	if (!sg_cpu->iowait_boost_pending) {
 		/*
@@ -431,18 +428,19 @@ static unsigned long sugov_iowait_apply(struct sugov_cpu *sg_cpu, u64 time,
 		sg_cpu->iowait_boost >>= 1;
 		if (sg_cpu->iowait_boost < IOWAIT_BOOST_MIN) {
 			sg_cpu->iowait_boost = 0;
-			return util;
+			return;
 		}
 	}
 
 	sg_cpu->iowait_boost_pending = false;
 
 	/*
-	 * @util is already in capacity scale; convert iowait_boost
+	 * sg_cpu->util is already in capacity scale; convert iowait_boost
 	 * into the same scale so we can compare.
 	 */
-	boost = (sg_cpu->iowait_boost * max) >> SCHED_CAPACITY_SHIFT;
-	return max(boost, util);
+	boost = (sg_cpu->iowait_boost * sg_cpu->max) >> SCHED_CAPACITY_SHIFT;
+	if (sg_cpu->util < boost)
+		sg_cpu->util = boost;
 }
 
 #ifdef CONFIG_NO_HZ_COMMON
@@ -473,9 +471,8 @@ static void sugov_update_single(struct update_util_data *hook, u64 time,
 {
 	struct sugov_cpu *sg_cpu = container_of(hook, struct sugov_cpu, update_util);
 	struct sugov_policy *sg_policy = sg_cpu->sg_policy;
-	unsigned long util, max;
-	unsigned int next_f;
 	unsigned int cached_freq = sg_policy->cached_raw_freq;
+	unsigned int next_f;
 
 	sugov_iowait_boost(sg_cpu, time, flags);
 	sg_cpu->last_update = time;
@@ -485,10 +482,10 @@ static void sugov_update_single(struct update_util_data *hook, u64 time,
 	if (!sugov_should_update_freq(sg_policy, time))
 		return;
 
-	util = sugov_get_util(sg_cpu);
-	max = sg_cpu->max;
-	util = sugov_iowait_apply(sg_cpu, time, util, max);
-	next_f = get_next_freq(sg_policy, util, max);
+	sugov_get_util(sg_cpu);
+	sugov_iowait_apply(sg_cpu, time);
+
+	next_f = get_next_freq(sg_policy, sg_cpu->util, sg_cpu->max);
 	/*
 	 * Do not reduce the frequency if the CPU has not been idle
 	 * recently, as the reduction is likely to be premature then.
@@ -525,9 +522,10 @@ static unsigned int sugov_next_freq_shared(struct sugov_cpu *sg_cpu, u64 time)
 		struct sugov_cpu *j_sg_cpu = &per_cpu(sugov_cpu, j);
 		unsigned long j_util, j_max;
 
-		j_util = sugov_get_util(j_sg_cpu);
+		sugov_get_util(j_sg_cpu);
+		sugov_iowait_apply(j_sg_cpu, time);
+		j_util = j_sg_cpu->util;
 		j_max = j_sg_cpu->max;
-		j_util = sugov_iowait_apply(j_sg_cpu, time, j_util, j_max);
 
 		if (j_util * max > j_max * util) {
 			util = j_util;
-- 
2.53.0



