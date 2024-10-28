Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251612C697;
	Mon, 28 Oct 2024 06:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097663; cv=none; b=D3Pa87gH5Tl2IrhNA6TFIvzPUj+4vz1VMuR/FtrXeW1V/dVRAt3Yo1wwOakDwQZxFU4cFvawkZdffRS9NVn8lBsOqG2jZTaWQUWXnONT0wtV1cjaITiSKA/eiVdWqt/ua/+I0IrvpYdhPd4O9xCP8844D+UKni2sCwiJz0ltsC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097663; c=relaxed/simple;
	bh=g1pbmtbMsjZqXNQBstKw8Lcq8Q310A4zAa/KaQQcsfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8evIxsh0ChWQ2HGxcbmQC722NN0Jma6Ci4DPCA42wzWYL9OnijDAG+ycJLYAlHhxhXrwEpgbY2fxD15fkkRu4nFMvEnLPvx/UxQYpft9HwWN8K5wD7H7TbANuMddacBrn7OhZ6JhWl1y1fyDzrurMX6HRl9CUbEefrZ7VYDiIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhMff1pz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhMff1pz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0EDC4CEC3;
	Mon, 28 Oct 2024 06:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097662;
	bh=g1pbmtbMsjZqXNQBstKw8Lcq8Q310A4zAa/KaQQcsfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhMff1pzjzY4Ec9qzgse2rPH08NX7lGD2E5StePTWm82+yrd6zWispjLNBSTyUmcn
	 7Xgux/M34GO0Imgyuwe4BRrOAzWD3sIJwiudZdk+KixNle6tkuGlGY0zDklH+kB2l5
	 kXzVnOFKZNV1RglbIntm1dQHjm8sr+CLf+cQnVbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Rik van Riel <riel@surriel.com>,
	Yang Shi <shy828301@gmail.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/208] mm/khugepaged: convert alloc_charge_hpage() to use folios
Date: Mon, 28 Oct 2024 07:24:31 +0100
Message-ID: <20241028062308.893159409@linuxfoundation.org>
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

From: Vishal Moola (Oracle) <vishal.moola@gmail.com>

[ Upstream commit b455f39d228935f88eebcd1f7c1a6981093c6a3b ]

Also remove count_memcg_page_event now that its last caller no longer uses
it and reword hpage_collapse_alloc_page() to hpage_collapse_alloc_folio().

This removes 1 call to compound_head() and helps convert khugepaged to
use folios throughout.

Link: https://lkml.kernel.org/r/20231020183331.10770-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 37f0b47c5143 ("mm: khugepaged: fix the arguments order in khugepaged_collapse_file trace point")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memcontrol.h | 14 --------------
 mm/khugepaged.c            | 17 ++++++++++-------
 2 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e4e24da16d2c3..b1fdb1554f2f9 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1080,15 +1080,6 @@ static inline void count_memcg_events(struct mem_cgroup *memcg,
 	local_irq_restore(flags);
 }
 
-static inline void count_memcg_page_event(struct page *page,
-					  enum vm_event_item idx)
-{
-	struct mem_cgroup *memcg = page_memcg(page);
-
-	if (memcg)
-		count_memcg_events(memcg, idx, 1);
-}
-
 static inline void count_memcg_folio_events(struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
 {
@@ -1565,11 +1556,6 @@ static inline void __count_memcg_events(struct mem_cgroup *memcg,
 {
 }
 
-static inline void count_memcg_page_event(struct page *page,
-					  int idx)
-{
-}
-
 static inline void count_memcg_folio_events(struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
 {
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 88433cc25d8a5..97cc4ef061832 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -887,16 +887,16 @@ static int hpage_collapse_find_target_node(struct collapse_control *cc)
 }
 #endif
 
-static bool hpage_collapse_alloc_page(struct page **hpage, gfp_t gfp, int node,
+static bool hpage_collapse_alloc_folio(struct folio **folio, gfp_t gfp, int node,
 				      nodemask_t *nmask)
 {
-	*hpage = __alloc_pages(gfp, HPAGE_PMD_ORDER, node, nmask);
-	if (unlikely(!*hpage)) {
+	*folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, nmask);
+
+	if (unlikely(!*folio)) {
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		return false;
 	}
 
-	folio_prep_large_rmappable((struct folio *)*hpage);
 	count_vm_event(THP_COLLAPSE_ALLOC);
 	return true;
 }
@@ -1063,17 +1063,20 @@ static int alloc_charge_hpage(struct page **hpage, struct mm_struct *mm,
 	int node = hpage_collapse_find_target_node(cc);
 	struct folio *folio;
 
-	if (!hpage_collapse_alloc_page(hpage, gfp, node, &cc->alloc_nmask))
+	if (!hpage_collapse_alloc_folio(&folio, gfp, node, &cc->alloc_nmask)) {
+		*hpage = NULL;
 		return SCAN_ALLOC_HUGE_PAGE_FAIL;
+	}
 
-	folio = page_folio(*hpage);
 	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
 		folio_put(folio);
 		*hpage = NULL;
 		return SCAN_CGROUP_CHARGE_FAIL;
 	}
-	count_memcg_page_event(*hpage, THP_COLLAPSE_ALLOC);
 
+	count_memcg_folio_events(folio, THP_COLLAPSE_ALLOC, 1);
+
+	*hpage = folio_page(folio, 0);
 	return SCAN_SUCCEED;
 }
 
-- 
2.43.0



