Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD7E1EB5A;
	Mon,  4 Mar 2024 21:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588963; cv=none; b=S8Ox0NAoxNaiC8McsDo8Z/DqP1duwbdV4Kh/w2fUDifbNk9uOtMtbytY1tNRF2yMHUOiI/adRoYnWqEiI3QXmDX9kuFpk9IbIUJtRzo1wTJTpBTGos63J2Pt1tIwstl+g5HN3h7s/7ly9ViUn0RHPlTloDt/j+9aA+iO7csFu3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588963; c=relaxed/simple;
	bh=cSGlSAkWbbDJkzsjAU9WByVrnga9Q0nVLa7gsJ2urDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMQy/ZKen4G8hioA5UMiEaDt4kBQPylRr79egww4nj3nVUE+u6hrQM+Bndwan5OQLhldsIaEkMVQOgQjHLYGXPq/5RVVwyVjigyFjefE9qxz8hLgJqBNGT818FRvewE22gHC25fEv0jsjHK49DEj8uEZj5jqHDmAEjdFUh9dW1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPHulFKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPHulFKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91926C433C7;
	Mon,  4 Mar 2024 21:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588962;
	bh=cSGlSAkWbbDJkzsjAU9WByVrnga9Q0nVLa7gsJ2urDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPHulFKt0gMi5TciFfidw9owiYtlk3QmKd8um20596SflYhbtqeHMKhSTv0NmTWtS
	 pX4JWT5m54Wb0cRqf3XXvn+dOkJlJrbPNuwlHosloh5iJ91JnTaYiM1WF54sEbm0XN
	 mfp6UsGhhKeZ/k7WFI2qJX3TFu9CUiYWaJetz55E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.1 124/215] x86/boot/compressed: Adhere to calling convention in get_sev_encryption_bit()
Date: Mon,  4 Mar 2024 21:23:07 +0000
Message-ID: <20240304211601.004589522@linuxfoundation.org>
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

commit 30c9ca16a5271ba6f8ad9c86507ff1c789c94677 upstream.

Make get_sev_encryption_bit() follow the ordinary i386 calling
convention, and only call it if CONFIG_AMD_MEM_ENCRYPT is actually
enabled. This clarifies the calling code, and makes it more
maintainable.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20221122161017.2426828-16-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/head_64.S     |    5 +++--
 arch/x86/boot/compressed/mem_encrypt.S |   10 ----------
 2 files changed, 3 insertions(+), 12 deletions(-)

--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -180,12 +180,13 @@ SYM_FUNC_START(startup_32)
   */
 	/*
 	 * If SEV is active then set the encryption mask in the page tables.
-	 * This will insure that when the kernel is copied and decompressed
+	 * This will ensure that when the kernel is copied and decompressed
 	 * it will be done so encrypted.
 	 */
-	call	get_sev_encryption_bit
 	xorl	%edx, %edx
 #ifdef	CONFIG_AMD_MEM_ENCRYPT
+	call	get_sev_encryption_bit
+	xorl	%edx, %edx
 	testl	%eax, %eax
 	jz	1f
 	subl	$32, %eax	/* Encryption bit is always above bit 31 */
--- a/arch/x86/boot/compressed/mem_encrypt.S
+++ b/arch/x86/boot/compressed/mem_encrypt.S
@@ -18,12 +18,7 @@
 	.text
 	.code32
 SYM_FUNC_START(get_sev_encryption_bit)
-	xor	%eax, %eax
-
-#ifdef CONFIG_AMD_MEM_ENCRYPT
 	push	%ebx
-	push	%ecx
-	push	%edx
 
 	movl	$0x80000000, %eax	/* CPUID to check the highest leaf */
 	cpuid
@@ -54,12 +49,7 @@ SYM_FUNC_START(get_sev_encryption_bit)
 	xor	%eax, %eax
 
 .Lsev_exit:
-	pop	%edx
-	pop	%ecx
 	pop	%ebx
-
-#endif	/* CONFIG_AMD_MEM_ENCRYPT */
-
 	RET
 SYM_FUNC_END(get_sev_encryption_bit)
 


