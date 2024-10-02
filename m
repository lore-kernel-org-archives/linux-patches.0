Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861691D07BA;
	Wed,  2 Oct 2024 13:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875969; cv=none; b=uHoE3oem3xFG+teSxJ3czFzKlSxg+cCTtvS3HZAXNMbJe7XnxzkQWAhsoCbaCijkid90rD4bGZLM9OwiMam+K25I/u9O5+kTkAJ3zVFv44JrlPnwISfvwNLX+jnT+K+1lHHM+8AVDVVZN12TDoy26pBDFqnfx5G8K7cN7d37OV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875969; c=relaxed/simple;
	bh=F0okHFGgZo65OM4RR85yxZt+xjnkULxNOegIXg87Tsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQrgt0eaLUtQbea/zfbhYD7wpZB+JoDXrb46JrBIJTAgkGkRxhfU+EeiOt/z5lAaXMajA0HPUSli3yQeym12seJjSVO1sPC+lePjdwvfdIy2B7c/gbIeLtjd8O7BKhmEZV6+4BKZyqCti8gIpAbfvnpF0/fXgf6d1gIhAb04rJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTmBUBM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTmBUBM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B25C4CECF;
	Wed,  2 Oct 2024 13:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875969;
	bh=F0okHFGgZo65OM4RR85yxZt+xjnkULxNOegIXg87Tsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTmBUBM58fwV2hRoBkVi90NqyUGBMF5QAtoMuxX2b5f42wo0TPZjvU1NeRIDB2Enr
	 3C1sGsbGQ+u+LlSHKR8/Zm0itmjjnPcSvOC6VNie4fqrWiOzyWKytXfrhhQolnrgLu
	 TUYOR8mSNl35cCdnQGWtczC2ek0yol6BSOSZuwZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Leon Hwang <hffilwlqm@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 256/695] bpf, arm64: Fix tailcall hierarchy
Date: Wed,  2 Oct 2024 14:54:14 +0200
Message-ID: <20241002125832.666485343@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <hffilwlqm@gmail.com>

[ Upstream commit 66ff4d61dc124eafe9efaeaef696a09b7f236da2 ]

This patch fixes a tailcall issue caused by abusing the tailcall in
bpf2bpf feature on arm64 like the way of "bpf, x64: Fix tailcall
hierarchy".

On arm64, when a tail call happens, it uses tail_call_cnt_ptr to
increment tail_call_cnt, too.

At the prologue of main prog, it has to initialize tail_call_cnt and
prepare tail_call_cnt_ptr.

At the prologue of subprog, it pushes x26 register twice, and does not
initialize tail_call_cnt.

At the epilogue, it pops x26 twice, no matter whether it is main prog or
subprog.

Fixes: d4609a5d8c70 ("bpf, arm64: Keep tail call count across bpf2bpf calls")
Acked-by: Puranjay Mohan <puranjay@kernel.org>
Signed-off-by: Leon Hwang <hffilwlqm@gmail.com>
Link: https://lore.kernel.org/r/20240714123902.32305-3-hffilwlqm@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 57 +++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index dd0bb069df4bb..59e05a7aea56a 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -26,7 +26,7 @@
 
 #define TMP_REG_1 (MAX_BPF_JIT_REG + 0)
 #define TMP_REG_2 (MAX_BPF_JIT_REG + 1)
-#define TCALL_CNT (MAX_BPF_JIT_REG + 2)
+#define TCCNT_PTR (MAX_BPF_JIT_REG + 2)
 #define TMP_REG_3 (MAX_BPF_JIT_REG + 3)
 #define FP_BOTTOM (MAX_BPF_JIT_REG + 4)
 #define ARENA_VM_START (MAX_BPF_JIT_REG + 5)
