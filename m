Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B44531AE6;
	Wed, 23 Sep 2026 14:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174647; cv=none; b=VczlCxs3RlF/apofQiEBDNrYo+PHPMxNIehStQuuycV+8EkGQmArCWSqpPeWOcZ9Jnar1WvRG+h9f+8VtJayoX3RK/eeXOEHvfCsoD+ODg9kp+3u55oFW1KDKS7OOQcD9nbyRIT6mxCDdJ2hw6AACaaZdO3q7sR8N43gtJcd61g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174647; c=relaxed/simple;
	bh=tDT4jN1MvKMcuRB9eQQqbjMnfj7kOZruRiqrzEMtmWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvS/39AEjuDi+oSnb2HSeMoVbzaU551AoAKLkoDXoIQLBqt/YTwpnZWxJymdlhe6mBOKaM2SuIstxjNI7ht7So9KiXcV8PTdgl33l3Bb8GMtLrlyx/xBT5ThL6ZSRcns/ZIiBqKknqiQWak1dZzQqEs1ZqxkW5x0opCoX3zpvRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtfOSyl0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtfOSyl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD5F1F000FF;
	Wed, 23 Sep 2026 14:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174646;
	bh=Dm04kzk2tmRcJia220p30Ggpe9GBOWFiVG/WdQFEHtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CtfOSyl0iV77d60rFW3IX7r2Nr06pDcN3wno+ZgkauaXdcdBUYDqq7Bv/Sq8xXtKR
	 t0gZA5n4B3pPGMq0UsoEr0s4sFalwqDwsIHVV4WkP7pglkoFfalsyRLpOIRXj+H9or
	 awVCxEaUYpdDViCtbRS1WdQxw35FFhK42qBHrT44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Jinke Han <jinkehan@didiglobal.com>,
	Ingo Molnar <mingo@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 182/398] x86/kprobes: Fix crash when probing CS CALL instructions
Date: Wed, 23 Sep 2026 16:04:16 +0200
Message-ID: <20260923140648.150856984@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinke Han <jinkehan@didiglobal.com>

[ Upstream commit a5f7a5bb3b7f28ba7e4fa246775b29a0e5537255 ]

When using eBPF to probe CS CALL instructions within a function,
a crash can be triggered.

The eBPF tool probes offset 257 of the __hrtimer_run_queues()
function:

<__hrtimer_run_queues+249>:  nopl   0x0(%rax,%rax,1)
<__hrtimer_run_queues+254>:  mov    %r14,%rdi
<__hrtimer_run_queues+257>:  cs call <__x86_indirect_thunk_r12>
<__hrtimer_run_queues+263>:  mov    %eax,%r12d
<__hrtimer_run_queues+266>:  xchg   %ax,%ax
<__hrtimer_run_queues+268>:  mov    %r13,%rdi

Which triggers this crash:

  BUG: unable to handle page fault for address: 00000000000f41c9
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  PGD 0 P4D 0
  Oops: 0002 [#1] SMP NOPTI
  CPU: 1 PID: 0 Comm: swapper/1 Kdump: loaded Tainted: P
  RIP: 0010:__hrtimer_run_queues+0x106/0x230

Note that __hrtimer_run_queues+0x106 is __hrtimer_run_queues+262, which is
at the 6th byte of the above CS CALL instruction. Since the CS CALL
instruction occupies 6 bytes, the exception occurred in the middle of that
call instruction.

The root cause is that when using eBPF tools to probe in the middle of a
function, a kprobe with INT3 is used as the underlying implementation.

During single-step emulation of the original CALL instruction,
int3_emulate_call() assumes that the probed CALL instruction is 5 bytes
long. However, the actual CS-prefixed CALL instruction occupies 6 bytes,
so it constructs an incorrect exception return address. When the CPU
returns from the kprobe handler, the next instruction to be executed is at
the address of the last byte of that CS CALL instruction. Coincidentally,
starting from that address, the CPU fetches and decodes a completely
different instruction, which ultimately triggers a kernel crash.

Fix the issue by using the actual instruction length obtained from
the instruction decoder when constructing the exception return
address, rather than relying on the hardcoded CALL_INSN_SIZE macro.

[ mingo: Refined the changelog ]

Fixes: 6256e668b7af ("x86/kprobes: Use int3 instead of debug trap for single-step")
Suggested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Jinke Han <jinkehan@didiglobal.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://patch.msgid.link/20260908073742.GA10517@didi-ThinkCentre-M920t-N000
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/text-patching.h | 4 ++--
 arch/x86/kernel/alternative.c        | 6 ++++--
 arch/x86/kernel/kprobes/core.c       | 5 ++---
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index f2d142a0a862e..ea09381070e82 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -164,9 +164,9 @@ unsigned long int3_emulate_pop(struct pt_regs *regs)
 }
 
 static __always_inline
-void int3_emulate_call(struct pt_regs *regs, unsigned long func)
+void int3_emulate_call(struct pt_regs *regs, unsigned long ip, unsigned long func)
 {
-	int3_emulate_push(regs, regs->ip - INT3_INSN_SIZE + CALL_INSN_SIZE);
+	int3_emulate_push(regs, ip);
 	int3_emulate_jmp(regs, func);
 }
 
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 4917d2843feb4..9c980b4f1943b 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -2305,6 +2305,7 @@ int3_exception_notify(struct notifier_block *self, unsigned long val, void *data
 	unsigned long selftest = (unsigned long)&int3_selftest_asm;
 	struct die_args *args = data;
 	struct pt_regs *regs = args->regs;
+	unsigned long ip;
 
 	OPTIMIZER_HIDE_VAR(selftest);
 
@@ -2317,7 +2318,8 @@ int3_exception_notify(struct notifier_block *self, unsigned long val, void *data
 	if (regs->ip - INT3_INSN_SIZE != selftest)
 		return NOTIFY_DONE;
 
-	int3_emulate_call(regs, (unsigned long)&int3_selftest_callee);
+	ip = regs->ip - INT3_INSN_SIZE + CALL_INSN_SIZE;
+	int3_emulate_call(regs, ip, (unsigned long)&int3_selftest_callee);
 	return NOTIFY_STOP;
 }
 
@@ -2889,7 +2891,7 @@ noinstr int smp_text_poke_int3_handler(struct pt_regs *regs)
 		break;
 
 	case CALL_INSN_OPCODE:
-		int3_emulate_call(regs, (long)ip + tpl->disp);
+		int3_emulate_call(regs, (long)ip, (long)ip + tpl->disp);
 		break;
 
 	case JMP32_INSN_OPCODE:
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 3863d7709386f..95ab48b3b0f89 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -511,10 +511,9 @@ NOKPROBE_SYMBOL(kprobe_emulate_ret);
 
 static void kprobe_emulate_call(struct kprobe *p, struct pt_regs *regs)
 {
-	unsigned long func = regs->ip - INT3_INSN_SIZE + p->ainsn.size;
+	unsigned long ip = regs->ip - INT3_INSN_SIZE + p->ainsn.size;
 
-	func += p->ainsn.rel32;
-	int3_emulate_call(regs, func);
+	int3_emulate_call(regs, ip, ip + p->ainsn.rel32);
 }
 NOKPROBE_SYMBOL(kprobe_emulate_call);
 
-- 
2.53.0



