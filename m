Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6615B1EB5A;
	Mon,  4 Mar 2024 21:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588960; cv=none; b=OYdqgqFYv1YM6VgdluiRSPGj+xosqhVFUV+OJjmyXyR1zekgR/QrcMDi8R9PI7kUrtyr0e/U21fIDvcNTFx1fC2lcMhd+81Sdvia2foTPG6SI2WCD5aDld5mE3jNgT+kqbQe6HyRQLhozHH93GtQJQ9lOY1NXzaBAQOwc6jJp/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588960; c=relaxed/simple;
	bh=peXt+e7HEDHXZDBUOvOHNaAO/XcJDLusnexGcz13Aso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXbo7cQh6w49Qwby6SEZkHsify3sEK4IGExPc2ZJEinJ5aXhqmlqZstbahseRwMb3Toee4Gv80ek3nNRjuXEaGy3fu2teM6K1U0NTYFUjousfVhIUXbSdqCc6aOHrEXncTfV6A6XHsvTYzyVteCeo7kQJNekmujXQ3oMhayJzls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8l77lWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8l77lWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED12CC433C7;
	Mon,  4 Mar 2024 21:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588960;
	bh=peXt+e7HEDHXZDBUOvOHNaAO/XcJDLusnexGcz13Aso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8l77lWi9iVxeZ0t/gPVfJ/ofUGZF9fHThEpsk0TmHQYnpYr7BIvXn42VMs7Uqq4h
	 GeFRasm9a8rkKaryUbK9P+4fQ5cBah0oZSamuNRuGmQGk2nHnVPt26g3z7u0t7hlZn
	 HGqlQiY0FWv3VmTP8bhrZDmdFpTE3veTOoMYa6Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.1 123/215] x86/boot/compressed: Move startup32_check_sev_cbit() out of head_64.S
Date: Mon,  4 Mar 2024 21:23:06 +0000
Message-ID: <20240304211600.973938762@linuxfoundation.org>
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

commit 9d7eaae6a071ff1f718e0aa5e610bb712f8cc632 upstream.

Now that the startup32_check_sev_cbit() routine can execute from
anywhere and behaves like an ordinary function, it can be moved where it
belongs.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20221122161017.2426828-15-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/head_64.S     |   71 ---------------------------------
 arch/x86/boot/compressed/mem_encrypt.S |   68 +++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 71 deletions(-)

--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -727,77 +727,6 @@ SYM_DATA_START(boot_idt)
 SYM_DATA_END_LABEL(boot_idt, SYM_L_GLOBAL, boot_idt_end)
 
 /*
- * Check for the correct C-bit position when the startup_32 boot-path is used.
- *
- * The check makes use of the fact that all memory is encrypted when paging is
- * disabled. The function creates 64 bits of random data using the RDRAND
- * instruction. RDRAND is mandatory for SEV guests, so always available. If the
- * hypervisor violates that the kernel will crash right here.
- *
- * The 64 bits of random data are stored to a memory location and at the same
- * time kept in the %eax and %ebx registers. Since encryption is always active
- * when paging is off the random data will be stored encrypted in main memory.
- *
- * Then paging is enabled. When the C-bit position is correct all memory is
- * still mapped encrypted and comparing the register values with memory will
- * succeed. An incorrect C-bit position will map all memory unencrypted, so that
- * the compare will use the encrypted random data and fail.
- */
-#ifdef CONFIG_AMD_MEM_ENCRYPT
-	.text
-SYM_FUNC_START(startup32_check_sev_cbit)
-	pushl	%ebx
-	pushl	%ebp
-
-	call	0f
-0:	popl	%ebp
-
-	/* Check for non-zero sev_status */
-	movl	(sev_status - 0b)(%ebp), %eax
-	testl	%eax, %eax
-	jz	4f
-
-	/*
-	 * Get two 32-bit random values - Don't bail out if RDRAND fails
-	 * because it is better to prevent forward progress if no random value
-	 * can be gathered.
-	 */
-1:	rdrand	%eax
-	jnc	1b
-2:	rdrand	%ebx
-	jnc	2b
-
-	/* Store to memory and keep it in the registers */
-	leal	(sev_check_data - 0b)(%ebp), %ebp
-	movl	%eax, 0(%ebp)
-	movl	%ebx, 4(%ebp)
-
-	/* Enable paging to see if encryption is active */
-	movl	%cr0, %edx			 /* Backup %cr0 in %edx */
-	movl	$(X86_CR0_PG | X86_CR0_PE), %ecx /* Enable Paging and Protected mode */
-	movl	%ecx, %cr0
-
-	cmpl	%eax, 0(%ebp)
-	jne	3f
-	cmpl	%ebx, 4(%ebp)
-	jne	3f
-
-	movl	%edx, %cr0	/* Restore previous %cr0 */
-
-	jmp	4f
-
-3:	/* Check failed - hlt the machine */
-	hlt
-	jmp	3b
-
-4:
-	popl	%ebp
-	popl	%ebx
-	RET
-SYM_FUNC_END(startup32_check_sev_cbit)
-#endif
-
-/*
  * Stack and heap for uncompression
  */
 	.bss
