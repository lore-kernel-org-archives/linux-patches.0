Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522AA51AEF2;
	Thu, 17 Sep 2026 17:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665666; cv=none; b=WqWvt84/gE1EHIMrEJpvH/oh5ppu81uzkFr5QroY71qmgJVGEU7NJjZiRlTTlUM0gICxHpEbp3Mq8LhAuyr1SWp3x0RdUk07nZNQHDI6zLTPgHaBbTMfoiY7TjKlaLIsO4Z785bi6uRcS4dXdvPnlk7jpwwsD4bXqNHUvAMr3HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665666; c=relaxed/simple;
	bh=i4jjnhPoKVb/RNrUX9BdjvGIoq+oiYFA2LHymiDMHsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbpaLG3DzCWm5qq1LUipU+yDKakIyU3Axm7RBHlqaN83cusonFF8AvxfYr3fZ6jUi1gYwaylFUFodPE8XfSX9vROLpT/q0hCxt6EWt8RMW3J1/p/n8OwsT6qwo6zS41ZqEjJxw8Lx9tm4tIGPEZa6wePRlrcIoHipX5xlfmObyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnOq4+Ix; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnOq4+Ix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39341F000FF;
	Thu, 17 Sep 2026 17:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665665;
	bh=SjaIP8WIdldSyvG4u3UUs1V6+JPR+nA0FqJIOFO35Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hnOq4+IxRjvBPBoEZzoBUVOqJzG4TF7jHr7OHSaNOwdMIXQBRP17LXuIw0L87eATW
	 sAjE+ToP5p6NS+2LgzrHr1OkyksbuyjczqeNr3quhiV96LQpL07I8NjOJb1SatvpaP
	 U8RI+D8OPif8Ww16tXLe3GBcOx3gwmB/RwyMOtd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0773/1250] bpf: share several utility functions as internal API
Date: Thu, 17 Sep 2026 16:09:28 +0100
Message-ID: <20260917151612.833985480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 33dfc521c20d02375c8696dcace04037d2a865e6 ]

Namely:
- bpf_subprog_is_global
- bpf_vlog_alignment

Acked-by: Mykyta Yatsenko <yatsenko@meta.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260410-patch-set-v4-1-5d4eecb343db@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 369f4ce73457 ("bpf: Check ancestor frames for rbtree callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h |  2 ++
 kernel/bpf/log.c             |  4 ++--
 kernel/bpf/verifier.c        | 10 +++++-----
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 4867b0e8b5d9d..068a740905583 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -1051,12 +1051,14 @@ void print_verifier_state(struct bpf_verifier_env *env, const struct bpf_verifie
 			  u32 frameno, bool print_all);
 void print_insn_state(struct bpf_verifier_env *env, const struct bpf_verifier_state *vstate,
 		      u32 frameno);
+u32 bpf_vlog_alignment(u32 pos);
 
 struct bpf_subprog_info *bpf_find_containing_subprog(struct bpf_verifier_env *env, int off);
 int bpf_jmp_offset(struct bpf_insn *insn);
 int bpf_insn_successors(struct bpf_prog *prog, u32 idx, u32 succ[2]);
 void bpf_fmt_stack_mask(char *buf, ssize_t buf_sz, u64 stack_mask);
 bool bpf_calls_callback(struct bpf_verifier_env *env, int insn_idx);
+bool bpf_subprog_is_global(const struct bpf_verifier_env *env, int subprog);
 
 int bpf_stack_liveness_init(struct bpf_verifier_env *env);
 void bpf_stack_liveness_free(struct bpf_verifier_env *env);
diff --git a/kernel/bpf/log.c b/kernel/bpf/log.c
index f50533169cc34..a05ef527a0ad8 100644
--- a/kernel/bpf/log.c
+++ b/kernel/bpf/log.c
@@ -842,7 +842,7 @@ void print_verifier_state(struct bpf_verifier_env *env, const struct bpf_verifie
 		mark_verifier_state_clean(env);
 }
 
-static inline u32 vlog_alignment(u32 pos)
+u32 bpf_vlog_alignment(u32 pos)
 {
 	return round_up(max(pos + BPF_LOG_MIN_ALIGNMENT / 2, BPF_LOG_ALIGNMENT),
 			BPF_LOG_MIN_ALIGNMENT) - pos - 1;
@@ -854,7 +854,7 @@ void print_insn_state(struct bpf_verifier_env *env, const struct bpf_verifier_st
 	if (env->prev_log_pos && env->prev_log_pos == env->log.end_pos) {
 		/* remove new line character */
 		bpf_vlog_reset(&env->log, env->prev_log_pos - 1);
-		verbose(env, "%*c;", vlog_alignment(env->prev_insn_print_pos), ' ');
+		verbose(env, "%*c;", bpf_vlog_alignment(env->prev_insn_print_pos), ' ');
 	} else {
 		verbose(env, "%d:", env->insn_idx);
 	}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7411afcba2c21..9c739f62c4895 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -431,7 +431,7 @@ static struct btf_record *reg_btf_record(const struct bpf_reg_state *reg)
 	return rec;
 }
 
-static bool subprog_is_global(const struct bpf_verifier_env *env, int subprog)
+bool bpf_subprog_is_global(const struct bpf_verifier_env *env, int subprog)
 {
 	struct bpf_func_info_aux *aux = env->prog->aux->func_info_aux;
 
@@ -4390,7 +4390,7 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx, int subseq_idx,
 			if (subprog < 0)
 				return -EFAULT;
 
-			if (subprog_is_global(env, subprog)) {
+			if (bpf_subprog_is_global(env, subprog)) {
 				/* check that jump history doesn't have any
 				 * extra instructions from subprog; the next
 				 * instruction after call to global subprog
@@ -6773,7 +6773,7 @@ static int check_max_stack_depth_subprog(struct bpf_verifier_env *env, int idx,
 		if (subprog[idx].has_tail_call)
 			tail_call_reachable = true;
 
-		frame = subprog_is_global(env, idx) ? 0 : frame + 1;
+		frame = bpf_subprog_is_global(env, idx) ? 0 : frame + 1;
 		if (frame >= MAX_CALL_FRAMES) {
 			verbose(env, "the call stack of %d frames is too deep !\n",
 				frame);
@@ -10813,7 +10813,7 @@ static int check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 	err = btf_check_subprog_call(env, subprog, caller->regs);
 	if (err == -EFAULT)
 		return err;
-	if (subprog_is_global(env, subprog)) {
+	if (bpf_subprog_is_global(env, subprog)) {
 		const char *sub_name = subprog_name(env, subprog);
 
 		if (env->cur_state->active_locks) {
@@ -23786,7 +23786,7 @@ static int do_check_subprogs(struct bpf_verifier_env *env)
 again:
 	new_cnt = 0;
 	for (i = 1; i < env->subprog_cnt; i++) {
-		if (!subprog_is_global(env, i))
+		if (!bpf_subprog_is_global(env, i))
 			continue;
 
 		sub_aux = subprog_aux(env, i);
-- 
2.53.0



