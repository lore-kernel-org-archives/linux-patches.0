Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3FB343882;
	Tue, 13 Oct 2026 12:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895485; cv=none; b=YB2/VYOhjswLjoADjor5EceAJcDK3M+2OWKr3ZS6ANbgStMgcUAx/a0VdS1D29+KW1VHskOP1nZuaL0QH8ZlqyLlF7VZSvw9FWvewk2hj5GUzWMsqClUZZvQvL+e+KMY1EURB8nhZ17zFtfJodKMLkKsAktjdc4phbBCdGhXsjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895485; c=relaxed/simple;
	bh=VQ9aJ4khTpGi1QLUnw3f0T+YwfekiWE6qFC582YBRpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eLwvP9ZEbXhq64GM0Ov25bBhDKrbf2UCH/FpWYme5ViQC66mp50gpqlXz4lS9W4SBdI3Fgq6bCUPB91wT5mRjAItWfB5Zkm/lmmbxPRCjIxT9ExYqHl07PBYDTaBGMeLRfsTyMZmHl1VsLXpPvWE8y9qf1CQjsC827uwoeWKgdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqWzeDeJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqWzeDeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE4D1F000FF;
	Tue, 13 Oct 2026 12:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895484;
	bh=igpflSpHyqIhL/Xfmf75Qf9c40WGbOLYmHJdiMg4FCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqWzeDeJj1+GsF4HpuuNv2lim3B4wYAJxLC8F0w4tzqPuvVATPF7AtN2XwttGiIwk
	 3/quICcYx4KzJS8fF0mjiGpISti6Rg20QZ+2Jt6Z14UaEDFe3tsygzkHYvwTQv9ear
	 Me4dkSivj0WV2u0XX+rwMxn6nKy6sG8h5w6a4zX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 291/497] KVM: arm64: Use stage-1 leaf size for VM_PFNMAP
Date: Tue, 13 Oct 2026 13:37:38 +0200
Message-ID: <20261013112914.802757718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mostafa Saleh <smostafa@google.com>

[ Upstream commit 71cc2c67fb8f8d5aa8154eb482e9846d2214f11b ]

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
[ sashal: Adapted upstream’s split fault-helper changes to the existing user_mem_abort() implementation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/mmu.c | 46 ++++++--------------------------------------
 1 file changed, 6 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6586008dc4df5..6655ffbf20656 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1366,32 +1366,11 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
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
 
@@ -1474,10 +1453,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			return ret;
 	}
 
-	/*
-	 * Let's check if we will get back a huge page backed by hugetlbfs, or
-	 * get block mapping for device MMIO region.
-	 */
 	mmap_read_lock(current->mm);
 	vma = vma_lookup(current->mm, hva);
 	if (unlikely(!vma)) {
@@ -1494,7 +1469,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
 	} else {
-		vma_shift = get_vma_page_shift(vma, hva);
+		vma_shift = get_vma_page_shift(vma);
 	}
 
 	switch (vma_shift) {
@@ -1589,16 +1564,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 
 	if (kvm_is_device_pfn(pfn)) {
-		/*
-		 * If the page was identified as device early by looking at
-		 * the VMA flags, vma_pagesize is already representing the
-		 * largest quantity we can map.  If instead it was mapped
-		 * via gfn_to_pfn_prot(), vma_pagesize is set to PAGE_SIZE
-		 * and must not be upgraded.
-		 *
-		 * In both cases, we don't let transparent_hugepage_adjust()
-		 * change things at the last minute.
-		 */
 		device = true;
 	} else if (logging_active && !write_fault) {
 		/*
@@ -1639,9 +1604,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	/*
 	 * If we are not forced to use page mapping, check if we are
-	 * backed by a THP and thus use block mapping if possible.
+	 * backed by a huge stage-1 mapping and thus use block mapping if
+	 * possible.
 	 */
-	if (vma_pagesize == PAGE_SIZE && !(force_pte || device)) {
+	if (vma_pagesize == PAGE_SIZE && !force_pte) {
 		if (fault_is_perm && fault_granule > PAGE_SIZE)
 			vma_pagesize = fault_granule;
 		else
-- 
2.53.0



