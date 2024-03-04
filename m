Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F41979F2;
	Mon,  4 Mar 2024 21:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589052; cv=none; b=JaAfMAn7eiQ+kDZNKcIHdAVLsXHCaL7T2kDvmCtakk2So6H+cCzItssoqLBdCrtcUYgaIas1CYR/oGgY3to3m9/lTFakejtCT38zyKcJjON8x1XFtjiWkFn7tXt6oP675ypxGGas7pOinnoBfCPo6BxLW13pCKhPViXAIQKzvtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589052; c=relaxed/simple;
	bh=a0rDHc5FIHourIpdjYNvdaMeROGSMYwzHis/hOyWNS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyjUN9/XSas1uFiUWzdD+sVYrMQVk01XVahjr9w1cbFuqY1FHfQJcKNZr5CaYWkUs5chv7DKeUtkZqLfesy52QLCK8jsXRSq9IiSz6h5h1eutCTnJzsE6JwqbeRRaEBMxdTXIyYCIji4txSB+uV68u9dfHlVJ/M1sZ3KGcTn1Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+o6sLhg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+o6sLhg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EFAC433F1;
	Mon,  4 Mar 2024 21:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589052;
	bh=a0rDHc5FIHourIpdjYNvdaMeROGSMYwzHis/hOyWNS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+o6sLhgMciMEBkQRxoUaI2nCsUTlAm0cYOc/t1nv9yc9rlEb8vzQpX9gFAhp7RDW
	 7GWArYUQHRC03eqR+eqjv9GmIRmwTLsu06C3uO3GLfXWtXGjU/5zcH503uDRCTFqIy
	 3SW3k8LINVeaTxf/pZkH53Yf6zAhJ12whjzjzpno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 183/215] x86/decompressor: Avoid magic offsets for EFI handover entrypoint
Date: Mon,  4 Mar 2024 21:24:06 +0000
Message-ID: <20240304211602.751821772@linuxfoundation.org>
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

[ Commit 12792064587623065250069d1df980e2c9ac3e67 upstream ]

The native 32-bit or 64-bit EFI handover protocol entrypoint offset
relative to the respective startup_32/64 address is described in
boot_params as handover_offset, so that the special Linux/x86 aware EFI
loader can find it there.

When mixed mode is enabled, this single field has to describe this
offset for both the 32-bit and 64-bit entrypoints, so their respective
relative offsets have to be identical. Given that startup_32 and
startup_64 are 0x200 bytes apart, and the EFI handover entrypoint
resides at a fixed offset, the 32-bit and 64-bit versions of those
entrypoints must be exactly 0x200 bytes apart as well.

Currently, hard-coded fixed offsets are used to ensure this, but it is
sufficient to emit the 64-bit entrypoint 0x200 bytes after the 32-bit
one, wherever it happens to reside. This allows this code (which is now
EFI mixed mode specific) to be moved into efi_mixed.S and out of the
startup code in head_64.S.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230807162720.545787-6-ardb@kernel.org
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/efi_mixed.S |   20 +++++++++++++++++++-
 arch/x86/boot/compressed/head_64.S   |   18 ------------------
 2 files changed, 19 insertions(+), 19 deletions(-)

--- a/arch/x86/boot/compressed/efi_mixed.S
+++ b/arch/x86/boot/compressed/efi_mixed.S
@@ -146,6 +146,16 @@ SYM_FUNC_START(__efi64_thunk)
 SYM_FUNC_END(__efi64_thunk)
 
 	.code32
+#ifdef CONFIG_EFI_HANDOVER_PROTOCOL
+SYM_FUNC_START(efi32_stub_entry)
+	add	$0x4, %esp		/* Discard return address */
+	popl	%ecx
+	popl	%edx
+	popl	%esi
+	jmp	efi32_entry
+SYM_FUNC_END(efi32_stub_entry)
+#endif
+
 /*
  * EFI service pointer must be in %edi.
  *
@@ -226,7 +236,7 @@ SYM_FUNC_END(efi_enter32)
  * stub may still exit and return to the firmware using the Exit() EFI boot
  * service.]
  */
-SYM_FUNC_START(efi32_entry)
+SYM_FUNC_START_LOCAL(efi32_entry)
 	call	1f
 1:	pop	%ebx
 
@@ -326,6 +336,14 @@ SYM_FUNC_START(efi32_pe_entry)
 	RET
 SYM_FUNC_END(efi32_pe_entry)
 
+#ifdef CONFIG_EFI_HANDOVER_PROTOCOL
+	.org	efi32_stub_entry + 0x200
+	.code64
+SYM_FUNC_START_NOALIGN(efi64_stub_entry)
+	jmp	efi_stub_entry
+SYM_FUNC_END(efi64_stub_entry)
+#endif
+
 	.section ".rodata"
 	/* EFI loaded image protocol GUID */
 	.balign 4
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -286,17 +286,6 @@ SYM_FUNC_START(startup_32)
 	lret
 SYM_FUNC_END(startup_32)
 
-#if IS_ENABLED(CONFIG_EFI_MIXED) && IS_ENABLED(CONFIG_EFI_HANDOVER_PROTOCOL)
-	.org 0x190
-SYM_FUNC_START(efi32_stub_entry)
-	add	$0x4, %esp		/* Discard return address */
-	popl	%ecx
-	popl	%edx
-	popl	%esi
-	jmp	efi32_entry
-SYM_FUNC_END(efi32_stub_entry)
-#endif
-
 	.code64
 	.org 0x200
 SYM_CODE_START(startup_64)
@@ -474,13 +463,6 @@ SYM_CODE_START(startup_64)
 	jmp	*%rax
 SYM_CODE_END(startup_64)
 
-#if IS_ENABLED(CONFIG_EFI_MIXED) && IS_ENABLED(CONFIG_EFI_HANDOVER_PROTOCOL)
-	.org 0x390
-SYM_FUNC_START(efi64_stub_entry)
-	jmp	efi_stub_entry
-SYM_FUNC_END(efi64_stub_entry)
-#endif
-
 	.text
 SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated)
 


