Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0CF51C31;
	Mon,  8 Jan 2024 15:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7cqGTqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C497C433C9;
	Mon,  8 Jan 2024 15:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728479;
	bh=kzx6mhRNLL2YCxsrCLtAg6DDjGl4XqhXg4aC+CyoBkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7cqGTqqZbpzDDto6A7HfAmWnITeRQkStPqNevvXp5IlyYs5JdA1tb4zIy82kmwxx
	 N0kiTmsBv4lITEglP8wDBjcGzaPQmWzJL3EcIo1AaMGCOqyZjwwiTIuKYkw/sgTBUC
	 x3d7UP45nj9Yyjny5j/++zNdyl4J8HKP2Nxm0+hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Leon Hwang <hffilwlqm@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/150] bpf, x64: Fix tailcall infinite loop
Date: Mon,  8 Jan 2024 16:35:11 +0100
Message-ID: <20240108153513.996432649@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <hffilwlqm@gmail.com>

[ Upstream commit 2b5dcb31a19a2e0acd869b12c9db9b2d696ef544 ]

>From commit ebf7d1f508a73871 ("bpf, x64: rework pro/epilogue and tailcall
handling in JIT"), the tailcall on x64 works better than before.

>From commit e411901c0b775a3a ("bpf: allow for tailcalls in BPF subprograms
for x64 JIT"), tailcall is able to run in BPF subprograms on x64.

>From commit 5b92a28aae4dd0f8 ("bpf: Support attaching tracing BPF program
to other BPF programs"), BPF program is able to trace other BPF programs.

How about combining them all together?

1. FENTRY/FEXIT on a BPF subprogram.
2. A tailcall runs in the BPF subprogram.
3. The tailcall calls the subprogram's caller.

As a result, a tailcall infinite loop comes up. And the loop would halt
the machine.

As we know, in tail call context, the tail_call_cnt propagates by stack
and rax register between BPF subprograms. So do in trampolines.

Fixes: ebf7d1f508a7 ("bpf, x64: rework pro/epilogue and tailcall handling in JIT")
Fixes: e411901c0b77 ("bpf: allow for tailcalls in BPF subprograms for x64 JIT")
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Leon Hwang <hffilwlqm@gmail.com>
Link: https://lore.kernel.org/r/20230912150442.2009-3-hffilwlqm@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 28 ++++++++++++++++++++++------
 include/linux/bpf.h         |  5 +++++
 kernel/bpf/trampoline.c     |  4 ++--
 kernel/bpf/verifier.c       |  3 +++
 4 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 4686c1d9d0cfd..e6a031f8dd2e9 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -893,6 +893,10 @@ static void emit_nops(u8 **pprog, int len)
 
 #define INSN_SZ_DIFF (((addrs[i] - addrs[i - 1]) - (prog - temp)))
 
+/* mov rax, qword ptr [rbp - rounded_stack_depth - 8] */
+#define RESTORE_TAIL_CALL_CNT(stack)				\
+	EMIT3_off32(0x48, 0x8B, 0x85, -round_up(stack, 8) - 8)
+
 static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image, u8 *rw_image,
 		  int oldproglen, struct jit_context *ctx, bool jmp_padding)
 {
@@ -1436,9 +1440,7 @@ st:			if (is_imm8(insn->off))
 		case BPF_JMP | BPF_CALL:
 			func = (u8 *) __bpf_call_base + imm32;
 			if (tail_call_reachable) {
-				/* mov rax, qword ptr [rbp - rounded_stack_depth - 8] */
-				EMIT3_off32(0x48, 0x8B, 0x85,
-					    -round_up(bpf_prog->aux->stack_depth, 8) - 8);
+				RESTORE_TAIL_CALL_CNT(bpf_prog->aux->stack_depth);
 				if (!imm32 || emit_call(&prog, func, image + addrs[i - 1] + 7))
 					return -EINVAL;
 			} else {
@@ -2070,6 +2072,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	 * RBP - ip_off    [ traced function ]  BPF_TRAMP_F_IP_ARG flag
 	 *
 	 * RBP - run_ctx_off [ bpf_tramp_run_ctx ]
+	 * RSP                 [ tail_call_cnt ] BPF_TRAMP_F_TAIL_CALL_CTX
 	 */
 
 	/* room for return value of orig_call or fentry prog */
@@ -2106,6 +2109,8 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	EMIT1(0x55);		 /* push rbp */
 	EMIT3(0x48, 0x89, 0xE5); /* mov rbp, rsp */
 	EMIT4(0x48, 0x83, 0xEC, stack_size); /* sub rsp, stack_size */
+	if (flags & BPF_TRAMP_F_TAIL_CALL_CTX)
+		EMIT1(0x50);		/* push rax */
 	EMIT1(0x53);		 /* push rbx */
 
 	/* Store number of argument registers of the traced function:
@@ -2156,9 +2161,15 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
 		restore_regs(m, &prog, nr_args, regs_off);
 
+		if (flags & BPF_TRAMP_F_TAIL_CALL_CTX)
+			/* Before calling the original function, restore the
+			 * tail_call_cnt from stack to rax.
+			 */
+			RESTORE_TAIL_CALL_CNT(stack_size);
+
 		if (flags & BPF_TRAMP_F_ORIG_STACK) {
-			emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
-			EMIT2(0xff, 0xd0); /* call *rax */
+			emit_ldx(&prog, BPF_DW, BPF_REG_6, BPF_REG_FP, 8);
+			EMIT2(0xff, 0xd3); /* call *rbx */
 		} else {
 			/* call original function */
 			if (emit_call(&prog, orig_call, prog)) {
@@ -2209,7 +2220,12 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 			ret = -EINVAL;
 			goto cleanup;
 		}
-	}
+	} else if (flags & BPF_TRAMP_F_TAIL_CALL_CTX)
+		/* Before running the original function, restore the
+		 * tail_call_cnt from stack to rax.
+		 */
+		RESTORE_TAIL_CALL_CNT(stack_size);
+
 	/* restore return value of orig_call or fentry prog back into RAX */
 	if (save_ret)
 		emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, -8);
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3ce9e39ecdb85..619fcba84be22 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -825,6 +825,11 @@ struct btf_func_model {
  */
 #define BPF_TRAMP_F_SHARE_IPMODIFY	BIT(6)
 
+/* Indicate that current trampoline is in a tail call context. Then, it has to
+ * cache and restore tail_call_cnt to avoid infinite tail call loop.
+ */
+#define BPF_TRAMP_F_TAIL_CALL_CTX	BIT(7)
+
 /* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is ~50
  * bytes on x86.
  */
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index c4381dfcd6b09..748ac86169941 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -443,8 +443,8 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mut
 		goto out;
 	}
 
-	/* clear all bits except SHARE_IPMODIFY */
-	tr->flags &= BPF_TRAMP_F_SHARE_IPMODIFY;
+	/* clear all bits except SHARE_IPMODIFY and TAIL_CALL_CTX */
+	tr->flags &= (BPF_TRAMP_F_SHARE_IPMODIFY | BPF_TRAMP_F_TAIL_CALL_CTX);
 
 	if (tlinks[BPF_TRAMP_FEXIT].nr_links ||
 	    tlinks[BPF_TRAMP_MODIFY_RETURN].nr_links) {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 12d360d80c149..ee6e811b43158 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15442,6 +15442,9 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	if (!tr)
 		return -ENOMEM;
 
+	if (tgt_prog && tgt_prog->aux->tail_call_reachable)
+		tr->flags = BPF_TRAMP_F_TAIL_CALL_CTX;
+
 	prog->aux->dst_trampoline = tr;
 	return 0;
 }
-- 
2.43.0



