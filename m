Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4397023777
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjOxMQLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE91C433C7;
	Mon,  6 Nov 2023 13:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277600;
	bh=DSXOKVr1fjRJQwCJbzcOLLJ3gnufvHMW8cLs/ELakWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjOxMQLLdyJJ7kEFz2K0r9UOm34m8Ec4KlZPBbGtvQ03efR0vc9dyDJ41bkJaNjke
	 d0GunijyjKxDNgn1BV0/8jCUg9JWTC2N4Gidwfl+joJYyPk3k899XyV7KOzNedVcID
	 VrA0ZjFkBIBKAuKE22GHmY5QkOII97q32wXkEsp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erhard Furtner <erhard_f@mailbox.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 74/95] powerpc/mm: Fix boot crash with FLATMEM
Date: Mon,  6 Nov 2023 14:04:42 +0100
Message-ID: <20231106130307.425671956@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>
References: <20231106130304.678610325@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit daa9ada2093ed23d52b4c1fe6e13cf78f55cc85f ]

Erhard reported that his G5 was crashing with v6.6-rc kernels:

  mpic: Setting up HT PICs workarounds for U3/U4
  BUG: Unable to handle kernel data access at 0xfeffbb62ffec65fe
  Faulting instruction address: 0xc00000000005dc40
  Oops: Kernel access of bad area, sig: 11 [#1]
  BE PAGE_SIZE=4K MMU=Hash SMP NR_CPUS=2 PowerMac
  Modules linked in:
  CPU: 0 PID: 0 Comm: swapper/0 Tainted: G                T  6.6.0-rc3-PMacGS #1
  Hardware name: PowerMac11,2 PPC970MP 0x440101 PowerMac
  NIP:  c00000000005dc40 LR: c000000000066660 CTR: c000000000007730
  REGS: c0000000022bf510 TRAP: 0380   Tainted: G                T (6.6.0-rc3-PMacGS)
  MSR:  9000000000001032 <SF,HV,ME,IR,DR,RI>  CR: 44004242  XER: 00000000
  IRQMASK: 3
  GPR00: 0000000000000000 c0000000022bf7b0 c0000000010c0b00 00000000000001ac
  GPR04: 0000000003c80000 0000000000000300 c0000000f20001ae 0000000000000300
  GPR08: 0000000000000006 feffbb62ffec65ff 0000000000000001 0000000000000000
  GPR12: 9000000000001032 c000000002362000 c000000000f76b80 000000000349ecd8
  GPR16: 0000000002367ba8 0000000002367f08 0000000000000006 0000000000000000
  GPR20: 00000000000001ac c000000000f6f920 c0000000022cd985 000000000000000c
  GPR24: 0000000000000300 00000003b0a3691d c0003e008030000e 0000000000000000
  GPR28: c00000000000000c c0000000f20001ee feffbb62ffec65fe 00000000000001ac
  NIP hash_page_do_lazy_icache+0x50/0x100
  LR  __hash_page_4K+0x420/0x590
  Call Trace:
    hash_page_mm+0x364/0x6f0
    do_hash_fault+0x114/0x2b0
    data_access_common_virt+0x198/0x1f0
  --- interrupt: 300 at mpic_init+0x4bc/0x10c4
  NIP:  c000000002020a5c LR: c000000002020a04 CTR: 0000000000000000
  REGS: c0000000022bf9f0 TRAP: 0300   Tainted: G                T (6.6.0-rc3-PMacGS)
  MSR:  9000000000001032 <SF,HV,ME,IR,DR,RI>  CR: 24004248  XER: 00000000
  DAR: c0003e008030000e DSISR: 40000000 IRQMASK: 1
  ...
  NIP mpic_init+0x4bc/0x10c4
  LR  mpic_init+0x464/0x10c4
  --- interrupt: 300
    pmac_setup_one_mpic+0x258/0x2dc
    pmac_pic_init+0x28c/0x3d8
    init_IRQ+0x90/0x140
    start_kernel+0x57c/0x78c
    start_here_common+0x1c/0x20

A bisect pointed to the breakage beginning with commit 9fee28baa601 ("powerpc:
implement the new page table range API").

Analysis of the oops pointed to a struct page with a corrupted
compound_head being loaded via page_folio() -> _compound_head() in
hash_page_do_lazy_icache().

The access by the mpic code is to an MMIO address, so the expectation
is that the struct page for that address would be initialised by
init_unavailable_range(), as pointed out by Aneesh.

Instrumentation showed that was not the case, which eventually lead to
the realisation that pfn_valid() was returning false for that address,
causing the struct page to not be initialised.

Because the system is using FLATMEM, the version of pfn_valid() in
memory_model.h is used:

static inline int pfn_valid(unsigned long pfn)
{
	...
	return pfn >= pfn_offset && (pfn - pfn_offset) < max_mapnr;
}

Which relies on max_mapnr being initialised. Early in boot max_mapnr is
zero meaning no PFNs are valid.

max_mapnr is initialised in mem_init() called via:

  start_kernel()
    mm_core_init()  # init/main.c:928
      mem_init()

But that is too late for the usage in init_unavailable_range() called via:

  start_kernel()
    setup_arch()    # init/main.c:893
      paging_init()
        free_area_init()
          init_unavailable_range()

Although max_mapnr is currently set in mem_init(), the value is actually
already available much earlier, as soon as mem_topology_setup() has
completed, which is also before paging_init() is called. So move the
initialisation there, which causes paging_init() to correctly initialise
the struct page and fixes the bug.

This bug seems to have been lurking for years, but went unnoticed
because the pre-folio code was inspecting the uninitialised page->flags
but not dereferencing it.

Thanks to Erhard and Aneesh for help debugging.

Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Closes: https://lore.kernel.org/all/20230929132750.3cd98452@yea/
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231023112500.1550208-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/setup-common.c | 2 ++
 arch/powerpc/mm/mem.c              | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index da8c71f321ad3..1e417c3eedfef 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -906,6 +906,8 @@ void __init setup_arch(char **cmdline_p)
 
 	/* Parse memory topology */
 	mem_topology_setup();
+	/* Set max_mapnr before paging_init() */
+	set_max_mapnr(max_pfn);
 
 	/*
 	 * Release secondary cpus out of their spinloops at 0x60 now that
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 1ed276d2305fa..08e3422eb7926 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -293,7 +293,6 @@ void __init mem_init(void)
 #endif
 
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE);
-	set_max_mapnr(max_pfn);
 
 	kasan_late_init();
 
-- 
2.42.0



