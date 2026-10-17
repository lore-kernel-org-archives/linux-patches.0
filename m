Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4864CF477;
	Sat, 17 Oct 2026 16:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254151; cv=none; b=rtpU795AAsinya8nd1BExZZp4A9BlLiW2IKcWfoBkB0q8VgpKajAiJzPqgxr4pSTfUIx48xPxiddrUrfNKVTpXIqE5pQtYm9JNOVKk4Hp9uk6x5C9Iqb9XxHEXOXgdefAWj8CM7x1x16rzIsvpR6dmFcu3D3Q9KPKz931tuJ3cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254151; c=relaxed/simple;
	bh=8H1wDK8mF0AGl+TlfjCvX58sv155IlZKyG7x7xUWxy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vu3DzOSrRHZ3e3ojo9W8zAS1WCZMMLuKkp29BH6/AJ+RvTRuQtiAGD8xovmqGiBQ8hbkDDqIVWZBHUronPwb5M5FF6jTDw5NVGebfZZVyLsQPyEBPw9u39VWU24kfYD6qm7oW5MpgxywTZ5p9NL+jG/hbeXfKIeOxBPyaulzSBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+bHDXyP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+bHDXyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFED1F000C4;
	Sat, 17 Oct 2026 16:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254150;
	bh=ymhSVe/Ai8CLfkEnZhUk1df/NeYMyVxnLxTnhn15w7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F+bHDXyPaY0I3ydQJm4FPOf6hUDGMfR3N+7WjlDlDeHWEx39LLFvuzUZQHFwFaNoZ
	 aksNy+ObiN7vMBd0ufYP0qBTBjLRJn8PBwF4NRMZJnhQYjTnCFXKYaDRjOtI9wvDNQ
	 0GTPnrlEp6jGT2u1k9Ki8YU2+8K7hoKbiano6zRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Ming <a0yami@mailbox.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 353/869] cgroup/rstat: validate cpu before css_rstat_cpu() access
Date: Sat, 17 Oct 2026 17:53:14 +0200
Message-ID: <20261017160046.153098561@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/cgroup/rstat.c  | 19 ++++++++++++++++---
 mm/memcontrol.c        |  2 +-
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d89da7e067f42..cc882dc2db7f6 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -2189,7 +2189,7 @@ void blk_cgroup_bio_start(struct bio *bio)
 	}
 
 	u64_stats_update_end_irqrestore(&bis->sync, flags);
-	cgroup_rstat_updated(blkcg->css.cgroup, cpu);
+	__cgroup_rstat_updated(blkcg->css.cgroup, cpu);
 	put_cpu();
 }
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 2a510dbbfe623..66a283527fa98 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -688,6 +688,7 @@ static inline void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
 /*
  * cgroup scalable recursive statistics.
  */
+void __cgroup_rstat_updated(struct cgroup *cgrp, int cpu);
 void cgroup_rstat_updated(struct cgroup *cgrp, int cpu);
 void cgroup_rstat_flush(struct cgroup *cgrp);
 void cgroup_rstat_flush_hold(struct cgroup *cgrp);
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index c4ce2f5a9745f..d8bdebdeac023 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include "cgroup-internal.h"
 
+#include <linux/cpumask.h>
 #include <linux/sched/cputime.h>
 
 #include <linux/bpf.h>
@@ -74,7 +75,7 @@ void _cgroup_rstat_cpu_unlock(raw_spinlock_t *cpu_lock, int cpu,
 }
 
 /**
- * cgroup_rstat_updated - keep track of updated rstat_cpu
+ * __cgroup_rstat_updated - keep track of updated rstat_cpu
  * @cgrp: target cgroup
  * @cpu: cpu on which rstat_cpu was updated
  *
@@ -82,7 +83,7 @@ void _cgroup_rstat_cpu_unlock(raw_spinlock_t *cpu_lock, int cpu,
  * rstat_cpu->updated_children list.  See the comment on top of
  * cgroup_rstat_cpu definition for details.
  */
-__bpf_kfunc void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
+void __cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
 {
 	raw_spinlock_t *cpu_lock = per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu);
 	unsigned long flags;
@@ -129,6 +130,18 @@ __bpf_kfunc void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
 	_cgroup_rstat_cpu_unlock(cpu_lock, cpu, cgrp, flags, true);
 }
 
+/*
+ * BPF-facing wrapper for __cgroup_rstat_updated(). Validate the
+ * caller-provided CPU before passing it to the internal rstat updater.
+ */
+__bpf_kfunc void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
+{
+	if (unlikely(cpu < 0 || cpu >= nr_cpu_ids || !cpu_possible(cpu)))
+		return;
+
+	__cgroup_rstat_updated(cgrp, cpu);
+}
+
 /**
  * cgroup_rstat_push_children - push children cgroups into the given list
  * @head: current head of the list (= subtree root)
@@ -511,7 +524,7 @@ static void cgroup_base_stat_cputime_account_end(struct cgroup *cgrp,
 						 unsigned long flags)
 {
 	u64_stats_update_end_irqrestore(&rstatc->bsync, flags);
-	cgroup_rstat_updated(cgrp, smp_processor_id());
+	__cgroup_rstat_updated(cgrp, smp_processor_id());
 	put_cpu_ptr(rstatc);
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 50a1fd9087fae..8b0635ed1d208 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -569,7 +569,7 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 	if (!val)
 		return;
 
-	cgroup_rstat_updated(memcg->css.cgroup, cpu);
+	__cgroup_rstat_updated(memcg->css.cgroup, cpu);
 	statc = this_cpu_ptr(memcg->vmstats_percpu);
 	for (; statc; statc = statc->parent) {
 		stats_updates = READ_ONCE(statc->stats_updates) + abs(val);
-- 
2.53.0



