Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B2718A6D6;
	Tue, 30 Jul 2024 17:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359628; cv=none; b=LupGwdh7AXUEPQpUg79jWv7YJi7Ar+/SATbKiOLGcqZiojjq0Km8l1MR7B8hoYc4Lq3I9WoRHb+UDkYJXUOEo3ZxdMNsb4nzd73DJAOW1AuLWua5FU6KOdEbjQjkPTBKy0ISpZhy14grwUOlYfXwzfmqe7+poz2P32TWVGOgQDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359628; c=relaxed/simple;
	bh=53CF6ij41Fb8W8yyj3TeENXQ3XidxvxyezL1Pk7dV6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txdlbEQR0Z/CzVe0uYJhdB/+WKgBqNOgqGRNUngt3EH3NBhSo7uEgR7dVly75c1LHip4JVNbcFG5q+z6Vv7eNgUk4tROQRERARztKFcOKT1QoBRJauMpMcNi7sUEiALaj20YcLAR9Y+kRFW6AQ7fgHerDKscHAV9KpWL7Mqodfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDSvMgTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDSvMgTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9384C32782;
	Tue, 30 Jul 2024 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359628;
	bh=53CF6ij41Fb8W8yyj3TeENXQ3XidxvxyezL1Pk7dV6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDSvMgTfL8n2QrlhYELcKaYYa/aBP1XNe0ORrbRyyBRULEphHz2no9vv/8meTAZCW
	 /hlaVBNWl0xY7E0wXnQ2DGWcuAfK2shODiXqk8t1XjjiDuhRufdpYECzDQbrAriqlb
	 2z5vn5PWCuPICJl5oCZBnWO8YDof2g3NMWK8uJ3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lance Yang <ioworker0@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 510/809] fs/proc/task_mmu: properly detect PM_MMAP_EXCLUSIVE per page of PMD-mapped THPs
Date: Tue, 30 Jul 2024 17:46:26 +0200
Message-ID: <20240730151744.878236166@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 2c1f057e5be63e890f2dd89e4c25ab5eef084a91 ]

We added PM_MMAP_EXCLUSIVE in 2015 via commit 77bb499bb60f ("pagemap: add
mmap-exclusive bit for marking pages mapped only here"), when THPs could
not be partially mapped and page_mapcount() returned something that was
true for all pages of the THP.

In 2016, we added support for partially mapping THPs via commit
53f9263baba6 ("mm: rework mapcount accounting to enable 4k mapping of
THPs") but missed to determine PM_MMAP_EXCLUSIVE as well per page.

Checking page_mapcount() on the head page does not tell the whole story.

We should check each individual page.  In a future without per-page
mapcounts it will be different, but we'll change that to be consistent
with PTE-mapped THPs once we deal with that.

Link: https://lkml.kernel.org/r/20240607122357.115423-4-david@redhat.com
Fixes: 53f9263baba6 ("mm: rework mapcount accounting to enable 4k mapping of THPs")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/task_mmu.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 22892cdb74cef..a45f2da0ada0d 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1477,6 +1477,7 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 
 	ptl = pmd_trans_huge_lock(pmdp, vma);
 	if (ptl) {
+		unsigned int idx = (addr & ~PMD_MASK) >> PAGE_SHIFT;
 		u64 flags = 0, frame = 0;
 		pmd_t pmd = *pmdp;
 		struct page *page = NULL;
@@ -1493,8 +1494,7 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 			if (pmd_uffd_wp(pmd))
 				flags |= PM_UFFD_WP;
 			if (pm->show_pfn)
-				frame = pmd_pfn(pmd) +
-					((addr & ~PMD_MASK) >> PAGE_SHIFT);
+				frame = pmd_pfn(pmd) + idx;
 		}
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 		else if (is_swap_pmd(pmd)) {
@@ -1503,11 +1503,9 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 
 			if (pm->show_pfn) {
 				if (is_pfn_swap_entry(entry))
-					offset = swp_offset_pfn(entry);
+					offset = swp_offset_pfn(entry) + idx;
 				else
-					offset = swp_offset(entry);
-				offset = offset +
-					((addr & ~PMD_MASK) >> PAGE_SHIFT);
+					offset = swp_offset(entry) + idx;
 				frame = swp_type(entry) |
 					(offset << MAX_SWAPFILES_SHIFT);
 			}
@@ -1523,12 +1521,16 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 
 		if (page && !PageAnon(page))
 			flags |= PM_FILE;
-		if (page && (flags & PM_PRESENT) && page_mapcount(page) == 1)
-			flags |= PM_MMAP_EXCLUSIVE;
 
-		for (; addr != end; addr += PAGE_SIZE) {
-			pagemap_entry_t pme = make_pme(frame, flags);
+		for (; addr != end; addr += PAGE_SIZE, idx++) {
+			unsigned long cur_flags = flags;
+			pagemap_entry_t pme;
+
+			if (page && (flags & PM_PRESENT) &&
+			    page_mapcount(page + idx) == 1)
+				cur_flags |= PM_MMAP_EXCLUSIVE;
 
+			pme = make_pme(frame, cur_flags);
 			err = add_to_pagemap(&pme, pm);
 			if (err)
 				break;
-- 
2.43.0



