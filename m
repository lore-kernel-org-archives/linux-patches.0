Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AE72D9787;
	Thu, 28 May 2026 20:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000152; cv=none; b=QSxREt94bpYst+xJFjy14xGx5WVF6mpH7CQHJUjDwTy7A5oeIlMuuLNMkNNvpQCTrt+q66LP0vM0xTh3HHvW/ZfJOUl3gt+j1xVTsyGi55Nt5kInPrqyH6Cf5fgM8oFZ6eD13zQA4X6cD40ypAHWeM7nfEW+nyB0g+EvhReEOqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000152; c=relaxed/simple;
	bh=s2VEaiJDtPR76NJh8C2kpmLrGh9AGXZKKQjHUA+AZlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfdL74bd1QD3KrB8nwsLdG1eF96pdtwns6bH5QI13eCiFGju7Y4jDWnkk/MjmhiT7KTiarWH7AP72Z4S3BdrOYJDekmKANjm7E0ImywFJ8KvCJL+0lInXz70cdZP6nP+NyixNo80NA07xHQUI8LfjzR5TCpqM2z83sbCDStpkbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8kGi2fe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8kGi2fe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA511F000E9;
	Thu, 28 May 2026 20:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000151;
	bh=NlhNHXQUVZV7REhUNNS2yf6AMsAEh1lG2VJOPqQN6+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8kGi2feRvHCOXCOnDYmR0lfNYZFMsSwMbM03R4teXI/YL6eRtasXg1V/2iNnc3hH
	 t0Kahc5E7OuIymJwxBZsl60oIpAmebGq798deaKUpY6Ae4BDlreIP0/w9FP0TeH4n+
	 J16mTD0wc8dwJW14G6r1unyYUOoutM3Qpcv82VGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Ming <a0yami@mailbox.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 321/377] cgroup/rstat: validate cpu before css_rstat_cpu() access
Date: Thu, 28 May 2026 21:49:19 +0200
Message-ID: <20260528194647.692173921@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Qing Ming <a0yami@mailbox.org>

[ Upstream commit 8817005efbdfdf5d4e4814cb5dc52b53d12917d7 ]

css_rstat_updated() is exposed as a BPF kfunc and accepts a
caller-provided cpu argument. The function uses cpu for per-cpu rstat
lookups without checking whether it refers to a valid possible CPU.

A BPF iter/cgroup program with CAP_BPF and CAP_PERFMON can pass an
invalid cpu value. On an unfixed UBSCAN_BOUNDS test kernel, cpu ==
0x7fffffff triggers:

  UBSAN: array-index-out-of-bounds in kernel/cgroup/rstat.c:31:9
  index 2147483647 is out of range for type 'long unsigned int [64]'
  Call Trace:
    css_rstat_updated
    bpf_iter_run_prog
    cgroup_iter_seq_show
    bpf_seq_read

Add cpu validation to the BPF-facing css_rstat_updated() kfunc and
move the common implementation to __css_rstat_updated() for in-kernel
callers.

Fixes: a319185be9f5 ("cgroup: bpf: enable bpf programs to integrate with rstat")
Signed-off-by: Qing Ming <a0yami@mailbox.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c     |  2 +-
 include/linux/cgroup.h |  1 +
 kernel/cgroup/rstat.c  | 30 ++++++++++++++++++++----------
 mm/memcontrol.c        |  6 +++---
 4 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 9a8d047be580b..f1ea69743c544 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -2241,7 +2241,7 @@ void blk_cgroup_bio_start(struct bio *bio)
 	}
 
 	u64_stats_update_end_irqrestore(&bis->sync, flags);
-	css_rstat_updated(&blkcg->css, cpu);
+	__css_rstat_updated(&blkcg->css, cpu);
 	put_cpu();
 }
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 6ed477338b166..7b2807009155a 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -713,6 +713,7 @@ static inline void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
 /*
  * cgroup scalable recursive statistics.
  */
+void __css_rstat_updated(struct cgroup_subsys_state *css, int cpu);
 void css_rstat_updated(struct cgroup_subsys_state *css, int cpu);
 void css_rstat_flush(struct cgroup_subsys_state *css);
 
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 150e5871e66f2..ed60ba119c687 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include "cgroup-internal.h"
 
+#include <linux/cpumask.h>
 #include <linux/sched/cputime.h>
 
 #include <linux/bpf.h>
