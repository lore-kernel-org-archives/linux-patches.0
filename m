Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0199E30FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B2AC433CA;
	Wed, 20 Sep 2023 12:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212812;
	bh=4jSF39GJRTca/dC7MqnhzLd1uc+LD/2t+U5LhtMGAV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqbU9uej+8hjWWpNrlTbxc2Hq2gKThmYVJt651SjG0v/VpoMV7+zJncN17AcqHJHk
	 lc4wvvCRdNowFow5X+OJKglFJN5642pPmveoq+h/Q8TyC7ZVjBy8EkEUfOFIV2+ai/
	 JwFDYkyab0bkeORqjsxozP+ZpfQKqC2vapMa1xwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jslaby@suse.cz>,
	Borislav Petkov <bp@suse.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	bp@alien8.de,
	hpa@zytor.com,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/367] x86/asm: Make more symbols local
Date: Wed, 20 Sep 2023 13:27:12 +0200
Message-ID: <20230920112859.924590531@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit 30a2441cae7b149ff484a697bf9eb8de53240a4f ]

During the assembly cleanup patchset review, I found more symbols which
are used only locally. So make them really local by prepending ".L" to
them. Namely:

 - wakeup_idt is used only in realmode/rm/wakeup_asm.S.
 - in_pm32 is used only in boot/pmjump.S.
 - retint_user is used only in entry/entry_64.S, perhaps since commit
   2ec67971facc ("x86/entry/64/compat: Remove most of the fast system
   call machinery"), where entry_64_compat's caller was removed.

Drop GLOBAL from all of them too. I do not see more candidates in the
series.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: bp@alien8.de
Cc: hpa@zytor.com
Link: https://lkml.kernel.org/r/20191011092213.31470-1-jslaby@suse.cz
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Stable-dep-of: 264b82fdb498 ("x86/decompressor: Don't rely on upper 32 bits of GPRs being preserved")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/pmjump.S            | 6 +++---
 arch/x86/entry/entry_64.S         | 4 ++--
 arch/x86/realmode/rm/wakeup_asm.S | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/boot/pmjump.S b/arch/x86/boot/pmjump.S
index c22f9a7d1aeb9..ea88d52eeac70 100644
--- a/arch/x86/boot/pmjump.S
+++ b/arch/x86/boot/pmjump.S
@@ -40,13 +40,13 @@ GLOBAL(protected_mode_jump)
 
 	# Transition to 32-bit mode
 	.byte	0x66, 0xea		# ljmpl opcode
-2:	.long	in_pm32			# offset
+2:	.long	.Lin_pm32		# offset
 	.word	__BOOT_CS		# segment
 ENDPROC(protected_mode_jump)
 
 	.code32
 	.section ".text32","ax"
-GLOBAL(in_pm32)
+.Lin_pm32:
 	# Set up data segments for flat 32-bit mode
 	movl	%ecx, %ds
 	movl	%ecx, %es
@@ -72,4 +72,4 @@ GLOBAL(in_pm32)
 	lldt	%cx
 
 	jmpl	*%eax			# Jump to the 32-bit entrypoint
-ENDPROC(in_pm32)
+ENDPROC(.Lin_pm32)
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index bd7a4ad0937c4..640c7d36c26c7 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -618,7 +618,7 @@ ret_from_intr:
 	jz	retint_kernel
 
 	/* Interrupt came from user space */
-GLOBAL(retint_user)
+.Lretint_user:
 	mov	%rsp,%rdi
 	call	prepare_exit_to_usermode
 	TRACE_IRQS_IRETQ
@@ -1392,7 +1392,7 @@ ENTRY(error_exit)
 	TRACE_IRQS_OFF
 	testb	$3, CS(%rsp)
 	jz	retint_kernel
-	jmp	retint_user
+	jmp	.Lretint_user
 END(error_exit)
 
 /*
diff --git a/arch/x86/realmode/rm/wakeup_asm.S b/arch/x86/realmode/rm/wakeup_asm.S
index 05ac9c17c8111..dad6198f1a266 100644
--- a/arch/x86/realmode/rm/wakeup_asm.S
+++ b/arch/x86/realmode/rm/wakeup_asm.S
@@ -73,7 +73,7 @@ ENTRY(wakeup_start)
 	movw	%ax, %fs
 	movw	%ax, %gs
 
-	lidtl	wakeup_idt
+	lidtl	.Lwakeup_idt
 
 	/* Clear the EFLAGS */
 	pushl $0
@@ -171,8 +171,8 @@ END(wakeup_gdt)
 
 	/* This is the standard real-mode IDT */
 	.balign	16
-GLOBAL(wakeup_idt)
+.Lwakeup_idt:
 	.word	0xffff		/* limit */
 	.long	0		/* address */
 	.word	0
-END(wakeup_idt)
+END(.Lwakeup_idt)
-- 
2.40.1



