Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452F7569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BA6C433D2;
	Sun, 28 May 2023 19:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302107;
	bh=j5vvx8VTbcx7YDeHezKVoK1v+mS/DTAgrOeEYFBUoY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N92em4+akuwDmzpH8vspHhV30g3kAWDwjF2C9kLGW1xTqoUo/V4Tb1yt+NSeb0Uzs
	 HyJkeDY66cfEqclIFih3TpYgKBgFCymRDukKso99Yr8CEbUqxMBs1MeGut4ipIVrnR
	 XukHHE6rU9DS5PmWCfsHIYoBNfQrUKFog7m8Vq8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vernon Lovejoy <vlovejoy@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH 5.4 156/161] x86/show_trace_log_lvl: Ensure stack pointer is aligned, again
Date: Sun, 28 May 2023 20:11:20 +0100
Message-Id: <20230528190841.797032591@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vernon Lovejoy <vlovejoy@redhat.com>

commit 2e4be0d011f21593c6b316806779ba1eba2cd7e0 upstream.

The commit e335bb51cc15 ("x86/unwind: Ensure stack pointer is aligned")
tried to align the stack pointer in show_trace_log_lvl(), otherwise the
"stack < stack_info.end" check can't guarantee that the last read does
not go past the end of the stack.

However, we have the same problem with the initial value of the stack
pointer, it can also be unaligned. So without this patch this trivial
kernel module

	#include <linux/module.h>

	static int init(void)
	{
		asm volatile("sub    $0x4,%rsp");
		dump_stack();
		asm volatile("add    $0x4,%rsp");

		return -EAGAIN;
	}

	module_init(init);
	MODULE_LICENSE("GPL");

crashes the kernel.

Fixes: e335bb51cc15 ("x86/unwind: Ensure stack pointer is aligned")
Signed-off-by: Vernon Lovejoy <vlovejoy@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/20230512104232.GA10227@redhat.com
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/dumpstack.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -171,7 +171,6 @@ void show_trace_log_lvl(struct task_stru
 	printk("%sCall Trace:\n", log_lvl);
 
 	unwind_start(&state, task, regs, stack);
-	stack = stack ? : get_stack_pointer(task, regs);
 	regs = unwind_get_entry_regs(&state, &partial);
 
 	/*
@@ -190,9 +189,13 @@ void show_trace_log_lvl(struct task_stru
 	 * - hardirq stack
 	 * - entry stack
 	 */
-	for ( ; stack; stack = PTR_ALIGN(stack_info.next_sp, sizeof(long))) {
+	for (stack = stack ?: get_stack_pointer(task, regs);
+	     stack;
+	     stack = stack_info.next_sp) {
 		const char *stack_name;
 
+		stack = PTR_ALIGN(stack, sizeof(long));
+
 		if (get_stack_info(stack, task, &stack_info, &visit_mask)) {
 			/*
 			 * We weren't on a valid stack.  It's possible that


