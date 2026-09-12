Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E93E3AFD15;
	Sat, 12 Sep 2026 09:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203629; cv=none; b=rb+eSD6DT2zUjuFGOTIY/3jbhg2U9nUp9MX8hSqJdIC6YCw6avV8dHwYRA+2YZvF4AkF/AKxZH04CRvwMYmHXYE5NMBada99a1nLcorFaPoR0trmJdZhftlA3yR6/Pp40esboUHJk5a8pDJwgJUQxZOw9WEOkxVMCQfTnsa48as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203629; c=relaxed/simple;
	bh=Ai5XoyOgOTBPNOpP96qu53voRRC1IPxf5PkZ1pLwfik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpgwdPtkuDCUmQY9v3QtRbVrFQQHQshx31ZCTQgByEfz/6NIlXZDF7l13rG4s7i/KvDw9AFfmKoXbDO/6RFRllWFjYbYiYUSZTsjU+cusHyKGmiv29WltKzjUa/HkF3wrVsq8aCHlSWFt475NVKxdAlxBV+VcoAUst3IGEooYto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0yaXQ7+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0yaXQ7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9D91F000FF;
	Sat, 12 Sep 2026 09:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203628;
	bh=UMy4fC/gQSeJJraauALBz00lJQCjdsQDDBG4qS3DgNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C0yaXQ7+6PqGT3b0iIvR1o0omcAHNbR7ZVX7OBBoQpVvH9YcEkZw5tV69a3gf7v8m
	 jwpedl1+SPx9EGL9BLIjaJtqoyb5jLUsGFTSo8EtcLtvRyREYlFtdBl5QtoY/ieALS
	 Kz06Y2ijTVc5KRPotqVct4Ni5Gd4mXyymCu94p98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Xu Kuohai <xukuohai@huawei.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1446/1815] bpf, arm64: Fix stack-passed arguments for indirect trampolines
Date: Sat, 12 Sep 2026 08:53:16 +0200
Message-ID: <20260912065722.963130846@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit 50de1c47a41d4031f6002969e71dc6954dedb6b2 ]

save_args() reads stack-passed arguments relative to FP assuming the
trampoline is entered through the fentry call from a traced function, in
which case both the parent frame (FP/x9) and the traced function frame
(FP/LR) are saved before FP is set, so the arguments start at FP + 32.

An indirect trampoline for a struct_ops callback is entered through a
function pointer (blr), so only the FP/LR frame is pushed and the
arguments start at FP + 16, not FP + 32. Every stack-passed argument of
a struct_ops callback with more than eight argument slots is read two
slots off.

This went unnoticed because no struct_ops member passed arguments on the
stack until bpf_testmod_ops3::test_arena_stack, added by
commit 2d4de9a493a0 ("selftests/bpf: Test stack-passed struct_ops arena arguments").
That member covers this on arm64 once the JIT gains arena argument
support later in this series. Pass is_struct_ops into save_args() and
pick the offset accordingly, mirroring the x86 fix.

Fixes: 9014cf56f13d ("bpf, arm64: Support up to 12 function arguments")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Reviewed-by: Xu Kuohai <xukuohai@huawei.com>
Link: https://lore.kernel.org/bpf/20260813190356.335181-2-puranjay@kernel.org
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 6d9d2ecc4fe46..d4e62484baea0 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -2512,9 +2512,8 @@ static void clear_garbage(struct jit_ctx *ctx, int reg, int effective_bytes)
 }
 
 static void save_args(struct jit_ctx *ctx, int bargs_off, int oargs_off,
-		      const struct btf_func_model *m,
-		      const struct arg_aux *a,
-		      bool for_call_origin)
+		      const struct btf_func_model *m, const struct arg_aux *a,
+		      bool for_call_origin, bool is_struct_ops)
 {
 	int i;
 	int reg;
@@ -2534,7 +2533,15 @@ static void save_args(struct jit_ctx *ctx, int bargs_off, int oargs_off,
 		bargs_off += 8;
 	}
 
-	soff = 32; /* on stack arguments start from FP + 32 */
+	/*
+	 * On-stack arguments start above the frame(s) pushed by the trampoline
+	 * prologue. Entered through the fentry call from a traced function, the
+	 * prologue saves both the parent (FP/x9) and the traced function
+	 * (FP/LR) frames, so the arguments start at FP + 32. A struct_ops
+	 * callback is called indirectly and only the FP/LR frame is saved, so
+	 * they start at FP + 16.
+	 */
+	soff = is_struct_ops ? 16 : 32;
 	doff = (for_call_origin ? oargs_off : bargs_off);
 
 	/* save on stack arguments */
@@ -2730,7 +2737,7 @@ static int prepare_trampoline(struct jit_ctx *ctx, struct bpf_tramp_image *im,
 	store_func_meta(ctx, func_meta, func_meta_off);
 
 	/* save args for bpf */
-	save_args(ctx, bargs_off, oargs_off, m, a, false);
+	save_args(ctx, bargs_off, oargs_off, m, a, false, is_struct_ops);
 
 	/* save callee saved registers */
 	emit(A64_STR64I(A64_R(19), A64_SP, regs_off), ctx);
@@ -2779,7 +2786,7 @@ static int prepare_trampoline(struct jit_ctx *ctx, struct bpf_tramp_image *im,
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
 		/* save args for original func */
-		save_args(ctx, bargs_off, oargs_off, m, a, true);
+		save_args(ctx, bargs_off, oargs_off, m, a, true, is_struct_ops);
 		/* call original func */
 		emit(A64_LDR64I(A64_R(10), A64_SP, retaddr_off), ctx);
 		emit(A64_ADR(A64_LR, AARCH64_INSN_SIZE * 2), ctx);
-- 
2.53.0



