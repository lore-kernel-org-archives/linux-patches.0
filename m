Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E683131F9BE;
	Wed, 20 May 2026 16:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294849; cv=none; b=izRwd/nvYPsg0ILYCChzR0IBUwBWTVQZTJW3BdlHTC/8W000IXQiXWUnArzmDS600tGF4b4qIG4i9NBudFejWU0GTQsUGj/v7dUf9t+lGntKG0fYuQ20m6FSQ8ojGz4ugDIEy7Y//JVGf60v+zJXusYM0v/9j5Qd8U9UImiEKSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294849; c=relaxed/simple;
	bh=5STfWjJs7YjB9jjxBlTx2B2KKqKYik698PKV7PBHUhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWuOyTcfacf/82O5gO4zyKxMZ7mznTCf6wbYm5OLxrZlqNFJpjvmzFc3DHQxCVj5tfxbdIwaAt/5GsYhdOiXrx1QiSyiIfdVt75/5gMf659pa6/mTfNbfeOXCCnbl5V9ZXA8YaC0qy34F1ca8SbTNRm5eXuQiZ4bZATeTPd+F0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BMYco4kt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BMYco4kt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8971F000E9;
	Wed, 20 May 2026 16:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294847;
	bh=6FGkH5y6O8fo49nRcMg5H8vH6CzVD0e0Lt+nXtyMXps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BMYco4ktDhamkzvumNvamDs6mACq8uLJ1ktEDsZFffwD29xCBME2Fi4cH1KRsjsC1
	 AmWiNIH1kmEJ2GNR5HuiLbhZFQvhinNDFkaS/Em81ekG6DWS8xrvCmZSZDGVDk1uiq
	 pn6WK5N++lNttNMetzMc4sYSt1mYTs5rvb1OBJpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0168/1146] bpf: Fix ld_{abs,ind} failure path analysis in subprogs
Date: Wed, 20 May 2026 18:06:58 +0200
Message-ID: <20260520162152.091555090@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit ee861486e377edc55361c08dcbceab3f6b6577bd ]

Usage of ld_{abs,ind} instructions got extended into subprogs some time
ago via commit 09b28d76eac4 ("bpf: Add abnormal return checks."). These
are only allowed in subprograms when the latter are BTF annotated and
have scalar return types.

The code generator in bpf_gen_ld_abs() has an abnormal exit path (r0=0 +
exit) from legacy cBPF times. While the enforcement is on scalar return
types, the verifier must also simulate the path of abnormal exit if the
packet data load via ld_{abs,ind} failed.

This is currently not the case. Fix it by having the verifier simulate
both success and failure paths, and extend it in similar ways as we do
for tail calls. The success path (r0=unknown, continue to next insn) is
pushed onto stack for later validation and the r0=0 and return to the
caller is done on the fall-through side.

Fixes: 09b28d76eac4 ("bpf: Add abnormal return checks.")
Reported-by: STAR Labs SG <info@starlabs.sg>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260408191242.526279-2-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2949cdc7565f7..71c078d18683a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -17943,6 +17943,23 @@ static int check_ld_abs(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	mark_reg_unknown(env, regs, BPF_REG_0);
 	/* ld_abs load up to 32-bit skb data. */
 	regs[BPF_REG_0].subreg_def = env->insn_idx + 1;
+	/*
+	 * See bpf_gen_ld_abs() which emits a hidden BPF_EXIT with r0=0
+	 * which must be explored by the verifier when in a subprog.
+	 */
+	if (env->cur_state->curframe) {
+		struct bpf_verifier_state *branch;
+
+		mark_reg_scratched(env, BPF_REG_0);
+		branch = push_stack(env, env->insn_idx + 1, env->insn_idx, false);
+		if (IS_ERR(branch))
+			return PTR_ERR(branch);
+		mark_reg_known_zero(env, regs, BPF_REG_0);
+		err = prepare_func_exit(env, &env->insn_idx);
+		if (err)
+			return err;
+		env->insn_idx--;
+	}
 	return 0;
 }
 
@@ -18815,7 +18832,12 @@ static int visit_gotox_insn(int t, struct bpf_verifier_env *env)
 	return keep_exploring ? KEEP_EXPLORING : DONE_EXPLORING;
 }
 
-static int visit_tailcall_insn(struct bpf_verifier_env *env, int t)
+/*
+ * Instructions that can abnormally return from a subprog (tail_call
+ * upon success, ld_{abs,ind} upon load failure) have a hidden exit
+ * that the verifier must account for.
+ */
+static int visit_abnormal_return_insn(struct bpf_verifier_env *env, int t)
 {
 	static struct bpf_subprog_info *subprog;
 	struct bpf_iarray *jt;
@@ -18850,6 +18872,13 @@ static int visit_insn(int t, struct bpf_verifier_env *env)
 	/* All non-branch instructions have a single fall-through edge. */
 	if (BPF_CLASS(insn->code) != BPF_JMP &&
 	    BPF_CLASS(insn->code) != BPF_JMP32) {
+		if (BPF_CLASS(insn->code) == BPF_LD &&
+		    (BPF_MODE(insn->code) == BPF_ABS ||
+		     BPF_MODE(insn->code) == BPF_IND)) {
+			ret = visit_abnormal_return_insn(env, t);
+			if (ret)
+				return ret;
+		}
 		insn_sz = bpf_is_ldimm64(insn) ? 2 : 1;
 		return push_insn(t, t + insn_sz, FALLTHROUGH, env);
 	}
@@ -18895,7 +18924,7 @@ static int visit_insn(int t, struct bpf_verifier_env *env)
 			if (bpf_helper_changes_pkt_data(insn->imm))
 				mark_subprog_changes_pkt_data(env, t);
 			if (insn->imm == BPF_FUNC_tail_call) {
-				ret = visit_tailcall_insn(env, t);
+				ret = visit_abnormal_return_insn(env, t);
 				if (ret)
 					return ret;
 			}
-- 
2.53.0



