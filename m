Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C494A54F85;
	Mon,  8 Jan 2024 15:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wakMJWfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD02C433C8;
	Mon,  8 Jan 2024 15:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728460;
	bh=39KTWdDsa5zHdv93N5UZ6gpT7H27rZrYPaEd/GTZVsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wakMJWfrEcof1XmnzDaUCmIDT4C+XAUNwqhAjY7Y9dqnCPKdkJFCfIN6ssRc8wuZs
	 w420O9ZnxeLrB2T+St7YH5IfwAupxfkLMQqt0yRo6N8TZN36oBcfdGIzwSq2t3Junx
	 yQydUICJSYGO0sSwh2muzhvCNUc1UhrVn/j+JW9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/150] bpf: Support new 32bit offset jmp instruction
Date: Mon,  8 Jan 2024 16:35:34 +0100
Message-ID: <20240108153515.057018112@linuxfoundation.org>
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

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit 4cd58e9af8b9d9fff6b7145e742abbfcda0af4af ]

Add interpreter/jit/verifier support for 32bit offset jmp instruction.
If a conditional jmp instruction needs more than 16bit offset,
it can be simulated with a conditional jmp + a 32bit jmp insn.

Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20230728011231.3716103-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 3feb263bb516 ("bpf: handle ldimm64 properly in check_cfg()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 28 ++++++++++++++++++----------
 kernel/bpf/core.c           | 19 ++++++++++++++++---
 kernel/bpf/verifier.c       | 32 ++++++++++++++++++++++----------
 3 files changed, 56 insertions(+), 23 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 84c695ae1940f..b69aee6245e4a 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1625,16 +1625,24 @@ st:			if (is_imm8(insn->off))
 			break;
 
 		case BPF_JMP | BPF_JA:
-			if (insn->off == -1)
-				/* -1 jmp instructions will always jump
-				 * backwards two bytes. Explicitly handling
-				 * this case avoids wasting too many passes
-				 * when there are long sequences of replaced
-				 * dead code.
-				 */
-				jmp_offset = -2;
-			else
-				jmp_offset = addrs[i + insn->off] - addrs[i];
+		case BPF_JMP32 | BPF_JA:
+			if (BPF_CLASS(insn->code) == BPF_JMP) {
+				if (insn->off == -1)
+					/* -1 jmp instructions will always jump
+					 * backwards two bytes. Explicitly handling
+					 * this case avoids wasting too many passes
+					 * when there are long sequences of replaced
+					 * dead code.
+					 */
+					jmp_offset = -2;
+				else
+					jmp_offset = addrs[i + insn->off] - addrs[i];
+			} else {
+				if (insn->imm == -1)
+					jmp_offset = -2;
+				else
+					jmp_offset = addrs[i + insn->imm] - addrs[i];
+			}
 
 			if (!jmp_offset) {
 				/*
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 7225cb67c0d3a..0b55ebf4a9b1f 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -367,7 +367,12 @@ static int bpf_adj_delta_to_off(struct bpf_insn *insn, u32 pos, s32 end_old,
 {
 	const s32 off_min = S16_MIN, off_max = S16_MAX;
 	s32 delta = end_new - end_old;
-	s32 off = insn->off;
+	s32 off;
+
+	if (insn->code == (BPF_JMP32 | BPF_JA))
+		off = insn->imm;
+	else
+		off = insn->off;
 
 	if (curr < pos && curr + off + 1 >= end_old)
 		off += delta;
@@ -375,8 +380,12 @@ static int bpf_adj_delta_to_off(struct bpf_insn *insn, u32 pos, s32 end_old,
 		off -= delta;
 	if (off < off_min || off > off_max)
 		return -ERANGE;
-	if (!probe_pass)
-		insn->off = off;
+	if (!probe_pass) {
+		if (insn->code == (BPF_JMP32 | BPF_JA))
+			insn->imm = off;
+		else
+			insn->off = off;
+	}
 	return 0;
 }
 
@@ -1586,6 +1595,7 @@ EXPORT_SYMBOL_GPL(__bpf_call_base);
 	INSN_3(JMP, JSLE, K),			\
 	INSN_3(JMP, JSET, K),			\
 	INSN_2(JMP, JA),			\
+	INSN_2(JMP32, JA),			\
 	/* Store instructions. */		\
 	/*   Register based. */			\
 	INSN_3(STX, MEM,  B),			\
@@ -1862,6 +1872,9 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 	JMP_JA:
 		insn += insn->off;
 		CONT;
+	JMP32_JA:
+		insn += insn->imm;
+		CONT;
 	JMP_EXIT:
 		return BPF_R0;
 	/* JMP */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 73d500c51bd86..dd025f66efabc 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2254,7 +2254,10 @@ static int check_subprogs(struct bpf_verifier_env *env)
 			goto next;
 		if (BPF_OP(code) == BPF_EXIT || BPF_OP(code) == BPF_CALL)
 			goto next;
-		off = i + insn[i].off + 1;
+		if (code == (BPF_JMP32 | BPF_JA))
+			off = i + insn[i].imm + 1;
+		else
+			off = i + insn[i].off + 1;
 		if (off < subprog_start || off >= subprog_end) {
 			verbose(env, "jump out of range from insn %d to %d\n", i, off);
 			return -EINVAL;
@@ -2266,6 +2269,7 @@ static int check_subprogs(struct bpf_verifier_env *env)
 			 * or unconditional jump back
 			 */
 			if (code != (BPF_JMP | BPF_EXIT) &&
+			    code != (BPF_JMP32 | BPF_JA) &&
 			    code != (BPF_JMP | BPF_JA)) {
 				verbose(env, "last insn is not an exit or jmp\n");
 				return -EINVAL;
@@ -11116,7 +11120,7 @@ static int visit_func_call_insn(int t, struct bpf_insn *insns,
 static int visit_insn(int t, struct bpf_verifier_env *env)
 {
 	struct bpf_insn *insns = env->prog->insnsi, *insn = &insns[t];
-	int ret;
+	int ret, off;
 
 	if (bpf_pseudo_func(insn))
 		return visit_func_call_insn(t, insns, env, true);
@@ -11144,14 +11148,19 @@ static int visit_insn(int t, struct bpf_verifier_env *env)
 		if (BPF_SRC(insn->code) != BPF_K)
 			return -EINVAL;
 
+		if (BPF_CLASS(insn->code) == BPF_JMP)
+			off = insn->off;
+		else
+			off = insn->imm;
+
 		/* unconditional jump with single edge */
-		ret = push_insn(t, t + insn->off + 1, FALLTHROUGH, env,
+		ret = push_insn(t, t + off + 1, FALLTHROUGH, env,
 				true);
 		if (ret)
 			return ret;
 
-		mark_prune_point(env, t + insn->off + 1);
-		mark_jmp_point(env, t + insn->off + 1);
+		mark_prune_point(env, t + off + 1);
+		mark_jmp_point(env, t + off + 1);
 
 		return ret;
 
@@ -12687,15 +12696,18 @@ static int do_check(struct bpf_verifier_env *env)
 					return err;
 			} else if (opcode == BPF_JA) {
 				if (BPF_SRC(insn->code) != BPF_K ||
-				    insn->imm != 0 ||
 				    insn->src_reg != BPF_REG_0 ||
 				    insn->dst_reg != BPF_REG_0 ||
-				    class == BPF_JMP32) {
+				    (class == BPF_JMP && insn->imm != 0) ||
+				    (class == BPF_JMP32 && insn->off != 0)) {
 					verbose(env, "BPF_JA uses reserved fields\n");
 					return -EINVAL;
 				}
 
-				env->insn_idx += insn->off + 1;
+				if (class == BPF_JMP)
+					env->insn_idx += insn->off + 1;
+				else
+					env->insn_idx += insn->imm + 1;
 				continue;
 
 			} else if (opcode == BPF_EXIT) {
@@ -13521,13 +13533,13 @@ static bool insn_is_cond_jump(u8 code)
 {
 	u8 op;
 
+	op = BPF_OP(code);
 	if (BPF_CLASS(code) == BPF_JMP32)
-		return true;
+		return op != BPF_JA;
 
 	if (BPF_CLASS(code) != BPF_JMP)
 		return false;
 
-	op = BPF_OP(code);
 	return op != BPF_JA && op != BPF_EXIT && op != BPF_CALL;
 }
 
-- 
2.43.0



