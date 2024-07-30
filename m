Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D825188017;
	Tue, 30 Jul 2024 17:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359621; cv=none; b=qXQqkwP0Iw3+ASTC/K1fMcc76vFjawBlbTGrsfVSTLbKhTIUq38azVT5pweKZrRKMhIhPydyqNVgsq6+QyaYsHhCa8hTeR4YVvNWwlFJVFhTDjz4dXLWxJrIhopAqJHndwE532ilsFpr7pcSfJhPatBHR/qyqeT8xrW0uI4OvGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359621; c=relaxed/simple;
	bh=04FrcmAqCtKs0VT4W2miMjyamEmw74A6W0jFyfpESP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKhRVgRYKAPVk4GYwNyNtaRndZs2pxzibL3iQsDd09Ni1DfbklVgFAHCzF5HW272Ru+mQwZ0HCFe87G0CMzsIMPlCdggW8ri9f3InsTV79MJed6F42ngMFFrLnDRUv8vbLBVR/1TLozcm4u2r78GV28sjVocqvjFHuzWzln2ajM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StqESLZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StqESLZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07E0C32782;
	Tue, 30 Jul 2024 17:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359621;
	bh=04FrcmAqCtKs0VT4W2miMjyamEmw74A6W0jFyfpESP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StqESLZlAd0JEFQ/hHLjDCTY5pZCgnwycPpYiavdjr5jaqy/jTcJg+1mKhSHRwn6S
	 bikwIwQHcguQ/Hg41uZdyZwFAGDK30ggJ6FEbCCDQBEXl6yRMWMRV0sfWXHSmm/7L2
	 rfm7LhblZ2sAmKPABy6j+BktfDpFRDCWc+a6KGXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Lance Yang <ioworker0@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 509/809] fs/proc/task_mmu: dont indicate PM_MMAP_EXCLUSIVE without PM_PRESENT
Date: Tue, 30 Jul 2024 17:46:25 +0200
Message-ID: <20240730151744.840004574@linuxfoundation.org>
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

[ Upstream commit da7f31ed0f4df8f61e8195e527aa83dd54896ba3 ]

Relying on the mapcount for non-present PTEs that reference pages doesn't
make any sense: they are not accounted in the mapcount, so page_mapcount()
== 1 won't return the result we actually want to know.

While we don't check the mapcount for migration entries already, we could
end up checking it for swap, hwpoison, device exclusive, ...  entries,
which we really shouldn't.

There is one exception: device private entries, which we consider
fake-present (e.g., incremented the mapcount).  But we won't care about
that for now for PM_MMAP_EXCLUSIVE, because indicating PM_SWAP for them
although they are fake-present already sounds suspiciously wrong.

Let's never indicate PM_MMAP_EXCLUSIVE without PM_PRESENT.

Link: https://lkml.kernel.org/r/20240607122357.115423-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 2c1f057e5be6 ("fs/proc/task_mmu: properly detect PM_MMAP_EXCLUSIVE per page of PMD-mapped THPs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/task_mmu.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 76ad35df3b1ee..22892cdb74cef 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1418,7 +1418,6 @@ static pagemap_entry_t pte_to_pagemap_entry(struct pagemapread *pm,
 {
 	u64 frame = 0, flags = 0;
 	struct page *page = NULL;
-	bool migration = false;
 
 	if (pte_present(pte)) {
 		if (pm->show_pfn)
@@ -1450,7 +1449,6 @@ static pagemap_entry_t pte_to_pagemap_entry(struct pagemapread *pm,
 			    (offset << MAX_SWAPFILES_SHIFT);
 		}
 		flags |= PM_SWAP;
-		migration = is_migration_entry(entry);
 		if (is_pfn_swap_entry(entry))
 			page = pfn_swap_entry_to_page(entry);
 		if (pte_marker_entry_uffd_wp(entry))
@@ -1459,7 +1457,7 @@ static pagemap_entry_t pte_to_pagemap_entry(struct pagemapread *pm,
 
 	if (page && !PageAnon(page))
 		flags |= PM_FILE;
-	if (page && !migration && page_mapcount(page) == 1)
+	if (page && (flags & PM_PRESENT) && page_mapcount(page) == 1)
 		flags |= PM_MMAP_EXCLUSIVE;
 	if (vma->vm_flags & VM_SOFTDIRTY)
 		flags |= PM_SOFT_DIRTY;
@@ -1476,7 +1474,6 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 	pte_t *pte, *orig_pte;
 	int err = 0;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	bool migration = false;
 
 	ptl = pmd_trans_huge_lock(pmdp, vma);
 	if (ptl) {
@@ -1520,14 +1517,13 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 			if (pmd_swp_uffd_wp(pmd))
 				flags |= PM_UFFD_WP;
 			VM_BUG_ON(!is_pmd_migration_entry(pmd));
-			migration = is_migration_entry(entry);
 			page = pfn_swap_entry_to_page(entry);
 		}
 #endif
 
 		if (page && !PageAnon(page))
 			flags |= PM_FILE;
-		if (page && !migration && page_mapcount(page) == 1)
+		if (page && (flags & PM_PRESENT) && page_mapcount(page) == 1)
 			flags |= PM_MMAP_EXCLUSIVE;
 
 		for (; addr != end; addr += PAGE_SIZE) {
-- 
2.43.0



