Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046863;
	b=TOztVQbXBL1EirGlpbx9WknQsFJ8StiLH6KV2L+qw/W3zWmgK8I4Fng0ly/0UhQ+C+w3
	 l5lVXXUucJCpy2MvRRGmzvZddGoMn/FLtGfk+rhXQUzKGZuYWPOwuQNfZ1sJssM+rxPlO
	 1kx2+YsyQRFhIl9IsM5YbJ6zmqt1mWkT2bfuKC5UNc+F0kCZFJl4yyKAVvOj5Qb9LfQxV
	 M52Fa9NfVej5jNz5s63QFGRxVUYi09hb+klye7SdsXPyvyghOYgmeDN5a8cybYcjMmEoc
	 YgW3BfWbit+JxN/tea9zIBXnj5Bk1cZZTqcxlYU+8cVyy7eMt1YD9Fkv/izKmhDxeVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S/O0pub4GexlabREXC0dnxBLP0FWpW8TuKyYsc7hNnM=;
	b=t8KyJTrU6A7p5NQJpP8NpipU2V8I5tt9IOuc8CTTvv/ZLoqBoGfEf88y8cj3UlxCkvKF
	 6maSDZIo/d5Q1fuiU2skz//sSvggFlSMhL6gABNi/T3IfGUctW5/52QXbyTLNrAG20e0f
	 Ee9juBgcVgD8ZHe1meO7ItiYEnfvtClwDIEFI6tXhZkzkJ1V5AZTbq7mVmawkNxwueKyw
	 +EJR90vdBx9arFSKwh00Wi93C0qXbBH50Nnd0c0zc8PqTLjIQQZlQxz6Vi++8dFXqNOfB
	 iGcAXzLlVRZnQiGwqZiBDzZxTy/VlxjJyhWW0X6oBXdTm5gzHk9jKI5aiTHhXC2HPhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fF65UTIU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6767B606A32A;
	Thu, 19 Nov 2026 00:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fF65UTIU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00B31F000C5;
	Thu, 19 Nov 2026 00:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046863;
	bh=S/O0pub4GexlabREXC0dnxBLP0FWpW8TuKyYsc7hNnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fF65UTIUGy6p+zo3LRtmoJErmkXuck4ZnlfWlIwhwhMx4EJ1F7nAdobuhb+L+wV0P
	 Ff3uGk0PLrdVsh1qNlQ2f155FQghP+V+HQ2HV2PRmvopaj+x0a6vjapX8KSZrZ7wsd
	 T6yUI9xcrYhC26rBDygepSTjoFx08CK+Eb4tgG3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Mina Almasry <almasrymina@google.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1434/2857] mm/hugetlb_cgroup: convert set_hugetlb_cgroup*() to folios
Date: Wed, 18 Nov 2026 15:41:08 +0100
Message-ID: <20261118150252.944732763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sidhartha Kumar <sidhartha.kumar@oracle.com>

[ Upstream commit de656ed376c4cb47c5713fba52f8bbfbea44f387 ]

Allows __prep_new_huge_page() to operate on a folio by converting
set_hugetlb_cgroup*() to take in a folio.

Link: https://lkml.kernel.org/r/20221101223059.460937-4-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bui Quang Minh <minhquangbui99@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 23fac055c211 ("mm/hugetlb_cgroup: move per-node usage on cgroup reparenting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hugetlb_cgroup.h | 12 ++++++------
 mm/hugetlb.c                   | 33 +++++++++++++++++++--------------
 mm/hugetlb_cgroup.c            | 11 ++++++-----
 3 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
index 241bf4fe701ae..f0d9f295413be 100644
--- a/include/linux/hugetlb_cgroup.h
+++ b/include/linux/hugetlb_cgroup.h
@@ -112,16 +112,16 @@ static inline void __set_hugetlb_cgroup(struct folio *folio,
 				 (unsigned long)h_cg);
 }
 
