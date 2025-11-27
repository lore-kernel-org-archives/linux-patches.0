Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128C528D850;
	Thu, 27 Nov 2025 14:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255021; cv=none; b=VisbxeTH8Z6dVCh4JTlopWZovgHYelEnkrqi4z9JXK5SjttvjTDDWM77oy5/VYy5QWDw1bQMqJe+UQ2sJEHP4Iza/6BzoVqIdgn9H3VtWDiFfP5Hy7t//OZVyrT2xFb4iEAU5hWDWGEw1pRJ2XpjB4OZ/2fMnfUqS7ETwkjfP4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255021; c=relaxed/simple;
	bh=NL083HLjM+AlG332QKV3nPyfOFS7AqID58IHVgHBEek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElvZywBRPzyp+w/JSgwpFexEryFfNl01SD8SuXZN7lBeyrIwZw7WboPHuvhtCTbQknJ6vxNRIaA1abON3r8ZObQBdd1NPZOCjYEEPLntgThFcpGqG695yKRUa/kcTMxP4rNwf03SAKl3PJ+7/GV2/CGqJD2rhgruGBweCZmGqTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBdFFhYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBdFFhYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633ACC4CEF8;
	Thu, 27 Nov 2025 14:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255020;
	bh=NL083HLjM+AlG332QKV3nPyfOFS7AqID58IHVgHBEek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wBdFFhYuICFV8XD27rC8SyLzZ/vZbvvCH0clj+Aq25Dsfncp0FAgUq3LT6y7vZFgz
	 WgF3Q1+nTFSOHzn2ASa0MClPG4bOB7C3rfuNRButadxNJZi3ozxOb3DjHWQmKh2ivA
	 iPXcdTZw7Tf2zqEWKmfd9OEFRKUtSXm9mOYCTMyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 67/86] s390/mm: Fix __ptep_rdp() inline assembly
Date: Thu, 27 Nov 2025 15:46:23 +0100
Message-ID: <20251127144030.281178622@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 31475b88110c4725b4f9a79c3a0d9bbf97e69e1c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/pgtable.h | 12 +++++-------
 arch/s390/mm/pgtable.c          |  4 ++--
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index da2e91b5b1925..2cc9d7bb1b2ac 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1065,17 +1065,15 @@ static inline pte_t pte_mkhuge(pte_t pte)
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
@@ -1259,7 +1257,7 @@ static inline void flush_tlb_fix_spurious_fault(struct vm_area_struct *vma,
 	 * A local RDP can be used to do the flush.
 	 */
 	if (MACHINE_HAS_RDP && !(pte_val(*ptep) & _PAGE_PROTECT))
-		__ptep_rdp(address, ptep, 0, 0, 1);
+		__ptep_rdp(address, ptep, 1);
 }
 #define flush_tlb_fix_spurious_fault flush_tlb_fix_spurious_fault
 
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 5e349869590a8..1fb435b3913cd 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -312,9 +312,9 @@ void ptep_reset_dat_prot(struct mm_struct *mm, unsigned long addr, pte_t *ptep,
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
-- 
2.51.0



