Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FAE1CAA4;
	Tue, 14 May 2024 11:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686174; cv=none; b=JNUr2lk1+MLUNkVezGTVyfK/I5u5sbyQPZJMlEa9SoozSNn6YPyb54HB+cjU6ifl1k2bbuxOLwQ8+/tRaVi7etA8oGRanCz28zNlTIQB+OFm+opK8QkkS+0aZCAO7FJ03is2QayM1P5erDcn2edGiyW/CqMAPRt4pemMTgEK8QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686174; c=relaxed/simple;
	bh=QwulqOZG6Tnr4IR6KPvH/It09CDuC2MJvbR3l9+pXdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fllFI6LqXJ7J1H9awml8oQBNyTZD3fYcv1G66X1NbDCX26vg0jkcI2M7MfqdR3cQG2kCPLOF+zsLIMd+ldfl5QJU85GhXkuUQxsq/XZY4WoJt4JM9A7wEO4KwkHlM9bAYm5hT84nhkR0r4PrxXLTxzKyG/EKwX3ee5wU73GAYIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amekGro5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amekGro5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661C4C2BD10;
	Tue, 14 May 2024 11:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686174;
	bh=QwulqOZG6Tnr4IR6KPvH/It09CDuC2MJvbR3l9+pXdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amekGro5Ym++IXyQS7sVFkj6a5SJ89VVnfRKWqq1iqUqKDZsoD+ZswFZVdQWWmqRT
	 FxZGJswnWO2awFfsExlpanIgy1SC5fK4LWD6C99pf6vscO6woAKZMB5hRVPoAT/y7s
	 Xc6TRQl0WEpy/hAPLP8E9cerIXVSLsjPKETQGvyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Mina Almasry <almasrymina@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/236] mm/hugetlb_cgroup: convert hugetlb_cgroup_uncharge_page() to folios
Date: Tue, 14 May 2024 12:16:18 +0200
Message-ID: <20240514101020.948073420@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sidhartha Kumar <sidhartha.kumar@oracle.com>

[ Upstream commit d4ab0316cc33aeedf6dcb1c2c25e097a25766132 ]

Continue to use a folio inside free_huge_page() by converting
hugetlb_cgroup_uncharge_page*() to folios.

Link: https://lkml.kernel.org/r/20221101223059.460937-8-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bui Quang Minh <minhquangbui99@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: b76b46902c2d ("mm/hugetlb: fix missing hugetlb_lock for resv uncharge")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hugetlb_cgroup.h | 16 ++++++++--------
 mm/hugetlb.c                   | 15 +++++++++------
 mm/hugetlb_cgroup.c            | 21 ++++++++++-----------
 3 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
index feb2edafc8b68..241bf4fe701ae 100644
--- a/include/linux/hugetlb_cgroup.h
+++ b/include/linux/hugetlb_cgroup.h
@@ -158,10 +158,10 @@ extern void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
 extern void hugetlb_cgroup_commit_charge_rsvd(int idx, unsigned long nr_pages,
 					      struct hugetlb_cgroup *h_cg,
 					      struct page *page);
-extern void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
-					 struct page *page);
-extern void hugetlb_cgroup_uncharge_page_rsvd(int idx, unsigned long nr_pages,
-					      struct page *page);
+extern void hugetlb_cgroup_uncharge_folio(int idx, unsigned long nr_pages,
+					 struct folio *folio);
+extern void hugetlb_cgroup_uncharge_folio_rsvd(int idx, unsigned long nr_pages,
+					      struct folio *folio);
 
 extern void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
 					   struct hugetlb_cgroup *h_cg);
@@ -254,14 +254,14 @@ hugetlb_cgroup_commit_charge_rsvd(int idx, unsigned long nr_pages,
 {
 }
 
-static inline void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
-						struct page *page)
+static inline void hugetlb_cgroup_uncharge_folio(int idx, unsigned long nr_pages,
+						struct folio *folio)
 {
 }
 
