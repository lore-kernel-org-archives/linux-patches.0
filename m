Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2411EB5A;
	Mon,  4 Mar 2024 21:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588924; cv=none; b=P7iKLkvqDguukpGfVBI0tSQg+Gw4Z0joVuLh1xyY5g0JzEhKDZn5bNGOkhGWF/gn8mTkvEX5WMbcrWI49+RqWAdXupuuHhhqF4B1s1dNngWZ7Vxc1qjeVwLpPHWnHy/RbQM08ETd3l2zXXNElyKmwEXnC0FZBkoAbW6l4TAzWVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588924; c=relaxed/simple;
	bh=R9AmLYDS2sZTgqionYsHPzcRwnkYWQerRM4+jGXEGsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7fGLerKNdtgKW2jBruqluTtLPMKnlCvVKNLI/clEP+1YyJjhUbTIJgbHTvua7QlBFipLwQOKEPkif/jd2XLEV3/GcTHITyruCetYsxnd+ygkSr8VrbDpkEFMFTXqGn9ezzIBi+VQrV+z40FkxJ89RlR4a+XmTfI+SPkAkAK+Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1SeAFuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1SeAFuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CD1C433F1;
	Mon,  4 Mar 2024 21:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588924;
	bh=R9AmLYDS2sZTgqionYsHPzcRwnkYWQerRM4+jGXEGsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1SeAFuClEdmtTK1YvAoHbBPnAfpAiXhJagIwmTO7ectpcTb9/5oCYEmVTn4F2fnT
	 sCGGsv3GuLuZ70S9Ja7GJSwO4JpQMvCCVGCs4poraLfUh+z7PrMFeeC/YYYFi2BOmh
	 0NfO71aE+Ujg1HD+BWuO4AtAnSyfJJs91cRQVhFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 6.1 136/215] x86/decompressor: Only call the trampoline when changing paging levels
Date: Mon,  4 Mar 2024 21:23:19 +0000
Message-ID: <20240304211601.385109941@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit f97b67a773cd84bd8b55c0a0ec32448a87fc56bb upstream.

Since the current and desired number of paging levels are known when the
trampoline is being prepared, avoid calling the trampoline at all if it
is clear that calling it is not going to result in a change to the
number of paging levels.

Given that the CPU is already running in long mode, the PAE and LA57
settings are necessarily consistent with the currently active page
tables, and other fields in CR4 will be initialized by the startup code
in the kernel proper. So limit the manipulation of CR4 to toggling the
LA57 bit, which is the only thing that really needs doing at this point
in the boot. This also means that there is no need to pass the value of
l5_required to toggle_la57(), as it will not be called unless CR4.LA57
needs to toggle.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Link: https://lore.kernel.org/r/20230807162720.545787-14-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/head_64.S    |   45 +++-------------------------------
 arch/x86/boot/compressed/pgtable_64.c |   22 ++++++----------
 2 files changed, 13 insertions(+), 54 deletions(-)

--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -390,10 +390,6 @@ SYM_CODE_START(startup_64)
 	 * For the trampoline, we need the top page table to reside in lower
 	 * memory as we don't have a way to load 64-bit values into CR3 in
 	 * 32-bit mode.
-	 *
-	 * We go though the trampoline even if we don't have to: if we're
-	 * already in a desired paging mode. This way the trampoline code gets
-	 * tested on every boot.
 	 */
 
 	/* Make sure we have GDT with 32-bit code segment */
@@ -544,8 +540,7 @@ SYM_FUNC_END(.Lrelocated)
  *
  * Return address is at the top of the stack (might be above 4G).
  * The first argument (EDI) contains the 32-bit addressable base of the
- * trampoline memory. A non-zero second argument (ESI) means that the
- * trampoline needs to enable 5-level paging.
+ * trampoline memory.
  */
 	.section ".rodata", "a", @progbits
 SYM_CODE_START(trampoline_32bit_src)
@@ -597,25 +592,10 @@ SYM_CODE_START(trampoline_32bit_src)
 	btrl	$X86_CR0_PG_BIT, %eax
 	movl	%eax, %cr0
 
