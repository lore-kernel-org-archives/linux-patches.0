Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8346D158525;
	Mon,  6 Jan 2025 15:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178097; cv=none; b=TAiN/ZpB0KUJGdkCv5anByWpe5EnYYOoMTXLe/vy4tTZMxUJtQL/yeTL2NqOyVG50RvzuZX6XJ055TbdJXd2MlPbRv6BAzd74jWCI5AwD6m6aE2Rdo3SOKXc/CGum/PSfbPROM9IF6NIEwtFu5Xtx5qmnecX/70xhwYXFaSJAKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178097; c=relaxed/simple;
	bh=eDbAv4Rcyu/prvxe4brltpbijkTobDBq+NoBP7wTkJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NeOLhKeLSKZ/lmcpdDcXvL55Op6+FlAT4oQs5dbS3WIBoQOMoV/M6Qc+tLi+UJGhNeRZyr3jqVUc3o52BbMJkcUxYWJktKU/IxSkm/A2GMAPgUTrlQPcBksun7sXqrMhtvJhPwpcYYnN0h2/THzJ1Wa1Z62+CclAirr9uRjfVFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LctpTZsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LctpTZsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72FFC4CED2;
	Mon,  6 Jan 2025 15:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178097;
	bh=eDbAv4Rcyu/prvxe4brltpbijkTobDBq+NoBP7wTkJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LctpTZsFb8iX7THqnVMwJKTHWA/5rOMdbaClxr6QQBp/57hqTtNzPW5rGO6q9jsqg
	 pPm7kzulXGSz9+BCvXJw47ecEIHPboy9WnW0ZrqT/a5OxfywbY7X55SffcnBf6iFlV
	 BpBT0G7aUM+kh0jSg6qqIiGRTV7D/jy5E87BrSKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Shixin <liushixin2@huawei.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Ken Chen <kenneth.w.chen@intel.com>,
	Muchun Song <muchun.song@linux.dev>,
	Nanyong Sun <sunnanyong@huawei.com>,
	Jane Chu <jane.chu@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 153/156] mm: hugetlb: independent PMD page table shared count
Date: Mon,  6 Jan 2025 16:17:19 +0100
Message-ID: <20250106151147.493335782@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Shixin <liushixin2@huawei.com>

commit 59d9094df3d79443937add8700b2ef1a866b1081 upstream.

The folio refcount may be increased unexpectly through try_get_folio() by
caller such as split_huge_pages.  In huge_pmd_unshare(), we use refcount
to check whether a pmd page table is shared.  The check is incorrect if
the refcount is increased by the above caller, and this can cause the page
table leaked:

 BUG: Bad page state in process sh  pfn:109324
 page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x66 pfn:0x109324
 flags: 0x17ffff800000000(node=0|zone=2|lastcpupid=0xfffff)
 page_type: f2(table)
 raw: 017ffff800000000 0000000000000000 0000000000000000 0000000000000000
 raw: 0000000000000066 0000000000000000 00000000f2000000 0000000000000000
 page dumped because: nonzero mapcount
 ...
 CPU: 31 UID: 0 PID: 7515 Comm: sh Kdump: loaded Tainted: G    B              6.13.0-rc2master+ #7
 Tainted: [B]=BAD_PAGE
 Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
 Call trace:
  show_stack+0x20/0x38 (C)
  dump_stack_lvl+0x80/0xf8
  dump_stack+0x18/0x28
  bad_page+0x8c/0x130
  free_page_is_bad_report+0xa4/0xb0
  free_unref_page+0x3cc/0x620
  __folio_put+0xf4/0x158
  split_huge_pages_all+0x1e0/0x3e8
  split_huge_pages_write+0x25c/0x2d8
  full_proxy_write+0x64/0xd8
  vfs_write+0xcc/0x280
  ksys_write+0x70/0x110
  __arm64_sys_write+0x24/0x38
  invoke_syscall+0x50/0x120
  el0_svc_common.constprop.0+0xc8/0xf0
  do_el0_svc+0x24/0x38
  el0_svc+0x34/0x128
  el0t_64_sync_handler+0xc8/0xd0
  el0t_64_sync+0x190/0x198

The issue may be triggered by damon, offline_page, page_idle, etc, which
will increase the refcount of page table.

1. The page table itself will be discarded after reporting the
   "nonzero mapcount".

2. The HugeTLB page mapped by the page table miss freeing since we
   treat the page table as shared and a shared page table will not be
   unmapped.

Fix it by introducing independent PMD page table shared count.  As
described by comment, pt_index/pt_mm/pt_frag_refcount are used for s390
gmap, x86 pgds and powerpc, pt_share_count is used for x86/arm64/riscv
pmds, so we can reuse the field as pt_share_count.

