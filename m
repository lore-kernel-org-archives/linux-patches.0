Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5CA3BBF0;
	Wed,  4 Feb 2026 15:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217244; cv=none; b=gujgCEHeevlyveAQGryqADh+eJ010evrtFuiTMNFO1qAquUDiIGnHB6v7clqcqkfmAyuKAjtZmGEGzlQZkaZdc/QeRUxWpmIG1ALRpr1ZXz+rIZQtm8HT2e16oVP9wzmuBPGzm0yu4/5AhmLSwnyKe+UDn2brvC6unfCXIezWSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217244; c=relaxed/simple;
	bh=2lnDUk4E3M7SbgyaE/HDRIiDwhMSHHni471Z6zCtM2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=quZiBlt+NpMkSHb8trDzqNJKSVX2z5oJOfkDxx1VScB7Wr8t/kw5p8rfbRdi7Hs0OSqmkeJ0mn86gKaynjS5/czrkwEsF+VxLlKMsuPTaTAxl6h6/VYqc1F0QK9oW6IkqZdoXmolFpIt1zQZurwXiH4qWBQtvfViunQJUyY814U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FyLwhbjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FyLwhbjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654E4C116C6;
	Wed,  4 Feb 2026 15:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217244;
	bh=2lnDUk4E3M7SbgyaE/HDRIiDwhMSHHni471Z6zCtM2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FyLwhbjPrJHlpQeTUyTxGL1boVHTVJIW/gJTasAKiw5wJpHztvMySoHww2Cem5MCF
	 x6hb26/4Vkinn9bCUuk84hklBg7Oy35oM4DA8yc2Jrv5XQ1MCM0HIkQ7FY35xAue/S
	 T3uJ4Aeh/Ah9IfmRjr4WdVkY5loHW2ZJ6JdcnvA4=
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
Subject: [PATCH 5.15 132/206] migrate: correct lock ordering for hugetlb file folios
Date: Wed,  4 Feb 2026 15:39:23 +0100
Message-ID: <20260204143902.952540683@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1291,6 +1291,7 @@ static int unmap_and_move_huge_page(new_
 	struct page *new_hpage;
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
+	enum ttu_flags ttu = 0;
 
 	/*
 	 * Migratability of hugepages depends on architectures and their size.
@@ -1344,9 +1345,6 @@ static int unmap_and_move_huge_page(new_
 		goto put_anon;
 
 	if (page_mapped(hpage)) {
-		bool mapping_locked = false;
-		enum ttu_flags ttu = 0;
-
 		if (!PageAnon(hpage)) {
 			/*
 			 * In shared mappings, try_to_unmap could potentially
@@ -1358,15 +1356,11 @@ static int unmap_and_move_huge_page(new_
 			if (unlikely(!mapping))
 				goto unlock_put_anon;
 
-			mapping_locked = true;
 			ttu |= TTU_RMAP_LOCKED;
 		}
 
 		try_to_migrate(hpage, ttu);
 		page_was_mapped = 1;
-
-		if (mapping_locked)
-			i_mmap_unlock_write(mapping);
 	}
 
 	if (!page_mapped(hpage))
@@ -1374,7 +1368,11 @@ static int unmap_and_move_huge_page(new_
 
 	if (page_was_mapped)
 		remove_migration_ptes(hpage,
-			rc == MIGRATEPAGE_SUCCESS ? new_hpage : hpage, false);
+			rc == MIGRATEPAGE_SUCCESS ? new_hpage : hpage,
+				ttu ? true : false);
+
+	if (ttu & TTU_RMAP_LOCKED)
+		i_mmap_unlock_write(mapping);
 
 unlock_put_anon:
 	unlock_page(new_hpage);


