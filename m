Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216148;
	b=yAW5LloWJMUZTkSV2BH9jWe9WM88m1liGMe2Ew3u3pwgzOMPakrrfJWbb3jiTybbZ393
	 0kssEAspAlQPZk/BrGo2NaOvxudKteBHuFYUn8b5C6cgS8nvs2/s42csmre20kjM87DtM
	 u+TKyzWIKecDFtgc2/StH4vUWDKRPmOyI6Yaqu8GpIIRvvMSk/j7we1QO/iL/vPdIfJUP
	 9MrrZ1iU8Uy1VDF0vetYFHRiLT2GQaELoA5D9V4vNX41iW6pfhXMR8RLLubxV4b17VNrU
	 EHIH+eqDu93+xRcwVm3BpeXWCijd4vfvH71fmjPq2NAKkCpNtRiCtKpyUHGM/JZiGWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cwhts6q4KeT0YzOliphRSCo9HnAcPSA+6KQNam5FSXw=;
	b=EZYUTfzHp+gbAm32y2b8n22awqMa6NN6sTYoVtOznV7bugDJHmXdqyiykbshk3OJqBVp
	 /9qfUQsLmFkydv94Y7Oj0bdPeDf3oVogzcUa/8zWoUsBW5Di1T/icTfBlTYsxT7iauFxK
	 +b+E5KcFezvzGZwQ7qdT1Bb1Sz7oK0M9SBNrkRwYT6YcOA7FcyZT6MgDmgRA7nQZP+ySf
	 vCWxHTK2dCZNgDElvZIikzSrBrTbpquspODLJqEeMImXz0yquTSuPGzdT01E4/kqUyLiJ
	 waTSkhQKIm0KSG9QUPj6kgi4Jdlja7NE+DoCPBvyIuakNwdolUQd18KErC4Pq8TU/4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sMtWwTGh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D66606A31A;
	Wed, 28 Oct 2026 19:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sMtWwTGh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414D81F01825;
	Wed, 28 Oct 2026 19:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216147;
	bh=cwhts6q4KeT0YzOliphRSCo9HnAcPSA+6KQNam5FSXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sMtWwTGhd3+iBY98XQRMLfQ5bpz9rQYR5QP3SuN8P+uCne8gROvm/NJbkWK1MffXL
	 0mGXIs040lLyaWnA3Fr70L6DTGwsfjWoGZn4ow3NEKvCl2guR3qb1SG6NPuOuFfZeZ
	 xxeVVb82NeqBWeCHCb1IE/WYdCdcm00OvXqZVuEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Ming <a0yami@mailbox.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1455/1887] cgroup/rstat: validate cpu before css_rstat_cpu() access
Date: Wed, 28 Oct 2026 17:59:11 +0100
Message-ID: <20261028170532.569786204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 34b89029ba434..4c86003bf4445 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -2034,7 +2034,7 @@ void blk_cgroup_bio_start(struct bio *bio)
 
 	u64_stats_update_end_irqrestore(&bis->sync, flags);
 	if (cgroup_subsys_on_dfl(io_cgrp_subsys))
-		cgroup_rstat_updated(bio->bi_blkg->blkcg->css.cgroup, cpu);
+		__cgroup_rstat_updated(bio->bi_blkg->blkcg->css.cgroup, cpu);
 	put_cpu();
 }
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 2b7d077de7ef6..255b05e18cab4 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -762,6 +762,7 @@ static inline void cgroup_path_from_kernfs_id(u64 id, char *buf, size_t buflen)
 /*
  * cgroup scalable recursive statistics.
  */
+void __cgroup_rstat_updated(struct cgroup *cgrp, int cpu);
 void cgroup_rstat_updated(struct cgroup *cgrp, int cpu);
 void cgroup_rstat_flush(struct cgroup *cgrp);
 void cgroup_rstat_flush_irqsafe(struct cgroup *cgrp);
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 0ae90c15cad85..0660e860afa29 100644
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
-void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
+void __cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
 {
 	raw_spinlock_t *cpu_lock = per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu);
 	unsigned long flags;
@@ -73,6 +74,18 @@ void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
 	raw_spin_unlock_irqrestore(cpu_lock, flags);
 }
 
+/*
+ * BPF-facing wrapper for __cgroup_rstat_updated(). Validate the caller-provided
+ * CPU before passing it to the internal rstat updater.
+ */
+void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
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
@@ -402,7 +415,7 @@ static void cgroup_base_stat_cputime_account_end(struct cgroup *cgrp,
 						 unsigned long flags)
 {
 	u64_stats_update_end_irqrestore(&rstatc->bsync, flags);
-	cgroup_rstat_updated(cgrp, smp_processor_id());
+	__cgroup_rstat_updated(cgrp, smp_processor_id());
 	put_cpu_ptr(rstatc);
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7b64dee7f3862..e270dae84941a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -608,7 +608,7 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 {
 	unsigned int x;
 
-	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
+	__cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
 
 	x = __this_cpu_add_return(stats_updates, abs(val));
 	if (x > MEMCG_CHARGE_BATCH) {
-- 
2.53.0



