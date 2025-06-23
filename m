Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF38270838;
	Mon, 23 Jun 2025 21:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712955; cv=none; b=kLgI8MHXujv6VNUVaHwWcAV10kNtZyN1CClFit8yofrA6xeCRrf1s7XaFwAmOuZvmEH0lCiwQEbAjRiQUbh7w7ZwH7ao+/CVUjT0uit474BjxTuzQCRxxnFr/8hiz1OjcimYM+tdurwHSOLPyT8LE6FYhIC0HeStfFPGdLKugpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712955; c=relaxed/simple;
	bh=31/XzM6SPUrSjFThxSVIYqSeAFGufEdRAiZPafCNiHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mfj3jpdGv2RJPjFxC/bclaV4UofwNVLitiU3Ma+8tGcwFBFV99aFjKKYvp3XjAOO/1ZeC+zeRB+8wwaUKyJuAhkmXX1WLicFKZ/S8VZUd7Zo9FTB62tROh/EWIxwnawHNEstu4p4R5XO8QX8NARZ5zM2IOqwFXnOfJzxyRy+PPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyrKrMRD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyrKrMRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56981C4CEEA;
	Mon, 23 Jun 2025 21:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712955;
	bh=31/XzM6SPUrSjFThxSVIYqSeAFGufEdRAiZPafCNiHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyrKrMRDOxW4C/p13cxujQ0+gBMyTjQvdolUtp2igG1cC2I4TLiAcealrwknjF2f3
	 kqtv2eBoefmEKIpwaP6UM4q25/YJ1V0YwceG9mALvMvS6N+GZFk2gLfRzzfOKj+GQL
	 yfo26FLIcxvb2OwFJv4sv5655qtgrfgpuh3pqIi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	Andreas Oetken <andreas.oetken@siemens-energy.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 157/222] nios2: force update_mmu_cache on spurious tlb-permission--related pagefaults
Date: Mon, 23 Jun 2025 15:08:12 +0200
Message-ID: <20250623130616.805674177@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Schuster <schuster.simon@siemens-energy.com>

[ Upstream commit 2d8a3179ea035f9341b6a73e5ba4029fc67e983d ]

NIOS2 uses a software-managed TLB for virtual address translation. To
flush a cache line, the original mapping is replaced by one to physical
address 0x0 with no permissions (rwx mapped to 0) set. This can lead to
TLB-permission--related traps when such a nominally flushed entry is
encountered as a mapping for an otherwise valid virtual address within a
process (e.g. due to an MMU-PID-namespace rollover that previously
flushed the complete TLB including entries of existing, running
processes).

The default ptep_set_access_flags implementation from mm/pgtable-generic.c
only forces a TLB-update when the page-table entry has changed within the
page table:

	/*
	 * [...] We return whether the PTE actually changed, which in turn
	 * instructs the caller to do things like update__mmu_cache. [...]
	 */
	int ptep_set_access_flags(struct vm_area_struct *vma,
				  unsigned long address, pte_t *ptep,
				  pte_t entry, int dirty)
	{
		int changed = !pte_same(*ptep, entry);
		if (changed) {
			set_pte_at(vma->vm_mm, address, ptep, entry);
			flush_tlb_fix_spurious_fault(vma, address);
		}
		return changed;
	}

However, no cross-referencing with the TLB-state occurs, so the
flushing-induced pseudo entries that are responsible for the pagefault
in the first place are never pre-empted from TLB on this code path.

This commit fixes this behaviour by always requesting a TLB-update in
this part of the pagefault handling, fixing spurious page-faults on the
way. The handling is a straightforward port of the logic from the MIPS
architecture via an arch-specific ptep_set_access_flags function ported
from arch/mips/include/asm/pgtable.h.

Signed-off-by: Simon Schuster <schuster.simon@siemens-energy.com>
Signed-off-by: Andreas Oetken <andreas.oetken@siemens-energy.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nios2/include/asm/pgtable.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/nios2/include/asm/pgtable.h b/arch/nios2/include/asm/pgtable.h
index 99985d8b71664..506bbc7730879 100644
--- a/arch/nios2/include/asm/pgtable.h
+++ b/arch/nios2/include/asm/pgtable.h
@@ -297,4 +297,20 @@ extern void __init mmu_init(void);
 extern void update_mmu_cache(struct vm_area_struct *vma,
 			     unsigned long address, pte_t *pte);
 
+static inline int pte_same(pte_t pte_a, pte_t pte_b);
+
+#define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
+static inline int ptep_set_access_flags(struct vm_area_struct *vma,
+					unsigned long address, pte_t *ptep,
+					pte_t entry, int dirty)
+{
+	if (!pte_same(*ptep, entry))
+		set_ptes(vma->vm_mm, address, ptep, entry, 1);
+	/*
+	 * update_mmu_cache will unconditionally execute, handling both
+	 * the case that the PTE changed and the spurious fault case.
+	 */
+	return true;
+}
+
 #endif /* _ASM_NIOS2_PGTABLE_H */
-- 
2.39.5



