Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBBD1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147EDC433EF;
	Wed, 28 Dec 2022 14:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239245;
	bh=f5Ylzdt0I4y/KUQdCpfnsRnQLYSZan6Yt+T4hdefR0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uuDHblZ/SWT7/kRtvCxLksbswZmhavCaT5pSwO6yIgMl1+ZinReImdJwJI7hBDaAn
	 AQZ6toGhlPx9oYJuN80T8vilbsaaSs8OzE2I7qJe2wjwqj1BvOW6L3r9SGWRAlaDSp
	 MnWCLdIN37QpJ8lhy7Bv0pWwhGLBsq3y7aHyABDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 184/731] bpf: propagate precision across all frames, not just the last one
Date: Wed, 28 Dec 2022 15:34:51 +0100
Message-Id: <20221228144301.895258603@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 529409ea92d590659be487ba0839710329bd8074 ]

When equivalent completed state is found and it has additional precision
restrictions, BPF verifier propagates precision to
currently-being-verified state chain (i.e., including parent states) so
that if some of the states in the chain are not yet completed, necessary
precision restrictions are enforced.

Unfortunately, right now this happens only for the last frame (deepest
active subprogram's frame), not all the frames. This can lead to
incorrect matching of states due to missing precision marker. Currently
this doesn't seem possible as BPF verifier forces everything to precise
when validated BPF program has any subprograms. But with the next patch
lifting this restriction, this becomes problematic.

In fact, without this fix, we'll start getting failure in one of the
existing test_verifier test cases:

  #906/p precise: cross frame pruning FAIL
  Unexpected success to load!
  verification time 48 usec
  stack depth 0+0
  processed 26 insns (limit 1000000) max_states_per_insn 3 total_states 17 peak_states 17 mark_read 8

This patch adds precision propagation across all frames.

Fixes: a3ce685dd01a ("bpf: fix precision tracking")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20221104163649.121784-3-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 71 ++++++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 32 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a0a1061eabb1..b1ca4dbdeecf 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2369,7 +2369,7 @@ static void mark_all_scalars_precise(struct bpf_verifier_env *env,
 		}
 }
 
-static int __mark_chain_precision(struct bpf_verifier_env *env, int regno,
+static int __mark_chain_precision(struct bpf_verifier_env *env, int frame, int regno,
 				  int spi)
 {
 	struct bpf_verifier_state *st = env->cur_state;
@@ -2386,7 +2386,7 @@ static int __mark_chain_precision(struct bpf_verifier_env *env, int regno,
 	if (!env->bpf_capable)
 		return 0;
 
-	func = st->frame[st->curframe];
+	func = st->frame[frame];
 	if (regno >= 0) {
 		reg = &func->regs[regno];
 		if (reg->type != SCALAR_VALUE) {
@@ -2467,7 +2467,7 @@ static int __mark_chain_precision(struct bpf_verifier_env *env, int regno,
 			break;
 
 		new_marks = false;
-		func = st->frame[st->curframe];
+		func = st->frame[frame];
 		bitmap_from_u64(mask, reg_mask);
 		for_each_set_bit(i, mask, 32) {
 			reg = &func->regs[i];
@@ -2533,12 +2533,17 @@ static int __mark_chain_precision(struct bpf_verifier_env *env, int regno,
 
 static int mark_chain_precision(struct bpf_verifier_env *env, int regno)
 {
-	return __mark_chain_precision(env, regno, -1);
+	return __mark_chain_precision(env, env->cur_state->curframe, regno, -1);
 }
 
-static int mark_chain_precision_stack(struct bpf_verifier_env *env, int spi)
+static int mark_chain_precision_frame(struct bpf_verifier_env *env, int frame, int regno)
 {
-	return __mark_chain_precision(env, -1, spi);
+	return __mark_chain_precision(env, frame, regno, -1);
+}
+
+static int mark_chain_precision_stack_frame(struct bpf_verifier_env *env, int frame, int spi)
+{
+	return __mark_chain_precision(env, frame, -1, spi);
 }
 
 static bool is_spillable_regtype(enum bpf_reg_type type)
@@ -10543,34 +10548,36 @@ static int propagate_precision(struct bpf_verifier_env *env,
 {
 	struct bpf_reg_state *state_reg;
 	struct bpf_func_state *state;
-	int i, err = 0;
+	int i, err = 0, fr;
 
-	state = old->frame[old->curframe];
-	state_reg = state->regs;
-	for (i = 0; i < BPF_REG_FP; i++, state_reg++) {
-		if (state_reg->type != SCALAR_VALUE ||
-		    !state_reg->precise)
-			continue;
-		if (env->log.level & BPF_LOG_LEVEL2)
-			verbose(env, "propagating r%d\n", i);
-		err = mark_chain_precision(env, i);
-		if (err < 0)
-			return err;
-	}
+	for (fr = old->curframe; fr >= 0; fr--) {
+		state = old->frame[fr];
+		state_reg = state->regs;
+		for (i = 0; i < BPF_REG_FP; i++, state_reg++) {
+			if (state_reg->type != SCALAR_VALUE ||
+			    !state_reg->precise)
+				continue;
+			if (env->log.level & BPF_LOG_LEVEL2)
+				verbose(env, "frame %d: propagating r%d\n", i, fr);
+			err = mark_chain_precision_frame(env, fr, i);
+			if (err < 0)
+				return err;
+		}
 
-	for (i = 0; i < state->allocated_stack / BPF_REG_SIZE; i++) {
-		if (!is_spilled_reg(&state->stack[i]))
-			continue;
-		state_reg = &state->stack[i].spilled_ptr;
-		if (state_reg->type != SCALAR_VALUE ||
-		    !state_reg->precise)
-			continue;
-		if (env->log.level & BPF_LOG_LEVEL2)
-			verbose(env, "propagating fp%d\n",
-				(-i - 1) * BPF_REG_SIZE);
-		err = mark_chain_precision_stack(env, i);
-		if (err < 0)
-			return err;
+		for (i = 0; i < state->allocated_stack / BPF_REG_SIZE; i++) {
+			if (!is_spilled_reg(&state->stack[i]))
+				continue;
+			state_reg = &state->stack[i].spilled_ptr;
+			if (state_reg->type != SCALAR_VALUE ||
+			    !state_reg->precise)
+				continue;
+			if (env->log.level & BPF_LOG_LEVEL2)
+				verbose(env, "frame %d: propagating fp%d\n",
+					(-i - 1) * BPF_REG_SIZE, fr);
+			err = mark_chain_precision_stack_frame(env, fr, i);
+			if (err < 0)
+				return err;
+		}
 	}
 	return 0;
 }
-- 
2.35.1



