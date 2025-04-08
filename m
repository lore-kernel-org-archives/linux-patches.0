Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37A3267F6E;
	Tue,  8 Apr 2025 11:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110406; cv=none; b=qXqaPHdvuNuhWcUDiUIZJMvvID09D6dZ0bnmELFZ6w9lIjso+B3nlHGwpmM/L41A5dNgwsJaGK2HvyP8N3h1/39du7hkqEVKkvsXxpX3ZMZ59PVaN0yzRCUaR1NzLvSqjKYX4kxd8QHO3OxWYTaAPQtzmszjE+ut1WdPzNct7qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110406; c=relaxed/simple;
	bh=2ayTrDt0kRBgO2DqPR6FkH4EAApweAtWEDNpLbFq6MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQ+or7SV1Y6NrVonmp3xQmLbHWvtZZPEyNzvGYtReDqJ8kibNxtqrNx4+9l8ID6gQDAzu6szYdinxjbP9Wvog7jRb0D9c2GJGdRzHCCrNIYoECa+PYM8MHV0QBEg+6rfTXu8ZQXr/Ldw4hNfnWq7d6bXT9YXY5TX7UK5XiqXLwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ei56XRpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ei56XRpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153DEC4CEE5;
	Tue,  8 Apr 2025 11:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110404;
	bh=2ayTrDt0kRBgO2DqPR6FkH4EAApweAtWEDNpLbFq6MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ei56XRprQG5POenNRanCntUKjjtN2Gw050DkIKNGcLXkJdLRHdi0ISUqN4OsA7HnI
	 OcXStq8Zi4HiRJIdztUfKvxdng2MtDZsjCegvJ241IIGniUENVolNu0I+9thMH/7Ma
	 V6m26hQOXo50JFquee44kmFC8mb4rJ+FyXrVDdjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Waiman Long <llong@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 052/731] sched/deadline: Rebuild root domain accounting after every update
Date: Tue,  8 Apr 2025 12:39:09 +0200
Message-ID: <20250408104915.483696773@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juri Lelli <juri.lelli@redhat.com>

[ Upstream commit 2ff899e3516437354204423ef0a94994717b8e6a ]

Rebuilding of root domains accounting information (total_bw) is
currently broken on some cases, e.g. suspend/resume on aarch64. Problem
is that the way we keep track of domain changes and try to add bandwidth
back is convoluted and fragile.

Fix it by simplify things by making sure bandwidth accounting is cleared
and completely restored after root domains changes (after root domains
are again stable).

To be sure we always call dl_rebuild_rd_accounting while holding
cpuset_mutex we also add cpuset_reset_sched_domains() wrapper.

Fixes: 53916d5fd3c0 ("sched/deadline: Check bandwidth overflow earlier for hotplug")
Reported-by: Jon Hunter <jonathanh@nvidia.com>
Co-developed-by: Waiman Long <llong@redhat.com>
Signed-off-by: Waiman Long <llong@redhat.com>
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lore.kernel.org/r/Z9MRfeJKJUOyUSto@jlelli-thinkpadt14gen4.remote.csb
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cpuset.h         |  6 ++++++
 include/linux/sched/deadline.h |  1 +
 include/linux/sched/topology.h |  2 ++
 kernel/cgroup/cpuset.c         | 23 ++++++++++++++++-------
 kernel/sched/core.c            |  4 ++--
 kernel/sched/deadline.c        | 16 ++++++++++------
 kernel/sched/topology.c        |  1 +
 7 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 835e7b793f6a3..17cc90d900f96 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -128,6 +128,7 @@ extern bool current_cpuset_is_being_rebound(void);
 extern void rebuild_sched_domains(void);
 
 extern void cpuset_print_current_mems_allowed(void);
+extern void cpuset_reset_sched_domains(void);
 
 /*
  * read_mems_allowed_begin is required when making decisions involving
@@ -264,6 +265,11 @@ static inline void rebuild_sched_domains(void)
 	partition_sched_domains(1, NULL, NULL);
 }
 
+static inline void cpuset_reset_sched_domains(void)
+{
+	partition_sched_domains(1, NULL, NULL);
+}
+
 static inline void cpuset_print_current_mems_allowed(void)
 {
 }
diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
index 6ec578600b24c..f9aabbc9d22ef 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -34,6 +34,7 @@ static inline bool dl_time_before(u64 a, u64 b)
 struct root_domain;
 extern void dl_add_task_root_domain(struct task_struct *p);
 extern void dl_clear_root_domain(struct root_domain *rd);
+extern void dl_clear_root_domain_cpu(int cpu);
 
 #endif /* CONFIG_SMP */
 
diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
index 7f3dbafe18177..1622232bd08b9 100644
--- a/include/linux/sched/topology.h
+++ b/include/linux/sched/topology.h
@@ -166,6 +166,8 @@ static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
 	return to_cpumask(sd->span);
 }
 
