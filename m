Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA7E28BA9F;
	Wed,  7 May 2025 19:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644917; cv=none; b=oW+0gPZXLti3z1xqGgtfUuRy8fuVK8GHxfwd/ygxIMza9nTXPMZI3jb0nw5UoFF5yECmV4qPxtMscYwXE7f7Xa0ptuVJtA8uZEU9jexSte2RQH/XgnCB5tgXmg4QBDxakGFpm5eZ8fMVw+ExcRvDaaCxXhIqH10sLEoiQfSaXJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644917; c=relaxed/simple;
	bh=MFMGrS2+3YoGTrbJVbLYHUErg9yO6vSlBeT0HU5k4h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUnYGdyr8hedGUMljPIcP0HTyaufObfOeEWcWd8VYDXc/U1l5bd1iF5zSGJ55msWvthN0U8FTU80cRoPTESQ5m79jH2EEDlY69FFUqAfVLYUu0+iE+vBOmBgWH57UYvaxbCp4x+Hh+gKZZOTxtZJoxcUs4AcfYMsbIXfH84dvJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xMJ5Qedv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xMJ5Qedv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3335C4CEE2;
	Wed,  7 May 2025 19:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644917;
	bh=MFMGrS2+3YoGTrbJVbLYHUErg9yO6vSlBeT0HU5k4h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xMJ5QedvmWeFgqxJQ4GLrqau++wBtXrrehIUXmH4sWkx90dfhyebu3Ir/OWp/Ozj6
	 kJtri5dt973CBZdhhKIA23U+rhtyfyC7ppFrFrvrxDNKJdqKSdQvbQCLSyWuY9FSUw
	 JGTF3/4HwxnloBdKJj3pr763F3NIyhfYz8r3nC4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Zavaritsky <mejedi@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.6 035/129] bpf: track changes_pkt_data property for global functions
Date: Wed,  7 May 2025 20:39:31 +0200
Message-ID: <20250507183814.951072893@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[shung-hsi.yu: do not use bitfield in "struct bpf_subprog_info" because commit
406a6fa44bfb ("bpf: use bitfields for simple per-subprog bool flags") is not
present and minor context difference in check_func_call() because commit
491dd8edecbc ("bpf: Emit global subprog name in verifier logs") is not present. ]
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf_verifier.h |    1 +
 kernel/bpf/verifier.c        |   32 +++++++++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -573,6 +573,7 @@ struct bpf_subprog_info {
 	bool tail_call_reachable;
 	bool has_ld_abs;
 	bool is_async_cb;
+	bool changes_pkt_data;
 };
 
 struct bpf_verifier_env;
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9364,6 +9364,8 @@ static int check_func_call(struct bpf_ve
 
 		if (env->log.level & BPF_LOG_LEVEL)
 			verbose(env, "Func#%d is global and valid. Skipping.\n", subprog);
+		if (env->subprog_info[subprog].changes_pkt_data)
+			clear_all_pkt_pointers(env);
 		clear_caller_saved_regs(env, caller->regs);
 
 		/* All global functions return a 64-bit SCALAR_VALUE */
@@ -15114,6 +15116,29 @@ static int check_return_code(struct bpf_
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
@@ -15247,6 +15272,7 @@ static int visit_func_call_insn(int t, s
 				bool visit_callee)
 {
 	int ret, insn_sz;
+	int w;
 
 	insn_sz = bpf_is_ldimm64(&insns[t]) ? 2 : 1;
 	ret = push_insn(t, t + insn_sz, FALLTHROUGH, env);
@@ -15258,8 +15284,10 @@ static int visit_func_call_insn(int t, s
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
@@ -15311,6 +15339,8 @@ static int visit_insn(int t, struct bpf_
 			mark_prune_point(env, t);
 			mark_jmp_point(env, t);
 		}
+		if (bpf_helper_call(insn) && bpf_helper_changes_pkt_data(insn->imm))
+			mark_subprog_changes_pkt_data(env, t);
 		if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL) {
 			struct bpf_kfunc_call_arg_meta meta;
 


