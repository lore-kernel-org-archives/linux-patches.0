Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCD93AEF54;
	Thu, 17 Sep 2026 17:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665733; cv=none; b=iFCKuwa/s7BJb3uwgLLSOo8Rf/2QlbQJgTAurebZ643zWtQGu6C5jfVLzpp4RNBj91nozRNj2M8eDoGC6v/z9iJF54abIABynTYkL+UCZQdM3gwoo4o2mS17huVrCi7B2Jb1BAT5JUgJshPCM5nCagYe2A1lisr4zm11QHm6OVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665733; c=relaxed/simple;
	bh=0vXaI2E1LUW80LaB0q65HIxv2JDXc+8pKnUqH4aI+4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMeA4cSblkf3a90qB+mLRYutdfmKfCpCaAwRV9yIxZyXcj+5snjZKO8SLV447pbxnVBTvRPIjDv5I0amXkjVD4r5X5iRaaHlYoddD2vdvf/9Osf/hyMwi4k8WaWXl80uEDreBuAM4ingna51i/2ojM60og2v554jNqhMRVUa3CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQcsTqkz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQcsTqkz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6F41F000FF;
	Thu, 17 Sep 2026 17:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665732;
	bh=VcJLCZIsCXlfwWsB1CMq0POhP2bkNwm8ECJnJC7mnNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KQcsTqkzoHLaL1cUK2oBP3uxOgq+QADYtp6DNb9zUAuxhTW57oit9iRB8VD5cp20z
	 QkDFhaVtELqPs42c7uwlKqC8ZEOrZD3EJhtIEATM86gGbjsXxtn0Rt3UrG2jaDCS52
	 LE6m+SOloX3BtV2++X5w6ZMQsq5oHy7B6QfZK4T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0775/1250] bpf: Report maximum combined stack depth
Date: Thu, 17 Sep 2026 16:09:30 +0100
Message-ID: <20260917151612.891989925@linuxfoundation.org>
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

[ Upstream commit f41f34ec64748e16e5a90ab391cec39e30942f32 ]

We've hit the 512 bytes limit on stack depth a few times in Cilium
recently. As a result, we started reporting in CI our current maximum
stack depth across all configurations for each BPF program.

Unfortunately, that is not trivial to compute in userspace. The
verifier reports the stack depths of individual subprogs at the end of
the logs. However the maximum combined stack depth also depends on the
callgraph of those subprogs (the max combined stack depth is the height
of the callgraph weighted by per-subprog stack depths). We can compute
a callgraph in userspace from the loaded instructions, but it often
doesn't match the verifier's own callgraph because of dead code
elimination. Our current approach relies on dumping the BPF_LOG_LEVEL2
logs, but this feels overkill considering the verifier already has the
information we need.

The patch lets the verifier dump the maximum combined stack depth in
the logs, on the same line as the per-subprog stack depths:

    stack depth 16+256 max 272

The per-subprog stack depths and the new max stack depth are not
directly comparable. The former is sometimes updated during fixups,
while the latter is not. As a result, even with a single subprog, we
may end up with two slightly different values. The aim of the new max
value is to be closest to what is actually enforced by the verifier.

Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/d3d23a0410f87f116f3bbaa98a815dbae113bda2.1778700777.git.paul.chaignon@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 369f4ce73457 ("bpf: Check ancestor frames for rbtree callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h | 2 ++
 kernel/bpf/verifier.c        | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 11c464dabacf5..80136ecfa6cbc 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -795,6 +795,8 @@ struct bpf_verifier_env {
 	u32 prev_insn_processed, insn_processed;
 	/* number of jmps, calls, exits analyzed so far */
 	u32 prev_jmps_processed, jmps_processed;
+	/* maximum combined stack depth */
+	u32 max_stack_depth;
 	/* total verification time */
 	u64 verification_time;
 	/* maximum number of verifier states kept in 'branching' instructions */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a6d1efb5b44eb..d1def3edb9d1e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6693,6 +6693,8 @@ static int check_max_stack_depth_subprog(struct bpf_verifier_env *env, int idx,
 	}
 
 	if (subprog[idx].priv_stack_mode == PRIV_STACK_ADAPTIVE) {
+		if (subprog_depth > env->max_stack_depth)
+			env->max_stack_depth = subprog_depth;
 		if (subprog_depth > MAX_BPF_STACK) {
 			verbose(env, "stack size of subprog %d is %d. Too large\n",
 				idx, subprog_depth);
@@ -6700,6 +6702,8 @@ static int check_max_stack_depth_subprog(struct bpf_verifier_env *env, int idx,
 		}
 	} else {
 		depth += subprog_depth;
+		if (depth > env->max_stack_depth)
+			env->max_stack_depth = depth;
 		if (depth > MAX_BPF_STACK) {
 			total = 0;
 			for (tmp = idx; tmp >= 0; tmp = dinfo[tmp].caller)
@@ -23849,7 +23853,7 @@ static void print_verification_stats(struct bpf_verifier_env *env)
 		verbose(env, "stack depth %d", env->subprog_info[0].stack_depth);
 		for (i = 1; i < subprog_cnt; i++)
 			verbose(env, "+%d", env->subprog_info[i].stack_depth);
-		verbose(env, "\n");
+		verbose(env, " max %d\n", env->max_stack_depth);
 		verbose(env, "insns processed %d", env->subprog_info[0].insn_processed);
 		for (i = 1; i < subprog_cnt; i++)
 			if (bpf_subprog_is_global(env, i))
-- 
2.53.0



