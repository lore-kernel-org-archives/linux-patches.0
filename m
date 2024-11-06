Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC91E1E0B62;
	Wed,  6 Nov 2024 12:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897232; cv=none; b=MYXubTyA8yesNy/O9aId1uEjMvghllVy4HHLyGDQDWH4PppEREWGuNkEbiv6cyQYBz6u/PRevjU9oFbVJzQ+tkV7vv8FjjMGn+1LOzghsGtdwhi/5Pg2s5YqG7srkRVXnaL2yfwxpXFav5xRiKjpuPmTTRMwgDpZTt5Emfz2UjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897232; c=relaxed/simple;
	bh=RtbEl9HDK0SkWXRbWRk8jYWrxiulfOke7ddlu5AZxWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swgI3AYDiZwH4VTTpaQPp1uvC6FJrpAKkL64IE4LpW59TCQl75Cqlk1DagiBxgkLrw4Y3yJr0n7jAq0y9sAlA7i0f9tnuemJrE4VhVaEiBge3PqVUcML0C9o2OviXePI1dHCJ1eVDGMOI7REPzydNhCQj3iiED23Ol39dAvNHeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1zmzvM69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1zmzvM69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023D1C4CECD;
	Wed,  6 Nov 2024 12:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897232;
	bh=RtbEl9HDK0SkWXRbWRk8jYWrxiulfOke7ddlu5AZxWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1zmzvM69JF5b7DWLBWiHwXazHjI5NKXDT6n3C0Air4dE85mIqnPOOcjur3TFqcqLR
	 bpBww1pygfwP/2fP1r1BiMpCYcXug9MRnsW0RkjILHGRigBXl3Eq/wj5Hec9iWHlln
	 HuhkpfqYoNS1NL04ApfKKyLJ/sYdtKoWhPei+M9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Huang, Ying" <ying.huang@intel.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Xin Hao <xhao@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>,
	Yang Shi <shy828301@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Matthew Wilcox <willy@infradead.org>,
	Bharata B Rao <bharata@amd.com>,
	Alistair Popple <apopple@nvidia.com>,
	Minchan Kim <minchan@kernel.org>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/126] migrate_pages: separate hugetlb folios migration
Date: Wed,  6 Nov 2024 13:05:11 +0100
Message-ID: <20241106120309.029559511@linuxfoundation.org>
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

[ Upstream commit e5bfff8b10e496378da4b7863479dd6fb907d4ea ]

This is a preparation patch to batch the folio unmapping and moving for
the non-hugetlb folios.  Based on that we can batch the TLB shootdown
during the folio migration and make it possible to use some hardware
accelerator for the folio copying.

In this patch the hugetlb folios and non-hugetlb folios migration is
separated in migrate_pages() to make it easy to change the non-hugetlb
folios migration implementation.

Link: https://lkml.kernel.org/r/20230213123444.155149-3-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Xin Hao <xhao@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 35e41024c4c2 ("vmscan,migrate: fix page count imbalance on node stats when demoting pages")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/migrate.c | 141 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 119 insertions(+), 22 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index b7596a0b4445f..70d0b20d06a5f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1398,6 +1398,8 @@ static inline int try_split_folio(struct folio *folio, struct list_head *split_f
 	return rc;
 }
 
