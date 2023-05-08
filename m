Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58460168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA17C4339B;
	Mon,  8 May 2023 09:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539458;
	bh=vXT5zHw0jD8awhq1OZ+fdrHpwm15x1XkfNvwelBJ68s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tA2dvuVDWfIe1nmIKCajP7tGvZrUw5/S6MiwyFj9ckWpEz5NwNLGZmQNqVxsdJBSG
	 fewL7JNAZiUhH/e2iX7rPfkY3BR5ppzhdZTDCfiGUy1ssQk5GRVpFcF/PJ5dTMC3Cx
	 Z8Gg1jh01TMuQ6a3QnJg0J//SmtcmAtwsC7Selk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.1 023/611] arm64: Stash shadow stack pointer in the task struct on interrupt
Date: Mon,  8 May 2023 11:37:45 +0200
Message-Id: <20230508094422.477717680@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/entry.S |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -873,19 +873,19 @@ NOKPROBE(ret_from_fork)
  */
 SYM_FUNC_START(call_on_irq_stack)
 #ifdef CONFIG_SHADOW_CALL_STACK
-	stp	scs_sp, xzr, [sp, #-16]!
+	get_current_task x16
+	scs_save x16
 	ldr_this_cpu scs_sp, irq_shadow_call_stack_ptr, x17
 #endif
+
 	/* Create a frame record to save our LR and SP (implicit in FP) */
 	stp	x29, x30, [sp, #-16]!
 	mov	x29, sp
 
 	ldr_this_cpu x16, irq_stack_ptr, x17
-	mov	x15, #IRQ_STACK_SIZE
-	add	x16, x16, x15
 
 	/* Move to the new stack and call the function there */
-	mov	sp, x16
+	add	sp, x16, #IRQ_STACK_SIZE
 	blr	x1
 
 	/*
@@ -894,9 +894,7 @@ SYM_FUNC_START(call_on_irq_stack)
 	 */
 	mov	sp, x29
 	ldp	x29, x30, [sp], #16
-#ifdef CONFIG_SHADOW_CALL_STACK
-	ldp	scs_sp, xzr, [sp], #16
-#endif
+	scs_load_current
 	ret
 SYM_FUNC_END(call_on_irq_stack)
 NOKPROBE(call_on_irq_stack)


