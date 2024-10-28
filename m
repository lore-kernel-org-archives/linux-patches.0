Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D06C18DF7D;
	Mon, 28 Oct 2024 06:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098182; cv=none; b=pmEdBvGuRx//GcmNrYWVoqtMqE8uips+QZVGiAveRt4hpKKCjpLKz0p0cjSwKJCNmrhqWLhH86uthRKcCheH9a+beRsCG9aZqeUOGeCx2xfYM3FzmRNz/xAokqDQxz3b0sI+KC89UNHqzFVN2NQAECUjyIn+AkgWy8wmgs+nKUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098182; c=relaxed/simple;
	bh=3faHsc87kqeUsjTXy0WA2tBlj13u9DPBAHQjxcUK9jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mory9PeZdBKH1ErlZZg8j9iEeigzILgxc7cyobkjHC6NKnSCEfeS2YMAPFDmaXaljNWvRLG/TDkNhRjR/F/cWSPu+crhHwV7e6O3VozDKWdmiodgyvsQyr+whlbHHSVXngd7sI3PeS8bg5Qfz65Qj/FiADzi7W0c491Q1MV/myg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WG19GzSO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WG19GzSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D323C4CEC3;
	Mon, 28 Oct 2024 06:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098182;
	bh=3faHsc87kqeUsjTXy0WA2tBlj13u9DPBAHQjxcUK9jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WG19GzSOBQ+hKlVInrg+DkmWsjVJIApAESaKYe+mQAlDwpEbbddFfwvyeF/QPRQkw
	 CXL7Ga+8KMEyWNM2PQS7Vu7PyvcRP9EbJNXdsos4OuuPMj8VszE1nqgRf+3QznBIxP
	 W+pETBhG5PYrVHEkQlWRhiizhQm+WYXguoXGVzgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Barry Song <21cnbao@gmail.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <ioworker0@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 114/261] mm: shmem: move shmem_huge_global_enabled() into shmem_allowable_huge_orders()
Date: Mon, 28 Oct 2024 07:24:16 +0100
Message-ID: <20241028062314.886397975@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit 6beeab870e70b2d4f49baf6c6be9da1b61c169f8 ]

Move shmem_huge_global_enabled() into shmem_allowable_huge_orders(), so
that shmem_allowable_huge_orders() can also help to find the allowable
huge orders for tmpfs.  Moreover the shmem_huge_global_enabled() can
become static.  While we are at it, passing the vma instead of mm for
shmem_huge_global_enabled() makes code cleaner.

No functional changes.

Link: https://lkml.kernel.org/r/8e825146bb29ee1a1c7bd64d2968ff3e19be7815.1721626645.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 2b0f922323cc ("mm: don't install PMD mappings when THPs are disabled by the hw/process/vma")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/shmem_fs.h | 12 ++--------
 mm/huge_memory.c         | 12 +++-------
 mm/shmem.c               | 47 +++++++++++++++++++++++++---------------
 3 files changed, 35 insertions(+), 36 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 405ee8d3589a5..1564d7d3ca615 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -111,21 +111,13 @@ extern void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end);
 int shmem_unuse(unsigned int type);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-extern bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index, bool shmem_huge_force,
-				      struct mm_struct *mm, unsigned long vm_flags);
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
-				bool global_huge);
+				bool shmem_huge_force);
 #else
-static __always_inline bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
-						      bool shmem_huge_force, struct mm_struct *mm,
-						      unsigned long vm_flags)
-{
-	return false;
-}
 static inline unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
