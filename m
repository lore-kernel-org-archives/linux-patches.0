Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C6D76021;
	Mon, 29 Jan 2024 17:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548617; cv=none; b=XJYcsejW/bb3AendgDjAiITxAb3RaHbthSWs46MVq63g3kG78M33yYzcc7sMO+mfmxFVkIzY5IwEjYFaaw6XstgE/I+tcejThtwnPVmdXA9ahtAt8OOQL8wUsDeYS24exy9eRBRxPqRgRo5LbDXoBbIK/qyVs++I04Yputj8Oqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548617; c=relaxed/simple;
	bh=5dc8CscW/8MIe5o5Y5OAv6MS6KjCor31n40Dgan6i3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJF7Pu8Jq9gEsKGnxrenMYDKdEsobU4nHkgvT6/KvBsJPLx+VlgZEVAyi8VQ7+Z3iQegJ2BabvhtDjXKH4fueGMO1kHaHOKQUp25M+9XoYe/orvXO+c6WTY/sQKpLHFuEnziL3kf/XscoRKqvEVAtKofg5cYSumllD5BIW+U4DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GPHPBrw4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GPHPBrw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAC6C43390;
	Mon, 29 Jan 2024 17:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548617;
	bh=5dc8CscW/8MIe5o5Y5OAv6MS6KjCor31n40Dgan6i3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GPHPBrw4gCyshQEGjMxqdixj3IQhcm2x11Dbr7VY9TltdSrcXP+5h+xgBrvrzGY/x
	 X3eWxJ09Gyk8qo4ufu9/eAhoIYEcXONVN4RrG8pc8V8qsfQuzlUnGMaLcA3Cgrgc63
	 wpqcDc9TW8B2OsFqx4643lzYevMD+EErg2gaEE/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Zi Yan <ziy@nvidia.com>,
	Hugh Dickins <hughd@google.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yin Fengwei <fengwei.yin@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 286/331] mm: migrate: record the mlocked page status to remove unnecessary lru drain
Date: Mon, 29 Jan 2024 09:05:50 -0800
Message-ID: <20240129170023.226103004@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit eebb3dabbb5cc590afe32880b5d3726d0fbf88db ]

When doing compaction, I found the lru_add_drain() is an obvious hotspot
when migrating pages. The distribution of this hotspot is as follows:
   - 18.75% compact_zone
      - 17.39% migrate_pages
         - 13.79% migrate_pages_batch
            - 11.66% migrate_folio_move
               - 7.02% lru_add_drain
                  + 7.02% lru_add_drain_cpu
               + 3.00% move_to_new_folio
                 1.23% rmap_walk
            + 1.92% migrate_folio_unmap
         + 3.20% migrate_pages_sync
      + 0.90% isolate_migratepages

The lru_add_drain() was added by commit c3096e6782b7 ("mm/migrate:
__unmap_and_move() push good newpage to LRU") to drain the newpage to LRU
immediately, to help to build up the correct newpage->mlock_count in
remove_migration_ptes() for mlocked pages.  However, if there are no
mlocked pages are migrating, then we can avoid this lru drain operation,
especailly for the heavy concurrent scenarios.

So we can record the source pages' mlocked status in
migrate_folio_unmap(), and only drain the lru list when the mlocked status
is set in migrate_folio_move().

In addition, the page was already isolated from lru when migrating, so
checking the mlocked status is stable by folio_test_mlocked() in
migrate_folio_unmap().

After this patch, I can see the hotpot of the lru_add_drain() is gone:
   - 9.41% migrate_pages_batch
      - 6.15% migrate_folio_move
         - 3.64% move_to_new_folio
            + 1.80% migrate_folio_extra
            + 1.70% buffer_migrate_folio
         + 1.41% rmap_walk
         + 0.62% folio_add_lru
      + 3.07% migrate_folio_unmap

Meanwhile, the compaction latency shows some improvements when running
thpscale:
                            base                   patched
Amean     fault-both-1      1131.22 (   0.00%)     1112.55 *   1.65%*
Amean     fault-both-3      2489.75 (   0.00%)     2324.15 *   6.65%*
Amean     fault-both-5      3257.37 (   0.00%)     3183.18 *   2.28%*
Amean     fault-both-7      4257.99 (   0.00%)     4079.04 *   4.20%*
Amean     fault-both-12     6614.02 (   0.00%)     6075.60 *   8.14%*
Amean     fault-both-18    10607.78 (   0.00%)     8978.86 *  15.36%*
Amean     fault-both-24    14911.65 (   0.00%)    11619.55 *  22.08%*
Amean     fault-both-30    14954.67 (   0.00%)    14925.66 *   0.19%*
Amean     fault-both-32    16654.87 (   0.00%)    15580.31 *   6.45%*

Link: https://lkml.kernel.org/r/06e9153a7a4850352ec36602df3a3a844de45698.1697859741.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: d1adb25df711 ("mm: migrate: fix getting incorrect page mapping during page migration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/migrate.c | 48 +++++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 19 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 03bc2063ac87..3373fc1c2d0f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1035,22 +1035,28 @@ union migration_ptr {
 	struct anon_vma *anon_vma;
 	struct address_space *mapping;
 };
