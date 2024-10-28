Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3FF2C697;
	Mon, 28 Oct 2024 06:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097671; cv=none; b=p9xe8rcELa98+CVaCNWwRrNs+Aco0/4NVwIKmf0m9gNb22jmq0/q9XO8xulx/rlE0vCwxLkFTwmmhH07B8iTgVr9JIIH8bM6yduDFCiMW/Rh7lF8eJjYB9QOxdiCJEzirSnkkN+HiwZue+bIaXDu5Mk8CS1pv63qE1gd8N0ISnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097671; c=relaxed/simple;
	bh=a/Nuco4UeBNLm6kVnFxAJfBiGTTxVaQG1Oh+F6cy/vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IH9PutMMgh+KOMbXPekPP0okaa2qdkVrLR6iAyxWstAIPZ1ZpKGW8fLuW7gWAWSQvrSjZIrbqipmS4zBaPvfFvlwwPmPPSVUkftV//6N+rbwGr1V2AUgChhSKXT/yx/l+pkbGCaqx2kaDxioaKE7P13aB1dKWz99vxZjGDDq0fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrZQ8o3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrZQ8o3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1A8C4CEC3;
	Mon, 28 Oct 2024 06:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097671;
	bh=a/Nuco4UeBNLm6kVnFxAJfBiGTTxVaQG1Oh+F6cy/vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrZQ8o3IGJg8IHvBawjUcwOIuGdGrEVMKLPa0gdVS+Cc6fa1Fsqs3ML7Jl1FbLYMq
	 5Qi/2zTBCslkVAzXtsZ3H4LRoudiqQFOusM2731U3NpsErjH7iW3/xQCzEtthNxkHN
	 c3Z/B6UfyeBR3nRc/QHZdrOF15X/zWVUtoVXWHWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/208] khugepaged: convert alloc_charge_hpage to alloc_charge_folio
Date: Mon, 28 Oct 2024 07:24:35 +0100
Message-ID: <20241028062308.997780887@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit d5ab50b9412c0bba750eef5a34fd2937de1aee55 ]

Both callers want to deal with a folio, so return a folio from this
function.

Link: https://lkml.kernel.org/r/20240403171838.1445826-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 37f0b47c5143 ("mm: khugepaged: fix the arguments order in khugepaged_collapse_file trace point")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/khugepaged.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d0fcfa47085b4..b197323450b5a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1041,7 +1041,7 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 	return result;
 }
 
-static int alloc_charge_hpage(struct page **hpage, struct mm_struct *mm,
+static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
 			      struct collapse_control *cc)
 {
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
@@ -1051,7 +1051,7 @@ static int alloc_charge_hpage(struct page **hpage, struct mm_struct *mm,
 
 	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
 	if (!folio) {
-		*hpage = NULL;
+		*foliop = NULL;
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		return SCAN_ALLOC_HUGE_PAGE_FAIL;
 	}
@@ -1059,13 +1059,13 @@ static int alloc_charge_hpage(struct page **hpage, struct mm_struct *mm,
 	count_vm_event(THP_COLLAPSE_ALLOC);
 	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
 		folio_put(folio);
-		*hpage = NULL;
+		*foliop = NULL;
 		return SCAN_CGROUP_CHARGE_FAIL;
 	}
 
 	count_memcg_folio_events(folio, THP_COLLAPSE_ALLOC, 1);
 
-	*hpage = folio_page(folio, 0);
+	*foliop = folio;
 	return SCAN_SUCCEED;
 }
 
@@ -1094,7 +1094,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	 */
 	mmap_read_unlock(mm);
 
-	result = alloc_charge_hpage(&hpage, mm, cc);
+	result = alloc_charge_folio(&folio, mm, cc);
+	hpage = &folio->page;
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
 
@@ -1197,7 +1198,6 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	if (unlikely(result != SCAN_SUCCEED))
 		goto out_up_write;
 
-	folio = page_folio(hpage);
 	/*
 	 * The smp_wmb() inside __folio_mark_uptodate() ensures the
 	 * copy_huge_page writes become visible before the set_pmd_at()
@@ -1786,7 +1786,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	struct page *hpage;
 	struct page *page;
 	struct page *tmp;
-	struct folio *folio;
+	struct folio *folio, *new_folio;
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
@@ -1797,7 +1797,8 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
 
-	result = alloc_charge_hpage(&hpage, mm, cc);
+	result = alloc_charge_folio(&new_folio, mm, cc);
+	hpage = &new_folio->page;
 	if (result != SCAN_SUCCEED)
 		goto out;
 
-- 
2.43.0



