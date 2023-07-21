Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313811F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88DEC433C8;
	Fri, 21 Jul 2023 16:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955996;
	bh=w1RgeU1DO+l8qv+95iNBDLin4Bh3YTeF6PHZA6NydJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJRGILhuLvExk9GbIN207pr1khk2RCEtq7GaLRlBHfnWzvPU58kCWdwNCYuCDDge6
	 SJgUMSkpbXIsXCfmr8PqSupQSHyjEt/TTRVlHwSFEJ3Y3maNKn9UzLIc/4n8jhBnRU
	 8hv+dfteP9EP1DFKZNS8usDBLRYHeh/LknWJkjKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 080/292] riscv, bpf: Fix inconsistent JIT image generation
Date: Fri, 21 Jul 2023 18:03:09 +0200
Message-ID: <20230721160532.244689804@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Björn Töpel <bjorn@rivosinc.com>

[ Upstream commit c56fb2aab23505bb7160d06097c8de100b82b851 ]

In order to generate the prologue and epilogue, the BPF JIT needs to
know which registers that are clobbered. Therefore, the during
pre-final passes, the prologue is generated after the body of the
program body-prologue-epilogue. Then, in the final pass, a proper
prologue-body-epilogue JITted image is generated.

This scheme has worked most of the time. However, for some large
programs with many jumps, e.g. the test_kmod.sh BPF selftest with
hardening enabled (blinding constants), this has shown to be
incorrect. For the final pass, when the proper prologue-body-epilogue
is generated, the image has not converged. This will lead to that the
final image will have incorrect jump offsets. The following is an
excerpt from an incorrect image:

  | ...
  |     3b8:       00c50663                beq     a0,a2,3c4 <.text+0x3c4>
  |     3bc:       0020e317                auipc   t1,0x20e
  |     3c0:       49630067                jalr    zero,1174(t1) # 20e852 <.text+0x20e852>
  | ...
  |  20e84c:       8796                    c.mv    a5,t0
  |  20e84e:       6422                    c.ldsp  s0,8(sp)    # Epilogue start
  |  20e850:       6141                    c.addi16sp      sp,16
  |  20e852:       853e                    c.mv    a0,a5       # Incorrect jump target
  |  20e854:       8082                    c.jr    ra

The image has shrunk, and the epilogue offset is incorrect in the
final pass.

Correct the problem by always generating proper prologue-body-epilogue
outputs, which means that the first pass will only generate the body
to track what registers that are touched.

Fixes: 2353ecc6f91f ("bpf, riscv: add BPF JIT for RV64G")
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230710074131.19596-1-bjorn@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit.h      |  6 +++---
 arch/riscv/net/bpf_jit_core.c | 19 +++++++++++++------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/net/bpf_jit.h b/arch/riscv/net/bpf_jit.h
index bf9802a63061d..2717f54904287 100644
--- a/arch/riscv/net/bpf_jit.h
+++ b/arch/riscv/net/bpf_jit.h
@@ -69,7 +69,7 @@ struct rv_jit_context {
 	struct bpf_prog *prog;
 	u16 *insns;		/* RV insns */
 	int ninsns;
-	int body_len;
+	int prologue_len;
 	int epilogue_offset;
 	int *offset;		/* BPF to RV */
 	int nexentries;
@@ -216,8 +216,8 @@ static inline int rv_offset(int insn, int off, struct rv_jit_context *ctx)
 	int from, to;
 
 	off++; /* BPF branch is from PC+1, RV is from PC */
-	from = (insn > 0) ? ctx->offset[insn - 1] : 0;
-	to = (insn + off > 0) ? ctx->offset[insn + off - 1] : 0;
+	from = (insn > 0) ? ctx->offset[insn - 1] : ctx->prologue_len;
+	to = (insn + off > 0) ? ctx->offset[insn + off - 1] : ctx->prologue_len;
 	return ninsns_rvoff(to - from);
 }
 
diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.c
index 737baf8715da7..7a26a3e1c73cf 100644
--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -44,7 +44,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	unsigned int prog_size = 0, extable_size = 0;
 	bool tmp_blinded = false, extra_pass = false;
 	struct bpf_prog *tmp, *orig_prog = prog;
-	int pass = 0, prev_ninsns = 0, prologue_len, i;
+	int pass = 0, prev_ninsns = 0, i;
 	struct rv_jit_data *jit_data;
 	struct rv_jit_context *ctx;
 
@@ -83,6 +83,12 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		prog = orig_prog;
 		goto out_offset;
 	}
+
+	if (build_body(ctx, extra_pass, NULL)) {
+		prog = orig_prog;
+		goto out_offset;
+	}
+
 	for (i = 0; i < prog->len; i++) {
 		prev_ninsns += 32;
 		ctx->offset[i] = prev_ninsns;
@@ -91,12 +97,15 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	for (i = 0; i < NR_JIT_ITERATIONS; i++) {
 		pass++;
 		ctx->ninsns = 0;
+
+		bpf_jit_build_prologue(ctx);
+		ctx->prologue_len = ctx->ninsns;
+
 		if (build_body(ctx, extra_pass, ctx->offset)) {
 			prog = orig_prog;
 			goto out_offset;
 		}
-		ctx->body_len = ctx->ninsns;
-		bpf_jit_build_prologue(ctx);
+
 		ctx->epilogue_offset = ctx->ninsns;
 		bpf_jit_build_epilogue(ctx);
 
@@ -162,10 +171,8 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 
 	if (!prog->is_func || extra_pass) {
 		bpf_jit_binary_lock_ro(jit_data->header);
-		prologue_len = ctx->epilogue_offset - ctx->body_len;
 		for (i = 0; i < prog->len; i++)
-			ctx->offset[i] = ninsns_rvoff(prologue_len +
-						      ctx->offset[i]);
+			ctx->offset[i] = ninsns_rvoff(ctx->offset[i]);
 		bpf_prog_fill_jited_linfo(prog, ctx->offset);
 out_offset:
 		kfree(ctx->offset);
-- 
2.39.2



