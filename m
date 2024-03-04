Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE3B1EB5A;
	Mon,  4 Mar 2024 21:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588824; cv=none; b=Qv6n/3KlXCFRQ1763c7Qwg4lVMMAvcvLkDCHnu3yAiPG77hUXoGsABU3jc9KipeDz13w9IANNodhUc1PSIX3VJRmOpPMcu4YkVMpWU18Ffg2juf/K4VTIEtSmHJG+ANdcx9lhdY0WWmJEkGSKSXT9XJ9uIPqSavk+KSIQYIJgR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588824; c=relaxed/simple;
	bh=sfwDx6cA3qaIS5DOXddpt7V2itLtMXxYlns0OLJoLV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vz0z5+zRP0Tc5Opvnh8U/Q8f3a2JgwtqeXqTZWvZP1GcbJrwyUMu2rIBrrJ8iVR7m3Nz5H1z+558mNymGSyx8kFrTyhTKmtvaDITyVbh6PHsaHwTUoWPPGVQk2HgSEKbpaO6Ba7xo0Qx4flMxSkCpxZ9z9bWuvfQO4YWda2nPL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LyRhFjS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LyRhFjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2E0C433F1;
	Mon,  4 Mar 2024 21:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588824;
	bh=sfwDx6cA3qaIS5DOXddpt7V2itLtMXxYlns0OLJoLV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0LyRhFjSl8fkFHar4KsuZuj6T+XdK+BDUhVfKXPGoJYD9hEd3gGvzrD66s6iY73VO
	 wndQIhHCRJu+R4fXh/UqWyuNZYJwwkrV6UmutUfzZG/tU+s9/Hq096pgUYrPpv8Z16
	 hDKq17ZspQwPZndVoQfNPQsVHKKTVFSTPUaSzu4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.1 111/215] x86/boot/compressed: Move 32-bit entrypoint code into .text section
Date: Mon,  4 Mar 2024 21:22:54 +0000
Message-ID: <20240304211600.556328063@linuxfoundation.org>
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

commit e2ab9eab324cdf240de89741e4a1aa79919f0196 upstream.

Move the code that stores the arguments passed to the EFI entrypoint
into the .text section, so that it can be moved into a separate
compilation unit in a subsequent patch.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20221122161017.2426828-3-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/head_64.S |   48 ++++++++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 14 deletions(-)

--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -303,24 +303,41 @@ SYM_FUNC_START(efi32_stub_entry)
 	popl	%ecx
 	popl	%edx
 	popl	%esi
+	jmp	efi32_entry
+SYM_FUNC_END(efi32_stub_entry)
 
+	.text
+/*
+ * This is the common EFI stub entry point for mixed mode.
+ *
+ * Arguments:	%ecx	image handle
+ * 		%edx	EFI system table pointer
+ *		%esi	struct bootparams pointer (or NULL when not using
+ *			the EFI handover protocol)
+ *
+ * Since this is the point of no return for ordinary execution, no registers
+ * are considered live except for the function parameters. [Note that the EFI
+ * stub may still exit and return to the firmware using the Exit() EFI boot
+ * service.]
+ */
+SYM_FUNC_START_LOCAL(efi32_entry)
 	call	1f
-1:	pop	%ebp
-	subl	$ rva(1b), %ebp
-
-	movl	%esi, rva(efi32_boot_args+8)(%ebp)
-SYM_INNER_LABEL(efi32_pe_stub_entry, SYM_L_LOCAL)
-	movl	%ecx, rva(efi32_boot_args)(%ebp)
-	movl	%edx, rva(efi32_boot_args+4)(%ebp)
-	movb	$0, rva(efi_is64)(%ebp)
+1:	pop	%ebx
 
 	/* Save firmware GDTR and code/data selectors */
-	sgdtl	rva(efi32_boot_gdt)(%ebp)
-	movw	%cs, rva(efi32_boot_cs)(%ebp)
-	movw	%ds, rva(efi32_boot_ds)(%ebp)
+	sgdtl	(efi32_boot_gdt - 1b)(%ebx)
+	movw	%cs, (efi32_boot_cs - 1b)(%ebx)
+	movw	%ds, (efi32_boot_ds - 1b)(%ebx)
 
 	/* Store firmware IDT descriptor */
-	sidtl	rva(efi32_boot_idt)(%ebp)
+	sidtl	(efi32_boot_idt - 1b)(%ebx)
+
+	/* Store boot arguments */
+	leal	(efi32_boot_args - 1b)(%ebx), %ebx
+	movl	%ecx, 0(%ebx)
+	movl	%edx, 4(%ebx)
+	movl	%esi, 8(%ebx)
+	movb	$0x0, 12(%ebx)          // efi_is64
 
 	/* Disable paging */
 	movl	%cr0, %eax
@@ -328,7 +345,8 @@ SYM_INNER_LABEL(efi32_pe_stub_entry, SYM
 	movl	%eax, %cr0
 
 	jmp	startup_32
-SYM_FUNC_END(efi32_stub_entry)
+SYM_FUNC_END(efi32_entry)
+	__HEAD
 #endif
 
 	.code64
@@ -847,7 +865,9 @@ SYM_FUNC_START(efi32_pe_entry)
 	 */
 	subl	%esi, %ebx
 	movl	%ebx, rva(image_offset)(%ebp)	// save image_offset
-	jmp	efi32_pe_stub_entry
+	xorl	%esi, %esi
+	jmp	efi32_entry			// pass %ecx, %edx, %esi
+						// no other registers remain live
 
 2:	popl	%edi				// restore callee-save registers
 	popl	%ebx


