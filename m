Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD69248BA6;
	Wed, 15 Jan 2025 10:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938116; cv=none; b=X5dC6TTuugMiCwAXSsP5usEqrUluM5e/VS05Y/XrKceY5ePb4q7pxvUBKtsK2rboyGfZeHYeATTt0/mtQ9cb5B/Shzn92vHCJAeCPOgG+dO6EODySU2ATikst78h+5ANR6Vpkmi0Ke6CBfpyHuhmElvUI2cFO9HpjhsajK6Km00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938116; c=relaxed/simple;
	bh=3yQKGBjoxJaPy9eh3aVo/H6E2/bqCEXrjiCvTgFtb4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxAOv3OxtYf/z/TWHHrHeKhzwc/J2sym4hZjCYGF/QmhsyTrV8NMKpijOKG/c1cUOEwcVdq01WOj7RQy/z/4DSEBm1IGbvabr53Y80g+2Wu2XUAf/Mf/LJeCCtSDP+IHiV9bgfJ7sgMZT/1DurxMgLEcXhVswLoSaQvQ1N9rQoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z66Fq5Rn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z66Fq5Rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3E4C4CEDF;
	Wed, 15 Jan 2025 10:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938116;
	bh=3yQKGBjoxJaPy9eh3aVo/H6E2/bqCEXrjiCvTgFtb4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z66Fq5RnEdFYC1OoSk06vCw13ItP+U88vxS81EngIzEw+uIa8JuIAnsUU6pm9mXWp
	 gRnlxaDlNbMcXkwM5ZqLwOgu1r6HIf75iVPeXFUo7ztO2ez2EUbm9JVdakzhY36tX2
	 raklOz+GzycpDvAaN+iLDM7kvQCpYDo2FTzQRz58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Athul Krishna <athul.krishna.kr@protonmail.com>,
	Precific <precification@posteo.de>,
	Peter Xu <peterx@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 6.12 087/189] vfio/pci: Fallback huge faults for unaligned pfn
Date: Wed, 15 Jan 2025 11:36:23 +0100
Message-ID: <20250115103609.808326993@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: Alex Williamson <alex.williamson@redhat.com>

commit 09dfc8a5f2ce897005a94bf66cca4f91e4e03700 upstream.

The PFN must also be aligned to the fault order to insert a huge
pfnmap.  Test the alignment and fallback when unaligned.

Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219619
Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
Reported-by: Precific <precification@posteo.de>
Reviewed-by: Peter Xu <peterx@redhat.com>
Tested-by: Precific <precification@posteo.de>
Link: https://lore.kernel.org/r/20250102183416.1841878-1-alex.williamson@redhat.com
Cc: stable@vger.kernel.org
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/vfio_pci_core.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1661,14 +1661,15 @@ static vm_fault_t vfio_pci_mmap_huge_fau
 	unsigned long pfn, pgoff = vmf->pgoff - vma->vm_pgoff;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 
-	if (order && (vmf->address & ((PAGE_SIZE << order) - 1) ||
+	pfn = vma_to_pfn(vma) + pgoff;
+
+	if (order && (pfn & ((1 << order) - 1) ||
+		      vmf->address & ((PAGE_SIZE << order) - 1) ||
 		      vmf->address + (PAGE_SIZE << order) > vma->vm_end)) {
 		ret = VM_FAULT_FALLBACK;
 		goto out;
 	}
 
-	pfn = vma_to_pfn(vma);
-
 	down_read(&vdev->memory_lock);
 
 	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
@@ -1676,18 +1677,18 @@ static vm_fault_t vfio_pci_mmap_huge_fau
 
 	switch (order) {
 	case 0:
-		ret = vmf_insert_pfn(vma, vmf->address, pfn + pgoff);
+		ret = vmf_insert_pfn(vma, vmf->address, pfn);
 		break;
 #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
 	case PMD_ORDER:
-		ret = vmf_insert_pfn_pmd(vmf, __pfn_to_pfn_t(pfn + pgoff,
-							     PFN_DEV), false);
+		ret = vmf_insert_pfn_pmd(vmf,
+					 __pfn_to_pfn_t(pfn, PFN_DEV), false);
 		break;
 #endif
 #ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
 	case PUD_ORDER:
-		ret = vmf_insert_pfn_pud(vmf, __pfn_to_pfn_t(pfn + pgoff,
-							     PFN_DEV), false);
+		ret = vmf_insert_pfn_pud(vmf,
+					 __pfn_to_pfn_t(pfn, PFN_DEV), false);
 		break;
 #endif
 	default:


