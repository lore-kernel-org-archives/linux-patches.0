Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10DC3F789B;
	Wed, 20 May 2026 18:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300196; cv=none; b=fybYmv1l5FfGOVzOXxDGl9IchXvrj2n4hMGguHxNHVfVZqt0KvAHl0ZYPKt/HUH+6q4UuBDNAri7KwAV/z7cv9MaZLxnQ+3DDnPILe35THWIaju3zsLXwb1JasIujfQhakV13XdXC9BB1lTIbbb8yVQfMERt6U4fFt2+o5acMHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300196; c=relaxed/simple;
	bh=ArTPJf+9M76g7K3r6vIuztWyFu+iK71bp2Uo/7wLYeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxJjAHH+M6Vq+VzMTrMz/3T7/WiOq4RfokueA623rUTTjhlKHqaGKl3RRs/JK/UvP1zJZy5LVR19xciCy3WOqecDNROaHJUL4DkM/V8HOjf786+wd3qXyU33qc9oH8x2LYOP/n80bUz7FOjZbMqDEYjKn6mKKWiJQVibHEmCP3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJ51iGHQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJ51iGHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B361F00893;
	Wed, 20 May 2026 18:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300195;
	bh=nI9lp3jGhQjhp54G5n9V4FJitvl0BNgt5GfeLxqMP/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJ51iGHQfzaCrP2InaWBS2nUKQpLF7PdtPFlizhQUSiihF0gjfnLcnswg9hu1ZM40
	 3ZDc0Q0H0cJT17UQ5mixsHYA9EaoSaZbGAOFWvawhOb9LgPGW2X9ehUM5lW8IwyCxE
	 sOTbkAfBBDCJUxlmDfCAd4tANWeI3gSWgfWX3CJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/666] bpf: return VMA snapshot from task_vma iterator
Date: Wed, 20 May 2026 18:14:55 +0200
Message-ID: <20260520162113.050478425@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index aee03c55602a0..fc5f463ca529a 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -812,7 +812,7 @@ static inline void bpf_iter_mmput_async(struct mm_struct *mm)
 struct bpf_iter_task_vma_kern_data {
 	struct task_struct *task;
 	struct mm_struct *mm;
-	struct vm_area_struct *locked_vma;
+	struct vm_area_struct snapshot;
 	u64 next_addr;
 };
 
@@ -846,7 +846,7 @@ __bpf_kfunc int bpf_iter_task_vma_new(struct bpf_iter_task_vma *it,
 
 	/*
 	 * Reject irqs-disabled contexts including NMI. Operations used
-	 * by _next() and _destroy() (vma_end_read, bpf_iter_mmput_async)
+	 * by _next() and _destroy() (vma_end_read, fput, bpf_iter_mmput_async)
 	 * can take spinlocks with IRQs disabled (pi_lock, pool->lock).
 	 * Running from NMI or from a tracepoint that fires with those
 	 * locks held could deadlock.
@@ -889,7 +889,7 @@ __bpf_kfunc int bpf_iter_task_vma_new(struct bpf_iter_task_vma *it,
 		goto err_cleanup_iter;
 	}
 
-	kit->data->locked_vma = NULL;
+	kit->data->snapshot.vm_file = NULL;
 	kit->data->next_addr = addr;
 	return 0;
 
@@ -951,26 +951,45 @@ bpf_iter_task_vma_find_next(struct bpf_iter_task_vma_kern_data *data)
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
@@ -978,8 +997,7 @@ __bpf_kfunc void bpf_iter_task_vma_destroy(struct bpf_iter_task_vma *it)
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



