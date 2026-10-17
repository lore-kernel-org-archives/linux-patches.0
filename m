Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDA23876CC;
	Sat, 17 Oct 2026 17:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257061; cv=none; b=Fgrir1FQ+FISC/lN3fP3viaKfis/Ge/jrODqCM3yTOaCwuolT+2OVGI7udTyXOqQeJlxjpWEvrD2Edan665PnkgheoGNsSDg8MLgn55BWzSy2veeRcoyXHyM1TglLUzfPIXjhlmmOzMyf/mF5RgzjTI7kspM0EtUAOzpJBtGPa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257061; c=relaxed/simple;
	bh=+qGu03PgiYmgBjWB4QOa90gwkjKTa+oh3crB8oN8sMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIilEYazq3WyJMEYUzNLQCwNEbuNEDxUKxevo/rWQR1ZXtqbG9xb+vhePCVzX+1XL3LytSVnqfWSrjozsW+buUzBxGXnjmO66smfH9oDKH0IFfmlZ6vv6lCvkc5uX/uB2i8pag8fHPn+b76KBPR4h+J0Gxe0tB7xTlc6y9hQD9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jY73ultE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jY73ultE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027811F000C4;
	Sat, 17 Oct 2026 17:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257060;
	bh=FXHVflIl483Ntk6Y6UlwV5OQdcXQUzq2mayXQLNO2Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jY73ultEnwTx/TOx5bw33oaLeAv2gSGzEuof6TwCUbpsa5m76dQxryXDekx2u2crP
	 3/dAq4yXuVCpuzPxuCDaaJXejUWFCn2irYuF3d/zR/LkxD1FuwSgB8c9AZRDxb78i2
	 UyelJEk3dn2fth2miV9ZkZ7C/CjJEblJ8ciL9VZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0386/1674] KVM: arm64: Dont use the VMA to size stage-2 block mappings for VM_PFNMAP
Date: Sat, 17 Oct 2026 17:44:18 +0200
Message-ID: <20261017160441.020340247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mostafa Saleh <smostafa@google.com>

[ Upstream commit 71cc2c67fb8f8d5aa8154eb482e9846d2214f11b ]

get_vma_page_shift() derives the stage-2 block size for VM_PFNMAP VMAs
from the VMA layout alone, which does not necessarily match what
stage-1 maps for that VMA.

Upstream commit 71cc2c67fb8f ("KVM: arm64: Use stage-1 leaf size for
VM_PFNMAP") drops that calculation and lets transparent_hugepage_adjust()
derive the mapping size from the stage-1 leaf instead. The second part
is not applicable here: in this kernel transparent_hugepage_adjust()
takes a reference on the backing struct page, which is not safe for
MMIO, and stage-1 has no huge PFNMAP before v6.12 anyway. Only drop the
VMA-based calculation, so VM_PFNMAP VMAs are mapped at PAGE_SIZE.

Fixes: 2aa53d68cee6 ("KVM: arm64: Try stage2 block mapping for host device MMIO")
Cc: stable@vger.kernel.org
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/mmu.c | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 482280fe22d7c..47f76a78ba1f4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1329,32 +1329,11 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	return PAGE_SIZE;
 }
 
-static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
+static int get_vma_page_shift(struct vm_area_struct *vma)
 {
-	unsigned long pa;
-
 	if (is_vm_hugetlb_page(vma) && !(vma->vm_flags & VM_PFNMAP))
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
 
@@ -1456,7 +1435,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
 	} else {
-		vma_shift = get_vma_page_shift(vma, hva);
+		vma_shift = get_vma_page_shift(vma);
 	}
 
 	switch (vma_shift) {
-- 
2.53.0



