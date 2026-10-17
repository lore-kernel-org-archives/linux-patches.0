Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BE5387373;
	Sat, 17 Oct 2026 18:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260286; cv=none; b=ciqkENFNHqJ7xhpcpWESoOPA3RzyyeN1s1EKci+tT23jUPlOZjFWzzN+LdpUPMKKtsuYWvxK1BrYdOpf93lylvxfii3tPddY3X0c4zTSIhNdKx8aYDccJbnptQP/vnfH486YrfzVfl/+/e8is59XvHysbScemxBf+QNgYX3daR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260286; c=relaxed/simple;
	bh=AeGdG4+ljcKrBQXW683DuZolxMIiVSoBwldbMRfg3pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bz04w5uhIPTHprl85Onv0vmaoFySRDSfXyw9yuBjvaV2AAXIK0NmFlslLiV5ld8ITxcHzBz29Eja3wPPQv6hJ7Z7vo/MTrFYtQKRWtDDvt35FohmPNUJVkY5H8LKTqJi/fNjnG2Z7ECLs+oOo3dhOVN8berBGnpIq5MC9BBhxKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLmEYJRv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLmEYJRv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9551F000C4;
	Sat, 17 Oct 2026 18:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260284;
	bh=jVTfSh/ZhdtNzHn01V6/TkK/6NylKN2HC6sqnBqO4UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NLmEYJRv+wgGotuuYS9ziZiDrB3ofystu3rrPkh+FTCddx9hgDgwIhAo1NSU0SrpJ
	 QTVNR9n6TPsL4Bd1C85Bh/OnaYA3q0RzFBv/gHQcql9gymoG/t8liAuuXNajOe7xBC
	 wwAUOTPWDBRvLN4CaLXecxKbbfgl0s64C+560FH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1492/1674] cgroup/cpuset: move common code to cpuset-internal.h
Date: Sat, 17 Oct 2026 18:02:44 +0200
Message-ID: <20261017160509.441311205@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit 619a33efa0b0cd566f928d60d128033673e478cf ]

Move some declarations that will be used for cpuset v1 and v2,
including 'cpuset struct', 'cpuset_flagbits_t', cpuset_filetype_t,etc.
No logical change.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 95220e1f18f6 ("cgroup/cpuset: Make nr_deadline_tasks an atomic_t")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset-internal.h | 216 ++++++++++++++++++++++++++++++++
 kernel/cgroup/cpuset.c          | 216 +-------------------------------
 2 files changed, 217 insertions(+), 215 deletions(-)

diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index 034de3cbf3add..f8e300ed0c34d 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -3,4 +3,220 @@
 #ifndef __CPUSET_INTERNAL_H
 #define __CPUSET_INTERNAL_H
 
