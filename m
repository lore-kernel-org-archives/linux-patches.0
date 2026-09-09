Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8138F577E2E;
	Wed,  9 Sep 2026 14:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963994; cv=none; b=sUYKdgLmoEiQy7eA5C6/isZRFF4B7S8HK/3SFkh9myyf0IK6n2C0g97tE2IE58DysDRAcv9B5+WbxfYJgc3PmNNs/CEKVvRc9VK3WW7lIxCbXY2m1alhv+6p3vysnJLYRlfKZUFOt5EcS+0mHY6r1shr4s+d5kYxnVU0LGKV3H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963994; c=relaxed/simple;
	bh=XHFIxjKw2AHRVnExUTQV9Frigd3nicVH18b5mCIzlf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwI4z098Jbt13GmXd6MGl38bj5GnKuMW+ozRF1gUBi80Iu7y3cN1yk2cQiPOxyIvNpSU+jiFJiUYtU6cIjGWxW5nB9Cg62ndXxjXZPWaEFyeNA61qomx56W2OHVFmyVG/dOz5jd/vo+v/mrG1ytcB89PSSgthnZGfA03JV12iW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZbvEEpWc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZbvEEpWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98671F00A3A;
	Wed,  9 Sep 2026 14:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963993;
	bh=lw0ZUXjFZ0PvICG3WKhJkFKEsYpeuokpxYhNJz598ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZbvEEpWcj3KkXvrqmGrfsqOLKwlDC67bvD1oTrTV2BcYx56OJqZ8EMgjgpxonY/yE
	 HjQLMOkUwYJTxqamshZSiPZ9F/NEUcmn5Xqpqkg8CLT8tTYuIdFJs0isWUzAzAxWx1
	 SZcVWM1dDHu11e7XEFbmgoUqa+WcAeZpM8XiVt1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 268/583] LoongArch: BPF: Refactor jump offset calculation in tail call
Date: Wed,  9 Sep 2026 15:39:13 +0200
Message-ID: <20260909134247.380469642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit 37d545d12f21c4d50612ecaebd7ae1e5bf91b2d8 upstream.

The old macro-based jmp_offset calculation derives the jump distance
from a stale prior-pass code stride, which can lead to wrong branch
offsets and soft lockups under extra JIT passes.

Fix this by calculating the offset directly on the absolute target:
"ctx->offset[insn + 1] - ctx->idx".

To avoid a false 16-bit range check abort during size estimation, add
a "ctx->image == NULL" guard to inject a safe dummy offset.

Cc: stable@vger.kernel.org
Fixes: cd39d9e6b7e4 ("LoongArch: BPF: Fix jump offset calculation in tailcall")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -266,17 +266,13 @@ bool bpf_jit_supports_far_kfunc_call(voi
 
 static int emit_bpf_tail_call(struct jit_ctx *ctx, int insn)
 {
-	int off, tc_ninsn = 0;
+	int off, jmp_offset;
 	int tcc_ptr_off = BPF_TAIL_CALL_CNT_PTR_STACK_OFF(ctx->stack_size);
 	u8 a1 = LOONGARCH_GPR_A1;
 	u8 a2 = LOONGARCH_GPR_A2;
 	u8 t1 = LOONGARCH_GPR_T1;
 	u8 t2 = LOONGARCH_GPR_T2;
 	u8 t3 = LOONGARCH_GPR_T3;
-	const int idx0 = ctx->idx;
-
-#define cur_offset (ctx->idx - idx0)
-#define jmp_offset (tc_ninsn - (cur_offset))
 
 	/*
 	 * a0: &ctx
@@ -286,12 +282,12 @@ static int emit_bpf_tail_call(struct jit
 	 * if (index >= array->map.max_entries)
 	 *	 goto out;
 	 */
-	tc_ninsn = insn ? ctx->offset[insn+1] - ctx->offset[insn] : ctx->offset[0];
 	emit_zext_32(ctx, a2, true);
 
 	off = offsetof(struct bpf_array, map.max_entries);
 	emit_insn(ctx, ldwu, t1, a1, off);
 	/* bgeu $a2, $t1, jmp_offset */
+	jmp_offset = ctx->image ? (ctx->offset[insn + 1] - ctx->idx) : 0;
 	if (emit_tailcall_jmp(ctx, BPF_JGE, a2, t1, jmp_offset) < 0)
 		goto toofar;
 
@@ -302,6 +298,7 @@ static int emit_bpf_tail_call(struct jit
 	emit_insn(ctx, ldd, REG_TCC, LOONGARCH_GPR_SP, tcc_ptr_off);
 	emit_insn(ctx, ldd, t3, REG_TCC, 0);
 	emit_insn(ctx, addid, t2, LOONGARCH_GPR_ZERO, MAX_TAIL_CALL_CNT);
+	jmp_offset = ctx->image ? (ctx->offset[insn + 1] - ctx->idx) : 0;
 	if (emit_tailcall_jmp(ctx, BPF_JSGE, t3, t2, jmp_offset) < 0)
 		goto toofar;
 
@@ -316,6 +313,7 @@ static int emit_bpf_tail_call(struct jit
 	off = offsetof(struct bpf_array, ptrs);
 	emit_insn(ctx, ldd, t2, t2, off);
 	/* beq $t2, $zero, jmp_offset */
+	jmp_offset = ctx->image ? (ctx->offset[insn + 1] - ctx->idx) : 0;
 	if (emit_tailcall_jmp(ctx, BPF_JEQ, t2, LOONGARCH_GPR_ZERO, jmp_offset) < 0)
 		goto toofar;
 
@@ -331,8 +329,6 @@ static int emit_bpf_tail_call(struct jit
 toofar:
 	pr_info_once("tail_call: jump too far\n");
 	return -1;
-#undef cur_offset
-#undef jmp_offset
 }
 
 static void emit_atomic(const struct bpf_insn *insn, struct jit_ctx *ctx)


