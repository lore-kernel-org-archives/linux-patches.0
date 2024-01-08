Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0FC54BCE;
	Mon,  8 Jan 2024 15:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B8K37X0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F844C433C8;
	Mon,  8 Jan 2024 15:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728454;
	bh=FEkHIX3Ai/SlodQ59a4WZZFf8DR3oMRQjhwg9fUCxqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8K37X0tv7m8vbiyZOL1Vlrhw2RH6EljckIrRnL27BmEuv4kNYZ6l+xgD5uj6nDkZ
	 8CwqBNmsX4Kvrc9EdTiiUmuKxxhSgMiiF2NeyW+zHXS63vMug7zd0t9Wp5bABazfFs
	 FwHWAtHl4OXIsD/PndtOJ2zf8MdIV9ka5PGiuODo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/150] bpf: Remove unused insn_cnt argument from visit_[func_call_]insn()
Date: Mon,  8 Jan 2024 16:35:32 +0100
Message-ID: <20240108153514.958785456@linuxfoundation.org>
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

[ Upstream commit dcb2288b1fd9a8cdf2f3b8c0c7b3763346ef515f ]

Number of total instructions in BPF program (including subprogs) can and
is accessed from env->prog->len. visit_func_call_insn() doesn't do any
checks against insn_cnt anymore, relying on push_insn() to do this check
internally. So remove unnecessary insn_cnt input argument from
visit_func_call_insn() and visit_insn() functions.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20221207195534.2866030-1-andrii@kernel.org
Stable-dep-of: 3feb263bb516 ("bpf: handle ldimm64 properly in check_cfg()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 09631797d9e0c..d1393e07ab2c9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11082,8 +11082,7 @@ static int push_insn(int t, int w, int e, struct bpf_verifier_env *env,
 	return DONE_EXPLORING;
 }
 
-static int visit_func_call_insn(int t, int insn_cnt,
-				struct bpf_insn *insns,
+static int visit_func_call_insn(int t, struct bpf_insn *insns,
 				struct bpf_verifier_env *env,
 				bool visit_callee)
 {
@@ -11114,13 +11113,13 @@ static int visit_func_call_insn(int t, int insn_cnt,
  *  DONE_EXPLORING - the instruction was fully explored
  *  KEEP_EXPLORING - there is still work to be done before it is fully explored
  */
-static int visit_insn(int t, int insn_cnt, struct bpf_verifier_env *env)
+static int visit_insn(int t, struct bpf_verifier_env *env)
 {
 	struct bpf_insn *insns = env->prog->insnsi;
 	int ret;
 
 	if (bpf_pseudo_func(insns + t))
-		return visit_func_call_insn(t, insn_cnt, insns, env, true);
+		return visit_func_call_insn(t, insns, env, true);
 
 	/* All non-branch instructions have a single fall-through edge. */
 	if (BPF_CLASS(insns[t].code) != BPF_JMP &&
@@ -11139,7 +11138,7 @@ static int visit_insn(int t, int insn_cnt, struct bpf_verifier_env *env)
 			 * async state will be pushed for further exploration.
 			 */
 			mark_prune_point(env, t);
-		return visit_func_call_insn(t, insn_cnt, insns, env,
+		return visit_func_call_insn(t, insns, env,
 					    insns[t].src_reg == BPF_PSEUDO_CALL);
 
 	case BPF_JA:
@@ -11196,7 +11195,7 @@ static int check_cfg(struct bpf_verifier_env *env)
 	while (env->cfg.cur_stack > 0) {
 		int t = insn_stack[env->cfg.cur_stack - 1];
 
-		ret = visit_insn(t, insn_cnt, env);
+		ret = visit_insn(t, env);
 		switch (ret) {
 		case DONE_EXPLORING:
 			insn_state[t] = EXPLORED;
-- 
2.43.0