-static inline void hugetlb_cgroup_uncharge_page_rsvd(int idx,
+static inline void hugetlb_cgroup_uncharge_folio_rsvd(int idx,
 						     unsigned long nr_pages,
-						     struct page *page)
+						     struct folio *folio)
 {
 }
 static inline void hugetlb_cgroup_uncharge_cgroup(int idx,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6cdbb06902df1..e720b9ac28337 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1956,10 +1956,10 @@ void free_huge_page(struct page *page)
 
 	spin_lock_irqsave(&hugetlb_lock, flags);
 	folio_clear_hugetlb_migratable(folio);
-	hugetlb_cgroup_uncharge_page(hstate_index(h),
-				     pages_per_huge_page(h), page);
-	hugetlb_cgroup_uncharge_page_rsvd(hstate_index(h),
-					  pages_per_huge_page(h), page);
+	hugetlb_cgroup_uncharge_folio(hstate_index(h),
+				     pages_per_huge_page(h), folio);
+	hugetlb_cgroup_uncharge_folio_rsvd(hstate_index(h),
+					  pages_per_huge_page(h), folio);
 	if (restore_reserve)
 		h->resv_huge_pages++;
 
@@ -3082,6 +3082,7 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct page *page;
+	struct folio *folio;
 	long map_chg, map_commit;
 	long gbl_chg;
 	int ret, idx;
@@ -3145,6 +3146,7 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 	 * a reservation exists for the allocation.
 	 */
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve, gbl_chg);
+
 	if (!page) {
 		spin_unlock_irq(&hugetlb_lock);
 		page = alloc_buddy_huge_page_with_mpol(h, vma, addr);
@@ -3159,6 +3161,7 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 		set_page_refcounted(page);
 		/* Fall through */
 	}
+	folio = page_folio(page);
 	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
 	/* If allocation is not consuming a reservation, also store the
 	 * hugetlb_cgroup pointer on the page.
@@ -3188,8 +3191,8 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 		rsv_adjust = hugepage_subpool_put_pages(spool, 1);
 		hugetlb_acct_memory(h, -rsv_adjust);
 		if (deferred_reserve)
-			hugetlb_cgroup_uncharge_page_rsvd(hstate_index(h),
-					pages_per_huge_page(h), page);
+			hugetlb_cgroup_uncharge_folio_rsvd(hstate_index(h),
+					pages_per_huge_page(h), folio);
 	}
 	return page;
 
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 8b95c1560f9c3..32f4408eda240 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -346,11 +346,10 @@ void hugetlb_cgroup_commit_charge_rsvd(int idx, unsigned long nr_pages,
 /*
  * Should be called with hugetlb_lock held
  */
-static void __hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
-					   struct page *page, bool rsvd)
+static void __hugetlb_cgroup_uncharge_folio(int idx, unsigned long nr_pages,
+					   struct folio *folio, bool rsvd)
 {
 	struct hugetlb_cgroup *h_cg;
-	struct folio *folio = page_folio(page);
 
 	if (hugetlb_cgroup_disabled())
 		return;
@@ -368,27 +367,27 @@ static void __hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
 		css_put(&h_cg->css);
 	else {
 		unsigned long usage =
-			h_cg->nodeinfo[page_to_nid(page)]->usage[idx];
+			h_cg->nodeinfo[folio_nid(folio)]->usage[idx];
 		/*
 		 * This write is not atomic due to fetching usage and writing
 		 * to it, but that's fine because we call this with
 		 * hugetlb_lock held anyway.
 		 */
-		WRITE_ONCE(h_cg->nodeinfo[page_to_nid(page)]->usage[idx],
+		WRITE_ONCE(h_cg->nodeinfo[folio_nid(folio)]->usage[idx],
 			   usage - nr_pages);
 	}
 }
 
-void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
-				  struct page *page)
+void hugetlb_cgroup_uncharge_folio(int idx, unsigned long nr_pages,
+				  struct folio *folio)
 {
-	__hugetlb_cgroup_uncharge_page(idx, nr_pages, page, false);
+	__hugetlb_cgroup_uncharge_folio(idx, nr_pages, folio, false);
 }
 
-void hugetlb_cgroup_uncharge_page_rsvd(int idx, unsigned long nr_pages,
-				       struct page *page)
+void hugetlb_cgroup_uncharge_folio_rsvd(int idx, unsigned long nr_pages,
+				       struct folio *folio)
 {
-	__hugetlb_cgroup_uncharge_page(idx, nr_pages, page, true);
+	__hugetlb_cgroup_uncharge_folio(idx, nr_pages, folio, true);
 }
 
 static void __hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
-- 
2.43.0



