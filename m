Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD09D3451DA;
	Sat, 17 Oct 2026 17:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259856; cv=none; b=b6eXWTyp/LgBsCMW3yN/Qyqee5j6gQJ+xB4SJ6Xod/NwkH7JfgrJT364mWqwNAg2X0QjGa2qFbz3AJ/EN2I8EOpogDVAyiKX6uJrAfRchBrsYQCesbbNfMh9BhDk5MhC77uTK1xFYJCQAjPRiK0+uiF+bTY/PrnRmawBF/nqrWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259856; c=relaxed/simple;
	bh=8798Pa5LLEMjwuwwEiiM4UkIzhP0GvYnnYI2yP5a2Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+PItbd1LEIi4RINeuH/KPZsbhSbCC8e25nKhMw8AM5fVgQMycteO3g1P5Njj8YWIG2iowLLcPPXb7Y2wfLhMS7frwOu5Bmel6+7P245KqSrwadLpyzsSq9p6z6thrP7vYNqrxQPziIujDckgiacwitsTK4vBX+vyCDDYwpFGeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p60J+vYS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p60J+vYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356E01F000C4;
	Sat, 17 Oct 2026 17:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259855;
	bh=1vGJiPUrotblw/WNFrGlntRJNd7gbKG9+lyukujy4t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p60J+vYSVfr4sXvkX7fCcJ7/P40oqRqYS8IBR+PoeF+txf7m29rr447C3yI0eUS67
	 daCQ1wApHeqWTHxlT80BK6keRsx8/3BtKmQBJzkR/DNmdkRIBXpghF1NE/fM/798Qe
	 0FL378QEQUCvBg7cj3HylshcJkmPCbaM+tHn9bN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1352/1674] LoongArch: BPF: Refactor jump offset calculation in tail call
Date: Sat, 17 Oct 2026 18:00:24 +0200
Message-ID: <20261017160505.867824184@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f1ad46e233215..e3220af7d26a1 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -205,17 +205,13 @@ bool bpf_jit_supports_kfunc_call(void)
 
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
@@ -225,12 +221,12 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx, int insn)
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
 
@@ -239,6 +235,7 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx, int insn)
 	 *	 goto out;
 	 */
 	emit_insn(ctx, addid, REG_TCC, tcc, -1);
+	jmp_offset = ctx->image ? (ctx->offset[insn + 1] - ctx->idx) : 0;
 	if (emit_tailcall_jmp(ctx, BPF_JSLT, REG_TCC, LOONGARCH_GPR_ZERO, jmp_offset) < 0)
 		goto toofar;
 
@@ -251,6 +248,7 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx, int insn)
 	off = offsetof(struct bpf_array, ptrs);
 	emit_insn(ctx, ldd, t2, t2, off);
 	/* beq $t2, $zero, jmp_offset */
+	jmp_offset = ctx->image ? (ctx->offset[insn + 1] - ctx->idx) : 0;
 	if (emit_tailcall_jmp(ctx, BPF_JEQ, t2, LOONGARCH_GPR_ZERO, jmp_offset) < 0)
 		goto toofar;
 
@@ -264,8 +262,6 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx, int insn)
 toofar:
 	pr_info_once("tail_call: jump too far\n");
 	return -1;
-#undef cur_offset
-#undef jmp_offset
 }
 
 static void emit_atomic(const struct bpf_insn *insn, struct jit_ctx *ctx)
-- 
2.53.0



