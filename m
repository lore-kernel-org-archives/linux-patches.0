Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C8814267
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 18:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392C4C433C8;
	Thu, 29 Jun 2023 18:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688064305;
	bh=TLBGj4dqfLU3IcziBijSAv3P3ZcbkS9Q766oMjASvus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hCHkP9fapYcPRrqyGK8k0RsJfWsZP/CGYpBwx+DbHpJ+n4ScAhd8nylkmXUqn2+d7
	 /uwJiSx95Q32FPqoxWskNQw9nZORGgqpKUeSTYEwbPmWF1MBywDYbSLqw1xqcn1Q/R
	 OU4nuQ0ZeY0JzJKekOCCXpF8F/GcN42L8l5ikYD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <ben@decadent.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Samuel Mendoza-Jonas <samjonas@amazon.com>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 6.1 19/30] riscv/mm: Convert to using lock_mm_and_find_vma()
Date: Thu, 29 Jun 2023 20:43:38 +0200
Message-ID: <20230629184152.447109443@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629184151.651069086@linuxfoundation.org>
References: <20230629184151.651069086@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ben Hutchings <ben@decadent.org.uk>

commit 7267ef7b0b77f4ed23b7b3c87d8eca7bd9c2d007 upstream.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[6.1: Kconfig context]
Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig    |    1 +
 arch/riscv/mm/fault.c |   31 +++++++++++++------------------
 2 files changed, 14 insertions(+), 18 deletions(-)

--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -114,6 +114,7 @@ config RISCV
 	select HAVE_RSEQ
 	select IRQ_DOMAIN
 	select IRQ_FORCED_THREADING
+	select LOCK_MM_AND_FIND_VMA
 	select MODULES_USE_ELF_RELA if MODULES
 	select MODULE_SECTIONS if MODULES
 	select OF
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -83,13 +83,13 @@ static inline void mm_fault_error(struct
 	BUG();
 }
 
-static inline void bad_area(struct pt_regs *regs, struct mm_struct *mm, int code, unsigned long addr)
+static inline void
+bad_area_nosemaphore(struct pt_regs *regs, int code, unsigned long addr)
 {
 	/*
 	 * Something tried to access memory that isn't in our memory map.
 	 * Fix it, but check if it's kernel or user first.
 	 */
-	mmap_read_unlock(mm);
 	/* User mode accesses just cause a SIGSEGV */
 	if (user_mode(regs)) {
 		do_trap(regs, SIGSEGV, code, addr);
@@ -99,6 +99,15 @@ static inline void bad_area(struct pt_re
 	no_context(regs, addr);
 }
 
+static inline void
+bad_area(struct pt_regs *regs, struct mm_struct *mm, int code,
+	 unsigned long addr)
+{
+	mmap_read_unlock(mm);
+
+	bad_area_nosemaphore(regs, code, addr);
+}
+
 static inline void vmalloc_fault(struct pt_regs *regs, int code, unsigned long addr)
 {
 	pgd_t *pgd, *pgd_k;
@@ -281,23 +290,10 @@ asmlinkage void do_page_fault(struct pt_
 	else if (cause == EXC_INST_PAGE_FAULT)
 		flags |= FAULT_FLAG_INSTRUCTION;
 retry:
-	mmap_read_lock(mm);
-	vma = find_vma(mm, addr);
+	vma = lock_mm_and_find_vma(mm, addr, regs);
 	if (unlikely(!vma)) {
 		tsk->thread.bad_cause = cause;
-		bad_area(regs, mm, code, addr);
-		return;
-	}
-	if (likely(vma->vm_start <= addr))
-		goto good_area;
-	if (unlikely(!(vma->vm_flags & VM_GROWSDOWN))) {
-		tsk->thread.bad_cause = cause;
-		bad_area(regs, mm, code, addr);
-		return;
-	}
-	if (unlikely(expand_stack(vma, addr))) {
-		tsk->thread.bad_cause = cause;
-		bad_area(regs, mm, code, addr);
+		bad_area_nosemaphore(regs, code, addr);
 		return;
 	}
 
@@ -305,7 +301,6 @@ retry:
 	 * Ok, we have a good vm_area for this memory access, so
 	 * we can handle it.
 	 */
-good_area:
 	code = SEGV_ACCERR;
 
 	if (unlikely(access_error(cause, vma))) {


