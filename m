Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D2C18871E;
	Fri, 15 Nov 2024 06:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653505; cv=none; b=Lp75W3x4XWFy9Pob+L3JYpOw5fiIry+toqh5AVkinjXLOOMFGVsODwKoevIXE/ykQG0+FPDrR8zy0vP6qdyEQQMqvdM2Ih8GVqE2C0M5EKqbH8tFYODc+lIvTQ0+bdcotCU9z5JrEpTERH+eyL9ifffPSsig/kdDYo+fKeXYa14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653505; c=relaxed/simple;
	bh=PjbOU4Gb+yzzbdTFGBPyvHMGUvgNC4Cm62srRpbK8Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYo7iFYt7K89FN0EkvmP4yP5YBm25wzGn28ujf+ZiiMTlAcn7sEIFqGRAxgL1aLwzwZ61IvM6Icv+/MN4BYKcrDIG6dKDjyRHPs3aGXvRMn7z7Ob9ylX4KBP2Nyf2Q4oKqLTOZZpaVqDv+tVitGEIG4bMD6lU72ayOTqe6jJP50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uU1+unNQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uU1+unNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33321C4CECF;
	Fri, 15 Nov 2024 06:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653504;
	bh=PjbOU4Gb+yzzbdTFGBPyvHMGUvgNC4Cm62srRpbK8Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uU1+unNQ+6bIO9naekgJOqoWwXCt8JozHbkbPydNAgbg30CL0ex0X4n+6eL5D3c7G
	 IaKNerBkyfd61Ujtys1/rFY9rL9bdOxzrk5jW3uQRilT15E52Qo10L4H8evEiHQE6B
	 upZF3sfKDHdbSoNqXKTKkQCOLI2Lrv/TiTTR2v5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	Andi Kleen <ak@linux.intel.com>,
	Christoph Lameter <cl@linux.com>,
	David Hildenbrand <david@redhat.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Mel Gorman <mgorman@techsingularity.net>,
	Michal Hocko <mhocko@suse.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun heo <tj@kernel.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Yang Shi <shy828301@gmail.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 42/48] mm: add page_rmappable_folio() wrapper
Date: Fri, 15 Nov 2024 07:38:31 +0100
Message-ID: <20241115063724.480624722@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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

From: Hugh Dickins <hughd@google.com>

commit 23e4883248f0472d806c8b3422ba6257e67bf1a5 upstream.

folio_prep_large_rmappable() is being used repeatedly along with a
conversion from page to folio, a check non-NULL, a check order > 1: wrap
it all up into struct folio *page_rmappable_folio(struct page *).

Link: https://lkml.kernel.org/r/8d92c6cf-eebe-748-e29c-c8ab224c741@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun heo <tj@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/internal.h   |    9 +++++++++
 mm/mempolicy.c  |   17 +++--------------
 mm/page_alloc.c |    8 ++------
 3 files changed, 14 insertions(+), 20 deletions(-)

--- a/mm/internal.h
+++ b/mm/internal.h
@@ -415,6 +415,15 @@ static inline void folio_set_order(struc
 
 void folio_undo_large_rmappable(struct folio *folio);
 
+static inline struct folio *page_rmappable_folio(struct page *page)
+{
+	struct folio *folio = (struct folio *)page;
+
+	if (folio && folio_order(folio) > 1)
+		folio_prep_large_rmappable(folio);
+	return folio;
+}
+
 static inline void prep_compound_head(struct page *page, unsigned int order)
 {
 	struct folio *folio = (struct folio *)page;
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2200,10 +2200,7 @@ struct folio *vma_alloc_folio(gfp_t gfp,
 		mpol_cond_put(pol);
 		gfp |= __GFP_COMP;
 		page = alloc_page_interleave(gfp, order, nid);
-		folio = (struct folio *)page;
-		if (folio && order > 1)
-			folio_prep_large_rmappable(folio);
-		goto out;
+		return page_rmappable_folio(page);
 	}
 
 	if (pol->mode == MPOL_PREFERRED_MANY) {
@@ -2213,10 +2210,7 @@ struct folio *vma_alloc_folio(gfp_t gfp,
 		gfp |= __GFP_COMP;
 		page = alloc_pages_preferred_many(gfp, order, node, pol);
 		mpol_cond_put(pol);
-		folio = (struct folio *)page;
-		if (folio && order > 1)
-			folio_prep_large_rmappable(folio);
-		goto out;
+		return page_rmappable_folio(page);
 	}
 
 	if (unlikely(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && hugepage)) {
@@ -2310,12 +2304,7 @@ EXPORT_SYMBOL(alloc_pages);
 
 struct folio *folio_alloc(gfp_t gfp, unsigned order)
 {
-	struct page *page = alloc_pages(gfp | __GFP_COMP, order);
-	struct folio *folio = (struct folio *)page;
-
-	if (folio && order > 1)
-		folio_prep_large_rmappable(folio);
-	return folio;
+	return page_rmappable_folio(alloc_pages(gfp | __GFP_COMP, order));
 }
 EXPORT_SYMBOL(folio_alloc);
 
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4464,12 +4464,8 @@ struct folio *__folio_alloc(gfp_t gfp, u
 		nodemask_t *nodemask)
 {
 	struct page *page = __alloc_pages(gfp | __GFP_COMP, order,
-			preferred_nid, nodemask);
-	struct folio *folio = (struct folio *)page;
-
-	if (folio && order > 1)
-		folio_prep_large_rmappable(folio);
-	return folio;
+					preferred_nid, nodemask);
+	return page_rmappable_folio(page);
 }
 EXPORT_SYMBOL(__folio_alloc);
 


