Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1A5381D7;
	Fri, 24 Nov 2023 18:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B7k6v7pn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A5AC433C7;
	Fri, 24 Nov 2023 18:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849439;
	bh=u3BNKGYDqlWzhp7vYxaS6Xwn0myrdHVNnL1mnGbKRnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7k6v7pn3xvXvhCIMJjskEjDth2bdw8d+oEXPSFj9nx3FZRulfpuV1c+p5+LdKPWU
	 8/W/v8LUyI4d2MYV+Y/U2UDczWPlKtmj5hxeRQ8Sbi20ectuuzXaV2/T8aLG/rEPh/
	 zgqk00ced6Sbfw5AlwpiUJoH4Ys7rXxWWODUs6P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Hao Sun <sunhao.th@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 181/530] bpf: fix control-flow graph checking in privileged mode
Date: Fri, 24 Nov 2023 17:45:47 +0000
Message-ID: <20231124172033.579760516@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 10e14e9652bf9e8104151bfd9200433083deae3d ]

When BPF program is verified in privileged mode, BPF verifier allows
bounded loops. This means that from CFG point of view there are
definitely some back-edges. Original commit adjusted check_cfg() logic
to not detect back-edges in control flow graph if they are resulting
from conditional jumps, which the idea that subsequent full BPF
verification process will determine whether such loops are bounded or
not, and either accept or reject the BPF program. At least that's my
reading of the intent.

Unfortunately, the implementation of this idea doesn't work correctly in
all possible situations. Conditional jump might not result in immediate
back-edge, but just a few unconditional instructions later we can arrive
at back-edge. In such situations check_cfg() would reject BPF program
even in privileged mode, despite it might be bounded loop. Next patch
adds one simple program demonstrating such scenario.

To keep things simple, instead of trying to detect back edges in
privileged mode, just assume every back edge is valid and let subsequent
BPF verification prove or reject bounded loops.

Note a few test changes. For unknown reason, we have a few tests that
are specified to detect a back-edge in a privileged mode, but looking at
their code it seems like the right outcome is passing check_cfg() and
letting subsequent verification to make a decision about bounded or not
bounded looping.

