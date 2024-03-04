Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44EC7A70D;
	Mon,  4 Mar 2024 21:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589055; cv=none; b=p6VNvyHJ6MzPe3LBXX5oHb6PH/TRhd+i8oWFnC9b0ZmbkOYSMuLG7BYsR4YgmZ5gfoDCZdcn6+eP3Q6XEgcXL9LIAdd7Jo1luB3acpVTfxujEC1g5jU1eV3Vgh7tUYNhlkBRpNGWnnU1jY78ylCjEaClgzZCTOVS5nSD7R+hcic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589055; c=relaxed/simple;
	bh=hBgiLWEucv/M7iv5DYiIqc/FxrSoPtfcjKPOjBN2bqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzkBBkCvBnM+MsmR4piIx37QTC7osMhPwqFELoEdkq5GIQZOvFguw1LaN/A8myMCMKrfjCWUxwN/eFfcaDYH15N3mRChBUxCFCH5q+SdYinhwHi5tyLNWJWVt282hgGsqP7QhO7GvQ1aPbr4OIkjfZ01bPtzASDoObgKyYMvsGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYaz6Ann; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYaz6Ann"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DDAAC433F1;
	Mon,  4 Mar 2024 21:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589054;
	bh=hBgiLWEucv/M7iv5DYiIqc/FxrSoPtfcjKPOjBN2bqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LYaz6AnnMyrPrQxXekZ69A1pzfmaYF3on1vDw0C37sBhYmfgpoQb9bN39T9T3Fs7Z
	 ffE+WDC7z7MbG/zEZ0aMWKG9mhmpn1lB8FfUeyw/ruxzdSJN2TacDbJae3r1AUAJbj
	 uvQ845weTWbHpSdmNNdhX9iwW2lEEGKxhavYKlZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 184/215] x86/efistub: Clear BSS in EFI handover protocol entrypoint
Date: Mon,  4 Mar 2024 21:24:07 +0000
Message-ID: <20240304211602.790529534@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb+git@google.com>

From: Ard Biesheuvel <ardb@kernel.org>

[ Commit d7156b986d4cc0657fa6dc05c9fcf51c3d55a0fe upstream ]

The so-called EFI handover protocol is value-add from the distros that
permits a loader to simply copy a PE kernel image into memory and call
an alternative entrypoint that is described by an embedded boot_params
structure.

Most implementations of this protocol do not bother to check the PE
header for minimum alignment, section placement, etc, and therefore also
don't clear the image's BSS, or even allocate enough memory for it.

Allocating more memory on the fly is rather difficult, but at least
clear the BSS region explicitly when entering in this manner, so that
the EFI stub code does not get confused by global variables that were
not zero-initialized correctly.

When booting in mixed mode, this BSS clearing must occur before any
global state is created, so clear it in the 32-bit asm entry point.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230807162720.545787-7-ardb@kernel.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/efi_mixed.S    |   14 +++++++++++++-
 drivers/firmware/efi/libstub/x86-stub.c |   13 +++++++++++--
 2 files changed, 24 insertions(+), 3 deletions(-)

--- a/arch/x86/boot/compressed/efi_mixed.S
+++ b/arch/x86/boot/compressed/efi_mixed.S
@@ -148,6 +148,18 @@ SYM_FUNC_END(__efi64_thunk)
 	.code32
 #ifdef CONFIG_EFI_HANDOVER_PROTOCOL
 SYM_FUNC_START(efi32_stub_entry)
+	call	1f
+1:	popl	%ecx
+
+	/* Clear BSS */
+	xorl	%eax, %eax
+	leal	(_bss - 1b)(%ecx), %edi
+	leal	(_ebss - 1b)(%ecx), %ecx
+	subl	%edi, %ecx
+	shrl	$2, %ecx
+	cld
+	rep	stosl
+
 	add	$0x4, %esp		/* Discard return address */
 	popl	%ecx
 	popl	%edx
@@ -340,7 +352,7 @@ SYM_FUNC_END(efi32_pe_entry)
 	.org	efi32_stub_entry + 0x200
 	.code64
 SYM_FUNC_START_NOALIGN(efi64_stub_entry)
-	jmp	efi_stub_entry
+	jmp	efi_handover_entry
 SYM_FUNC_END(efi64_stub_entry)
 #endif
 
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -925,12 +925,21 @@ fail:
 }
 
 #ifdef CONFIG_EFI_HANDOVER_PROTOCOL
+void efi_handover_entry(efi_handle_t handle, efi_system_table_t *sys_table_arg,
+			struct boot_params *boot_params)
+{
+	extern char _bss[], _ebss[];
+
+	memset(_bss, 0, _ebss - _bss);
+	efi_stub_entry(handle, sys_table_arg, boot_params);
+}
+
 #ifndef CONFIG_EFI_MIXED
-extern __alias(efi_stub_entry)
+extern __alias(efi_handover_entry)
 void efi32_stub_entry(efi_handle_t handle, efi_system_table_t *sys_table_arg,
 		      struct boot_params *boot_params);
 
-extern __alias(efi_stub_entry)
+extern __alias(efi_handover_entry)
 void efi64_stub_entry(efi_handle_t handle, efi_system_table_t *sys_table_arg,
 		      struct boot_params *boot_params);
 #endif