@@ -53,7 +54,7 @@ static inline struct llist_head *ss_lhead_cpu(struct cgroup_subsys *ss, int cpu)
 }
 
 /**
- * css_rstat_updated - keep track of updated rstat_cpu
+ * __css_rstat_updated - keep track of updated rstat_cpu
  * @css: target cgroup subsystem state
  * @cpu: cpu on which rstat_cpu was updated
  *
@@ -63,20 +64,17 @@ static inline struct llist_head *ss_lhead_cpu(struct cgroup_subsys *ss, int cpu)
  *
  * NOTE: if the user needs the guarantee that the updater either add itself in
  * the lockless list or the concurrent flusher flushes its updated stats, a
- * memory barrier is needed before the call to css_rstat_updated() i.e. a
+ * memory barrier is needed before the call to __css_rstat_updated() i.e. a
  * barrier after updating the per-cpu stats and before calling
- * css_rstat_updated().
+ * __css_rstat_updated().
  */
-__bpf_kfunc void css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
+void __css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
 {
 	struct llist_head *lhead;
 	struct css_rstat_cpu *rstatc;
 	struct llist_node *self;
 
-	/*
-	 * Since bpf programs can call this function, prevent access to
-	 * uninitialized rstat pointers.
-	 */
+	/* Prevent access to uninitialized rstat pointers. */
 	if (!css_uses_rstat(css))
 		return;
 
@@ -125,6 +123,18 @@ __bpf_kfunc void css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
 	llist_add(&rstatc->lnode, lhead);
 }
 
+/*
+ * BPF-facing wrapper for __css_rstat_updated(). Validate the caller-provided
+ * CPU before passing it to the internal rstat updater.
+ */
+__bpf_kfunc void css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
+{
+	if (unlikely(cpu < 0 || cpu >= nr_cpu_ids || !cpu_possible(cpu)))
+		return;
+
+	__css_rstat_updated(css, cpu);
+}
+
 static void __css_process_update_tree(struct cgroup_subsys_state *css, int cpu)
 {
 	/* put @css and all ancestors on the corresponding updated lists */
@@ -170,7 +180,7 @@ static void css_process_update_tree(struct cgroup_subsys *ss, int cpu)
 		 * flusher flush the stats updated by the updater who have
 		 * observed that they are already on the list. The
 		 * corresponding barrier pair for this one should be before
-		 * css_rstat_updated() by the user.
+		 * __css_rstat_updated() by the user.
 		 *
 		 * For now, there aren't any such user, so not adding the
 		 * barrier here but if such a use-case arise, please add
@@ -614,7 +624,7 @@ static void cgroup_base_stat_cputime_account_end(struct cgroup *cgrp,
 						 unsigned long flags)
 {
 	u64_stats_update_end_irqrestore(&rstatbc->bsync, flags);
-	css_rstat_updated(&cgrp->self, smp_processor_id());
+	__css_rstat_updated(&cgrp->self, smp_processor_id());
 	put_cpu_ptr(rstatbc);
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 61cf6af26f3c9..4df68e5468add 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -571,7 +571,7 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val,
 	if (!val)
 		return;
 
-	css_rstat_updated(&memcg->css, cpu);
+	__css_rstat_updated(&memcg->css, cpu);
 	statc_pcpu = memcg->vmstats_percpu;
 	for (; statc_pcpu; statc_pcpu = statc->parent_pcpu) {
 		statc = this_cpu_ptr(statc_pcpu);
@@ -2525,7 +2525,7 @@ static inline void account_slab_nmi_safe(struct mem_cgroup *memcg,
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[pgdat->node_id];
 
 		/* preemption is disabled in_nmi(). */
-		css_rstat_updated(&memcg->css, smp_processor_id());
+		__css_rstat_updated(&memcg->css, smp_processor_id());
 		if (idx == NR_SLAB_RECLAIMABLE_B)
 			atomic_add(nr, &pn->slab_reclaimable);
 		else
@@ -2749,7 +2749,7 @@ static inline void account_kmem_nmi_safe(struct mem_cgroup *memcg, int val)
 		mod_memcg_state(memcg, MEMCG_KMEM, val);
 	} else {
 		/* preemption is disabled in_nmi(). */
-		css_rstat_updated(&memcg->css, smp_processor_id());
+		__css_rstat_updated(&memcg->css, smp_processor_id());
 		atomic_add(val, &memcg->kmem_stat);
 	}
 }
-- 
2.53.0



