Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345547404E;
	Sat, 17 Oct 2026 16:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254828; cv=none; b=PRLgh9sqgbTmA1a6Dxjr2Xo7ABVO6YQatQ3fXJwjZ6tbcy3I3RQKvNX/bwxJajeoUJlaG8NFMZtD4AdfI2hn9xcWyxxztTGGbdyNfurv5qLWvDaFSz++Ieh1zcAx+DOrUkGRja6MXdLVS01w1xj6TnBcM508hjILhsgX0p3L1pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254828; c=relaxed/simple;
	bh=TB/m5nMCfpBSDfHgBUobA0COspoR3N6eL77nZnS9rHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ol0pUefxg4dh9q1/qIAgmY9dkp9xTHevWT8i4jStmmt4Li69/4jjx42eVGSNP9jvFpbq5P0rprGiZSBwQMHDXc9xrd8gvkVEUtMkYVtFIAHyvu2Gbqv93LiXUjCfVtCsdwH1iJeJBbqyCwKqROwmoHCAkZ/hxtn9Q2v2A5hy5Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vIBSEXri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vIBSEXri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B971F000C4;
	Sat, 17 Oct 2026 16:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254827;
	bh=O39xDbSQEeBQ1K5lPXHOoUiT6892Isx7t44vmkrYiQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vIBSEXriIixiWSLKIJUCnkurVSI1Eg9qEGrd5bG5DLCbH6ilG8K4rZQfmBKRdurzx
	 N4YHGGmyQ8UWuwsCeVkPfnVgTng6sa8ULngEbF7++CJljEa1MMTaWrLurLJ/fIbmKi
	 QzHoEYXWZu3WYb+X7wnI9ZxvyyVAbjJXXHTHKINs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Xu <weixugc@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Brian Geffon <bgeffon@google.com>,
	Jan Alexander Steffens <heftig@archlinux.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 576/869] mm/mglru: reset page lru tier bits when activating
Date: Sat, 17 Oct 2026 17:56:57 +0200
Message-ID: <20261017160051.829328794@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Xu <weixugc@google.com>

[ Upstream commit f1001f3d3b6868998cab73d10fda1a5c99ddf963 ]

When a folio is activated, lru_gen_add_folio() moves the folio to the
youngest generation.  But unlike folio_update_gen()/folio_inc_gen(),
lru_gen_add_folio() doesn't reset the folio lru tier bits (LRU_REFS_MASK |
LRU_REFS_FLAGS).  This inconsistency can affect how pages are aged via
folio_mark_accessed() (e.g.  fd accesses), though no user visible impact
related to this has been detected yet.

Note that lru_gen_add_folio() cannot clear PG_workingset if the activation
is due to workingset refault, otherwise PSI accounting will be skipped.
So fix lru_gen_add_folio() to clear the lru tier bits other than
PG_workingset when activating a folio, and also clear all the lru tier
bits when a folio is activated via folio_activate() in
lru_gen_look_around().

Link: https://lkml.kernel.org/r/20241017181528.3358821-1-weixugc@google.com
Fixes: 018ee47f1489 ("mm: multi-gen LRU: exploit locality in rmap")
Signed-off-by: Wei Xu <weixugc@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jan Alexander Steffens <heftig@archlinux.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: f7e698e326b2 ("mm/mglru: fix and remove redundant unevictable folio handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm_inline.h | 15 ++++++++++++++-
 include/linux/mmzone.h    |  2 ++
 mm/vmscan.c               |  8 ++++----
 3 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index f4fe593c1400e..622dfe2545d79 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -155,6 +155,11 @@ static inline int folio_lru_refs(struct folio *folio)
 	return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + workingset;
 }
 
+static inline void folio_clear_lru_refs(struct folio *folio)
+{
+	set_mask_bits(&folio->flags, LRU_REFS_MASK | LRU_REFS_FLAGS, 0);
+}
+
 static inline int folio_lru_gen(struct folio *folio)
 {
 	unsigned long flags = READ_ONCE(folio->flags);
@@ -222,6 +227,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 {
 	unsigned long seq;
 	unsigned long flags;
+	unsigned long mask;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
@@ -257,7 +263,14 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 	gen = lru_gen_from_seq(seq);
 	flags = (gen + 1UL) << LRU_GEN_PGOFF;
 	/* see the comment on MIN_NR_GENS about PG_active */
-	set_mask_bits(&folio->flags, LRU_GEN_MASK | BIT(PG_active), flags);
+	mask = LRU_GEN_MASK;
+	/*
+	 * Don't clear PG_workingset here because it can affect PSI accounting
+	 * if the activation is due to workingset refault.
+	 */
+	if (folio_test_active(folio))
+		mask |= LRU_REFS_MASK | BIT(PG_referenced) | BIT(PG_active);
+	set_mask_bits(&folio->flags, mask, flags);
 
 	lru_gen_update_size(lruvec, folio, -1, gen);
 	/* for folio_rotate_reclaimable() */
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 8f932c4350fcb..9d52485541529 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -403,6 +403,8 @@ enum {
 	NR_LRU_GEN_CAPS
 };
 
+#define LRU_REFS_FLAGS		(BIT(PG_referenced) | BIT(PG_workingset))
+
 #define MIN_LRU_BATCH		BITS_PER_LONG
 #define MAX_LRU_BATCH		(MIN_LRU_BATCH * 64)
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4c13524afaaaf..460943a562c92 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2625,8 +2625,6 @@ static bool should_clear_pmd_young(void)
  *                          shorthand helpers
  ******************************************************************************/
 
-#define LRU_REFS_FLAGS	(BIT(PG_referenced) | BIT(PG_workingset))
-
 #define DEFINE_MAX_SEQ(lruvec)						\
 	unsigned long max_seq = READ_ONCE((lruvec)->lrugen.max_seq)
 
@@ -4157,8 +4155,10 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 		old_gen = folio_lru_gen(folio);
 		if (old_gen < 0)
 			folio_set_referenced(folio);
-		else if (old_gen != new_gen)
+		else if (old_gen != new_gen) {
+			folio_clear_lru_refs(folio);
 			folio_activate(folio);
+		}
 	}
 
 	arch_leave_lazy_mmu_mode();
@@ -4400,7 +4400,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 	/* see the comment on MAX_NR_TIERS */
 	if (!folio_test_referenced(folio))
-		set_mask_bits(&folio->flags, LRU_REFS_MASK | LRU_REFS_FLAGS, 0);
+		folio_clear_lru_refs(folio);
 
 	/* for shrink_folio_list() */
 	folio_clear_reclaim(folio);
-- 
2.53.0



