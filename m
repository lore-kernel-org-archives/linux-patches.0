Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E228FBEC
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81B4C433D2;
	Mon, 15 May 2023 17:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172950;
	bh=gFIGOI8Nhr27BglzSZDQ32vVzrm2gVTEEhhpeFQeYUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tKvWJUjKlN5D3gE8zSSCltJP2t/aEBW6a58oTVnO7fbGlQD4Fmmv5QjsQpZGLtwj+
	 xzBABb/YcMiKxhSQ2wx/9qN6HB2ELWmqVs2Jc8giTxjeAtEGeYt8a6Bb1pANnJtJIu
	 yCRHgnsT23jLDDOqDgQ3AfE76A5jNCtZoOzMrKGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.10 290/381] arm64: Stash shadow stack pointer in the task struct on interrupt
Date: Mon, 15 May 2023 18:29:01 +0200
Message-Id: <20230515161749.887679258@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ard Biesheuvel <ardb@kernel.org>

commit 59b37fe52f49955791a460752c37145f1afdcad1 upstream.

Instead of reloading the shadow call stack pointer from the ordinary
stack, which may be vulnerable to the kind of gadget based attacks
shadow call stacks were designed to prevent, let's store a task's shadow
call stack pointer in the task struct when switching to the shadow IRQ
stack.

Given that currently, the task_struct::scs_sp field is only used to
preserve the shadow call stack pointer while a task is scheduled out or
running in user space, reusing this field to preserve and restore it
while running off the IRQ stack must be safe, as those occurrences are
guaranteed to never overlap. (The stack switching logic only switches
stacks when running from the task stack, and so the value being saved
here always corresponds to the task mode shadow stack)

While at it, fold a mov/add/mov sequence into a single add.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20230109174800.3286265-3-ardb@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ardb: v5.10 backport, which doesn't have call_on_irq_stack() yet *]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/entry.S |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -431,9 +431,7 @@ SYM_CODE_END(__swpan_exit_el0)
 
 	.macro	irq_stack_entry
 	mov	x19, sp			// preserve the original sp
-#ifdef CONFIG_SHADOW_CALL_STACK
-	mov	x24, scs_sp		// preserve the original shadow stack
-#endif
+	scs_save tsk			// preserve the original shadow stack
 
 	/*
 	 * Compare sp with the base of the task stack.
@@ -467,9 +465,7 @@ SYM_CODE_END(__swpan_exit_el0)
 	 */
 	.macro	irq_stack_exit
 	mov	sp, x19
-#ifdef CONFIG_SHADOW_CALL_STACK
-	mov	scs_sp, x24
-#endif
+	scs_load_current
 	.endm
 
 /* GPRs used by entry code */


