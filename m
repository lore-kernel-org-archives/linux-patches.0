Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0B347607B;
	Fri,  7 Aug 2026 15:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117394; cv=none; b=SEcPUWYehryYX65AzYH4/x3aSIb/7GpAHh/SxB/ctiIEGD9OK1csn8W5oSOI0YsHbZWGjXtmY9BjD28KYM2GK5/D5VZ9m5nRVCUuGcfQ2ryfSFwKR65UtSXZnxjWE0LgU7D14NX1jITLvb0z6c9gnwz3OLzW1lKaa5RHFH5jXwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117394; c=relaxed/simple;
	bh=Nb2L0LE4/dsmlLHaZa4k6Pw6KesGdRgycoyFOwKTqhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnyUKFGwLnrg2gZhS1ZnbHUFiCMNzUd/LlUzzuuvhdN28PR1xn7/8ZLMF9RpxY/5/ICNSgbrj7fptqxr1kUQN2aWjPW74nU60vvB08myz8xqx9cDlzhpk3FQnSaUc1SOSSc6PwCTN83dyDkmQ4KWJ/+vdSuHGhjZgsycfEroGgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOLq0xmv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOLq0xmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B7D1F000E9;
	Fri,  7 Aug 2026 15:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117392;
	bh=v7/FYfdfMrH+Kd4Ohs0PVwbPiHzQBMi1qYzeJ1o1H3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FOLq0xmvwfmHAMvetXCG3j6/5eYjY+gicj9jeLp5bDAr4piad5ltbNti1V64abghC
	 u+5UONXoC6glKS6x6yXAv3KTDq+bjpwkkCT9tj8XttsewByI0DLSQBpD+Fyw6ALKdU
	 KSmgl6APAbmhtyHJr2bOHRBn73EEtxAlqSptxot8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	David Hildenbrand <david@kernel.org>,
	Guo Ren <guoren@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nam Cao <namcao@linutronix.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 301/438] riscv/mm: use physical alignment for vmemmap_start_pfn
Date: Fri,  7 Aug 2026 16:38:17 +0200
Message-ID: <20260807143434.389818187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiakai Xu <xujiakai2025@iscas.ac.cn>

commit 45ebe4540817cb540a59e4dc04014ac5dddc9990 upstream.

RISC-V computes vmemmap_start_pfn by rounding phys_ram_base down to
VMEMMAP_ADDR_ALIGN.  That alignment must therefore be expressed in the
physical-address domain.

Commit 476849b0fba4 ("riscv/mm: align vmemmap to maximal folio size")
attempted to account for the maximal folio alignment by feeding
MAX_FOLIO_VMEMMAP_ALIGN directly into VMEMMAP_ADDR_ALIGN.  However,
MAX_FOLIO_VMEMMAP_ALIGN is measured in bytes of struct page storage,
whereas VMEMMAP_ADDR_ALIGN is used to align a physical address.

The mask-based compound_info encoding requires pfn_to_page(0) to be
naturally aligned to MAX_FOLIO_VMEMMAP_ALIGN.  Commit 9f94db4c7eaa
("mm/sparse: check memmap alignment for compound_info_has_mask()") added a
check for that requirement and exposed the unit mismatch on systems such
as QEMU virt, where the DRAM base is not aligned to MAX_FOLIO_NR_PAGES *
PAGE_SIZE.

Here is the log:
[    0.000000][    C0] ------------[ cut here ]------------
[    0.000000][    C0] WARNING: mm/sparse.c:365 at sparse_init+0x58a/0x6fe, CPU#0: swapper/0
[    0.000000][    C0] Modules linked in:
[    0.000000][    C0] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7.2.0-rc3-g1d8304bdd65f #2 PREEMPT
[    0.000000][    C0] Hardware name: riscv-virtio,qemu (DT)
[    0.000000][    C0] epc : sparse_init+0x58a/0x6fe
[    0.000000][    C0]  ra : sparse_init+0x58a/0x6fe
[    0.000000][    C0] epc : ffffffff86851c88 ra : ffffffff86851c88 sp : ffffffff88807a30
[    0.000000][    C0]  gp : ffffffff8a3bf240 tp : ffffffff88842080 t0 : ff600000ffab6000
[    0.000000][    C0]  t1 : 000000017fab6000 t2 : 65203a6573726363 s0 : ffffffff88807bc0
[    0.000000][    C0]  s1 : 000000000e000000 a0 : 0000000000000007 a1 : 0000000000000000
[    0.000000][    C0]  a2 : 0000000000000002 a3 : ffffffff86851c88 a4 : 0000000000000000
[    0.000000][    C0]  a5 : ffffffff88843080 a6 : 0000000000000003 a7 : 0000000000000000
[    0.000000][    C0]  s2 : ff60000000000000 s3 : 0040000000000000 s4 : 0004000000000000
[    0.000000][    C0]  s5 : ffffffff8a4d92e0 s6 : ff600000ffab55e0 s7 : ffffffff88384d00
[    0.000000][    C0]  s8 : 0000000000000003 s9 : ffffffff88384cc1 s10: ffffffff88384cc0
[    0.000000][    C0]  s11: ffffffff8a4daae0 t3 : ffffffff915e8b20 t4 : ffffffff915e8b20
[    0.000000][    C0]  t5 : ffffffff915e8b20 t6 : ffffffff915e8bc8 ssp : 0000000000000000
[    0.000000][    C0] status: 0000000200000100 badaddr: ffffffff86851c88 cause: 0000000000000003
[    0.000000][    C0] [<ffffffff86851c88>] sparse_init+0x58a/0x6fe
[    0.000000][    C0] [<ffffffff8683d396>] mm_core_init_early+0x116/0x1e30
[    0.000000][    C0] [<ffffffff86801edc>] start_kernel+0xd2/0x848

Convert MAX_FOLIO_VMEMMAP_ALIGN to the equivalent physical alignment
before using it in VMEMMAP_ADDR_ALIGN.  This keeps the existing
round_down() logic while making the resulting vmemmap base satisfy the
mask-alignment requirement.

Link: https://lore.kernel.org/20260716115326.3466926-1-xujiakai2025@iscas.ac.cn
Fixes: 476849b0fba4 ("riscv/mm: align vmemmap to maximal folio size")
Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: David Hildenbrand <david@kernel.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nam Cao <namcao@linutronix.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Assisted-by: YuanSheng:DeepSeek-V4-Flash
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -61,7 +61,8 @@ EXPORT_SYMBOL(phys_ram_base);
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 #define VMEMMAP_ADDR_ALIGN	max(1ULL << SECTION_SIZE_BITS, \
-				    MAX_FOLIO_VMEMMAP_ALIGN)
+				    PFN_PHYS(MAX_FOLIO_VMEMMAP_ALIGN / \
+					     sizeof(struct page)))
 
 unsigned long vmemmap_start_pfn __ro_after_init;
 EXPORT_SYMBOL(vmemmap_start_pfn);


