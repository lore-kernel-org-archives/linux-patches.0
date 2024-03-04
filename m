Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3221EB5A;
	Mon,  4 Mar 2024 21:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588927; cv=none; b=G03iCx2qxLTEoTr9wpEJ+XaDeWHZXdgCM/aWk4YH1PkhHHAwFVyQ8EANb7diFU1a8qms0k88hdgonYOuFLpkNk+7eEbfxuI2Afb4U9yE7EmnZEXVhfLPUSue38aaD/Gu7I5nq7GCw730vkkBlUobUACdOKZ9Ker84B2MW+oJdb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588927; c=relaxed/simple;
	bh=4d8TFE23FuvH7Kkfy6o4cD0QOH5mMZBsu1gfqJp8bjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6hByGeazb5FUxSvthLo8zxul4oC4jde2lsJNqF1ipEVmRUDdM9iFdibriC5kVM06xcMKma1jRuGqzSHyLRSfVqdltmhqAmzvwLaQpT3eksrcgECrxIf1ZVHHyMDtXS9AU17qzIQWgLS4Xy2WhRmNB+NsNf8Zqb9hNRWZGZJ3Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXm2iDrS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXm2iDrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8082CC433F1;
	Mon,  4 Mar 2024 21:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588926;
	bh=4d8TFE23FuvH7Kkfy6o4cD0QOH5mMZBsu1gfqJp8bjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXm2iDrS0QhVv13JJCR33rvLBWVIXAbLsv+apms/2qIuxXlcrWoMw9Ln+T/hhi4hb
	 XlKfSJHg4BxI+wRdefFwoO4CGnAm6hanepmOhyEJimTP6fSC1tj3XoSOCdcKsRfk1z
	 wjheaT+3buVnya1xTgBMrDhPWc+ZTn5q5WeGQbZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 137/215] x86/decompressor: Pass pgtable address to trampoline directly
Date: Mon,  4 Mar 2024 21:23:20 +0000
Message-ID: <20240304211601.413963002@linuxfoundation.org>
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

commit cb83cece57e1889109dd73ea08ee338668c9d1b8 upstream.

The only remaining use of the trampoline address by the trampoline
itself is deriving the page table address from it, and this involves
adding an offset of 0x0. So simplify this, and pass the new CR3 value
directly.

This makes the fact that the page table happens to be at the start of
the trampoline allocation an implementation detail of the caller.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230807162720.545787-15-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/head_64.S    |    8 ++++----
 arch/x86/boot/compressed/pgtable.h    |    2 --
 arch/x86/boot/compressed/pgtable_64.c |    9 ++++-----
 3 files changed, 8 insertions(+), 11 deletions(-)

--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -539,8 +539,9 @@ SYM_FUNC_END(.Lrelocated)
  * running in 64-bit mode.
  *
  * Return address is at the top of the stack (might be above 4G).
- * The first argument (EDI) contains the 32-bit addressable base of the
- * trampoline memory.
+ * The first argument (EDI) contains the address of the temporary PGD level
+ * page table in 32-bit addressable memory which will be programmed into
+ * register CR3.
  */
 	.section ".rodata", "a", @progbits
 SYM_CODE_START(trampoline_32bit_src)
@@ -593,8 +594,7 @@ SYM_CODE_START(trampoline_32bit_src)
 	movl	%eax, %cr0
 
 	/* Point CR3 to the trampoline's new top level page table */
-	leal	TRAMPOLINE_32BIT_PGTABLE_OFFSET(%edi), %eax
-	movl	%eax, %cr3
+	movl	%edi, %cr3
 
 	/* Set EFER.LME=1 as a precaution in case hypervsior pulls the rug */
 	movl	$MSR_EFER, %ecx
--- a/arch/x86/boot/compressed/pgtable.h
+++ b/arch/x86/boot/compressed/pgtable.h
@@ -3,8 +3,6 @@
 
 #define TRAMPOLINE_32BIT_SIZE		(2 * PAGE_SIZE)
 
-#define TRAMPOLINE_32BIT_PGTABLE_OFFSET	0
-
 #define TRAMPOLINE_32BIT_CODE_OFFSET	PAGE_SIZE
 #define TRAMPOLINE_32BIT_CODE_SIZE	0xA0
 
--- a/arch/x86/boot/compressed/pgtable_64.c
+++ b/arch/x86/boot/compressed/pgtable_64.c
@@ -103,7 +103,7 @@ static unsigned long find_trampoline_pla
 
 asmlinkage void configure_5level_paging(struct boot_params *bp)
 {
-	void (*toggle_la57)(void *trampoline);
+	void (*toggle_la57)(void *cr3);
 	bool l5_required = false;
 
 	/* Initialize boot_params. Required for cmdline_find_option_bool(). */
@@ -174,7 +174,7 @@ asmlinkage void configure_5level_paging(
 		 * For 4- to 5-level paging transition, set up current CR3 as
 		 * the first and the only entry in a new top-level page table.
 		 */
-		trampoline_32bit[TRAMPOLINE_32BIT_PGTABLE_OFFSET] = __native_read_cr3() | _PAGE_TABLE_NOENC;
+		*trampoline_32bit = __native_read_cr3() | _PAGE_TABLE_NOENC;
 	} else {
 		unsigned long src;
 
@@ -187,8 +187,7 @@ asmlinkage void configure_5level_paging(
 		 * may be above 4G.
 		 */
 		src = *(unsigned long *)__native_read_cr3() & PAGE_MASK;
-		memcpy(trampoline_32bit + TRAMPOLINE_32BIT_PGTABLE_OFFSET / sizeof(unsigned long),
-		       (void *)src, PAGE_SIZE);
+		memcpy(trampoline_32bit, (void *)src, PAGE_SIZE);
 	}
 
 	toggle_la57(trampoline_32bit);
@@ -198,7 +197,7 @@ void cleanup_trampoline(void *pgtable)
 {
 	void *trampoline_pgtable;
 
-	trampoline_pgtable = trampoline_32bit + TRAMPOLINE_32BIT_PGTABLE_OFFSET / sizeof(unsigned long);
+	trampoline_pgtable = trampoline_32bit;
 
 	/*
 	 * Move the top level page table out of trampoline memory,


