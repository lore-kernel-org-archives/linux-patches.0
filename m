Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F404B32ED5F;
	Wed,  3 Dec 2025 15:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777089; cv=none; b=dRsiSm77csvRK9UcEB75A9ufCuB+ntQcWvWccBpfDgrc5wNXEyFx2wwtdmTfW/7CzFgmbzisqwEAi00PQTkS9aYI4JGhqnqB484ngNNCQ7QKfpfDQ22v0cdZOe9HIK8FTMYq7o04ASFQZlW988l+okpSn36d3Z6IweK8WHh8wUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777089; c=relaxed/simple;
	bh=hLqg8Wne/kJHo+4gdBJs6M0q4yUE09eShUW7PxXxn8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doeXIzminx17eL8IWBPU+g5xT2mPCa50Eahr55bqLAWm1K+Gg7SBFnZFV7Mx0zuuuOGD8eaHnWUn4Ip58uqGPXi8Sa88zFkoeJ2TkaZyeHlOoktQN42CxqJmqvPVeK+7XgMcpjABhfZFzBMBmYvdwEq8bH9roqJfoAP90ACmtfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNtELZRo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNtELZRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF56C4CEF5;
	Wed,  3 Dec 2025 15:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777088;
	bh=hLqg8Wne/kJHo+4gdBJs6M0q4yUE09eShUW7PxXxn8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNtELZRoGtRoHYRiGtb9+qR4dbAET6seFi2jgWjJFts3UAdS0PwDnxstCP8hbAPc0
	 Hkns57nLxQiOXK39pLPSrNMhPKyLEjUlEQ7cMTHwItYe9fguEi13nBtwjmIc7sPC6p
	 DHsUCz9HhrRIqDLSVNUuMC3693ZObHlXYOgG7edg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Klara Modin <klarasmodin@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.17 071/146] MIPS: mm: kmalloc tlb_vpn array to avoid stack overflow
Date: Wed,  3 Dec 2025 16:27:29 +0100
Message-ID: <20251203152349.065219062@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/mm/tlb-r4k.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

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
@@ -522,17 +523,26 @@ static int r4k_vpn_cmp(const void *a, co
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
@@ -585,6 +595,10 @@ static void r4k_tlb_uniquify(void)
 	tlbw_use_hazard();
 	htw_start();
 	flush_micro_tlb();
+	if (use_slab)
+		kfree(tlb_vpns);
+	else
+		memblock_free(tlb_vpns, tlb_vpn_size);
 }
 
 /*


