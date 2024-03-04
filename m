Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75451EB5A;
	Mon,  4 Mar 2024 21:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588957; cv=none; b=OCIW22fG3SMO1yrBx2n4buptCKp17xl5eZ0/QofV+bshZYMawXcjbxHcnQxCm9E1VXpITUpC97QEsEJpRx7rb7yZ1j4BbKg24fFiusBH51YY6aOx9TQFJqcvbV98MbqChedouy/LToKiTi7nY+BnwyrEWC8Ztl3lN1E/kSivp3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588957; c=relaxed/simple;
	bh=ug9Q1OLOXAdYUackhr1tHbldcMlXf4aQqIgFPVkA4pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1nUPoHzIiWs9ImRBmNLyEk4FfYUB+6JJl4dLW0c0sdAac8phvhE3Ww+JqmLtbKsI/5tee094H3ZoR5i0TZ9vdn1XsJnEtkiug+7GYUiSebZrScKt6PEd0a4c3KkNiK2j6M1VzCgCfyQgIcP/l1oGdBN9enPUVadHs9MrxT+5j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8+scesX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8+scesX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEB9C433C7;
	Mon,  4 Mar 2024 21:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588957;
	bh=ug9Q1OLOXAdYUackhr1tHbldcMlXf4aQqIgFPVkA4pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8+scesXLEJOzJEx9jUsEaO7+9xwI9T5N+niMEhH0VwIDsEjcr/0JIMLk864vkKn3
	 NvhueQsUZ7+V+Xk9v0n6ONiBNDVJ+UBrKKSlKLKyA03VkO7V1LwAHOCVS57/9gG32c
	 gH5PnOmbr2uVkA58QMJKhuiblUoRCTfqs0xDBKL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.1 122/215] x86/boot/compressed: Move startup32_check_sev_cbit() into .text
Date: Mon,  4 Mar 2024 21:23:05 +0000
Message-ID: <20240304211600.939894033@linuxfoundation.org>
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

commit b5d854cd4b6a314edd6c15dabc4233b84a0f8e5e upstream.

Move startup32_check_sev_cbit() into the .text section and turn it into
an ordinary function using the ordinary 32-bit calling convention,
instead of saving/restoring the registers that are known to be live at
the only call site. This improves maintainability, and makes it possible
to move this function out of head_64.S and into a separate compilation
unit that is specific to memory encryption.

Note that this requires the call site to be moved before the mixed mode
check, as %eax will be live otherwise.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20221122161017.2426828-14-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/head_64.S |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -251,6 +251,11 @@ SYM_FUNC_START(startup_32)
 	movl    $__BOOT_TSS, %eax
 	ltr	%ax
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	/* Check if the C-bit position is correct when SEV is active */
+	call	startup32_check_sev_cbit
+#endif
+
 	/*
 	 * Setup for the jump to 64bit mode
 	 *
@@ -268,8 +273,6 @@ SYM_FUNC_START(startup_32)
 	leal	rva(startup_64_mixed_mode)(%ebp), %eax
 1:
 #endif
-	/* Check if the C-bit position is correct when SEV is active */
-	call	startup32_check_sev_cbit
 
 	pushl	$__KERNEL_CS
 	pushl	%eax
@@ -740,16 +743,17 @@ SYM_DATA_END_LABEL(boot_idt, SYM_L_GLOBA
  * succeed. An incorrect C-bit position will map all memory unencrypted, so that
  * the compare will use the encrypted random data and fail.
  */
-	__HEAD
-SYM_FUNC_START(startup32_check_sev_cbit)
 #ifdef CONFIG_AMD_MEM_ENCRYPT
-	pushl	%eax
+	.text
+SYM_FUNC_START(startup32_check_sev_cbit)
 	pushl	%ebx
-	pushl	%ecx
-	pushl	%edx
+	pushl	%ebp
+
+	call	0f
+0:	popl	%ebp
 
 	/* Check for non-zero sev_status */
-	movl	rva(sev_status)(%ebp), %eax
+	movl	(sev_status - 0b)(%ebp), %eax
 	testl	%eax, %eax
 	jz	4f
 
@@ -764,17 +768,18 @@ SYM_FUNC_START(startup32_check_sev_cbit)
 	jnc	2b
 
 	/* Store to memory and keep it in the registers */
-	movl	%eax, rva(sev_check_data)(%ebp)
-	movl	%ebx, rva(sev_check_data+4)(%ebp)
+	leal	(sev_check_data - 0b)(%ebp), %ebp
+	movl	%eax, 0(%ebp)
+	movl	%ebx, 4(%ebp)
 
 	/* Enable paging to see if encryption is active */
 	movl	%cr0, %edx			 /* Backup %cr0 in %edx */
 	movl	$(X86_CR0_PG | X86_CR0_PE), %ecx /* Enable Paging and Protected mode */
 	movl	%ecx, %cr0
 
-	cmpl	%eax, rva(sev_check_data)(%ebp)
+	cmpl	%eax, 0(%ebp)
 	jne	3f
-	cmpl	%ebx, rva(sev_check_data+4)(%ebp)
+	cmpl	%ebx, 4(%ebp)
 	jne	3f
 
 	movl	%edx, %cr0	/* Restore previous %cr0 */
@@ -786,13 +791,11 @@ SYM_FUNC_START(startup32_check_sev_cbit)
 	jmp	3b
 
 4:
-	popl	%edx
-	popl	%ecx
+	popl	%ebp
 	popl	%ebx
-	popl	%eax
-#endif
 	RET
 SYM_FUNC_END(startup32_check_sev_cbit)
+#endif
 
 /*
  * Stack and heap for uncompression


