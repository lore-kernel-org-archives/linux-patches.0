Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280C8524A8;
	Mon,  8 Jan 2024 15:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTmnlEL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D97FC433C8;
	Mon,  8 Jan 2024 15:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728467;
	bh=xNzukKnbhIw53ikfwtrZPxbe2zL23e98UDAuVbIYSC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aTmnlEL6BR5wfsdJjikxvYzxZpHESokL01r5ee/HvsR/NEV8jWh4QAVAXxHD8sDob
	 hNSXhwdH8gGvUj+DmwFAVZwQe2DeAbY7hC5FjqEPcpXNS2sJt4ry3OU0FTV61c6eMI
	 Vzpb6IHY75AUCCbFEXS42WJRLC5o0JXDJr4bM25k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Hao Sun <sunhao.th@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/150] bpf: handle ldimm64 properly in check_cfg()
Date: Mon,  8 Jan 2024 16:35:35 +0100
Message-ID: <20240108153515.104372889@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 3feb263bb516ee7e1da0acd22b15afbb9a7daa19 ]

ldimm64 instructions are 16-byte long, and so have to be handled
appropriately in check_cfg(), just like the rest of BPF verifier does.

This has implications in three places:
  - when determining next instruction for non-jump instructions;
  - when determining next instruction for callback address ldimm64
    instructions (in visit_func_call_insn());
  - when checking for unreachable instructions, where second half of
    ldimm64 is expected to be unreachable;

We take this also as an opportunity to report jump into the middle of
ldimm64. And adjust few test_verifier tests accordingly.

Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Reported-by: Hao Sun <sunhao.th@gmail.com>
Fixes: 475fb78fbf48 ("bpf: verifier (add branch/goto checks)")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20231110002638.4168352-2-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h                           |  8 ++++--
 kernel/bpf/verifier.c                         | 27 ++++++++++++++-----
 .../testing/selftests/bpf/verifier/ld_imm64.c |  8 +++---
 3 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 619fcba84be22..ba22cf4f5fc0e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -702,10 +702,14 @@ bpf_ctx_record_field_size(struct bpf_insn_access_aux *aux, u32 size)
 	aux->ctx_field_size = size;
 }
 
+static bool bpf_is_ldimm64(const struct bpf_insn *insn)
+{
+	return insn->code == (BPF_LD | BPF_IMM | BPF_DW);
+}
+
 static inline bool bpf_pseudo_func(const struct bpf_insn *insn)
 {
-	return insn->code == (BPF_LD | BPF_IMM | BPF_DW) &&
-	       insn->src_reg == BPF_PSEUDO_FUNC;
+	return bpf_is_ldimm64(insn) && insn->src_reg == BPF_PSEUDO_FUNC;
 }
 
 struct bpf_prog_ops {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index dd025f66efabc..95521beec66c5 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11090,15 +11090,16 @@ static int visit_func_call_insn(int t, struct bpf_insn *insns,
 				struct bpf_verifier_env *env,
 				bool visit_callee)
 {
-	int ret;
+	int ret, insn_sz;
 
-	ret = push_insn(t, t + 1, FALLTHROUGH, env, false);
+	insn_sz = bpf_is_ldimm64(&insns[t]) ? 2 : 1;
+	ret = push_insn(t, t + insn_sz, FALLTHROUGH, env, false);
 	if (ret)
 		return ret;
 
-	mark_prune_point(env, t + 1);
+	mark_prune_point(env, t + insn_sz);
 	/* when we exit from subprog, we need to record non-linear history */
-	mark_jmp_point(env, t + 1);
+	mark_jmp_point(env, t + insn_sz);
 
 	if (visit_callee) {
 		mark_prune_point(env, t);
@@ -11120,15 +11121,17 @@ static int visit_func_call_insn(int t, struct bpf_insn *insns,
 static int visit_insn(int t, struct bpf_verifier_env *env)
 {
 	struct bpf_insn *insns = env->prog->insnsi, *insn = &insns[t];
-	int ret, off;
+	int ret, off, insn_sz;
 
 	if (bpf_pseudo_func(insn))
 		return visit_func_call_insn(t, insns, env, true);
 
 	/* All non-branch instructions have a single fall-through edge. */
 	if (BPF_CLASS(insn->code) != BPF_JMP &&
-	    BPF_CLASS(insn->code) != BPF_JMP32)
-		return push_insn(t, t + 1, FALLTHROUGH, env, false);
+	    BPF_CLASS(insn->code) != BPF_JMP32) {
+		insn_sz = bpf_is_ldimm64(insn) ? 2 : 1;
+		return push_insn(t, t + insn_sz, FALLTHROUGH, env, false);
+	}
 
 	switch (BPF_OP(insn->code)) {
 	case BPF_EXIT:
@@ -11227,11 +11230,21 @@ static int check_cfg(struct bpf_verifier_env *env)
 	}
 
 	for (i = 0; i < insn_cnt; i++) {
+		struct bpf_insn *insn = &env->prog->insnsi[i];
+
 		if (insn_state[i] != EXPLORED) {
 			verbose(env, "unreachable insn %d\n", i);
 			ret = -EINVAL;
 			goto err_free;
 		}
+		if (bpf_is_ldimm64(insn)) {
+			if (insn_state[i + 1] != 0) {
+				verbose(env, "jump into the middle of ldimm64 insn %d\n", i);
+				ret = -EINVAL;
+				goto err_free;
+			}
+			i++; /* skip second half of ldimm64 */
+		}
 	}
 	ret = 0; /* cfg looks good */
 
diff --git a/tools/testing/selftests/bpf/verifier/ld_imm64.c b/tools/testing/selftests/bpf/verifier/ld_imm64.c
index f9297900cea6d..78f19c255f20b 100644
--- a/tools/testing/selftests/bpf/verifier/ld_imm64.c
+++ b/tools/testing/selftests/bpf/verifier/ld_imm64.c
@@ -9,8 +9,8 @@
 	BPF_MOV64_IMM(BPF_REG_0, 2),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid BPF_LD_IMM insn",
-	.errstr_unpriv = "R1 pointer comparison",
+	.errstr = "jump into the middle of ldimm64 insn 1",
+	.errstr_unpriv = "jump into the middle of ldimm64 insn 1",
 	.result = REJECT,
 },
 {
@@ -23,8 +23,8 @@
 	BPF_LD_IMM64(BPF_REG_0, 1),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid BPF_LD_IMM insn",
-	.errstr_unpriv = "R1 pointer comparison",
+	.errstr = "jump into the middle of ldimm64 insn 1",
+	.errstr_unpriv = "jump into the middle of ldimm64 insn 1",
 	.result = REJECT,
 },
 {
-- 
2.43.0



