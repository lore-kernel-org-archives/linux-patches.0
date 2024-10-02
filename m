Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4975E1D1F54;
	Wed,  2 Oct 2024 14:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877893; cv=none; b=TiX5bm7SoFlvcR4VTJ6rYBgFgKoTpNKI8yyZjoLODlkKBEJz0424Zs9Cw7pt9CtAUxdCxHNod+524h1CQzVi/BV19nzMK8bSbyVGzeucEh922EJCxkAL+WuVjp+58P6Nz7MzyRanPl1kPryw/bLoXOT75gOG6fnMX4fYpXio9qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877893; c=relaxed/simple;
	bh=DSafgbit1CCKfwkEi8Gcqi8vimBC8inm7po8w+3xQqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o73utDBMhJL7Yurrrgkf2kkN23o9K9iLwZ42og/JvVJIhgfbN2i6QL7RzYIpOW3dsgPnQ/L0xrkx4Zp3WHRGee8fM91kMPUAF1t8Ycd6P4Wrr5LSKt73JVmt2Dln8EVRyL8y1Ta81OLLfy57PoAcQqIE+oRK9Fy3mju2kOb6neg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFwRqi1k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFwRqi1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EF1C4CEC2;
	Wed,  2 Oct 2024 14:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877892;
	bh=DSafgbit1CCKfwkEi8Gcqi8vimBC8inm7po8w+3xQqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFwRqi1kv17X1z5u4xuxDTKGRakzvldFOai5giI8/aB9gyc4TRp9sUzMfxT1J8iEJ
	 lHl6n+ImlO5kZi9fJ0SH7Jc+Oaya40Gokg6XuMdD0kwUvmY+L+r+XvDP/XG4k4yR3A
	 fSKP56AMRoNXpH2SUtTYOdw0bHzSpIHgO5iFUgoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Leon Hwang <hffilwlqm@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 229/634] bpf, arm64: Fix tailcall hierarchy
Date: Wed,  2 Oct 2024 14:55:29 +0200
Message-ID: <20241002125820.139560425@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1bf483ec971d9..c4190865f2433 100644
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



