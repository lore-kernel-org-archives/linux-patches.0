Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDCEAD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF37BC433F1;
	Wed,  4 Jan 2023 16:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849147;
	bh=QnTL1pJhaYM9HhLu9CZz2zN9rtJDnHdoTLLxjIBkB9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bKO0eRgzbcNy0h7qu389GCrX+PGW5uNrCP+kRxjiYhXaScZ7ZcIg9zls5/hMuwBCR
	 Eia7YpSy5N8nCF6VonP5yRK5iBs29cY6Jir5x95WbRWLTSUuL+EYpiFpxYkmgaUcO5
	 o0bRuX9NdcMfRAhpp2bRP9GNriIlsaToOSwUuKB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	James Houghton <jthoughton@google.com>,
	Mina Almasry <almasrymina@google.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Naoya Horiguchi <naoya.horiguchi@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 142/207] hugetlb: really allocate vma lock for all sharable vmas
Date: Wed,  4 Jan 2023 17:06:40 +0100
Message-Id: <20230104160516.419267605@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Kravetz <mike.kravetz@oracle.com>

commit e700898fa075c69b3ae02b702ab57fb75e1a82ec upstream.

Commit bbff39cc6cbc ("hugetlb: allocate vma lock for all sharable vmas")
removed the pmd sharable checks in the vma lock helper routines.  However,
it left the functional version of helper routines behind #ifdef
CONFIG_ARCH_WANT_HUGE_PMD_SHARE.  Therefore, the vma lock is not being
used for sharable vmas on architectures that do not support pmd sharing.
On these architectures, a potential fault/truncation race is exposed that
could leave pages in a hugetlb file past i_size until the file is removed.

Move the functional vma lock helpers outside the ifdef, and remove the
non-functional stubs.  Since the vma lock is not just for pmd sharing,
rename the routine __vma_shareable_flags_pmd.

Link: https://lkml.kernel.org/r/20221212235042.178355-1-mike.kravetz@oracle.com
Fixes: bbff39cc6cbc ("hugetlb: allocate vma lock for all sharable vmas")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |  333 ++++++++++++++++++++++++++---------------------------------
 1 file changed, 148 insertions(+), 185 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -255,6 +255,152 @@ static inline struct hugepage_subpool *s
 	return subpool_inode(file_inode(vma->vm_file));
 }
 