+#include <linux/cpumask.h>
+#include <linux/spinlock.h>
+#include <linux/cpuset.h>
+#include <linux/cgroup.h>
+
+/* See "Frequency meter" comments, below. */
+
+struct fmeter {
+	int cnt;		/* unprocessed events count */
+	int val;		/* most recent output value */
+	time64_t time;		/* clock (secs) when val computed */
+	spinlock_t lock;	/* guards read or write of above */
+};
+
+/*
+ * Invalid partition error code
+ */
+enum prs_errcode {
+	PERR_NONE = 0,
+	PERR_INVCPUS,
+	PERR_INVPARENT,
+	PERR_NOTPART,
+	PERR_NOTEXCL,
+	PERR_NOCPUS,
+	PERR_HOTPLUG,
+	PERR_CPUSEMPTY,
+};
+
+/* bits in struct cpuset flags field */
+typedef enum {
+	CS_ONLINE,
+	CS_CPU_EXCLUSIVE,
+	CS_MEM_EXCLUSIVE,
+	CS_MEM_HARDWALL,
+	CS_MEMORY_MIGRATE,
+	CS_SCHED_LOAD_BALANCE,
+	CS_SPREAD_PAGE,
+	CS_SPREAD_SLAB,
+} cpuset_flagbits_t;
+
+/* The various types of files and directories in a cpuset file system */
+
+typedef enum {
+	FILE_MEMORY_MIGRATE,
+	FILE_CPULIST,
+	FILE_MEMLIST,
+	FILE_EFFECTIVE_CPULIST,
+	FILE_EFFECTIVE_MEMLIST,
+	FILE_SUBPARTS_CPULIST,
+	FILE_CPU_EXCLUSIVE,
+	FILE_MEM_EXCLUSIVE,
+	FILE_MEM_HARDWALL,
+	FILE_SCHED_LOAD_BALANCE,
+	FILE_PARTITION_ROOT,
+	FILE_SCHED_RELAX_DOMAIN_LEVEL,
+	FILE_MEMORY_PRESSURE_ENABLED,
+	FILE_MEMORY_PRESSURE,
+	FILE_SPREAD_PAGE,
+	FILE_SPREAD_SLAB,
+} cpuset_filetype_t;
+
+struct cpuset {
+	struct cgroup_subsys_state css;
+
+	unsigned long flags;		/* "unsigned long" so bitops work */
+
+	/*
+	 * On default hierarchy:
+	 *
+	 * The user-configured masks can only be changed by writing to
+	 * cpuset.cpus and cpuset.mems, and won't be limited by the
+	 * parent masks.
+	 *
+	 * The effective masks is the real masks that apply to the tasks
+	 * in the cpuset. They may be changed if the configured masks are
+	 * changed or hotplug happens.
+	 *
+	 * effective_mask == configured_mask & parent's effective_mask,
+	 * and if it ends up empty, it will inherit the parent's mask.
+	 *
+	 *
+	 * On legacy hierarchy:
+	 *
+	 * The user-configured masks are always the same with effective masks.
+	 */
+
+	/* user-configured CPUs and Memory Nodes allow to tasks */
+	cpumask_var_t cpus_allowed;
+	nodemask_t mems_allowed;
+
+	/* effective CPUs and Memory Nodes allow to tasks */
+	cpumask_var_t effective_cpus;
+	nodemask_t effective_mems;
+
+	/*
+	 * CPUs allocated to child sub-partitions (default hierarchy only)
+	 * - CPUs granted by the parent = effective_cpus U subparts_cpus
+	 * - effective_cpus and subparts_cpus are mutually exclusive.
+	 *
+	 * effective_cpus contains only onlined CPUs, but subparts_cpus
+	 * may have offlined ones.
+	 */
+	cpumask_var_t subparts_cpus;
+
+	/*
+	 * This is old Memory Nodes tasks took on.
+	 *
+	 * - top_cpuset.old_mems_allowed is initialized to mems_allowed.
+	 * - A new cpuset's old_mems_allowed is initialized when some
+	 *   task is moved into it.
+	 * - old_mems_allowed is used in cpuset_migrate_mm() when we change
+	 *   cpuset.mems_allowed and have tasks' nodemask updated, and
+	 *   then old_mems_allowed is updated to mems_allowed.
+	 */
+	nodemask_t old_mems_allowed;
+
+	struct fmeter fmeter;		/* memory_pressure filter */
+
+	/*
+	 * Tasks are being attached to this cpuset.  Used to prevent
+	 * zeroing cpus/mems_allowed between ->can_attach() and ->attach().
+	 */
+	int attach_in_progress;
+
+	/* partition number for rebuild_sched_domains() */
+	int pn;
+
+	/* for custom sched domain */
+	int relax_domain_level;
+
+	/* number of CPUs in subparts_cpus */
+	int nr_subparts_cpus;
+
+	/* partition root state */
+	int partition_root_state;
+
+	/*
+	 * Default hierarchy only:
+	 * use_parent_ecpus - set if using parent's effective_cpus
+	 * child_ecpus_count - # of children with use_parent_ecpus set
+	 */
+	int use_parent_ecpus;
+	int child_ecpus_count;
+
+	/*
+	 * number of SCHED_DEADLINE tasks attached to this cpuset, so that we
+	 * know when to rebuild associated root domain bandwidth information.
+	 */
+	int nr_deadline_tasks;
+	int nr_migrate_dl_tasks;
+	u64 sum_migrate_dl_bw;
+
+	/* Invalid partition error code, not lock protected */
+	enum prs_errcode prs_err;
+
+	/* Handle for cpuset.cpus.partition */
+	struct cgroup_file partition_file;
+};
+
+static inline struct cpuset *css_cs(struct cgroup_subsys_state *css)
+{
+	return css ? container_of(css, struct cpuset, css) : NULL;
+}
+
+/* Retrieve the cpuset for a task */
+static inline struct cpuset *task_cs(struct task_struct *task)
+{
+	return css_cs(task_css(task, cpuset_cgrp_id));
+}
+
+static inline struct cpuset *parent_cs(struct cpuset *cs)
+{
+	return css_cs(cs->css.parent);
+}
+
+/* convenient tests for these bits */
+static inline bool is_cpuset_online(struct cpuset *cs)
+{
+	return test_bit(CS_ONLINE, &cs->flags) && !css_is_dying(&cs->css);
+}
+
+static inline int is_cpu_exclusive(const struct cpuset *cs)
+{
+	return test_bit(CS_CPU_EXCLUSIVE, &cs->flags);
+}
+
+static inline int is_mem_exclusive(const struct cpuset *cs)
+{
+	return test_bit(CS_MEM_EXCLUSIVE, &cs->flags);
+}
+
+static inline int is_mem_hardwall(const struct cpuset *cs)
+{
+	return test_bit(CS_MEM_HARDWALL, &cs->flags);
+}
+
+static inline int is_sched_load_balance(const struct cpuset *cs)
+{
+	return test_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
+}
+
+static inline int is_memory_migrate(const struct cpuset *cs)
+{
+	return test_bit(CS_MEMORY_MIGRATE, &cs->flags);
+}
+
+static inline int is_spread_page(const struct cpuset *cs)
+{
+	return test_bit(CS_SPREAD_PAGE, &cs->flags);
+}
+
+static inline int is_spread_slab(const struct cpuset *cs)
+{
+	return test_bit(CS_SPREAD_SLAB, &cs->flags);
+}
+
 #endif /* __CPUSET_INTERNAL_H */
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index bb413045d1744..329e7b55e2fdf 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -22,10 +22,9 @@
  *  distribution for more details.
  */
 #include "cgroup-internal.h"
