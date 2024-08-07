Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6A674055;
	Wed,  7 Aug 2024 15:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042943; cv=none; b=gkhxt5JHaDdh6UfMFTf87rSi3YOzzze6Os9G1nXaY/eunvOPDr7OCIOAY/I+dPT1TrQ8P0L6F+SQuDKVjkFBl6DE57mGrFef14t6nSHxv6YZ2kL+eZAFZPYWHEARiIRntsOhjuRFgvJzYUp/jzyVjUNWKiG3y6osy+LPuUU/nqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042943; c=relaxed/simple;
	bh=OnUoLSV1jsz38IihbD8hwPnuI4OgMr38BH6Nd9vu6vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpoZeqcE7x3Si7syD+D1H7umrLJPLXZJIdFqRgkJ3S2VQjpcLDbcN7tD53Nyp/O/UCAPsW4lvU+7Mlj8fJwipDU5I7U8rPHCW2msxdi5DaqEWccL/nCsCTkmO31R1i3PzU1Tdt0926Z0ksccmjOzl2wpg8WueR+1H0KxRU/dkoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zR9mkeug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zR9mkeug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF459C32781;
	Wed,  7 Aug 2024 15:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042943;
	bh=OnUoLSV1jsz38IihbD8hwPnuI4OgMr38BH6Nd9vu6vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zR9mkeugLi5zjWr+NdK01kcmBksSA/V7o5qPV53dvugS5ETRle+CdHA47Fjk1JeJH
	 0utV2kwxqsM7/wwl2PVFvFG1LMvciLUEvhjOMfqZ3122d2LSMaKmU/tozoZ0EbzW+1
	 KwadCTwE70Pj+azsH2gK3gvv4HhZH6sQgjKXsE9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 004/123] mm/migrate: move NUMA hinting fault folio isolation + checks under PTL
Date: Wed,  7 Aug 2024 16:58:43 +0200
Message-ID: <20240807150020.945942238@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit ee86814b0562f18255b55c5e6a01a022895994cf ]

Currently we always take a folio reference even if migration will not even
be tried or isolation failed, requiring us to grab+drop an additional
reference.

Further, we end up calling folio_likely_mapped_shared() while the folio
might have already been unmapped, because after we dropped the PTL, that
can easily happen.  We want to stop touching mapcounts and friends from
such context, and only call folio_likely_mapped_shared() while the folio
is still mapped: mapcount information is pretty much stale and unreliable
otherwise.

So let's move checks into numamigrate_isolate_folio(), rename that
function to migrate_misplaced_folio_prepare(), and call that function from
callsites where we call migrate_misplaced_folio(), but still with the PTL
held.

We can now stop taking temporary folio references, and really only take a
reference if folio isolation succeeded.  Doing the
folio_likely_mapped_shared() + folio isolation under PT lock is now
similar to how we handle MADV_PAGEOUT.

While at it, combine the folio_is_file_lru() checks.

[david@redhat.com: fix list_del() corruption]
  Link: https://lkml.kernel.org/r/8f85c31a-e603-4578-bf49-136dae0d4b69@redhat.com
  Link: https://lkml.kernel.org/r/20240626191129.658CFC32782@smtp.kernel.org
Link: https://lkml.kernel.org/r/20240620212935.656243-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 6e49019db5f7 ("mm/migrate: putback split folios when numa hint migration fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/migrate.h |  7 ++++
 mm/huge_memory.c        |  8 ++--
 mm/memory.c             |  9 +++--
 mm/migrate.c            | 83 +++++++++++++++++++----------------------
 4 files changed, 56 insertions(+), 51 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 2ce13e8a309bd..9438cc7c2aeb5 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -142,9 +142,16 @@ const struct movable_operations *page_movable_ops(struct page *page)
 }
 
 #ifdef CONFIG_NUMA_BALANCING
