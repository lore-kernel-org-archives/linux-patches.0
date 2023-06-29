Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B5614267
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 18:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BDBC433C8;
	Thu, 29 Jun 2023 18:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688064395;
	bh=uQXXioqfHrA46LL6kPa6D9PucZrzLvSau3uLt56zMhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axCIY4WVBrnUkjqpQ2Tb3fZOenz3K+kwKHLnA7yL9BkB5MAphBlsMEgVrgTFiSrMu
	 fk1gBe9i1fc3pBYgOElPMUugSHAgC/t70pVLruWE+8jr5T0sS2L8aezt/HiyLaes/5
	 daX+5DA6V084EYIQ+1KOwtRNJYDmNwe8M6+c6ByY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <ben@decadent.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.3 18/29] arm/mm: Convert to using lock_mm_and_find_vma()
Date: Thu, 29 Jun 2023 20:43:48 +0200
Message-ID: <20230629184152.465126960@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629184151.705870770@linuxfoundation.org>
References: <20230629184151.705870770@linuxfoundation.org>
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

commit 8b35ca3e45e35a26a21427f35d4093606e93ad0a upstream.

arm has an additional check for address < FIRST_USER_ADDRESS before
expanding the stack.  Since FIRST_USER_ADDRESS is defined everywhere
(generally as 0), move that check to the generic expand_downwards().

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/Kconfig    |    1 
 arch/arm/mm/fault.c |   63 +++++++++++-----------------------------------------
 mm/mmap.c           |    2 -
 3 files changed, 16 insertions(+), 50 deletions(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -125,6 +125,7 @@ config ARM
 	select HAVE_UID16
 	select HAVE_VIRT_CPU_ACCOUNTING_GEN
 	select IRQ_FORCED_THREADING
+	select LOCK_MM_AND_FIND_VMA
 	select MODULES_USE_ELF_REL
 	select NEED_DMA_MAP_STATE
 	select OF_EARLY_FLATTREE if OF
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -232,37 +232,11 @@ static inline bool is_permission_fault(u
 	return false;
 }
 
-static vm_fault_t __kprobes
-__do_page_fault(struct mm_struct *mm, unsigned long addr, unsigned int flags,
-		unsigned long vma_flags, struct pt_regs *regs)
-{
-	struct vm_area_struct *vma = find_vma(mm, addr);
-	if (unlikely(!vma))
-		return VM_FAULT_BADMAP;
-
-	if (unlikely(vma->vm_start > addr)) {
-		if (!(vma->vm_flags & VM_GROWSDOWN))
-			return VM_FAULT_BADMAP;
-		if (addr < FIRST_USER_ADDRESS)
-			return VM_FAULT_BADMAP;
-		if (expand_stack(vma, addr))
-			return VM_FAULT_BADMAP;
-	}
-
-	/*
-	 * ok, we have a good vm_area for this memory access, check the
-	 * permissions on the VMA allow for the fault which occurred.
-	 */
-	if (!(vma->vm_flags & vma_flags))
-		return VM_FAULT_BADACCESS;
-
-	return handle_mm_fault(vma, addr & PAGE_MASK, flags, regs);
-}
-
 static int __kprobes
 do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 {
 	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
 	int sig, code;
 	vm_fault_t fault;
 	unsigned int flags = FAULT_FLAG_DEFAULT;
@@ -301,31 +275,21 @@ do_page_fault(unsigned long addr, unsign
 
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
 
-	/*
-	 * As per x86, we may deadlock here.  However, since the kernel only
-	 * validly references user space from well defined areas of the code,
-	 * we can bug out early if this is from code which shouldn't.
-	 */
-	if (!mmap_read_trylock(mm)) {
-		if (!user_mode(regs) && !search_exception_tables(regs->ARM_pc))
-			goto no_context;
 retry:
-		mmap_read_lock(mm);
-	} else {
-		/*
-		 * The above down_read_trylock() might have succeeded in
-		 * which case, we'll have missed the might_sleep() from
-		 * down_read()
-		 */
-		might_sleep();
-#ifdef CONFIG_DEBUG_VM
-		if (!user_mode(regs) &&
-		    !search_exception_tables(regs->ARM_pc))
-			goto no_context;
-#endif
+	vma = lock_mm_and_find_vma(mm, addr, regs);
+	if (unlikely(!vma)) {
+		fault = VM_FAULT_BADMAP;
+		goto bad_area;
 	}
 
-	fault = __do_page_fault(mm, addr, flags, vm_flags, regs);
+	/*
+	 * ok, we have a good vm_area for this memory access, check the
+	 * permissions on the VMA allow for the fault which occurred.
+	 */
+	if (!(vma->vm_flags & vm_flags))
+		fault = VM_FAULT_BADACCESS;
+	else
+		fault = handle_mm_fault(vma, addr & PAGE_MASK, flags, regs);
 
 	/* If we need to retry but a fatal signal is pending, handle the
 	 * signal first. We do not need to release the mmap_lock because
@@ -356,6 +320,7 @@ retry:
 	if (likely(!(fault & (VM_FAULT_ERROR | VM_FAULT_BADMAP | VM_FAULT_BADACCESS))))
 		return 0;
 
+bad_area:
 	/*
 	 * If we are in kernel mode at this point, we
 	 * have no context to handle this fault with.
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1999,7 +1999,7 @@ int expand_downwards(struct vm_area_stru
 	int error = 0;
 
 	address &= PAGE_MASK;
-	if (address < mmap_min_addr)
+	if (address < mmap_min_addr || address < FIRST_USER_ADDRESS)
 		return -EPERM;
 
 	/* Enforce stack_guard_gap */


