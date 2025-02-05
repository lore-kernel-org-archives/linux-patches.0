Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC2C151988;
	Wed,  5 Feb 2025 14:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766238; cv=none; b=BMG7aSLr/oaaZdwaZeu46YcgPcznO1M6V2h6/hYVsxYc9J4K59otd5MvpqQ17WdvnzO/57eZ7fAtarAAHEMn4uRvhoF5KeyYFsc9gi6OixjhT9y9mVLCPWqtlu+yovWmEFcGdwuATGbru50YaNV7ttw8ROJIiPp3qwSNyCI0WSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766238; c=relaxed/simple;
	bh=6PlJRvQYE7lgRcZbln7D7P3jTLUmUUzPWE4b6IIXuL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPxgBaEmPiDxJDvVvUNql5NZWCjVkyR+TnhEqMxUKXryYy42VY7pi3ciUcEeRnT6Y7nn9h4FcilSbHggLdqG4Pp4GpQqXX+ba1M7Y1eMKFvaXUAFZZTDqESgQjz1XhmEAry2pFafStmIWGNhzNFINii5eXeha9tjxKK95xY4KDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ig8iiJMT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ig8iiJMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C27CC4CED1;
	Wed,  5 Feb 2025 14:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766238;
	bh=6PlJRvQYE7lgRcZbln7D7P3jTLUmUUzPWE4b6IIXuL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ig8iiJMTk5txDYD6CbcV2XBci/p4AJRbZmRMd+yWVbA9V17uXY4d1treG1tkbAqvw
	 evb26NeMvB80mE7AaR/JfEl0zVeNAfBKJC6jeJyZRVKwHxIjgQ2Fjw+tDQlAeefn0n
	 lT8NbABrqbA0E8N0r2/rMza5O0ZgrfjZkBWstASQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 255/623] sched_ext: Use the NUMA scheduling domain for NUMA optimizations
Date: Wed,  5 Feb 2025 14:39:57 +0100
Message-ID: <20250205134505.986558864@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <arighi@nvidia.com>

[ Upstream commit 4572541892ea4e1dade2e9c1313d3f8069d37f0a ]

Rely on the NUMA scheduling domain topology, instead of accessing NUMA
topology information directly.

There is basically no functional change, but in this way we ensure
consistent use of the same topology information determined by the
scheduling subsystem.

Fixes: f6ce6b949304 ("sched_ext: Do not enable LLC/NUMA optimizations when domains overlap")
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 114 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 86 insertions(+), 28 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 19813b387ef98..76030e54a3f59 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3219,6 +3219,74 @@ static s32 scx_pick_idle_cpu(const struct cpumask *cpus_allowed, u64 flags)
 		goto retry;
 }
 
+/*
+ * Return the amount of CPUs in the same LLC domain of @cpu (or zero if the LLC
+ * domain is not defined).
+ */
+static unsigned int llc_weight(s32 cpu)
+{
+	struct sched_domain *sd;
+
+	sd = rcu_dereference(per_cpu(sd_llc, cpu));
+	if (!sd)
+		return 0;
+
+	return sd->span_weight;
+}
+
+/*
+ * Return the cpumask representing the LLC domain of @cpu (or NULL if the LLC
+ * domain is not defined).
+ */
+static struct cpumask *llc_span(s32 cpu)
+{
+	struct sched_domain *sd;
+
+	sd = rcu_dereference(per_cpu(sd_llc, cpu));
+	if (!sd)
+		return 0;
+
+	return sched_domain_span(sd);
+}
+
+/*
+ * Return the amount of CPUs in the same NUMA domain of @cpu (or zero if the
+ * NUMA domain is not defined).
+ */
+static unsigned int numa_weight(s32 cpu)
+{
+	struct sched_domain *sd;
+	struct sched_group *sg;
+
+	sd = rcu_dereference(per_cpu(sd_numa, cpu));
+	if (!sd)
+		return 0;
+	sg = sd->groups;
+	if (!sg)
+		return 0;
+
+	return sg->group_weight;
+}
+
+/*
+ * Return the cpumask representing the NUMA domain of @cpu (or NULL if the NUMA
+ * domain is not defined).
+ */
+static struct cpumask *numa_span(s32 cpu)
+{
+	struct sched_domain *sd;
+	struct sched_group *sg;
+
+	sd = rcu_dereference(per_cpu(sd_numa, cpu));
+	if (!sd)
+		return NULL;
+	sg = sd->groups;
+	if (!sg)
+		return NULL;
+
+	return sched_group_span(sg);
+}
+
 /*
  * Return true if the LLC domains do not perfectly overlap with the NUMA
  * domains, false otherwise.
@@ -3250,19 +3318,10 @@ static bool llc_numa_mismatch(void)
 	 * overlapping, which is incorrect (as NUMA 1 has two distinct LLC
 	 * domains).
 	 */