-				bool global_huge)
+				bool shmem_huge_force)
 {
 	return 0;
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 26843caa46962..d12ec1c8c7f07 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -159,16 +159,10 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	 * Must be done before hugepage flags check since shmem has its
 	 * own flags.
 	 */
-	if (!in_pf && shmem_file(vma->vm_file)) {
-		bool global_huge = shmem_huge_global_enabled(file_inode(vma->vm_file),
-							     vma->vm_pgoff, !enforce_sysfs,
-							     vma->vm_mm, vm_flags);
-
-		if (!vma_is_anon_shmem(vma))
-			return global_huge ? orders : 0;
+	if (!in_pf && shmem_file(vma->vm_file))
 		return shmem_allowable_huge_orders(file_inode(vma->vm_file),
-							vma, vma->vm_pgoff, global_huge);
-	}
+						   vma, vma->vm_pgoff,
+						   !enforce_sysfs);
 
 	if (!vma_is_anonymous(vma)) {
 		/*
diff --git a/mm/shmem.c b/mm/shmem.c
index d2ca6d4300bb8..a332323eea0b9 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -549,9 +549,10 @@ static bool shmem_confirm_swap(struct address_space *mapping,
 static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
 
 static bool __shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
-					bool shmem_huge_force, struct mm_struct *mm,
+					bool shmem_huge_force, struct vm_area_struct *vma,
 					unsigned long vm_flags)
 {
+	struct mm_struct *mm = vma ? vma->vm_mm : NULL;
 	loff_t i_size;
 
 	if (!S_ISREG(inode->i_mode))
@@ -581,15 +582,15 @@ static bool __shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
 	}
 }
 
-bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
-		   bool shmem_huge_force, struct mm_struct *mm,
+static bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
+		   bool shmem_huge_force, struct vm_area_struct *vma,
 		   unsigned long vm_flags)
 {
 	if (HPAGE_PMD_ORDER > MAX_PAGECACHE_ORDER)
 		return false;
 
 	return __shmem_huge_global_enabled(inode, index, shmem_huge_force,
-					   mm, vm_flags);
+					   vma, vm_flags);
 }
 
 #if defined(CONFIG_SYSFS)
@@ -772,6 +773,13 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 {
 	return 0;
 }
+
+static bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
+		bool shmem_huge_force, struct vm_area_struct *vma,
+		unsigned long vm_flags)
+{
+	return false;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 /*
@@ -1625,22 +1633,33 @@ static gfp_t limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
-				bool global_huge)
+				bool shmem_huge_force)
 {
 	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
 	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
-	unsigned long vm_flags = vma->vm_flags;
+	unsigned long vm_flags = vma ? vma->vm_flags : 0;
+	bool global_huge;
 	loff_t i_size;
 	int order;
 
-	if ((vm_flags & VM_NOHUGEPAGE) ||
-	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
+	if (vma && ((vm_flags & VM_NOHUGEPAGE) ||
+	    test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags)))
 		return 0;
 
 	/* If the hardware/firmware marked hugepage support disabled. */
 	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED))
 		return 0;
 
+	global_huge = shmem_huge_global_enabled(inode, index, shmem_huge_force,
+						vma, vm_flags);
+	if (!vma || !vma_is_anon_shmem(vma)) {
+		/*
+		 * For tmpfs, we now only support PMD sized THP if huge page
+		 * is enabled, otherwise fallback to order 0.
+		 */
+		return global_huge ? BIT(HPAGE_PMD_ORDER) : 0;
+	}
+
 	/*
 	 * Following the 'deny' semantics of the top level, force the huge
 	 * option off from all mounts.
@@ -2086,7 +2105,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 	struct mm_struct *fault_mm;
 	struct folio *folio;
 	int error;
-	bool alloced, huge;
+	bool alloced;
 	unsigned long orders = 0;
 
 	if (WARN_ON_ONCE(!shmem_mapping(inode->i_mapping)))
@@ -2159,14 +2178,8 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 		return 0;
 	}
 
-	huge = shmem_huge_global_enabled(inode, index, false, fault_mm,
-			     vma ? vma->vm_flags : 0);
-	/* Find hugepage orders that are allowed for anonymous shmem. */
-	if (vma && vma_is_anon_shmem(vma))
-		orders = shmem_allowable_huge_orders(inode, vma, index, huge);
-	else if (huge)
-		orders = BIT(HPAGE_PMD_ORDER);
-
+	/* Find hugepage orders that are allowed for anonymous shmem and tmpfs. */
+	orders = shmem_allowable_huge_orders(inode, vma, index, false);
 	if (orders > 0) {
 		gfp_t huge_gfp;
 
-- 
2.43.0



