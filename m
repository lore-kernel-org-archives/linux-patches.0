Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF0836CE19;
	Sat, 17 Oct 2026 17:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257796; cv=none; b=M+w+2SxwUU9+t4MS/q97jFL+ibTbKyEeW6Qd51uKLHOT9+6vzN3QBeQ7Oa6bxyI2OKRa9GThEC0m1HUe/OwHkFC/HAZSt3yT5QJBB6K/LXXOvJLs8t75QiFvSdfGFfcTreUXQwiauqFQA53Q36WI2GHDFQhxYCP0HkYteup1EaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257796; c=relaxed/simple;
	bh=1DknuM1TaIzfLhK5hnJBx6Axk9kh3jXspyzEF7FVp+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SEX8p+7XeEfHUVFfN2vVSY97uX8MbxOWfFdG54TEOnhF7DpaRkWQYkP2tT2VkZUg7zR1CiOxblrBi7AsWBUry0MU+Lj0bZYBP57GxuB4X85ZzDM3ke6l5eiTKh/e1JHFRGayAiWufxtPwpdDH01wOewY/r7nQpL6ORwLpxAg9DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OWHYS7mp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OWHYS7mp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EA51F000C4;
	Sat, 17 Oct 2026 17:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257795;
	bh=eJntDyjudxb6t/1VdNSsNmCz2dKOToLktIcmLrKvtSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OWHYS7mphAz8m2GKGcRtzOpYdig/oDiwlSlqO1CioHbxRJ4IwrPsFuj7v5gyakfHZ
	 2foFspiGNF1HIwKrf94GBt7AbsYkMDNHSmKbOXKWfQQGojgyDE3IPM9QIPiT64r9aL
	 4TJk6tvos8k5wsoKBOn0KqF8pU47ZpX/K1WKjmMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Miko=C5=82aj=20Lenczewski?= <miko.lenczewski@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0674/1674] mm: clear uffd-wp PTE/PMD state on mremap()
Date: Sat, 17 Oct 2026 17:49:06 +0200
Message-ID: <20261017160448.408464855@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

[ Upstream commit 0cef0bb836e3cfe00f08f9606c72abd72fe78ca3 ]

When mremap()ing a memory region previously registered with userfaultfd as
write-protected but without UFFD_FEATURE_EVENT_REMAP, an inconsistency in
flag clearing leads to a mismatch between the vma flags (which have
uffd-wp cleared) and the pte/pmd flags (which do not have uffd-wp
cleared).  This mismatch causes a subsequent mprotect(PROT_WRITE) to
trigger a warning in page_table_check_pte_flags() due to setting the pte
to writable while uffd-wp is still set.

Fix this by always explicitly clearing the uffd-wp pte/pmd flags on any
such mremap() so that the values are consistent with the existing clearing
of VM_UFFD_WP.  Be careful to clear the logical flag regardless of its
physical form; a PTE bit, a swap PTE bit, or a PTE marker.  Cover PTE,
huge PMD and hugetlb paths.

Link: https://lkml.kernel.org/r/20250107144755.1871363-2-ryan.roberts@arm.com
Co-developed-by: Mikołaj Lenczewski <miko.lenczewski@arm.com>
Signed-off-by: Mikołaj Lenczewski <miko.lenczewski@arm.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Closes: https://lore.kernel.org/linux-mm/810b44a8-d2ae-4107-b665-5a42eae2d948@arm.com/
Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c              |  7 +++++++
 include/linux/userfaultfd_k.h |  7 +++++++
 mm/huge_memory.c              | 12 ++++++++++++
 mm/hugetlb.c                  | 14 +++++++++++++-
 mm/mremap.c                   | 32 +++++++++++++++++++++++++++++++-
 5 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 0ebdf3c2c9ee6..bd64d6b9cf899 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -138,6 +138,13 @@ bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma)
 	return ctx->features & UFFD_FEATURE_WP_UNPOPULATED;
 }
 
+bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
+{
+	struct userfaultfd_ctx *uffd_ctx = vma->vm_userfaultfd_ctx.ctx;
+
+	return uffd_ctx && (uffd_ctx->features & UFFD_FEATURE_EVENT_REMAP) == 0;
+}
+
 static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
 				     vm_flags_t flags)
 {
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 67ff2889374f1..c08e3b0da5e86 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -162,6 +162,8 @@ static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 
 bool vma_can_userfault(struct vm_area_struct *vma, unsigned long vm_flags);
 
+bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma);
+
 extern int dup_userfaultfd(struct vm_area_struct *, struct list_head *);
 extern void dup_userfaultfd_complete(struct list_head *);
 
@@ -280,6 +282,11 @@ static inline bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma)
 	return false;
 }
 
+static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
+{
+	return false;
+}
+
 #endif /* CONFIG_USERFAULTFD */
 
 static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3a49543ef62a6..1646eead7c3fe 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1772,6 +1772,16 @@ static pmd_t move_soft_dirty_pmd(pmd_t pmd)
 	return pmd;
 }
 
