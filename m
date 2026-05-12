Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C123E0749;
	Tue, 12 May 2026 17:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607828; cv=none; b=kPQS+j8v8VAMRNv6J+tB3aeg8HixgUQgH7RpKGTQ0ofQWXYVx8ygO1r+eSHpF+e0eo9NGXT5G3rPv/oqy966WGT0QbUpmaaUUoy0Rr0PZcrZac1kiml+8WHL2b7LjS5mjVZ+Zn1p71H3Fo4p4MrfQL5WjYby/myLAAmQgyUHMrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607828; c=relaxed/simple;
	bh=b993iMuHDQ3e5gSKEGc2ZVKJrCah8uBQOlKUJ8ou9Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VI4SbUWc71lbporBdYOaqcxPsGeIPOx3AZJG9IKo6uRnmhj9IWv50nh9q4FBfegb63wWVlRhD9vMD3B7y6m7MBhFQyhx33TSYboo1tdrYc/E2Zm1OYz/NZJZloLksey6h3T1lat7b9UoQVpnK4BTrOCP2mLsKV7kmXMX2Z6XXGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2QjIjrn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2QjIjrn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399FCC2BCB0;
	Tue, 12 May 2026 17:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607828;
	bh=b993iMuHDQ3e5gSKEGc2ZVKJrCah8uBQOlKUJ8ou9Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2QjIjrndwQUUZV3TLtGUz7IOwpVf36jAEn7yuxl6XVkilesBNNkfhSidAV8I81E6
	 l+2yJJMFzoweYI9HgROwALfrhjg+LwHu3WGBK9VBgLfddiH5sAoJI/e2codknF5Mta
	 Vh4Ws79gc/0urRwK2iGY1RnPbbHiJ/qoKdFnA+G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/206] mm: convert mm_lock_seq to a proper seqcount
Date: Tue, 12 May 2026 19:37:46 +0200
Message-ID: <20260512173933.121747607@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Suren Baghdasaryan <surenb@google.com>

[ Upstream commit eb449bd96954b1c1e491d19066cfd2a010f0aa47 ]

Convert mm_lock_seq to be seqcount_t and change all mmap_write_lock
variants to increment it, in-line with the usual seqcount usage pattern.
This lets us check whether the mmap_lock is write-locked by checking
mm_lock_seq.sequence counter (odd=locked, even=unlocked). This will be
used when implementing mmap_lock speculation functions.
As a result vm_lock_seq is also change to be unsigned to match the type
of mm_lock_seq.sequence.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Link: https://lkml.kernel.org/r/20241122174416.1367052-2-surenb@google.com
Stable-dep-of: 52f657e34d7b ("x86: shadow stacks: proper error handling for mmap lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm.h               | 12 +++----
 include/linux/mm_types.h         |  7 ++--
 include/linux/mmap_lock.h        | 55 +++++++++++++++++++++-----------
 kernel/fork.c                    |  5 +--
 mm/init-mm.c                     |  2 +-
 tools/testing/vma/vma.c          |  4 +--
 tools/testing/vma/vma_internal.h |  4 +--
 7 files changed, 53 insertions(+), 36 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 20f9287d23a57..01d53e7fdcce5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -698,7 +698,7 @@ static inline bool vma_start_read(struct vm_area_struct *vma)
 	 * we don't rely on for anything - the mm_lock_seq read against which we
 	 * need ordering is below.
 	 */
-	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(vma->vm_mm->mm_lock_seq))
+	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(vma->vm_mm->mm_lock_seq.sequence))
 		return false;
 
 	if (unlikely(down_read_trylock(&vma->vm_lock->lock) == 0))
@@ -715,7 +715,7 @@ static inline bool vma_start_read(struct vm_area_struct *vma)
 	 * after it has been unlocked.
 	 * This pairs with RELEASE semantics in vma_end_write_all().
 	 */
-	if (unlikely(vma->vm_lock_seq == smp_load_acquire(&vma->vm_mm->mm_lock_seq))) {
+	if (unlikely(vma->vm_lock_seq == raw_read_seqcount(&vma->vm_mm->mm_lock_seq))) {
 		up_read(&vma->vm_lock->lock);
 		return false;
 	}
@@ -730,7 +730,7 @@ static inline void vma_end_read(struct vm_area_struct *vma)
 }
 
 /* WARNING! Can only be used if mmap_lock is expected to be write-locked */
-static bool __is_vma_write_locked(struct vm_area_struct *vma, int *mm_lock_seq)
+static bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
 {
 	mmap_assert_write_locked(vma->vm_mm);
 
@@ -738,7 +738,7 @@ static bool __is_vma_write_locked(struct vm_area_struct *vma, int *mm_lock_seq)
 	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
 	 * mm->mm_lock_seq can't be concurrently modified.
 	 */
-	*mm_lock_seq = vma->vm_mm->mm_lock_seq;
+	*mm_lock_seq = vma->vm_mm->mm_lock_seq.sequence;
 	return (vma->vm_lock_seq == *mm_lock_seq);
 }
 
