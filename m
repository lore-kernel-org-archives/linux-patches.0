Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173E6320393;
	Mon, 13 Apr 2026 16:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099355; cv=none; b=qUhKJgIkIZNJ+760OTBsKq8iJ/PusMqmThzaSeXPrFhhas8moBumfVzcQEc8YqXo7gno1tW4/nCUL8afjeV/wcp3TzWJGp7upYK3h1eQOMFw3UO7vokexzN9F1GCcSt5rYn/Q1aBzuJyxsJc4kcPi62myVwEduXdAVbFs78MYPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099355; c=relaxed/simple;
	bh=qElh2kgtvW/xoDbqDnFzGOGDlz/d/vwHOdgkUbOZjW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oj9GrR5s5zIQ0DTUEyRgbOz68guASkQJ4P5GR+lscyLULoEpMJvbbsfHpEZk/JIIorrenVnUqnxVGkixTTcD+lB/xL2tB1u4/7Hvl6nQqjRr8lJbldgiCWFVgYJhKJc/v1/jiVYulPYnF0meFEZcoHVawQPcji1e3l/MYOoAoK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQB4rv+b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQB4rv+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3001C2BCAF;
	Mon, 13 Apr 2026 16:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099355;
	bh=qElh2kgtvW/xoDbqDnFzGOGDlz/d/vwHOdgkUbOZjW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQB4rv+bjRkAoT8TMcOuTFT/SqnADe8grwKBOAXurFHMPqfUmPJ8EPVEoVb7oPeet
	 mc2nEBNWAydpKYgRvLq3EoU1gxqS/xk6s28pw420waSAD5/7wRPQrdeybaqaZYI6eI
	 pnWOiZTimk+icwh8fbed5PuhJX+8+vSpyZWniLQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 281/491] x86/fault: Fold mm_fault_error() into do_user_addr_fault()
Date: Mon, 13 Apr 2026 17:58:46 +0200
Message-ID: <20260413155829.565868556@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@kernel.org>

[ Upstream commit ec352711ceba890ea3a0c182c2d49c86c1a5e30e ]

mm_fault_error() is logically just the end of do_user_addr_fault().
Combine the functions.  This makes the code easier to read.

Most of the churn here is from renaming hw_error_code to error_code in
do_user_addr_fault().

This makes no difference at all to the generated code (objdump -dr) as
compared to changing noinline to __always_inline in the definition of
mm_fault_error().

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/dedc4d9c9b047e51ce38b991bd23971a28af4e7b.1612924255.git.luto@kernel.org
Stable-dep-of: 217c0a5c177a ("x86/efi: efi_unmap_boot_services: fix calculation of ranges_to_free size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/fault.c | 97 +++++++++++++++++++++------------------------
 1 file changed, 45 insertions(+), 52 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 98a5924d98b72..07983b6208f52 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -925,40 +925,6 @@ do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address,
 	force_sig_fault(SIGBUS, BUS_ADRERR, (void __user *)address);
 }
 
