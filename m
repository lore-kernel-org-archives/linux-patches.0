Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B841C291
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSHh7tI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2613BC433C8;
	Wed,  4 Oct 2023 18:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444526;
	bh=qcGq7FE8j8jXwbeSkbb5pvW39duYzmFd39h3Dsy21hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSHh7tI+prUqNGOyEKvVcZHq8zCD4DN433fP97bITKmte8Sq5S2I7zE4kP10moxrM
	 sUT1WD0WqJVfFd7SK4Y6L99BR52A09uCJUboc5/B7tlkUOqgCTQrv2j5ZdPYzWqyRh
	 ILsYWYfVqkwU9O4b4jeuedMg7cAWkEYS0T9cc24g=
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.5 282/321] mm: mempolicy: keep VMA walk if both MPOL_MF_STRICT and MPOL_MF_MOVE are specified
Date: Wed,  4 Oct 2023 19:57:07 +0200
Message-ID: <20231004175242.341407610@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Shi <yang@os.amperecomputing.com>

commit 24526268f4e38c9ec0c4a30de4f37ad2a2a84e47 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |   39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -426,6 +426,7 @@ struct queue_pages {
 	unsigned long start;
 	unsigned long end;
 	struct vm_area_struct *first;
+	bool has_unmovable;
 };
 
 /*
@@ -446,9 +447,8 @@ static inline bool queue_folio_required(
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
@@ -479,7 +479,7 @@ static int queue_folios_pmd(pmd_t *pmd,
 	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
 		if (!vma_migratable(walk->vma) ||
 		    migrate_folio_add(folio, qp->pagelist, flags)) {
-			ret = 1;
+			qp->has_unmovable = true;
 			goto unlock;
 		}
 	} else
@@ -495,9 +495,8 @@ unlock:
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
@@ -508,7 +507,6 @@ static int queue_folios_pte_range(pmd_t
 	struct folio *folio;
 	struct queue_pages *qp = walk->private;
 	unsigned long flags = qp->flags;
-	bool has_unmovable = false;
 	pte_t *pte, *mapped_pte;
 	pte_t ptent;
 	spinlock_t *ptl;
@@ -538,11 +536,12 @@ static int queue_folios_pte_range(pmd_t
 		if (!queue_folio_required(folio, qp))
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
@@ -550,16 +549,13 @@ static int queue_folios_pte_range(pmd_t
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
 
@@ -599,7 +595,7 @@ static int queue_folios_hugetlb(pte_t *p
 		 * Detecting misplaced folio but allow migrating folios which
 		 * have been queued.
 		 */
-		ret = 1;
+		qp->has_unmovable = true;
 		goto unlock;
 	}
 
@@ -620,7 +616,7 @@ static int queue_folios_hugetlb(pte_t *p
 			 * Failed to isolate folio but allow migrating pages
 			 * which have been queued.
 			 */
-			ret = 1;
+			qp->has_unmovable = true;
 	}
 unlock:
 	spin_unlock(ptl);
@@ -756,12 +752,15 @@ queue_pages_range(struct mm_struct *mm,
 		.start = start,
 		.end = end,
 		.first = NULL,
+		.has_unmovable = false,
 	};
 	const struct mm_walk_ops *ops = lock_vma ?
 			&queue_pages_lock_vma_walk_ops : &queue_pages_walk_ops;
 
 	err = walk_page_range(mm, start, end, ops, &qp);
 
+	if (qp.has_unmovable)
+		err = 1;
 	if (!qp.first)
 		/* whole range in hole */
 		err = -EFAULT;
@@ -1358,7 +1357,7 @@ static long do_mbind(unsigned long start
 				putback_movable_pages(&pagelist);
 		}
 
-		if ((ret > 0) || (nr_failed && (flags & MPOL_MF_STRICT)))
+		if (((ret > 0) || nr_failed) && (flags & MPOL_MF_STRICT))
 			err = -EIO;
 	} else {
 up_out:


