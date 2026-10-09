Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DDA4EB85C;
	Fri,  9 Oct 2026 14:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557344; cv=none; b=RvvOzzSogK0d3uoo8gyNzo2J5Qy/VAB7+nnod3OoL/8IwFRk3MciyzoOowiyhBPvAR8WM/ZVVSFq/7GK+f4jJ8+jyvdeuRuCH+tJiiXj67cLsCBD0Ufasd5UFJhCwihNDsbsH5EAPNffIIFObyVGdu8wjLmxFcVTMeb1WLXj17M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557344; c=relaxed/simple;
	bh=9VDkY1L7PXOsPAT+hYQeYZ/Npt2M9xTzajLGuYV8Jks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfCMwJLUOI5XVBK5jI+QmO57evalYKTkRyGSyeXG1PNJ+iFyidqAihulV3bhynDJsPHzAaUrVoSO6Tf0/BlzysrohJNVDX7FvC8H38hGbqcTuf5i6E22emOAqMCoPz9/NNW8U3yB6WpMUDBbDGr2+5h5laf9UYIWW3/gekoEPRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02HPhUEW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02HPhUEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1151F000FF;
	Fri,  9 Oct 2026 14:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557343;
	bh=9IzHz7q8K0JY4qiOcNprTaEXgyVa4G1Wjd5weLFWdxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=02HPhUEWhAThA3CHy+eQ9L3ywFYx5g20Sk9L5Gf5hT0moby2nYq4CwgyUEU31ofbp
	 UgPhcx2vyoU/+pOur8xCz+R98gxt6cvm5QxhH1xL6EMmUUiXszMNGF3v/41aaYhrod
	 THnMInvJWBj06QlQv8iA3mAfjYbYcpksFggv2EfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 385/403] arm64: mm: Fix the break-before-make flush range for erratum 2645198
Date: Fri,  9 Oct 2026 16:12:26 +0200
Message-ID: <20261009141001.338821198@linuxfoundation.org>
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

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 1fef81669147d63eb8c5d3627d54eadc21173a0b ]

modify_prot_start_ptes() performs the break-before-make TLB invalidation
required by erratum 2645198 with __flush_tlb_range(), whose third
argument is the end address of the range.  It passes nr * PAGE_SIZE
instead of addr + nr * PAGE_SIZE, so __do_flush_tlb_range() computes the
page count as (nr * PAGE_SIZE - addr) >> PAGE_SHIFT.

For addr > nr * PAGE_SIZE that subtraction underflows, the page count
exceeds the batching limit and the flush degenerates to flush_tlb_mm(),
so a single-page mprotect broadcasts an ASID-wide invalidation and a
full-range mmu notifier call.

For addr <= nr * PAGE_SIZE only [addr, nr * PAGE_SIZE) is invalidated,
and when the cleared batch starts below nr * PAGE_SIZE the tail is left
in the TLB.  The workaround then no longer covers the whole batch, and
for addr == nr * PAGE_SIZE the flush is empty.

On affected Cortex-A715 CPUs, this can corrupt ESR_ELx and FAR_ELx on the
next instruction abort caused by a permission fault.

Pass addr + nr * PAGE_SIZE as the end address.

Fixes: 7efa1cd5f89b5 ("arm64: add batched versions of ptep_modify_prot_start/commit")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
[ sashal: Adapted __flush_tlb_range() arguments from PAGE_SIZE, 3, TLBF_NOWALKCACHE to PAGE_SIZE, true, 3. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2150,7 +2150,7 @@ pte_t modify_prot_start_ptes(struct vm_a
 		 * in cases where cpu is affected with errata #2645198.
 		 */
 		if (pte_accessible(vma->vm_mm, pte) && pte_user_exec(pte))
-			__flush_tlb_range(vma, addr, nr * PAGE_SIZE,
+			__flush_tlb_range(vma, addr, addr + nr * PAGE_SIZE,
 					  PAGE_SIZE, true, 3);
 	}
 


