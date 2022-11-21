Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B6F3D74
	for <patches@lists.linux.dev>; Mon, 21 Nov 2022 12:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC11C433C1;
	Mon, 21 Nov 2022 12:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669034687;
	bh=0q0Psi7fyKyo3QGbCxCqGfT4LqjyRduaugNxMpHWhUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cHhjglSSR2v2ezqZoR59nGnAV5V9KnJ/yiQgRkcgkjHAdvcLdogKkvdAItiKW3YPA
	 eSOLWPih4NrEI6p1/C+xc8otXYWCwvtpXyYNuLzdowL2ycEd9moppgzWKr/hNPN1bU
	 indnmdYP02BIUPGZalQKVH2a2TZarnSCM1EjYFG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Borislav Petkov <bp@suse.de>,
	Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
	Suleiman Souhlal <suleiman@google.com>
Subject: [PATCH 4.19 20/34] x86/speculation: Fix RSB filling with CONFIG_RETPOLINE=n
Date: Mon, 21 Nov 2022 13:43:42 +0100
Message-Id: <20221121124151.615281027@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121124150.886779344@linuxfoundation.org>
References: <20221121124150.886779344@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit b2620facef4889fefcbf2e87284f34dcd4189bce upstream.

If a kernel is built with CONFIG_RETPOLINE=n, but the user still wants
to mitigate Spectre v2 using IBRS or eIBRS, the RSB filling will be
silently disabled.

There's nothing retpoline-specific about RSB buffer filling.  Remove the
CONFIG_RETPOLINE guards around it.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_32.S            |    2 --
 arch/x86/entry/entry_64.S            |    2 --
 arch/x86/include/asm/nospec-branch.h |    2 --
 3 files changed, 6 deletions(-)

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -643,7 +643,6 @@ ENTRY(__switch_to_asm)
 	movl	%ebx, PER_CPU_VAR(stack_canary)+stack_canary_offset
 #endif
 
-#ifdef CONFIG_RETPOLINE
 	/*
 	 * When switching from a shallower to a deeper call stack
 	 * the RSB may either underflow or use entries populated
@@ -652,7 +651,6 @@ ENTRY(__switch_to_asm)
 	 * speculative execution to prevent attack.
 	 */
 	FILL_RETURN_BUFFER %ebx, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_CTXSW
-#endif
 
 	/* restore callee-saved registers */
 	popfl
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -367,7 +367,6 @@ ENTRY(__switch_to_asm)
 	movq	%rbx, PER_CPU_VAR(irq_stack_union)+stack_canary_offset
 #endif
 
-#ifdef CONFIG_RETPOLINE
 	/*
 	 * When switching from a shallower to a deeper call stack
 	 * the RSB may either underflow or use entries populated
@@ -376,7 +375,6 @@ ENTRY(__switch_to_asm)
 	 * speculative execution to prevent attack.
 	 */
 	FILL_RETURN_BUFFER %r12, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_CTXSW
-#endif
 
 	/* restore callee-saved registers */
 	popfq
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -159,11 +159,9 @@
   * monstrosity above, manually.
   */
 .macro FILL_RETURN_BUFFER reg:req nr:req ftr:req
-#ifdef CONFIG_RETPOLINE
 	ALTERNATIVE "jmp .Lskip_rsb_\@", "", \ftr
 	__FILL_RETURN_BUFFER(\reg,\nr,%_ASM_SP)
 .Lskip_rsb_\@:
-#endif
 .endm
 
 #else /* __ASSEMBLY__ */


