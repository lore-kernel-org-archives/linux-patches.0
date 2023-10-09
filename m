Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EA31A5A3
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOpQBzZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30AF0C433CA;
	Mon,  9 Oct 2023 13:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857378;
	bh=w2bs9ARiW76paolouBe7wvlzk1CkQVTrj+uO8T4ZTew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nOpQBzZuBTYgQhMpvl2nbDLlzIBkZ3RgW/AoiCtxFaTAk7F5p04Bz+oTf9g8Td3gd
	 hfvCW5/6prwE1O4nVgNMkoinO3Ff1XrG727/8TQ+lR5X2wVnRgo09PEjyK71mdgpRE
	 nrhLqDFvxCrM8i4B5HzXBpAPACR+B59/RTqmG0cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Yin Fengwei <fengwei.yin@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Jane Chu <jane.chu@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/162] mm/mempolicy: convert migrate_page_add() to migrate_folio_add()
Date: Mon,  9 Oct 2023 15:00:08 +0200
Message-ID: <20231009130123.696530757@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

From: Vishal Moola (Oracle) <vishal.moola@gmail.com>

[ Upstream commit 4a64981dfee9119aa2c1f243b48f34cbbd67779c ]

Replace migrate_page_add() with migrate_folio_add().  migrate_folio_add()
does the same a migrate_page_add() but takes in a folio instead of a page.
This removes a couple of calls to compound_head().

Link: https://lkml.kernel.org/r/20230130201833.27042-7-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 24526268f4e3 ("mm: mempolicy: keep VMA walk if both MPOL_MF_STRICT and MPOL_MF_MOVE are specified")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mempolicy.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 2ae6c8f18aba1..158b0bcd12fd7 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -414,7 +414,7 @@ static const struct mempolicy_operations mpol_ops[MPOL_MAX] = {
 	},
 };
 
-static int migrate_page_add(struct page *page, struct list_head *pagelist,
+static int migrate_folio_add(struct folio *folio, struct list_head *foliolist,
 				unsigned long flags);
 
 struct queue_pages {
@@ -476,7 +476,7 @@ static int queue_folios_pmd(pmd_t *pmd, spinlock_t *ptl, unsigned long addr,
 	/* go to folio migration */
 	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
 		if (!vma_migratable(walk->vma) ||
-		    migrate_page_add(&folio->page, qp->pagelist, flags)) {
+		    migrate_folio_add(folio, qp->pagelist, flags)) {
 			ret = 1;
 			goto unlock;
 		}
@@ -544,7 +544,7 @@ static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
 			 * temporary off LRU pages in the range.  Still
 			 * need migrate other LRU pages.
 			 */
-			if (migrate_page_add(&folio->page, qp->pagelist, flags))
+			if (migrate_folio_add(folio, qp->pagelist, flags))
 				has_unmovable = true;
 		} else
 			break;
@@ -1012,27 +1012,28 @@ static long do_get_mempolicy(int *policy, nodemask_t *nmask,
 }
 
 #ifdef CONFIG_MIGRATION
-/*
- * page migration, thp tail pages can be passed.
- */
-static int migrate_page_add(struct page *page, struct list_head *pagelist,
+static int migrate_folio_add(struct folio *folio, struct list_head *foliolist,
 				unsigned long flags)
 {
-	struct page *head = compound_head(page);
 	/*
-	 * Avoid migrating a page that is shared with others.
+	 * We try to migrate only unshared folios. If it is shared it
+	 * is likely not worth migrating.
+	 *
+	 * To check if the folio is shared, ideally we want to make sure
+	 * every page is mapped to the same process. Doing that is very
+	 * expensive, so check the estimated mapcount of the folio instead.
 	 */
-	if ((flags & MPOL_MF_MOVE_ALL) || page_mapcount(head) == 1) {
-		if (!isolate_lru_page(head)) {
-			list_add_tail(&head->lru, pagelist);
-			mod_node_page_state(page_pgdat(head),
-				NR_ISOLATED_ANON + page_is_file_lru(head),
-				thp_nr_pages(head));
+	if ((flags & MPOL_MF_MOVE_ALL) || folio_estimated_sharers(folio) == 1) {
+		if (!folio_isolate_lru(folio)) {
+			list_add_tail(&folio->lru, foliolist);
+			node_stat_mod_folio(folio,
+				NR_ISOLATED_ANON + folio_is_file_lru(folio),
+				folio_nr_pages(folio));
 		} else if (flags & MPOL_MF_STRICT) {
 			/*
-			 * Non-movable page may reach here.  And, there may be
-			 * temporary off LRU pages or non-LRU movable pages.
-			 * Treat them as unmovable pages since they can't be
+			 * Non-movable folio may reach here.  And, there may be
+			 * temporary off LRU folios or non-LRU movable folios.
+			 * Treat them as unmovable folios since they can't be
 			 * isolated, so they can't be moved at the moment.  It
 			 * should return -EIO for this case too.
 			 */
@@ -1224,7 +1225,7 @@ static struct page *new_page(struct page *page, unsigned long start)
 }
 #else
 
-static int migrate_page_add(struct page *page, struct list_head *pagelist,
+static int migrate_folio_add(struct folio *folio, struct list_head *foliolist,
 				unsigned long flags)
 {
 	return -EIO;
-- 
2.40.1



