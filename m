Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210746;
	b=d7acpUU0kwq/i1oH53PtDPOo3oEAVabht7G82twba7/6UrrC12l+7j+PmiKXPkJD3fE+
	 BQqP7F+Zct/ApU8NqngeGZGi3JYokcnrGhrx29kL8M1RRP0NLDnHvuXXp1depZXvEd0iR
	 Bru7KsxdhGN13qYWjW7qMVnHzBOqqhzypkUQptlTZfjAqQM3IHrTD4SgB16s2DtSZsZBb
	 bc87FpZdi1YtxzIiOKgG5pduNGGPU0m/rfCuVG6WKH6I4G3HeaVD3wVfzwB7sScxp+DWy
	 J+h64hHgHDmSKLBRA0ZAb6W4ngADh8NIqptq96IYUOyPS4NazItN32/1XUG3WEhQMsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yExc0Il9Reo6gCpt5psJAMXOXesZM4iSWUeDRDCT0z4=;
	b=KdkSnQgbYmPCdLU4By56Es+mGN22nnyl/yuzJIKQsBNizvZ+FBMHiTH/F1QWc/NUjR2k
	 fgRGnOge0MELn4sq5mXEDKk1NrnUC2lLqEsL27PLxI8Udellj3gsyBeRjye4LPptRobPJ
	 QB0uRHW9ecqqkZ84mIl2WILvesqBw1Vym4UQE1xHv7AzyiNkq2TlyNK1eEjfFI89VwG/T
	 uTplig/RNKEqgWMiCxTOLlH/1WvT0iINELQO8ShJoqJwkr/7/t62npEewx1bgYykOBQaS
	 EvDZ4Xm6Q9KY6P7BcIWqx4vBaygdXOOpfvsVKa966hvDqHSxXeFGUIUuNd0XhuXElAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QxXWWXrt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86ECE606A31A;
	Wed, 28 Oct 2026 18:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QxXWWXrt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05701F01825;
	Wed, 28 Oct 2026 18:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210746;
	bh=yExc0Il9Reo6gCpt5psJAMXOXesZM4iSWUeDRDCT0z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QxXWWXrt2wZXuPH7bDpnQ2sdUgniivCKLL2F0b0lawlajmcBRFN1WsoLyTZEPPBFF
	 5IAbiXPQhQJ/2mC1gHL2cbXyN1vfmsFbMGDaPBhWTC9eBs7ub7XScYPaDIHuRz2RY+
	 jd0daiJ5xGrnQ07TKKStfdj6h2nxUA29LsuapKmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/571] arm64: mm: Fix the lockless page-table walk in show_pte()
Date: Wed, 28 Oct 2026 17:53:47 +0100
Message-ID: <20261028170009.925111657@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit a77644d009dece1104b6fcc6e322b0e4503db0d6 ]

show_pte() walks page tables locklessly and can run with interrupts
enabled. A concurrent teardown can free a table page while it is being
walked. It can also clear a parent entry after show_pte() checked it; the
regular pXd_offset() helpers then reread the cleared entry and can derive a
bogus lower-level pointer and fault again.

Use the lockless offset helpers with the saved parent entries, as
gup_fast() does, and pass the saved PMD to pte_offset_map().

For task page tables, arm64 selects MMU_GATHER_RCU_TABLE_FREE. Disable
local interrupts around the walk to hold off RCU-deferred table frees and
block the tlb_remove_table_sync_one() IPI until the walk is finished.

Place the IRQ guard after the header print. This does not make the output a
consistent snapshot, but prevents the task page-table walk from
dereferencing a released table page or deriving a pointer from a different
parent value.

Fixes: 1d18c47c735e ("arm64: MMU fault handling and page table management")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
[ replaced guard(irqsave)() with explicit local_irq_save()/local_irq_restore() calls to avoid declarations after statements. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/fault.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 39f03d18717eb..0155330b9d0da 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -15,6 +15,7 @@
 #include <linux/mm.h>
 #include <linux/hardirq.h>
 #include <linux/init.h>
+#include <linux/irqflags.h>
 #include <linux/kasan.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
@@ -123,6 +124,7 @@ static void show_pte(unsigned long addr)
 	struct mm_struct *mm;
 	pgd_t *pgdp;
 	pgd_t pgd;
+	unsigned long flags;
 
 	if (is_ttbr0_addr(addr)) {
 		/* TTBR0 */
@@ -144,6 +146,9 @@ static void show_pte(unsigned long addr)
 	pr_alert("%s pgtable: %luk pages, %llu-bit VAs, pgdp=%016lx\n",
 		 mm == &init_mm ? "swapper" : "user", PAGE_SIZE / SZ_1K,
 		 vabits_actual, mm_to_pgd_phys(mm));
+
+	local_irq_save(flags);
+
 	pgdp = pgd_offset(mm, addr);
 	pgd = READ_ONCE(*pgdp);
 	pr_alert("[%016lx] pgd=%016llx", addr, pgd_val(pgd));
@@ -157,25 +162,25 @@ static void show_pte(unsigned long addr)
 		if (pgd_none(pgd) || pgd_bad(pgd))
 			break;
 
-		p4dp = p4d_offset(pgdp, addr);
+		p4dp = p4d_offset_lockless(pgdp, pgd, addr);
 		p4d = READ_ONCE(*p4dp);
 		pr_cont(", p4d=%016llx", p4d_val(p4d));
 		if (p4d_none(p4d) || p4d_bad(p4d))
 			break;
 
-		pudp = pud_offset(p4dp, addr);
+		pudp = pud_offset_lockless(p4dp, p4d, addr);
 		pud = READ_ONCE(*pudp);
 		pr_cont(", pud=%016llx", pud_val(pud));
 		if (pud_none(pud) || pud_bad(pud))
 			break;
 
-		pmdp = pmd_offset(pudp, addr);
+		pmdp = pmd_offset_lockless(pudp, pud, addr);
 		pmd = READ_ONCE(*pmdp);
 		pr_cont(", pmd=%016llx", pmd_val(pmd));
 		if (pmd_none(pmd) || pmd_bad(pmd))
 			break;
 
-		ptep = pte_offset_map(pmdp, addr);
+		ptep = pte_offset_map(&pmd, addr);
 		if (!ptep)
 			break;
 
@@ -185,6 +190,7 @@ static void show_pte(unsigned long addr)
 	} while(0);
 
 	pr_cont("\n");
+	local_irq_restore(flags);
 }
 
 /*
-- 
2.53.0



