Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7A81EB5A;
	Mon,  4 Mar 2024 21:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588887; cv=none; b=JP6PFiKvLurUR3JsKusKHgOpTmrZfKfCmNqKp8pjg/23o+uwCqEwRwoFmUcuxVogzsyxjVtuOIubaHwtok9UKJdsnce++ZPbuV46Fcw1zMgXmmapaYgKQSakhRzQ12FYb2NwBLNh7FeQax4qY7+T4fmwBxW531gVlYAqSsVBK1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588887; c=relaxed/simple;
	bh=jKUnLj1cYMSjmrxE0wLLAtP7jkn3bA9Nv92d7se1XLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zah+wgrYeLCkZtYbpXQ3oYIkLF2k4tB/M9Wz68Tlfg7hQZuyoAo/lUcjl5JLu0NWZqs9kvfqYEZp9g1P/Qj3M13R16+HcruZtD9IY4CB1Yu9NjBJ1ZVwmjaqO1dHhvhgFRLLdKqQL/3+8Cp0yRpmkrG1mwfqaD8j6JnAa4ko4JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8trGnby; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8trGnby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FDDC433F1;
	Mon,  4 Mar 2024 21:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588887;
	bh=jKUnLj1cYMSjmrxE0wLLAtP7jkn3bA9Nv92d7se1XLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8trGnbyGZI/9+vWs/VS6ziog17koxkU9NUIogSa+U5jRpILCJqqy4aGAW71z5V6p
	 mp5wINuz1PKiXWx5Sb8C4na/ItrjAW+TmObsbZWVUJ8IQ2e2tLiz+pcI1AXzHFlkOA
	 Fo6dy8Ujk9s7h+q4CRygiLEieTCSLT7YFBy1X/bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.1 120/215] x86/boot/compressed: Move startup32_load_idt() into .text section
Date: Mon,  4 Mar 2024 21:23:03 +0000
Message-ID: <20240304211600.876171962@linuxfoundation.org>
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

commit c6355995ba471d7ad574174e593192ce805c7e1a upstream.

Convert startup32_load_idt() into an ordinary function and move it into
the .text section. This involves turning the rva() immediates into ones
derived from a local label, and preserving/restoring the %ebp and %ebx
as per the calling convention.

Also move the #ifdef to the only existing call site. This makes it clear
that the function call does nothing if support for memory encryption is
not compiled in.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20221122161017.2426828-12-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/head_64.S |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -118,7 +118,9 @@ SYM_FUNC_START(startup_32)
 1:
 
 	/* Setup Exception handling for SEV-ES */
+#ifdef CONFIG_AMD_MEM_ENCRYPT
 	call	startup32_load_idt
+#endif
 
 	/* Make sure cpu supports long mode. */
 	call	verify_cpu
@@ -732,10 +734,8 @@ SYM_DATA_START(boot32_idt)
 	.quad 0
 	.endr
 SYM_DATA_END_LABEL(boot32_idt, SYM_L_GLOBAL, boot32_idt_end)
-#endif
 
-#ifdef CONFIG_AMD_MEM_ENCRYPT
-	__HEAD
+	.text
 	.code32
 /*
  * Write an IDT entry into boot32_idt
@@ -768,24 +768,32 @@ SYM_FUNC_START_LOCAL(startup32_set_idt_e
 
 	RET
 SYM_FUNC_END(startup32_set_idt_entry)
-#endif
 
 SYM_FUNC_START(startup32_load_idt)
-#ifdef CONFIG_AMD_MEM_ENCRYPT
-	leal    rva(boot32_idt)(%ebp), %ecx
+	push	%ebp
+	push	%ebx
+
+	call	1f
+1:	pop	%ebp
+
+	leal    (boot32_idt - 1b)(%ebp), %ebx
 
 	/* #VC handler */
-	leal    rva(startup32_vc_handler)(%ebp), %eax
+	leal    (startup32_vc_handler - 1b)(%ebp), %eax
 	movl    $X86_TRAP_VC, %edx
+	movl	%ebx, %ecx
 	call    startup32_set_idt_entry
 
 	/* Load IDT */
-	leal	rva(boot32_idt)(%ebp), %eax
-	movl	%eax, rva(boot32_idt_desc+2)(%ebp)
-	lidt    rva(boot32_idt_desc)(%ebp)
-#endif
+	leal	(boot32_idt_desc - 1b)(%ebp), %ecx
+	movl	%ebx, 2(%ecx)
+	lidt    (%ecx)
+
+	pop	%ebx
+	pop	%ebp
 	RET
 SYM_FUNC_END(startup32_load_idt)
+#endif
 
 /*
  * Check for the correct C-bit position when the startup_32 boot-path is used.
@@ -804,6 +812,7 @@ SYM_FUNC_END(startup32_load_idt)
  * succeed. An incorrect C-bit position will map all memory unencrypted, so that
  * the compare will use the encrypted random data and fail.
  */
+	__HEAD
 SYM_FUNC_START(startup32_check_sev_cbit)
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 	pushl	%eax