+int migrate_misplaced_folio_prepare(struct folio *folio,
+		struct vm_area_struct *vma, int node);
 int migrate_misplaced_folio(struct folio *folio, struct vm_area_struct *vma,
 			   int node);
 #else
+static inline int migrate_misplaced_folio_prepare(struct folio *folio,
+		struct vm_area_struct *vma, int node)
+{
+	return -EAGAIN; /* can't migrate now */
+}
 static inline int migrate_misplaced_folio(struct folio *folio,
 					 struct vm_area_struct *vma, int node)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5ca9d45e6742c..5f32a196a612e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1702,11 +1702,13 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 	if (node_is_toptier(nid))
 		last_cpupid = folio_last_cpupid(folio);
 	target_nid = numa_migrate_prep(folio, vmf, haddr, nid, &flags);
-	if (target_nid == NUMA_NO_NODE) {
-		folio_put(folio);
+	if (target_nid == NUMA_NO_NODE)
+		goto out_map;
+	if (migrate_misplaced_folio_prepare(folio, vma, target_nid)) {
+		flags |= TNF_MIGRATE_FAIL;
 		goto out_map;
 	}
-
+	/* The folio is isolated and isolation code holds a folio reference. */
 	spin_unlock(vmf->ptl);
 	writable = false;
 
diff --git a/mm/memory.c b/mm/memory.c
index b1e77b9d17e75..755ffe082e217 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5067,8 +5067,6 @@ int numa_migrate_prep(struct folio *folio, struct vm_fault *vmf,
 {
 	struct vm_area_struct *vma = vmf->vma;
 
-	folio_get(folio);
-
 	/* Record the current PID acceesing VMA */
 	vma_set_access_pid_bit(vma);
 
@@ -5205,10 +5203,13 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 	else
 		last_cpupid = folio_last_cpupid(folio);
 	target_nid = numa_migrate_prep(folio, vmf, vmf->address, nid, &flags);
-	if (target_nid == NUMA_NO_NODE) {
-		folio_put(folio);
+	if (target_nid == NUMA_NO_NODE)
+		goto out_map;
+	if (migrate_misplaced_folio_prepare(folio, vma, target_nid)) {
+		flags |= TNF_MIGRATE_FAIL;
 		goto out_map;
 	}
+	/* The folio is isolated and isolation code holds a folio reference. */
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	writable = false;
 	ignore_writable = true;
diff --git a/mm/migrate.c b/mm/migrate.c
index 83e0e1aa21c7e..6b5affe49cf91 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2557,16 +2557,44 @@ static struct folio *alloc_misplaced_dst_folio(struct folio *src,
 	return __folio_alloc_node(gfp, order, nid);
 }
 
-static int numamigrate_isolate_folio(pg_data_t *pgdat, struct folio *folio)
+/*
+ * Prepare for calling migrate_misplaced_folio() by isolating the folio if
+ * permitted. Must be called with the PTL still held.
+ */
+int migrate_misplaced_folio_prepare(struct folio *folio,
+		struct vm_area_struct *vma, int node)
 {
 	int nr_pages = folio_nr_pages(folio);
+	pg_data_t *pgdat = NODE_DATA(node);
+
+	if (folio_is_file_lru(folio)) {
+		/*
+		 * Do not migrate file folios that are mapped in multiple
+		 * processes with execute permissions as they are probably
+		 * shared libraries.
+		 *
+		 * See folio_likely_mapped_shared() on possible imprecision
+		 * when we cannot easily detect if a folio is shared.
+		 */
+		if ((vma->vm_flags & VM_EXEC) &&
+		    folio_likely_mapped_shared(folio))
+			return -EACCES;
+
+		/*
+		 * Do not migrate dirty folios as not all filesystems can move
+		 * dirty folios in MIGRATE_ASYNC mode which is a waste of
+		 * cycles.
+		 */
+		if (folio_test_dirty(folio))
+			return -EAGAIN;
+	}
 
 	/* Avoid migrating to a node that is nearly full */
 	if (!migrate_balanced_pgdat(pgdat, nr_pages)) {
 		int z;
 
 		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING))
-			return 0;
+			return -EAGAIN;
 		for (z = pgdat->nr_zones - 1; z >= 0; z--) {
 			if (managed_zone(pgdat->node_zones + z))
 				break;
@@ -2577,65 +2605,37 @@ static int numamigrate_isolate_folio(pg_data_t *pgdat, struct folio *folio)
 		 * further.
 		 */
 		if (z < 0)
-			return 0;
+			return -EAGAIN;
 
 		wakeup_kswapd(pgdat->node_zones + z, 0,
 			      folio_order(folio), ZONE_MOVABLE);
-		return 0;
+		return -EAGAIN;
 	}
 
 	if (!folio_isolate_lru(folio))
-		return 0;
+		return -EAGAIN;
 
 	node_stat_mod_folio(folio, NR_ISOLATED_ANON + folio_is_file_lru(folio),
 			    nr_pages);
-
-	/*
-	 * Isolating the folio has taken another reference, so the
-	 * caller's reference can be safely dropped without the folio
-	 * disappearing underneath us during migration.
-	 */
-	folio_put(folio);
-	return 1;
+	return 0;
 }
 
 /*
  * Attempt to migrate a misplaced folio to the specified destination
- * node. Caller is expected to have an elevated reference count on
- * the folio that will be dropped by this function before returning.
+ * node. Caller is expected to have isolated the folio by calling
+ * migrate_misplaced_folio_prepare(), which will result in an
+ * elevated reference count on the folio. This function will un-isolate the
+ * folio, dereferencing the folio before returning.
  */
 int migrate_misplaced_folio(struct folio *folio, struct vm_area_struct *vma,
 			    int node)
 {
 	pg_data_t *pgdat = NODE_DATA(node);
-	int isolated;
 	int nr_remaining;
 	unsigned int nr_succeeded;
 	LIST_HEAD(migratepages);
 	int nr_pages = folio_nr_pages(folio);
 
-	/*
-	 * Don't migrate file folios that are mapped in multiple processes
-	 * with execute permissions as they are probably shared libraries.
-	 *
-	 * See folio_likely_mapped_shared() on possible imprecision when we
-	 * cannot easily detect if a folio is shared.
-	 */
-	if (folio_likely_mapped_shared(folio) && folio_is_file_lru(folio) &&
-	    (vma->vm_flags & VM_EXEC))
-		goto out;
-
-	/*
-	 * Also do not migrate dirty folios as not all filesystems can move
-	 * dirty folios in MIGRATE_ASYNC mode which is a waste of cycles.
-	 */
-	if (folio_is_file_lru(folio) && folio_test_dirty(folio))
-		goto out;
-
-	isolated = numamigrate_isolate_folio(pgdat, folio);
-	if (!isolated)
-		goto out;
-
 	list_add(&folio->lru, &migratepages);
 	nr_remaining = migrate_pages(&migratepages, alloc_misplaced_dst_folio,
 				     NULL, node, MIGRATE_ASYNC,
@@ -2647,7 +2647,6 @@ int migrate_misplaced_folio(struct folio *folio, struct vm_area_struct *vma,
 					folio_is_file_lru(folio), -nr_pages);
 			folio_putback_lru(folio);
 		}
-		isolated = 0;
 	}
 	if (nr_succeeded) {
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
@@ -2656,11 +2655,7 @@ int migrate_misplaced_folio(struct folio *folio, struct vm_area_struct *vma,
 					    nr_succeeded);
 	}
 	BUG_ON(!list_empty(&migratepages));
-	return isolated ? 0 : -EAGAIN;
-
-out:
-	folio_put(folio);
-	return -EAGAIN;
+	return nr_remaining ? -EAGAIN : 0;
 }
 #endif /* CONFIG_NUMA_BALANCING */
 #endif /* CONFIG_NUMA */
-- 
2.43.0



