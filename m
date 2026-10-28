Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208334;
	b=CYWwWDz0zq0MDFagsin+8N0bWadbPxApXQlAswEu7zr71gzLscakvgKrdrq9W0o0Xris
	 ToIc9Sw3oLdEXrDLGga7p0UMwVLlTbYkuD1+3U/CXOGdFzUMcuVEOTFIp3Kt93REpTbcr
	 UHP7nWAdbBnRvP9NAL9N0d8QN/7uq72s01wuGg6MYcExPZAmb/a7wSIV1zG2mH0Y/iZLR
	 NJUMihJc2jEZqlTYOefvuFWJwM3DUnlQD6zsGoen5ceM8G2fTeuUVGb+ezHJI8CoV7JOR
	 gmT0hs0n27vPgLwuZR4CednTUe+yfYFJgk59AAsOCzMUY6lHYt+la8JTg5eUsUmncGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u+I3bvwmsRdRqT1x1XTGDFpCjq1xMSTBL5PYXWEKXMo=;
	b=VeWEFtKJDOSRrgG1uc+hcnxwwmNjR/92pCwBuCWq7pSbvgu0fgtEQRSljbrg091E0Xg1
	 NS1CuVmNrPZU4c2OCBkr7CESzCHw02btHUgS0VqLhu9Xeoa6uI25DDIOrnNR9QqdxsCo6
	 Uy3iI4vH8c7lnF0DiZi0kje+zBRJiukmW7EJAzqDGX9+mB6ORU1JvLnOsXcKvy1SMjWhY
	 xyQRkqr6GIH8PiWNsAgLwRyml/bdE1XCB9eLrqC5wgCI586iBHf5NGJ3dMbXQVD+LfRR9
	 Wn1KNFfiUfr0hzfEu5RSxAJoj4uB5/eb4/IJo3zviOmB8QBFvGa6vHpO9d7DuKpn/YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NcT6U/7N";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEF8606A32A;
	Wed, 28 Oct 2026 17:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NcT6U/7N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDD11F01828;
	Wed, 28 Oct 2026 17:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208334;
	bh=u+I3bvwmsRdRqT1x1XTGDFpCjq1xMSTBL5PYXWEKXMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NcT6U/7NQ2jW4itVUZKDqOZUrP73j6NYiDrGKsOu3xbR8WRUE3kxdaPEPJzLdpRxT
	 sFlzEJae+WxQ7XFFlzaMe++1wI+ZreJ9A4mXk0AmyRT+UASATuqv5a4hyXZGWLM2jN
	 793xECwZE4k6+5BLj9D6SlNEksBUqa+GT4vEi1V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/516] arm64: mm: Fix the lockless page-table walk in show_pte()
Date: Wed, 28 Oct 2026 17:53:54 +0100
Message-ID: <20261028170005.461757106@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ replaced guard(irqsave)() with explicit local_irq_save()/local_irq_restore() to avoid declaration-after-statement warnings. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/fault.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index d8baedd160de0..edf82cced64dd 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -14,6 +14,7 @@
 #include <linux/mm.h>
 #include <linux/hardirq.h>
 #include <linux/init.h>
+#include <linux/irqflags.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/page-flags.h>
@@ -116,6 +117,7 @@ static inline unsigned long mm_to_pgd_phys(struct mm_struct *mm)
 static void show_pte(unsigned long addr)
 {
 	struct mm_struct *mm;
+	unsigned long flags;
 	pgd_t *pgdp;
 	pgd_t pgd;
 
@@ -139,6 +141,9 @@ static void show_pte(unsigned long addr)
 	pr_alert("%s pgtable: %luk pages, %llu-bit VAs, pgdp=%016lx\n",
 		 mm == &init_mm ? "swapper" : "user", PAGE_SIZE / SZ_1K,
 		 vabits_actual, mm_to_pgd_phys(mm));
+
+	local_irq_save(flags);
+
 	pgdp = pgd_offset(mm, addr);
 	pgd = READ_ONCE(*pgdp);
 	pr_alert("[%016lx] pgd=%016llx", addr, pgd_val(pgd));
@@ -152,31 +157,32 @@ static void show_pte(unsigned long addr)
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
 		pte = READ_ONCE(*ptep);
 		pr_cont(", pte=%016llx", pte_val(pte));
 		pte_unmap(ptep);
 	} while(0);
 
 	pr_cont("\n");
+	local_irq_restore(flags);
 }
 
 /*
-- 
2.53.0



