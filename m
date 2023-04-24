Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748112108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6C4C433D2;
	Mon, 24 Apr 2023 13:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343151;
	bh=XrHlzTKbU7qkV17lX17Fstu9bTeTo0DA/bz4RI8TfFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMGCFjW3VtEXgI6zPV7fO2vDB49Gq/d6SK7psZQrU6NPyVtTAGCph4EL9h3pidSe2
	 l4NHQzKj8VLw8875+IYSMWPCHTzKd1PasG7YQkZ5Wx5YtDd+9UilP+3EcgsnpT6rZs
	 dBeLStMO5uMyTPV8M9b53TRup0BfFzOVLwWF0NWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WANG Xuerui <git@xen0n.name>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.2 066/110] LoongArch: Mark 3 symbol exports as non-GPL
Date: Mon, 24 Apr 2023 15:17:28 +0200
Message-Id: <20230424131138.824903167@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Huacai Chen <chenhuacai@loongson.cn>

commit dce5ea1d0f45fa612f5760b88614a3f32bc75e3f upstream.

vm_map_base, empty_zero_page and invalid_pmd_table could be accessed
widely by some out-of-tree non-GPL but important file systems or drivers
(e.g. OpenZFS). Let's use EXPORT_SYMBOL() instead of EXPORT_SYMBOL_GPL()
to export them, so as to avoid build errors.

1, Details about vm_map_base:

This is a LoongArch-specific symbol and may be referenced through macros
PCI_IOBASE, VMALLOC_START and VMALLOC_END.

2, Details about empty_zero_page:

As it stands today, only 3 architectures export empty_zero_page as a GPL
symbol: IA64, LoongArch and MIPS. LoongArch gets the GPL export by
inheriting from MIPS, and the MIPS export was first introduced in commit
497d2adcbf50b ("[MIPS] Export empty_zero_page for sake of the ext4
module."). The IA64 export was similar: commit a7d57ecf4216e ("[IA64]
Export three symbols for module use") did so for kvm.

In both IA64 and MIPS, the export of empty_zero_page was done for
satisfying some in-kernel component built as module (kvm and ext4
respectively), and given its reasonably low-level nature, GPL is a
reasonable choice. But looking at the bigger picture it is evident most
other architectures do not regard it as GPL, so in effect the symbol
probably should not be treated as such, in favor of consistency.

3, Details about invalid_pmd_table:

Keep consistency with invalid_pte_table and make it be possible by some
modules.

Cc: stable@vger.kernel.org
Reviewed-by: WANG Xuerui <git@xen0n.name>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/cpu-probe.c |    2 +-
 arch/loongarch/mm/init.c          |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/loongarch/kernel/cpu-probe.c
+++ b/arch/loongarch/kernel/cpu-probe.c
@@ -60,7 +60,7 @@ static inline void set_elf_platform(int
 
 /* MAP BASE */
 unsigned long vm_map_base;
-EXPORT_SYMBOL_GPL(vm_map_base);
+EXPORT_SYMBOL(vm_map_base);
 
 static void cpu_probe_addrbits(struct cpuinfo_loongarch *c)
 {
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -41,7 +41,7 @@
  * don't have to care about aliases on other CPUs.
  */
 unsigned long empty_zero_page, zero_page_mask;
-EXPORT_SYMBOL_GPL(empty_zero_page);
+EXPORT_SYMBOL(empty_zero_page);
 EXPORT_SYMBOL(zero_page_mask);
 
 void setup_zero_pages(void)
@@ -270,7 +270,7 @@ pud_t invalid_pud_table[PTRS_PER_PUD] __
 #endif
 #ifndef __PAGETABLE_PMD_FOLDED
 pmd_t invalid_pmd_table[PTRS_PER_PMD] __page_aligned_bss;
-EXPORT_SYMBOL_GPL(invalid_pmd_table);
+EXPORT_SYMBOL(invalid_pmd_table);
 #endif
 pte_t invalid_pte_table[PTRS_PER_PTE] __page_aligned_bss;
 EXPORT_SYMBOL(invalid_pte_table);


