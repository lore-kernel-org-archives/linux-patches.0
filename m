Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FC91F9A9B;
	Wed,  6 Nov 2024 12:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897301; cv=none; b=UOXyLhy4PEvFlW72hcvtmZ5tj7H+tHr1uqoyILktum8fi7q0cBfrYmVH0DdVbLnCFMkrvS4uSjREmcPy9MA5Ea3R+bAy6zwpBgTmfLfGknJKCABbJH2zotYCoOYyoHcZ1wq51jQNtlEQs7l8sY8OngLlOSbHPObuK5CDHK5MU1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897301; c=relaxed/simple;
	bh=N0YZodusvakXes3KBlq0bhJ/0i4vsOm5PYNQPdagpcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kb2YBZL8VDCtMW4yfi6I1eKUGHoWjwNKl6FhaeQzbYd30Vn0YdHFUcI9n61OeSjzSJBoqPn+SMg4zzGQW+MdNf50+pZKOOj5u5vqr3jZjot1fSZRO3coLRKf1NSoUDAyL9llkLX1X6eGisgpxgUZRtP0f/GYxQKLEYozH8tyTn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEiXB2jh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEiXB2jh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE38C4CED5;
	Wed,  6 Nov 2024 12:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897301;
	bh=N0YZodusvakXes3KBlq0bhJ/0i4vsOm5PYNQPdagpcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZEiXB2jhrkM5FALtvToYhqUtGeb8L+F6aHwwDfeBsg/uIcQVW1s1kt9A9/Taqt17E
	 rts4jsxO7KBiqcdZGrhMM5A5H4MU5tDM77kcBxZ3hRgqDjG+K3iUus1dCRvb5yYOr5
	 oXFFn0PYCcr5wZueLqXPga9/w4D5ZvA+YNs4Dy3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Huang, Ying" <ying.huang@intel.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>,
	Yang Shi <shy828301@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Matthew Wilcox <willy@infradead.org>,
	Bharata B Rao <bharata@amd.com>,
	Alistair Popple <apopple@nvidia.com>,
	Xin Hao <xhao@linux.alibaba.com>,
	Minchan Kim <minchan@kernel.org>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/126] migrate_pages: restrict number of pages to migrate in batch
Date: Wed,  6 Nov 2024 13:05:12 +0100
Message-ID: <20241106120309.056185942@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

From: Huang Ying <ying.huang@intel.com>

[ Upstream commit 42012e0436d44aeb2e68f11a28ddd0ad3f38b61f ]

This is a preparation patch to batch the folio unmapping and moving for
non-hugetlb folios.

If we had batched the folio unmapping, all folios to be migrated would be
unmapped before copying the contents and flags of the folios.  If the
folios that were passed to migrate_pages() were too many in unit of pages,
the execution of the processes would be stopped for too long time, thus
too long latency.  For example, migrate_pages() syscall will call
migrate_pages() with all folios of a process.  To avoid this possible
issue, in this patch, we restrict the number of pages to be migrated to be
no more than HPAGE_PMD_NR.  That is, the influence is at the same level of
THP migration.

Link: https://lkml.kernel.org/r/20230213123444.155149-4-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Xin Hao <xhao@linux.alibaba.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 35e41024c4c2 ("vmscan,migrate: fix page count imbalance on node stats when demoting pages")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/migrate.c | 174 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 106 insertions(+), 68 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 70d0b20d06a5f..40ae91e1a026b 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1398,6 +1398,11 @@ static inline int try_split_folio(struct folio *folio, struct list_head *split_f
 	return rc;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#define NR_MAX_BATCHED_MIGRATION	HPAGE_PMD_NR