-	for_each_online_cpu(cpu) {
-		const struct cpumask *numa_cpus;
-		struct sched_domain *sd;
-
-		sd = rcu_dereference(per_cpu(sd_llc, cpu));
-		if (!sd)
+	for_each_online_cpu(cpu)
+		if (llc_weight(cpu) != numa_weight(cpu))
 			return true;
 
-		numa_cpus = cpumask_of_node(cpu_to_node(cpu));
-		if (sd->span_weight != cpumask_weight(numa_cpus))
-			return true;
-	}
-
 	return false;
 }
 
@@ -3280,8 +3339,7 @@ static bool llc_numa_mismatch(void)
 static void update_selcpu_topology(void)
 {
 	bool enable_llc = false, enable_numa = false;
-	struct sched_domain *sd;
-	const struct cpumask *cpus;
+	unsigned int nr_cpus;
 	s32 cpu = cpumask_first(cpu_online_mask);
 
 	/*
@@ -3295,10 +3353,12 @@ static void update_selcpu_topology(void)
 	 * CPUs.
 	 */
 	rcu_read_lock();
-	sd = rcu_dereference(per_cpu(sd_llc, cpu));
-	if (sd) {
-		if (sd->span_weight < num_online_cpus())
+	nr_cpus = llc_weight(cpu);
+	if (nr_cpus > 0) {
+		if (nr_cpus < num_online_cpus())
 			enable_llc = true;
+		pr_debug("sched_ext: LLC=%*pb weight=%u\n",
+			 cpumask_pr_args(llc_span(cpu)), llc_weight(cpu));
 	}
 
 	/*
@@ -3310,9 +3370,13 @@ static void update_selcpu_topology(void)
 	 * enabling both NUMA and LLC optimizations is unnecessary, as checking
 	 * for an idle CPU in the same domain twice is redundant.
 	 */
-	cpus = cpumask_of_node(cpu_to_node(cpu));
-	if ((cpumask_weight(cpus) < num_online_cpus()) && llc_numa_mismatch())
-		enable_numa = true;
+	nr_cpus = numa_weight(cpu);
+	if (nr_cpus > 0) {
+		if (nr_cpus < num_online_cpus() && llc_numa_mismatch())
+			enable_numa = true;
+		pr_debug("sched_ext: NUMA=%*pb weight=%u\n",
+			 cpumask_pr_args(numa_span(cpu)), numa_weight(cpu));
+	}
 	rcu_read_unlock();
 
 	pr_debug("sched_ext: LLC idle selection %s\n",
@@ -3364,7 +3428,6 @@ static s32 scx_select_cpu_dfl(struct task_struct *p, s32 prev_cpu,
 
 	*found = false;
 
-
 	/*
 	 * This is necessary to protect llc_cpus.
 	 */
@@ -3383,15 +3446,10 @@ static s32 scx_select_cpu_dfl(struct task_struct *p, s32 prev_cpu,
 	 */
 	if (p->nr_cpus_allowed >= num_possible_cpus()) {
 		if (static_branch_maybe(CONFIG_NUMA, &scx_selcpu_topo_numa))
-			numa_cpus = cpumask_of_node(cpu_to_node(prev_cpu));
-
-		if (static_branch_maybe(CONFIG_SCHED_MC, &scx_selcpu_topo_llc)) {
-			struct sched_domain *sd;
+			numa_cpus = numa_span(prev_cpu);
 
-			sd = rcu_dereference(per_cpu(sd_llc, prev_cpu));
-			if (sd)
-				llc_cpus = sched_domain_span(sd);
-		}
+		if (static_branch_maybe(CONFIG_SCHED_MC, &scx_selcpu_topo_llc))
+			llc_cpus = llc_span(prev_cpu);
 	}
 
 	/*
-- 
2.39.5



