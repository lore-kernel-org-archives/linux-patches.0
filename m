Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7CD30FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A78DC43397;
	Wed, 20 Sep 2023 12:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212820;
	bh=xKv9gL4Q5wSve6jHOQYz7C62hD4aYrqWmv8wkjQYGpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JFr50shcSxF9XpDXk+JxmRb/0UBzQ/ypJggN6D4zKarB5PuQ3yV0KaGYXTeDIawPO
	 JRQPuK8DNFYuGewjYxZNPZEdHjO0fHgoyXDORyyD0mQ6Hqv9wZCEYqQozRNGZQDEcJ
	 ULtvR+81cbm7wZTKylIdYf+0ZG88MBGUU4YXcXA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/367] x86/decompressor: Dont rely on upper 32 bits of GPRs being preserved
Date: Wed, 20 Sep 2023 13:27:14 +0200
Message-ID: <20230920112859.977728923@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 264b82fdb4989cf6a44a2bcd0c6ea05e8026b2ac ]

The 4-to-5 level mode switch trampoline disables long mode and paging in
order to be able to flick the LA57 bit. According to section 3.4.1.1 of
the x86 architecture manual [0], 64-bit GPRs might not retain the upper
32 bits of their contents across such a mode switch.

Given that RBP, RBX and RSI are live at this point, preserve them on the
stack, along with the return address that might be above 4G as well.

[0] Intel® 64 and IA-32 Architectures Software Developer’s Manual, Volume 1: Basic Architecture

  "Because the upper 32 bits of 64-bit general-purpose registers are
   undefined in 32-bit modes, the upper 32 bits of any general-purpose
   register are not preserved when switching from 64-bit mode to a 32-bit
   mode (to protected mode or compatibility mode). Software must not
   depend on these bits to maintain a value after a 64-bit to 32-bit
   mode switch."

Fixes: 194a9749c73d650c ("x86/boot/compressed/64: Handle 5-level paging boot if kernel is above 4G")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230807162720.545787-2-ardb@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/head_64.S | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 95ee795d97964..d8164e6abaaff 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -381,11 +381,25 @@ ENTRY(startup_64)
 	/* Save the trampoline address in RCX */
 	movq	%rax, %rcx
 
+	/* Set up 32-bit addressable stack */
+	leaq	TRAMPOLINE_32BIT_STACK_END(%rcx), %rsp
+
+	/*
+	 * Preserve live 64-bit registers on the stack: this is necessary
+	 * because the architecture does not guarantee that GPRs will retain
+	 * their full 64-bit values across a 32-bit mode switch.
+	 */
+	pushq	%rbp
+	pushq	%rbx
+	pushq	%rsi
+
 	/*
-	 * Load the address of trampoline_return() into RDI.
-	 * It will be used by the trampoline to return to the main code.
+	 * Push the 64-bit address of trampoline_return() onto the new stack.
+	 * It will be used by the trampoline to return to the main code. Due to
+	 * the 32-bit mode switch, it cannot be kept it in a register either.
 	 */
 	leaq	trampoline_return(%rip), %rdi
+	pushq	%rdi
 
 	/* Switch to compatibility mode (CS.L = 0 CS.D = 1) via far return */
 	pushq	$__KERNEL32_CS
@@ -393,6 +407,11 @@ ENTRY(startup_64)
 	pushq	%rax
 	lretq
 trampoline_return:
+	/* Restore live 64-bit registers */
+	popq	%rsi
+	popq	%rbx
+	popq	%rbp
+
 	/* Restore the stack, the 32-bit trampoline uses its own stack */
 	leaq	boot_stack_end(%rbx), %rsp
 
@@ -573,7 +592,7 @@ SYM_FUNC_END(.Lrelocated)
 /*
  * This is the 32-bit trampoline that will be copied over to low memory.
  *
- * RDI contains the return address (might be above 4G).
+ * Return address is at the top of the stack (might be above 4G).
  * ECX contains the base address of the trampoline memory.
  * Non zero RDX means trampoline needs to enable 5-level paging.
  */
@@ -583,9 +602,6 @@ ENTRY(trampoline_32bit_src)
 	movl	%eax, %ds
 	movl	%eax, %ss
 
-	/* Set up new stack */
-	leal	TRAMPOLINE_32BIT_STACK_END(%ecx), %esp
-
 	/* Disable paging */
 	movl	%cr0, %eax
 	btrl	$X86_CR0_PG_BIT, %eax
@@ -644,7 +660,7 @@ ENTRY(trampoline_32bit_src)
 	.code64
 SYM_FUNC_START_LOCAL_NOALIGN(.Lpaging_enabled)
 	/* Return from the trampoline */
-	jmp	*%rdi
+	retq
 SYM_FUNC_END(.Lpaging_enabled)
 
 	/*
-- 
2.40.1



