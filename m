Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358FF1CAA4;
	Tue, 14 May 2024 11:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686171; cv=none; b=IiWg0mjMQrt27vz0WqM9fExsQmGo2gJ7toxSfjZeMuw4JQ+n7mpsiFEHjIRMwhP9xRlS/cEG3ZeZX0US7Vu4nrsnqyHDAcFriEI0IpDQVj+mnJX6YsP3DRSFVmW31CSdxQajRyQmyXDzupnVTLbrVga7CCg9Z9AkvRINZoI4b2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686171; c=relaxed/simple;
	bh=PYKozqe3VENtOpnGK0xyZShfQRkZj5iZfU9K3/H8LYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFeAlCeD4Qx7dewmmDWJzn5X5M+BxC/3TKRAsLedmJtMHCukF5+BGbnWUP244YkPEx1YOMuQ/D6nrkMjSTLhbZM+wpxXDczhsfW2ZWuyaNspK2OSLIOuqvIqDLPqHP73P0GlQ9tztfnC4pSPXPAw5EwmeOqOSPqivnr9PYWIPz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LR7Rx461; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LR7Rx461"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850C9C2BD10;
	Tue, 14 May 2024 11:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686171;
	bh=PYKozqe3VENtOpnGK0xyZShfQRkZj5iZfU9K3/H8LYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LR7Rx461nET2h7Mwyg3pewwyITginZn9vcz3QRcO61H/dALyZL5D3CPheViQDlPzV
	 IBpb65fwsCtImEWfszBecUBf6TuM1lnBECUCWrDqs7JeYJJN5g+xhxbx34umNAlQm2
	 KPVj9YaqrHmRWhnWsWj1ee2ieBGFQVmU17Ln2p0o=
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
Subject: [PATCH 6.1 015/236] mm/hugetlb: convert free_huge_page to folios
Date: Tue, 14 May 2024 12:16:17 +0200
Message-ID: <20240514101020.910661659@linuxfoundation.org>
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

[ Upstream commit 0356c4b96f6890dd61af4c902f681764f4bdba09 ]

Use folios inside free_huge_page(), this is in preparation for converting
hugetlb_cgroup_uncharge_page() to take in a folio.

Link: https://lkml.kernel.org/r/20221101223059.460937-7-sidhartha.kumar@oracle.com
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
 mm/hugetlb.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 9c1a30eb6c564..6cdbb06902df1 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1918,21 +1918,22 @@ void free_huge_page(struct page *page)
 	 * Can't pass hstate in here because it is called from the
 	 * compound page destructor.
 	 */
-	struct hstate *h = page_hstate(page);
-	int nid = page_to_nid(page);
-	struct hugepage_subpool *spool = hugetlb_page_subpool(page);
+	struct folio *folio = page_folio(page);
+	struct hstate *h = folio_hstate(folio);
+	int nid = folio_nid(folio);
+	struct hugepage_subpool *spool = hugetlb_folio_subpool(folio);
 	bool restore_reserve;
 	unsigned long flags;
 
-	VM_BUG_ON_PAGE(page_count(page), page);
-	VM_BUG_ON_PAGE(page_mapcount(page), page);
+	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
+	VM_BUG_ON_FOLIO(folio_mapcount(folio), folio);
 
-	hugetlb_set_page_subpool(page, NULL);
-	if (PageAnon(page))
-		__ClearPageAnonExclusive(page);
-	page->mapping = NULL;
-	restore_reserve = HPageRestoreReserve(page);
-	ClearHPageRestoreReserve(page);
+	hugetlb_set_folio_subpool(folio, NULL);
+	if (folio_test_anon(folio))
+		__ClearPageAnonExclusive(&folio->page);
+	folio->mapping = NULL;
+	restore_reserve = folio_test_hugetlb_restore_reserve(folio);
+	folio_clear_hugetlb_restore_reserve(folio);
 
 	/*
 	 * If HPageRestoreReserve was set on page, page allocation consumed a
@@ -1954,7 +1955,7 @@ void free_huge_page(struct page *page)
 	}
 
 	spin_lock_irqsave(&hugetlb_lock, flags);
-	ClearHPageMigratable(page);
+	folio_clear_hugetlb_migratable(folio);
 	hugetlb_cgroup_uncharge_page(hstate_index(h),
 				     pages_per_huge_page(h), page);
 	hugetlb_cgroup_uncharge_page_rsvd(hstate_index(h),
@@ -1962,7 +1963,7 @@ void free_huge_page(struct page *page)
 	if (restore_reserve)
 		h->resv_huge_pages++;
 
-	if (HPageTemporary(page)) {
+	if (folio_test_hugetlb_temporary(folio)) {
 		remove_hugetlb_page(h, page, false);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_page(h, page, true);
-- 
2.43.0



