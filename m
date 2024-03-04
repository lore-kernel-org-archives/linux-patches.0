Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2901EB5A;
	Mon,  4 Mar 2024 21:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588845; cv=none; b=i/9kgpVQkPm2eKEZvPC9N3te24NVZFbMq9TGgTI/na7H0xUpRO+CnSeCad8zBUmY8j9sMahBKjC53RyeEjwTkDkhy9mvR7Mi2biDk5mzmtcRd305U5ZQwqznkKKJOO6EkALdoU/dBFUgi6y90YMRHXgTW+452dGDHTWd4k5tmj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588845; c=relaxed/simple;
	bh=oK3b/c/Ns91vcAvJA51OKQr+QD2Zfijc+i3svCXslmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mekyX5mNNfa+XkikScOC94wKTT9jk4fptqtB+a7Gn+k14FDGLwktSutgiT8Q29ldkh9i0B8c7wTQb7Ts8U103Rca68b12Ja7wHVvhk9y9tkql6PT6EiXKm19ZmhuZc+Id1796HBiYDkPaLxzMAPdt0thihke09olojvd55jmcgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxG5dzc6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxG5dzc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721E1C433C7;
	Mon,  4 Mar 2024 21:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588844;
	bh=oK3b/c/Ns91vcAvJA51OKQr+QD2Zfijc+i3svCXslmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxG5dzc68WdlXB/3gS2BCqScz3jrVZzxiKbGe3X7mAe7+x6V2ytRzh2Bnp/sau4T1
	 /lh3uD7fysdwxTS5uJLqI7FE8OfV0EKxyQX6ou0Df+Go8AEqrKo6ZIpfmWwcWOjGQV
	 4wa58F9vjEDUti/5sls8DHNX+I8GHnHU6tTvJL90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.1 118/215] x86/boot/compressed: Avoid touching ECX in startup32_set_idt_entry()
Date: Mon,  4 Mar 2024 21:23:01 +0000
Message-ID: <20240304211600.800656241@linuxfoundation.org>
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

commit 6aac80a8da46d70f2ae7ff97c9f45a15c7c9b3ef upstream.

Avoid touching register %ecx in startup32_set_idt_entry(), by folding
the MOV, SHL and ORL instructions into a single ORL which no longer
requires a temp register.

This permits ECX to be used as a function argument in a subsequent
patch.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20221122161017.2426828-10-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/head_64.S |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -749,7 +749,6 @@ SYM_DATA_END_LABEL(boot32_idt, SYM_L_GLO
  */
 SYM_FUNC_START(startup32_set_idt_entry)
 	push    %ebx
-	push    %ecx
 
 	/* IDT entry address to %ebx */
 	leal    rva(boot32_idt)(%ebp), %ebx
@@ -758,10 +757,8 @@ SYM_FUNC_START(startup32_set_idt_entry)
 
 	/* Build IDT entry, lower 4 bytes */
 	movl    %eax, %edx
-	andl    $0x0000ffff, %edx	# Target code segment offset [15:0]
-	movl    $__KERNEL32_CS, %ecx	# Target code segment selector
-	shl     $16, %ecx
-	orl     %ecx, %edx
+	andl    $0x0000ffff, %edx		# Target code segment offset [15:0]
+	orl	$(__KERNEL32_CS << 16), %edx	# Target code segment selector
 
 	/* Store lower 4 bytes to IDT */
 	movl    %edx, (%ebx)
@@ -774,7 +771,6 @@ SYM_FUNC_START(startup32_set_idt_entry)
 	/* Store upper 4 bytes to IDT */
 	movl    %edx, 4(%ebx)
 
-	pop     %ecx
 	pop     %ebx
 	RET
 SYM_FUNC_END(startup32_set_idt_entry)


