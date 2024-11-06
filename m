Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0367F1DF974;
	Wed,  6 Nov 2024 12:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896454; cv=none; b=Anw+VNVfw/QCDedHHECVoGUKSzgfKf9mEkaTEDgj/PWGrreN2StLqnjhO1DK2XEdj4lEK0dm+ZSMF8bzBzI58AA7enVlkFHsR7npJUJvUGs4BKsJ+PPtqlk2yy97baAXKpinH8Z7ZM+Ti4phHbNiqOPSsdurSXCY5q2ujAtBRyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896454; c=relaxed/simple;
	bh=2WZanJ3Ye/Xt+m9KHKOFhaz2+TLDvw99E6CKLDG7BCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Akt8Xk4329xmOlC4276rcP7AJXmXhDlNrha2ze8W87sOTeHUVnrTvjlZuqVl362Xs9oCi7MY6t0vGXBUXKKxSavJ8ZRlIhjMyJgcqMfiqU2jM/gJokpiYoTGH2u5MLPypkFkPtAwRnT2DgPZH9HbaXdjlzEZCf6+RgYuiM620nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XSBaIZ6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XSBaIZ6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50867C4CECD;
	Wed,  6 Nov 2024 12:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896453;
	bh=2WZanJ3Ye/Xt+m9KHKOFhaz2+TLDvw99E6CKLDG7BCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XSBaIZ6WE27EnBU+fmAmDPtZxMT+ZqqRxU2MMxCt+by//wLlZBGtcUx4jiasQ4GER
	 VaBkCNw3y1GXtS6JobZoqW6gPFxnLOKy16B7po8ynXW+RH1BuOh2BY+vPvP//36/f/
	 cU51RWcl7G9BLepmqB9XiTcwmTiNzpJKxFMnuwBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhao <yuzhao@google.com>,
	James Houghton <jthoughton@google.com>,
	David Stevens <stevensd@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Wei Xu <weixugc@google.com>,
	kernel test robot <lkp@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 208/245] mm: multi-gen LRU: use {ptep,pmdp}_clear_young_notify()
Date: Wed,  6 Nov 2024 13:04:21 +0100
Message-ID: <20241106120324.370005289@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

From: Yu Zhao <yuzhao@google.com>

[ Upstream commit 1d4832becdc2cdb2cffe2a6050c9d9fd8ff1c58c ]

When the MM_WALK capability is enabled, memory that is mostly accessed by
a VM appears younger than it really is, therefore this memory will be less
likely to be evicted.  Therefore, the presence of a running VM can
significantly increase swap-outs for non-VM memory, regressing the
performance for the rest of the system.

Fix this regression by always calling {ptep,pmdp}_clear_young_notify()
whenever we clear the young bits on PMDs/PTEs.

[jthoughton@google.com: fix link-time error]
Link: https://lkml.kernel.org/r/20241019012940.3656292-3-jthoughton@google.com
Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
Reported-by: David Stevens <stevensd@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: <stable@vger.kernel.org>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mmzone.h |  5 ++-
 mm/rmap.c              |  9 ++---
 mm/vmscan.c            | 88 +++++++++++++++++++++++-------------------
 3 files changed, 55 insertions(+), 47 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 5f44d24ed9ffe..fd04c8e942250 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -555,7 +555,7 @@ struct lru_gen_memcg {
 
 void lru_gen_init_pgdat(struct pglist_data *pgdat);
 void lru_gen_init_lruvec(struct lruvec *lruvec);
-void lru_gen_look_around(struct page_vma_mapped_walk *pvmw);
+bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw);
 
 void lru_gen_init_memcg(struct mem_cgroup *memcg);
 void lru_gen_exit_memcg(struct mem_cgroup *memcg);
@@ -574,8 +574,9 @@ static inline void lru_gen_init_lruvec(struct lruvec *lruvec)
 {
 }
 
-static inline void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
+static inline bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 {
+	return false;
 }
 
 static inline void lru_gen_init_memcg(struct mem_cgroup *memcg)
diff --git a/mm/rmap.c b/mm/rmap.c
index 2630bde38640c..3d89847f01dad 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -885,13 +885,10 @@ static bool folio_referenced_one(struct folio *folio,
 			return false;
 		}
 