+static pmd_t clear_uffd_wp_pmd(pmd_t pmd)
+{
+	if (pmd_present(pmd))
+		pmd = pmd_clear_uffd_wp(pmd);
+	else if (is_swap_pmd(pmd))
+		pmd = pmd_swp_clear_uffd_wp(pmd);
+
+	return pmd;
+}
+
 bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 		  unsigned long new_addr, pmd_t *old_pmd, pmd_t *new_pmd)
 {
@@ -1810,6 +1820,8 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
 		}
 		pmd = move_soft_dirty_pmd(pmd);
+		if (vma_has_uffd_without_event_remap(vma))
+			pmd = clear_uffd_wp_pmd(pmd);
 		set_pmd_at(mm, new_addr, new_pmd, pmd);
 		if (force_flush)
 			flush_pmd_tlb_range(vma, old_addr, old_addr + PMD_SIZE);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index fbda160ffc073..cca79f0e78f70 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5225,6 +5225,7 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
 			  unsigned long new_addr, pte_t *src_pte, pte_t *dst_pte,
 			  unsigned long sz)
 {
+	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *src_ptl, *dst_ptl;
@@ -5241,7 +5242,18 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
 		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 
 	pte = huge_ptep_get_and_clear(mm, old_addr, src_pte, sz);
-	set_huge_pte_at(mm, new_addr, dst_pte, pte, sz);
+
+	if (need_clear_uffd_wp && pte_marker_uffd_wp(pte))
+		huge_pte_clear(mm, new_addr, dst_pte, sz);
+	else {
+		if (need_clear_uffd_wp) {
+			if (pte_present(pte))
+				pte = huge_pte_clear_uffd_wp(pte);
+			else if (is_swap_pte(pte))
+				pte = pte_swp_clear_uffd_wp(pte);
+		}
+		set_huge_pte_at(mm, new_addr, dst_pte, pte, sz);
+	}
 
 	if (src_ptl != dst_ptl)
 		spin_unlock(src_ptl);
diff --git a/mm/mremap.c b/mm/mremap.c
index ddf374d74e184..0739a31b54eed 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -138,6 +138,7 @@ static int move_ptes(struct vm_area_struct *vma, pmd_t *old_pmd,
 		struct vm_area_struct *new_vma, pmd_t *new_pmd,
 		unsigned long new_addr, bool need_rmap_locks)
 {
+	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *old_pte, *new_pte, pte;
 	spinlock_t *old_ptl, *new_ptl;
@@ -207,7 +208,18 @@ static int move_ptes(struct vm_area_struct *vma, pmd_t *old_pmd,
 			force_flush = true;
 		pte = move_pte(pte, new_vma->vm_page_prot, old_addr, new_addr);
 		pte = move_soft_dirty_pte(pte);
-		set_pte_at(mm, new_addr, new_pte, pte);
+
+		if (need_clear_uffd_wp && pte_marker_uffd_wp(pte))
+			pte_clear(mm, new_addr, new_pte);
+		else {
+			if (need_clear_uffd_wp) {
+				if (pte_present(pte))
+					pte = pte_clear_uffd_wp(pte);
+				else if (is_swap_pte(pte))
+					pte = pte_swp_clear_uffd_wp(pte);
+			}
+			set_pte_at(mm, new_addr, new_pte, pte);
+		}
 	}
 
 	arch_leave_lazy_mmu_mode();
@@ -269,6 +281,15 @@ static bool move_normal_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 	if (WARN_ON_ONCE(!pmd_none(*new_pmd)))
 		return false;
 
+	/* If this pmd belongs to a uffd vma with remap events disabled, we need
+	 * to ensure that the uffd-wp state is cleared from all pgtables. This
+	 * means recursing into lower page tables in move_page_tables(), and we
+	 * can reuse the existing code if we simply treat the entry as "not
+	 * moved".
+	 */
+	if (vma_has_uffd_without_event_remap(vma))
+		return false;
+
 	/*
 	 * We don't have to worry about the ordering of src and dst
 	 * ptlocks because exclusive mmap_lock prevents deadlock.
@@ -324,6 +345,15 @@ static bool move_normal_pud(struct vm_area_struct *vma, unsigned long old_addr,
 	if (WARN_ON_ONCE(!pud_none(*new_pud)))
 		return false;
 
+	/* If this pud belongs to a uffd vma with remap events disabled, we need
+	 * to ensure that the uffd-wp state is cleared from all pgtables. This
+	 * means recursing into lower page tables in move_page_tables(), and we
+	 * can reuse the existing code if we simply treat the entry as "not
+	 * moved".
+	 */
+	if (vma_has_uffd_without_event_remap(vma))
+		return false;
+
 	/*
 	 * We don't have to worry about the ordering of src and dst
 	 * ptlocks because exclusive mmap_lock prevents deadlock.
-- 
2.53.0



