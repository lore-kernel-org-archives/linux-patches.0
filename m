Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F1F12F58D;
	Tue, 14 May 2024 11:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686128; cv=none; b=NvrhEcCrOnVyi3QaxiB45ySWQIGG0I2CiZbdBnXfYUQ8huVKh83jX2TFKwmlNuj4U1Jc36M3/oTWPoOaDV0AM8E/fMIMxhGNunpMuFfj2cgDeWVosvn5RHzQW6QocboQCU/yjjT1B9Zk54cGtbNbob3MgX9WZiz8pXysz1GzwN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686128; c=relaxed/simple;
	bh=W9DCH0VGzL88Ql5MF5z9C3SIISdF4VTnQH46QltHoo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGeL/b6ggkcAC/wcUwtBGLehH3/uTGWAmC3HcwxVwnR4Fn8Qah7GVgX5Okk3GARudJbB1j3hgI+4P/poOvmTUotN4uT+q6tguEdDOiQtNfJ7Ict/fNQpGsWQqoOS02CrChzZnbvAIH5b71LWsz9IEa2O29wNi2/s6UxG3ZSGnL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWygxilK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWygxilK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAF8C2BD10;
	Tue, 14 May 2024 11:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686127;
	bh=W9DCH0VGzL88Ql5MF5z9C3SIISdF4VTnQH46QltHoo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWygxilKg1iZvxyvP+p/DeMQMkqfp1WTo4N50yHPT4ZCCFJevTRx9xokn0/jr1SIm
	 3QRVeGIuITrrppmZzuTsGkt1NgJpfAnVmaO/q5Eh93e380gdZrTuaBASXIEen0Esv6
	 mw90iTfpizA4OKynWjuKi3OyvC2b1Bib/jlGRWd8=
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
Subject: [PATCH 6.1 013/236] mm/hugetlb_cgroup: convert __set_hugetlb_cgroup() to folios
Date: Tue, 14 May 2024 12:16:15 +0200
Message-ID: <20240514101020.835517630@linuxfoundation.org>
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

[ Upstream commit a098c977722ca27d3b4bfeb966767af3cce45f85 ]

Patch series "convert hugetlb_cgroup helper functions to folios", v2.

This patch series continues the conversion of hugetlb code from being
managed in pages to folios by converting many of the hugetlb_cgroup helper
functions to use folios.  This allows the core hugetlb functions to pass
in a folio to these helper functions.

This patch (of 9);

Change __set_hugetlb_cgroup() to use folios so it is explicit that the
function operates on a head page.

Link: https://lkml.kernel.org/r/20221101223059.460937-1-sidhartha.kumar@oracle.com
Link: https://lkml.kernel.org/r/20221101223059.460937-2-sidhartha.kumar@oracle.com
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
 include/linux/hugetlb_cgroup.h | 14 +++++++-------
 mm/hugetlb_cgroup.c            |  4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
index 630cd255d0cfd..7576e9ed8afe7 100644
--- a/include/linux/hugetlb_cgroup.h
+++ b/include/linux/hugetlb_cgroup.h
@@ -90,31 +90,31 @@ hugetlb_cgroup_from_page_rsvd(struct page *page)
 	return __hugetlb_cgroup_from_page(page, true);
 }
 
-static inline void __set_hugetlb_cgroup(struct page *page,
+static inline void __set_hugetlb_cgroup(struct folio *folio,
 				       struct hugetlb_cgroup *h_cg, bool rsvd)
 {
-	VM_BUG_ON_PAGE(!PageHuge(page), page);
+	VM_BUG_ON_FOLIO(!folio_test_hugetlb(folio), folio);
 
-	if (compound_order(page) < HUGETLB_CGROUP_MIN_ORDER)
+	if (folio_order(folio) < HUGETLB_CGROUP_MIN_ORDER)
 		return;
 	if (rsvd)
-		set_page_private(page + SUBPAGE_INDEX_CGROUP_RSVD,
+		set_page_private(folio_page(folio, SUBPAGE_INDEX_CGROUP_RSVD),
 				 (unsigned long)h_cg);
 	else
-		set_page_private(page + SUBPAGE_INDEX_CGROUP,
+		set_page_private(folio_page(folio, SUBPAGE_INDEX_CGROUP),
 				 (unsigned long)h_cg);
 }
 
 static inline void set_hugetlb_cgroup(struct page *page,
 				     struct hugetlb_cgroup *h_cg)
 {
-	__set_hugetlb_cgroup(page, h_cg, false);
+	__set_hugetlb_cgroup(page_folio(page), h_cg, false);
 }
 
 static inline void set_hugetlb_cgroup_rsvd(struct page *page,
 					  struct hugetlb_cgroup *h_cg)
 {
-	__set_hugetlb_cgroup(page, h_cg, true);
+	__set_hugetlb_cgroup(page_folio(page), h_cg, true);
 }
 
 static inline bool hugetlb_cgroup_disabled(void)
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index f61d132df52b3..b2316bcbf634a 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -314,7 +314,7 @@ static void __hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
 	if (hugetlb_cgroup_disabled() || !h_cg)
 		return;
 
-	__set_hugetlb_cgroup(page, h_cg, rsvd);
+	__set_hugetlb_cgroup(page_folio(page), h_cg, rsvd);
 	if (!rsvd) {
 		unsigned long usage =
 			h_cg->nodeinfo[page_to_nid(page)]->usage[idx];
@@ -356,7 +356,7 @@ static void __hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
 	h_cg = __hugetlb_cgroup_from_page(page, rsvd);
 	if (unlikely(!h_cg))
 		return;
-	__set_hugetlb_cgroup(page, NULL, rsvd);
+	__set_hugetlb_cgroup(page_folio(page), NULL, rsvd);
 
 	page_counter_uncharge(__hugetlb_cgroup_counter_from_cgroup(h_cg, idx,
 								   rsvd),
-- 
2.43.0



