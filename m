Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EBC1078F;
	Tue, 30 Jul 2024 16:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358271; cv=none; b=Vfmg81iCLPHlftodTl3TFJzCdPspB0QpmpeeW3EJaKdxbBJH708OiYZ0KHrY/POrVaIaxGmgtt9K4kv/0lDvDxBgWe+tD6k0kjORqyKeq8fxfRoBaxtDA11wSN0ZH0kD6sNQTdxunofRSHSFiT6E8ujikBifeVbpKB6OnyJcwBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358271; c=relaxed/simple;
	bh=0mjcyPkG0dnyGs4+cPt0X4qptLfl/JorXBAS42oP5z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyD100C4PPHWgi/36EKMErmZyGS+ZGzJVeBxHdSOZCHS0W7fFByv/xy1wUbw/HYHnizsvfeJ6vijjtbaHlc2et9R5BoXC3JGIup2LEk+5plZqPaC8pAwMm5du8DJ7E1rfsyH31BcSP9f3kaV4hz8kH3HPOvfIZtHu7KvimrWjzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1+ubJwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1+ubJwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBBDC32782;
	Tue, 30 Jul 2024 16:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358271;
	bh=0mjcyPkG0dnyGs4+cPt0X4qptLfl/JorXBAS42oP5z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1+ubJwdaxyizRPM8mcOdqZJ7XXhHAIFIdsvOLnEMnnFvIfq2pKFbPV92Jrl1K3Yu
	 mWG0nsK84np0BetGjGhAJTMmAYpL7WbKvkPjaUiEN6W1pl67jHJHs9EvAFeTIxhqFF
	 pef9XJaeUmN99vRWU9saC3pschvvHEWOJdY0/LqA=
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
Subject: [PATCH 6.6 346/568] fs/proc/task_mmu: properly detect PM_MMAP_EXCLUSIVE per page of PMD-mapped THPs
Date: Tue, 30 Jul 2024 17:47:33 +0200
Message-ID: <20240730151653.394574904@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a5a946bef0ac4..59571737e1677 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1470,6 +1470,7 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 
 	ptl = pmd_trans_huge_lock(pmdp, vma);
 	if (ptl) {
+		unsigned int idx = (addr & ~PMD_MASK) >> PAGE_SHIFT;
 		u64 flags = 0, frame = 0;
 		pmd_t pmd = *pmdp;
 		struct page *page = NULL;
@@ -1486,8 +1487,7 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 			if (pmd_uffd_wp(pmd))
 				flags |= PM_UFFD_WP;
 			if (pm->show_pfn)
-				frame = pmd_pfn(pmd) +
-					((addr & ~PMD_MASK) >> PAGE_SHIFT);
+				frame = pmd_pfn(pmd) + idx;
 		}
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 		else if (is_swap_pmd(pmd)) {
@@ -1496,11 +1496,9 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 
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
@@ -1516,12 +1514,16 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 
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