+#include "cpuset-internal.h"
 
 #include <linux/cpu.h>
-#include <linux/cpumask.h>
-#include <linux/cpuset.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
@@ -39,10 +38,8 @@
 #include <linux/sched/mm.h>
 #include <linux/sched/task.h>
 #include <linux/security.h>
-#include <linux/spinlock.h>
 #include <linux/oom.h>
 #include <linux/sched/isolation.h>
-#include <linux/cgroup.h>
 #include <linux/wait.h>
 
 DEFINE_STATIC_KEY_FALSE(cpusets_pre_enable_key);
@@ -55,29 +52,6 @@ DEFINE_STATIC_KEY_FALSE(cpusets_enabled_key);
  */
 DEFINE_STATIC_KEY_FALSE(cpusets_insane_config_key);
 
-/* See "Frequency meter" comments, below. */
-
-struct fmeter {
-	int cnt;		/* unprocessed events count */
-	int val;		/* most recent output value */
-	time64_t time;		/* clock (secs) when val computed */
-	spinlock_t lock;	/* guards read or write of above */
-};
-
-/*
- * Invalid partition error code
- */
-enum prs_errcode {
-	PERR_NONE = 0,
-	PERR_INVCPUS,
-	PERR_INVPARENT,
-	PERR_NOTPART,
-	PERR_NOTEXCL,
-	PERR_NOCPUS,
-	PERR_HOTPLUG,
-	PERR_CPUSEMPTY,
-};
-
 static const char * const perr_strings[] = {
 	[PERR_INVCPUS]   = "Invalid cpu list in cpuset.cpus",
 	[PERR_INVPARENT] = "Parent is an invalid partition root",
@@ -88,104 +62,6 @@ static const char * const perr_strings[] = {
 	[PERR_CPUSEMPTY] = "cpuset.cpus is empty",
 };
 
-struct cpuset {
-	struct cgroup_subsys_state css;
-
-	unsigned long flags;		/* "unsigned long" so bitops work */
-
-	/*
-	 * On default hierarchy:
-	 *
-	 * The user-configured masks can only be changed by writing to
-	 * cpuset.cpus and cpuset.mems, and won't be limited by the
-	 * parent masks.
-	 *
-	 * The effective masks is the real masks that apply to the tasks
-	 * in the cpuset. They may be changed if the configured masks are
-	 * changed or hotplug happens.
-	 *
-	 * effective_mask == configured_mask & parent's effective_mask,
-	 * and if it ends up empty, it will inherit the parent's mask.
-	 *
-	 *
-	 * On legacy hierarchy:
-	 *
-	 * The user-configured masks are always the same with effective masks.
-	 */
-
-	/* user-configured CPUs and Memory Nodes allow to tasks */
-	cpumask_var_t cpus_allowed;
-	nodemask_t mems_allowed;
-
-	/* effective CPUs and Memory Nodes allow to tasks */
-	cpumask_var_t effective_cpus;
-	nodemask_t effective_mems;
-
-	/*
-	 * CPUs allocated to child sub-partitions (default hierarchy only)
-	 * - CPUs granted by the parent = effective_cpus U subparts_cpus
-	 * - effective_cpus and subparts_cpus are mutually exclusive.
-	 *
-	 * effective_cpus contains only onlined CPUs, but subparts_cpus
-	 * may have offlined ones.
-	 */
-	cpumask_var_t subparts_cpus;
-
-	/*
-	 * This is old Memory Nodes tasks took on.
-	 *
-	 * - top_cpuset.old_mems_allowed is initialized to mems_allowed.
-	 * - A new cpuset's old_mems_allowed is initialized when some
-	 *   task is moved into it.
-	 * - old_mems_allowed is used in cpuset_migrate_mm() when we change
-	 *   cpuset.mems_allowed and have tasks' nodemask updated, and
-	 *   then old_mems_allowed is updated to mems_allowed.
-	 */
-	nodemask_t old_mems_allowed;
-
-	struct fmeter fmeter;		/* memory_pressure filter */
-
-	/*
-	 * Tasks are being attached to this cpuset.  Used to prevent
-	 * zeroing cpus/mems_allowed between ->can_attach() and ->attach().
-	 */
-	int attach_in_progress;
-
-	/* partition number for rebuild_sched_domains() */
-	int pn;
-
-	/* for custom sched domain */
-	int relax_domain_level;
-
-	/* number of CPUs in subparts_cpus */
-	int nr_subparts_cpus;
-
-	/* partition root state */
-	int partition_root_state;
-
-	/*
-	 * Default hierarchy only:
-	 * use_parent_ecpus - set if using parent's effective_cpus
-	 * child_ecpus_count - # of children with use_parent_ecpus set
-	 */
-	int use_parent_ecpus;
-	int child_ecpus_count;
-
-	/*
-	 * number of SCHED_DEADLINE tasks attached to this cpuset, so that we
-	 * know when to rebuild associated root domain bandwidth information.
-	 */
-	int nr_deadline_tasks;
-	int nr_migrate_dl_tasks;
-	u64 sum_migrate_dl_bw;
-
-	/* Invalid partition error code, not lock protected */
-	enum prs_errcode prs_err;
-
-	/* Handle for cpuset.cpus.partition */
-	struct cgroup_file partition_file;
-};
-
 /*
  * Partition root states:
  *
@@ -215,22 +91,6 @@ struct tmpmasks {
 	cpumask_var_t new_cpus;		/* For update_cpumasks_hier() */
 };
 
