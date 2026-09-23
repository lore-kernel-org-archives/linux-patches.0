Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2708531AE5;
	Wed, 23 Sep 2026 14:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173354; cv=none; b=MDnkzefWX2tC9BvdpT2X+Nhc6dNTM2YSRJ6wewmQmTY7EuCwMhe+s0ql4wsKkk4qBunaWjf8Tmi8XAiCmrfYxfYl+fORFtFTINCGmgcfjM8OMA4szjM504xqRWn5RdFihaeQMkBcbfks+7O+23XF1kDr/xU7ClyhhfjcRFw7qZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173354; c=relaxed/simple;
	bh=6BWPGHxzw3zJXDDM17TM4z/f2fRmueg54fjqpj4F77s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l79VPW4dVeolKtCkgDJOoFOcBJevGzi+4QQ1TqkMqHvgRqwEO/aCOfloe3KcKrmxmAnXumwc0VEQY14m/6dVeRmgcWXF2hO1lVyr56vV4cg4nSLeJaEdv+ODjMRZMS34MR07AEeolTyF9ttixQ5A76AXG5qSgjjziILMHWqBH34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLxxDXuK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLxxDXuK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CDAD1F000FF;
	Wed, 23 Sep 2026 14:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173352;
	bh=qTgoNjRVXpbLGsbaH5Jw50hKTeHnTnEZAWE+uv/Xmmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bLxxDXuKR1LzHc9Phh3Y/gGS/qVkfIEQ50DDsfoQOmzNHj/pqYoaTUbU8Ky7hTENy
	 iPHWEde+0wW1gaWQFpZ5cQ+o4HzIVK/nEJGsl2KHJ1igqK9clUEoTof7AMReSUr0fU
	 9m9ZRkTVlpFHzGrwDSMLwYqqghg4NnNFpO9K4yPU=
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
Subject: [PATCH 7.2 218/438] x86/kprobes: Fix crash when probing CS CALL instructions
Date: Wed, 23 Sep 2026 16:03:59 +0200
Message-ID: <20260923140650.414147755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index b0b576ab2fa6e..f24d7e911d3e5 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -2319,6 +2319,7 @@ int3_exception_notify(struct notifier_block *self, unsigned long val, void *data
 	unsigned long selftest = (unsigned long)&int3_selftest_asm;
 	struct die_args *args = data;
 	struct pt_regs *regs = args->regs;
+	unsigned long ip;
 
 	OPTIMIZER_HIDE_VAR(selftest);
 
@@ -2331,7 +2332,8 @@ int3_exception_notify(struct notifier_block *self, unsigned long val, void *data
 	if (regs->ip - INT3_INSN_SIZE != selftest)
 		return NOTIFY_DONE;
 
-	int3_emulate_call(regs, (unsigned long)&int3_selftest_callee);
+	ip = regs->ip - INT3_INSN_SIZE + CALL_INSN_SIZE;
+	int3_emulate_call(regs, ip, (unsigned long)&int3_selftest_callee);
 	return NOTIFY_STOP;
 }
 
@@ -2929,7 +2931,7 @@ noinstr int smp_text_poke_int3_handler(struct pt_regs *regs)
 		break;
 
 	case CALL_INSN_OPCODE:
-		int3_emulate_call(regs, (long)ip + tpl->disp);
+		int3_emulate_call(regs, (long)ip, (long)ip + tpl->disp);
 		break;
 
 	case JMP32_INSN_OPCODE:
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index c1fac3a9fecc2..03d2710ec3021 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -510,10 +510,9 @@ NOKPROBE_SYMBOL(kprobe_emulate_ret);
 
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



