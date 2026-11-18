Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020861;
	b=UkA+/klyUtjl+dEFBj44ojmoCIdfOM8U3fIRbZWI5VbdQLnst8umrCfwumfNVyJocFKL
	 MyJRnemCV3OgYPj6O0GZAYZk/ZVm6w0kq/CBHgLJaWhuM/jozqk1NRYrDY2kwFTMcKSJx
	 tfDCNApsr2Y1a1Vr3vxlUM9qua1ahE+o6EEqGDgZEsZU5QCpgRhZutZoNWIEbIJH3LcKd
	 US2fyoK6/qAzw6s/XNuybHzrsOdhd21Zg7qWm1lRaXmRq0C5mBdPsDR4F0omSwHJIT978
	 T625WDhy/sP58Rw3Ny0ZmOCk3LNOhgXxZtAS9XMgYG9B1/9yUO+pgGjThBkg/CUH1Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SEWkwokLMhTtzynUaUOyxWwEyqpyBJzR7nrICGynh30=;
	b=WwqVfC3NeumRcxGkIO80AFXDC6PWPanc9ygj1/8VdPlH1QWlDHKPNGJvRnufFEcxWSg3
	 blUNLII9S5tpbcwB0cHRYm85yD8Bk9WjT8c5RMf4ha8NesnAQ9VwJGeSjCkPSniqzcCXP
	 4184Lw0kjBG4t39vfVt4VSlqA4bSZAj/gXu7Fot0sD4pvKNgX/e3CcDPG1rkZW7+qap9B
	 Ye2ApHYSmoqZ/+dyIl1RvWvkUjiiteWUvzNPv3HzeF+rYnMTNf3RkeEiNm7kQYsqlPD3S
	 dsai3cyzl1uhM+sRNxVPwvdfqj9PMoPu9A5EmjUCZVj66fvGvVYL2Nn57CiLI8oFudg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TZXTwo3f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B823C606B587;
	Wed, 18 Nov 2026 16:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TZXTwo3f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146D31F000C4;
	Wed, 18 Nov 2026 16:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020861;
	bh=SEWkwokLMhTtzynUaUOyxWwEyqpyBJzR7nrICGynh30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZXTwo3fKHKN/VKKa7Ljor8Nn+TCHYBf6CJ9OWhCN2wAORz9w5wdNX2xyGUd5UOtE
	 IQsESDTMFdmo0YgCHqds/FzFqCXKvoRpPbgylosCGzi6CoqEgtA6CylTO9O8loK8Iy
	 2WorPXRodO7u0gWssyZxRZNPDYoWBKd+RLPaWfE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2060/2651] bpf, x86: Pass a trampolines stack arguments by the calling convention
Date: Wed, 18 Nov 2026 15:55:00 +0100
Message-ID: <20261118150400.222951317@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit 9f9c30435ca92cddb37e67cda46ec02e26dd0a07 ]

A trampoline on a function of a program that can tail call keeps the
tail call counter pointer by pushing rax after allocating its frame.
When it calls the original function, for fexit, fmod_ret or fsession,
the push sits between the stack arguments and the return address, which
the x86-64 calling convention does not allow. For example, in

	run() -> call_stack() -> callee_stack(a, b, c, d, e, f, g, h)
	run() -> subprog_tail() -> bpf_tail_call()

callee_stack() is not on the path to the tail call, so the verifier
allows its stack arguments g and h. fexit on it builds, with T the
trampoline's rbp:

	T-120  h                  save_args()
	T-128  g                  save_args(), RSP after sub rsp, 128
	T-136  tail_call_cnt_ptr  push rax, RSP at the call
	T-144  return address     call orig_call

and callee_stack() finds the counter pointer where g belongs, at 8(%rsp)
on entry, and g where h belongs.

Keep the pointer in a slot of the frame instead, so that the stack
arguments sit right above the return address again:

	T-120  tail_call_cnt_ptr  mov [rbp - 120], rax
	T-128  (pad to 16)
	T-136  h                  save_args()
	T-144  g                  save_args(), RSP at the call
	T-152  return address     call orig_call

