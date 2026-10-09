Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482A84E56C6;
	Fri,  9 Oct 2026 14:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557235; cv=none; b=o3ihO/pGsHxk/A9xunuX7Vrf7tWOplWIEUDlKtRQPkXbvdfmSXqglCwGetOtPdSfUTvCS7O1SMfXrQ4fRSHmI9o/MeSsTregtUAuHsP8RbXkG55bPIxzyedzHfknUFFg3IBbfd/btWu9iqZfp5nW8J1WbFcrELUbOXIOM8alIBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557235; c=relaxed/simple;
	bh=9eBSYQZ5y3cji70QzMd+Szug07t31KgyWzRCz0mBs30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5QoyyBwVg/mzhSfl5HR+/MCK3qGvfaMNKMISHLsw2cdH5Q7C1DbqAevcXoQfFU3ostGS+zsJvMqsKSl3XnfSWWW8/bxpF2Sl5+i3/LbiBSt/t0E/uzQrDzlYTFRogu+ukwsNoTtzyV+rAV3MNgXpk0e/+VRDqtPvN1OEW9BWmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7WCn3p+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7WCn3p+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861D81F00898;
	Fri,  9 Oct 2026 14:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557232;
	bh=CM2288KEM6jysWHAX/UwVMEwwS+jnuUwiukHJcWbNL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7WCn3p+oRPdbjMPq+5JzGiQwvqM4+lEowIqWgFXOrwkiaa0DUJMxfWyfctKzhvk0
	 T9mo9QybIwma1UtD6aO4TOUKpUiUKomodqNkV6+HpYVFTUxaATARgroU0JJz2JHaS0
	 ogxhOFx9M4Lft3otGkx0jO76/J88qdJoOr2BCCek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 323/428] KVM: arm64: Use stage-1 leaf size for VM_PFNMAP
Date: Fri,  9 Oct 2026 16:11:00 +0200
Message-ID: <20261009140953.228871345@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mostafa Saleh <smostafa@google.com>

commit 71cc2c67fb8f8d5aa8154eb482e9846d2214f11b upstream.

When commit 2aa53d68cee6 ("KVM: arm64: Try stage2 block mapping for
host device MMIO") added VM_PFNMAP support to get_vma_page_shift(),
stage-1 page tables did not support huge PFNMAP (as in VFIO-PCI
vfio_pci_mmap_huge_fault()) and transparent_hugepage_adjust() was
unsafe for MMIO as it dereferenced struct page.

Since commit 6011cf68c885 ("KVM: arm64: Walk userspace page tables to
compute the THP mapping size"), transparent_hugepage_adjust() instead
walks the host stage-1 page tables via get_user_mapping_size() without
touching struct page. Meanwhile, commit 3e509c9b03f9 ("mm/arm64:
support large pfn mappings") enabled stage-1 huge PFNMAP.

So. we can drop the VMA-based VM_PFNMAP size calculation in
get_vma_page_shift() and let transparent_hugepage_adjust() derive
the stage-2 mapping size directly from the populated stage-1 leaf
for non-cacheable mappings as well.

Assisted-by: LLM
Cc: stable@vger.kernel.org
Fixes: 2aa53d68cee6 ("KVM: arm64: Try stage2 block mapping for host device MMIO")
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/mmu.c |   47 ++++++-----------------------------------------
 1 file changed, 6 insertions(+), 41 deletions(-)

--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1468,32 +1468,11 @@ transparent_hugepage_adjust(struct kvm *
 	return PAGE_SIZE;
 }
 
-static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
+static int get_vma_page_shift(struct vm_area_struct *vma)
 {
-	unsigned long pa;
-
-	if (is_vm_hugetlb_page(vma) && !(vma->vm_flags & VM_PFNMAP))
+	if (is_vm_hugetlb_page(vma))
 		return huge_page_shift(hstate_vma(vma));
 
-	if (!(vma->vm_flags & VM_PFNMAP))
-		return PAGE_SHIFT;
-
-	VM_BUG_ON(is_vm_hugetlb_page(vma));
-
-	pa = (vma->vm_pgoff << PAGE_SHIFT) + (hva - vma->vm_start);
-
-#ifndef __PAGETABLE_PMD_FOLDED
-	if ((hva & (PUD_SIZE - 1)) == (pa & (PUD_SIZE - 1)) &&
-	    ALIGN_DOWN(hva, PUD_SIZE) >= vma->vm_start &&
-	    ALIGN(hva, PUD_SIZE) <= vma->vm_end)
-		return PUD_SHIFT;
-#endif
-
-	if ((hva & (PMD_SIZE - 1)) == (pa & (PMD_SIZE - 1)) &&
-	    ALIGN_DOWN(hva, PMD_SIZE) >= vma->vm_start &&
-	    ALIGN(hva, PMD_SIZE) <= vma->vm_end)
-		return PMD_SHIFT;
-
 	return PAGE_SHIFT;
 }
 
@@ -1794,7 +1773,7 @@ static short kvm_s2_resolve_vma_size(con
 		vma_shift = PAGE_SHIFT;
 	} else {
 		s2vi->max_map_size = PUD_SIZE;
-		vma_shift = get_vma_page_shift(vma, s2fd->hva);
+		vma_shift = get_vma_page_shift(vma);
 	}
 
 	switch (vma_shift) {
@@ -1952,16 +1931,6 @@ static int kvm_s2_fault_pin_pfn(const st
 				return -EFAULT;
 			}
 		} else {
-			/*
-			 * If the page was identified as device early by looking at
-			 * the VMA flags, vma_pagesize is already representing the
-			 * largest quantity we can map.  If instead it was mapped
-			 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
-			 * and must not be upgraded.
-			 *
-			 * In both cases, we don't let transparent_hugepage_adjust()
-			 * change things at the last minute.
-			 */
 			s2vi->map_non_cacheable = true;
 		}
 
@@ -2051,10 +2020,10 @@ static int kvm_s2_fault_map(const struct
 
 	/*
 	 * If we are not forced to use page mapping, check if we are
-	 * backed by a THP and thus use block mapping if possible.
+	 * backed by a huge stage-1 mapping and thus use block mapping if
+	 * possible.
 	 */
-	if (mapping_size == PAGE_SIZE &&
-	    !(s2vi->max_map_size == PAGE_SIZE || s2vi->map_non_cacheable)) {
+	if (mapping_size == PAGE_SIZE && s2vi->max_map_size != PAGE_SIZE) {
 		if (perm_fault_granule > PAGE_SIZE) {
 			mapping_size = perm_fault_granule;
 		} else {
@@ -2132,10 +2101,6 @@ static int user_mem_abort(const struct k
 			return ret;
 	}
 
-	/*
-	 * Let's check if we will get back a huge page backed by hugetlbfs, or
-	 * get block mapping for device MMIO region.
-	 */
 	ret = kvm_s2_fault_pin_pfn(s2fd, &s2vi);
 	if (ret != 1)
 		return ret;


