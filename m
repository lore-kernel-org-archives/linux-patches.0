Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA63146D53;
	Wed, 28 Jan 2026 15:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615931; cv=none; b=DVlcZfm3wqF/+D2R+MCorvkp8UBaZ6cC5fInjfPQPON2qudzfbicNEaKnN/NgB+DOW439M/GfeNSHaHWeZEBXW3zjv3TPa2whvR2bya61F9FziYY/svEd4Dq6WQyQy3O1LfBAtP55jGnDtuar2jzeAhaa7vAl/kSjoKd3fEvOhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615931; c=relaxed/simple;
	bh=FHjPgjWB4rtkBGNtuAIHjZdKnT69EzI0u+N+H9TdNxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVAy3zN0Kj+0f5TIcFMDaHtBDL0kPpY1fpBTgtgFic1aFlmF0hJXP9gGwjd6KaWQJu5H5Z6GrU8l5gEx3D8YeKUwU3KrGPWKyu50yWdNCYl4ItWK91yOYAKk+Gp/K/nnN6kJlgAZ/MNm1smLPAJ2oQ7PqO1R3z8SwWoZ2+9aD6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHnuWexQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHnuWexQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD21C4CEF1;
	Wed, 28 Jan 2026 15:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615931;
	bh=FHjPgjWB4rtkBGNtuAIHjZdKnT69EzI0u+N+H9TdNxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHnuWexQjUcza4ZJTohYNtt+GgElxy1bV1GMk1PTSglFJmmnvgq/ND+L8ZQ0AvA+A
	 W+vVhunrcu0stsrNWFrRrOXQ5MxRKpVskLDtPhjnDXgjnOATiSAguK+ladpe+i+6zQ
	 tmO7v/Iw8U0JxTsSrvOZ4cGT6YOKCMVuaBssIxHQ=
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
Subject: [PATCH 6.18 156/227] migrate: correct lock ordering for hugetlb file folios
Date: Wed, 28 Jan 2026 16:23:21 +0100
Message-ID: <20260128145350.067006727@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 mm/migrate.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1450,6 +1450,7 @@ static int unmap_and_move_huge_page(new_
 	int page_was_mapped = 0;
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
+	enum ttu_flags ttu = 0;
 
 	if (folio_ref_count(src) == 1) {
 		/* page was freed from under us. So we are done. */
@@ -1490,8 +1491,6 @@ static int unmap_and_move_huge_page(new_
 		goto put_anon;
 
 	if (folio_mapped(src)) {
-		enum ttu_flags ttu = 0;
-
 		if (!folio_test_anon(src)) {
 			/*
 			 * In shared mappings, try_to_unmap could potentially
@@ -1508,16 +1507,17 @@ static int unmap_and_move_huge_page(new_
 
 		try_to_migrate(src, ttu);
 		page_was_mapped = 1;
-
-		if (ttu & TTU_RMAP_LOCKED)
-			i_mmap_unlock_write(mapping);
 	}
 
 	if (!folio_mapped(src))
 		rc = move_to_new_folio(dst, src, mode);
 
 	if (page_was_mapped)
-		remove_migration_ptes(src, !rc ? dst : src, 0);
+		remove_migration_ptes(src, !rc ? dst : src,
+				ttu ? RMP_LOCKED : 0);
+
+	if (ttu & TTU_RMAP_LOCKED)
+		i_mmap_unlock_write(mapping);
 
 unlock_put_anon:
 	folio_unlock(dst);


