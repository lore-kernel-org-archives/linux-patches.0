Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1C2369999;
	Wed, 20 May 2026 17:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297736; cv=none; b=j77rhnlSsrUMzIdhfintTTiyRULF9Qxzz6034CRidCZbKoY5zXu0Sc6iZ+faPCs9ZZW7DvNMROYCaVlwic8oqYufEXdv+gla/O6q4xF7pp5QC82wqi6G8pgJntHKVnwaA8tvEFj4wOPMnbb/3Aidg6p5tYbjWKJimTkto1voVkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297736; c=relaxed/simple;
	bh=qEB2THl6YbfvDBTdliWZUW619WUEzYTJNQC+VJyBQaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJe9plCwM9UiyvqR2wu+tFpdiI3Lq+iap9z34+BYJCEI2OoPGVNWy89dut4MOJrF9KDNESdbuObW/Ou49jiDEIZ9w8Ko+qUnYGmV3L7b3NY/aVk8vC/ssh/4nGdKQP+vXgR68Rb2aQJVU27Y1JpmqZiDYur6mpnYgSTKF6RICvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e41DUzY3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e41DUzY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCB81F000E9;
	Wed, 20 May 2026 17:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297735;
	bh=SsIYKo29v1d+rBSJvQXuig7sab7og1YkNry9os0jDo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e41DUzY3oDxlo6QHKtBhhn4RcXoYBLGapAPyQJ/+qUrGNhVcE1GkRERmrI+fQNVw7
	 My/Y5Z0Y5q0OoKYpHJbRdC0p6YQTixOoeWFvPct8J+58Xi5Wnkn28gfKUIlbNVB3nS
	 U9PMijsin7hZjurl8L6b3KOUWo7yWUlYaV/YgXd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 145/957] bpf: return VMA snapshot from task_vma iterator
Date: Wed, 20 May 2026 18:10:28 +0200
Message-ID: <20260520162137.698996725@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit 4cbee026db54cad39c39db4d356100cb133412b3 ]

Holding the per-VMA lock across the BPF program body creates a lock
ordering problem when helpers acquire locks that depend on mmap_lock:

  vm_lock -> i_rwsem -> mmap_lock -> vm_lock

Snapshot the VMA under the per-VMA lock in _next() via memcpy(), then
drop the lock before returning. The BPF program accesses only the
snapshot.

The verifier only trusts vm_mm and vm_file pointers (see
BTF_TYPE_SAFE_TRUSTED_OR_NULL in verifier.c). vm_file is reference-
counted with get_file() under the lock and released via fput() on the
next iteration or in _destroy(). vm_mm is already correct because
lock_vma_under_rcu() verifies vma->vm_mm == mm. All other pointers
are left as-is by memcpy() since the verifier treats them as untrusted.

Fixes: 4ac454682158 ("bpf: Introduce task_vma open-coded iterator kfuncs")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Mykyta Yatsenko <yatsenko@meta.com>
Link: https://lore.kernel.org/r/20260408154539.3832150-4-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/task_iter.c | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 87e87f18913d9..e791ae065c39b 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -808,7 +808,7 @@ static inline void bpf_iter_mmput_async(struct mm_struct *mm)
 struct bpf_iter_task_vma_kern_data {
 	struct task_struct *task;
 	struct mm_struct *mm;
-	struct vm_area_struct *locked_vma;
+	struct vm_area_struct snapshot;
 	u64 next_addr;
 };
 
@@ -842,7 +842,7 @@ __bpf_kfunc int bpf_iter_task_vma_new(struct bpf_iter_task_vma *it,
 
 	/*
 	 * Reject irqs-disabled contexts including NMI. Operations used
-	 * by _next() and _destroy() (vma_end_read, bpf_iter_mmput_async)
+	 * by _next() and _destroy() (vma_end_read, fput, bpf_iter_mmput_async)
 	 * can take spinlocks with IRQs disabled (pi_lock, pool->lock).
 	 * Running from NMI or from a tracepoint that fires with those
 	 * locks held could deadlock.
@@ -885,7 +885,7 @@ __bpf_kfunc int bpf_iter_task_vma_new(struct bpf_iter_task_vma *it,
 		goto err_cleanup_iter;
 	}
 
-	kit->data->locked_vma = NULL;
+	kit->data->snapshot.vm_file = NULL;
 	kit->data->next_addr = addr;
 	return 0;
 
@@ -947,26 +947,45 @@ bpf_iter_task_vma_find_next(struct bpf_iter_task_vma_kern_data *data)
 	return vma;
 }
 
+static void bpf_iter_task_vma_snapshot_reset(struct vm_area_struct *snap)
+{
+	if (snap->vm_file) {
+		fput(snap->vm_file);
+		snap->vm_file = NULL;
+	}
+}
+
 __bpf_kfunc struct vm_area_struct *bpf_iter_task_vma_next(struct bpf_iter_task_vma *it)
 {
 	struct bpf_iter_task_vma_kern *kit = (void *)it;
-	struct vm_area_struct *vma;
+	struct vm_area_struct *snap, *vma;
 
 	if (!kit->data) /* bpf_iter_task_vma_new failed */
 		return NULL;
 
-	if (kit->data->locked_vma) {
-		vma_end_read(kit->data->locked_vma);
-		kit->data->locked_vma = NULL;
-	}
+	snap = &kit->data->snapshot;
+
+	bpf_iter_task_vma_snapshot_reset(snap);
 
 	vma = bpf_iter_task_vma_find_next(kit->data);
 	if (!vma)
 		return NULL;
 
-	kit->data->locked_vma = vma;
+	memcpy(snap, vma, sizeof(*snap));
+
+	/*
+	 * The verifier only trusts vm_mm and vm_file (see
+	 * BTF_TYPE_SAFE_TRUSTED_OR_NULL in verifier.c). Take a reference
+	 * on vm_file; vm_mm is already correct because lock_vma_under_rcu()
+	 * verifies vma->vm_mm == mm. All other pointers are untrusted by
+	 * the verifier and left as-is.
+	 */
+	if (snap->vm_file)
+		get_file(snap->vm_file);
+
 	kit->data->next_addr = vma->vm_end;
-	return vma;
+	vma_end_read(vma);
+	return snap;
 }
 
 __bpf_kfunc void bpf_iter_task_vma_destroy(struct bpf_iter_task_vma *it)
@@ -974,8 +993,7 @@ __bpf_kfunc void bpf_iter_task_vma_destroy(struct bpf_iter_task_vma *it)
 	struct bpf_iter_task_vma_kern *kit = (void *)it;
 
 	if (kit->data) {
-		if (kit->data->locked_vma)
-			vma_end_read(kit->data->locked_vma);
+		bpf_iter_task_vma_snapshot_reset(&kit->data->snapshot);
 		put_task_struct(kit->data->task);
 		bpf_iter_mmput_async(kit->data->mm);
 		bpf_mem_free(&bpf_global_ma, kit->data);
-- 
2.53.0