+#else
+#define NR_MAX_BATCHED_MIGRATION	512
+#endif
 #define NR_MAX_MIGRATE_PAGES_RETRY	10
 
 struct migrate_pages_stats {
@@ -1499,40 +1504,15 @@ static int migrate_hugetlbs(struct list_head *from, new_page_t get_new_page,
 	return nr_failed;
 }
 
-/*
- * migrate_pages - migrate the folios specified in a list, to the free folios
- *		   supplied as the target for the page migration
- *
- * @from:		The list of folios to be migrated.
- * @get_new_page:	The function used to allocate free folios to be used
- *			as the target of the folio migration.
- * @put_new_page:	The function used to free target folios if migration
- *			fails, or NULL if no special handling is necessary.
- * @private:		Private data to be passed on to get_new_page()
- * @mode:		The migration mode that specifies the constraints for
- *			folio migration, if any.
- * @reason:		The reason for folio migration.
- * @ret_succeeded:	Set to the number of folios migrated successfully if
- *			the caller passes a non-NULL pointer.
- *
- * The function returns after NR_MAX_MIGRATE_PAGES_RETRY attempts or if no folios
- * are movable any more because the list has become empty or no retryable folios
- * exist any more. It is caller's responsibility to call putback_movable_pages()
- * only if ret != 0.
- *
- * Returns the number of {normal folio, large folio, hugetlb} that were not
- * migrated, or an error code. The number of large folio splits will be
- * considered as the number of non-migrated large folio, no matter how many
- * split folios of the large folio are migrated successfully.
- */
-int migrate_pages(struct list_head *from, new_page_t get_new_page,
+static int migrate_pages_batch(struct list_head *from, new_page_t get_new_page,
 		free_page_t put_new_page, unsigned long private,
-		enum migrate_mode mode, int reason, unsigned int *ret_succeeded)
+		enum migrate_mode mode, int reason, struct list_head *ret_folios,
+		struct migrate_pages_stats *stats)
 {
 	int retry = 1;
 	int large_retry = 1;
 	int thp_retry = 1;
-	int nr_failed;
+	int nr_failed = 0;
 	int nr_retry_pages = 0;
 	int nr_large_failed = 0;
 	int pass = 0;
@@ -1540,20 +1520,9 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 	bool is_thp = false;
 	struct folio *folio, *folio2;
 	int rc, nr_pages;
-	LIST_HEAD(ret_folios);
 	LIST_HEAD(split_folios);
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
 	bool no_split_folio_counting = false;
-	struct migrate_pages_stats stats;
-
-	trace_mm_migrate_pages_start(mode, reason);
-
-	memset(&stats, 0, sizeof(stats));
-	rc = migrate_hugetlbs(from, get_new_page, put_new_page, private, mode, reason,
-			      &stats, &ret_folios);
-	if (rc < 0)
-		goto out;
-	nr_failed = rc;
 
 split_folio_migration:
 	for (pass = 0;
@@ -1565,12 +1534,6 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 		nr_retry_pages = 0;
 
 		list_for_each_entry_safe(folio, folio2, from, lru) {
-			/* Retried hugetlb folios will be kept in list  */
-			if (folio_test_hugetlb(folio)) {
-				list_move_tail(&folio->lru, &ret_folios);
-				continue;
-			}
-
 			/*
 			 * Large folio statistics is based on the source large
 			 * folio. Capture required information that might get
@@ -1584,15 +1547,14 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 
 			rc = unmap_and_move(get_new_page, put_new_page,
 					    private, folio, pass > 2, mode,
-					    reason, &ret_folios);
+					    reason, ret_folios);
 			/*
 			 * The rules are:
 			 *	Success: folio will be freed
 			 *	-EAGAIN: stay on the from list
 			 *	-ENOMEM: stay on the from list
 			 *	-ENOSYS: stay on the from list
-			 *	Other errno: put on ret_folios list then splice to
-			 *		     from list
+			 *	Other errno: put on ret_folios list
 			 */
 			switch(rc) {
 			/*
@@ -1609,17 +1571,17 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 				/* Large folio migration is unsupported */
 				if (is_large) {
 					nr_large_failed++;
-					stats.nr_thp_failed += is_thp;
+					stats->nr_thp_failed += is_thp;
 					if (!try_split_folio(folio, &split_folios)) {
-						stats.nr_thp_split += is_thp;
+						stats->nr_thp_split += is_thp;
 						break;
 					}
 				} else if (!no_split_folio_counting) {
 					nr_failed++;
 				}
 
-				stats.nr_failed_pages += nr_pages;
-				list_move_tail(&folio->lru, &ret_folios);
+				stats->nr_failed_pages += nr_pages;
+				list_move_tail(&folio->lru, ret_folios);
 				break;
 			case -ENOMEM:
 				/*
@@ -1628,13 +1590,13 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 				 */
 				if (is_large) {
 					nr_large_failed++;
-					stats.nr_thp_failed += is_thp;
+					stats->nr_thp_failed += is_thp;
 					/* Large folio NUMA faulting doesn't split to retry. */
 					if (!nosplit) {
 						int ret = try_split_folio(folio, &split_folios);
 
 						if (!ret) {
-							stats.nr_thp_split += is_thp;
+							stats->nr_thp_split += is_thp;
 							break;
 						} else if (reason == MR_LONGTERM_PIN &&
 							   ret == -EAGAIN) {
@@ -1652,17 +1614,17 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 					nr_failed++;
 				}
 
-				stats.nr_failed_pages += nr_pages + nr_retry_pages;
+				stats->nr_failed_pages += nr_pages + nr_retry_pages;
 				/*
 				 * There might be some split folios of fail-to-migrate large
-				 * folios left in split_folios list. Move them back to migration
+				 * folios left in split_folios list. Move them to ret_folios
 				 * list so that they could be put back to the right list by
 				 * the caller otherwise the folio refcnt will be leaked.
 				 */
-				list_splice_init(&split_folios, from);
+				list_splice_init(&split_folios, ret_folios);
 				/* nr_failed isn't updated for not used */
 				nr_large_failed += large_retry;
-				stats.nr_thp_failed += thp_retry;
+				stats->nr_thp_failed += thp_retry;
 				goto out;
 			case -EAGAIN:
 				if (is_large) {
@@ -1674,8 +1636,8 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 				nr_retry_pages += nr_pages;
 				break;
 			case MIGRATEPAGE_SUCCESS:
-				stats.nr_succeeded += nr_pages;
-				stats.nr_thp_succeeded += is_thp;
+				stats->nr_succeeded += nr_pages;
+				stats->nr_thp_succeeded += is_thp;
 				break;
 			default:
 				/*
@@ -1686,20 +1648,20 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 				 */
 				if (is_large) {
 					nr_large_failed++;
-					stats.nr_thp_failed += is_thp;
+					stats->nr_thp_failed += is_thp;
 				} else if (!no_split_folio_counting) {
 					nr_failed++;
 				}
 
-				stats.nr_failed_pages += nr_pages;
+				stats->nr_failed_pages += nr_pages;
 				break;
 			}
 		}
 	}
 	nr_failed += retry;
 	nr_large_failed += large_retry;
-	stats.nr_thp_failed += thp_retry;
-	stats.nr_failed_pages += nr_retry_pages;
+	stats->nr_thp_failed += thp_retry;
+	stats->nr_failed_pages += nr_retry_pages;
 	/*
 	 * Try to migrate split folios of fail-to-migrate large folios, no
 	 * nr_failed counting in this round, since all split folios of a
@@ -1710,7 +1672,7 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 		 * Move non-migrated folios (after NR_MAX_MIGRATE_PAGES_RETRY
 		 * retries) to ret_folios to avoid migrating them again.
 		 */
-		list_splice_init(from, &ret_folios);
+		list_splice_init(from, ret_folios);
 		list_splice_init(&split_folios, from);
 		no_split_folio_counting = true;
 		retry = 1;
@@ -1718,6 +1680,82 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 	}
 
 	rc = nr_failed + nr_large_failed;
+out:
+	return rc;
+}
+
+/*
+ * migrate_pages - migrate the folios specified in a list, to the free folios
+ *		   supplied as the target for the page migration
+ *
+ * @from:		The list of folios to be migrated.
+ * @get_new_page:	The function used to allocate free folios to be used
+ *			as the target of the folio migration.
+ * @put_new_page:	The function used to free target folios if migration
+ *			fails, or NULL if no special handling is necessary.
+ * @private:		Private data to be passed on to get_new_page()
+ * @mode:		The migration mode that specifies the constraints for
+ *			folio migration, if any.
+ * @reason:		The reason for folio migration.
+ * @ret_succeeded:	Set to the number of folios migrated successfully if
+ *			the caller passes a non-NULL pointer.
+ *
+ * The function returns after NR_MAX_MIGRATE_PAGES_RETRY attempts or if no folios
+ * are movable any more because the list has become empty or no retryable folios
+ * exist any more. It is caller's responsibility to call putback_movable_pages()
+ * only if ret != 0.
+ *
+ * Returns the number of {normal folio, large folio, hugetlb} that were not
+ * migrated, or an error code. The number of large folio splits will be
+ * considered as the number of non-migrated large folio, no matter how many
+ * split folios of the large folio are migrated successfully.
+ */
+int migrate_pages(struct list_head *from, new_page_t get_new_page,
+		free_page_t put_new_page, unsigned long private,
+		enum migrate_mode mode, int reason, unsigned int *ret_succeeded)
+{
+	int rc, rc_gather;
+	int nr_pages;
+	struct folio *folio, *folio2;
+	LIST_HEAD(folios);
+	LIST_HEAD(ret_folios);
+	struct migrate_pages_stats stats;
+
+	trace_mm_migrate_pages_start(mode, reason);
+
+	memset(&stats, 0, sizeof(stats));
+
+	rc_gather = migrate_hugetlbs(from, get_new_page, put_new_page, private,
+				     mode, reason, &stats, &ret_folios);
+	if (rc_gather < 0)
+		goto out;
+again:
+	nr_pages = 0;
+	list_for_each_entry_safe(folio, folio2, from, lru) {
+		/* Retried hugetlb folios will be kept in list  */
+		if (folio_test_hugetlb(folio)) {
+			list_move_tail(&folio->lru, &ret_folios);
+			continue;
+		}
+
+		nr_pages += folio_nr_pages(folio);
+		if (nr_pages > NR_MAX_BATCHED_MIGRATION)
+			break;
+	}
+	if (nr_pages > NR_MAX_BATCHED_MIGRATION)
+		list_cut_before(&folios, from, &folio->lru);
+	else
+		list_splice_init(from, &folios);
+	rc = migrate_pages_batch(&folios, get_new_page, put_new_page, private,
+				 mode, reason, &ret_folios, &stats);
+	list_splice_tail_init(&folios, &ret_folios);
+	if (rc < 0) {
+		rc_gather = rc;
+		goto out;
+	}
+	rc_gather += rc;
+	if (!list_empty(from))
+		goto again;
 out:
 	/*
 	 * Put the permanent failure folio back to migration list, they
@@ -1730,7 +1768,7 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 	 * are migrated successfully.
 	 */
 	if (list_empty(from))
-		rc = 0;
+		rc_gather = 0;
 
 	count_vm_events(PGMIGRATE_SUCCESS, stats.nr_succeeded);
 	count_vm_events(PGMIGRATE_FAIL, stats.nr_failed_pages);
@@ -1744,7 +1782,7 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 	if (ret_succeeded)
 		*ret_succeeded = stats.nr_succeeded;
 
-	return rc;
+	return rc_gather;
 }
 
 struct page *alloc_migration_target(struct page *page, unsigned long private)
-- 
2.43.0



