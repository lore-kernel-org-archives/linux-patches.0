Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0BE8F5C;
	Mon,  1 Apr 2024 16:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990199; cv=none; b=Xw4tDj+jreCsJ4wyjkzw12jIfh8T+APA35luWmGjm6sObMLoX9miMFcDdEIbfMXuDRfRaDUN4JeDmnPCnQopAKtf15/iP1KIH0wAzmpPH8WF941YJqbwIs20uSbT/5HZ1ToeS3uAnhGMD/lgxqIJM1RQ9KCZLV8DIcUCa53bCPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990199; c=relaxed/simple;
	bh=GbWOvFu8n35qZchcdnGWlr91SuB7PIDMGOsxudtCyWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiCwSl+VDxf9x38YwMHE1Z6H5acvPojEg7h463UBItgAvgovahMRyte1FEiM2q65TuqX3Y3tTrClMt03kDnveJizBOhtkJ6+p/NY99LabZR/O4sQVQj3x2g32fn+YgrvpdlK3RaedaA8TDaOtR98Jg4DYQFZ6xLQUagbEDGvwRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UoHSqHxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UoHSqHxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47045C433F1;
	Mon,  1 Apr 2024 16:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990199;
	bh=GbWOvFu8n35qZchcdnGWlr91SuB7PIDMGOsxudtCyWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoHSqHxG/ZPypTjkGAfWRuXP/MNd488HHZoR+5//AebnFnrCItSKyz4QK0WLTLt0G
	 iQPYncv7HsssG2m8gNSlqep9PlDPFlDn44Tguz/gxSfcVXrVCI55ZEmUasne4vwCRB
	 1h44JTK82vwJXh+mrxw9daVf4paVRUmj6UxogmKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.6 249/396] x86/efistub: Call mixed mode boot services on the firmwares stack
Date: Mon,  1 Apr 2024 17:44:58 +0200
Message-ID: <20240401152555.335288588@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


