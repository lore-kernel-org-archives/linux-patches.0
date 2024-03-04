Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AB31EB5A;
	Mon,  4 Mar 2024 21:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588929; cv=none; b=V4qsxWcQ5BrFblqhySfeGE8XkypJhQHIHPOXetqb2nRhqPYrdXLpF6IOJCrAIatT8OXa+21tbUkuqlROCSV1SIpFAOF9fkgTXYyZRvA46iROCwpbr2bTJJYVQByrlRwg3orY7qb51Ar66Y9M7o14ZYi5t9J5vXoVa+tBDZALgmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588929; c=relaxed/simple;
	bh=aCx5yuqjWnlIKfhZOyB0YvUzImifDHgNBmny4i080Cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8Cdnv69yWAFTtPHCVAR6SOd5rFqztV5SRhe7hIrMrcoCOhlMBG7z9ZI+oI8fW2qrSkl53+Fv2rFb3fOk9MLFqAn/8GEgf1/zqoJLOKXSY1APwMloOfT2tJ/rgHWnfSHCkb1CWL4rPp2V+tRXTOLMW9S2Ksj4xXshpchVG84m/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9V0SueL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9V0SueL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B036C433F1;
	Mon,  4 Mar 2024 21:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588929;
	bh=aCx5yuqjWnlIKfhZOyB0YvUzImifDHgNBmny4i080Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a9V0SueLlw9rn1qqzoQcOJKE6z4EfO7C1nPUQ/Mc8HLCdXhOyemU+LHEolLBVeLuW
	 YOFIOvdVY4ztB78wLL6YJXINO/pcQo4VVbcSwLVgY212aQbvFb6jSMSolbRB2BAkre
	 8OgrMZb2XXguUqjcW/RUEeNz4Lgyo6XOY2rq5MRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 6.1 138/215] x86/decompressor: Merge trampoline cleanup with switching code
Date: Mon,  4 Mar 2024 21:23:21 +0000
Message-ID: <20240304211601.444540780@linuxfoundation.org>
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

commit 03dda95137d3247564854ad9032c0354273a159d upstream.

Now that the trampoline setup code and the actual invocation of it are
all done from the C routine, the trampoline cleanup can be merged into
it as well, instead of returning to asm just to call another C function.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Link: https://lore.kernel.org/r/20230807162720.545787-16-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/head_64.S    |   14 ++++----------
 arch/x86/boot/compressed/pgtable_64.c |   18 ++++--------------
 2 files changed, 8 insertions(+), 24 deletions(-)

--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -433,20 +433,14 @@ SYM_CODE_START(startup_64)
 	 * a trampoline in 32-bit addressable memory if the current number does
 	 * not match the desired number.
 	 *
-	 * Pass the boot_params pointer as the first argument.
+	 * Pass the boot_params pointer as the first argument. The second
+	 * argument is the relocated address of the page table to use instead
+	 * of the page table in trampoline memory (if required).
 	 */
 	movq	%r15, %rdi
+	leaq	rva(top_pgtable)(%rbx), %rsi
 	call	configure_5level_paging
 
-	/*
-	 * cleanup_trampoline() would restore trampoline memory.
-	 *
-	 * RDI is address of the page table to use instead of page table
-	 * in trampoline memory (if required).
-	 */
-	leaq	rva(top_pgtable)(%rbx), %rdi
-	call	cleanup_trampoline
-
 	/* Zero EFLAGS */
 	pushq	$0
 	popfq
--- a/arch/x86/boot/compressed/pgtable_64.c
+++ b/arch/x86/boot/compressed/pgtable_64.c
@@ -101,7 +101,7 @@ static unsigned long find_trampoline_pla
 	return bios_start - TRAMPOLINE_32BIT_SIZE;
 }
 
-asmlinkage void configure_5level_paging(struct boot_params *bp)
+asmlinkage void configure_5level_paging(struct boot_params *bp, void *pgtable)
 {
 	void (*toggle_la57)(void *cr3);
 	bool l5_required = false;
@@ -191,22 +191,12 @@ asmlinkage void configure_5level_paging(
 	}
 
 	toggle_la57(trampoline_32bit);
-}
-
-void cleanup_trampoline(void *pgtable)
-{
-	void *trampoline_pgtable;
-
-	trampoline_pgtable = trampoline_32bit;
 
 	/*
-	 * Move the top level page table out of trampoline memory,
-	 * if it's there.
+	 * Move the top level page table out of trampoline memory.
 	 */
-	if ((void *)__native_read_cr3() == trampoline_pgtable) {
-		memcpy(pgtable, trampoline_pgtable, PAGE_SIZE);
-		native_write_cr3((unsigned long)pgtable);
-	}
+	memcpy(pgtable, trampoline_32bit, PAGE_SIZE);
+	native_write_cr3((unsigned long)pgtable);
 
 	/* Restore trampoline memory */
 	memcpy(trampoline_32bit, trampoline_save, TRAMPOLINE_32BIT_SIZE);