@@ -749,7 +749,7 @@ static bool __is_vma_write_locked(struct vm_area_struct *vma, int *mm_lock_seq)
  */
 static inline void vma_start_write(struct vm_area_struct *vma)
 {
-	int mm_lock_seq;
+	unsigned int mm_lock_seq;
 
 	if (__is_vma_write_locked(vma, &mm_lock_seq))
 		return;
@@ -767,7 +767,7 @@ static inline void vma_start_write(struct vm_area_struct *vma)
 
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 {
-	int mm_lock_seq;
+	unsigned int mm_lock_seq;
 
 	VM_BUG_ON_VMA(!__is_vma_write_locked(vma, &mm_lock_seq), vma);
 }
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 2c834cbf3ff5d..2113f7da182c6 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -750,7 +750,7 @@ struct vm_area_struct {
 	 * counter reuse can only lead to occasional unnecessary use of the
 	 * slowpath.
 	 */
-	int vm_lock_seq;
+	unsigned int vm_lock_seq;
 	/* Unstable RCU readers are allowed to read this. */
 	struct vma_lock *vm_lock;
 #endif
@@ -922,6 +922,9 @@ struct mm_struct {
 		 * Roughly speaking, incrementing the sequence number is
 		 * equivalent to releasing locks on VMAs; reading the sequence
 		 * number can be part of taking a read lock on a VMA.
+		 * Incremented every time mmap_lock is write-locked/unlocked.
+		 * Initialized to 0, therefore odd values indicate mmap_lock
+		 * is write-locked and even values that it's released.
 		 *
 		 * Can be modified under write mmap_lock using RELEASE
 		 * semantics.
@@ -930,7 +933,7 @@ struct mm_struct {
 		 * Can be read with ACQUIRE semantics if not holding write
 		 * mmap_lock.
 		 */
-		int mm_lock_seq;
+		seqcount_t mm_lock_seq;
 #endif
 
 
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index de9dc20b01ba7..9715326f5a85f 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -71,39 +71,39 @@ static inline void mmap_assert_write_locked(const struct mm_struct *mm)
 }
 
 #ifdef CONFIG_PER_VMA_LOCK
-/*
- * Drop all currently-held per-VMA locks.
- * This is called from the mmap_lock implementation directly before releasing
- * a write-locked mmap_lock (or downgrading it to read-locked).
- * This should normally NOT be called manually from other places.
- * If you want to call this manually anyway, keep in mind that this will release
- * *all* VMA write locks, including ones from further up the stack.
- */
-static inline void vma_end_write_all(struct mm_struct *mm)
+static inline void mm_lock_seqcount_init(struct mm_struct *mm)
 {
-	mmap_assert_write_locked(mm);
-	/*
-	 * Nobody can concurrently modify mm->mm_lock_seq due to exclusive
-	 * mmap_lock being held.
-	 * We need RELEASE semantics here to ensure that preceding stores into
-	 * the VMA take effect before we unlock it with this store.
-	 * Pairs with ACQUIRE semantics in vma_start_read().
-	 */
-	smp_store_release(&mm->mm_lock_seq, mm->mm_lock_seq + 1);
+	seqcount_init(&mm->mm_lock_seq);
+}
+
+static inline void mm_lock_seqcount_begin(struct mm_struct *mm)
+{
+	do_raw_write_seqcount_begin(&mm->mm_lock_seq);
+}
+
+static inline void mm_lock_seqcount_end(struct mm_struct *mm)
+{
+	ASSERT_EXCLUSIVE_WRITER(mm->mm_lock_seq);
+	do_raw_write_seqcount_end(&mm->mm_lock_seq);
 }
+
 #else
-static inline void vma_end_write_all(struct mm_struct *mm) {}
+static inline void mm_lock_seqcount_init(struct mm_struct *mm) {}
+static inline void mm_lock_seqcount_begin(struct mm_struct *mm) {}
+static inline void mm_lock_seqcount_end(struct mm_struct *mm) {}
 #endif
 
 static inline void mmap_init_lock(struct mm_struct *mm)
 {
 	init_rwsem(&mm->mmap_lock);
+	mm_lock_seqcount_init(mm);
 }
 
 static inline void mmap_write_lock(struct mm_struct *mm)
 {
 	__mmap_lock_trace_start_locking(mm, true);
 	down_write(&mm->mmap_lock);
+	mm_lock_seqcount_begin(mm);
 	__mmap_lock_trace_acquire_returned(mm, true, true);
 }
 
@@ -111,6 +111,7 @@ static inline void mmap_write_lock_nested(struct mm_struct *mm, int subclass)
 {
 	__mmap_lock_trace_start_locking(mm, true);
 	down_write_nested(&mm->mmap_lock, subclass);
+	mm_lock_seqcount_begin(mm);
 	__mmap_lock_trace_acquire_returned(mm, true, true);
 }
 
@@ -120,10 +121,26 @@ static inline int mmap_write_lock_killable(struct mm_struct *mm)
 
 	__mmap_lock_trace_start_locking(mm, true);
 	ret = down_write_killable(&mm->mmap_lock);
+	if (!ret)
+		mm_lock_seqcount_begin(mm);
 	__mmap_lock_trace_acquire_returned(mm, true, ret == 0);
 	return ret;
 }
 
+/*
+ * Drop all currently-held per-VMA locks.
+ * This is called from the mmap_lock implementation directly before releasing
+ * a write-locked mmap_lock (or downgrading it to read-locked).
+ * This should normally NOT be called manually from other places.
+ * If you want to call this manually anyway, keep in mind that this will release
+ * *all* VMA write locks, including ones from further up the stack.
+ */
+static inline void vma_end_write_all(struct mm_struct *mm)
+{
+	mmap_assert_write_locked(mm);
+	mm_lock_seqcount_end(mm);
+}
+
 static inline void mmap_write_unlock(struct mm_struct *mm)
 {
 	__mmap_lock_trace_released(mm, true);
diff --git a/kernel/fork.c b/kernel/fork.c
index 29532a57e0cd4..c6415bb0abf59 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -450,7 +450,7 @@ static bool vma_lock_alloc(struct vm_area_struct *vma)
 		return false;
 
 	init_rwsem(&vma->vm_lock->lock);
-	vma->vm_lock_seq = -1;
+	vma->vm_lock_seq = UINT_MAX;
 
 	return true;
 }
@@ -1280,9 +1280,6 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	seqcount_init(&mm->write_protect_seq);
 	mmap_init_lock(mm);
 	INIT_LIST_HEAD(&mm->mmlist);
-#ifdef CONFIG_PER_VMA_LOCK
-	mm->mm_lock_seq = 0;
-#endif
 	mm_pgtables_bytes_init(mm);
 	mm->map_count = 0;
 	mm->locked_vm = 0;
diff --git a/mm/init-mm.c b/mm/init-mm.c
index 24c8093792745..6af3ad675930b 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -40,7 +40,7 @@ struct mm_struct init_mm = {
 	.arg_lock	=  __SPIN_LOCK_UNLOCKED(init_mm.arg_lock),
 	.mmlist		= LIST_HEAD_INIT(init_mm.mmlist),
 #ifdef CONFIG_PER_VMA_LOCK
-	.mm_lock_seq	= 0,
+	.mm_lock_seq	= SEQCNT_ZERO(init_mm.mm_lock_seq),
 #endif
 	.user_ns	= &init_user_ns,
 	.cpu_bitmap	= CPU_BITS_NONE,
diff --git a/tools/testing/vma/vma.c b/tools/testing/vma/vma.c
index b33b47342d418..9074aaced9c5a 100644
--- a/tools/testing/vma/vma.c
+++ b/tools/testing/vma/vma.c
@@ -87,7 +87,7 @@ static struct vm_area_struct *alloc_and_link_vma(struct mm_struct *mm,
 	 * begun. Linking to the tree will have caused this to be incremented,
 	 * which means we will get a false positive otherwise.
 	 */
-	vma->vm_lock_seq = -1;
+	vma->vm_lock_seq = UINT_MAX;
 
 	return vma;
 }
@@ -212,7 +212,7 @@ static bool vma_write_started(struct vm_area_struct *vma)
 	int seq = vma->vm_lock_seq;
 
 	/* We reset after each check. */
-	vma->vm_lock_seq = -1;
+	vma->vm_lock_seq = UINT_MAX;
 
 	/* The vma_start_write() stub simply increments this value. */
 	return seq > -1;
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 1d5bbc8464f18..0a95dbb0346fb 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -231,7 +231,7 @@ struct vm_area_struct {
 	 * counter reuse can only lead to occasional unnecessary use of the
 	 * slowpath.
 	 */
-	int vm_lock_seq;
+	unsigned int vm_lock_seq;
 	struct vma_lock *vm_lock;
 #endif
 
@@ -406,7 +406,7 @@ static inline bool vma_lock_alloc(struct vm_area_struct *vma)
 		return false;
 
 	init_rwsem(&vma->vm_lock->lock);
-	vma->vm_lock_seq = -1;
+	vma->vm_lock_seq = UINT_MAX;
 
 	return true;
 }
-- 
2.53.0



