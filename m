Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4387472
	for <patches@lists.linux.dev>; Fri, 21 Apr 2023 21:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HAZkfNRruAgARTe618ACsQ6wCYRRSd9EZooPKA+qgbw=; b=DnGs3ejEo/+K910m27ugy2zmJh
	qb5mcLlEfR2wdQNE/p1//CuFDbtuczZKd7j27Gu+GCzFIVBmDmCr5B7yxLhtPcDngNB4k80THHDuR
	w2DMyrzuDU9msgM7Zy+oghoVKusNkUcBRoJC/pAS7Cc8RxdQEaVjJ+Bd2tc6Z6+C7gpfmYibKo708
	Vi5Tb7IXkNa4kvn4N3d3BddjBa5cCKcG9E33SvWZ4GkM7ZwxcmNuAPg77qD1HGAf/ilG221q1rmJ5
	9ejkkgHgonznxoi20BOMaCnyIcdksGRblL0lJg1XSWnZUtylSqq5ykxsRsCRkUyoDucbBY5Vd4B0h
	p73Bmwcw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1ppyY1-00Btoi-1l;
	Fri, 21 Apr 2023 21:44:05 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: hughd@google.com,
	akpm@linux-foundation.org,
	willy@infradead.org,
	brauner@kernel.org,
	djwong@kernel.org
Cc: p.raghav@samsung.com,
	da.gomez@samsung.com,
	a.manzanares@samsung.com,
	dave@stgolabs.net,
	yosryahmed@google.com,
	keescook@chromium.org,
	hare@suse.de,
	kbusch@kernel.org,
	mcgrof@kernel.org,
	patches@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC 1/8] shmem: replace BLOCKS_PER_PAGE with PAGE_SECTORS
Date: Fri, 21 Apr 2023 14:43:53 -0700
Message-Id: <20230421214400.2836131-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230421214400.2836131-1-mcgrof@kernel.org>
References: <20230421214400.2836131-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Instead of having our own macro use the generic PAGE_SECTORS.
It also makes it clearer what we are trying to compute here on
the inode->i_blocks. We get the inode size by as define din
__inode_get_bytes() by:

(inode->i_blocks << SECTOR_SHIFT) + inode->i_bytes

This produces no functional changes.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 mm/shmem.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b5d102a2a766..5bf92d571092 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -86,7 +86,6 @@ static struct vfsmount *shm_mnt;
 
 #include "internal.h"
 
-#define BLOCKS_PER_PAGE  (PAGE_SIZE/512)
 #define VM_ACCT(size)    (PAGE_ALIGN(size) >> PAGE_SHIFT)
 
 /* Pretend that each entry is of this size in directory's i_size */
@@ -363,7 +362,7 @@ static void shmem_recalc_inode(struct inode *inode)
 	freed = info->alloced - info->swapped - inode->i_mapping->nrpages;
 	if (freed > 0) {
 		info->alloced -= freed;
-		inode->i_blocks -= freed * BLOCKS_PER_PAGE;
+		inode->i_blocks -= freed * PAGE_SECTORS;
 		shmem_inode_unacct_blocks(inode, freed);
 	}
 }
@@ -381,7 +380,7 @@ bool shmem_charge(struct inode *inode, long pages)
 
 	spin_lock_irqsave(&info->lock, flags);
 	info->alloced += pages;
-	inode->i_blocks += pages * BLOCKS_PER_PAGE;
+	inode->i_blocks += pages * PAGE_SECTORS;
 	shmem_recalc_inode(inode);
 	spin_unlock_irqrestore(&info->lock, flags);
 
@@ -397,7 +396,7 @@ void shmem_uncharge(struct inode *inode, long pages)
 
 	spin_lock_irqsave(&info->lock, flags);
 	info->alloced -= pages;
-	inode->i_blocks -= pages * BLOCKS_PER_PAGE;
+	inode->i_blocks -= pages * PAGE_SECTORS;
 	shmem_recalc_inode(inode);
 	spin_unlock_irqrestore(&info->lock, flags);
 
@@ -2002,7 +2001,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 
 	spin_lock_irq(&info->lock);
 	info->alloced += folio_nr_pages(folio);
-	inode->i_blocks += (blkcnt_t)BLOCKS_PER_PAGE << folio_order(folio);
+	inode->i_blocks += (blkcnt_t) PAGE_SECTORS << folio_order(folio);
 	shmem_recalc_inode(inode);
 	spin_unlock_irq(&info->lock);
 	alloced = true;
@@ -2659,7 +2658,7 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
 
 	spin_lock_irq(&info->lock);
 	info->alloced++;
-	inode->i_blocks += BLOCKS_PER_PAGE;
+	inode->i_blocks += PAGE_SECTORS;
 	shmem_recalc_inode(inode);
 	spin_unlock_irq(&info->lock);
 
-- 
2.39.2

