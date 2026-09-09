Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9578B481A97;
	Wed,  9 Sep 2026 14:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964888; cv=none; b=YnBvqt4Hshi3pZA0T9Wg0reQuSRUULw8kGgVOaqjP0JD6eCW3G3FxoZFX6w+WQ7P5sIrUTV7tQf/Zv3uXOka1THYf1IYoY5w/fK7idkA1OemTXlCTU8BfiBE8rAV5f2KiyDm4NXK0VYK9uaVjzmqHO4WD6/MavsRRYxsTvLbPwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964888; c=relaxed/simple;
	bh=G3pqo2Re/jGjQZnwBYO1Z6ySmOYe7qaBGcMz6BLcKK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4OujMX6qzY9KCn4pJge08POmDEOAyYKf434cv/7UbCoDNuRnKautXNXmFJzSbD1bGHDflzN4ftEe0qTGKBthco+5gRkBiIeIMdtT2eTjDhOIa9L/f9pfqQGz0z35GlbqFdfoYOup5T5U97DoqI9NJZygCDAW5yMtzb5+E0j2ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGZU6sRO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGZU6sRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C3F1F00A3A;
	Wed,  9 Sep 2026 14:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964887;
	bh=2Lcx/9zilOU3dK012D+NVZPcv61N+ymB/7e2LYtEZLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JGZU6sRONKtnQ5PRR91FjIXY9dFbUgLOf5qy/TfKcyy3ub6KEFSLhb/ZlHKK1/4KB
	 6EHXzjf7wRI6CET2GYrrBlzsO2Q+co9Ul5jUd46HqJAu0Ic5hBrDz3bfoQNFzJ+Hqz
	 YNCOD84eqN2WLGUudblFXxmt0ExliiARrMzocqCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 578/583] mm/huge_memory: replace can_split_folio() with direct refcount calculation
Date: Wed,  9 Sep 2026 15:44:23 +0200
Message-ID: <20260909134257.832172718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zi Yan <ziy@nvidia.com>

[ Upstream commit 5842bcbfc316738cbfcbdb4def5a7592aa03ebf2 ]

can_split_folio() is just a refcount comparison, making sure only the
split caller holds an extra pin.  Open code it with
folio_expected_ref_count() != folio_ref_count() - 1.  For the extra_pins
used by folio_ref_freeze(), add folio_cache_ref_count() to calculate it.
Also replace folio_expected_ref_count() with folio_cache_ref_count() used
by folio_ref_unfreeze(), since they are returning the same values when a
folio is frozen and folio_cache_ref_count() does not have unnecessary
folio_mapcount() in its implementation.

Link: https://lkml.kernel.org/r/20251126210618.1971206-3-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: c299a2285d9d ("mm/huge_memory: use folio's memcg inside __folio_split()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/huge_mm.h |    1 -
 mm/huge_memory.c        |   35 ++++++++++++-----------------------
 mm/vmscan.c             |    3 ++-
 3 files changed, 14 insertions(+), 25 deletions(-)

--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -364,7 +364,6 @@ unsigned long thp_get_unmapped_area_vmfl
 		unsigned long len, unsigned long pgoff, unsigned long flags,
 		vm_flags_t vm_flags);
 
-bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
 int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order);
 int min_order_for_split(struct folio *folio);
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3328,23 +3328,6 @@ static void lru_add_split_folio(struct f
 	}
 }
 
-/* Racy check whether the huge page can be split */
-bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
-{
-	int extra_pins;
-
-	/* Additional pins from page cache */
-	if (folio_test_anon(folio))
-		extra_pins = folio_test_swapcache(folio) ?
-				folio_nr_pages(folio) : 0;
-	else
-		extra_pins = folio_nr_pages(folio);
-	if (pextra_pins)
-		*pextra_pins = extra_pins;
-	return folio_mapcount(folio) == folio_ref_count(folio) - extra_pins -
-					caller_pins;
-}
-
 static bool page_range_has_hwpoisoned(struct page *page, long nr_pages)
 {
 	for (; nr_pages; page++, nr_pages--)
@@ -3717,7 +3700,6 @@ static int __folio_split(struct folio *f
 	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
-	int extra_pins;
 	int nr_shmem_dropped = 0;
 	enum ttu_flags ttu_flags = 0;
 	pgoff_t end = 0;
@@ -3805,7 +3787,7 @@ static int __folio_split(struct folio *f
 	 * Racy check if we can split the page, before unmap_folio() will
 	 * split PMDs
 	 */
-	if (!can_split_folio(folio, 1, &extra_pins)) {
+	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1) {
 		ret = -EAGAIN;
 		goto out_unlock;
 	}
@@ -3829,7 +3811,10 @@ static int __folio_split(struct folio *f
 
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	ds_queue = folio_split_queue_lock(folio);
-	if (folio_ref_freeze(folio, 1 + extra_pins)) {
+	if (folio_ref_freeze(folio,
+			     (folio_test_anon(folio) &&
+			      !folio_test_swapcache(folio) ?
+			      0 : folio_nr_pages(folio)) + 1)) {
 		struct swap_cluster_info *ci = NULL;
 		struct lruvec *lruvec;
 		int expected_refs;
@@ -3898,7 +3883,9 @@ static int __folio_split(struct folio *f
 
 			next = folio_next(new_folio);
 
-			expected_refs = folio_expected_ref_count(new_folio) + 1;
+			expected_refs = (folio_test_anon(new_folio) &&
+					 !folio_test_swapcache(new_folio) ?
+					 0 : folio_nr_pages(new_folio)) + 1;
 			folio_ref_unfreeze(new_folio, expected_refs);
 
 			lru_add_split_folio(folio, new_folio, lruvec, list);
@@ -3938,7 +3925,9 @@ static int __folio_split(struct folio *f
 		 * Otherwise, a parallel folio_try_get() can grab @folio
 		 * and its caller can see stale page cache entries.
 		 */
-		expected_refs = folio_expected_ref_count(folio) + 1;
+		expected_refs = (folio_test_anon(folio) &&
+				 !folio_test_swapcache(folio) ?
+				 0 : folio_nr_pages(folio)) + 1;
 		folio_ref_unfreeze(folio, expected_refs);
 
 		unlock_page_lruvec(lruvec);
@@ -4467,7 +4456,7 @@ static int split_huge_pages_pid(int pid,
 		 * can be split or not. So skip the check here.
 		 */
 		if (!folio_test_private(folio) &&
-		    !can_split_folio(folio, 0, NULL))
+		    folio_expected_ref_count(folio) != folio_ref_count(folio))
 			goto next;
 
 		if (!folio_trylock(folio))
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1312,7 +1312,8 @@ retry:
 					goto keep_locked;
 				if (folio_test_large(folio)) {
 					/* cannot split folio, skip it */
-					if (!can_split_folio(folio, 1, NULL))
+					if (folio_expected_ref_count(folio) !=
+					    folio_ref_count(folio) - 1)
 						goto activate_locked;
 					/*
 					 * Split partially mapped folios right away.


