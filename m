Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBCD1F470A;
	Tue, 21 Jan 2025 18:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482580; cv=none; b=pBR/kOfUXoC0u12nW6lngR8BLqY0xigGHXvma6u370OzBLU1rjc3Nba9qN7em8oUUheGG5bCSgphXc1nsYq/B3oLW6KIY3ol2TktvldEMWkxyhfWS09l1rhcfCT3AASG4jbb7gUsCcrj0hnfk5x1wCQqmyv6HAR0Tt/e3GQpnig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482580; c=relaxed/simple;
	bh=dsqaxQBPwY/p8ZBWWkqqZz/xYxcGnknOOsIt6Xhs6Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pXA9DOzw/pT9cYAwIMop9/eaywE9MeTk99utoSK86CFalMwfXbV0lKBj4CVjptqkNHHOKaD2lyCcK8nZmF2mbrARFfexgOGSSfJDNbeigaadhM0NLoXA8IK4AHxpotWNCnmU54DtoHm5hNYUk4DQJmsShek1h+G1Vr9+p6aLmAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCh3UKNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCh3UKNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1AAC4CEDF;
	Tue, 21 Jan 2025 18:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482580;
	bh=dsqaxQBPwY/p8ZBWWkqqZz/xYxcGnknOOsIt6Xhs6Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCh3UKNWmQ6F0q/dxaNLiwNEEGTdKq9lRjJfssaAMzWrGxWHraAtMoz/AvQgxwPnl
	 DKHqN6A3Daa2NzB/fdI/5/vOjDPki5fYC/0QpC8ESNCBwwUzm3VWk6RRRlOMc3FMw0
	 F2a7wgTANCpALSERDPfCQA+vhXtgBsUvWrX2NPP8=
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 100/122] mm: clear uffd-wp PTE/PMD state on mremap()
Date: Tue, 21 Jan 2025 18:52:28 +0100
Message-ID: <20250121174536.888704597@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

commit 0cef0bb836e3cfe00f08f9606c72abd72fe78ca3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/userfaultfd_k.h |   12 ++++++++++++
 mm/huge_memory.c              |   12 ++++++++++++
 mm/hugetlb.c                  |   14 +++++++++++++-
 mm/mremap.c                   |   32 +++++++++++++++++++++++++++++++-
 4 files changed, 68 insertions(+), 2 deletions(-)

--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -247,6 +247,13 @@ static inline bool vma_can_userfault(str
 	    vma_is_shmem(vma);
 }
 
+static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
+{
+	struct userfaultfd_ctx *uffd_ctx = vma->vm_userfaultfd_ctx.ctx;
+
+	return uffd_ctx && (uffd_ctx->features & UFFD_FEATURE_EVENT_REMAP) == 0;
+}
+
 extern int dup_userfaultfd(struct vm_area_struct *, struct list_head *);
 extern void dup_userfaultfd_complete(struct list_head *);
 void dup_userfaultfd_fail(struct list_head *);
@@ -401,6 +408,11 @@ static inline bool userfaultfd_wp_async(
 {
 	return false;
 }
+
+static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
+{
+	return false;
+}
 
 #endif /* CONFIG_USERFAULTFD */
 
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2132,6 +2132,16 @@ static pmd_t move_soft_dirty_pmd(pmd_t p
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
@@ -2170,6 +2180,8 @@ bool move_huge_pmd(struct vm_area_struct
 			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
 		}
 		pmd = move_soft_dirty_pmd(pmd);
+		if (vma_has_uffd_without_event_remap(vma))
+			pmd = clear_uffd_wp_pmd(pmd);
 		set_pmd_at(mm, new_addr, new_pmd, pmd);
 		if (force_flush)
 			flush_pmd_tlb_range(vma, old_addr, old_addr + PMD_SIZE);
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5395,6 +5395,7 @@ static void move_huge_pte(struct vm_area
 			  unsigned long new_addr, pte_t *src_pte, pte_t *dst_pte,
 			  unsigned long sz)
 {
+	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *src_ptl, *dst_ptl;
@@ -5411,7 +5412,18 @@ static void move_huge_pte(struct vm_area
 		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 
 	pte = huge_ptep_get_and_clear(mm, old_addr, src_pte);
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
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -138,6 +138,7 @@ static int move_ptes(struct vm_area_stru
 		struct vm_area_struct *new_vma, pmd_t *new_pmd,
 		unsigned long new_addr, bool need_rmap_locks)
 {
+	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *old_pte, *new_pte, pte;
 	spinlock_t *old_ptl, *new_ptl;
@@ -207,7 +208,18 @@ static int move_ptes(struct vm_area_stru
 			force_flush = true;
 		pte = move_pte(pte, old_addr, new_addr);
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
@@ -269,6 +281,15 @@ static bool move_normal_pmd(struct vm_ar
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
@@ -324,6 +345,15 @@ static bool move_normal_pud(struct vm_ar
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


