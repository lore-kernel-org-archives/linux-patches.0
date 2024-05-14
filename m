Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAAB1CAA4;
	Tue, 14 May 2024 11:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686159; cv=none; b=q6MaXAkuT7/JaGbljuc9ilIX4I9la8SI2HizRI3tnbU17aMOdXt9y9HlqNG+xsQR1zJHPGvU2uVLj7u4XVLm9J5bVC4mg4cS15LLEv4MPviI+rid1xew6UrDe5oAHNLzY8j0KQXTN8HgNM+uLCVW9Ry//X0hNnQAecxxKUVh0RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686159; c=relaxed/simple;
	bh=jOLYMbet/ItuegWvoqK/jk89YP7hD/Pk4e0nuaqfEGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2GadB0PWEGYciInJLMBsqUP4Q/TP5A4vlB37+vDzpMnOiarVZcgnuNh9Asjs0efFHwMoEY3SttCoYsUDisSAMRi1/f1kEn3RQy+Nxp1tO6OrUaqhvgCkJiqBL2JwHF1uFAPEQUpX/tt8Sjsw3i6pEHqVT5gijeluyQBTGE+FkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLp6wzT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLp6wzT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF09C2BD10;
	Tue, 14 May 2024 11:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686159;
	bh=jOLYMbet/ItuegWvoqK/jk89YP7hD/Pk4e0nuaqfEGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLp6wzT1CZJRvWDBGvyY42pjOpANGdlAm2Y/bvKMqkzHdTzGsAZ7BVlX/NXr8lvwc
	 QIpF9rvK9x5uoiQheowsT1mDjPSBlfxBcqglthJJnADORA0TQ1Be+l9euq3MnoCyaQ
	 ryXxspaSZfiI9J7ODy5KL0wBlqU+PYCKpz8AvWMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Mina Almasry <almasrymina@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/236] mm/hugetlb_cgroup: convert hugetlb_cgroup_from_page() to folios
Date: Tue, 14 May 2024 12:16:16 +0200
Message-ID: <20240514101020.872665033@linuxfoundation.org>
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

[ Upstream commit f074732d599e19a2a5b12e54743ad5eaccbe6550 ]

Introduce folios in __remove_hugetlb_page() by converting
hugetlb_cgroup_from_page() to use folios.

Also gets rid of unsed hugetlb_cgroup_from_page_resv() function.

Link: https://lkml.kernel.org/r/20221101223059.460937-3-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Bui Quang Minh <minhquangbui99@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: b76b46902c2d ("mm/hugetlb: fix missing hugetlb_lock for resv uncharge")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hugetlb_cgroup.h | 39 +++++++++++++++++-----------------
 mm/hugetlb.c                   |  5 +++--
 mm/hugetlb_cgroup.c            | 13 +++++++-----
 3 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
index 7576e9ed8afe7..feb2edafc8b68 100644
--- a/include/linux/hugetlb_cgroup.h
+++ b/include/linux/hugetlb_cgroup.h
@@ -67,27 +67,34 @@ struct hugetlb_cgroup {
 };
 
 static inline struct hugetlb_cgroup *
-__hugetlb_cgroup_from_page(struct page *page, bool rsvd)
+__hugetlb_cgroup_from_folio(struct folio *folio, bool rsvd)
 {
-	VM_BUG_ON_PAGE(!PageHuge(page), page);
+	struct page *tail;
 
-	if (compound_order(page) < HUGETLB_CGROUP_MIN_ORDER)
+	VM_BUG_ON_FOLIO(!folio_test_hugetlb(folio), folio);
+	if (folio_order(folio) < HUGETLB_CGROUP_MIN_ORDER)
 		return NULL;
-	if (rsvd)
-		return (void *)page_private(page + SUBPAGE_INDEX_CGROUP_RSVD);
-	else
-		return (void *)page_private(page + SUBPAGE_INDEX_CGROUP);
+
+	if (rsvd) {
+		tail = folio_page(folio, SUBPAGE_INDEX_CGROUP_RSVD);
+		return (void *)page_private(tail);
+	}
+
+	else {
+		tail = folio_page(folio, SUBPAGE_INDEX_CGROUP);
+		return (void *)page_private(tail);
+	}
 }
 