Fixes: 324c3ca6eed6 ("bpf,x86: Implement JIT support for stack arguments")
Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261016183044.1132751-1-yonghong.song@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 476d77acd031b..10f68ee7c9e68 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -3413,9 +3413,9 @@ static int invoke_bpf_mod_ret(const struct btf_func_model *m, u8 **pprog,
 	return 0;
 }
 
-/* mov rax, qword ptr [rbp - rounded_stack_depth - 8] */
-#define LOAD_TRAMP_TAIL_CALL_CNT_PTR(stack)	\
-	__LOAD_TCC_PTR(-round_up(stack, 8) - 8)
+/* mov rax, qword ptr [rbp - off] */
+#define LOAD_TRAMP_TAIL_CALL_CNT_PTR(off)	\
+	__LOAD_TCC_PTR(-(off))
 
 /* Example:
  * __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev);
@@ -3485,6 +3485,7 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *rw_im
 {
 	int i, ret, nr_regs = m->nr_args, stack_size = 0;
 	int regs_off, func_meta_off, ip_off, run_ctx_off, arg_stack_off, rbx_off;
+	int tcc_off = 0;
 	struct bpf_tramp_nodes *fentry = &tnodes[BPF_TRAMP_FENTRY];
 	struct bpf_tramp_nodes *fexit = &tnodes[BPF_TRAMP_FEXIT];
 	struct bpf_tramp_nodes *fmod_ret = &tnodes[BPF_TRAMP_MODIFY_RETURN];
@@ -3535,11 +3536,12 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *rw_im
 	 *
 	 * RBP - run_ctx_off [ bpf_tramp_run_ctx ]
 	 *
+	 * RBP - tcc_off   [ tail_call_cnt_ptr ]  BPF_TRAMP_F_TAIL_CALL_CTX
+	 *
 	 *                     [ stack_argN ]  BPF_TRAMP_F_CALL_ORIG
 	 *                     [ ...        ]
 	 *                     [ stack_arg2 ]
 	 * RBP - arg_stack_off [ stack_arg1 ]
-	 * RSP                 [ tail_call_cnt_ptr ] BPF_TRAMP_F_TAIL_CALL_CTX
 	 */
 
 	/* room for return value of orig_call or fentry prog */
@@ -3570,6 +3572,11 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *rw_im
 	stack_size += (sizeof(struct bpf_tramp_run_ctx) + 7) & ~0x7;
 	run_ctx_off = stack_size;
 
+	if (flags & BPF_TRAMP_F_TAIL_CALL_CTX) {
+		stack_size += 8;
+		tcc_off = stack_size;
+	}
+
 	if (nr_regs > 6 && (flags & BPF_TRAMP_F_CALL_ORIG)) {
 		/* the space that used to pass arguments on-stack */
 		stack_size += (nr_regs - get_nr_used_regs(m)) * 8;
@@ -3627,7 +3634,8 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *rw_im
 		EMIT4(0x48, 0x83, 0xEC, stack_size);
 	}
 	if (flags & BPF_TRAMP_F_TAIL_CALL_CTX)
-		EMIT1(0x50);		/* push rax */
+		/* mov QWORD PTR [rbp - tcc_off], rax */
+		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -tcc_off);
 	/* mov QWORD PTR [rbp - rbx_off], rbx */
 	emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_6, -rbx_off);
 
@@ -3688,7 +3696,7 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *rw_im
 			/* Before calling the original function, load the
 			 * tail_call_cnt_ptr from stack to rax.
 			 */
-			LOAD_TRAMP_TAIL_CALL_CNT_PTR(stack_size);
+			LOAD_TRAMP_TAIL_CALL_CNT_PTR(tcc_off);
 		}
 
 		if (flags & BPF_TRAMP_F_ORIG_STACK) {
@@ -3752,7 +3760,7 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *rw_im
 		/* Before running the original function, load the
 		 * tail_call_cnt_ptr from stack to rax.
 		 */
-		LOAD_TRAMP_TAIL_CALL_CNT_PTR(stack_size);
+		LOAD_TRAMP_TAIL_CALL_CNT_PTR(tcc_off);
 	}
 
 	/* restore return value of orig_call or fentry prog back into RAX */
-- 
2.53.0



