Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F68300C1E;
	Sun,  1 Jun 2025 23:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748821004; cv=none; b=F1bXzKUpWYZzXbSiBp1hyckUHeGKbbCyLBn8iSH+dQmxYgAioPx8Et2qSiNzZ8cQddRLDqHdbe71iO5u1rKSwxYShX8pGxkZzQmWppJv2DgV2AtVG5ogVZ1Oulfbxjls/VmwXaDHNQ0+ztorBIbfXw7FskIl29VSQhjcgiFKk5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748821004; c=relaxed/simple;
	bh=/xZhtlZ0I1j7o78k4OE359nzlxP1iIRoK+L1jSLikLo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q07A3p6HNaZ9U1c+Jj5ONrZEK4Dh8m9EBHLXCC+x4iUiL50x6CcBPKwa6gozfqewmusbdILWHyFVac6a85JHwlglexuCM3vmHaAV+9QtXu9nqSvlMHKZxE1odYUrijda26/eEifQfrzIGFJebqhwNW04f33HU3oxylGyklmCPEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WFntShNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WFntShNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04101C4CEE7;
	Sun,  1 Jun 2025 23:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748821003;
	bh=/xZhtlZ0I1j7o78k4OE359nzlxP1iIRoK+L1jSLikLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFntShNon3I2egHlctywAgwsTP5WUGun7tOQCAqswIFR24iNstLMYPh0W90E/MuYm
	 59tMzYxYiT4H1JhOXW3VjolcvJAz1gAxxuMCStEaMtaK/2xStmGv5WOaw2qTFjFavF
	 TfBw2mfvL6QCUAamfy9SAzkqlz5Nv8AJ/mjtxC4/6DdgVldvt7FtKbIokYt6pKAHXn
	 hp0B4ycxVIZPkfs23o33Lhl6DZJTKEKbMV+G8zzQhC3K79lLhvGjR9kSiwcsX2A5SD
	 pUGMKeqwsHgz9oC1Mjlm9wAxhMhYF3q1VpOkLHkN5hdncQz2h+zcAD/tVvSfJCsZqC
	 TaROEDW8UNpWw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Simon Schuster <schuster.simon@siemens-energy.com>,
	Andreas Oetken <andreas.oetken@siemens-energy.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 62/93] nios2: force update_mmu_cache on spurious tlb-permission--related pagefaults
Date: Sun,  1 Jun 2025 19:33:29 -0400
Message-Id: <20250601233402.3512823-62-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601233402.3512823-1-sashal@kernel.org>
References: <20250601233402.3512823-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
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
index eab87c6beacb5..e5d64c84aadf7 100644
--- a/arch/nios2/include/asm/pgtable.h
+++ b/arch/nios2/include/asm/pgtable.h
@@ -291,4 +291,20 @@ void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
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