+/*
+ * hugetlb vma_lock helper routines
+ */
+static bool __vma_shareable_lock(struct vm_area_struct *vma)
+{
+	return vma->vm_flags & (VM_MAYSHARE | VM_SHARED) &&
+		vma->vm_private_data;
+}
+
+void hugetlb_vma_lock_read(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_lock(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		down_read(&vma_lock->rw_sema);
+	}
+}
+
+void hugetlb_vma_unlock_read(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_lock(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		up_read(&vma_lock->rw_sema);
+	}
+}
+
+void hugetlb_vma_lock_write(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_lock(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		down_write(&vma_lock->rw_sema);
+	}
+}
+
+void hugetlb_vma_unlock_write(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_lock(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		up_write(&vma_lock->rw_sema);
+	}
+}
+
+int hugetlb_vma_trylock_write(struct vm_area_struct *vma)
+{
+	struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+	if (!__vma_shareable_lock(vma))
+		return 1;
+
+	return down_write_trylock(&vma_lock->rw_sema);
+}
+
+void hugetlb_vma_assert_locked(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_lock(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		lockdep_assert_held(&vma_lock->rw_sema);
+	}
+}
+
+void hugetlb_vma_lock_release(struct kref *kref)
+{
+	struct hugetlb_vma_lock *vma_lock = container_of(kref,
+			struct hugetlb_vma_lock, refs);
+
+	kfree(vma_lock);
+}
+
+static void __hugetlb_vma_unlock_write_put(struct hugetlb_vma_lock *vma_lock)
+{
+	struct vm_area_struct *vma = vma_lock->vma;
+
+	/*
+	 * vma_lock structure may or not be released as a result of put,
+	 * it certainly will no longer be attached to vma so clear pointer.
+	 * Semaphore synchronizes access to vma_lock->vma field.
+	 */
+	vma_lock->vma = NULL;
+	vma->vm_private_data = NULL;
+	up_write(&vma_lock->rw_sema);
+	kref_put(&vma_lock->refs, hugetlb_vma_lock_release);
+}
+
+static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_lock(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		__hugetlb_vma_unlock_write_put(vma_lock);
+	}
+}
+
+static void hugetlb_vma_lock_free(struct vm_area_struct *vma)
+{
+	/*
+	 * Only present in sharable vmas.
+	 */
+	if (!vma || !__vma_shareable_lock(vma))
+		return;
+
+	if (vma->vm_private_data) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		down_write(&vma_lock->rw_sema);
+		__hugetlb_vma_unlock_write_put(vma_lock);
+	}
+}
+
+static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma)
+{
+	struct hugetlb_vma_lock *vma_lock;
+
+	/* Only establish in (flags) sharable vmas */
+	if (!vma || !(vma->vm_flags & VM_MAYSHARE))
+		return;
+
+	/* Should never get here with non-NULL vm_private_data */
+	if (vma->vm_private_data)
+		return;
+
+	vma_lock = kmalloc(sizeof(*vma_lock), GFP_KERNEL);
+	if (!vma_lock) {
+		/*
+		 * If we can not allocate structure, then vma can not
+		 * participate in pmd sharing.  This is only a possible
+		 * performance enhancement and memory saving issue.
+		 * However, the lock is also used to synchronize page
+		 * faults with truncation.  If the lock is not present,
+		 * unlikely races could leave pages in a file past i_size
+		 * until the file is removed.  Warn in the unlikely case of
+		 * allocation failure.
+		 */
+		pr_warn_once("HugeTLB: unable to allocate vma specific lock\n");
+		return;
+	}
+
+	kref_init(&vma_lock->refs);
+	init_rwsem(&vma_lock->rw_sema);
+	vma_lock->vma = vma;
+	vma->vm_private_data = vma_lock;
+}
+
 /* Helper that removes a struct file_region from the resv_map cache and returns
  * it for use.
  */
@@ -6557,7 +6703,8 @@ bool hugetlb_reserve_pages(struct inode
 	}
 
 	/*
-	 * vma specific semaphore used for pmd sharing synchronization
+	 * vma specific semaphore used for pmd sharing and fault/truncation
+	 * synchronization
 	 */
 	hugetlb_vma_lock_alloc(vma);
 
@@ -6813,149 +6960,6 @@ void adjust_range_if_pmd_sharing_possibl
 		*end = ALIGN(*end, PUD_SIZE);
 }
 
