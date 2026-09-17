Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D71501F26;
	Thu, 17 Sep 2026 15:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659533; cv=none; b=rCaRFkb9WtQrlGXagelyqicJPmWhgPKu5c58/Q6yAP611i84QWoA3wnn5qB0xvtROJfJElhajp7yH/CQRtGUYHEx9c7ncUcyjRlhSnHoewXOWlVF0zmxzxdZMK0mNWITsNRnYzEWudaCdYRgZwYv7Fkqe6XJs8iJIW+s6LHX190=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659533; c=relaxed/simple;
	bh=seHjh1vWe+g6zmrlZtmdT1FygJuW91Mq3GN8ViD0qMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V04XkNkCoUmpGXnkZulldpRBtzZ6D5ZRjUosY+AQXaRd/wAqkg0bvbtu2CPEzDaQRO6atMBmhFlM/A6LZVtZchFFyCEtcm22Trt3LqrZ3yM93NEkeRhJsBdwuzPUrOmmv0+pbLJDsO8jBpnbscuqXNTkCDRnWwJobQhcIAj1U7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZnRDKej; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZnRDKej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DCE1F00893;
	Thu, 17 Sep 2026 15:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659522;
	bh=NGodG6yVhZzkVza7smFteHsmKTcWa3eGGbXj48ArjB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZnRDKej89g4vu+P4ltM4Mr4ib1ai5clopCkXDT1yrtiIT4CwUJAjSbdfUoYDQG6j
	 mn0RCRkaGO4QwlF54varmC/pGRhg11i9a6+07PncFYVC8I6+veyy7TREWBos7kRFgH
	 1nmRw4GUcfvWKpTHcvXM4y6jJNPOtsMIRkSfBfe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 248/733] bpf: dont rewrite bpf_fastcall patterns entered by a jump
Date: Thu, 17 Sep 2026 16:09:16 +0100
Message-ID: <20260917151357.464723632@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 0b1c83dc3c4401cd7e846548f62e3caf3d06742e ]

mark_fastcall_pattern_for_call() must ensure that matched
"spill; call; fill" instruction series is not interrupted by a jump.
Otherwise the rewrite applied by bpf_remove_fastcall_spills_fills()
is not sound.

Record the instructions targeted by jumps in
insn_aux_data[*].jump_target when the CFG is built and use this flag
to stop growing a pattern at such an instruction. Jumps to the first
spill are fine.

Note that existing insn_aux_data[*].jmp_point field can't be reused,
as it marks subprogram return instructions.

Fixes: 5b5f51bff1b6 ("bpf: no_caller_saved_registers attribute for helper calls")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260903205820.1743087-1-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h | 12 ++++++++++++
 kernel/bpf/cfg.c             |  3 +++
 kernel/bpf/verifier.c        |  8 ++++++++
 3 files changed, 23 insertions(+)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 39a851e690ec4..ad7b8335ebc82 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -704,6 +704,8 @@ struct bpf_insn_aux_data {
 	 */
 	u32 calls_callback:1;
 	u32 indirect_target:1; /* if it is an indirect jump target */
+	/* true if some jump or call instruction targets this instruction */
+	u32 jump_target:1;
 	/*
 	 * CFG strongly connected component this instruction belongs to,
 	 * zero if it is a singleton SCC.
@@ -1115,6 +1117,16 @@ static inline void mark_jmp_point(struct bpf_verifier_env *env, int idx)
 	env->insn_aux_data[idx].jmp_point = true;
 }
 
+static inline void mark_jump_target(struct bpf_verifier_env *env, int idx)
+{
+	env->insn_aux_data[idx].jump_target = true;
+}
+
+static inline bool bpf_is_jump_target(struct bpf_verifier_env *env, int insn_idx)
+{
+	return env->insn_aux_data[insn_idx].jump_target;
+}
+
 static inline struct bpf_func_state *cur_func(struct bpf_verifier_env *env)
 {
 	struct bpf_verifier_state *cur = env->cur_state;
diff --git a/kernel/bpf/cfg.c b/kernel/bpf/cfg.c
index 26d37066465f3..d5fc03f12969b 100644
--- a/kernel/bpf/cfg.c
+++ b/kernel/bpf/cfg.c
@@ -120,6 +120,7 @@ static int push_insn(int t, int w, int e, struct bpf_verifier_env *env)
 		/* mark branch target for state pruning */
 		mark_prune_point(env, w);
 		mark_jmp_point(env, w);
+		mark_jump_target(env, w);
 	}
 
 	if (insn_state[w] == 0) {
@@ -378,6 +379,7 @@ static int visit_gotox_insn(int t, struct bpf_verifier_env *env)
 		}
 
 		mark_jmp_point(env, w);
+		mark_jump_target(env, w);
 
 		/* EXPLORED || DISCOVERED */
 		if (insn_state[w])
@@ -539,6 +541,7 @@ static int visit_insn(int t, struct bpf_verifier_env *env)
 
 		mark_prune_point(env, t + off + 1);
 		mark_jmp_point(env, t + off + 1);
+		mark_jump_target(env, t + off + 1);
 
 		return ret;
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index bc5aea31df589..d1f6365e2a817 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -16856,6 +16856,10 @@ bool bpf_get_call_summary(struct bpf_verifier_env *env, struct bpf_insn *call,
  *   r0 = *(u64 *)(r10 - 8);             r0 += r1;
  *   r0 += r1;                           exit;
  *   exit;
+ *
+ * Both uses of the marks assume that a pattern is entered at its first
+ * spill and thus executes as a unit, hence a pattern is not grown past
+ * an instruction targeted by a jump.
  */
 static void mark_fastcall_pattern_for_call(struct bpf_verifier_env *env,
 					   struct bpf_subprog_info *subprog,
@@ -16894,6 +16898,10 @@ static void mark_fastcall_pattern_for_call(struct bpf_verifier_env *env,
 	for (i = 1, off = lowest_off; i <= ARRAY_SIZE(caller_saved); ++i, off += BPF_REG_SIZE) {
 		if (insn_idx - i < 0 || insn_idx + i >= env->prog->len)
 			break;
+		/* stx/ldx/call must not be a jump targets, a jump to the first stx is fine */
+		if (bpf_is_jump_target(env, insn_idx - i + 1) ||
+		    bpf_is_jump_target(env, insn_idx + i))
+			break;
 		stx = &insns[insn_idx - i];
 		ldx = &insns[insn_idx + i];
 		/* must be a stack spill/fill pair */
-- 
2.53.0



