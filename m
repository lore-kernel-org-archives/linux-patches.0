Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6ED384;
	Thu, 13 Jun 2024 12:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282091; cv=none; b=ObeJvmUCUysWJovzZcWYL2gloD0WZvwFM5JTUiANe68LOcDsOeypWUvTZH63iLlu2//csyLzrf1aeCefLzdHiihMfViYeHMMc2MVb0lgnF71Q6SYlld9sb1rjjyvx5rp/qFu3mNFAKTK/XpLEhaXJcHSnoSwzR7aENh3kVeD1Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282091; c=relaxed/simple;
	bh=/unNMAPQfvEUKsbcJwr6+ty07IRXHsAh+3y5dqgSKUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8I1gAyABw7Cy8GTryC1nFGY+iDXZzGsIDZVahxha5TCt4gMTxaW6uLuKDverBYgi4+zol0I562ljrsOdEP8+QsoXEf+scSe3QNjBCIBeBTBMDFGB/7t4hw9GTE7bwZZRSfIkXd+utzf3mR0H8HV/0M4VRSZfGtNndOHk7FDl/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nw2Zir1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nw2Zir1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1A2C2BBFC;
	Thu, 13 Jun 2024 12:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282091;
	bh=/unNMAPQfvEUKsbcJwr6+ty07IRXHsAh+3y5dqgSKUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nw2Zir1hjkZXePE6ZHhuHf7w/wCj7R/SjT2L6+heJITgembViIvua+LN8dF6nuu3+
	 5ZEa7Ql8Q1jfOH/1MzMghRyICR+Dajryk/CzvHZPM1e+86gGF6jFAzjThIi2MQyJTK
	 e4BrofgL5rk8JZ3XbH52pbhMYCAvElZ1LulpCob0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Fei Li <fei1.li@intel.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Yonghua Huang <yonghua.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/402] drivers/virt/acrn: fix PFNMAP PTE checks in acrn_vm_ram_map()
Date: Thu, 13 Jun 2024 13:31:57 +0200
Message-ID: <20240613113308.375956662@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 3d6586008f7b638f91f3332602592caa8b00b559 ]

Patch series "mm: follow_pte() improvements and acrn follow_pte() fixes".

Patch #1 fixes a bunch of issues I spotted in the acrn driver.  It
compiles, that's all I know.  I'll appreciate some review and testing from
acrn folks.

Patch #2+#3 improve follow_pte(), passing a VMA instead of the MM, adding
more sanity checks, and improving the documentation.  Gave it a quick test
on x86-64 using VM_PAT that ends up using follow_pte().

This patch (of 3):

We currently miss handling various cases, resulting in a dangerous
follow_pte() (previously follow_pfn()) usage.

(1) We're not checking PTE write permissions.

Maybe we should simply always require pte_write() like we do for
pin_user_pages_fast(FOLL_WRITE)? Hard to tell, so let's check for
ACRN_MEM_ACCESS_WRITE for now.

(2) We're not rejecting refcounted pages.

As we are not using MMU notifiers, messing with refcounted pages is
dangerous and can result in use-after-free. Let's make sure to reject them.

(3) We are only looking at the first PTE of a bigger range.

We only lookup a single PTE, but memmap->len may span a larger area.
Let's loop over all involved PTEs and make sure the PFN range is
actually contiguous. Reject everything else: it couldn't have worked
either way, and rather made use access PFNs we shouldn't be accessing.

Link: https://lkml.kernel.org/r/20240410155527.474777-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240410155527.474777-2-david@redhat.com
Fixes: 8a6e85f75a83 ("virt: acrn: obtain pa from VMA with PFNMAP flag")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Fei Li <fei1.li@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Yonghua Huang <yonghua.huang@intel.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virt/acrn/mm.c | 63 +++++++++++++++++++++++++++++++-----------
 1 file changed, 47 insertions(+), 16 deletions(-)

