Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019506;
	b=0Oi5N7iBGMkzsT385sjC8Zd8XebFJWOAnTX5j+2PLzK2E+479P1+fnUgfl6GaM/Xcbk9
	 52y3OnhjefIXuDFhpWfED5zN0SyCFM6x/C1PCLfkUvRfmWyNP0X4OtxgWAgp35ueGQz2p
	 tc0HW6KSGWU+i1R/pJ0aeW6foXY2XkuwW5pSGmpjxdu30+ExDt+0zl/plYoyGdkXupV+9
	 p3FNEVlqMbkLc69XzUGjnLjUDjbZ6Ilxw6qOgw3wqRBlU321hrQFtqTcme+PvZwYHVZ8k
	 D/LN8eHwMBS+0vGFKoU3l/RY9XidudsZlTVVpet/2vGsm/Ipx8gWA3h9Mb9ljnOFLsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DOeLiwtnTjPRdMyLW4artsqhKAvz85CwT5/w7nOaLnw=;
	b=YpUtyO1azdYyugvU0SsGM2ybw/i5ftk9yt3x9viLYrAzUuVCl2/ZJ1xr1WJ15ZQKxpKX
	 hzkl2PqZO40GM25FPqYnvpmHcsgSev/SaU4jlpxlP3gTKD6zHfMUb82Fy0Nk8hvburNJ2
	 747rQsrXGHxHBWugib3U47xHA0DYtmMJ5uq2keCllA1qzlT4GWAKGQJmSirqL9oxnGpCn
	 rF1oPem4p2N8liu4qmvAoYGnupHpmZ/gI84XnegfS4CpPQJcFdZ456E3gG+M2xwvdxnbW
	 Yhliczj1mMPhzEc62SXMBAHAtG+4kjlc1+lavrMVfpQBzaTSYDtbFslJ2HyTqvMHHZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oKRKKr08;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C64E606A338;
	Wed, 18 Nov 2026 16:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oKRKKr08
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECED1F000CA;
	Wed, 18 Nov 2026 16:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019506;
	bh=DOeLiwtnTjPRdMyLW4artsqhKAvz85CwT5/w7nOaLnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oKRKKr083VyWMY6ZgiaemTkG1/4iQR5F4g0VZ70JuzrX/L/3zdW08qQBFnljKOQsf
	 gYWbi544qqw7paNUZN/9BbxjTpxKDyW87GmwgO+fnEYXCRr3p4OyHGxN/Z6jKSeeL0
	 BbqujF7ENQXUV/buJQndVHtvikYHXI4agvrb50fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1578/2651] bpf: Fix arg_track_xfer() for atomic stack spills and fills
Date: Wed, 18 Nov 2026 15:46:58 +0100
Message-ID: <20261118150344.730060416@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 13cffb88318085117c988106d4f5e439646f3ba6 ]

Track spilled stack pointers through 64-bit atomic accesses:
- BPF_STORE_REL spills the source register.
- BPF_LOAD_ACQ restores the spilled value into dst_reg.
- BPF_XCHG and BPF_{ADD,AND,OR,XOR} | BPF_FETCH restore it into src_reg.
- BPF_CMPXCHG restores it into R0.

This prevents missing stack accesses through pointers recovered by these
instructions, matching the main verifier's spill/fill behavior.

Fixes: bf0c571f7feb ("bpf: introduce forward arg-tracking dataflow analysis")
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261009-scev-minimal-rebase-v3-9-bcba9bc53ac9@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/liveness.c | 91 ++++++++++++++++++++++++-------------------
 1 file changed, 50 insertions(+), 41 deletions(-)

diff --git a/kernel/bpf/liveness.c b/kernel/bpf/liveness.c
index 53e4e286a24e3..acee6f86f8474 100644
--- a/kernel/bpf/liveness.c
+++ b/kernel/bpf/liveness.c
@@ -1239,6 +1239,29 @@ static bool can_be_local_fp(int depth, int regno, struct arg_track *at)
 	       (at->frame == ARG_IMPRECISE && (at->mask & BIT(depth)));
 }
 
