Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDB922CBC6;
	Mon, 23 Mar 2026 14:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277125; cv=none; b=BILmLVyyDowgXqC9yu+x1ByYdELMMenOk27sjC7KoWg5dwxcBGtKPxI6PoyBxac81eYypVI3mZYrlXge9bUwRYONy4mMQOGlAiWYP3vGtXvXgUqZZezeGMVlw9Nz3fAjWdSQMBYmCkfmE7XAbPq5WKcNvYxzdziGa8/b0j+Dl0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277125; c=relaxed/simple;
	bh=ONMZovV10ElPfDthSBE4ixvIsabWpGcjbY4b81KYSRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhnX5Yzwq4z6lvQV7KOlJ4btmNc98NHi2O6BBBOfIipc7Bdkpby60UeWTXgDo2iWyHij0pP9VNA5rptTEZLiq4XIsHcmiuaOa/RAklVCWs99yM57bwLeFND+f7+eSok9jvBtqdNuVfl7t1EpDU44hwjoH4cce0s+ucSaZw5k9fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lTG97zMm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lTG97zMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7FFC4CEF7;
	Mon, 23 Mar 2026 14:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277125;
	bh=ONMZovV10ElPfDthSBE4ixvIsabWpGcjbY4b81KYSRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lTG97zMm+xzzib1LtS3l4C3Qc4fhBhrYdTNgU6LPtc1vBtaW6XVQpv9ONINRQ8EnG
	 B2TN4t3OuxaRMlnpvck8bqiyw2htnZCbj5wflothcnQnGtENLCniL3+J5rdxnW4qGd
	 vr/KyqQxzpnegzInmh2nhOAvnoV0MqFYCSk2IPro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Bathini <hbathini@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 327/460] powerpc64/bpf: fix kfunc call support
Date: Mon, 23 Mar 2026 14:45:23 +0100
Message-ID: <20260323134534.551198600@linuxfoundation.org>
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

From: Hari Bathini <hbathini@linux.ibm.com>

[ Upstream commit 01b6ac72729610ae732ca2a66e3a642e23f6cd60 ]

Commit 61688a82e047 ("powerpc/bpf: enable kfunc call") inadvertently
enabled kfunc call support for 32-bit powerpc but that support will
not be possible until ABI mismatch between 32-bit powerpc and eBPF is
handled in 32-bit powerpc JIT code. Till then, advertise support only
for 64-bit powerpc. Also, in powerpc ABI, caller needs to extend the
arguments properly based on signedness. The JIT code is responsible
for handling this explicitly for kfunc calls as verifier can't handle
this for each architecture-specific ABI needs. But this was not taken
care of while kfunc call support was enabled for powerpc. Fix it by
handling this with bpf_jit_find_kfunc_model() and using zero_extend()
& sign_extend() helper functions.

Fixes: 61688a82e047 ("powerpc/bpf: enable kfunc call")
Cc: stable@vger.kernel.org
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260303181031.390073-7-hbathini@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/net/bpf_jit_comp.c   |    2 
 arch/powerpc/net/bpf_jit_comp64.c |  101 ++++++++++++++++++++++++++++++++++----
 2 files changed, 94 insertions(+), 9 deletions(-)

--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -362,7 +362,7 @@ void bpf_jit_free(struct bpf_prog *fp)
 
 bool bpf_jit_supports_kfunc_call(void)
 {
-	return true;
+	return IS_ENABLED(CONFIG_PPC64);
 }
 
 bool bpf_jit_supports_far_kfunc_call(void)
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -293,6 +293,83 @@ int bpf_jit_emit_func_call_rel(u32 *imag
 	return 0;
 }
 
