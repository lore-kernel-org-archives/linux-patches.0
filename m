Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABC31A592
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EUSvA6n1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3E8C433C8;
	Mon,  9 Oct 2023 13:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857381;
	bh=FCxVJvS/h+un1gTQyIl6GpAm8hsgQ7URAD7jOCodVcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EUSvA6n1n4I4L7LTA8JQVCSlJTWidEJxACs6t08r65pTSdMegNz1p4YMfSYg+nQa9
	 ClvTp9Z89ISI15rF5CtAoRmPDqYvyuq3Ih0/176gx1fSU6G8gLcUWbUDmF4F7G8q/F
	 kl8s8TMfRPygygj9Jj1HY6Pg/hav2siwbqaYsN8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Shi <yang@os.amperecomputing.com>,
	Hugh Dickins <hughd@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Oscar Salvador <osalvador@suse.de>,
	Rafael Aquini <aquini@redhat.com>,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
	David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/162] mm: mempolicy: keep VMA walk if both MPOL_MF_STRICT and MPOL_MF_MOVE are specified
Date: Mon,  9 Oct 2023 15:00:09 +0200
Message-ID: <20231009130123.722749944@linuxfoundation.org>
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

From: Yang Shi <yang@os.amperecomputing.com>

[ Upstream commit 24526268f4e38c9ec0c4a30de4f37ad2a2a84e47 ]

When calling mbind() with MPOL_MF_{MOVE|MOVEALL} | MPOL_MF_STRICT, kernel
should attempt to migrate all existing pages, and return -EIO if there is
misplaced or unmovable page.  Then commit 6f4576e3687b ("mempolicy: apply
page table walker on queue_pages_range()") messed up the return value and
didn't break VMA scan early ianymore when MPOL_MF_STRICT alone.  The
return value problem was fixed by commit a7f40cfe3b7a ("mm: mempolicy:
make mbind() return -EIO when MPOL_MF_STRICT is specified"), but it broke
the VMA walk early if unmovable page is met, it may cause some pages are
not migrated as expected.

The code should conceptually do:

 if (MPOL_MF_MOVE|MOVEALL)
     scan all vmas
     try to migrate the existing pages
     return success
 else if (MPOL_MF_MOVE* | MPOL_MF_STRICT)
     scan all vmas
     try to migrate the existing pages
     return -EIO if unmovable or migration failed
 else /* MPOL_MF_STRICT alone */
     break early if meets unmovable and don't call mbind_range() at all
 else /* none of those flags */
     check the ranges in test_walk, EFAULT without mbind_range() if discontig.

Fixed the behavior.

Link: https://lkml.kernel.org/r/20230920223242.3425775-1-yang@os.amperecomputing.com
Fixes: a7f40cfe3b7a ("mm: mempolicy: make mbind() return -EIO when MPOL_MF_STRICT is specified")
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>	[4.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mempolicy.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 158b0bcd12fd7..bfe2d1d50fbee 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -424,6 +424,7 @@ struct queue_pages {
 	unsigned long start;
 	unsigned long end;
 	struct vm_area_struct *first;
+	bool has_unmovable;
 };
 
 /*
@@ -444,9 +445,8 @@ static inline bool queue_pages_required(struct page *page,
 /*
  * queue_folios_pmd() has three possible return values:
  * 0 - folios are placed on the right node or queued successfully, or
- *     special page is met, i.e. huge zero page.
- * 1 - there is unmovable folio, and MPOL_MF_MOVE* & MPOL_MF_STRICT were
- *     specified.
+ *     special page is met, i.e. zero page, or unmovable page is found
+ *     but continue walking (indicated by queue_pages.has_unmovable).
  * -EIO - is migration entry or only MPOL_MF_STRICT was specified and an
  *        existing folio was already on a node that does not follow the
  *        policy.
@@ -477,7 +477,7 @@ static int queue_folios_pmd(pmd_t *pmd, spinlock_t *ptl, unsigned long addr,
 	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
 		if (!vma_migratable(walk->vma) ||
 		    migrate_folio_add(folio, qp->pagelist, flags)) {
-			ret = 1;
+			qp->has_unmovable = true;
 			goto unlock;
 		}
 	} else
@@ -493,9 +493,8 @@ static int queue_folios_pmd(pmd_t *pmd, spinlock_t *ptl, unsigned long addr,
  *
  * queue_folios_pte_range() has three possible return values:
  * 0 - folios are placed on the right node or queued successfully, or
- *     special page is met, i.e. zero page.
- * 1 - there is unmovable folio, and MPOL_MF_MOVE* & MPOL_MF_STRICT were
- *     specified.
+ *     special page is met, i.e. zero page, or unmovable page is found
+ *     but continue walking (indicated by queue_pages.has_unmovable).
  * -EIO - only MPOL_MF_STRICT was specified and an existing folio was already
  *        on a node that does not follow the policy.
  */
@@ -506,7 +505,6 @@ static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
 	struct folio *folio;
 	struct queue_pages *qp = walk->private;
 	unsigned long flags = qp->flags;
-	bool has_unmovable = false;
 	pte_t *pte, *mapped_pte;
 	spinlock_t *ptl;
 
@@ -533,11 +531,12 @@ static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
 		if (!queue_pages_required(&folio->page, qp))
 			continue;
 		if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
-			/* MPOL_MF_STRICT must be specified if we get here */
-			if (!vma_migratable(vma)) {
-				has_unmovable = true;
-				break;
-			}
+			/*
+			 * MPOL_MF_STRICT must be specified if we get here.
+			 * Continue walking vmas due to MPOL_MF_MOVE* flags.
+			 */
+			if (!vma_migratable(vma))
+				qp->has_unmovable = true;
 
 			/*
 			 * Do not abort immediately since there may be
@@ -545,16 +544,13 @@ static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
 			 * need migrate other LRU pages.
 			 */
 			if (migrate_folio_add(folio, qp->pagelist, flags))
-				has_unmovable = true;
+				qp->has_unmovable = true;
 		} else
 			break;
 	}
 	pte_unmap_unlock(mapped_pte, ptl);
 	cond_resched();
 
-	if (has_unmovable)
-		return 1;
-
 	return addr != end ? -EIO : 0;
 }
 
