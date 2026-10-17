Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285C23BED01;
	Sat, 17 Oct 2026 17:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258921; cv=none; b=TFnD9w0HkwOPwY6YFp77s8s2SA1XJvlA+YX0i/O2LX65qaJkAoDo/dso9HA+3QYMdpKq7Tw8dFVSXAqX0AMTSo/katy4YSn55nB47gnrUGkQlQoHrraW4QHZZzjVlf08BOgHpcTAgIO49LGR5Xwckoe4NyGJswh1y42kPlCFF6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258921; c=relaxed/simple;
	bh=NlC/5MFwSzgmwo1scp1Nbpm95GVeUP8oygxsxxHpDBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cE+B3/1MSsEsWwIpi3FPeTfDhdROycbFaIm/6NngQfVrJCE4NF/o9m8J97CRjPQikfDDNlNGbhHaJ2fNXqBH130g1zmQzBm+AnrNfnRtyBtga07iD+Ta5ozu8E1iqiGotxjzz2d78gqRc3EtMuwrXdkZf1mH0f6KbRJspCiQDpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6wI8Jb7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6wI8Jb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C411F000C4;
	Sat, 17 Oct 2026 17:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258920;
	bh=FZN0hzB/INsQVbCSdW/OdbU7sQaI1cuE6qEhpqzKz2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u6wI8Jb7YgYKc6Ysg2I2zv9zdeV5Ce4TAXvDEYfbr2L8ErO9BXbEavEkeRqPM+ps+
	 bnAi+7z77uXv+NyxHfNUDJ2bmmBWeK2NC08MrC2LKbS8BhinShZTCD4JcyfdN0qzaI
	 oCbkopFvjlsgjcOGLmlEiONLxvn/+h+yOrx7sK70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Ming <a0yami@mailbox.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1043/1674] cgroup/rstat: validate cpu before css_rstat_cpu() access
Date: Sat, 17 Oct 2026 17:55:15 +0200
Message-ID: <20261017160457.906931136@linuxfoundation.org>
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
index 9b1034fe8c879..f23d5f8c6ef22 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -2194,7 +2194,7 @@ void blk_cgroup_bio_start(struct bio *bio)
 	}
 
 	u64_stats_update_end_irqrestore(&bis->sync, flags);
-	cgroup_rstat_updated(blkcg->css.cgroup, cpu);
+	__cgroup_rstat_updated(blkcg->css.cgroup, cpu);
 	put_cpu();
 }
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index fa87b6a15082c..bbfa1abf05d33 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -690,6 +690,7 @@ static inline void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
 /*
  * cgroup scalable recursive statistics.
  */
+void __cgroup_rstat_updated(struct cgroup *cgrp, int cpu);
 void cgroup_rstat_updated(struct cgroup *cgrp, int cpu);
 void cgroup_rstat_flush(struct cgroup *cgrp);
 void cgroup_rstat_flush_hold(struct cgroup *cgrp);
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index c32439b855f5d..c78d3c4c652e7 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include "cgroup-internal.h"
 
+#include <linux/cpumask.h>
 #include <linux/sched/cputime.h>
 
 #include <linux/bpf.h>
@@ -18,7 +19,7 @@ static struct cgroup_rstat_cpu *cgroup_rstat_cpu(struct cgroup *cgrp, int cpu)
 }
 
 /**
- * cgroup_rstat_updated - keep track of updated rstat_cpu
+ * __cgroup_rstat_updated - keep track of updated rstat_cpu
  * @cgrp: target cgroup
  * @cpu: cpu on which rstat_cpu was updated
  *
@@ -26,7 +27,7 @@ static struct cgroup_rstat_cpu *cgroup_rstat_cpu(struct cgroup *cgrp, int cpu)
  * rstat_cpu->updated_children list.  See the comment on top of
  * cgroup_rstat_cpu definition for details.
  */
-__bpf_kfunc void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
+void __cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
 {
 	raw_spinlock_t *cpu_lock = per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu);
 	unsigned long flags;
@@ -73,6 +74,18 @@ __bpf_kfunc void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
 	raw_spin_unlock_irqrestore(cpu_lock, flags);
 }
 
+/*
+ * BPF-facing wrapper for __cgroup_rstat_updated(). Validate the caller-provided
+ * CPU before passing it to the internal rstat updater.
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
  * cgroup_rstat_cpu_pop_updated - iterate and dismantle rstat_cpu updated tree
  * @pos: current position
@@ -394,7 +407,7 @@ static void cgroup_base_stat_cputime_account_end(struct cgroup *cgrp,
 						 unsigned long flags)
 {
 	u64_stats_update_end_irqrestore(&rstatc->bsync, flags);
-	cgroup_rstat_updated(cgrp, smp_processor_id());
+	__cgroup_rstat_updated(cgrp, smp_processor_id());
 	put_cpu_ptr(rstatc);
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5c654a395fff1..d612b32d3ce3a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -715,7 +715,7 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 	if (!val)
 		return;
 
-	cgroup_rstat_updated(memcg->css.cgroup, cpu);
+	__cgroup_rstat_updated(memcg->css.cgroup, cpu);
 	statc = this_cpu_ptr(memcg->vmstats_percpu);
 	for (; statc; statc = statc->parent) {
 		stats_updates = READ_ONCE(statc->stats_updates) + abs(val);
-- 
2.53.0