-		if (pvmw.pte) {
-			if (lru_gen_enabled() &&
-			    pte_young(ptep_get(pvmw.pte))) {
-				lru_gen_look_around(&pvmw);
+		if (lru_gen_enabled() && pvmw.pte) {
+			if (lru_gen_look_around(&pvmw))
 				referenced++;
-			}
-
+		} else if (pvmw.pte) {
 			if (ptep_clear_flush_young_notify(vma, address,
 						pvmw.pte))
 				referenced++;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index a2ad17092abdf..f5bcd08527ae0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -56,6 +56,7 @@
 #include <linux/khugepaged.h>
 #include <linux/rculist_nulls.h>
 #include <linux/random.h>
+#include <linux/mmu_notifier.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -3276,7 +3277,8 @@ static bool get_next_vma(unsigned long mask, unsigned long size, struct mm_walk
 	return false;
 }
 
-static unsigned long get_pte_pfn(pte_t pte, struct vm_area_struct *vma, unsigned long addr)
+static unsigned long get_pte_pfn(pte_t pte, struct vm_area_struct *vma, unsigned long addr,
+				 struct pglist_data *pgdat)
 {
 	unsigned long pfn = pte_pfn(pte);
 
@@ -3288,13 +3290,20 @@ static unsigned long get_pte_pfn(pte_t pte, struct vm_area_struct *vma, unsigned
 	if (WARN_ON_ONCE(pte_devmap(pte) || pte_special(pte)))
 		return -1;
 
+	if (!pte_young(pte) && !mm_has_notifiers(vma->vm_mm))
+		return -1;
+
 	if (WARN_ON_ONCE(!pfn_valid(pfn)))
 		return -1;
 
+	if (pfn < pgdat->node_start_pfn || pfn >= pgdat_end_pfn(pgdat))
+		return -1;
+
 	return pfn;
 }
 
-static unsigned long get_pmd_pfn(pmd_t pmd, struct vm_area_struct *vma, unsigned long addr)
+static unsigned long get_pmd_pfn(pmd_t pmd, struct vm_area_struct *vma, unsigned long addr,
+				 struct pglist_data *pgdat)
 {
 	unsigned long pfn = pmd_pfn(pmd);
 
@@ -3306,9 +3315,15 @@ static unsigned long get_pmd_pfn(pmd_t pmd, struct vm_area_struct *vma, unsigned
 	if (WARN_ON_ONCE(pmd_devmap(pmd)))
 		return -1;
 
+	if (!pmd_young(pmd) && !mm_has_notifiers(vma->vm_mm))
+		return -1;
+
 	if (WARN_ON_ONCE(!pfn_valid(pfn)))
 		return -1;
 
+	if (pfn < pgdat->node_start_pfn || pfn >= pgdat_end_pfn(pgdat))
+		return -1;
+
 	return pfn;
 }
 
@@ -3317,10 +3332,6 @@ static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *memcg,
 {
 	struct folio *folio;
 
-	/* try to avoid unnecessary memory loads */
-	if (pfn < pgdat->node_start_pfn || pfn >= pgdat_end_pfn(pgdat))
-		return NULL;
-
 	folio = pfn_folio(pfn);
 	if (folio_nid(folio) != pgdat->node_id)
 		return NULL;
@@ -3376,20 +3387,16 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		total++;
 		walk->mm_stats[MM_LEAF_TOTAL]++;
 
-		pfn = get_pte_pfn(ptent, args->vma, addr);
+		pfn = get_pte_pfn(ptent, args->vma, addr, pgdat);
 		if (pfn == -1)
 			continue;
 
-		if (!pte_young(ptent)) {
-			continue;
-		}
-
 		folio = get_pfn_folio(pfn, memcg, pgdat, walk->can_swap);
 		if (!folio)
 			continue;
 
-		if (!ptep_test_and_clear_young(args->vma, addr, pte + i))
-			VM_WARN_ON_ONCE(true);
+		if (!ptep_clear_young_notify(args->vma, addr, pte + i))
+			continue;
 
 		young++;
 		walk->mm_stats[MM_LEAF_YOUNG]++;
@@ -3455,21 +3462,25 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 		/* don't round down the first address */
 		addr = i ? (*first & PMD_MASK) + i * PMD_SIZE : *first;
 
-		pfn = get_pmd_pfn(pmd[i], vma, addr);
-		if (pfn == -1)
+		if (!pmd_present(pmd[i]))
 			goto next;
 
 		if (!pmd_trans_huge(pmd[i])) {
-			if (!walk->force_scan && should_clear_pmd_young())
+			if (!walk->force_scan && should_clear_pmd_young() &&
+			    !mm_has_notifiers(args->mm))
 				pmdp_test_and_clear_young(vma, addr, pmd + i);
 			goto next;
 		}
 
+		pfn = get_pmd_pfn(pmd[i], vma, addr, pgdat);
+		if (pfn == -1)
+			goto next;
+
 		folio = get_pfn_folio(pfn, memcg, pgdat, walk->can_swap);
 		if (!folio)
 			goto next;
 
-		if (!pmdp_test_and_clear_young(vma, addr, pmd + i))
+		if (!pmdp_clear_young_notify(vma, addr, pmd + i))
 			goto next;
 
 		walk->mm_stats[MM_LEAF_YOUNG]++;
@@ -3527,24 +3538,18 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 		}
 
 		if (pmd_trans_huge(val)) {
-			unsigned long pfn = pmd_pfn(val);
 			struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
+			unsigned long pfn = get_pmd_pfn(val, vma, addr, pgdat);
 
 			walk->mm_stats[MM_LEAF_TOTAL]++;
 
-			if (!pmd_young(val)) {
-				continue;
-			}
-
-			/* try to avoid unnecessary memory loads */
-			if (pfn < pgdat->node_start_pfn || pfn >= pgdat_end_pfn(pgdat))
-				continue;
-
-			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+			if (pfn != -1)
+				walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
 			continue;
 		}
 
-		if (!walk->force_scan && should_clear_pmd_young()) {
+		if (!walk->force_scan && should_clear_pmd_young() &&
+		    !mm_has_notifiers(args->mm)) {
 			if (!pmd_young(val))
 				continue;
 
@@ -4018,13 +4023,13 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
  * the PTE table to the Bloom filter. This forms a feedback loop between the
  * eviction and the aging.
  */
-void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
+bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 {
 	int i;
 	unsigned long start;
 	unsigned long end;
 	struct lru_gen_mm_walk *walk;
-	int young = 0;
+	int young = 1;
 	pte_t *pte = pvmw->pte;
 	unsigned long addr = pvmw->address;
 	struct vm_area_struct *vma = pvmw->vma;
@@ -4040,12 +4045,15 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
 
+	if (!ptep_clear_young_notify(vma, addr, pte))
+		return false;
+
 	if (spin_is_contended(pvmw->ptl))
-		return;
+		return true;
 
 	/* exclude special VMAs containing anon pages from COW */
 	if (vma->vm_flags & VM_SPECIAL)
-		return;
+		return true;
 
 	/* avoid taking the LRU lock under the PTL when possible */
 	walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
@@ -4053,6 +4061,9 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	start = max(addr & PMD_MASK, vma->vm_start);
 	end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
 
+	if (end - start == PAGE_SIZE)
+		return true;
+
 	if (end - start > MIN_LRU_BATCH * PAGE_SIZE) {
 		if (addr - start < MIN_LRU_BATCH * PAGE_SIZE / 2)
 			end = start + MIN_LRU_BATCH * PAGE_SIZE;
@@ -4066,7 +4077,7 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 
 	/* folio_update_gen() requires stable folio_memcg() */
 	if (!mem_cgroup_trylock_pages(memcg))
-		return;
+		return true;
 
 	arch_enter_lazy_mmu_mode();
 
@@ -4076,19 +4087,16 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 		unsigned long pfn;
 		pte_t ptent = ptep_get(pte + i);
 
-		pfn = get_pte_pfn(ptent, vma, addr);
+		pfn = get_pte_pfn(ptent, vma, addr, pgdat);
 		if (pfn == -1)
 			continue;
 
-		if (!pte_young(ptent))
-			continue;
-
 		folio = get_pfn_folio(pfn, memcg, pgdat, can_swap);
 		if (!folio)
 			continue;
 
-		if (!ptep_test_and_clear_young(vma, addr, pte + i))
-			VM_WARN_ON_ONCE(true);
+		if (!ptep_clear_young_notify(vma, addr, pte + i))
+			continue;
 
 		young++;
 
@@ -4118,6 +4126,8 @@ void lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	/* feedback from rmap walkers to page table walkers */
 	if (mm_state && suitable_to_scan(i, young))
 		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
+
+	return true;
 }
 
 /******************************************************************************
-- 
2.43.0