-static noinline void
-mm_fault_error(struct pt_regs *regs, unsigned long error_code,
-	       unsigned long address, vm_fault_t fault)
-{
-	if (fatal_signal_pending(current) && !(error_code & X86_PF_USER)) {
-		no_context(regs, error_code, address, 0, 0);
-		return;
-	}
-
-	if (fault & VM_FAULT_OOM) {
-		/* Kernel mode? Handle exceptions or die: */
-		if (!(error_code & X86_PF_USER)) {
-			no_context(regs, error_code, address,
-				   SIGSEGV, SEGV_MAPERR);
-			return;
-		}
-
-		/*
-		 * We ran out of memory, call the OOM killer, and return the
-		 * userspace (which will retry the fault, or kill us if we got
-		 * oom-killed):
-		 */
-		pagefault_out_of_memory();
-	} else {
-		if (fault & (VM_FAULT_SIGBUS|VM_FAULT_HWPOISON|
-			     VM_FAULT_HWPOISON_LARGE))
-			do_sigbus(regs, error_code, address, fault);
-		else if (fault & VM_FAULT_SIGSEGV)
-			bad_area_nosemaphore(regs, error_code, address);
-		else
-			BUG();
-	}
-}
-
 static int spurious_kernel_fault_check(unsigned long error_code, pte_t *pte)
 {
 	if ((error_code & X86_PF_WRITE) && !pte_write(*pte))
@@ -1184,7 +1150,7 @@ NOKPROBE_SYMBOL(do_kern_addr_fault);
 /* Handle faults in the user portion of the address space */
 static inline
 void do_user_addr_fault(struct pt_regs *regs,
-			unsigned long hw_error_code,
+			unsigned long error_code,
 			unsigned long address)
 {
 	struct vm_area_struct *vma;
@@ -1204,8 +1170,8 @@ void do_user_addr_fault(struct pt_regs *regs,
 	 * Reserved bits are never expected to be set on
 	 * entries in the user portion of the page tables.
 	 */
-	if (unlikely(hw_error_code & X86_PF_RSVD))
-		pgtable_bad(regs, hw_error_code, address);
+	if (unlikely(error_code & X86_PF_RSVD))
+		pgtable_bad(regs, error_code, address);
 
 	/*
 	 * If SMAP is on, check for invalid kernel (supervisor) access to user
@@ -1215,10 +1181,10 @@ void do_user_addr_fault(struct pt_regs *regs,
 	 * enforcement appears to be consistent with the USER bit.
 	 */
 	if (unlikely(cpu_feature_enabled(X86_FEATURE_SMAP) &&
-		     !(hw_error_code & X86_PF_USER) &&
+		     !(error_code & X86_PF_USER) &&
 		     !(regs->flags & X86_EFLAGS_AC)))
 	{
-		bad_area_nosemaphore(regs, hw_error_code, address);
+		bad_area_nosemaphore(regs, error_code, address);
 		return;
 	}
 
@@ -1227,7 +1193,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	 * in a region with pagefaults disabled then we must not take the fault
 	 */
 	if (unlikely(faulthandler_disabled() || !mm)) {
-		bad_area_nosemaphore(regs, hw_error_code, address);
+		bad_area_nosemaphore(regs, error_code, address);
 		return;
 	}
 
@@ -1248,9 +1214,9 @@ void do_user_addr_fault(struct pt_regs *regs,
 
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
 
-	if (hw_error_code & X86_PF_WRITE)
+	if (error_code & X86_PF_WRITE)
 		flags |= FAULT_FLAG_WRITE;
-	if (hw_error_code & X86_PF_INSTR)
+	if (error_code & X86_PF_INSTR)
 		flags |= FAULT_FLAG_INSTRUCTION;
 
 #ifdef CONFIG_X86_64
@@ -1266,7 +1232,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	 * to consider the PF_PK bit.
 	 */
 	if (is_vsyscall_vaddr(address)) {
-		if (emulate_vsyscall(hw_error_code, regs, address))
+		if (emulate_vsyscall(error_code, regs, address))
 			return;
 	}
 #endif
@@ -1289,7 +1255,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 			 * Fault from code in kernel from
 			 * which we do not expect faults.
 			 */
-			bad_area_nosemaphore(regs, hw_error_code, address);
+			bad_area_nosemaphore(regs, error_code, address);
 			return;
 		}
 retry:
@@ -1305,17 +1271,17 @@ void do_user_addr_fault(struct pt_regs *regs,
 
 	vma = find_vma(mm, address);
 	if (unlikely(!vma)) {
-		bad_area(regs, hw_error_code, address);
+		bad_area(regs, error_code, address);
 		return;
 	}
 	if (likely(vma->vm_start <= address))
 		goto good_area;
 	if (unlikely(!(vma->vm_flags & VM_GROWSDOWN))) {
-		bad_area(regs, hw_error_code, address);
+		bad_area(regs, error_code, address);
 		return;
 	}
 	if (unlikely(expand_stack(vma, address))) {
-		bad_area(regs, hw_error_code, address);
+		bad_area(regs, error_code, address);
 		return;
 	}
 
@@ -1324,8 +1290,8 @@ void do_user_addr_fault(struct pt_regs *regs,
 	 * we can handle it..
 	 */
 good_area:
-	if (unlikely(access_error(hw_error_code, vma))) {
-		bad_area_access_error(regs, hw_error_code, address, vma);
+	if (unlikely(access_error(error_code, vma))) {
+		bad_area_access_error(regs, error_code, address, vma);
 		return;
 	}
 
@@ -1347,7 +1313,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	/* Quick path to respond to signals */
 	if (fault_signal_pending(fault, regs)) {
 		if (!user_mode(regs))
-			no_context(regs, hw_error_code, address, SIGBUS,
+			no_context(regs, error_code, address, SIGBUS,
 				   BUS_ADRERR);
 		return;
 	}
@@ -1364,11 +1330,38 @@ void do_user_addr_fault(struct pt_regs *regs,
 	}
 
 	mmap_read_unlock(mm);
-	if (unlikely(fault & VM_FAULT_ERROR)) {
-		mm_fault_error(regs, hw_error_code, address, fault);
+	if (likely(!(fault & VM_FAULT_ERROR)))
+		return;
+
+	if (fatal_signal_pending(current) && !(error_code & X86_PF_USER)) {
+		no_context(regs, error_code, address, 0, 0);
 		return;
 	}
 
+	if (fault & VM_FAULT_OOM) {
+		/* Kernel mode? Handle exceptions or die: */
+		if (!(error_code & X86_PF_USER)) {
+			no_context(regs, error_code, address,
+				   SIGSEGV, SEGV_MAPERR);
+			return;
+		}
+
+		/*
+		 * We ran out of memory, call the OOM killer, and return the
+		 * userspace (which will retry the fault, or kill us if we got
+		 * oom-killed):
+		 */
+		pagefault_out_of_memory();
+	} else {
+		if (fault & (VM_FAULT_SIGBUS|VM_FAULT_HWPOISON|
+			     VM_FAULT_HWPOISON_LARGE))
+			do_sigbus(regs, error_code, address, fault);
+		else if (fault & VM_FAULT_SIGSEGV)
+			bad_area_nosemaphore(regs, error_code, address);
+		else
+			BUG();
+	}
+
 	check_v8086_mode(regs, address, tsk);
 }
 NOKPROBE_SYMBOL(do_user_addr_fault);
-- 
2.53.0