+#define NR_MAX_MIGRATE_PAGES_RETRY	10
+
 struct migrate_pages_stats {
 	int nr_succeeded;	/* Normal and large folios migrated successfully, in
 				   units of base pages */
@@ -1408,6 +1410,95 @@ struct migrate_pages_stats {
 	int nr_thp_split;	/* THP split before migrating */
 };
 
+/*
+ * Returns the number of hugetlb folios that were not migrated, or an error code
+ * after NR_MAX_MIGRATE_PAGES_RETRY attempts or if no hugetlb folios are movable
+ * any more because the list has become empty or no retryable hugetlb folios
+ * exist any more. It is caller's responsibility to call putback_movable_pages()
+ * only if ret != 0.
+ */
+static int migrate_hugetlbs(struct list_head *from, new_page_t get_new_page,
+			    free_page_t put_new_page, unsigned long private,
+			    enum migrate_mode mode, int reason,
+			    struct migrate_pages_stats *stats,
+			    struct list_head *ret_folios)
+{
+	int retry = 1;
+	int nr_failed = 0;
+	int nr_retry_pages = 0;
+	int pass = 0;
+	struct folio *folio, *folio2;
+	int rc, nr_pages;
+
+	for (pass = 0; pass < NR_MAX_MIGRATE_PAGES_RETRY && retry; pass++) {
+		retry = 0;
+		nr_retry_pages = 0;
+
+		list_for_each_entry_safe(folio, folio2, from, lru) {
+			if (!folio_test_hugetlb(folio))
+				continue;
+
+			nr_pages = folio_nr_pages(folio);
+
+			cond_resched();
+
+			rc = unmap_and_move_huge_page(get_new_page,
+						      put_new_page, private,
+						      &folio->page, pass > 2, mode,
+						      reason, ret_folios);
+			/*
+			 * The rules are:
+			 *	Success: hugetlb folio will be put back
+			 *	-EAGAIN: stay on the from list
+			 *	-ENOMEM: stay on the from list
+			 *	-ENOSYS: stay on the from list
+			 *	Other errno: put on ret_folios list
+			 */
+			switch(rc) {
+			case -ENOSYS:
+				/* Hugetlb migration is unsupported */
+				nr_failed++;
+				stats->nr_failed_pages += nr_pages;
+				list_move_tail(&folio->lru, ret_folios);
+				break;
+			case -ENOMEM:
+				/*
+				 * When memory is low, don't bother to try to migrate
+				 * other folios, just exit.
+				 */
+				stats->nr_failed_pages += nr_pages + nr_retry_pages;
+				return -ENOMEM;
+			case -EAGAIN:
+				retry++;
+				nr_retry_pages += nr_pages;
+				break;
+			case MIGRATEPAGE_SUCCESS:
+				stats->nr_succeeded += nr_pages;
+				break;
+			default:
+				/*
+				 * Permanent failure (-EBUSY, etc.):
+				 * unlike -EAGAIN case, the failed folio is
+				 * removed from migration folio list and not
+				 * retried in the next outer loop.
+				 */
+				nr_failed++;
+				stats->nr_failed_pages += nr_pages;
+				break;
+			}
+		}
+	}
+	/*
+	 * nr_failed is number of hugetlb folios failed to be migrated.  After
+	 * NR_MAX_MIGRATE_PAGES_RETRY attempts, give up and count retried hugetlb
+	 * folios as failed.
+	 */
+	nr_failed += retry;
+	stats->nr_failed_pages += nr_retry_pages;
+
+	return nr_failed;
+}
+
 /*
  * migrate_pages - migrate the folios specified in a list, to the free folios
  *		   supplied as the target for the page migration
@@ -1424,10 +1515,10 @@ struct migrate_pages_stats {
  * @ret_succeeded:	Set to the number of folios migrated successfully if
  *			the caller passes a non-NULL pointer.
  *
- * The function returns after 10 attempts or if no folios are movable any more
- * because the list has become empty or no retryable folios exist any more.
- * It is caller's responsibility to call putback_movable_pages() to return folios
- * to the LRU or free list only if ret != 0.
+ * The function returns after NR_MAX_MIGRATE_PAGES_RETRY attempts or if no folios
+ * are movable any more because the list has become empty or no retryable folios
+ * exist any more. It is caller's responsibility to call putback_movable_pages()
+ * only if ret != 0.
  *
  * Returns the number of {normal folio, large folio, hugetlb} that were not
  * migrated, or an error code. The number of large folio splits will be
@@ -1441,7 +1532,7 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 	int retry = 1;
 	int large_retry = 1;
 	int thp_retry = 1;
-	int nr_failed = 0;
+	int nr_failed;
 	int nr_retry_pages = 0;
 	int nr_large_failed = 0;
 	int pass = 0;
@@ -1458,38 +1549,45 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 	trace_mm_migrate_pages_start(mode, reason);
 
 	memset(&stats, 0, sizeof(stats));
+	rc = migrate_hugetlbs(from, get_new_page, put_new_page, private, mode, reason,
+			      &stats, &ret_folios);
+	if (rc < 0)
+		goto out;
+	nr_failed = rc;
+
 split_folio_migration:
-	for (pass = 0; pass < 10 && (retry || large_retry); pass++) {
+	for (pass = 0;
+	     pass < NR_MAX_MIGRATE_PAGES_RETRY && (retry || large_retry);
+	     pass++) {
 		retry = 0;
 		large_retry = 0;
 		thp_retry = 0;
 		nr_retry_pages = 0;
 
 		list_for_each_entry_safe(folio, folio2, from, lru) {
+			/* Retried hugetlb folios will be kept in list  */
+			if (folio_test_hugetlb(folio)) {
+				list_move_tail(&folio->lru, &ret_folios);
+				continue;
+			}
+
 			/*
 			 * Large folio statistics is based on the source large
 			 * folio. Capture required information that might get
 			 * lost during migration.
 			 */
-			is_large = folio_test_large(folio) && !folio_test_hugetlb(folio);
+			is_large = folio_test_large(folio);
 			is_thp = is_large && folio_test_pmd_mappable(folio);
 			nr_pages = folio_nr_pages(folio);
+
 			cond_resched();
 
-			if (folio_test_hugetlb(folio))
-				rc = unmap_and_move_huge_page(get_new_page,
-						put_new_page, private,
-						&folio->page, pass > 2, mode,
-						reason,
-						&ret_folios);
-			else
-				rc = unmap_and_move(get_new_page, put_new_page,
-						private, folio, pass > 2, mode,
-						reason, &ret_folios);
+			rc = unmap_and_move(get_new_page, put_new_page,
+					    private, folio, pass > 2, mode,
+					    reason, &ret_folios);
 			/*
 			 * The rules are:
-			 *	Success: non hugetlb folio will be freed, hugetlb
-			 *		 folio will be put back
+			 *	Success: folio will be freed
 			 *	-EAGAIN: stay on the from list
 			 *	-ENOMEM: stay on the from list
 			 *	-ENOSYS: stay on the from list
@@ -1516,7 +1614,6 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 						stats.nr_thp_split += is_thp;
 						break;
 					}
-				/* Hugetlb migration is unsupported */
 				} else if (!no_split_folio_counting) {
 					nr_failed++;
 				}
@@ -1610,8 +1707,8 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 	 */
 	if (!list_empty(&split_folios)) {
 		/*
-		 * Move non-migrated folios (after 10 retries) to ret_folios
-		 * to avoid migrating them again.
+		 * Move non-migrated folios (after NR_MAX_MIGRATE_PAGES_RETRY
+		 * retries) to ret_folios to avoid migrating them again.
 		 */
 		list_splice_init(from, &ret_folios);
 		list_splice_init(&split_folios, from);
-- 
2.43.0



