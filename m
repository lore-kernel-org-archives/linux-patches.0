Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE1627CCC7;
	Wed, 23 Apr 2025 15:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421382; cv=none; b=m7vhHprKrWC2MXweIWtZhBfijvjTKCq4PoeR/Ttqtaqrg0VgioYdScZ0BaeyFV5qFxC1ZLBrtsfGkLiyHa0dvb0Pxayb07rjNFCXqJS5EgZ+akgE5CJ3e0t8I+NpjIy16Jbu4o02trR2uEMteTI8BO+niiQqyXmTGBgNJBcVJNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421382; c=relaxed/simple;
	bh=8fg7TNmoO0ppj8v6xntVWLEaZtBCc9+Hbxo84MWEx+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpItHyy1sxEh2YjQ50CLfrJycTtTzoGs1wPCnoTH4zMyLA/g8HiqToiINU52IiAj0IH2VcSXH8uO2T6qkpT6Mt5WlfkPvjl4Tf1pObuhQix8S38LYblJbo6gWVw8vgsX68V+kHOTDKuM6POwbBepntOdB0coH1F1dPkvkZMOe74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSLKVu02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSLKVu02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F173C4CEE3;
	Wed, 23 Apr 2025 15:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421381;
	bh=8fg7TNmoO0ppj8v6xntVWLEaZtBCc9+Hbxo84MWEx+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSLKVu020eAiiQPpRS/nSnnMf3BCoUrUnrLCr6SNJZYDJGXzROJZibC6Vti1GqPf7
	 fFp3M0EeBxbJaofM6uVBs7BcgS50d8mASyYGDOxbqIzalgYBzrQjgfHy1YLZbgucaW
	 cxV0+3FReuGs/hRi2gU1cYwtw14o1jy/955CjT2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Zavaritsky <mejedi@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.12 216/223] bpf: track changes_pkt_data property for global functions
Date: Wed, 23 Apr 2025 16:44:48 +0200
Message-ID: <20250423142625.964938108@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

commit 51081a3f25c742da5a659d7fc6fd77ebfdd555be upstream.

When processing calls to certain helpers, verifier invalidates all
packet pointers in a current state. For example, consider the
following program:

    __attribute__((__noinline__))
    long skb_pull_data(struct __sk_buff *sk, __u32 len)
    {
        return bpf_skb_pull_data(sk, len);
    }

    SEC("tc")
    int test_invalidate_checks(struct __sk_buff *sk)
    {
        int *p = (void *)(long)sk->data;
        if ((void *)(p + 1) > (void *)(long)sk->data_end) return TCX_DROP;
        skb_pull_data(sk, 0);
        *p = 42;
        return TCX_PASS;
    }

After a call to bpf_skb_pull_data() the pointer 'p' can't be used
safely. See function filter.c:bpf_helper_changes_pkt_data() for a list
of such helpers.

At the moment verifier invalidates packet pointers when processing
helper function calls, and does not traverse global sub-programs when
processing calls to global sub-programs. This means that calls to
helpers done from global sub-programs do not invalidate pointers in
the caller state. E.g. the program above is unsafe, but is not
rejected by verifier.

This commit fixes the omission by computing field
bpf_subprog_info->changes_pkt_data for each sub-program before main
verification pass.
changes_pkt_data should be set if:
- subprogram calls helper for which bpf_helper_changes_pkt_data
  returns true;
- subprogram calls a global function,
  for which bpf_subprog_info->changes_pkt_data should be set.

The verifier.c:check_cfg() pass is modified to compute this
information. The commit relies on depth first instruction traversal
done by check_cfg() and absence of recursive function calls:
- check_cfg() would eventually visit every call to subprogram S in a
  state when S is fully explored;
- when S is fully explored:
  - every direct helper call within S is explored
    (and thus changes_pkt_data is set if needed);
  - every call to subprogram S1 called by S was visited with S1 fully
    explored (and thus S inherits changes_pkt_data from S1).