+
+enum {
+	PAGE_WAS_MAPPED = BIT(0),
+	PAGE_WAS_MLOCKED = BIT(1),
+};
+
 static void __migrate_folio_record(struct folio *dst,
-				   unsigned long page_was_mapped,
+				   unsigned long old_page_state,
 				   struct anon_vma *anon_vma)
 {
 	union migration_ptr ptr = { .anon_vma = anon_vma };
 	dst->mapping = ptr.mapping;
-	dst->private = (void *)page_was_mapped;
+	dst->private = (void *)old_page_state;
 }
 
 static void __migrate_folio_extract(struct folio *dst,
-				   int *page_was_mappedp,
+				   int *old_page_state,
 				   struct anon_vma **anon_vmap)
 {
 	union migration_ptr ptr = { .mapping = dst->mapping };
 	*anon_vmap = ptr.anon_vma;
-	*page_was_mappedp = (unsigned long)dst->private;
+	*old_page_state = (unsigned long)dst->private;
 	dst->mapping = NULL;
 	dst->private = NULL;
 }
@@ -1111,7 +1117,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 {
 	struct folio *dst;
 	int rc = -EAGAIN;
-	int page_was_mapped = 0;
+	int old_page_state = 0;
 	struct anon_vma *anon_vma = NULL;
 	bool is_lru = !__PageMovable(&src->page);
 	bool locked = false;
@@ -1165,6 +1171,8 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		folio_lock(src);
 	}
 	locked = true;
+	if (folio_test_mlocked(src))
+		old_page_state |= PAGE_WAS_MLOCKED;
 
 	if (folio_test_writeback(src)) {
 		/*
@@ -1214,7 +1222,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	dst_locked = true;
 
 	if (unlikely(!is_lru)) {
-		__migrate_folio_record(dst, page_was_mapped, anon_vma);
+		__migrate_folio_record(dst, old_page_state, anon_vma);
 		return MIGRATEPAGE_UNMAP;
 	}
 
@@ -1240,11 +1248,11 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
 			       !folio_test_ksm(src) && !anon_vma, src);
 		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
-		page_was_mapped = 1;
+		old_page_state |= PAGE_WAS_MAPPED;
 	}
 
 	if (!folio_mapped(src)) {
-		__migrate_folio_record(dst, page_was_mapped, anon_vma);
+		__migrate_folio_record(dst, old_page_state, anon_vma);
 		return MIGRATEPAGE_UNMAP;
 	}
 
@@ -1256,7 +1264,8 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	if (rc == -EAGAIN)
 		ret = NULL;
 
-	migrate_folio_undo_src(src, page_was_mapped, anon_vma, locked, ret);
+	migrate_folio_undo_src(src, old_page_state & PAGE_WAS_MAPPED,
+			       anon_vma, locked, ret);
 	migrate_folio_undo_dst(dst, dst_locked, put_new_folio, private);
 
 	return rc;
@@ -1269,12 +1278,12 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 			      struct list_head *ret)
 {
 	int rc;
-	int page_was_mapped = 0;
+	int old_page_state = 0;
 	struct anon_vma *anon_vma = NULL;
 	bool is_lru = !__PageMovable(&src->page);
 	struct list_head *prev;
 
-	__migrate_folio_extract(dst, &page_was_mapped, &anon_vma);
+	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
 	prev = dst->lru.prev;
 	list_del(&dst->lru);
 
@@ -1295,10 +1304,10 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	 * isolated from the unevictable LRU: but this case is the easiest.
 	 */
 	folio_add_lru(dst);
-	if (page_was_mapped)
+	if (old_page_state & PAGE_WAS_MLOCKED)
 		lru_add_drain();
 
-	if (page_was_mapped)
+	if (old_page_state & PAGE_WAS_MAPPED)
 		remove_migration_ptes(src, dst, false);
 
 out_unlock_both:
@@ -1330,11 +1339,12 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	 */
 	if (rc == -EAGAIN) {
 		list_add(&dst->lru, prev);
-		__migrate_folio_record(dst, page_was_mapped, anon_vma);
+		__migrate_folio_record(dst, old_page_state, anon_vma);
 		return rc;
 	}
 
-	migrate_folio_undo_src(src, page_was_mapped, anon_vma, true, ret);
+	migrate_folio_undo_src(src, old_page_state & PAGE_WAS_MAPPED,
+			       anon_vma, true, ret);
 	migrate_folio_undo_dst(dst, true, put_new_folio, private);
 
 	return rc;
@@ -1802,12 +1812,12 @@ static int migrate_pages_batch(struct list_head *from,
 	dst = list_first_entry(&dst_folios, struct folio, lru);
 	dst2 = list_next_entry(dst, lru);
 	list_for_each_entry_safe(folio, folio2, &unmap_folios, lru) {
-		int page_was_mapped = 0;
+		int old_page_state = 0;
 		struct anon_vma *anon_vma = NULL;
 
-		__migrate_folio_extract(dst, &page_was_mapped, &anon_vma);
-		migrate_folio_undo_src(folio, page_was_mapped, anon_vma,
-				       true, ret_folios);
+		__migrate_folio_extract(dst, &old_page_state, &anon_vma);
+		migrate_folio_undo_src(folio, old_page_state & PAGE_WAS_MAPPED,
+				       anon_vma, true, ret_folios);
 		list_del(&dst->lru);
 		migrate_folio_undo_dst(dst, true, put_new_folio, private);
 		dst = dst2;
-- 
2.43.0



