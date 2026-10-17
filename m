Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A69537BE64;
	Sat, 17 Oct 2026 16:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254877; cv=none; b=Ivl0++p+mTadb4FYfgAdDqQ1u+dW86V7X+3v7PeOY/uIoh0Nf2I+c75jw6Yb6Xmxp6bPP+TWJQNKmHp9RpGp5vG/wWYOSawrg2Fkz1zaUtZUfBIr5+ZmJwBf0f3cN33Dvta2Vp7+rXbAXJQ9LTD09x5Awoxyqd0TAsnVqDUpXhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254877; c=relaxed/simple;
	bh=v2XS7Z4fRar9sTJXWhXzJgBdpIeUngRiet/YkcmuGpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nevLjipjnbDlEGI24yM4S7P/peXXwFQoylDpXogDwwi7qAYQVe9EqYSrEwLnpYK8+NOsiumRWx1YWiqUGgQbQxWNr1TpKJzpAw15s/DX9diMNuhXut6cKwj58MlplT0jwoJnTGbUx3NLtrhXkCSCp64ALvtD641aYAIQCTQ+u8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SlJOkSIw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlJOkSIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4D41F000C5;
	Sat, 17 Oct 2026 16:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254876;
	bh=FmfX7eSI7pj3srHTeB/Vx3rXd73aszb++ZgwCT+EJ60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SlJOkSIwUz2aOz2+s6/JfhoURSe0oHIWh/xzFKYqry1GUissJ/LLSkazNxsns4Gs8
	 1M9QDZpSMJrbpbB64SK73CpritolxmXQiNIH1xR3iN3w6DRPKXHMYF56cUBmGzRqt3
	 OmGeT71n4oKaQi0r8Wb5x9kJrh1CpjPPGGi1/U14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 590/869] LoongArch: BPF: Refactor jump offset calculation in tail call
Date: Sat, 17 Oct 2026 17:57:11 +0200
Message-ID: <20261017160052.180362519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 37d545d12f21c4d50612ecaebd7ae1e5bf91b2d8 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/net/bpf_jit.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/loongarch/net/bpf_jit.c b/arch/loongarch/net/bpf_jit.c
index f1aaa4367fc88..4797b0bcc4fd7 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -210,17 +210,13 @@ bool bpf_jit_supports_far_kfunc_call(void)
 
 static int emit_bpf_tail_call(struct jit_ctx *ctx, int insn)
 {
-	int off, tc_ninsn = 0;
+	int off, jmp_offset;
 	u8 tcc = tail_call_reg(ctx);
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
@@ -230,12 +226,12 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx, int insn)
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
 
@@ -244,6 +240,7 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx, int insn)
 	 *	 goto out;
 	 */
 	emit_insn(ctx, addid, REG_TCC, tcc, -1);
+	jmp_offset = ctx->image ? (ctx->offset[insn + 1] - ctx->idx) : 0;
 	if (emit_tailcall_jmp(ctx, BPF_JSLT, REG_TCC, LOONGARCH_GPR_ZERO, jmp_offset) < 0)
 		goto toofar;
 
@@ -256,6 +253,7 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx, int insn)
 	off = offsetof(struct bpf_array, ptrs);
 	emit_insn(ctx, ldd, t2, t2, off);
 	/* beq $t2, $zero, jmp_offset */
+	jmp_offset = ctx->image ? (ctx->offset[insn + 1] - ctx->idx) : 0;
 	if (emit_tailcall_jmp(ctx, BPF_JEQ, t2, LOONGARCH_GPR_ZERO, jmp_offset) < 0)
 		goto toofar;
 
@@ -269,8 +267,6 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx, int insn)
 toofar:
 	pr_info_once("tail_call: jump too far\n");
 	return -1;
-#undef cur_offset
-#undef jmp_offset
 }
 
 static void emit_atomic(const struct bpf_insn *insn, struct jit_ctx *ctx)
-- 
2.53.0