+extern void dl_rebuild_rd_accounting(void);
+
 extern void partition_sched_domains_locked(int ndoms_new,
 					   cpumask_var_t doms_new[],
 					   struct sched_domain_attr *dattr_new);
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index f87526edb2a46..1892dc8cd2119 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -954,10 +954,12 @@ static void dl_update_tasks_root_domain(struct cpuset *cs)
 	css_task_iter_end(&it);
 }
 
-static void dl_rebuild_rd_accounting(void)
+void dl_rebuild_rd_accounting(void)
 {
 	struct cpuset *cs = NULL;
 	struct cgroup_subsys_state *pos_css;
+	int cpu;
+	u64 cookie = ++dl_cookie;
 
 	lockdep_assert_held(&cpuset_mutex);
 	lockdep_assert_cpus_held();
@@ -965,11 +967,12 @@ static void dl_rebuild_rd_accounting(void)
 
 	rcu_read_lock();
 
-	/*
-	 * Clear default root domain DL accounting, it will be computed again
-	 * if a task belongs to it.
-	 */
-	dl_clear_root_domain(&def_root_domain);
+	for_each_possible_cpu(cpu) {
+		if (dl_bw_visited(cpu, cookie))
+			continue;
+
+		dl_clear_root_domain_cpu(cpu);
+	}
 
 	cpuset_for_each_descendant_pre(cs, pos_css, &top_cpuset) {
 
@@ -996,7 +999,6 @@ partition_and_rebuild_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 {
 	sched_domains_mutex_lock();
 	partition_sched_domains_locked(ndoms_new, doms_new, dattr_new);
-	dl_rebuild_rd_accounting();
 	sched_domains_mutex_unlock();
 }
 
@@ -1083,6 +1085,13 @@ void rebuild_sched_domains(void)
 	cpus_read_unlock();
 }
 
+void cpuset_reset_sched_domains(void)
+{
+	mutex_lock(&cpuset_mutex);
+	partition_sched_domains(1, NULL, NULL);
+	mutex_unlock(&cpuset_mutex);
+}
+
 /**
  * cpuset_update_tasks_cpumask - Update the cpumasks of tasks in the cpuset.
  * @cs: the cpuset in which each task's cpus_allowed mask needs to be changed
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8adf495491179..3c7c942c7c429 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8183,7 +8183,7 @@ static void cpuset_cpu_active(void)
 		 * operation in the resume sequence, just build a single sched
 		 * domain, ignoring cpusets.
 		 */
-		partition_sched_domains(1, NULL, NULL);
+		cpuset_reset_sched_domains();
 		if (--num_cpus_frozen)
 			return;
 		/*
@@ -8202,7 +8202,7 @@ static void cpuset_cpu_inactive(unsigned int cpu)
 		cpuset_update_active_cpus();
 	} else {
 		num_cpus_frozen++;
-		partition_sched_domains(1, NULL, NULL);
+		cpuset_reset_sched_domains();
 	}
 }
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 3e05032e9e0eb..5dca336cdd7ca 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -166,7 +166,7 @@ static inline unsigned long dl_bw_capacity(int i)
 	}
 }
 
-static inline bool dl_bw_visited(int cpu, u64 cookie)
+bool dl_bw_visited(int cpu, u64 cookie)
 {
 	struct root_domain *rd = cpu_rq(cpu)->rd;
 
@@ -207,7 +207,7 @@ static inline unsigned long dl_bw_capacity(int i)
 	return SCHED_CAPACITY_SCALE;
 }
 
-static inline bool dl_bw_visited(int cpu, u64 cookie)
+bool dl_bw_visited(int cpu, u64 cookie)
 {
 	return false;
 }
@@ -2981,18 +2981,22 @@ void dl_clear_root_domain(struct root_domain *rd)
 	rd->dl_bw.total_bw = 0;
 
 	/*
-	 * dl_server bandwidth is only restored when CPUs are attached to root
-	 * domains (after domains are created or CPUs moved back to the
-	 * default root doamin).
+	 * dl_servers are not tasks. Since dl_add_task_root_domain ignores
+	 * them, we need to account for them here explicitly.
 	 */
 	for_each_cpu(i, rd->span) {
 		struct sched_dl_entity *dl_se = &cpu_rq(i)->fair_server;
 
 		if (dl_server(dl_se) && cpu_active(i))
-			rd->dl_bw.total_bw += dl_se->dl_bw;
+			__dl_add(&rd->dl_bw, dl_se->dl_bw, dl_bw_cpus(i));
 	}
 }
 
+void dl_clear_root_domain_cpu(int cpu)
+{
+	dl_clear_root_domain(cpu_rq(cpu)->rd);
+}
+
 #endif /* CONFIG_SMP */
 
 static void switched_from_dl(struct rq *rq, struct task_struct *p)
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 44093339761c9..363ad268a25b0 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2791,6 +2791,7 @@ void partition_sched_domains_locked(int ndoms_new, cpumask_var_t doms_new[],
 	ndoms_cur = ndoms_new;
 
 	update_sched_domain_debugfs();
+	dl_rebuild_rd_accounting();
 }
 
 /*
-- 
2.39.5



