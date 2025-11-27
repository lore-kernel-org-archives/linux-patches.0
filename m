Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3C6334684;
	Thu, 27 Nov 2025 14:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255521; cv=none; b=FjC82dd23SqW4FgQUOZ8dkmzfHmo3SZ/XVbPitIktTSmjJhV3wNP7dQR/cDkqWGoBdiHIxtutZ6WyJCqSdC6/M6mYyJwnT8Us7x3BUx/Zf/FVpcyV1ax5S+3C6qdKLWFiJq2FtZC0PzBY1KuHsDD/R+/ec9sKcnDM54DwO/a84M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255521; c=relaxed/simple;
	bh=ZQRgNRaweplUL4DQRaDtWloSSY/iLPKQ2FRXtI2LXAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flHDvdl5Yhog3lvVywZFyyknFjv71SdosMPU31cGJ3YmLx5/BNMebw3KQpK5gYoz3sFOaVQxEV3xiVINLC6pKQPIl/lKUuVrzyQCOjGXCv2bpxNohpUT6z3T0FKn2qbsEOSWZIvAEFLvWgwFQrtyoz0B0uMmq8f/O5tixWOx4Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKp4F5T4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKp4F5T4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6E2C4CEF8;
	Thu, 27 Nov 2025 14:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255520;
	bh=ZQRgNRaweplUL4DQRaDtWloSSY/iLPKQ2FRXtI2LXAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKp4F5T4hxzklr3xpgqAc7b+aMeZCgEAl4iQJ8fGJ4yp1T8iLeuFIDUR2+t7Y/Vcz
	 F6lGjpxOfC//Zz6Bzsk9SpddrMOVhXkPEGaIhX8eerJik0ixhwxIHysrlTXEl44erl
	 4bEBEnyljCN7jLcvTCmZAu3eMBq0jmQ3ZfPEvHn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.17 021/175] s390/mm: Fix __ptep_rdp() inline assembly
Date: Thu, 27 Nov 2025 15:44:34 +0100
Message-ID: <20251127144043.734735340@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

commit 31475b88110c4725b4f9a79c3a0d9bbf97e69e1c upstream.

When a zero ASCE is passed to the __ptep_rdp() inline assembly, the
generated instruction should have the R3 field of the instruction set to
zero. However the inline assembly is written incorrectly: for such cases a
zero is loaded into a register allocated by the compiler and this register
is then used by the instruction.

This means that selected TLB entries may not be flushed since the specified
ASCE does not match the one which was used when the selected TLB entries
were created.

Fix this by removing the asce and opt parameters of __ptep_rdp(), since
all callers always pass zero, and use a hard-coded register zero for
the R3 field.

Fixes: 0807b856521f ("s390/mm: add support for RDP (Reset DAT-Protection)")
Cc: stable@vger.kernel.org
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/pgtable.h |   12 +++++-------
 arch/s390/mm/pgtable.c          |    4 ++--
 2 files changed, 7 insertions(+), 9 deletions(-)

--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1154,17 +1154,15 @@ static inline pte_t pte_mkhuge(pte_t pte
 #define IPTE_NODAT	0x400
 #define IPTE_GUEST_ASCE	0x800
 
-static __always_inline void __ptep_rdp(unsigned long addr, pte_t *ptep,
-				       unsigned long opt, unsigned long asce,
-				       int local)
+static __always_inline void __ptep_rdp(unsigned long addr, pte_t *ptep, int local)
 {
 	unsigned long pto;
 
 	pto = __pa(ptep) & ~(PTRS_PER_PTE * sizeof(pte_t) - 1);
-	asm volatile(".insn rrf,0xb98b0000,%[r1],%[r2],%[asce],%[m4]"
+	asm volatile(".insn	rrf,0xb98b0000,%[r1],%[r2],%%r0,%[m4]"
 		     : "+m" (*ptep)
-		     : [r1] "a" (pto), [r2] "a" ((addr & PAGE_MASK) | opt),
-		       [asce] "a" (asce), [m4] "i" (local));
+		     : [r1] "a" (pto), [r2] "a" (addr & PAGE_MASK),
+		       [m4] "i" (local));
 }
 
 static __always_inline void __ptep_ipte(unsigned long address, pte_t *ptep,
@@ -1348,7 +1346,7 @@ static inline void flush_tlb_fix_spuriou
 	 * A local RDP can be used to do the flush.
 	 */
 	if (cpu_has_rdp() && !(pte_val(*ptep) & _PAGE_PROTECT))
-		__ptep_rdp(address, ptep, 0, 0, 1);
+		__ptep_rdp(address, ptep, 1);
 }
 #define flush_tlb_fix_spurious_fault flush_tlb_fix_spurious_fault
 
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -274,9 +274,9 @@ void ptep_reset_dat_prot(struct mm_struc
 	preempt_disable();
 	atomic_inc(&mm->context.flush_count);
 	if (cpumask_equal(mm_cpumask(mm), cpumask_of(smp_processor_id())))
-		__ptep_rdp(addr, ptep, 0, 0, 1);
+		__ptep_rdp(addr, ptep, 1);
 	else
-		__ptep_rdp(addr, ptep, 0, 0, 0);
+		__ptep_rdp(addr, ptep, 0);
 	/*
 	 * PTE is not invalidated by RDP, only _PAGE_PROTECT is cleared. That
 	 * means it is still valid and active, and must not be changed according