Bounded recursion case is also interesting. The example should pass, as
recursion is limited to just a few levels and so we never reach maximum
number of nested frames and never exhaust maximum stack depth. But the
way that max stack depth logic works today it falsely detects this as
exceeding max nested frame count. This patch series doesn't attempt to
fix this orthogonal problem, so we just adjust expected verifier failure.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Fixes: 2589726d12a1 ("bpf: introduce bounded loops")
Reported-by: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20231110061412.2995786-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c                         | 23 +++++++------------
 .../selftests/bpf/progs/verifier_loops1.c     |  9 +++++---
 tools/testing/selftests/bpf/verifier/calls.c  |  6 ++---
 3 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a35e9b52280b2..3e6bc21d6b17c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14751,8 +14751,7 @@ enum {
  * w - next instruction
  * e - edge
  */
-static int push_insn(int t, int w, int e, struct bpf_verifier_env *env,
-		     bool loop_ok)
+static int push_insn(int t, int w, int e, struct bpf_verifier_env *env)
 {
 	int *insn_stack = env->cfg.insn_stack;
 	int *insn_state = env->cfg.insn_state;
@@ -14784,7 +14783,7 @@ static int push_insn(int t, int w, int e, struct bpf_verifier_env *env,
 		insn_stack[env->cfg.cur_stack++] = w;
 		return KEEP_EXPLORING;
 	} else if ((insn_state[w] & 0xF0) == DISCOVERED) {
-		if (loop_ok && env->bpf_capable)
+		if (env->bpf_capable)
 			return DONE_EXPLORING;
 		verbose_linfo(env, t, "%d: ", t);
 		verbose_linfo(env, w, "%d: ", w);
@@ -14807,7 +14806,7 @@ static int visit_func_call_insn(int t, struct bpf_insn *insns,
 	int ret, insn_sz;
 
 	insn_sz = bpf_is_ldimm64(&insns[t]) ? 2 : 1;
-	ret = push_insn(t, t + insn_sz, FALLTHROUGH, env, false);
+	ret = push_insn(t, t + insn_sz, FALLTHROUGH, env);
 	if (ret)
 		return ret;
 
@@ -14817,12 +14816,7 @@ static int visit_func_call_insn(int t, struct bpf_insn *insns,
 
 	if (visit_callee) {
 		mark_prune_point(env, t);
-		ret = push_insn(t, t + insns[t].imm + 1, BRANCH, env,
-				/* It's ok to allow recursion from CFG point of
-				 * view. __check_func_call() will do the actual
-				 * check.
-				 */
-				bpf_pseudo_func(insns + t));
+		ret = push_insn(t, t + insns[t].imm + 1, BRANCH, env);
 	}
 	return ret;
 }
@@ -14844,7 +14838,7 @@ static int visit_insn(int t, struct bpf_verifier_env *env)
 	if (BPF_CLASS(insn->code) != BPF_JMP &&
 	    BPF_CLASS(insn->code) != BPF_JMP32) {
 		insn_sz = bpf_is_ldimm64(insn) ? 2 : 1;
-		return push_insn(t, t + insn_sz, FALLTHROUGH, env, false);
+		return push_insn(t, t + insn_sz, FALLTHROUGH, env);
 	}
 
 	switch (BPF_OP(insn->code)) {
@@ -14891,8 +14885,7 @@ static int visit_insn(int t, struct bpf_verifier_env *env)
 			off = insn->imm;
 
 		/* unconditional jump with single edge */
-		ret = push_insn(t, t + off + 1, FALLTHROUGH, env,
-				true);
+		ret = push_insn(t, t + off + 1, FALLTHROUGH, env);
 		if (ret)
 			return ret;
 
@@ -14905,11 +14898,11 @@ static int visit_insn(int t, struct bpf_verifier_env *env)
 		/* conditional jump with two edges */
 		mark_prune_point(env, t);
 
-		ret = push_insn(t, t + 1, FALLTHROUGH, env, true);
+		ret = push_insn(t, t + 1, FALLTHROUGH, env);
 		if (ret)
 			return ret;
 
-		return push_insn(t, t + insn->off + 1, BRANCH, env, true);
+		return push_insn(t, t + insn->off + 1, BRANCH, env);
 	}
 }
 
diff --git a/tools/testing/selftests/bpf/progs/verifier_loops1.c b/tools/testing/selftests/bpf/progs/verifier_loops1.c
index 5bc86af80a9ad..71735dbf33d4f 100644
--- a/tools/testing/selftests/bpf/progs/verifier_loops1.c
+++ b/tools/testing/selftests/bpf/progs/verifier_loops1.c
@@ -75,9 +75,10 @@ l0_%=:	r0 += 1;					\
 "	::: __clobber_all);
 }
 
-SEC("tracepoint")
+SEC("socket")
 __description("bounded loop, start in the middle")
-__failure __msg("back-edge")
+__success
+__failure_unpriv __msg_unpriv("back-edge")
 __naked void loop_start_in_the_middle(void)
 {
 	asm volatile ("					\
@@ -136,7 +137,9 @@ l0_%=:	exit;						\
 
 SEC("tracepoint")
 __description("bounded recursion")
-__failure __msg("back-edge")
+__failure
+/* verifier limitation in detecting max stack depth */
+__msg("the call stack of 8 frames is too deep !")
 __naked void bounded_recursion(void)
 {
 	asm volatile ("					\
diff --git a/tools/testing/selftests/bpf/verifier/calls.c b/tools/testing/selftests/bpf/verifier/calls.c
index 1bdf2b43e49ea..3d5cd51071f04 100644
--- a/tools/testing/selftests/bpf/verifier/calls.c
+++ b/tools/testing/selftests/bpf/verifier/calls.c
@@ -442,7 +442,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
-	.errstr = "back-edge from insn 0 to 0",
+	.errstr = "the call stack of 9 frames is too deep",
 	.result = REJECT,
 },
 {
@@ -799,7 +799,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
-	.errstr = "back-edge",
+	.errstr = "the call stack of 9 frames is too deep",
 	.result = REJECT,
 },
 {
@@ -811,7 +811,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
-	.errstr = "back-edge",
+	.errstr = "the call stack of 9 frames is too deep",
 	.result = REJECT,
 },
 {
-- 
2.42.0



