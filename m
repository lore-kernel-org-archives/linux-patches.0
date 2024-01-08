Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10404524B8;
	Mon,  8 Jan 2024 15:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMzx9Nax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB73C433C8;
	Mon,  8 Jan 2024 15:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728451;
	bh=IkVwhcTQj3fob4XsOfoAeRa6dYFHu9lwQVOgmOHgVyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMzx9NaxP/RGNFLGb3yhXdDdzdvIAVT5YKg4bv47UHgIZK2ahUExO3InVMJtdvSfA
	 iiWad7l5OtRG115qVikGYioNula0b4szoMN5d9aO8Qy+QPK5t/eG+HopR+AtpK7Mxv
	 sFEE3Sg9cBNOYOnWQsEASW9andZtc+IlyJJ1fP1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/150] bpf: remove unnecessary prune and jump points
Date: Mon,  8 Jan 2024 16:35:31 +0100
Message-ID: <20240108153514.915961820@linuxfoundation.org>
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

[ Upstream commit 618945fbed501b6e5865042068a51edfb2dda948 ]

Don't mark some instructions as jump points when there are actually no
jumps and instructions are just processed sequentially. Such case is
handled naturally by precision backtracking logic without the need to
update jump history. See get_prev_insn_idx(). It goes back linearly by
one instruction, unless current top of jmp_history is pointing to
current instruction. In such case we use `st->jmp_history[cnt - 1].prev_idx`
to find instruction from which we jumped to the current instruction
non-linearly.

Also remove both jump and prune point marking for instruction right
after unconditional jumps, as program flow can get to the instruction
right after unconditional jump instruction only if there is a jump to
that instruction from somewhere else in the program. In such case we'll
mark such instruction as prune/jump point because it's a destination of
a jump.

This change has no changes in terms of number of instructions or states
processes across Cilium and selftests programs.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20221206233345.438540-4-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 3feb263bb516 ("bpf: handle ldimm64 properly in check_cfg()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ec688665aaa25..09631797d9e0c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11093,13 +11093,12 @@ static int visit_func_call_insn(int t, int insn_cnt,
 	if (ret)
 		return ret;
 
-	if (t + 1 < insn_cnt) {
-		mark_prune_point(env, t + 1);
-		mark_jmp_point(env, t + 1);
-	}
+	mark_prune_point(env, t + 1);
+	/* when we exit from subprog, we need to record non-linear history */
+	mark_jmp_point(env, t + 1);
+
 	if (visit_callee) {
 		mark_prune_point(env, t);
-		mark_jmp_point(env, t);
 		ret = push_insn(t, t + insns[t].imm + 1, BRANCH, env,
 				/* It's ok to allow recursion from CFG point of
 				 * view. __check_func_call() will do the actual
@@ -11133,15 +11132,13 @@ static int visit_insn(int t, int insn_cnt, struct bpf_verifier_env *env)
 		return DONE_EXPLORING;
 
 	case BPF_CALL:
-		if (insns[t].imm == BPF_FUNC_timer_set_callback) {
-			/* Mark this call insn to trigger is_state_visited() check
-			 * before call itself is processed by __check_func_call().
-			 * Otherwise new async state will be pushed for further
-			 * exploration.
+		if (insns[t].imm == BPF_FUNC_timer_set_callback)
+			/* Mark this call insn as a prune point to trigger
+			 * is_state_visited() check before call itself is
+			 * processed by __check_func_call(). Otherwise new
+			 * async state will be pushed for further exploration.
 			 */
 			mark_prune_point(env, t);
-			mark_jmp_point(env, t);
-		}
 		return visit_func_call_insn(t, insn_cnt, insns, env,
 					    insns[t].src_reg == BPF_PSEUDO_CALL);
 
@@ -11155,26 +11152,15 @@ static int visit_insn(int t, int insn_cnt, struct bpf_verifier_env *env)
 		if (ret)
 			return ret;
 
-		/* unconditional jmp is not a good pruning point,
-		 * but it's marked, since backtracking needs
-		 * to record jmp history in is_state_visited().
-		 */
 		mark_prune_point(env, t + insns[t].off + 1);
 		mark_jmp_point(env, t + insns[t].off + 1);
-		/* tell verifier to check for equivalent states
-		 * after every call and jump
-		 */
-		if (t + 1 < insn_cnt) {
-			mark_prune_point(env, t + 1);
-			mark_jmp_point(env, t + 1);
-		}
 
 		return ret;
 
 	default:
 		/* conditional jump with two edges */
 		mark_prune_point(env, t);
-		mark_jmp_point(env, t);
+
 		ret = push_insn(t, t + 1, FALLTHROUGH, env, true);
 		if (ret)
 			return ret;
-- 
2.43.0



