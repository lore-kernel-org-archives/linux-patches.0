Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BAD3624A4;
	Wed,  3 Dec 2025 16:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780759; cv=none; b=KsK+WkYRvkO9W7OSjWYo+3fLKD9Nrps6TPyLLvXtPuEAkPPUxaY1nvs6dW89/vIDn7dvj1p84YxpNj8lK/Gaq0DiVCHbO/ts3bP+c9FkkWD1qB2J06nhl05Q9YQZAlpnId8cIHnQKAcZwQzIMt6xwxheOJNRG61i1CEd7t52LOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780759; c=relaxed/simple;
	bh=T/nQUIYnU7LFnUI09xtxulyMyLNZA9FtRRJF6fb5KOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Em05ZgZi+CpwBjp597lr4OhAuU0Lo/YkF5oSYt3mOVx5Nb/FckmNXw3cNy8eGI1BbJeqwHbtY5ul1sAWZXUT/nb83loN4K+leWAeirJQ2yE46BTjKsBCv1raCD0989d4HnU1/iCP0+AVPYPqd402q0Jbemr9oraYVRod+c5M4E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imhWkmNp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imhWkmNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2576CC4CEF5;
	Wed,  3 Dec 2025 16:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780759;
	bh=T/nQUIYnU7LFnUI09xtxulyMyLNZA9FtRRJF6fb5KOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imhWkmNpwGMQ98vBYCnnAYfx22jwVko/76P7O3TV+3ugEsE286XtpqPuZ6K07RLI+
	 Js3WS89Z3c2xLM1ZUuRGzjmjqczcNc9cZuBQWn9AimIj+Pl6SV3hKwte960tsW10Na
	 01G0Bx2Nd9IOWwiG4coUr+3paUAoJE9/S+3NHKmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Klara Modin <klarasmodin@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.12 064/132] MIPS: mm: kmalloc tlb_vpn array to avoid stack overflow
Date: Wed,  3 Dec 2025 16:29:03 +0100
Message-ID: <20251203152345.668510869@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 arch/mips/mm/tlb-r4k.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index 3facf7cc6c7d..44a662536148 100644
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
@@ -522,17 +523,26 @@ static int r4k_vpn_cmp(const void *a, const void *b)
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
-- 
2.52.0



