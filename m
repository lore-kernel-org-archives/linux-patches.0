Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A1E31E106;
	Sat, 12 Sep 2026 13:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221374; cv=none; b=JCF9gBkssWu+ROYMta43s50wZyzUuHZFkmYjRZY2a+2ukWqOge5oqm0883SI9ugGf7xF8HkGWwiEoGJSpxWQWEQsVmtPsHDUstIdLf+ZKKd4tdxLun2HVTnHI1+CE7wJ79Pgo4VNKK+6WR1sjk00GqnUs6zG+O9W1hcpmiEoP8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221374; c=relaxed/simple;
	bh=2T+6irnyvW2hMUnGKN8TW+quuF6vFsbyybUKoqIQ35w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcMLq6Vi2ZDIbZT4dGLYBPR/T6EFmw37cjpgu9dJ0d1cfXfFAD9bN/6Rp798XhidZpOVD9I2lE1lkHTFOOIogLMFiD11jT8SRllAdSOf299k61aoMpGfZM9sGuGG5Iq4ULCFzOoY0L5w9qHb2ryqaokMcbj4jFAzTZXwUyop6Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GAHur1Rt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GAHur1Rt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CE71F000FF;
	Sat, 12 Sep 2026 13:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221371;
	bh=jgRl3tb2bsRseJT71xBY3E3fuRStYekTYLJTG8Ckytg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GAHur1RtgSVVhdTCctNQJ8AoOeAP6izCheLBbvvJM6mReyQAmFGU4XfBiSJ3LLQRd
	 34hOsScIAXlY98xtZmWmSJBRebRJfGh9jpw+yb2xRruoWjzr2X2tCsqWpaAKRS4yzH
	 sk3qrYQF3G6Tb7XcldiEk6jgKbaW7IVuIty/U764=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 0369/1424] arm64: mm: Fix the lockless page-table walk in show_pte()
Date: Sat, 12 Sep 2026 08:46:41 +0200
Message-ID: <20260912065615.556879615@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

commit a77644d009dece1104b6fcc6e322b0e4503db0d6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/fault.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

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
@@ -156,6 +157,9 @@ static void show_pte(unsigned long addr)
 	pr_alert("%s pgtable: %luk pages, %llu-bit VAs, pgdp=%016lx\n",
 		 mm == &init_mm ? "swapper" : "user", PAGE_SIZE / SZ_1K,
 		 vabits_actual, mm_to_pgd_phys(mm));
+
+	guard(irqsave)();
+
 	pgdp = pgd_offset(mm, addr);
 	pgd = READ_ONCE(*pgdp);
 	pr_alert("[%016lx] pgd=%016llx", addr, pgd_val(pgd));
@@ -169,25 +173,25 @@ static void show_pte(unsigned long addr)
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
 


