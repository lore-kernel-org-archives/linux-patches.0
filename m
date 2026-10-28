Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212288;
	b=mQFaeBc78WjrUji1kpuFzWGP2neMyL2Gz9ejIA99YCHUlshMjOTBzDJExYrVRH3AzJjq
	 ilIAkKByF1v0M3YRM+MgYw2UXXXOiy9eM7favZ0igtRVHwv/JfhH0wdmOjTxWoqtb4Tsy
	 eDLtxzSsVuk4BlkopeRNzwFL8jB2sNPIhcChuNMPu6jP75eKTMZwzSzoGuLvThyxQLAFZ
	 zO6OsCQcj9EPtypuCyUlccHe4UiiqO+Oz+idJ5GGa2FxIGOvCj3VMCnfwRAF8cacTmqwd
	 qfTummaN51e+dKx4uqkT1q1Y1u+aJdB+cLBIyebuXQCavfZ1DVMdfR73OeVrF8X4HWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212288;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MNgXIQ8mvW/zChUFJaVuBFc3KImdO1PuPEJHEFisnyI=;
	b=wlJ21BtuZucKn9L4zYPbki9gRM8/ftv5QgGJQEVa6gft2NAMvJhTyiDvVIvEazc0D8a1
	 s8OzHAmPWRlWijeZto0jPEjog3krW1dAW89DnbYEBB/lSUTTUQZUKmtooSp7JNWJQfZz0
	 EhxVf0+tvauFAQUTKCoiFmEBrREaBqXTgPMG7kqHyCnfZhLwgzd11bJzHROyW4jqRQ14a
	 X55UafiTjYBFw+E1rR3TbpIdzmSPDLSDtzF+ucwoPYzInJhVZUQasKVbbhcbPDFAQ2o8h
	 7FwJ+2kmvDobPn86pvMVLVEDi2GFA41p10WRwuQ8XcQDHIPWRr73dzI0no7TG1HheMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XNr0zdCw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D81E606A31E;
	Wed, 28 Oct 2026 18:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XNr0zdCw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8291F031E0;
	Wed, 28 Oct 2026 18:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212288;
	bh=MNgXIQ8mvW/zChUFJaVuBFc3KImdO1PuPEJHEFisnyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XNr0zdCw9PVWibihTaPCepbqcMUCA6/QXTA7soNWE/oyFJSmknkTjuEkzsQ0Pml2t
	 qmPdRO/CQI8WR6Nzq8sfdaSw3wCZCu8N8IL/kdcbySLF82Kr5G2tGZdvajyFibi3J4
	 jlcuZexpHhrpWrrS27O3UwCqOU2KAObqCCvJZcI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0101/1887] arm64: mm: Fix the lockless page-table walk in show_pte()
Date: Wed, 28 Oct 2026 17:36:37 +0100
Message-ID: <20261028170501.532672770@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/fault.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index c4120bd80a9b4..5bd5e10c49f18 100644
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
@@ -145,6 +146,9 @@ static void show_pte(unsigned long addr)
 	pr_alert("%s pgtable: %luk pages, %llu-bit VAs, pgdp=%016lx\n",
 		 mm == &init_mm ? "swapper" : "user", PAGE_SIZE / SZ_1K,
 		 vabits_actual, mm_to_pgd_phys(mm));
+
+	guard(irqsave)();
+
 	pgdp = pgd_offset(mm, addr);
 	pgd = READ_ONCE(*pgdp);
 	pr_alert("[%016lx] pgd=%016llx", addr, pgd_val(pgd));
@@ -158,25 +162,25 @@ static void show_pte(unsigned long addr)
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
 
-- 
2.53.0



