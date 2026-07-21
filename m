Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350FD4028D6;
	Tue, 21 Jul 2026 17:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654503; cv=none; b=WOd7lhfjs+KHPZKNy/pQxCMU7PERnepXYLTUGL/6EDZsXzpvtro+aHaDT0AeDO2+H/WWVrIc+7fy5Oax+YeIIifkkhbBiT1zwnO3y6BQZA7+p+kPxMDsxftbl8pLYE6+RXo21e8vawKeyaRCwlpc55kTbBz4iith9k9Ek44GiOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654503; c=relaxed/simple;
	bh=1CykKLuPzAb5XqbcmamW1wkCyHwcZxPcJnt7naz71F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ax4FiThSuWVbH6DUnMZOOs+mw5oTGlgdTw/LsN1Is6Pun4OWrOa5YW4e5954xTJXlLzn53rrvjQjjeN40mRv21R23xFXiJUS++k2YY28sriVbfKo5pQGvpMnBw8ls6Ll3my5VOrCnr310c3p58jb3vq7s9v/a0wxu24XZPpD9c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NzS+/Qo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NzS+/Qo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDAF1F000E9;
	Tue, 21 Jul 2026 17:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654502;
	bh=VqJQHv+ApBa88vvBQBfvYJcI/j0xpC7sIcQmFWgi/XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1NzS+/QoQ84hI9f4g36s5XRgG715gLLyjC0ShLpK9rjpXgQzQMTuKXFj8JT6CXrdN
	 G04USfZ0vl8b/LcylgjMrvdZikqRS2nmMBO5sS5R9/jQJvR1vvir7+BHwwoWfHvb++
	 l0K6TrTvuM/FcAvrr9xIcWL+5t5bhQwSZkLR6EQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiryl Shutsemau <kas@kernel.org>,
	Sashiko AI review <sashiko-bot@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 1729/2077] fs/proc/task_mmu: fix hugetlb self-deadlock in pagemap_scan_pte_hole()
Date: Tue, 21 Jul 2026 17:23:22 +0200
Message-ID: <20260721152633.531969186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiryl Shutsemau (Meta) <kas@kernel.org>

commit e92d92bbafb264dc0518d52b846a3c07ed8d523f upstream.

A PAGEMAP_SCAN ioctl requesting PM_SCAN_WP_MATCHING on a hugetlb VMA hangs
the calling thread, unkillably, as soon as the scan reaches an unpopulated
part of the range:

  do_pagemap_scan()
    walk_page_range()
      walk_hugetlb_range()
        hugetlb_vma_lock_read()           # take the vma lock for read ...
        pagemap_scan_pte_hole()           # ... ->pte_hole() for a hole
          uffd_wp_range()
            change_protection()
              hugetlb_change_protection()
                hugetlb_vma_lock_write()  # ... and block taking it for write

walk_hugetlb_range() holds the hugetlb vma lock for read across the whole
walk.  A present entry goes to ->hugetlb_entry(); an unpopulated one goes
to ->pte_hole(), i.e.  pagemap_scan_pte_hole().  To write-protect the hole
that handler calls uffd_wp_range(), which on a hugetlb VMA reaches
hugetlb_change_protection() and takes the same vma lock for write.  The
thread then blocks in down_write() waiting for the read lock it is itself
holding.

The populated path avoids this: pagemap_scan_hugetlb_entry()
write-protects the entry inline under the page-table lock and never enters
hugetlb_change_protection().

Do the same for holes.  Fault in the page table and install the uffd-wp
marker directly with make_uffd_wp_huge_pte() under the page-table lock,
rather than routing through uffd_wp_range().  That is the same sequence
hugetlb_change_protection() runs for an unpopulated entry, minus the vma
write lock -- which is safe to skip because PMD sharing is disabled on
uffd-wp VMAs (hugetlb_unshare_all_pmds() runs at registration), leaving
nothing for that lock to serialise against.

Link: https://lore.kernel.org/20260529172331.356655-4-kas@kernel.org
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2890,8 +2890,62 @@ out_unlock:
 
 	return ret;
 }
+
+/*
+ * Write-protect the unpopulated hugetlb entries covering [addr, end) by
+ * installing uffd-wp markers inline, exactly as pagemap_scan_hugetlb_entry()
+ * does for populated entries.
+ *
+ * walk_hugetlb_range() currently calls ->pte_hole() once per huge page, so the
+ * loop normally runs a single iteration; it is written to cover the full range
+ * in case the walker ever coalesces adjacent holes.
+ *
+ * The obvious route -- uffd_wp_range() -> hugetlb_change_protection() --
+ * cannot be used here: it takes hugetlb_vma_lock_write(), but the page-table
+ * walker (walk_hugetlb_range()) already holds hugetlb_vma_lock_read() on the
+ * same VMA, so the scanning thread would deadlock against itself. PMD sharing
+ * is disabled on uffd-wp VMAs (hugetlb_unshare_all_pmds() at registration), so
+ * the vma lock guards nothing that matters for these entries anyway.
+ */
+static int pagemap_scan_hugetlb_hole_wp(struct vm_area_struct *vma,
+					unsigned long addr, unsigned long end)
+{
+	struct hstate *h = hstate_vma(vma);
+	unsigned long psize = huge_page_size(h);
+	struct mm_struct *mm = vma->vm_mm;
+	spinlock_t *ptl;
+	pte_t *ptep;
+	pte_t pte;
+
+	for (addr = ALIGN_DOWN(addr, psize); addr < end; addr += psize) {
+		ptep = huge_pte_alloc(mm, vma, addr, psize);
+		if (!ptep)
+			return -ENOMEM;
+
+		i_mmap_lock_write(vma->vm_file->f_mapping);
+		ptl = huge_pte_lock(h, mm, ptep);
+		pte = huge_ptep_get(mm, addr, ptep);
+		make_uffd_wp_huge_pte(vma, addr, ptep, pte);
+		/*
+		 * A none entry has no cached translation, so installing the
+		 * marker needs no TLB flush. Flush only if a fault populated
+		 * the entry between huge_pte_alloc() and the page table lock.
+		 */
+		if (!huge_pte_none(pte))
+			flush_hugetlb_tlb_range(vma, addr, addr + psize);
+		spin_unlock(ptl);
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
+	}
+
+	return 0;
+}
 #else
 #define pagemap_scan_hugetlb_entry NULL
+static int pagemap_scan_hugetlb_hole_wp(struct vm_area_struct *vma,
+					unsigned long addr, unsigned long end)
+{
+	return 0;
+}
 #endif
 
 static int pagemap_scan_pte_hole(unsigned long addr, unsigned long end,
@@ -2911,7 +2965,10 @@ static int pagemap_scan_pte_hole(unsigne
 	if (~p->arg.flags & PM_SCAN_WP_MATCHING)
 		return ret;
 
-	err = uffd_wp_range(vma, addr, end - addr, true);
+	if (is_vm_hugetlb_page(vma))
+		err = pagemap_scan_hugetlb_hole_wp(vma, addr, end);
+	else
+		err = uffd_wp_range(vma, addr, end - addr, true);
 	if (err < 0)
 		ret = err;
 


