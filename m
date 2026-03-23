Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87798239E6C;
	Mon, 23 Mar 2026 14:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277122; cv=none; b=VRvsBi4nlflP3ijcqMmyOfY+AJRLiUwqOzugwzAX4Uo2VJ/PgR9A6HLRUzAzh60Rmaw4ovHwWN14eRnKFPGJnHjwyRjd8bUL6fU1+QXRtTUb+HvckpFytj5DBw/24d9YdgtKAjw+PVPPHc8r5i2VeIbqHmhULteyv5Aike9ZvAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277122; c=relaxed/simple;
	bh=9lhQTnBdRLX4XSQcrTB+iLHuKL2uD4ww0Vrzc4ARzxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtKZvDo5XuHnKxWwsxcAprUxMWs9z9oMtQLzhZdwmWYDnJ4dHgtku6M99jjwlge9Ut3F+YdgceBwVR+ik9GUNnBbTTJs8e3QUrsUZWv7erogKWdoqEKWGRcB5WM1DouShijAUAODeMrAnuoj7s3sNu94az0Os3Hj1/OpYQn+YUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTUziF5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTUziF5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB74C4CEF7;
	Mon, 23 Mar 2026 14:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277122;
	bh=9lhQTnBdRLX4XSQcrTB+iLHuKL2uD4ww0Vrzc4ARzxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTUziF5HTwfPwkthDY/KaIQqjQwPUNOcqh7V0h5KvonPpt8qAA2TmVjYACy76AOXI
	 xL0YsLjf2RaRm3zzO/ECZk0nPH9c5wrQEn0idXw5NCXZQwLOs9J7Ag9/poBs6S3xSH
	 tlboa8ibJs1NrdPFH8wMbzb2BzcNG/Ot3Dvzxh8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen N Rao <naveen@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 326/460] powerpc64/bpf: Fold bpf_jit_emit_func_call_hlp() into bpf_jit_emit_func_call_rel()
Date: Mon, 23 Mar 2026 14:45:22 +0100
Message-ID: <20260323134534.522595311@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Naveen N Rao <naveen@kernel.org>

[ Upstream commit 9670f6d2097c4f97e15c67920dfddc664d7ee91c ]

Commit 61688a82e047 ("powerpc/bpf: enable kfunc call") enhanced
bpf_jit_emit_func_call_hlp() to handle calls out to module region, where
bpf progs are generated. The only difference now between
bpf_jit_emit_func_call_hlp() and bpf_jit_emit_func_call_rel() is in
handling of the initial pass where target function address is not known.
Fold that logic into bpf_jit_emit_func_call_hlp() and rename it to
bpf_jit_emit_func_call_rel() to simplify bpf function call JIT code.

We don't actually need to load/restore TOC across a call out to a
different kernel helper or to a different bpf program since they all
work with the kernel TOC. We only need to do it if we have to call out
to a module function. So, guard TOC load/restore with appropriate
conditions.

Signed-off-by: Naveen N Rao <naveen@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/20241030070850.1361304-10-hbathini@linux.ibm.com
Stable-dep-of: 01b6ac727296 ("powerpc64/bpf: fix kfunc call support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/net/bpf_jit_comp64.c |   61 ++++++++++----------------------------
 1 file changed, 17 insertions(+), 44 deletions(-)

--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -202,14 +202,22 @@ void bpf_jit_build_epilogue(u32 *image,
 	EMIT(PPC_RAW_BLR());
 }
 
-static int
-bpf_jit_emit_func_call_hlp(u32 *image, u32 *fimage, struct codegen_context *ctx, u64 func)
+int bpf_jit_emit_func_call_rel(u32 *image, u32 *fimage, struct codegen_context *ctx, u64 func)
 {
 	unsigned long func_addr = func ? ppc_function_entry((void *)func) : 0;
 	long reladdr;
 
-	if (WARN_ON_ONCE(!kernel_text_address(func_addr)))
-		return -EINVAL;
+	/* bpf to bpf call, func is not known in the initial pass. Emit 5 nops as a placeholder */
+	if (!func) {
+		for (int i = 0; i < 5; i++)
+			EMIT(PPC_RAW_NOP());
+		/* elfv1 needs an additional instruction to load addr from descriptor */
+		if (IS_ENABLED(CONFIG_PPC64_ELF_ABI_V1))
+			EMIT(PPC_RAW_NOP());
+		EMIT(PPC_RAW_MTCTR(_R12));
+		EMIT(PPC_RAW_BCTRL());
+		return 0;
+	}
 
 #ifdef CONFIG_PPC_KERNEL_PCREL
 	reladdr = func_addr - local_paca->kernelbase;
@@ -266,7 +274,8 @@ bpf_jit_emit_func_call_hlp(u32 *image, u
 			 * We can clobber r2 since we get called through a
 			 * function pointer (so caller will save/restore r2).
 			 */
-			EMIT(PPC_RAW_LD(_R2, bpf_to_ppc(TMP_REG_2), 8));
+			if (is_module_text_address(func_addr))
+				EMIT(PPC_RAW_LD(_R2, bpf_to_ppc(TMP_REG_2), 8));
 		} else {
 			PPC_LI64(_R12, func);
 			EMIT(PPC_RAW_MTCTR(_R12));
@@ -276,46 +285,14 @@ bpf_jit_emit_func_call_hlp(u32 *image, u
 		 * Load r2 with kernel TOC as kernel TOC is used if function address falls
 		 * within core kernel text.
 		 */
-		EMIT(PPC_RAW_LD(_R2, _R13, offsetof(struct paca_struct, kernel_toc)));
+		if (is_module_text_address(func_addr))
+			EMIT(PPC_RAW_LD(_R2, _R13, offsetof(struct paca_struct, kernel_toc)));
 	}
 #endif
 
 	return 0;
 }
 
-int bpf_jit_emit_func_call_rel(u32 *image, u32 *fimage, struct codegen_context *ctx, u64 func)
-{
-	unsigned int i, ctx_idx = ctx->idx;
-
-	if (WARN_ON_ONCE(func && is_module_text_address(func)))
-		return -EINVAL;
-
-	/* skip past descriptor if elf v1 */
-	func += FUNCTION_DESCR_SIZE;
-
-	/* Load function address into r12 */
-	PPC_LI64(_R12, func);
-
-	/* For bpf-to-bpf function calls, the callee's address is unknown
-	 * until the last extra pass. As seen above, we use PPC_LI64() to
-	 * load the callee's address, but this may optimize the number of
-	 * instructions required based on the nature of the address.
-	 *
-	 * Since we don't want the number of instructions emitted to increase,
-	 * we pad the optimized PPC_LI64() call with NOPs to guarantee that
-	 * we always have a five-instruction sequence, which is the maximum
-	 * that PPC_LI64() can emit.
-	 */
-	if (!image)
-		for (i = ctx->idx - ctx_idx; i < 5; i++)
-			EMIT(PPC_RAW_NOP());
-
-	EMIT(PPC_RAW_MTCTR(_R12));
-	EMIT(PPC_RAW_BCTRL());
-
-	return 0;
-}
-
 static int bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32 out)
 {
 	/*
@@ -1102,11 +1079,7 @@ emit_clear:
 			if (ret < 0)
 				return ret;
 
-			if (func_addr_fixed)
-				ret = bpf_jit_emit_func_call_hlp(image, fimage, ctx, func_addr);
-			else
-				ret = bpf_jit_emit_func_call_rel(image, fimage, ctx, func_addr);
-
+			ret = bpf_jit_emit_func_call_rel(image, fimage, ctx, func_addr);
 			if (ret)
 				return ret;
 