Link: https://lkml.kernel.org/r/20241216071147.3984217-1-liushixin2@huawei.com
Fixes: 39dde65c9940 ("[PATCH] shared page table for hugetlb page")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Ken Chen <kenneth.w.chen@intel.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm.h       |    1 +
 include/linux/mm_types.h |   30 ++++++++++++++++++++++++++++++
 mm/hugetlb.c             |   16 +++++++---------
 3 files changed, 38 insertions(+), 9 deletions(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3100,6 +3100,7 @@ static inline bool pagetable_pmd_ctor(st
 	if (!pmd_ptlock_init(ptdesc))
 		return false;
 	__folio_set_pgtable(folio);
+	ptdesc_pmd_pts_init(ptdesc);
 	lruvec_stat_add_folio(folio, NR_PAGETABLE);
 	return true;
 }
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -445,6 +445,7 @@ FOLIO_MATCH(compound_head, _head_2a);
  * @pt_index:         Used for s390 gmap.
  * @pt_mm:            Used for x86 pgds.
  * @pt_frag_refcount: For fragmented page table tracking. Powerpc only.
+ * @pt_share_count:   Used for HugeTLB PMD page table share count.
  * @_pt_pad_2:        Padding to ensure proper alignment.
  * @ptl:              Lock for the page table.
  * @__page_type:      Same as page->page_type. Unused for page tables.
@@ -471,6 +472,9 @@ struct ptdesc {
 		pgoff_t pt_index;
 		struct mm_struct *pt_mm;
 		atomic_t pt_frag_refcount;
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+		atomic_t pt_share_count;
+#endif
 	};
 
 	union {
@@ -516,6 +520,32 @@ static_assert(sizeof(struct ptdesc) <= s
 	const struct page *:		(const struct ptdesc *)(p),	\
 	struct page *:			(struct ptdesc *)(p)))
 
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+static inline void ptdesc_pmd_pts_init(struct ptdesc *ptdesc)
+{
+	atomic_set(&ptdesc->pt_share_count, 0);
+}
+
+static inline void ptdesc_pmd_pts_inc(struct ptdesc *ptdesc)
+{
+	atomic_inc(&ptdesc->pt_share_count);
+}
+
+static inline void ptdesc_pmd_pts_dec(struct ptdesc *ptdesc)
+{
+	atomic_dec(&ptdesc->pt_share_count);
+}
+
+static inline int ptdesc_pmd_pts_count(struct ptdesc *ptdesc)
+{
+	return atomic_read(&ptdesc->pt_share_count);
+}
+#else
+static inline void ptdesc_pmd_pts_init(struct ptdesc *ptdesc)
+{
+}
+#endif
+
 /*
  * Used for sizing the vmemmap region on some architectures
  */
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7200,7 +7200,7 @@ pte_t *huge_pmd_share(struct mm_struct *
 			spte = hugetlb_walk(svma, saddr,
 					    vma_mmu_pagesize(svma));
 			if (spte) {
-				get_page(virt_to_page(spte));
+				ptdesc_pmd_pts_inc(virt_to_ptdesc(spte));
 				break;
 			}
 		}
@@ -7215,7 +7215,7 @@ pte_t *huge_pmd_share(struct mm_struct *
 				(pmd_t *)((unsigned long)spte & PAGE_MASK));
 		mm_inc_nr_pmds(mm);
 	} else {
-		put_page(virt_to_page(spte));
+		ptdesc_pmd_pts_dec(virt_to_ptdesc(spte));
 	}
 	spin_unlock(&mm->page_table_lock);
 out:
@@ -7227,10 +7227,6 @@ out:
 /*
  * unmap huge page backed by shared pte.
  *
- * Hugetlb pte page is ref counted at the time of mapping.  If pte is shared
- * indicated by page_count > 1, unmap is achieved by clearing pud and
- * decrementing the ref count. If count == 1, the pte page is not shared.
- *
  * Called with page table lock held.
  *
  * returns: 1 successfully unmapped a shared pte page
@@ -7239,18 +7235,20 @@ out:
 int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
 					unsigned long addr, pte_t *ptep)
 {
+	unsigned long sz = huge_page_size(hstate_vma(vma));
 	pgd_t *pgd = pgd_offset(mm, addr);
 	p4d_t *p4d = p4d_offset(pgd, addr);
 	pud_t *pud = pud_offset(p4d, addr);
 
 	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
 	hugetlb_vma_assert_locked(vma);
-	BUG_ON(page_count(virt_to_page(ptep)) == 0);
-	if (page_count(virt_to_page(ptep)) == 1)
+	if (sz != PMD_SIZE)
+		return 0;
+	if (!ptdesc_pmd_pts_count(virt_to_ptdesc(ptep)))
 		return 0;
 
 	pud_clear(pud);
-	put_page(virt_to_page(ptep));
+	ptdesc_pmd_pts_dec(virt_to_ptdesc(ptep));
 	mm_dec_nr_pmds(mm);
 	return 1;
 }


