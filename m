Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C1D27FD56;
	Wed,  4 Feb 2026 14:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216517; cv=none; b=h65JC9YFJwT2SllMjf1lqS4YbUFgRd6ZfagO/jkeZV+/Y0/RfopiHkSuQEygzAKof0VJsTKjlcelZqWxIL8dgN7XusAuEI1lFgjiECoI0fYpCItL7lc8yaZ45t+3aWSX7+gfMAKPD3rnbjx5n6PfQQT3ASqqRn/drGCJp8DFtko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216517; c=relaxed/simple;
	bh=lABHIglB+ShPVkmw/4eY2TP99HxZddl2xcqUcO9BX3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSPJIJVu/vtaOn32Bl78piR0Y9dWmkkm4+9FDvqRbl1J15czcsqMT2BAqhZZJYRHjt8OkpckvuYTRjIouzxSUvtTaytswaWeSdMz9VfyFba35C8xVzDhmVXRDH6eK2IDJ4+x1m2Hb1aZIfzOZTtawK5i0PP2J3FzGeoacweL9dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eSWsZ5hf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eSWsZ5hf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF16C4CEF7;
	Wed,  4 Feb 2026 14:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216517;
	bh=lABHIglB+ShPVkmw/4eY2TP99HxZddl2xcqUcO9BX3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eSWsZ5hfu4SZJQ2xbr75F+FnGHixSdqR71pNMDrXkzFkKyovfu5+hazmaK5H3S2GO
	 8USvPGaEFG+tS+zhtuhkAtrIarj0z5nfB1jL5J+NZlQuM48LalMrLyMrdAU+kecrtJ
	 XmfNeVzcjfC8VAGSSbA38xOFvEgWyL4+2SCTB7sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Jann Horn <jannh@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Rik van Riel <riel@surriel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 5.10 112/161] migrate: correct lock ordering for hugetlb file folios
Date: Wed,  4 Feb 2026 15:39:35 +0100
Message-ID: <20260204143855.773203826@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit b7880cb166ab62c2409046b2347261abf701530e upstream.

Syzbot has found a deadlock (analyzed by Lance Yang):

1) Task (5749): Holds folio_lock, then tries to acquire i_mmap_rwsem(read lock).
2) Task (5754): Holds i_mmap_rwsem(write lock), then tries to acquire
folio_lock.

migrate_pages()
  -> migrate_hugetlbs()
    -> unmap_and_move_huge_page()     <- Takes folio_lock!
      -> remove_migration_ptes()
        -> __rmap_walk_file()
          -> i_mmap_lock_read()       <- Waits for i_mmap_rwsem(read lock)!

hugetlbfs_fallocate()
  -> hugetlbfs_punch_hole()           <- Takes i_mmap_rwsem(write lock)!
    -> hugetlbfs_zero_partial_page()
     -> filemap_lock_hugetlb_folio()
      -> filemap_lock_folio()
        -> __filemap_get_folio        <- Waits for folio_lock!

The migration path is the one taking locks in the wrong order according to
the documentation at the top of mm/rmap.c.  So expand the scope of the
existing i_mmap_lock to cover the calls to remove_migration_ptes() too.

This is (mostly) how it used to be after commit c0d0381ade79.  That was
removed by 336bf30eb765 for both file & anon hugetlb pages when it should
only have been removed for anon hugetlb pages.

Link: https://lkml.kernel.org/r/20260109041345.3863089-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Fixes: 336bf30eb765 ("hugetlbfs: fix anon huge page migration race")
Reported-by: syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/68e9715a.050a0220.1186a4.000d.GAE@google.com
Debugged-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1289,6 +1289,7 @@ static int unmap_and_move_huge_page(new_
 	struct page *new_hpage;
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
+	enum ttu_flags ttu = TTU_MIGRATION|TTU_IGNORE_MLOCK;
 
 	/*
 	 * Migratability of hugepages depends on architectures and their size.
@@ -1336,9 +1337,6 @@ static int unmap_and_move_huge_page(new_
 		goto put_anon;
 
 	if (page_mapped(hpage)) {
-		bool mapping_locked = false;
-		enum ttu_flags ttu = TTU_MIGRATION|TTU_IGNORE_MLOCK;
-
 		if (!PageAnon(hpage)) {
 			/*
 			 * In shared mappings, try_to_unmap could potentially
@@ -1350,15 +1348,11 @@ static int unmap_and_move_huge_page(new_
 			if (unlikely(!mapping))
 				goto unlock_put_anon;
 
-			mapping_locked = true;
 			ttu |= TTU_RMAP_LOCKED;
 		}
 
 		try_to_unmap(hpage, ttu);
 		page_was_mapped = 1;
-
-		if (mapping_locked)
-			i_mmap_unlock_write(mapping);
 	}
 
 	if (!page_mapped(hpage))
@@ -1366,7 +1360,11 @@ static int unmap_and_move_huge_page(new_
 
 	if (page_was_mapped)
 		remove_migration_ptes(hpage,
-			rc == MIGRATEPAGE_SUCCESS ? new_hpage : hpage, false);
+			rc == MIGRATEPAGE_SUCCESS ? new_hpage : hpage,
+				(ttu & TTU_RMAP_LOCKED) ? true : false);
+
+	if (ttu & TTU_RMAP_LOCKED)
+		i_mmap_unlock_write(mapping);
 
 unlock_put_anon:
 	unlock_page(new_hpage);