diff --git a/drivers/virt/acrn/mm.c b/drivers/virt/acrn/mm.c
index ffc1d1136f765..8ef49d7be453c 100644
--- a/drivers/virt/acrn/mm.c
+++ b/drivers/virt/acrn/mm.c
@@ -155,23 +155,29 @@ int acrn_vm_memseg_unmap(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 {
 	struct vm_memory_region_batch *regions_info;
-	int nr_pages, i = 0, order, nr_regions = 0;
+	int nr_pages, i, order, nr_regions = 0;
 	struct vm_memory_mapping *region_mapping;
 	struct vm_memory_region_op *vm_region;
 	struct page **pages = NULL, *page;
 	void *remap_vaddr;
 	int ret, pinned;
 	u64 user_vm_pa;
-	unsigned long pfn;
 	struct vm_area_struct *vma;
 
 	if (!vm || !memmap)
 		return -EINVAL;
 
+	/* Get the page number of the map region */
+	nr_pages = memmap->len >> PAGE_SHIFT;
+	if (!nr_pages)
+		return -EINVAL;
+
 	mmap_read_lock(current->mm);
 	vma = vma_lookup(current->mm, memmap->vma_base);
 	if (vma && ((vma->vm_flags & VM_PFNMAP) != 0)) {
+		unsigned long start_pfn, cur_pfn;
 		spinlock_t *ptl;
+		bool writable;
 		pte_t *ptep;
 
 		if ((memmap->vma_base + memmap->len) > vma->vm_end) {
@@ -179,25 +185,53 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 			return -EINVAL;
 		}
 
-		ret = follow_pte(vma->vm_mm, memmap->vma_base, &ptep, &ptl);
-		if (ret < 0) {
-			mmap_read_unlock(current->mm);
+		for (i = 0; i < nr_pages; i++) {
+			ret = follow_pte(vma->vm_mm,
+					 memmap->vma_base + i * PAGE_SIZE,
+					 &ptep, &ptl);
+			if (ret)
+				break;
+
+			cur_pfn = pte_pfn(ptep_get(ptep));
+			if (i == 0)
+				start_pfn = cur_pfn;
+			writable = !!pte_write(ptep_get(ptep));
+			pte_unmap_unlock(ptep, ptl);
+
+			/* Disallow write access if the PTE is not writable. */
+			if (!writable &&
+			    (memmap->attr & ACRN_MEM_ACCESS_WRITE)) {
+				ret = -EFAULT;
+				break;
+			}
+
+			/* Disallow refcounted pages. */
+			if (pfn_valid(cur_pfn) &&
+			    !PageReserved(pfn_to_page(cur_pfn))) {
+				ret = -EFAULT;
+				break;
+			}
+
+			/* Disallow non-contiguous ranges. */
+			if (cur_pfn != start_pfn + i) {
+				ret = -EINVAL;
+				break;
+			}
+		}
+		mmap_read_unlock(current->mm);
+
+		if (ret) {
 			dev_dbg(acrn_dev.this_device,
 				"Failed to lookup PFN at VMA:%pK.\n", (void *)memmap->vma_base);
 			return ret;
 		}
-		pfn = pte_pfn(ptep_get(ptep));
-		pte_unmap_unlock(ptep, ptl);
-		mmap_read_unlock(current->mm);
 
 		return acrn_mm_region_add(vm, memmap->user_vm_pa,
-			 PFN_PHYS(pfn), memmap->len,
+			 PFN_PHYS(start_pfn), memmap->len,
 			 ACRN_MEM_TYPE_WB, memmap->attr);
 	}
 	mmap_read_unlock(current->mm);
 
-	/* Get the page number of the map region */
-	nr_pages = memmap->len >> PAGE_SHIFT;
 	pages = vzalloc(array_size(nr_pages, sizeof(*pages)));
 	if (!pages)
 		return -ENOMEM;
@@ -241,12 +275,11 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 	mutex_unlock(&vm->regions_mapping_lock);
 
 	/* Calculate count of vm_memory_region_op */
-	while (i < nr_pages) {
+	for (i = 0; i < nr_pages; i += 1 << order) {
 		page = pages[i];
 		VM_BUG_ON_PAGE(PageTail(page), page);
 		order = compound_order(page);
 		nr_regions++;
-		i += 1 << order;
 	}
 
 	/* Prepare the vm_memory_region_batch */
@@ -263,8 +296,7 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 	regions_info->regions_num = nr_regions;
 	regions_info->regions_gpa = virt_to_phys(vm_region);
 	user_vm_pa = memmap->user_vm_pa;
-	i = 0;
-	while (i < nr_pages) {
+	for (i = 0; i < nr_pages; i += 1 << order) {
 		u32 region_size;
 
 		page = pages[i];
@@ -280,7 +312,6 @@ int acrn_vm_ram_map(struct acrn_vm *vm, struct acrn_vm_memmap *memmap)
 
 		vm_region++;
 		user_vm_pa += region_size;
-		i += 1 << order;
 	}
 
 	/* Inform the ACRN Hypervisor to set up EPT mappings */
-- 
2.43.0



