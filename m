Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211209;
	b=1aT31w/K0IhRjN0EFurcsvontOSJAP6kFw+YNg4G3JP+3yz6DlGChlfo1vFXl/K8rwwp
	 A3fnUU/EtuvL/rUnpdHp5CbbploM77FSPRAesUbWdFKyr4fRdtBqrm0HrxcXpyMTgSsff
	 8UBfGoZkvs4hyDJcqYdhUA/1uYvDGkKHjk+5vyVNpsP7dtC8x1i0r71zHMg6qHfCCeutm
	 2HhTTvbKATuZ00j4EdVdtPOQGU+4Dy+fHsEgXbMpjT6mWVux4swCgamcMEqtA5X8RIr5l
	 T2cXCSdnvAWdtzeq/zbcT4Y6Arb4Z9mrEJpb2dwKk8qNMXi2Z48JrtOCSVnjpERgwJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q+jRH3x57p+rkcNIYpWLUxvFtXVtvmGrO1/Phg2WDmU=;
	b=0SAuCj/qR8cnvyyYrVugrbI01/j8GXrwFlwuhUfiAx9bgEmdnORoSO8N3aClmg1qfzH2
	 +uGtnHunuaOgLxRdkQ3W7mK36UCP60z5m+iZStKWMNju2u5fwHWBAAb+E1QYhAq4q5Gvv
	 5jKF2gysV9UEZi/01KSrEukHT0uZmZ9seXupbjBDwCQArHYKX9mGJe9LTTD0omCUG9OlL
	 O6jyrkJJhSel0Yi+1Oc9xDVhAHlfFzvJEstkOSiCoBT+1UbCXBmQn2ObM1tXuEMrTau0o
	 L50oa9mgC8o1AMOzkr6b5yk89oxtKdf8m+yjg7mcRal3LIa8PGKqJYohBBnl8oFgtBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KsnAOsVO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B293C606A951;
	Wed, 28 Oct 2026 18:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KsnAOsVO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA191F01825;
	Wed, 28 Oct 2026 18:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211208;
	bh=Q+jRH3x57p+rkcNIYpWLUxvFtXVtvmGrO1/Phg2WDmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KsnAOsVOMWBJQcz5unFE0gXBXRQiszV0S9BXoqC55U2/AOvBWStDvNfcfHz+dA4v6
	 AgRX2S+rjdvSnFQw6MLhJL8vsFJN+BMJdNcoffPHKxnC398xkFMA29yYKRvOGXIBSo
	 Vxy106NfB0Y60fL1/zrWwBC5hoWsr78wfWMAyaGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 297/571] KVM: arm64: Dont use the VMA to size stage-2 block mappings for VM_PFNMAP
Date: Wed, 28 Oct 2026 17:57:24 +0100
Message-ID: <20261028170015.047191948@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7d04f96706447..c5697cbbfabea 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -904,32 +904,11 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
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
 
@@ -1038,7 +1017,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
 	} else {
-		vma_shift = get_vma_page_shift(vma, hva);
+		vma_shift = get_vma_page_shift(vma);
 	}
 
 	shared = (vma->vm_flags & VM_SHARED);
-- 
2.53.0



