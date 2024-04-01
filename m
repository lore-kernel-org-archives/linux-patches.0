Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0B91CA8F;
	Mon,  1 Apr 2024 16:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987301; cv=none; b=Ql3VFZwCA/gMr6hWy2zqg0trOHjfVmJ1bLpYMvIBO0KoWUJqWutApYWoFF6zmyWzND8RLraeOTD0uie6o5/lnHecaHGvA4y3PXSkmOfciQ+yxm5VZnFa5EsBbHXKthIyVY2jjDobpJZqcTRl+ZSM1L7AGRtoBuuo+/KIrxaYLX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987301; c=relaxed/simple;
	bh=86bejXeZC42ufsUDj7LMiKsVqQFMftCdeYVO0oh9vR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVS3rDoD4IqeAMJpBxJ2oDsybwy9WOqmgLoaOSz6tXWmlbe/40VAEk0tPtyuqYpM2I7YnHhZz39zzwTlSYc8AR3fiYGhLLNCxxSIk8WxHjQ/SN/dMIEWtlUMHMvGSL6DfAg4jHFzPmpp60HxjHxykhJMJHYWW8OOIpP0cTOZidI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JTgCfdar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JTgCfdar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA6EC433C7;
	Mon,  1 Apr 2024 16:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987301;
	bh=86bejXeZC42ufsUDj7LMiKsVqQFMftCdeYVO0oh9vR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JTgCfdarXUU6I4Ny19yiTBSJ1W1tDbOzKhao3g4TEFv+NuZicahVnUm9FA0LwjYSi
	 CWF2ngax2lU2lqvM/S0U6nZwN0qxmbfbq2IfpjGMYoMXb2ESkKkedpkzRMp0uPYY4q
	 W/j/IL3mvW3H2gTNx5eHTGghk71Zrx9zJnHWZZ+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.8 246/399] x86/efistub: Call mixed mode boot services on the firmwares stack
Date: Mon,  1 Apr 2024 17:43:32 +0200
Message-ID: <20240401152556.515576340@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit cefcd4fe2e3aaf792c14c9e56dab89e3d7a65d02 upstream.

Normally, the EFI stub calls into the EFI boot services using the stack
that was live when the stub was entered. According to the UEFI spec,
this stack needs to be at least 128k in size - this might seem large but
all asynchronous processing and event handling in EFI runs from the same
stack and so quite a lot of space may be used in practice.

In mixed mode, the situation is a bit different: the bootloader calls
the 32-bit EFI stub entry point, which calls the decompressor's 32-bit
entry point, where the boot stack is set up, using a fixed allocation
of 16k. This stack is still in use when the EFI stub is started in
64-bit mode, and so all calls back into the EFI firmware will be using
the decompressor's limited boot stack.

Due to the placement of the boot stack right after the boot heap, any
stack overruns have gone unnoticed. However, commit

  5c4feadb0011983b ("x86/decompressor: Move global symbol references to C code")

moved the definition of the boot heap into C code, and now the boot
stack is placed right at the base of BSS, where any overruns will
corrupt the end of the .data section.

While it would be possible to work around this by increasing the size of
the boot stack, doing so would affect all x86 systems, and mixed mode
systems are a tiny (and shrinking) fraction of the x86 installed base.

So instead, record the firmware stack pointer value when entering from
the 32-bit firmware, and switch to this stack every time a EFI boot
service call is made.

Cc: <stable@kernel.org> # v6.1+
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/efi_mixed.S |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/x86/boot/compressed/efi_mixed.S
+++ b/arch/x86/boot/compressed/efi_mixed.S
@@ -49,6 +49,11 @@ SYM_FUNC_START(startup_64_mixed_mode)
 	lea	efi32_boot_args(%rip), %rdx
 	mov	0(%rdx), %edi
 	mov	4(%rdx), %esi
+
+	/* Switch to the firmware's stack */
+	movl	efi32_boot_sp(%rip), %esp
+	andl	$~7, %esp
+
 #ifdef CONFIG_EFI_HANDOVER_PROTOCOL
 	mov	8(%rdx), %edx		// saved bootparams pointer
 	test	%edx, %edx
@@ -254,6 +259,9 @@ SYM_FUNC_START_LOCAL(efi32_entry)
 	/* Store firmware IDT descriptor */
 	sidtl	(efi32_boot_idt - 1b)(%ebx)
 
+	/* Store firmware stack pointer */
+	movl	%esp, (efi32_boot_sp - 1b)(%ebx)
+
 	/* Store boot arguments */
 	leal	(efi32_boot_args - 1b)(%ebx), %ebx
 	movl	%ecx, 0(%ebx)
@@ -318,5 +326,6 @@ SYM_DATA_END(efi32_boot_idt)
 
 SYM_DATA_LOCAL(efi32_boot_cs, .word 0)
 SYM_DATA_LOCAL(efi32_boot_ds, .word 0)
+SYM_DATA_LOCAL(efi32_boot_sp, .long 0)
 SYM_DATA_LOCAL(efi32_boot_args, .long 0, 0, 0)
 SYM_DATA(efi_is64, .byte 1)


