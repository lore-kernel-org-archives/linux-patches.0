Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEA48BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AC6C433A0;
	Tue, 28 Mar 2023 15:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680016331;
	bh=5/vuzYS234sPxoTRyR0qURepizo/NjXIeg9FCgD4o6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZ4eIl80MavYElfMLV2cvWE9wCsenFMGjojGKfQH4dI/qO81FzGloaUDFbiGdMekp
	 wKKj57+AXTeZ5BXvO4bK8Y9E3TMUDZwVNmFllLj7EjEjiIksew0Wjpl1IE0F0AMKnr
	 Rt0k3BlQIMqYzZot2CcBWI791f5/E5Qof2+OG0XM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Jhong <dylan@andestech.com>,
	Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 134/146] riscv: mm: Fix incorrect ASID argument when flushing TLB
Date: Tue, 28 Mar 2023 16:43:43 +0200
Message-Id: <20230328142608.248604798@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dylan Jhong <dylan@andestech.com>

commit 9a801afd3eb95e1a89aba17321062df06fb49d98 upstream.

Currently, we pass the CONTEXTID instead of the ASID to the TLB flush
function. We should only take the ASID field to prevent from touching
the reserved bit field.

Fixes: 3f1e782998cd ("riscv: add ASID-based tlbflushing methods")
Signed-off-by: Dylan Jhong <dylan@andestech.com>
Reviewed-by: Sergey Matyukevich <sergey.matyukevich@syntacore.com>
Link: https://lore.kernel.org/r/20230313034906.2401730-1-dylan@andestech.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/tlbflush.h |    2 ++
 arch/riscv/mm/context.c           |    2 +-
 arch/riscv/mm/tlbflush.c          |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/tlbflush.h
+++ b/arch/riscv/include/asm/tlbflush.h
@@ -12,6 +12,8 @@
 #include <asm/errata_list.h>
 
 #ifdef CONFIG_MMU
+extern unsigned long asid_mask;
+
 static inline void local_flush_tlb_all(void)
 {
 	__asm__ __volatile__ ("sfence.vma" : : : "memory");
--- a/arch/riscv/mm/context.c
+++ b/arch/riscv/mm/context.c
@@ -22,7 +22,7 @@ DEFINE_STATIC_KEY_FALSE(use_asid_allocat
 
 static unsigned long asid_bits;
 static unsigned long num_asids;
-static unsigned long asid_mask;
+unsigned long asid_mask;
 
 static atomic_long_t current_version;
 
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -43,7 +43,7 @@ static void __sbi_tlb_flush_range(struct
 	/* check if the tlbflush needs to be sent to other CPUs */
 	broadcast = cpumask_any_but(cmask, cpuid) < nr_cpu_ids;
 	if (static_branch_unlikely(&use_asid_allocator)) {
-		unsigned long asid = atomic_long_read(&mm->context.id);
+		unsigned long asid = atomic_long_read(&mm->context.id) & asid_mask;
 
 		if (broadcast) {
 			riscv_cpuid_to_hartid_mask(cmask, &hmask);