+/*
+ * Model 8-byte reads through @reg, including load-acquire
+ * and the old value fetched by atomic operations.
+ */
+static struct arg_track arg_track_deref(struct bpf_verifier_env *env, struct bpf_insn *insn,
+					struct arg_track *at_out, int reg,
+					struct arg_track *at_stack_out, u32 nslots,
+					int depth, u32 *callsites)
+{
+	struct arg_track *ptr = &at_out[reg];
+
+	if (can_be_local_fp(depth, reg, ptr))
+		return fill_from_stack(insn, at_out, reg, at_stack_out, nslots, depth);
+	if (ptr->frame >= 0 && ptr->frame < depth) {
+		struct spill_snapshot *parent = env->callsite_at_stack[callsites[ptr->frame]];
+
+		return fill_from_stack(insn, at_out, reg, parent->at, parent->slots, ptr->frame);
+	}
+	if (ptr->frame == ARG_IMPRECISE && !(ptr->mask & BIT(depth)) && ptr->mask)
+		return *ptr;
+	return (struct arg_track){ .frame = ARG_NONE };
+}
+
 /*
  * Pure dataflow transfer function for arg_track state.
  * Updates at_out[] based on how the instruction modifies registers.
@@ -1320,56 +1343,42 @@ static void arg_track_xfer(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		for (r = BPF_REG_0; r <= BPF_REG_5; r++)
 			at_out[r] = none;
 	} else if (class == BPF_LDX) {
-		u32 sz = bpf_size_to_bytes(BPF_SIZE(insn->code));
-		bool src_is_local_fp = can_be_local_fp(depth, insn->src_reg, src);
-
-		/*
-		 * Reload from callee stack: if src is current-frame FP-derived
-		 * and the load is an 8-byte BPF_MEM, try to restore the spill
-		 * identity.  For imprecise sources fill_from_stack() returns
-		 * ARG_IMPRECISE (off_cnt == 0).
-		 */
-		if (src_is_local_fp && BPF_MODE(insn->code) == BPF_MEM && sz == 8) {
-			*dst = fill_from_stack(insn, at_out, insn->src_reg, at_stack_out, nslots,
-					       depth);
-		} else if (src->frame >= 0 && src->frame < depth &&
-			   BPF_MODE(insn->code) == BPF_MEM && sz == 8) {
-			struct spill_snapshot *parent =
-				env->callsite_at_stack[callsites[src->frame]];
-
-			*dst = fill_from_stack(insn, at_out, insn->src_reg,
-					       parent->at, parent->slots, src->frame);
-		} else if (src->frame == ARG_IMPRECISE &&
-			   !(src->mask & BIT(depth)) && src->mask &&
-			   BPF_MODE(insn->code) == BPF_MEM && sz == 8) {
-			/*
-			 * Imprecise src with only parent-frame bits:
-			 * conservative fallback.
-			 */
-			*dst = *src;
-		} else {
+		/* Only an 8-byte BPF_MEM load can be a fill, see arg_track_deref(). */
+		if (BPF_MODE(insn->code) == BPF_MEM && BPF_SIZE(insn->code) == BPF_DW)
+			*dst = arg_track_deref(env, insn, at_out, insn->src_reg,
+					       at_stack_out, nslots, depth, callsites);
+		else
 			*dst = none;
-		}
 	} else if (class == BPF_LD && BPF_MODE(insn->code) == BPF_IMM) {
 		*dst = none;
 	} else if (class == BPF_STX) {
 		u32 sz = bpf_size_to_bytes(BPF_SIZE(insn->code));
-		bool dst_is_local_fp;
-
-		/* Track spills to current-frame FP-derived callee stack */
-		dst_is_local_fp = can_be_local_fp(depth, insn->dst_reg, dst);
-		if (dst_is_local_fp && BPF_MODE(insn->code) == BPF_MEM)
-			spill_to_stack(insn, at_out, insn->dst_reg,
-				       at_stack_out, nslots, src, sz);
+		bool dst_is_local_fp = can_be_local_fp(depth, insn->dst_reg, dst);
+		u8 mode = BPF_MODE(insn->code);
+
+		if (mode == BPF_MEM || (mode == BPF_ATOMIC && insn->imm == BPF_STORE_REL)) {
+			if (dst_is_local_fp)
+				spill_to_stack(insn, at_out, insn->dst_reg,
+					       at_stack_out, nslots, src, sz);
+		} else if (mode == BPF_ATOMIC && insn->imm == BPF_LOAD_ACQ) {
+			if (sz == 8)
+				*dst = arg_track_deref(env, insn, at_out, insn->src_reg,
+						       at_stack_out, nslots, depth, callsites);
+			else
+				*dst = none;
+		} else if (mode == BPF_ATOMIC) {
+			/* BPF_XCHG, BPF_CMPXCHG or BPF_{ADD,AND,OR,XOR} | [BPF_FETCH] */
+			struct arg_track old = none;
 
-		if (BPF_MODE(insn->code) == BPF_ATOMIC) {
-			if (dst_is_local_fp && insn->imm != BPF_LOAD_ACQ)
+			r = bpf_atomic_load_reg(insn);
+			if (r >= 0 && sz == 8)
+				old = arg_track_deref(env, insn, at_out, insn->dst_reg,
+						      at_stack_out, nslots, depth, callsites);
+			if (dst_is_local_fp)
 				clear_stack_for_all_offs(insn, at_out, insn->dst_reg,
 							 at_stack_out, nslots, sz);
-
-			r = bpf_atomic_load_reg(insn);
 			if (r >= 0)
-				at_out[r] = none;
+				at_out[r] = old;
 		}
 	} else if (class == BPF_ST && BPF_MODE(insn->code) == BPF_MEM) {
 		u32 sz = bpf_size_to_bytes(BPF_SIZE(insn->code));
-- 
2.53.0



