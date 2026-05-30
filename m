Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B934D3469FC;
	Sat, 30 May 2026 17:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162718; cv=none; b=rjh4QAMXtA7QpYdNqXq4B0ZhBHr6vWPBOQajWcSfpjDnUMKaP6dC0EqkFp6KdCzBItgmjBa4XoAfMcSiBuZpRVL/GjgEAePdtQtyNm/TiVbkaL4trRCQEYH7ZPL8IWHylluyyAm4uNobxlh/GTovHYY62h8LdsZRhRcO/Ff/UVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162718; c=relaxed/simple;
	bh=ITDg/c1NS9gqGGlL1wl7EMDFtY7Glgil+0eIGZiOya4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDGemITthkuvleoHhpVAqNy/FtcZk6Icdh9O6iN6TyzMOYGcJzGVNkB2NSpRKGRjmL2F+FSvBCLZ4zCjh1wNOS8Yupst/KfgCg0DD3bso+utAyyxqW40E1nRdSNRDLVGo4vcsqwMMggXnmwqn66GLk2pFnjXhv14qRV3IHg2rNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/dwpIJK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/dwpIJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EF61F00893;
	Sat, 30 May 2026 17:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162717;
	bh=ykxOglHZ8gGVqB97LC6uGRfmtHjZHwANNZb5HyHG3f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z/dwpIJKUPiYbW6u6hj/zKyZ0bPc3t/VXYTWkAiGPBbIfpYGfm8gkteOdqd4VJVC6
	 0SV9cL5Btkw6gnr6ehmYTqGaqT7W+8GWkfnqFK1WiOOJ41XxlWz5FsVzMsxQ4NVy1g
	 Tu1pHdDfwGSi1fklng5DpvSHPLZj1SfWkKEA5Xag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Klara Modin <klarasmodin@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/776] MIPS: mm: kmalloc tlb_vpn array to avoid stack overflow
Date: Sat, 30 May 2026 17:55:57 +0200
Message-ID: <20260530160241.416741814@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

commit 841ecc979b18d3227fad5e2d6a1e6f92688776b5 upstream.

Owing to Config4.MMUSizeExt and VTLB/FTLB MMU features later MIPSr2+
cores can have more than 64 TLB entries.  Therefore allocate an array
for uniquification instead of placing too an small array on the stack.

Fixes: 35ad7e181541 ("MIPS: mm: tlb-r4k: Uniquify TLB entries on init")
Co-developed-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: stable@vger.kernel.org # v6.17+: 9f048fa48740: MIPS: mm: Prevent a TLB shutdown on initial uniquification
Cc: stable@vger.kernel.org # v6.17+
Tested-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Tested-by: Klara Modin <klarasmodin@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
[ Use memblock_free_ptr() for 5.15.y. ]
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/tlb-r4k.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index d9a5ede8869bd..78e1420471b4e 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
+#include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
 #include <linux/export.h>
@@ -512,17 +513,26 @@ static int r4k_vpn_cmp(const void *a, const void *b)
  * Initialise all TLB entries with unique values that do not clash with
  * what we have been handed over and what we'll be using ourselves.
  */
-static void r4k_tlb_uniquify(void)
+static void __ref r4k_tlb_uniquify(void)
 {
-	unsigned long tlb_vpns[1 << MIPS_CONF1_TLBS_SIZE];
 	int tlbsize = current_cpu_data.tlbsize;
+	bool use_slab = slab_is_available();
 	int start = num_wired_entries();
+	phys_addr_t tlb_vpn_size;
+	unsigned long *tlb_vpns;
 	unsigned long vpn_mask;
 	int cnt, ent, idx, i;
 
 	vpn_mask = GENMASK(cpu_vmbits - 1, 13);
 	vpn_mask |= IS_ENABLED(CONFIG_64BIT) ? 3ULL << 62 : 1 << 31;
 
+	tlb_vpn_size = tlbsize * sizeof(*tlb_vpns);
+	tlb_vpns = (use_slab ?
+		    kmalloc(tlb_vpn_size, GFP_KERNEL) :
+		    memblock_alloc_raw(tlb_vpn_size, sizeof(*tlb_vpns)));
+	if (WARN_ON(!tlb_vpns))
+		return; /* Pray local_flush_tlb_all() is good enough. */
+
 	htw_stop();
 
 	for (i = start, cnt = 0; i < tlbsize; i++, cnt++) {
@@ -575,6 +585,10 @@ static void r4k_tlb_uniquify(void)
 	tlbw_use_hazard();
 	htw_start();
 	flush_micro_tlb();
+	if (use_slab)
+		kfree(tlb_vpns);
+	else
+		memblock_free_ptr(tlb_vpns, tlb_vpn_size);
 }
 
 /*
-- 
2.53.0