+static int zero_extend(u32 *image, struct codegen_context *ctx, u32 src_reg, u32 dst_reg, u32 size)
+{
+	switch (size) {
+	case 1:
+		 /* zero-extend 8 bits into 64 bits */
+		EMIT(PPC_RAW_RLDICL(dst_reg, src_reg, 0, 56));
+		return 0;
+	case 2:
+		 /* zero-extend 16 bits into 64 bits */
+		EMIT(PPC_RAW_RLDICL(dst_reg, src_reg, 0, 48));
+		return 0;
+	case 4:
+		 /* zero-extend 32 bits into 64 bits */
+		EMIT(PPC_RAW_RLDICL(dst_reg, src_reg, 0, 32));
+		fallthrough;
+	case 8:
+		/* Nothing to do */
+		return 0;
+	default:
+		return -1;
+	}
+}
+
+static int sign_extend(u32 *image, struct codegen_context *ctx, u32 src_reg, u32 dst_reg, u32 size)
+{
+	switch (size) {
+	case 1:
+		 /* sign-extend 8 bits into 64 bits */
+		EMIT(PPC_RAW_EXTSB(dst_reg, src_reg));
+		return 0;
+	case 2:
+		 /* sign-extend 16 bits into 64 bits */
+		EMIT(PPC_RAW_EXTSH(dst_reg, src_reg));
+		return 0;
+	case 4:
+		 /* sign-extend 32 bits into 64 bits */
+		EMIT(PPC_RAW_EXTSW(dst_reg, src_reg));
+		fallthrough;
+	case 8:
+		/* Nothing to do */
+		return 0;
+	default:
+		return -1;
+	}
+}
+
+/*
+ * Handle powerpc ABI expectations from caller:
+ *   - Unsigned arguments are zero-extended.
+ *   - Signed arguments are sign-extended.
+ */
+static int prepare_for_kfunc_call(const struct bpf_prog *fp, u32 *image,
+				  struct codegen_context *ctx,
+				  const struct bpf_insn *insn)
+{
+	const struct btf_func_model *m = bpf_jit_find_kfunc_model(fp, insn);
+	int i;
+
+	if (!m)
+		return -1;
+
+	for (i = 0; i < m->nr_args; i++) {
+		/* Note that BPF ABI only allows up to 5 args for kfuncs */
+		u32 reg = bpf_to_ppc(BPF_REG_1 + i), size = m->arg_size[i];
+
+		if (!(m->arg_flags[i] & BTF_FMODEL_SIGNED_ARG)) {
+			if (zero_extend(image, ctx, reg, reg, size))
+				return -1;
+		} else {
+			if (sign_extend(image, ctx, reg, reg, size))
+				return -1;
+		}
+	}
+
+	return 0;
+}
+
 static int bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32 out)
 {
 	/*
@@ -678,14 +755,16 @@ int bpf_jit_build_body(struct bpf_prog *
 				/* special mov32 for zext */
 				EMIT(PPC_RAW_RLWINM(dst_reg, dst_reg, 0, 0, 31));
 				break;
-			} else if (off == 8) {
-				EMIT(PPC_RAW_EXTSB(dst_reg, src_reg));
-			} else if (off == 16) {
-				EMIT(PPC_RAW_EXTSH(dst_reg, src_reg));
-			} else if (off == 32) {
-				EMIT(PPC_RAW_EXTSW(dst_reg, src_reg));
-			} else if (dst_reg != src_reg)
-				EMIT(PPC_RAW_MR(dst_reg, src_reg));
+			}
+			if (off == 0) {
+				/* MOV */
+				if (dst_reg != src_reg)
+					EMIT(PPC_RAW_MR(dst_reg, src_reg));
+			} else {
+				/* MOVSX: dst = (s8,s16,s32)src (off = 8,16,32) */
+				if (sign_extend(image, ctx, src_reg, dst_reg, off / 8))
+					return -1;
+			}
 			goto bpf_alu32_trunc;
 		case BPF_ALU | BPF_MOV | BPF_K: /* (u32) dst = imm */
 		case BPF_ALU64 | BPF_MOV | BPF_K: /* dst = (s64) imm */
@@ -1079,6 +1158,12 @@ emit_clear:
 			if (ret < 0)
 				return ret;
 
+			/* Take care of powerpc ABI requirements before kfunc call */
+			if (insn[i].src_reg == BPF_PSEUDO_KFUNC_CALL) {
+				if (prepare_for_kfunc_call(fp, image, ctx, &insn[i]))
+					return -1;
+			}
+
 			ret = bpf_jit_emit_func_call_rel(image, fimage, ctx, func_addr);
 			if (ret)
 				return ret;