-static inline struct cpuset *css_cs(struct cgroup_subsys_state *css)
-{
-	return css ? container_of(css, struct cpuset, css) : NULL;
-}
-
-/* Retrieve the cpuset for a task */
-static inline struct cpuset *task_cs(struct task_struct *task)
-{
-	return css_cs(task_css(task, cpuset_cgrp_id));
-}
-
-static inline struct cpuset *parent_cs(struct cpuset *cs)
-{
-	return css_cs(cs->css.parent);
-}
-
 void inc_dl_tasks_cs(struct task_struct *p)
 {
 	struct cpuset *cs = task_cs(p);
@@ -245,59 +105,6 @@ void dec_dl_tasks_cs(struct task_struct *p)
 	cs->nr_deadline_tasks--;
 }
 
-/* bits in struct cpuset flags field */
-typedef enum {
-	CS_ONLINE,
-	CS_CPU_EXCLUSIVE,
-	CS_MEM_EXCLUSIVE,
-	CS_MEM_HARDWALL,
-	CS_MEMORY_MIGRATE,
-	CS_SCHED_LOAD_BALANCE,
-	CS_SPREAD_PAGE,
-	CS_SPREAD_SLAB,
-} cpuset_flagbits_t;
-
-/* convenient tests for these bits */
-static inline bool is_cpuset_online(struct cpuset *cs)
-{
-	return test_bit(CS_ONLINE, &cs->flags) && !css_is_dying(&cs->css);
-}
-
-static inline int is_cpu_exclusive(const struct cpuset *cs)
-{
-	return test_bit(CS_CPU_EXCLUSIVE, &cs->flags);
-}
-
-static inline int is_mem_exclusive(const struct cpuset *cs)
-{
-	return test_bit(CS_MEM_EXCLUSIVE, &cs->flags);
-}
-
-static inline int is_mem_hardwall(const struct cpuset *cs)
-{
-	return test_bit(CS_MEM_HARDWALL, &cs->flags);
-}
-
-static inline int is_sched_load_balance(const struct cpuset *cs)
-{
-	return test_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
-}
-
-static inline int is_memory_migrate(const struct cpuset *cs)
-{
-	return test_bit(CS_MEMORY_MIGRATE, &cs->flags);
-}
-
-static inline int is_spread_page(const struct cpuset *cs)
-{
-	return test_bit(CS_SPREAD_PAGE, &cs->flags);
-}
-
-static inline int is_spread_slab(const struct cpuset *cs)
-{
-	return test_bit(CS_SPREAD_SLAB, &cs->flags);
-}
-
 static inline int is_partition_valid(const struct cpuset *cs)
 {
 	return cs->partition_root_state > 0;
@@ -2769,27 +2576,6 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	mutex_unlock(&cpuset_mutex);
 }
 
-/* The various types of files and directories in a cpuset file system */
-
-typedef enum {
-	FILE_MEMORY_MIGRATE,
-	FILE_CPULIST,
-	FILE_MEMLIST,
-	FILE_EFFECTIVE_CPULIST,
-	FILE_EFFECTIVE_MEMLIST,
-	FILE_SUBPARTS_CPULIST,
-	FILE_CPU_EXCLUSIVE,
-	FILE_MEM_EXCLUSIVE,
-	FILE_MEM_HARDWALL,
-	FILE_SCHED_LOAD_BALANCE,
-	FILE_PARTITION_ROOT,
-	FILE_SCHED_RELAX_DOMAIN_LEVEL,
-	FILE_MEMORY_PRESSURE_ENABLED,
-	FILE_MEMORY_PRESSURE,
-	FILE_SPREAD_PAGE,
-	FILE_SPREAD_SLAB,
-} cpuset_filetype_t;
-
 static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 			    u64 val)
 {
-- 
2.53.0