-static bool __vma_shareable_flags_pmd(struct vm_area_struct *vma)
-{
-	return vma->vm_flags & (VM_MAYSHARE | VM_SHARED) &&
-		vma->vm_private_data;
-}
-
-void hugetlb_vma_lock_read(struct vm_area_struct *vma)
-{
-	if (__vma_shareable_flags_pmd(vma)) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		down_read(&vma_lock->rw_sema);
-	}
-}
-
-void hugetlb_vma_unlock_read(struct vm_area_struct *vma)
-{
-	if (__vma_shareable_flags_pmd(vma)) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		up_read(&vma_lock->rw_sema);
-	}
-}
-
-void hugetlb_vma_lock_write(struct vm_area_struct *vma)
-{
-	if (__vma_shareable_flags_pmd(vma)) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		down_write(&vma_lock->rw_sema);
-	}
-}
-
-void hugetlb_vma_unlock_write(struct vm_area_struct *vma)
-{
-	if (__vma_shareable_flags_pmd(vma)) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		up_write(&vma_lock->rw_sema);
-	}
-}
-
-int hugetlb_vma_trylock_write(struct vm_area_struct *vma)
-{
-	struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-	if (!__vma_shareable_flags_pmd(vma))
-		return 1;
-
-	return down_write_trylock(&vma_lock->rw_sema);
-}
-
-void hugetlb_vma_assert_locked(struct vm_area_struct *vma)
-{
-	if (__vma_shareable_flags_pmd(vma)) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		lockdep_assert_held(&vma_lock->rw_sema);
-	}
-}
-
-void hugetlb_vma_lock_release(struct kref *kref)
-{
-	struct hugetlb_vma_lock *vma_lock = container_of(kref,
-			struct hugetlb_vma_lock, refs);
-
-	kfree(vma_lock);
-}
-
-static void __hugetlb_vma_unlock_write_put(struct hugetlb_vma_lock *vma_lock)
-{
-	struct vm_area_struct *vma = vma_lock->vma;
-
-	/*
-	 * vma_lock structure may or not be released as a result of put,
-	 * it certainly will no longer be attached to vma so clear pointer.
-	 * Semaphore synchronizes access to vma_lock->vma field.
-	 */
-	vma_lock->vma = NULL;
-	vma->vm_private_data = NULL;
-	up_write(&vma_lock->rw_sema);
-	kref_put(&vma_lock->refs, hugetlb_vma_lock_release);
-}
-
-static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma)
-{
-	if (__vma_shareable_flags_pmd(vma)) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		__hugetlb_vma_unlock_write_put(vma_lock);
-	}
-}
-
-static void hugetlb_vma_lock_free(struct vm_area_struct *vma)
-{
-	/*
-	 * Only present in sharable vmas.
-	 */
-	if (!vma || !__vma_shareable_flags_pmd(vma))
-		return;
-
-	if (vma->vm_private_data) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		down_write(&vma_lock->rw_sema);
-		__hugetlb_vma_unlock_write_put(vma_lock);
-	}
-}
-
-static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma)
-{
-	struct hugetlb_vma_lock *vma_lock;
-
-	/* Only establish in (flags) sharable vmas */
-	if (!vma || !(vma->vm_flags & VM_MAYSHARE))
-		return;
-
-	/* Should never get here with non-NULL vm_private_data */
-	if (vma->vm_private_data)
-		return;
-
-	vma_lock = kmalloc(sizeof(*vma_lock), GFP_KERNEL);
-	if (!vma_lock) {
-		/*
-		 * If we can not allocate structure, then vma can not
-		 * participate in pmd sharing.  This is only a possible
-		 * performance enhancement and memory saving issue.
-		 * However, the lock is also used to synchronize page
-		 * faults with truncation.  If the lock is not present,
-		 * unlikely races could leave pages in a file past i_size
-		 * until the file is removed.  Warn in the unlikely case of
-		 * allocation failure.
-		 */
-		pr_warn_once("HugeTLB: unable to allocate vma specific lock\n");
-		return;
-	}
-
-	kref_init(&vma_lock->refs);
-	init_rwsem(&vma_lock->rw_sema);
-	vma_lock->vma = vma;
-	vma->vm_private_data = vma_lock;
-}
-
 /*
  * Search for a shareable pmd page for hugetlb. In any case calls pmd_alloc()
  * and returns the corresponding pte. While this is not necessary for the
@@ -7044,47 +7048,6 @@ int huge_pmd_unshare(struct mm_struct *m
 
 #else /* !CONFIG_ARCH_WANT_HUGE_PMD_SHARE */
 
-void hugetlb_vma_lock_read(struct vm_area_struct *vma)
-{
-}
-
-void hugetlb_vma_unlock_read(struct vm_area_struct *vma)
-{
-}
-
-void hugetlb_vma_lock_write(struct vm_area_struct *vma)
-{
-}
-
-void hugetlb_vma_unlock_write(struct vm_area_struct *vma)
-{
-}
-
-int hugetlb_vma_trylock_write(struct vm_area_struct *vma)
-{
-	return 1;
-}
-
-void hugetlb_vma_assert_locked(struct vm_area_struct *vma)
-{
-}
-
-void hugetlb_vma_lock_release(struct kref *kref)
-{
-}
-
-static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma)
-{
-}
-
-static void hugetlb_vma_lock_free(struct vm_area_struct *vma)
-{
-}
-
-static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma)
-{
-}
-
 pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, pud_t *pud)
 {