@@ -594,7 +590,7 @@ static int queue_pages_hugetlb(pte_t *pte, unsigned long hmask,
 		 * Detecting misplaced page but allow migrating pages which
 		 * have been queued.
 		 */
-		ret = 1;
+		qp->has_unmovable = true;
 		goto unlock;
 	}
 
@@ -608,7 +604,7 @@ static int queue_pages_hugetlb(pte_t *pte, unsigned long hmask,
 			 * Failed to isolate page but allow migrating pages
 			 * which have been queued.
 			 */
-			ret = 1;
+			qp->has_unmovable = true;
 	}
 unlock:
 	spin_unlock(ptl);
@@ -737,10 +733,13 @@ queue_pages_range(struct mm_struct *mm, unsigned long start, unsigned long end,
 		.start = start,
 		.end = end,
 		.first = NULL,
+		.has_unmovable = false,
 	};
 
 	err = walk_page_range(mm, start, end, &queue_pages_walk_ops, &qp);
 
+	if (qp.has_unmovable)
+		err = 1;
 	if (!qp.first)
 		/* whole range in hole */
 		err = -EFAULT;
@@ -1338,7 +1337,7 @@ static long do_mbind(unsigned long start, unsigned long len,
 				putback_movable_pages(&pagelist);
 		}
 
-		if ((ret > 0) || (nr_failed && (flags & MPOL_MF_STRICT)))
+		if (((ret > 0) || nr_failed) && (flags & MPOL_MF_STRICT))
 			err = -EIO;
 	} else {
 up_out:
-- 
2.40.1



