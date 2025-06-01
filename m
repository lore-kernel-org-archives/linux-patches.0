Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F9F3126A2;
	Sun,  1 Jun 2025 23:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748821167; cv=none; b=L1+eVmBujb1bArkp9OA6jMtLfUhp6+xVJ/L1cAXAAaMW03pj6sBPL2HNenQXren0tiMnoqe2nRmzn6HggqNE4BlJ+89LlEnaH/h1ogEzrXYK+Wd7u6bAijPxXSE2pr66oOT9LX1pP80f+DwydmRTCGqsGS/6uwTM0AxG4S0jgtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748821167; c=relaxed/simple;
	bh=qgqAN44bDr7VYk79vDiVlcIXNF3ZqRKqjMa9gHxgbuA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HE7MSLuJD4R74SzAMJdfgWR5k7rEbLquhjRxjKc69pg1lJFDirkd34nTI+o6yWuIUNDuRnc6ohzg+6VIquY1O0YL0jiSjCfghhFi6o6P8Ua2e+apnpAMYW8anvywn5Nbgj057kDJb8NUmnx0qTahyxpBEZ0dNfoE6mMbnN2QdIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KohiS7Gl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KohiS7Gl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E16CC4CEEE;
	Sun,  1 Jun 2025 23:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748821166;
	bh=qgqAN44bDr7VYk79vDiVlcIXNF3ZqRKqjMa9gHxgbuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KohiS7Gl7i9IG7a1cjWpgowAvenMNRDQqhPsBBR1j3q+F7F8OHk1NkjCumSxdOQq5
	 w1o35Eu0P377eobiczLyPsfpjRSAl7sfnZD4GUMq3MBUD+u/G4w+SvrUvXhAJe7I5A
	 T4GVWujRvk+HGeIIjTmFkCzBRBjH+zshgMB+TSu1hVgvmvh0K/CyEyREQU3XT5oTuH
	 CZ4xIdyRrgHb0WOFYpew0uhnMKsIas0qazYxldnXknkd4w5hab9fjZAgr72aoazmi5
	 j7mR2bdZHquaCk1JYXRL3dCLpuzsxqiV1O7Q5X9TvPFRAj6uT+tAYpvcrlsPdxDUvd
	 zDHySCU+FWpzw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Simon Schuster <schuster.simon@siemens-energy.com>,
	Andreas Oetken <andreas.oetken@siemens-energy.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 42/66] nios2: force update_mmu_cache on spurious tlb-permission--related pagefaults
Date: Sun,  1 Jun 2025 19:37:19 -0400
Message-Id: <20250601233744.3514795-42-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601233744.3514795-1-sashal@kernel.org>
References: <20250601233744.3514795-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.92
Content-Transfer-Encoding: 8bit

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

**YES** This commit should be backported to stable kernel trees for the
following reasons: **1. Fixes a Real User-Affecting Bug:** The commit
addresses infinite page fault loops that can occur when: - NIOS2's
software-managed TLB encounters spurious permission-related page faults
- TLB entries flushed to physical address 0x0 with no permissions
persist due to MMU-PID-namespace rollovers - The generic
`ptep_set_access_flags` implementation fails to flush these stale TLB
entries because it only flushes when the PTE actually changes in the
page table **2. Small, Contained Fix:** The code change is minimal and
surgical: - Adds an arch-specific `ptep_set_access_flags` function in
`arch/nios2/include/asm/pgtable.h:284-297` - Always returns `true` to
force `update_mmu_cache` execution, ensuring TLB invalidation even when
the PTE hasn't changed - Identical pattern to MIPS architecture
(arch/mips/include/asm/pgtable.h), proven and stable **3. Architecture-
Specific with No Side Effects:** - Only affects NIOS2 architecture
(`arch/nios2/include/asm/pgtable.h`) - No cross-architecture
dependencies or changes to core MM code - Uses existing `set_ptes()` and
`update_mmu_cache` infrastructure **4. Consistent with Similar
Backported Fixes:** - Similar commit #5 (xtensa: define update_mmu_tlb
function) was marked **YES** for backport with `Cc:
stable@vger.kernel.org # 5.12+` - Both fix TLB invalidation issues in
software-managed TLB architectures - Both address spurious page fault
scenarios **5. Meets Stable Tree Criteria:** - **Important bugfix**:
Prevents infinite page fault loops - **Minimal risk**: Architecture-
specific, follows proven MIPS pattern - **No architectural changes**:
Uses existing MM infrastructure - **Confined to subsystem**: Limited to
NIOS2 TLB management The fix directly addresses a critical reliability
issue where users experience system hangs due to infinite page faults,
making it an ideal candidate for stable backporting.

 arch/nios2/include/asm/pgtable.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/nios2/include/asm/pgtable.h b/arch/nios2/include/asm/pgtable.h
index 5144506dfa693..2a6bb1aef0cca 100644
--- a/arch/nios2/include/asm/pgtable.h
+++ b/arch/nios2/include/asm/pgtable.h
@@ -286,4 +286,20 @@ void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
 #define update_mmu_cache(vma, addr, ptep) \
 	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
 
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

