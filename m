Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022683;
	b=nymz89H0XIQLbj+6gk62ly8BOh5SzMJuCjNwDiQrE8O9+JbRVIdxFzj51rfEuV1QX54p
	 gNOw5dpvYXwBKL0H8iTU1op9OOvnVXzQ6kJ1CLH/A/Go0CqyU1SXkLMQrMC6YFjiZM4KA
	 yt5CKp1C+zvjJT/QwvMZ7T5SvUMuVWUoVUwp7huyCfeFB6I8/90CA41oLKq1PMVmq3gIM
	 LBMgrEaLPjIsCfMO7kCYLK5h4d4xjLRwVk0punnAEziYs9AknkunFNT4afShejyfIheaV
	 7Np31A02lCAxQoc5zuv3Y662y0dYJkZikjuIUTNxmpBVvKT2y253D9C9YV7DWgKg1AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jwVngGhbkyiLd3xxh6+pkuZfZhcdcNv6124pBClgCo4=;
	b=ECO+HEDbuKGQz2lzT2A3c7EkzT7NwLvl/MLGB7JrSrYhom/fMQlWuLriOqeXCqABgkiR
	 syk49FeoH40f4KJvOCt5cTUmi33KKLjhOGEEDhEaHLbn7R/m4gwR3ssZnPXYtvCVig4FA
	 S922pEwiWJNGur/CoTKDDHTzmeeYuRxTSwnyu+UOE3jQ5wGsnsGF9NxXi9Wj60R1tSuNy
	 63ryvPGfmpbH4kzTFl1qr/ZVbzsMD1R12NJY/fmZbEfDGwKtv75fqdedPJtA/LJ6uSHmV
	 1G7wVqjOu0Q5AU4PRIHW2nnE/4ERyWDiD9gKu5TbaAyexNNXxltEUA+w9X9bNTYKWtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=An04oXvv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B4C606A31C;
	Wed, 18 Nov 2026 17:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=An04oXvv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CD11F000C4;
	Wed, 18 Nov 2026 17:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022683;
	bh=jwVngGhbkyiLd3xxh6+pkuZfZhcdcNv6124pBClgCo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=An04oXvvYByU3bMMFrFSN5j6BWRE00mBxZJv2AaeCCSmnFcwve2dNG6n3G7oNt3ZN
	 /Xeyll5w4/ZWjU5AmEASAWlBonEIufauUJZPhHgG6laZUMrZ96EmbDV15dKnBcFmDk
	 Ap2U+uZzW/r4ivr2mqKwOXZqMp2emMJ1jHDLmhro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SJ Park <sj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0101/2151] fs/proc/task_mmu: fix missed VMAs when reading /proc/PID/maps and friends
Date: Wed, 18 Nov 2026 15:30:36 +0100
Message-ID: <20261118150125.480517486@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit ee1afc5539b6fe03569a5855b6041b13343b0993 ]

Reading /proc/PID/maps under per-VMA locks can skip continuously mapped
address ranges during concurrent VMA splits or merges. This violates the
guarantee in Documentation/filesystems/proc.rst:

"If there is something at a given vaddr during the entirety of the
life of the smaps/maps walk, there will be some output for it."

lock_next_vma() reuses a tree iterator across calls under RCU. The iterator
remembers the range of its last entry. When its node is replaced,
mas_next_slot() walks the tree again at the last index of that range, then
advances past the entry containing that index. If VMA boundaries changed,
this can skip a range that has not been reported:

- A lookup finds [A, C), then mprotect() splits it into [A, B) and [B, C)
  before vma_start_read() locks the first VMA. The reader reports [A, B),
  but the iterator still covers [A, C). The next call starts from B yet
  advances past C, omitting [B, C).

- The reader reports [A, B) and unlocks it. A concurrent mprotect() then
  merges it with [B, C). On the next call, the iterator resumes at B - 1,
  which now belongs to [A, C), and advances past C. Again, [B, C) is lost.

Checking the mmap_lock sequence only within the next call misses writers
that completed before that call began. Also, a NULL result is currently
accepted without validation, so a race can terminate the walk early.

Even a fresh lookup can skip a mapping. Suppose it finds a gap before
[B, C). A writer inserts an adjacent VMA at the end of that gap, then
merges it into [B, C), replacing the node. The lookup resumes at the old
gap's last index, now inside the merged VMA, and steps past it. The
original [B, C) remains mapped throughout. Repeating the forward lookup
is insufficient: another merge can make it skip the same mapping again,
returning the same later VMA or NULL.

The fresh-lookup race also affects /proc/PID/smaps, numa_maps and
smaps_rollup. Resetting the iterator after gathering each VMA's statistics
does not prevent a merge during the next lookup. Fixing lock_next_vma()
also prevents omitted entries and incomplete rollup statistics.