The downside of such approach is that dead code elimination is not
taken into account: if a helper call inside global function is dead
because of current configuration, verifier would conservatively assume
that the call occurs for the purpose of the changes_pkt_data
computation.

Reported-by: Nick Zavaritsky <mejedi@gmail.com>
Closes: https://lore.kernel.org/bpf/0498CA22-5779-4767-9C0C-A9515CEA711F@gmail.com/
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20241210041100.1898468-4-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf_verifier.h |    1 +
 kernel/bpf/verifier.c        |   32 +++++++++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -668,6 +668,7 @@ struct bpf_subprog_info {
 	bool args_cached: 1;
 	/* true if bpf_fastcall stack region is used by functions that can't be inlined */
 	bool keep_fastcall_stack: 1;
+	bool changes_pkt_data: 1;
 
 	u8 arg_cnt;
 	struct bpf_subprog_arg_info args[MAX_BPF_FUNC_REG_ARGS];
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9831,6 +9831,8 @@ static int check_func_call(struct bpf_ve
 
 		verbose(env, "Func#%d ('%s') is global and assumed valid.\n",
 			subprog, sub_name);
+		if (env->subprog_info[subprog].changes_pkt_data)
+			clear_all_pkt_pointers(env);
 		/* mark global subprog for verifying after main prog */
 		subprog_aux(env, subprog)->called = true;
 		clear_caller_saved_regs(env, caller->regs);
@@ -16021,6 +16023,29 @@ enforce_retval:
 	return 0;
 }
 
+static void mark_subprog_changes_pkt_data(struct bpf_verifier_env *env, int off)
+{
+	struct bpf_subprog_info *subprog;
+
+	subprog = find_containing_subprog(env, off);
+	subprog->changes_pkt_data = true;
+}
+
+/* 't' is an index of a call-site.
+ * 'w' is a callee entry point.
+ * Eventually this function would be called when env->cfg.insn_state[w] == EXPLORED.
+ * Rely on DFS traversal order and absence of recursive calls to guarantee that
+ * callee's change_pkt_data marks would be correct at that moment.
+ */
+static void merge_callee_effects(struct bpf_verifier_env *env, int t, int w)
+{
+	struct bpf_subprog_info *caller, *callee;
+
+	caller = find_containing_subprog(env, t);
+	callee = find_containing_subprog(env, w);
+	caller->changes_pkt_data |= callee->changes_pkt_data;
+}
+
 /* non-recursive DFS pseudo code
  * 1  procedure DFS-iterative(G,v):
  * 2      label v as discovered
@@ -16154,6 +16179,7 @@ static int visit_func_call_insn(int t, s
 				bool visit_callee)
 {
 	int ret, insn_sz;
+	int w;
 
 	insn_sz = bpf_is_ldimm64(&insns[t]) ? 2 : 1;
 	ret = push_insn(t, t + insn_sz, FALLTHROUGH, env);
@@ -16165,8 +16191,10 @@ static int visit_func_call_insn(int t, s
 	mark_jmp_point(env, t + insn_sz);
 
 	if (visit_callee) {
+		w = t + insns[t].imm + 1;
 		mark_prune_point(env, t);
-		ret = push_insn(t, t + insns[t].imm + 1, BRANCH, env);
+		merge_callee_effects(env, t, w);
+		ret = push_insn(t, w, BRANCH, env);
 	}
 	return ret;
 }
@@ -16486,6 +16514,8 @@ static int visit_insn(int t, struct bpf_
 			mark_prune_point(env, t);
 			mark_jmp_point(env, t);
 		}
+		if (bpf_helper_call(insn) && bpf_helper_changes_pkt_data(insn->imm))
+			mark_subprog_changes_pkt_data(env, t);
 		if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL) {
 			struct bpf_kfunc_call_arg_meta meta;
 