-	/* Check what paging mode we want to be in after the trampoline */
-	testl	%esi, %esi
-	jz	1f
-
-	/* We want 5-level paging: don't touch CR3 if it already points to 5-level page tables */
-	movl	%cr4, %eax
-	testl	$X86_CR4_LA57, %eax
-	jnz	3f
-	jmp	2f
-1:
-	/* We want 4-level paging: don't touch CR3 if it already points to 4-level page tables */
-	movl	%cr4, %eax
-	testl	$X86_CR4_LA57, %eax
-	jz	3f
-2:
 	/* Point CR3 to the trampoline's new top level page table */
 	leal	TRAMPOLINE_32BIT_PGTABLE_OFFSET(%edi), %eax
 	movl	%eax, %cr3
-3:
+
 	/* Set EFER.LME=1 as a precaution in case hypervsior pulls the rug */
 	movl	$MSR_EFER, %ecx
 	rdmsr
@@ -624,26 +604,9 @@ SYM_CODE_START(trampoline_32bit_src)
 	jc	1f
 	wrmsr
 1:
-#ifdef CONFIG_X86_MCE
-	/*
-	 * Preserve CR4.MCE if the kernel will enable #MC support.
-	 * Clearing MCE may fault in some environments (that also force #MC
-	 * support). Any machine check that occurs before #MC support is fully
-	 * configured will crash the system regardless of the CR4.MCE value set
-	 * here.
-	 */
+	/* Toggle CR4.LA57 */
 	movl	%cr4, %eax
-	andl	$X86_CR4_MCE, %eax
-#else
-	movl	$0, %eax
-#endif
-
-	/* Enable PAE and LA57 (if required) paging modes */
-	orl	$X86_CR4_PAE, %eax
-	testl	%esi, %esi
-	jz	1f
-	orl	$X86_CR4_LA57, %eax
-1:
+	btcl	$X86_CR4_LA57_BIT, %eax
 	movl	%eax, %cr4
 
 	/* Enable paging again. */
--- a/arch/x86/boot/compressed/pgtable_64.c
+++ b/arch/x86/boot/compressed/pgtable_64.c
@@ -103,7 +103,7 @@ static unsigned long find_trampoline_pla
 
 asmlinkage void configure_5level_paging(struct boot_params *bp)
 {
-	void (*toggle_la57)(void *trampoline, bool enable_5lvl);
+	void (*toggle_la57)(void *trampoline);
 	bool l5_required = false;
 
 	/* Initialize boot_params. Required for cmdline_find_option_bool(). */
@@ -133,6 +133,13 @@ asmlinkage void configure_5level_paging(
 		ptrs_per_p4d = 512;
 	}
 
+	/*
+	 * The trampoline will not be used if the paging mode is already set to
+	 * the desired one.
+	 */
+	if (l5_required == !!(native_read_cr4() & X86_CR4_LA57))
+		return;
+
 	trampoline_32bit = (unsigned long *)find_trampoline_placement();
 
 	/* Preserve trampoline memory */
@@ -160,18 +167,8 @@ asmlinkage void configure_5level_paging(
 	 *
 	 * The new page table will be used by trampoline code for switching
 	 * from 4- to 5-level paging or vice versa.
-	 *
-	 * If switching is not required, the page table is unused: trampoline
-	 * code wouldn't touch CR3.
 	 */
 
-	/*
-	 * We are not going to use the page table in trampoline memory if we
-	 * are already in the desired paging mode.
-	 */
-	if (l5_required == !!(native_read_cr4() & X86_CR4_LA57))
-		goto out;
-
 	if (l5_required) {
 		/*
 		 * For 4- to 5-level paging transition, set up current CR3 as
@@ -194,8 +191,7 @@ asmlinkage void configure_5level_paging(
 		       (void *)src, PAGE_SIZE);
 	}
 
-out:
-	toggle_la57(trampoline_32bit, l5_required);
+	toggle_la57(trampoline_32bit);
 }
 
 void cleanup_trampoline(void *pgtable)


