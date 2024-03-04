Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EEB1EB5A;
	Mon,  4 Mar 2024 21:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588976; cv=none; b=cwXFpmogL3Pp6giA+WLY8zz/OnbsLQOZcK8s/1E8HewE57bwWhdWQaY4WJRkXeoR4YlufT6dM8PAIfYbftN3vU7zLAR+kpznhwJxefevzj5MxprWUxdpULb8GUlIxar07DjvoK7LVGHh24+w95xfTs96HCa/4Pp86mW8hPooQB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588976; c=relaxed/simple;
	bh=JE+EA/Gf1fGu4iZ2UlztxxU0LkvMbTzst+vjTs0SWKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVXodmc5um1Fl3YhFJOL4EE+XnP22824/KE1PhUoIyjc4KGgbMAnriyhm/SHKR2nXHyb0aJKGerOJYG+NeJNT2fyNhUA+ODs3/sdn25rE935AlNfhRvvXZ61WOJiq0QUd/3/spbU/5opUOtQ41CrnI+NNkc7RViqFwhFZDpTXn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwofT81I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwofT81I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF92C433F1;
	Mon,  4 Mar 2024 21:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588975;
	bh=JE+EA/Gf1fGu4iZ2UlztxxU0LkvMbTzst+vjTs0SWKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DwofT81If6iruHV529b6KmNRs7P/goxFYRsVJiFDGHm/THzUkirOIc3LclTEcz7qx
	 JoniLit9aRCr/sYfEUQP7qjrK9rEWJmO7Mdo3SKSF+Gcmt0ZaPx//KP/dYfprfw4hr
	 j0a/+1GaMDhKyPePskKHb0bAnGxY5rPcAivr2qiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.1 119/215] x86/boot/compressed: Pull global variable reference into startup32_load_idt()
Date: Mon,  4 Mar 2024 21:23:02 +0000
Message-ID: <20240304211600.840636668@linuxfoundation.org>
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

commit d73a257f7f86871c3aac24dc20538e3983096647 upstream.

In preparation for moving startup32_load_idt() out of head_64.S and
turning it into an ordinary function using the ordinary 32-bit calling
convention, pull the global variable reference to boot32_idt up into
startup32_load_idt() so that startup32_set_idt_entry() does not need to
discover its own runtime physical address, which will no longer be
correlated with startup_32 once this code is moved into .text.

While at it, give startup32_set_idt_entry() static linkage.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20221122161017.2426828-11-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/head_64.S |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -744,16 +744,11 @@ SYM_DATA_END_LABEL(boot32_idt, SYM_L_GLO
  *
  * %eax:	Handler address
  * %edx:	Vector number
- *
- * Physical offset is expected in %ebp
+ * %ecx:	IDT address
  */
-SYM_FUNC_START(startup32_set_idt_entry)
-	push    %ebx
-
-	/* IDT entry address to %ebx */
-	leal    rva(boot32_idt)(%ebp), %ebx
-	shl	$3, %edx
-	addl    %edx, %ebx
+SYM_FUNC_START_LOCAL(startup32_set_idt_entry)
+	/* IDT entry address to %ecx */
+	leal	(%ecx, %edx, 8), %ecx
 
 	/* Build IDT entry, lower 4 bytes */
 	movl    %eax, %edx
@@ -761,7 +756,7 @@ SYM_FUNC_START(startup32_set_idt_entry)
 	orl	$(__KERNEL32_CS << 16), %edx	# Target code segment selector
 
 	/* Store lower 4 bytes to IDT */
-	movl    %edx, (%ebx)
+	movl    %edx, (%ecx)
 
 	/* Build IDT entry, upper 4 bytes */
 	movl    %eax, %edx
@@ -769,15 +764,16 @@ SYM_FUNC_START(startup32_set_idt_entry)
 	orl     $0x00008e00, %edx	# Present, Type 32-bit Interrupt Gate
 
 	/* Store upper 4 bytes to IDT */
-	movl    %edx, 4(%ebx)
+	movl    %edx, 4(%ecx)
 
-	pop     %ebx
 	RET
 SYM_FUNC_END(startup32_set_idt_entry)
 #endif
 
 SYM_FUNC_START(startup32_load_idt)
 #ifdef CONFIG_AMD_MEM_ENCRYPT
+	leal    rva(boot32_idt)(%ebp), %ecx
+
 	/* #VC handler */
 	leal    rva(startup32_vc_handler)(%ebp), %eax
 	movl    $X86_TRAP_VC, %edx