--- a/arch/x86/boot/compressed/mem_encrypt.S
+++ b/arch/x86/boot/compressed/mem_encrypt.S
@@ -243,6 +243,74 @@ SYM_FUNC_START(startup32_load_idt)
 	RET
 SYM_FUNC_END(startup32_load_idt)
 
+/*
+ * Check for the correct C-bit position when the startup_32 boot-path is used.
+ *
+ * The check makes use of the fact that all memory is encrypted when paging is
+ * disabled. The function creates 64 bits of random data using the RDRAND
+ * instruction. RDRAND is mandatory for SEV guests, so always available. If the
+ * hypervisor violates that the kernel will crash right here.
+ *
+ * The 64 bits of random data are stored to a memory location and at the same
+ * time kept in the %eax and %ebx registers. Since encryption is always active
+ * when paging is off the random data will be stored encrypted in main memory.
+ *
+ * Then paging is enabled. When the C-bit position is correct all memory is
+ * still mapped encrypted and comparing the register values with memory will
+ * succeed. An incorrect C-bit position will map all memory unencrypted, so that
+ * the compare will use the encrypted random data and fail.
+ */
+SYM_FUNC_START(startup32_check_sev_cbit)
+	pushl	%ebx
+	pushl	%ebp
+
+	call	0f
+0:	popl	%ebp
+
+	/* Check for non-zero sev_status */
+	movl	(sev_status - 0b)(%ebp), %eax
+	testl	%eax, %eax
+	jz	4f
+
+	/*
+	 * Get two 32-bit random values - Don't bail out if RDRAND fails
+	 * because it is better to prevent forward progress if no random value
+	 * can be gathered.
+	 */
+1:	rdrand	%eax
+	jnc	1b
+2:	rdrand	%ebx
+	jnc	2b
+
+	/* Store to memory and keep it in the registers */
+	leal	(sev_check_data - 0b)(%ebp), %ebp
+	movl	%eax, 0(%ebp)
+	movl	%ebx, 4(%ebp)
+
+	/* Enable paging to see if encryption is active */
+	movl	%cr0, %edx			 /* Backup %cr0 in %edx */
+	movl	$(X86_CR0_PG | X86_CR0_PE), %ecx /* Enable Paging and Protected mode */
+	movl	%ecx, %cr0
+
+	cmpl	%eax, 0(%ebp)
+	jne	3f
+	cmpl	%ebx, 4(%ebp)
+	jne	3f
+
+	movl	%edx, %cr0	/* Restore previous %cr0 */
+
+	jmp	4f
+
+3:	/* Check failed - hlt the machine */
+	hlt
+	jmp	3b
+
+4:
+	popl	%ebp
+	popl	%ebx
+	RET
+SYM_FUNC_END(startup32_check_sev_cbit)
+
 	.code64
 
 #include "../../kernel/sev_verify_cbit.S"


