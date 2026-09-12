Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4ACB3DD51A;
	Sat, 12 Sep 2026 11:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211221; cv=none; b=iHkxgnQpUFebm6CMgol4id5r7CUTgGSpLk+9qrL5IlPb8Fiw0upR5rP6Udmy8ZZBScshFiMszyFt/iMpgpAJyMCcUew0S4RcwF+3hnO58HO2KXL9Zh/ful/TWOCPGY3KlADuFEFxxhH2vmIduouSg6KROuFaObQNUrhP4XHVo3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211221; c=relaxed/simple;
	bh=EKrtvVmaxsNhdR4k4fP40lrWvcR4wpXSwq/GowJEHFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+oI13R3MVHgPqaFRtMDMtyfr0fc6KgrLuPDMFU76FTfSrwUjJucGVzxH/dckq/5rGqmLRDdpmnCEyBk52fggNmLeOAmV4NNhC28fVqP9iOJXz91ylhC0HGz4tSq6mqj/OUCQtuUeAWJMz53N17rxxD8P3aD/F6m2OeuXee/xS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AftdGJ7N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AftdGJ7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81DC1F000FF;
	Sat, 12 Sep 2026 11:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211219;
	bh=A7F3lUFxeyDQyjG/pBwGKiywAbrK4k7gxa2ACjBf3J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AftdGJ7Nh/DEl6bTeadQbElnXsAR0aOjdTsUCoxXW5F2i76UjL4kM8bnSBC2zkl6A
	 IrOcsvxTGjfCQvBrVMl10DCL62T1dnbTdopu/5nynIMNRJIxrC8GPnP/2pMUIzLNzh
	 4Gceb6QJEjtsNj8xP9CLw8i/8K4RlRavY2sCpqvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Xu Kuohai <xukuohai@huawei.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1185/1518] bpf, arm64: Fix stack-passed arguments for indirect trampolines
Date: Sat, 12 Sep 2026 08:55:54 +0200
Message-ID: <20260912065650.281902273@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index bcfadc49d2096..7be20cb32a271 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -2433,9 +2433,8 @@ static void clear_garbage(struct jit_ctx *ctx, int reg, int effective_bytes)
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
@@ -2455,7 +2454,15 @@ static void save_args(struct jit_ctx *ctx, int bargs_off, int oargs_off,
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
@@ -2633,7 +2640,7 @@ static int prepare_trampoline(struct jit_ctx *ctx, struct bpf_tramp_image *im,
 	emit(A64_STR64I(A64_R(10), A64_SP, nfuncargs_off), ctx);
 
 	/* save args for bpf */
-	save_args(ctx, bargs_off, oargs_off, m, a, false);
+	save_args(ctx, bargs_off, oargs_off, m, a, false, is_struct_ops);
 
 	/* save callee saved registers */
 	emit(A64_STR64I(A64_R(19), A64_SP, regs_off), ctx);
@@ -2665,7 +2672,7 @@ static int prepare_trampoline(struct jit_ctx *ctx, struct bpf_tramp_image *im,
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
 		/* save args for original func */
-		save_args(ctx, bargs_off, oargs_off, m, a, true);
+		save_args(ctx, bargs_off, oargs_off, m, a, true, is_struct_ops);
 		/* call original func */
 		emit(A64_LDR64I(A64_R(10), A64_SP, retaddr_off), ctx);
 		emit(A64_ADR(A64_LR, AARCH64_INSN_SIZE * 2), ctx);
-- 
2.53.0



