Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2520F49D59F;
	Thu, 17 Sep 2026 17:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665699; cv=none; b=NZt/fQRg+Vxc2/Zz8bzBA8FujWL+O5RclbWKW0093agwgF8T4kE9FFn1Q4KzYkRJPCCqhpdmhDivfHHTcS40Kb/0wp9OE7s4/8giepGhS3+0zcvMlr65SHMzDkmSZxGYkKk+Hv9JGpvvZnIsf0m6ZdOso3eukcjf8JiedRDhzrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665699; c=relaxed/simple;
	bh=7eK/jiqbYugK9LCdZvxrF0JiflkYH2TQa7iP67ZkgSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIFWXWyrJKLgKV+904CU3xz7NQk93gjR/mWfliRTy1YG7fQSZ0TGbu2aLH9iKpSB+nOEkwrjnOb4fGrIfC3JW/umfAa4p7OhxrQiI6WSyPRWTXujtLsNOWI7b/SYVkr1u9p5WfeyLykMy+PUsfOp+qk5HWKF90KxWB6ykDgnFnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eyb99j7Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eyb99j7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF9C1F000FF;
	Thu, 17 Sep 2026 17:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665698;
	bh=7DlBdhLTol0VYaltGp8w5N/BlOmXvOYH8yuhvTIwD5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eyb99j7Y9uyPIGHe/ZSoO/6sTYbTsGW0c38Fl2br0wt8W9rhKUnZjTLrvlwNfeW/b
	 zu6Np6qcaAFJ8a4Y1ygm//5RolDer+yKW4ABM5R/l13eaQnfaO/5Utw9dT++JXEQy1
	 2d4M+IwDsDQI+0rv7R5rlfbNlwAzqdg/wGMv/DVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0774/1250] bpf: Print breakdown of insns processed by subprogs
Date: Thu, 17 Sep 2026 16:09:29 +0100
Message-ID: <20260917151612.863931607@linuxfoundation.org>
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

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit f603e84ab7918db6470c0b06b46ece7fbdb71e9a ]

When using global functions (i.e. subprogs), the verifier performs
function-by-function verification. In that case, the sum of the
instructions processed in each global function and in the main program
counts towards the 1 million instructions limit. Only that sum is
reported in the verifier logs.

While starting to use global functions in Cilium (finally!), we found it
can be useful to have the breakdown per global function, to understand
exactly where the budget is currently spent. This patch implements this
breakdown, under BPF_LOG_STATS, as done for the stack depths.

When iterating over subprogs, we need to skip the hidden subprogs at the
end because they don't have a corresponding func_info_aux entry and
calling bpf_subprog_is_global() would result in an OOB access.

Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/bpf/5590f9c67e614ec9054d0c7e74e87cc690a52c56.1777538384.git.paul.chaignon@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Stable-dep-of: 369f4ce73457 ("bpf: Check ancestor frames for rbtree callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h |  1 +
 kernel/bpf/verifier.c        | 25 ++++++++++++++++---------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 068a740905583..11c464dabacf5 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -648,6 +648,7 @@ struct bpf_subprog_info {
 	u32 postorder_start; /* The idx to the env->cfg.insn_postorder */
 	u16 stack_depth; /* max. stack depth used by this function */
 	u16 stack_extra;
+	u32 insn_processed;
 	/* offsets in range [stack_depth .. fastcall_stack_off)
 	 * are used for bpf_fastcall spills and fills.
 	 */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9c739f62c4895..a6d1efb5b44eb 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -23775,6 +23775,7 @@ static int do_check_subprogs(struct bpf_verifier_env *env)
 	struct bpf_prog_aux *aux = env->prog->aux;
 	struct bpf_func_info_aux *sub_aux;
 	int i, ret, new_cnt;
+	u32 insn_processed;
 
 	if (!aux->func_info)
 		return 0;
@@ -23789,6 +23790,8 @@ static int do_check_subprogs(struct bpf_verifier_env *env)
 		if (!bpf_subprog_is_global(env, i))
 			continue;
 
+		insn_processed = env->insn_processed;
+
 		sub_aux = subprog_aux(env, i);
 		if (!sub_aux->called || sub_aux->verified)
 			continue;
@@ -23796,6 +23799,7 @@ static int do_check_subprogs(struct bpf_verifier_env *env)
 		env->insn_idx = env->subprog_info[i].start;
 		WARN_ON_ONCE(env->insn_idx == 0);
 		ret = do_check_common(env, i);
+		env->subprog_info[i].insn_processed = env->insn_processed - insn_processed;
 		if (ret) {
 			return ret;
 		} else if (env->log.level & BPF_LOG_LEVEL) {
@@ -23822,10 +23826,12 @@ static int do_check_subprogs(struct bpf_verifier_env *env)
 
 static int do_check_main(struct bpf_verifier_env *env)
 {
+	u32 insn_processed = env->insn_processed;
 	int ret;
 
 	env->insn_idx = 0;
 	ret = do_check_common(env, 0);
+	env->subprog_info[0].insn_processed = env->insn_processed - insn_processed;
 	if (!ret)
 		env->prog->aux->stack_depth = env->subprog_info[0].stack_depth;
 	return ret;
@@ -23834,19 +23840,20 @@ static int do_check_main(struct bpf_verifier_env *env)
 
 static void print_verification_stats(struct bpf_verifier_env *env)
 {
-	int i;
+	/* Skip over hidden subprogs which are not verified. */
+	int i, subprog_cnt = env->subprog_cnt - env->hidden_subprog_cnt;
 
 	if (env->log.level & BPF_LOG_STATS) {
 		verbose(env, "verification time %lld usec\n",
 			div_u64(env->verification_time, 1000));
-		verbose(env, "stack depth ");
-		for (i = 0; i < env->subprog_cnt; i++) {
-			u32 depth = env->subprog_info[i].stack_depth;
-
-			verbose(env, "%d", depth);
-			if (i + 1 < env->subprog_cnt)
-				verbose(env, "+");
-		}
+		verbose(env, "stack depth %d", env->subprog_info[0].stack_depth);
+		for (i = 1; i < subprog_cnt; i++)
+			verbose(env, "+%d", env->subprog_info[i].stack_depth);
+		verbose(env, "\n");
+		verbose(env, "insns processed %d", env->subprog_info[0].insn_processed);
+		for (i = 1; i < subprog_cnt; i++)
+			if (bpf_subprog_is_global(env, i))
+				verbose(env, "+%d", env->subprog_info[i].insn_processed);
 		verbose(env, "\n");
 	}
 	verbose(env, "processed %d insns (limit %d) max_states_per_insn %d "
-- 
2.53.0



