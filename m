Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2D0233933;
	Wed, 20 May 2026 16:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294807; cv=none; b=h6F2JfTPSe8zCgJnMe03RoDlh8LL9wDJXeL9inCg8F3nKrNP+/44mIaqQtb4KPdlTM7Z2/gIwXmOfHuzbJOOsCLwaMf9h4oRPYY3ahAveANUg2N0I3gpovaepDVitkqc+V5V+tPOP2PsCrg6vnUDUiZilpIYllyVpvi+KXTT9fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294807; c=relaxed/simple;
	bh=AmlGzCPbPUAgE5r5pDLTuNLvievl1E0f4+71lLOQBGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhGeNsZPGLNMiclp2FyxsdGtYiBqHlDr+IhNCRcyB2KOur4bOJLAFl3Op3NjgiEkrenIY3Jyw+1Hy9BG4n98C5x0lIsliigZhNF31rqZR0f7xRsWbE9+aFRwVEJn2t/ZZAg/6/wDRikgc3d4YJxEVI97UI78PUeGztaqTKiDmh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P4FRKt8/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P4FRKt8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448691F000E9;
	Wed, 20 May 2026 16:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294805;
	bh=X+1RResyZwNdW/PvfP/IDVaicn70q0yDJwgrv8jjKDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P4FRKt8/LxQ+jz86i8P2Nqq12+6avM4Yozr5c/9f9I45vT5kDDRBOgNsrRg38c/f3
	 z6qvZFvjOsqE1gqkz9jcTwuY/jf7XE3fybTQMgvRWXmCmoXZuE8CKJIcSZpBz9JzIF
	 DpJ4VNlTbyzA5m3zQDV9nLOW9gDc9jR9Ka++4++E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0180/1146] bpf: fix mm lifecycle in open-coded task_vma iterator
Date: Wed, 20 May 2026 18:07:10 +0200
Message-ID: <20260520162152.354211154@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit d8e27d2d22b6e2df3a0125b8c08e9aace38c954c ]

The open-coded task_vma iterator reads task->mm locklessly and acquires
mmap_read_trylock() but never calls mmget(). If the task exits
concurrently, the mm_struct can be freed as it is not
SLAB_TYPESAFE_BY_RCU, resulting in a use-after-free.

Safely read task->mm with a trylock on alloc_lock and acquire an mm
reference. Drop the reference via bpf_iter_mmput_async() in _destroy()
and error paths. bpf_iter_mmput_async() is a local wrapper around
mmput_async() with a fallback to mmput() on !CONFIG_MMU.

Reject irqs-disabled contexts (including NMI) up front. Operations used
by _next() and _destroy() (mmap_read_unlock, bpf_iter_mmput_async)
take spinlocks with IRQs disabled (pool->lock, pi_lock). Running from
NMI or from a tracepoint that fires with those locks held could
deadlock.

A trylock on alloc_lock is used instead of the blocking task_lock()
(get_task_mm) to avoid a deadlock when a softirq BPF program iterates
a task that already holds its alloc_lock on the same CPU.

Fixes: 4ac454682158 ("bpf: Introduce task_vma open-coded iterator kfuncs")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Link: https://lore.kernel.org/r/20260408154539.3832150-2-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/task_iter.c | 54 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 98d9b4c0daff3..c1f5fbe9dc2f3 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -9,6 +9,7 @@
 #include <linux/bpf_mem_alloc.h>
 #include <linux/btf_ids.h>
 #include <linux/mm_types.h>
