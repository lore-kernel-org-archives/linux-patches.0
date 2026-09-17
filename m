Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E233D9523;
	Thu, 17 Sep 2026 18:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671496; cv=none; b=r4xZj7bI5um1OZpqV0vuvxwcGwFqow1BSfg7MWHIxzSGYY/oIr4f0bVgKcXQQUOmplRwOIcC11LvaGSqGTAUd8OYl76uOEHA3E+ZiD3An7ahtidA0ztr3jUDzSs8uHwErcqw2yxMC3klNtu2H6RKeMezWHCxmtQjAArPE8NrPMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671496; c=relaxed/simple;
	bh=tpX4Sp3gBxFyA7cZwHHkCH+sLh+/v/WLsymhjLjg6WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbYVNlovnnzSySD62RbztQQU54HiqLw3QhisPsKuyHDJNkidw6piY1zFq7L+U1yyU5sIlq4g8gm4+edP6nYCJ8hLL5d8gdSzVYzkqSXDbxfmxmNaUO5JEuBCKdvRhpzEx/JUbSb6TOqdTMCDJ3NEjXEmhTS7wufoo1xJUMu6WWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgVrQE4x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgVrQE4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C431F000FF;
	Thu, 17 Sep 2026 18:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671495;
	bh=6nuIs3VeitIT5ZWjtmTWUZvO1AHzD3a/aB5zDH0SV9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XgVrQE4xY41RjLDMiCNJUzOLdnQ/Ru/tDS3+KidGKZqivN/y4ZzeXv763LqUdrAnJ
	 F3jL/3B3ie6/lHDHRWfAsBCOp7TcPAD8QaCiy64WFpz5pQB2zCG+k5DvHFiup1EKNt
	 51nzUznFiIiBEUqIyJEJmENTufqhM9VsWjzV/5oI=
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
Subject: [PATCH 6.12 0994/1102] mm/mglru: reset page lru tier bits when activating
Date: Thu, 17 Sep 2026 16:15:37 +0100
Message-ID: <20260917151605.673956884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm_inline.h |   15 ++++++++++++++-
 include/linux/mmzone.h    |    2 ++
 mm/vmscan.c               |    8 ++++----
 3 files changed, 20 insertions(+), 5 deletions(-)

--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -155,6 +155,11 @@ static inline int folio_lru_refs(struct
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
@@ -222,6 +227,7 @@ static inline bool lru_gen_add_folio(str
 {
 	unsigned long seq;
 	unsigned long flags;
+	unsigned long mask;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
@@ -257,7 +263,14 @@ static inline bool lru_gen_add_folio(str
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
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -403,6 +403,8 @@ enum {
 	NR_LRU_GEN_CAPS
 };
 
+#define LRU_REFS_FLAGS		(BIT(PG_referenced) | BIT(PG_workingset))
+
 #define MIN_LRU_BATCH		BITS_PER_LONG
 #define MAX_LRU_BATCH		(MIN_LRU_BATCH * 64)
 
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2625,8 +2625,6 @@ static bool should_clear_pmd_young(void)
  *                          shorthand helpers
  ******************************************************************************/
 
-#define LRU_REFS_FLAGS	(BIT(PG_referenced) | BIT(PG_workingset))
-
 #define DEFINE_MAX_SEQ(lruvec)						\
 	unsigned long max_seq = READ_ONCE((lruvec)->lrugen.max_seq)
 
@@ -4157,8 +4155,10 @@ bool lru_gen_look_around(struct page_vma
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
@@ -4400,7 +4400,7 @@ static bool isolate_folio(struct lruvec
 
 	/* see the comment on MAX_NR_TIERS */
 	if (!folio_test_referenced(folio))
-		set_mask_bits(&folio->flags, LRU_REFS_MASK | LRU_REFS_FLAGS, 0);
+		folio_clear_lru_refs(folio);
 
 	/* for shrink_folio_list() */
 	folio_clear_reclaim(folio);


