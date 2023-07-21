Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB70920F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69981C433C7;
	Fri, 21 Jul 2023 19:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966674;
	bh=7Bg/hFRHrGEOwe9+xfZkJBxtBSSoWuGmCYi0/+j7hp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLFjCWUzX2cWoyOj/0w/wxcvcv9kDLxur13ktiWLVz25SKHdpo1psA1mqRSo4SQkH
	 kxsAfbzG7UCOqbPDSryl7fx5PFx7TyeJYcKZ6yRhEp3EBWneD+AR1yeTyFiSxStLq+
	 AIzeO+G12lnB4TBwopaC6wpJdGbuW0qHRBOhUFN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 427/532] bpf, riscv: Support riscv jit to provide bpf_line_info
Date: Fri, 21 Jul 2023 18:05:31 +0200
Message-ID: <20230721160637.732370868@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 3cb70413041fdf028fa1ba3986fd0c6aec9e3dcb ]

Add support for riscv jit to provide bpf_line_info. We need to
consider the prologue offset in ctx->offset, but unlike x86 and
arm64, ctx->offset of riscv does not provide an extra slot for
the prologue, so here we just calculate the len of prologue and
add it to ctx->offset at the end. Both RV64 and RV32 have been
tested.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220530092815.1112406-3-pulehui@huawei.com
Stable-dep-of: c56fb2aab235 ("riscv, bpf: Fix inconsistent JIT image generation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit.h      | 1 +
 arch/riscv/net/bpf_jit_core.c | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/net/bpf_jit.h b/arch/riscv/net/bpf_jit.h
index 75c1e99968675..ab0cd6d10ccf3 100644
--- a/arch/riscv/net/bpf_jit.h
+++ b/arch/riscv/net/bpf_jit.h
@@ -69,6 +69,7 @@ struct rv_jit_context {
 	struct bpf_prog *prog;
 	u16 *insns;		/* RV insns */
 	int ninsns;
+	int body_len;
 	int epilogue_offset;
 	int *offset;		/* BPF to RV */
 	unsigned long flags;
diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.c
index 753d85bdfad07..ff644452b88db 100644
--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -43,7 +43,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 {
 	bool tmp_blinded = false, extra_pass = false;
 	struct bpf_prog *tmp, *orig_prog = prog;
-	int pass = 0, prev_ninsns = 0, i;
+	int pass = 0, prev_ninsns = 0, prologue_len, i;
 	struct rv_jit_data *jit_data;
 	struct rv_jit_context *ctx;
 	unsigned int image_size = 0;
@@ -95,6 +95,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 			prog = orig_prog;
 			goto out_offset;
 		}
+		ctx->body_len = ctx->ninsns;
 		bpf_jit_build_prologue(ctx);
 		ctx->epilogue_offset = ctx->ninsns;
 		bpf_jit_build_epilogue(ctx);
@@ -154,6 +155,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 
 	if (!prog->is_func || extra_pass) {
 		bpf_jit_binary_lock_ro(jit_data->header);
+		prologue_len = ctx->epilogue_offset - ctx->body_len;
+		for (i = 0; i < prog->len; i++)
+			ctx->offset[i] = ninsns_rvoff(prologue_len +
+						      ctx->offset[i]);
+		bpf_prog_fill_jited_linfo(prog, ctx->offset);
 out_offset:
 		kfree(ctx->offset);
 		kfree(jit_data);
-- 
2.39.2