+#include <linux/sched/mm.h>
 #include "mmap_unlock_work.h"
 
 static const char * const iter_task_type_names[] = {
@@ -794,6 +795,15 @@ const struct bpf_func_proto bpf_find_vma_proto = {
 	.arg5_type	= ARG_ANYTHING,
 };
 
+static inline void bpf_iter_mmput_async(struct mm_struct *mm)
+{
+#ifdef CONFIG_MMU
+	mmput_async(mm);
+#else
+	mmput(mm);
+#endif
+}
+
 struct bpf_iter_task_vma_kern_data {
 	struct task_struct *task;
 	struct mm_struct *mm;
@@ -825,6 +835,24 @@ __bpf_kfunc int bpf_iter_task_vma_new(struct bpf_iter_task_vma *it,
 	BUILD_BUG_ON(sizeof(struct bpf_iter_task_vma_kern) != sizeof(struct bpf_iter_task_vma));
 	BUILD_BUG_ON(__alignof__(struct bpf_iter_task_vma_kern) != __alignof__(struct bpf_iter_task_vma));
 
+	/* bpf_iter_mmput_async() needs mmput_async() which requires CONFIG_MMU */
+	if (!IS_ENABLED(CONFIG_MMU)) {
+		kit->data = NULL;
+		return -EOPNOTSUPP;
+	}
+
+	/*
+	 * Reject irqs-disabled contexts including NMI. Operations used
+	 * by _next() and _destroy() (mmap_read_unlock, bpf_iter_mmput_async)
+	 * can take spinlocks with IRQs disabled (pi_lock, pool->lock).
+	 * Running from NMI or from a tracepoint that fires with those
+	 * locks held could deadlock.
+	 */
+	if (irqs_disabled()) {
+		kit->data = NULL;
+		return -EBUSY;
+	}
+
 	/* is_iter_reg_valid_uninit guarantees that kit hasn't been initialized
 	 * before, so non-NULL kit->data doesn't point to previously
 	 * bpf_mem_alloc'd bpf_iter_task_vma_kern_data
@@ -834,7 +862,25 @@ __bpf_kfunc int bpf_iter_task_vma_new(struct bpf_iter_task_vma *it,
 		return -ENOMEM;
 
 	kit->data->task = get_task_struct(task);
+	/*
+	 * Safely read task->mm and acquire an mm reference.
+	 *
+	 * Cannot use get_task_mm() because its task_lock() is a
+	 * blocking spin_lock that would deadlock if the target task
+	 * already holds alloc_lock on this CPU (e.g. a softirq BPF
+	 * program iterating a task interrupted while holding its
+	 * alloc_lock).
+	 */
+	if (!spin_trylock(&task->alloc_lock)) {
+		err = -EBUSY;
+		goto err_cleanup_iter;
+	}
 	kit->data->mm = task->mm;
+	if (kit->data->mm && !(task->flags & PF_KTHREAD))
+		mmget(kit->data->mm);
+	else
+		kit->data->mm = NULL;
+	spin_unlock(&task->alloc_lock);
 	if (!kit->data->mm) {
 		err = -ENOENT;
 		goto err_cleanup_iter;
@@ -844,15 +890,16 @@ __bpf_kfunc int bpf_iter_task_vma_new(struct bpf_iter_task_vma *it,
 	irq_work_busy = bpf_mmap_unlock_get_irq_work(&kit->data->work);
 	if (irq_work_busy || !mmap_read_trylock(kit->data->mm)) {
 		err = -EBUSY;
-		goto err_cleanup_iter;
+		goto err_cleanup_mmget;
 	}
 
 	vma_iter_init(&kit->data->vmi, kit->data->mm, addr);
 	return 0;
 
+err_cleanup_mmget:
+	bpf_iter_mmput_async(kit->data->mm);
 err_cleanup_iter:
-	if (kit->data->task)
-		put_task_struct(kit->data->task);
+	put_task_struct(kit->data->task);
 	bpf_mem_free(&bpf_global_ma, kit->data);
 	/* NULL kit->data signals failed bpf_iter_task_vma initialization */
 	kit->data = NULL;
@@ -875,6 +922,7 @@ __bpf_kfunc void bpf_iter_task_vma_destroy(struct bpf_iter_task_vma *it)
 	if (kit->data) {
 		bpf_mmap_unlock_mm(kit->data->work, kit->data->mm);
 		put_task_struct(kit->data->task);
+		bpf_iter_mmput_async(kit->data->mm);
 		bpf_mem_free(&bpf_global_ma, kit->data);
 	}
 }
-- 
2.53.0