-static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
+static inline struct hugetlb_cgroup *hugetlb_cgroup_from_folio(struct folio *folio)
 {
-	return __hugetlb_cgroup_from_page(page, false);
+	return __hugetlb_cgroup_from_folio(folio, false);
 }
 
 static inline struct hugetlb_cgroup *
-hugetlb_cgroup_from_page_rsvd(struct page *page)
+hugetlb_cgroup_from_folio_rsvd(struct folio *folio)
 {
-	return __hugetlb_cgroup_from_page(page, true);
+	return __hugetlb_cgroup_from_folio(folio, true);
 }
 
 static inline void __set_hugetlb_cgroup(struct folio *folio,
@@ -181,19 +188,13 @@ static inline void hugetlb_cgroup_uncharge_file_region(struct resv_map *resv,
 {
 }
 
-static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
-{
-	return NULL;
-}
-
-static inline struct hugetlb_cgroup *
-hugetlb_cgroup_from_page_resv(struct page *page)
+static inline struct hugetlb_cgroup *hugetlb_cgroup_from_folio(struct folio *folio)
 {
 	return NULL;
 }
 
 static inline struct hugetlb_cgroup *
-hugetlb_cgroup_from_page_rsvd(struct page *page)
+hugetlb_cgroup_from_folio_rsvd(struct folio *folio)
 {
 	return NULL;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 37288a7f0fa65..9c1a30eb6c564 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1661,9 +1661,10 @@ static void __remove_hugetlb_page(struct hstate *h, struct page *page,
 							bool demote)
 {
 	int nid = page_to_nid(page);
+	struct folio *folio = page_folio(page);
 
-	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page(page), page);
-	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page_rsvd(page), page);
+	VM_BUG_ON_FOLIO(hugetlb_cgroup_from_folio(folio), folio);
+	VM_BUG_ON_FOLIO(hugetlb_cgroup_from_folio_rsvd(folio), folio);
 
 	lockdep_assert_held(&hugetlb_lock);
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index b2316bcbf634a..8b95c1560f9c3 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -191,8 +191,9 @@ static void hugetlb_cgroup_move_parent(int idx, struct hugetlb_cgroup *h_cg,
 	struct page_counter *counter;
 	struct hugetlb_cgroup *page_hcg;
 	struct hugetlb_cgroup *parent = parent_hugetlb_cgroup(h_cg);
+	struct folio *folio = page_folio(page);
 
-	page_hcg = hugetlb_cgroup_from_page(page);
+	page_hcg = hugetlb_cgroup_from_folio(folio);
 	/*
 	 * We can have pages in active list without any cgroup
 	 * ie, hugepage with less than 3 pages. We can safely
@@ -349,14 +350,15 @@ static void __hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
 					   struct page *page, bool rsvd)
 {
 	struct hugetlb_cgroup *h_cg;
+	struct folio *folio = page_folio(page);
 
 	if (hugetlb_cgroup_disabled())
 		return;
 	lockdep_assert_held(&hugetlb_lock);
-	h_cg = __hugetlb_cgroup_from_page(page, rsvd);
+	h_cg = __hugetlb_cgroup_from_folio(folio, rsvd);
 	if (unlikely(!h_cg))
 		return;
-	__set_hugetlb_cgroup(page_folio(page), NULL, rsvd);
+	__set_hugetlb_cgroup(folio, NULL, rsvd);
 
 	page_counter_uncharge(__hugetlb_cgroup_counter_from_cgroup(h_cg, idx,
 								   rsvd),
@@ -888,13 +890,14 @@ void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
 	struct hugetlb_cgroup *h_cg;
 	struct hugetlb_cgroup *h_cg_rsvd;
 	struct hstate *h = page_hstate(oldhpage);
+	struct folio *old_folio = page_folio(oldhpage);
 
 	if (hugetlb_cgroup_disabled())
 		return;
 
 	spin_lock_irq(&hugetlb_lock);
-	h_cg = hugetlb_cgroup_from_page(oldhpage);
-	h_cg_rsvd = hugetlb_cgroup_from_page_rsvd(oldhpage);
+	h_cg = hugetlb_cgroup_from_folio(old_folio);
+	h_cg_rsvd = hugetlb_cgroup_from_folio_rsvd(old_folio);
 	set_hugetlb_cgroup(oldhpage, NULL);
 	set_hugetlb_cgroup_rsvd(oldhpage, NULL);
 
-- 
2.43.0