-static inline void set_hugetlb_cgroup(struct page *page,
+static inline void set_hugetlb_cgroup(struct folio *folio,
 				     struct hugetlb_cgroup *h_cg)
 {
-	__set_hugetlb_cgroup(page_folio(page), h_cg, false);
+	__set_hugetlb_cgroup(folio, h_cg, false);
 }
 
-static inline void set_hugetlb_cgroup_rsvd(struct page *page,
+static inline void set_hugetlb_cgroup_rsvd(struct folio *folio,
 					  struct hugetlb_cgroup *h_cg)
 {
-	__set_hugetlb_cgroup(page_folio(page), h_cg, true);
+	__set_hugetlb_cgroup(folio, h_cg, true);
 }
 
 static inline bool hugetlb_cgroup_disabled(void)
@@ -199,12 +199,12 @@ hugetlb_cgroup_from_folio_rsvd(struct folio *folio)
 	return NULL;
 }
 
-static inline void set_hugetlb_cgroup(struct page *page,
+static inline void set_hugetlb_cgroup(struct folio *folio,
 				     struct hugetlb_cgroup *h_cg)
 {
 }
 
-static inline void set_hugetlb_cgroup_rsvd(struct page *page,
+static inline void set_hugetlb_cgroup_rsvd(struct folio *folio,
 					  struct hugetlb_cgroup *h_cg)
 {
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 368e6286562f8..28c6a6c4120cc 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1986,19 +1986,21 @@ static void __prep_account_new_huge_page(struct hstate *h, int nid)
 	h->nr_huge_pages_node[nid]++;
 }
 
-static void __prep_new_huge_page(struct hstate *h, struct page *page)
+static void __prep_new_hugetlb_folio(struct hstate *h, struct folio *folio)
 {
-	hugetlb_vmemmap_optimize(h, page);
-	INIT_LIST_HEAD(&page->lru);
-	set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
-	hugetlb_set_page_subpool(page, NULL);
-	set_hugetlb_cgroup(page, NULL);
-	set_hugetlb_cgroup_rsvd(page, NULL);
+	hugetlb_vmemmap_optimize(h, &folio->page);
+	INIT_LIST_HEAD(&folio->lru);
+	folio->_folio_dtor = HUGETLB_PAGE_DTOR;
+	hugetlb_set_folio_subpool(folio, NULL);
+	set_hugetlb_cgroup(folio, NULL);
+	set_hugetlb_cgroup_rsvd(folio, NULL);
 }
 
 static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
 {
-	__prep_new_huge_page(h, page);
+	struct folio *folio = page_folio(page);
+
+	__prep_new_hugetlb_folio(h, folio);
 	spin_lock_irq(&hugetlb_lock);
 	__prep_account_new_huge_page(h, nid);
 	spin_unlock_irq(&hugetlb_lock);
@@ -2970,8 +2972,10 @@ static int alloc_and_dissolve_huge_page(struct hstate *h, struct page *old_page,
 					struct list_head *list)
 {
 	gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
-	int nid = page_to_nid(old_page);
+	struct folio *old_folio = page_folio(old_page);
+	int nid = folio_nid(old_folio);
 	struct page *new_page;
+	struct folio *new_folio;
 	int ret = 0;
 
 	/*
@@ -2984,16 +2988,17 @@ static int alloc_and_dissolve_huge_page(struct hstate *h, struct page *old_page,
 	new_page = alloc_buddy_huge_page(h, gfp_mask, nid, NULL, NULL);
 	if (!new_page)
 		return -ENOMEM;
-	__prep_new_huge_page(h, new_page);
+	new_folio = page_folio(new_page);
+	__prep_new_hugetlb_folio(h, new_folio);
 
 retry:
 	spin_lock_irq(&hugetlb_lock);
-	if (!PageHuge(old_page)) {
+	if (!folio_test_hugetlb(old_folio)) {
 		/*
 		 * Freed from under us. Drop new_page too.
 		 */
 		goto free_new;
-	} else if (page_count(old_page)) {
+	} else if (folio_ref_count(old_folio)) {
 		/*
 		 * Someone has grabbed the page, try to isolate it here.
 		 * Fail with -EBUSY if not possible.
@@ -3002,7 +3007,7 @@ static int alloc_and_dissolve_huge_page(struct hstate *h, struct page *old_page,
 		ret = folio_isolate_hugetlb(old_page, list);
 		spin_lock_irq(&hugetlb_lock);
 		goto free_new;
-	} else if (!HPageFreed(old_page)) {
+	} else if (!folio_test_hugetlb_freed(old_folio)) {
 		/*
 		 * Page's refcount is 0 but it has not been enqueued in the
 		 * freelist yet. Race window is small, so we can succeed here if
@@ -3040,7 +3045,7 @@ static int alloc_and_dissolve_huge_page(struct hstate *h, struct page *old_page,
 free_new:
 	spin_unlock_irq(&hugetlb_lock);
 	/* Page has a zero ref count, but needs a ref to be freed */
-	set_page_refcounted(new_page);
+	folio_ref_unfreeze(new_folio, 1);
 	update_and_free_page(h, new_page, false);
 
 	return ret;
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index 32f4408eda240..001828b062d43 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -212,7 +212,7 @@ static void hugetlb_cgroup_move_parent(int idx, struct hugetlb_cgroup *h_cg,
 	/* Take the pages off the local counter */
 	page_counter_cancel(counter, nr_pages);
 
-	set_hugetlb_cgroup(page, parent);
+	set_hugetlb_cgroup(folio, parent);
 out:
 	return;
 }
@@ -890,6 +890,7 @@ void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
 	struct hugetlb_cgroup *h_cg_rsvd;
 	struct hstate *h = page_hstate(oldhpage);
 	struct folio *old_folio = page_folio(oldhpage);
+	struct folio *new_folio = page_folio(newhpage);
 
 	if (hugetlb_cgroup_disabled())
 		return;
@@ -897,12 +898,12 @@ void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
 	spin_lock_irq(&hugetlb_lock);
 	h_cg = hugetlb_cgroup_from_folio(old_folio);
 	h_cg_rsvd = hugetlb_cgroup_from_folio_rsvd(old_folio);
-	set_hugetlb_cgroup(oldhpage, NULL);
-	set_hugetlb_cgroup_rsvd(oldhpage, NULL);
+	set_hugetlb_cgroup(old_folio, NULL);
+	set_hugetlb_cgroup_rsvd(old_folio, NULL);
 
 	/* move the h_cg details to new cgroup */
-	set_hugetlb_cgroup(newhpage, h_cg);
-	set_hugetlb_cgroup_rsvd(newhpage, h_cg_rsvd);
+	set_hugetlb_cgroup(new_folio, h_cg);
+	set_hugetlb_cgroup_rsvd(new_folio, h_cg_rsvd);
 	list_move(&newhpage->lru, &h->hugepage_activelist);
 	spin_unlock_irq(&hugetlb_lock);
 	return;
-- 
2.53.0



