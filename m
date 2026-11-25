Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617855;
	b=S4GGt9LkUJZgZHSCuw56gV8H1LwjWjQEaaJxPvbilKgN+KjI5x2pL2dOno1QxzNflI5+
	 GzviGj9HEEViAyfOqUUGmfvbcXBjirqSeQ+EMa/qszz1zoHgjp7Vjxq6QeAmDgKtGo0M+
	 esZbnRhh2ZmuLlkuR90GqpLe/+CiCfPuhtvFVqKIK9RzJ3CpCXbbVwrPMirC4ZdpcYOP5
	 57NFcQOmFTnhiQdVdGT1JPiX8Cedbmhcu8wIl5WKDCeeAypyqbjXaO+9NuHetRw6Fcy1/
	 acRgghd3cp6Objv6lJ1An8CUd/ZVj0iEYdYivgOtZCRea5sxAieLLnQYvSAaMhy6vMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rrPSDUD2atyMwksCtELgUcM50c+fvPDWUBaWW1hWiOk=;
	b=EuiE1eANwPzCjrb4AMpzO5OxYFJWspkn78nMdMFMYNnIqVyDLzgGIU3rv2ppzJ7GeIiV
	 HMS1hjiubG0fkkNhz0edR85VR1yMpM658xVLn4rwWRoTYPTEEe9aaX3oFxD0a8WN3yY/x
	 jtyXNp0JaiIFGgddpzo/waCZ9GBCSBnmnCVFeRUKwV2Z5QMwPTCYigqooQp1/HCldDhVE
	 5KA2EvrdwyhUKcU4NbWRkzliW3eoA/7p2cRQOxBTbGMWCMV5J1vU5o2OdSF1wYiUYO7eE
	 gpJZwpS5mVg+VUIJYpnB74nJcSvWeudO3H5oNvsG381plX2jmWtN+pmkkSqSTxJ335w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QB56d6Qp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C02606A31E;
	Wed, 25 Nov 2026 14:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QB56d6Qp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F2D1F000C6;
	Wed, 25 Nov 2026 14:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617854;
	bh=rrPSDUD2atyMwksCtELgUcM50c+fvPDWUBaWW1hWiOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QB56d6QpN2RrRqmx1JO+Agf4SJEUuuQ+DLyi0RjfLdswuChRxxtW/2ijGBjqIt9Xr
	 kUevb3JQivqxNtYjXBSxkrNWZM6WaROSl+VCeKDHPAAoUDB5KR0pm6NlrM9yO/DDI/
	 ZiUUbJ9FclmvvQNiJOZmeCoiYw2AUr4fzPWzFEF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0096/1005] bpf, x86: Fix bpf_throw() in a prog with a private stack
Date: Wed, 25 Nov 2026 15:23:54 +0100
Message-ID: <20261125143823.992436314@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 91068ed2d3ee0713d7566c7977b995f8a0936bea ]

When the main prog has a private stack and the prog calls bpf_throw(), it
returns to the kernel with wrong values in r12, rbx, r13, r14 and r15. The
kernel crashes soon after that, for example:

  BUG: kernel NULL pointer dereference, address: 0000000000000010
  RIP: 0010:__bpf_prog_test_run_raw_tp+0x125/0x380

The main prog of a prog that can throw saves these five registers at its
entry. bpf_throw() walks the stack to the frame of the main prog and
gives the stack pointer of that frame to the exception callback, which
pops the registers from there. In a function with a private stack r9 is
the frame pointer, and the JIT emits 'push r9' in front of every call
and 'pop r9' after it. So the stack pointer that bpf_throw() finds is
8 bytes too low:

  r12
  rbx
  r13
  r14
  r15  <- the callback has to pop from here
  r9   <- rsp of the main prog at the call

r15 gets the address of the private stack and every other register gets
the value of its neighbour.

This happens in tracepoint, raw_tp, perf_event and tracing progs, except
iterators, and in struct_ops progs that ask for a private stack, when
the main prog has more than 48 bytes of stack. The throw can be in the
main prog or in a subprog.

aux->stack_arg_sp_adjust already moves the stack pointer from the
outgoing stack arguments up to the saved registers. Add the 8 bytes of
r9 to it when the main prog has a private stack.

A constant is enough. Calls of helpers, kfuncs and subprogs and callx
all have the push. A prog with tail calls has no private stack, and a
callback cannot throw. Only the frame of the main prog matters: the
frames of subprogs are dropped, with or without a private stack. On
x86-64 a function with stack arguments has no private stack, hence only
one of the two parts is not zero.

The JITed code does not change.

Fixes: 7d1cd70d4b16 ("bpf, x86: Support private stack in jit")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261031050558.2410721-2-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 10f68ee7c9e68..1b56cb973d79e 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1838,8 +1838,13 @@ static int do_jit(struct bpf_verifier_env *env, struct bpf_prog *bpf_prog, int *
 	 * Arg 6 goes into r9 register, not on stack.
 	 */
 	outgoing_rsp = out_stack_arg_cnt > 1 ? (out_stack_arg_cnt - 1) * 8 : 0;
+	/*
+	 * bpf_throw() sees rsp of this frame as it is at a call. The callee-saved
+	 * regs are above the outgoing args, or above r9, which is pushed around
+	 * every call when the stack is private.
+	 */
 	if (bpf_prog->aux->exception_boundary)
-		bpf_prog->aux->stack_arg_sp_adjust = outgoing_rsp;
+		bpf_prog->aux->stack_arg_sp_adjust = outgoing_rsp + (priv_frame_ptr ? 8 : 0);
 	emit_sub_rsp(&prog, outgoing_rsp);
 
 	if (arena_vm_start)
-- 
2.53.0