@@ -63,8 +63,8 @@ static const int bpf2a64[] = {
 	[TMP_REG_1] = A64_R(10),
 	[TMP_REG_2] = A64_R(11),
 	[TMP_REG_3] = A64_R(12),
-	/* tail_call_cnt */
-	[TCALL_CNT] = A64_R(26),
+	/* tail_call_cnt_ptr */
+	[TCCNT_PTR] = A64_R(26),
 	/* temporary register for blinding constants */
 	[BPF_REG_AX] = A64_R(9),
 	[FP_BOTTOM] = A64_R(27),
@@ -282,13 +282,35 @@ static bool is_lsi_offset(int offset, int scale)
  *      mov x29, sp
  *      stp x19, x20, [sp, #-16]!
  *      stp x21, x22, [sp, #-16]!
- *      stp x25, x26, [sp, #-16]!
+ *      stp x26, x25, [sp, #-16]!
+ *      stp x26, x25, [sp, #-16]!
  *      stp x27, x28, [sp, #-16]!
  *      mov x25, sp
  *      mov tcc, #0
  *      // PROLOGUE_OFFSET
  */
 
+static void prepare_bpf_tail_call_cnt(struct jit_ctx *ctx)
+{
+	const struct bpf_prog *prog = ctx->prog;
+	const bool is_main_prog = !bpf_is_subprog(prog);
+	const u8 ptr = bpf2a64[TCCNT_PTR];
+	const u8 fp = bpf2a64[BPF_REG_FP];
+	const u8 tcc = ptr;
+
+	emit(A64_PUSH(ptr, fp, A64_SP), ctx);
+	if (is_main_prog) {
+		/* Initialize tail_call_cnt. */
+		emit(A64_MOVZ(1, tcc, 0, 0), ctx);
+		emit(A64_PUSH(tcc, fp, A64_SP), ctx);
+		emit(A64_MOV(1, ptr, A64_SP), ctx);
+	} else {
+		emit(A64_PUSH(ptr, fp, A64_SP), ctx);
+		emit(A64_NOP, ctx);
+		emit(A64_NOP, ctx);
+	}
+}
+
 #define BTI_INSNS (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL) ? 1 : 0)
 #define PAC_INSNS (IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL) ? 1 : 0)
 
@@ -296,7 +318,7 @@ static bool is_lsi_offset(int offset, int scale)
 #define POKE_OFFSET (BTI_INSNS + 1)
 
 /* Tail call offset to jump into */
-#define PROLOGUE_OFFSET (BTI_INSNS + 2 + PAC_INSNS + 8)
+#define PROLOGUE_OFFSET (BTI_INSNS + 2 + PAC_INSNS + 10)
 
 static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf,
 			  bool is_exception_cb, u64 arena_vm_start)
@@ -308,7 +330,6 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf,
 	const u8 r8 = bpf2a64[BPF_REG_8];
 	const u8 r9 = bpf2a64[BPF_REG_9];
 	const u8 fp = bpf2a64[BPF_REG_FP];
-	const u8 tcc = bpf2a64[TCALL_CNT];
 	const u8 fpb = bpf2a64[FP_BOTTOM];
 	const u8 arena_vm_base = bpf2a64[ARENA_VM_START];
 	const int idx0 = ctx->idx;
@@ -359,7 +380,7 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf,
 		/* Save callee-saved registers */
 		emit(A64_PUSH(r6, r7, A64_SP), ctx);
 		emit(A64_PUSH(r8, r9, A64_SP), ctx);
-		emit(A64_PUSH(fp, tcc, A64_SP), ctx);
+		prepare_bpf_tail_call_cnt(ctx);
 		emit(A64_PUSH(fpb, A64_R(28), A64_SP), ctx);
 	} else {
 		/*
@@ -372,18 +393,15 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf,
 		 * callee-saved registers. The exception callback will not push
 		 * anything and re-use the main program's stack.
 		 *
-		 * 10 registers are on the stack
+		 * 12 registers are on the stack
 		 */
-		emit(A64_SUB_I(1, A64_SP, A64_FP, 80), ctx);
+		emit(A64_SUB_I(1, A64_SP, A64_FP, 96), ctx);
 	}
 
 	/* Set up BPF prog stack base register */
 	emit(A64_MOV(1, fp, A64_SP), ctx);
 
 	if (!ebpf_from_cbpf && is_main_prog) {
-		/* Initialize tail_call_cnt */
-		emit(A64_MOVZ(1, tcc, 0, 0), ctx);
-
 		cur_offset = ctx->idx - idx0;
 		if (cur_offset != PROLOGUE_OFFSET) {
 			pr_err_once("PROLOGUE_OFFSET = %d, expected %d!\n",
@@ -432,7 +450,8 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx)
 
 	const u8 tmp = bpf2a64[TMP_REG_1];
 	const u8 prg = bpf2a64[TMP_REG_2];
-	const u8 tcc = bpf2a64[TCALL_CNT];
+	const u8 tcc = bpf2a64[TMP_REG_3];
+	const u8 ptr = bpf2a64[TCCNT_PTR];
 	const int idx0 = ctx->idx;
 #define cur_offset (ctx->idx - idx0)
 #define jmp_offset (out_offset - (cur_offset))
@@ -449,11 +468,12 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx)
 	emit(A64_B_(A64_COND_CS, jmp_offset), ctx);
 
 	/*
-	 * if (tail_call_cnt >= MAX_TAIL_CALL_CNT)
+	 * if ((*tail_call_cnt_ptr) >= MAX_TAIL_CALL_CNT)
 	 *     goto out;
-	 * tail_call_cnt++;
+	 * (*tail_call_cnt_ptr)++;
 	 */
 	emit_a64_mov_i64(tmp, MAX_TAIL_CALL_CNT, ctx);
+	emit(A64_LDR64I(tcc, ptr, 0), ctx);
 	emit(A64_CMP(1, tcc, tmp), ctx);
 	emit(A64_B_(A64_COND_CS, jmp_offset), ctx);
 	emit(A64_ADD_I(1, tcc, tcc, 1), ctx);
@@ -469,6 +489,9 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx)
 	emit(A64_LDR64(prg, tmp, prg), ctx);
 	emit(A64_CBZ(1, prg, jmp_offset), ctx);
 
+	/* Update tail_call_cnt if the slot is populated. */
+	emit(A64_STR64I(tcc, ptr, 0), ctx);
+
 	/* goto *(prog->bpf_func + prologue_offset); */
 	off = offsetof(struct bpf_prog, bpf_func);
 	emit_a64_mov_i64(tmp, off, ctx);
@@ -721,6 +744,7 @@ static void build_epilogue(struct jit_ctx *ctx, bool is_exception_cb)
 	const u8 r8 = bpf2a64[BPF_REG_8];
 	const u8 r9 = bpf2a64[BPF_REG_9];
 	const u8 fp = bpf2a64[BPF_REG_FP];
+	const u8 ptr = bpf2a64[TCCNT_PTR];
 	const u8 fpb = bpf2a64[FP_BOTTOM];
 
 	/* We're done with BPF stack */
@@ -738,7 +762,8 @@ static void build_epilogue(struct jit_ctx *ctx, bool is_exception_cb)
 	/* Restore x27 and x28 */
 	emit(A64_POP(fpb, A64_R(28), A64_SP), ctx);
 	/* Restore fs (x25) and x26 */
-	emit(A64_POP(fp, A64_R(26), A64_SP), ctx);
+	emit(A64_POP(ptr, fp, A64_SP), ctx);
+	emit(A64_POP(ptr, fp, A64_SP), ctx);
 
 	/* Restore callee-saved register */
 	emit(A64_POP(r8, r9, A64_SP), ctx);
-- 
2.43.0



