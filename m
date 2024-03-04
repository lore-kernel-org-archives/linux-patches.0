Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AE01EB5A;
	Mon,  4 Mar 2024 21:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588842; cv=none; b=dcuyvciKKaiBueTcLArFaynW/hO/P782ApwjQlyokF7AiJ+E5tuUqVl+7ZzmwzRK3QxkEV2yFCx9oL5MIOQivNms4FuHKs1AQbTgM7SrXdW8N5Qm+mVz13m5HaJTodghRkwBKi0T1FvtT+5yBO+wrm9Ex3hKzpSwK25MpiY6zPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588842; c=relaxed/simple;
	bh=YC83cLOF+zyVlW/htIyVrrvGj4X+vsf1DblTYDCUcSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFdUCSxBaTVTgTbQKkCvym4Bp/12qPjdS55IjIFcMOkxjXHkLRWKZqXbI7zFHEsMrIYSlEQQCSkf77wDsJ6qfcLiIlALsO4da3MVvKpu0D/DaCbUG0s+BElmLEMkSbqcqefLn2gc9EklRwt5f60U3N/6ZwLfjB5b/FNe4zknCPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJwW+9Rz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJwW+9Rz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D549FC433F1;
	Mon,  4 Mar 2024 21:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588842;
	bh=YC83cLOF+zyVlW/htIyVrrvGj4X+vsf1DblTYDCUcSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJwW+9RzKl5atU32AP3E5mqacC4u/f2AZP9Q7eLw6dzs0eTXhO5IyoND2kt+AO2Qz
	 RFpvIujUwyGvKu7iHwDpaRXa3maKky3sfWzU/kvuoB7q05XV73UuZdPOmHglohNSyL
	 aBaZmYCADXeSb5TW2bTX4yF1eW91Kfl+PKxrdu9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.1 117/215] x86/boot/compressed: Simplify IDT/GDT preserve/restore in the EFI thunk
Date: Mon,  4 Mar 2024 21:23:00 +0000
Message-ID: <20240304211600.762763988@linuxfoundation.org>
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

commit 630f337f0c4fd80390e8600adcab31550aea33df upstream.

Tweak the asm and remove some redundant instructions. While at it,
fix the associated comment for style and correctness.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20221122161017.2426828-9-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/efi_mixed.S |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

--- a/arch/x86/boot/compressed/efi_mixed.S
+++ b/arch/x86/boot/compressed/efi_mixed.S
@@ -96,24 +96,20 @@ SYM_FUNC_START(__efi64_thunk)
 
 	leaq	0x20(%rsp), %rbx
 	sgdt	(%rbx)
-
-	addq	$16, %rbx
-	sidt	(%rbx)
+	sidt	16(%rbx)
 
 	leaq	1f(%rip), %rbp
 
 	/*
-	 * Switch to IDT and GDT with 32-bit segments. This is the firmware GDT
-	 * and IDT that was installed when the kernel started executing. The
-	 * pointers were saved by the efi32_entry() routine below.
+	 * Switch to IDT and GDT with 32-bit segments. These are the firmware
+	 * GDT and IDT that were installed when the kernel started executing.
+	 * The pointers were saved by the efi32_entry() routine below.
 	 *
 	 * Pass the saved DS selector to the 32-bit code, and use far return to
 	 * restore the saved CS selector.
 	 */
-	leaq	efi32_boot_idt(%rip), %rax
-	lidt	(%rax)
-	leaq	efi32_boot_gdt(%rip), %rax
-	lgdt	(%rax)
+	lidt	efi32_boot_idt(%rip)
+	lgdt	efi32_boot_gdt(%rip)
 
 	movzwl	efi32_boot_ds(%rip), %edx
 	movzwq	efi32_boot_cs(%rip), %rax
@@ -187,9 +183,7 @@ SYM_FUNC_START_LOCAL(efi_enter32)
 	 */
 	cli
 
-	lidtl	(%ebx)
-	subl	$16, %ebx
-
+	lidtl	16(%ebx)
 	lgdtl	(%ebx)
 
 	movl	%cr4, %eax


