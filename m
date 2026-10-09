Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430D74E0B91;
	Fri,  9 Oct 2026 14:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557382; cv=none; b=X3kWxcKfQ4fpftsRSL0P1PrIOe0BZFF68sqN7k626EVzvohFo9S32XIr8Lw8sBG32c8PREzai7RrkcobLIHCF48cUyzFwwxjyuA5Sasr5QmOwVpCKpKufGyrF/s+6VjMZlIhHhTonA1vc/UhL388DCAhRVdazXv2CdxggZki648=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557382; c=relaxed/simple;
	bh=oVZ9rdPmCiCit3gX34TcjvoFwWaMS7ZzzTl6wQ3O+Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJaGbj2Udw4sCsIL40ub3+2fwRL8ZCyKHNYXO+mkRPWffWJP8GsJgXnDLXO4b1JsHjTj0fe12xgoVLfxYtchBkimsZaevNAK0hAct4dym08Ml6P6GXMTYevt1iLdVb/NhiHZiP5HTI1NMPZCoGgzxW6f7K9Z/ZgYkxWptSxyZj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jo7zbytA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jo7zbytA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945021F000FF;
	Fri,  9 Oct 2026 14:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557381;
	bh=6zYyc1Gx1wZGKGdy2QgTjUy5rfAsXnhEPcQfCRSj5pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jo7zbytAfh49Q/3qASbwcNaJj73XtwN/QNK19qCtYIQiHl43Kes77jVZCCS2JiWEH
	 gjXPNUmkt24GYTRVthKMy87bKEjy+1i+uUPldiSDNQg1MDVYmHZ0afrYkF07P7MRXY
	 aW86RMZCCcv0x1xE/t+eWBOAKCQmgdynjGouVfyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 391/403] KVM: arm64: Use stage-1 leaf size for VM_PFNMAP
Date: Fri,  9 Oct 2026 16:12:32 +0200
Message-ID: <20261009141001.491825389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
[ sashal: Adapted upstream helper changes to the monolithic user_mem_abort() implementation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/mmu.c |   46 ++++++----------------------------------------
 1 file changed, 6 insertions(+), 40 deletions(-)

--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1406,32 +1406,11 @@ transparent_hugepage_adjust(struct kvm *
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
 
@@ -1655,10 +1634,6 @@ static int user_mem_abort(struct kvm_vcp
 	if (ret)
 		return ret;
 
-	/*
-	 * Let's check if we will get back a huge page backed by hugetlbfs, or
-	 * get block mapping for device MMIO region.
-	 */
 	mmap_read_lock(current->mm);
 	vma = vma_lookup(current->mm, hva);
 	if (unlikely(!vma)) {
@@ -1670,7 +1645,7 @@ static int user_mem_abort(struct kvm_vcp
 	if (force_pte)
 		vma_shift = PAGE_SHIFT;
 	else
-		vma_shift = get_vma_page_shift(vma, hva);
+		vma_shift = get_vma_page_shift(vma);
 
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
@@ -1786,16 +1761,6 @@ static int user_mem_abort(struct kvm_vcp
 			if (!kvm_supports_cacheable_pfnmap())
 				ret = -EFAULT;
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
 			s2_force_noncacheable = true;
 		}
 	} else if (logging_active && !write_fault) {
@@ -1826,9 +1791,10 @@ static int user_mem_abort(struct kvm_vcp
 
 	/*
 	 * If we are not forced to use page mapping, check if we are
-	 * backed by a THP and thus use block mapping if possible.
+	 * backed by a huge stage-1 mapping and thus use block mapping if
+	 * possible.
 	 */
-	if (vma_pagesize == PAGE_SIZE && !(force_pte || s2_force_noncacheable)) {
+	if (vma_pagesize == PAGE_SIZE && !force_pte) {
 		if (fault_is_perm && fault_granule > PAGE_SIZE)
 			vma_pagesize = fault_granule;
 		else


