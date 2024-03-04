Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A391C6AB;
	Mon,  4 Mar 2024 21:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588826; cv=none; b=W7+cjqgTKJsK3ZZOT38MnKcRyuP4oANODsbMH3Za974hdCiODipEL31/Zk/Awc6WepRrXxIpr8nB+xRxuTUJQGKXeN9Cz8dhj04GebrYbvJBvbmVHLQgWN4goUmerXJHXshIer+oQiXfDhFS1W4oh051n2fcDcvAQYHKW1nTqUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588826; c=relaxed/simple;
	bh=DR/gZLco72wCgYCCEkBHAi+3C0YGkoggMfXoep5kF/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Denju8I5H8OJGXS6mS3RGVFXC41j9Rkz2HksAJs2lDBB6YLPCeXnpwUNVgSY3YZlxhl/KjWZ9XYJNAf4vidA4VjIGLtaH0uxSYwGq2RxtHfhKFW4XRnQPXicJdBxCUZxeuTrhgqs1p7esUzB3hFr4DEf/4MGY61qEt8bl1twApc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXIeATZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXIeATZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A26C433C7;
	Mon,  4 Mar 2024 21:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588826;
	bh=DR/gZLco72wCgYCCEkBHAi+3C0YGkoggMfXoep5kF/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXIeATZzt4vwXj+Ii5UitfwwzP4miiJMNGHvzBw6Skuj70j7kXvxkxDDlfCNYMDho
	 WNuQqKcZErcs6/UQr4R25tbhTwilFVHB8V+gN4szUByMTMH7yK19+YNbAeDMzKDd/b
	 IZel4VMWBgqsvBdKd9TvbdmFrctNb7mxX3hy8u4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.1 112/215] x86/boot/compressed: Move bootargs parsing out of 32-bit startup code
Date: Mon,  4 Mar 2024 21:22:55 +0000
Message-ID: <20240304211600.590951755@linuxfoundation.org>
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

commit 5c3a85f35b583259cf5ca0344cd79c8899ba1bb7 upstream.

Move the logic that chooses between the different EFI entrypoints out of
the 32-bit boot path, and into a 64-bit helper that can perform the same
task much more cleanly. While at it, document the mixed mode boot flow
in a code comment.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20221122161017.2426828-4-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/efi_mixed.S |   43 +++++++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/head_64.S   |   24 +++----------------
 2 files changed, 47 insertions(+), 20 deletions(-)

--- a/arch/x86/boot/compressed/efi_mixed.S
+++ b/arch/x86/boot/compressed/efi_mixed.S
@@ -22,6 +22,49 @@
 
 	.code64
 	.text
+/*
+ * When booting in 64-bit mode on 32-bit EFI firmware, startup_64_mixed_mode()
+ * is the first thing that runs after switching to long mode. Depending on
+ * whether the EFI handover protocol or the compat entry point was used to
+ * enter the kernel, it will either branch to the 64-bit EFI handover
+ * entrypoint at offset 0x390 in the image, or to the 64-bit EFI PE/COFF
+ * entrypoint efi_pe_entry(). In the former case, the bootloader must provide a
+ * struct bootparams pointer as the third argument, so the presence of such a
+ * pointer is used to disambiguate.
+ *
+ *                                                             +--------------+
+ *  +------------------+     +------------+            +------>| efi_pe_entry |
+ *  | efi32_pe_entry   |---->|            |            |       +-----------+--+
+ *  +------------------+     |            |     +------+----------------+  |
+ *                           | startup_32 |---->| startup_64_mixed_mode |  |
+ *  +------------------+     |            |     +------+----------------+  V
+ *  | efi32_stub_entry |---->|            |            |     +------------------+
+ *  +------------------+     +------------+            +---->| efi64_stub_entry |
+ *                                                           +-------------+----+
+ *                           +------------+     +----------+               |
+ *                           | startup_64 |<----| efi_main |<--------------+
+ *                           +------------+     +----------+
+ */
+SYM_FUNC_START(startup_64_mixed_mode)
+	lea	efi32_boot_args(%rip), %rdx
+	mov	0(%rdx), %edi
+	mov	4(%rdx), %esi
+	mov	8(%rdx), %edx		// saved bootparams pointer
+	test	%edx, %edx
+	jnz	efi64_stub_entry
+	/*
+	 * efi_pe_entry uses MS calling convention, which requires 32 bytes of
+	 * shadow space on the stack even if all arguments are passed in
+	 * registers. We also need an additional 8 bytes for the space that
+	 * would be occupied by the return address, and this also results in
+	 * the correct stack alignment for entry.
+	 */
+	sub	$40, %rsp
+	mov	%rdi, %rcx		// MS calling convention
+	mov	%rsi, %rdx
+	jmp	efi_pe_entry
+SYM_FUNC_END(startup_64_mixed_mode)
+
 SYM_FUNC_START(__efi64_thunk)
 	push	%rbp
 	push	%rbx
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -261,25 +261,9 @@ SYM_FUNC_START(startup_32)
 	 */
 	leal	rva(startup_64)(%ebp), %eax
 #ifdef CONFIG_EFI_MIXED
-	movl	rva(efi32_boot_args)(%ebp), %edi
-	testl	%edi, %edi
-	jz	1f
-	leal	rva(efi64_stub_entry)(%ebp), %eax
-	movl	rva(efi32_boot_args+4)(%ebp), %esi
-	movl	rva(efi32_boot_args+8)(%ebp), %edx	// saved bootparams pointer
-	testl	%edx, %edx
-	jnz	1f
-	/*
-	 * efi_pe_entry uses MS calling convention, which requires 32 bytes of
-	 * shadow space on the stack even if all arguments are passed in
-	 * registers. We also need an additional 8 bytes for the space that
-	 * would be occupied by the return address, and this also results in
-	 * the correct stack alignment for entry.
-	 */
-	subl	$40, %esp
-	leal	rva(efi_pe_entry)(%ebp), %eax
-	movl	%edi, %ecx			// MS calling convention
-	movl	%esi, %edx
+	cmpb	$1, rva(efi_is64)(%ebp)
+	je	1f
+	leal	rva(startup_64_mixed_mode)(%ebp), %eax
 1:
 #endif
 	/* Check if the C-bit position is correct when SEV is active */
@@ -795,7 +779,7 @@ SYM_DATA_END_LABEL(boot32_idt, SYM_L_GLO
 SYM_DATA(image_offset, .long 0)
 #endif
 #ifdef CONFIG_EFI_MIXED
-SYM_DATA_LOCAL(efi32_boot_args, .long 0, 0, 0)
+SYM_DATA(efi32_boot_args, .long 0, 0, 0)
 SYM_DATA(efi_is64, .byte 1)
 
 #define ST32_boottime		60 // offsetof(efi_system_table_32_t, boottime)


