Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFB3246798;
	Tue, 20 May 2025 14:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749939; cv=none; b=emzUTu5ovwK5s9H4OXbNcK81ztweJ+SXei46wk7UjcnDW40tUseib9/v+EFfE+9yhe/3ucV0FQ71tW3yaBbeVJEYPqjnERTsYfJ4dCJPLkAvkFS12iZaqsZ1NymTi7QEXx28D2XDA0E8Vteu1bZyGVkxxFPQyHCg9TCFygdQVZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749939; c=relaxed/simple;
	bh=yd4t5/9icNltNPWJ+0Gv2b5CXydGRg9/NQQBiReEhKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diErig2D3y4JD7CA2F5Zl74HzZV62fz+q7vPXMaffcidrp3B8HI+MrTIjX+vIaF5GShRwuwbIn1nvUMK7plWg1MzpBeQROnFpS0WYybtnBl8KggGjB6TcvKFNE7/AwcJqFmcEFRkPxfshuZ4sOf9MsUzVTivbXaPw3TYjsg2G40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2K1I1pPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2K1I1pPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D66C4CEE9;
	Tue, 20 May 2025 14:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749939;
	bh=yd4t5/9icNltNPWJ+0Gv2b5CXydGRg9/NQQBiReEhKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2K1I1pPIDyXRC1jCIebXDxgf9gMC5uEUC1mZPu57ADT5kMUUZx145AmJm89CXIAxK
	 O/3FdtN2XozUtfQA2w5i/VFEhGTEYWHpDTzP0OibJhjtOg/w/UlpriYAT1e8pSwUNK
	 kFyTfXnpht4bfJgUVpTyKG1V12+3l7Vm/IyxeQwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	Huang Ying <ying.huang@intel.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 108/117] mm/migrate: correct nr_failed in migrate_pages_sync()
Date: Tue, 20 May 2025 15:51:13 +0200
Message-ID: <20250520125808.290220118@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zi Yan <ziy@nvidia.com>

commit a259945efe6ada94087ef666e9b38f8e34ea34ba upstream.

nr_failed was missing the large folio splits from migrate_pages_batch()
and can cause a mismatch between migrate_pages() return value and the
number of not migrated pages, i.e., when the return value of
migrate_pages() is 0, there are still pages left in the from page list.
It will happen when a non-PMD THP large folio fails to migrate due to
-ENOMEM and is split successfully but not all the split pages are not
migrated, migrate_pages_batch() would return non-zero, but
astats.nr_thp_split = 0.  nr_failed would be 0 and returned to the caller
of migrate_pages(), but the not migrated pages are left in the from page
list without being added back to LRU lists.

Fix it by adding a new nr_split counter for large folio splits and adding
it to nr_failed in migrate_page_sync() after migrate_pages_batch() is
done.

Link: https://lkml.kernel.org/r/20231017163129.2025214-1-zi.yan@sent.com
Fixes: 2ef7dbb26990 ("migrate_pages: try migrate in batch asynchronously firstly")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1504,6 +1504,7 @@ struct migrate_pages_stats {
 	int nr_thp_succeeded;	/* THP migrated successfully */
 	int nr_thp_failed;	/* THP failed to be migrated */
 	int nr_thp_split;	/* THP split before migrating */
+	int nr_split;	/* Large folio (include THP) split before migrating */
 };
 
 /*
@@ -1623,6 +1624,7 @@ static int migrate_pages_batch(struct li
 	int nr_retry_pages = 0;
 	int pass = 0;
 	bool is_thp = false;
+	bool is_large = false;
 	struct folio *folio, *folio2, *dst = NULL, *dst2;
 	int rc, rc_saved = 0, nr_pages;
 	LIST_HEAD(unmap_folios);
@@ -1638,7 +1640,8 @@ static int migrate_pages_batch(struct li
 		nr_retry_pages = 0;
 
 		list_for_each_entry_safe(folio, folio2, from, lru) {
-			is_thp = folio_test_large(folio) && folio_test_pmd_mappable(folio);
+			is_large = folio_test_large(folio);
+			is_thp = is_large && folio_test_pmd_mappable(folio);
 			nr_pages = folio_nr_pages(folio);
 
 			cond_resched();
@@ -1658,6 +1661,7 @@ static int migrate_pages_batch(struct li
 				stats->nr_thp_failed++;
 				if (!try_split_folio(folio, split_folios)) {
 					stats->nr_thp_split++;
+					stats->nr_split++;
 					continue;
 				}
 				stats->nr_failed_pages += nr_pages;
@@ -1686,11 +1690,12 @@ static int migrate_pages_batch(struct li
 				nr_failed++;
 				stats->nr_thp_failed += is_thp;
 				/* Large folio NUMA faulting doesn't split to retry. */
-				if (folio_test_large(folio) && !nosplit) {
+				if (is_large && !nosplit) {
 					int ret = try_split_folio(folio, split_folios);
 
 					if (!ret) {
 						stats->nr_thp_split += is_thp;
+						stats->nr_split += is_large;
 						break;
 					} else if (reason == MR_LONGTERM_PIN &&
 						   ret == -EAGAIN) {
@@ -1836,6 +1841,7 @@ static int migrate_pages_sync(struct lis
 	stats->nr_succeeded += astats.nr_succeeded;
 	stats->nr_thp_succeeded += astats.nr_thp_succeeded;
 	stats->nr_thp_split += astats.nr_thp_split;
+	stats->nr_split += astats.nr_split;
 	if (rc < 0) {
 		stats->nr_failed_pages += astats.nr_failed_pages;
 		stats->nr_thp_failed += astats.nr_thp_failed;
@@ -1843,7 +1849,11 @@ static int migrate_pages_sync(struct lis
 		return rc;
 	}
 	stats->nr_thp_failed += astats.nr_thp_split;
-	nr_failed += astats.nr_thp_split;
+	/*
+	 * Do not count rc, as pages will be retried below.
+	 * Count nr_split only, since it includes nr_thp_split.
+	 */
+	nr_failed += astats.nr_split;
 	/*
 	 * Fall back to migrate all failed folios one by one synchronously. All
 	 * failed folios except split THPs will be retried, so their failure


