Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F177C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F83CC4339C;
	Mon, 24 Apr 2023 13:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342827;
	bh=Xj4DRvcX19MNepCASaZl+BCakrl1v12ik4BItkJJrB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srg4oXhqY4pqLpxl8bXlbdIlkFuYksdzyZCHZDSHxyk/pxjZg3KmOwaRdzBUGYzfj
	 6WGHjVHbsG8lJLf3HUFnotYeYbakl7Rx1PBnWO2bA7ItHGXtxja/jf9jM6D9n0jJog
	 rVGJj+na8V045OMyr8xAyc1B5Lek7fojuL+Tf2Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 72/98] mm/userfaultfd: fix uffd-wp handling for THP migration entries
Date: Mon, 24 Apr 2023 15:17:35 +0200
Message-Id: <20230424131136.653552597@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Hildenbrand <david@redhat.com>

commit 24bf08c4376be417f16ceb609188b16f461b0443 upstream.

Looks like what we fixed for hugetlb in commit 44f86392bdd1 ("mm/hugetlb:
fix uffd-wp handling for migration entries in
hugetlb_change_protection()") similarly applies to THP.

Setting/clearing uffd-wp on THP migration entries is not implemented
properly.  Further, while removing migration PMDs considers the uffd-wp
bit, inserting migration PMDs does not consider the uffd-wp bit.

We have to set/clear independently of the migration entry type in
change_huge_pmd() and properly copy the uffd-wp bit in
set_pmd_migration_entry().

Verified using a simple reproducer that triggers migration of a THP, that
the set_pmd_migration_entry() no longer loses the uffd-wp bit.

Link: https://lkml.kernel.org/r/20230405160236.587705-2-david@redhat.com
Fixes: f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1805,10 +1805,10 @@ int change_huge_pmd(struct mmu_gather *t
 	if (is_swap_pmd(*pmd)) {
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
 		struct page *page = pfn_swap_entry_to_page(entry);
+		pmd_t newpmd;
 
 		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
 		if (is_writable_migration_entry(entry)) {
-			pmd_t newpmd;
 			/*
 			 * A protection check is difficult so
 			 * just be safe and disable write
@@ -1822,8 +1822,16 @@ int change_huge_pmd(struct mmu_gather *t
 				newpmd = pmd_swp_mksoft_dirty(newpmd);
 			if (pmd_swp_uffd_wp(*pmd))
 				newpmd = pmd_swp_mkuffd_wp(newpmd);
-			set_pmd_at(mm, addr, pmd, newpmd);
+		} else {
+			newpmd = *pmd;
 		}
+
+		if (uffd_wp)
+			newpmd = pmd_swp_mkuffd_wp(newpmd);
+		else if (uffd_wp_resolve)
+			newpmd = pmd_swp_clear_uffd_wp(newpmd);
+		if (!pmd_same(*pmd, newpmd))
+			set_pmd_at(mm, addr, pmd, newpmd);
 		goto unlock;
 	}
 #endif
@@ -3233,6 +3241,8 @@ int set_pmd_migration_entry(struct page_
 	pmdswp = swp_entry_to_pmd(entry);
 	if (pmd_soft_dirty(pmdval))
 		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
+	if (pmd_uffd_wp(pmdval))
+		pmdswp = pmd_swp_mkuffd_wp(pmdswp);
 	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
 	page_remove_rmap(page, vma, true);
 	put_page(page);