Tie VMA iterator state with the current mm and the write generation at the
point of last mm speculation in vma_rcu_iter, whose values we call 'rvmi'.

This allows us to neatly abstract the existing priv->iter logic alongside
query_vma_find_by_addr() which uses its own VMA iterator.

Then, provide helpers that act on the rvmi - vma_rcu_iter_[maybe_changed,
may_have_skipped]() to determine whether any VMAs may have
been altered since last mm speculation.

Additionally introduce vma_range_is_empty(), used by
vma_rcu_iter_may_have_skipped(), to determine conclusively whether VMAs
exist in a set range, needing to be traversed.

Original fix generated by an LLM and sent by Josef Bacik in private, then
amended by David Hildenbrand, and Lorenzo Stoakes added additional
abstraction.

Link: https://lore.kernel.org/20261027-fix-proc-pid-maps-missing-vmas-v2-1-2791cc9fc95f@kernel.org
Fixes: 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock")
Fixes: ea3085dd7a4e ("fs/proc/task_mmu: read proc/pid/{smaps|numa_maps} under per-vma lock")
Fixes: 0e985559d72a ("proc/task_mmu: read proc/pid/smaps_rollup under per-vma lock")
Fixes: d9d1c2d81797 ("fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under per-vma locks")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
[ sashal: kept show_smaps_rollup() unchanged under mmap_lock while moving vma_rcu_iter_init() outside CONFIG_PER_VMA_LOCK. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/internal.h        |  1 +
 fs/proc/task_mmu.c        |  9 +++---
 include/linux/mmap_lock.h | 22 ++++++++++++--
 mm/mmap_lock.c            | 61 +++++++++++++++++++++++++++++----------
 4 files changed, 70 insertions(+), 23 deletions(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 77c347d3b6ad2..ff47feecba59e 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -391,6 +391,7 @@ struct proc_maps_private {
 	struct inode *inode;
 	struct task_struct *task;
 	struct vma_iterator iter;
+	struct vma_rcu_iter rvmi;
 	loff_t last_pos;
 	struct proc_maps_locking_ctx lock_ctx;
 #ifdef CONFIG_NUMA
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 823e8ee1b0953..f706477899f14 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -189,7 +189,7 @@ static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
 		return vma_next(&priv->iter);
 
 	unlock_ctx_vma(lock_ctx);
-	vma = lock_next_vma(lock_ctx->mm, &priv->iter, last_pos);
+	vma = lock_next_vma(&priv->rvmi, last_pos);
 	if (!IS_ERR_OR_NULL(vma))
 		lock_ctx->locked_vma = vma;
 
@@ -308,7 +308,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 	 */
 	if (last_addr > 0)
 		*ppos = last_addr = priv->last_pos;
-	vma_iter_init(&priv->iter, mm, (unsigned long)last_addr);
+	vma_rcu_iter_init(&priv->rvmi, mm, &priv->iter, (unsigned long)last_addr);
 	hold_task_mempolicy(priv);
 	if (last_addr == SENTINEL_VMA_GATE)
 		return get_gate_vma(mm);
@@ -552,6 +552,7 @@ static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_locking_ct
 	struct mm_struct *mm = lock_ctx->mm;
 	struct vm_area_struct *vma;
 	struct vma_iterator vmi;
+	struct vma_rcu_iter rvmi;
 
 	if (lock_ctx->mmap_locked)
 		return find_vma(mm, addr);
@@ -559,8 +560,8 @@ static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_locking_ct
 	/* Unlock previously locked VMA and find the next one under RCU */
 	unlock_ctx_vma(lock_ctx);
 	rcu_read_lock();
-	vma_iter_init(&vmi, mm, addr);
-	vma = lock_next_vma(mm, &vmi, addr);
+	vma_rcu_iter_init(&rvmi, mm, &vmi, addr);
+	vma = lock_next_vma(&rvmi, addr);
 	rcu_read_unlock();
 
 	if (!vma)
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 2e8bef12c76c8..59a2f0b22a29e 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -17,6 +17,13 @@ extern int rcuwait_wake_up(struct rcuwait *w);
 #define MMAP_LOCK_INITIALIZER(name) \
 	.mmap_lock = __RWSEM_INITIALIZER((name).mmap_lock),
 
+/* Tie a VMA iterator to mm write lock state at iterator initialisation. */
+struct vma_rcu_iter {
+	struct mm_struct *mm;
+	struct vma_iterator *vmi;
+	unsigned int mm_wr_seq;
+};
+
 DECLARE_TRACEPOINT(mmap_lock_start_locking);
 DECLARE_TRACEPOINT(mmap_lock_acquire_returned);
 DECLARE_TRACEPOINT(mmap_lock_released);
@@ -263,9 +270,8 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
  * Returns either a valid locked VMA, NULL if no more VMAs or -EINTR if the
  * process was interrupted.
  */
-struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
-				     struct vma_iterator *iter,
-				     unsigned long address);
+struct vm_area_struct *lock_next_vma(struct vma_rcu_iter *rvmi,
+				     unsigned long from_addr);
 
 #else /* CONFIG_PER_VMA_LOCK */
 
@@ -308,6 +314,16 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
 
 #endif /* CONFIG_PER_VMA_LOCK */
 
+static inline void vma_rcu_iter_init(struct vma_rcu_iter *rvmi,
+		struct mm_struct *mm, struct vma_iterator *vmi,
+		unsigned long addr)
+{
+	vma_iter_init(vmi, mm, addr);
+	rvmi->mm = mm;
+	rvmi->vmi = vmi;
+	rvmi->mm_wr_seq = UINT_MAX; /* Start odd so changed by default. */
+}
+
 static inline void mmap_write_lock(struct mm_struct *mm)
 {
 	__mmap_lock_trace_start_locking(mm, true);
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index c6becd6dd5d50..1511e6d617ce4 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -13,6 +13,8 @@
 #include <linux/trace_events.h>
 #include <linux/local_lock.h>
 
+#include "internal.h"
+
 EXPORT_TRACEPOINT_SYMBOL(mmap_lock_start_locking);
 EXPORT_TRACEPOINT_SYMBOL(mmap_lock_acquire_returned);
 EXPORT_TRACEPOINT_SYMBOL(mmap_lock_released);
@@ -322,21 +324,53 @@ static struct vm_area_struct *lock_next_vma_under_mmap_lock(struct mm_struct *mm
 	return vma;
 }
 
-struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
-				     struct vma_iterator *vmi,
+/* Is there no VMA in [start, last]? */
+static bool vma_range_is_empty(struct mm_struct *mm, unsigned long start,
+		unsigned long last)
+{
+	VMA_ITERATOR(vmi, mm, start);
+
+	return !vma_iter_load(&vmi) && vma_iter_end(&vmi) - 1 >= last;
+}
+
+/* Might the VMA tree have been modified since last mm speculation? */
+static bool vma_rcu_iter_maybe_changed(const struct vma_rcu_iter *rvmi)
+{
+	return (rvmi->mm_wr_seq & 1) || /* Odd implies write-lock. */
+	       mmap_lock_speculate_retry(rvmi->mm, rvmi->mm_wr_seq);
+}
+
+/* Could the VMA iterator have skipped a VMA due to the tree changing? */
+static bool vma_rcu_iter_may_have_skipped(const struct vma_rcu_iter *rvmi,
+		unsigned long from, unsigned long to)
+{
+	return vma_rcu_iter_maybe_changed(rvmi) &&
+	       !vma_range_is_empty(rvmi->mm, from, to);
+}
+
+struct vm_area_struct *lock_next_vma(struct vma_rcu_iter *rvmi,
 				     unsigned long from_addr)
 {
+	struct mm_struct *mm = rvmi->mm;
+	struct vma_iterator *vmi = rvmi->vmi;
 	struct vm_area_struct *vma;
-	unsigned int mm_wr_seq;
-	bool mmap_unlocked;
 
 	RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "no rcu read lock held");
 retry:
-	/* Start mmap_lock speculation in case we need to verify the vma later */
-	mmap_unlocked = mmap_lock_speculate_try_begin(mm, &mm_wr_seq);
+	/* Only trust the iterator's position if the tree cannot have changed. */
+	if (vma_rcu_iter_maybe_changed(rvmi)) {
+		vma_iter_set(vmi, from_addr);
+		mmap_lock_speculate_try_begin(mm, &rvmi->mm_wr_seq);
+	}
 	vma = vma_next(vmi);
-	if (!vma)
-		return NULL;
+	if (!vma) {
+		/* No reason to fallback if nothing left in range. */
+		if (!vma_rcu_iter_may_have_skipped(rvmi, from_addr, ULONG_MAX))
+			return NULL;
+
+		rcu_read_unlock();
+		goto fallback;
+	}
 
 	vma = vma_start_read(mm, vma);
 	if (IS_ERR_OR_NULL(vma)) {
@@ -365,14 +399,9 @@ struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
 	 * installed ahead of it. Otherwise we might observe a gap that should
 	 * not be there.
 	 */
-	if (from_addr < vma->vm_start) {
-		/* Verify only if the address space might have changed since vma lookup. */
-		if (!mmap_unlocked || mmap_lock_speculate_retry(mm, mm_wr_seq)) {
-			vma_iter_set(vmi, from_addr);
-			if (vma != vma_next(vmi))
-				goto fallback_unlock;
-		}
-	}
+	if (from_addr < vma->vm_start &&
+	    vma_rcu_iter_may_have_skipped(rvmi, from_addr, vma->vm_start - 1))
+		goto fallback_unlock;
 
 	return vma;
 
-- 
2.53.0



