Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159BE5381D;
	Mon,  8 Jan 2024 15:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X12Ft8tN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CCBC433C9;
	Mon,  8 Jan 2024 15:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728457;
	bh=odsodgXGsCQ6eJPhcU8NaRjqemuihUkIpgbDthhqslA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X12Ft8tNsZyFwa4+f0KsK5dQAx6xwN6NEq3iJdNJr0xmAWeFqZqtvwZez0dj5PKcO
	 68KBxlCmve9tvDj26t1975FcyDYw61wu8svJ7aEzYYPnqmCTvmwKEd+xYDszd0hjci
	 cffwmVZkx2F5cNpFflZ1Zzw//sXxqSjodoGZji3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/150] bpf: clean up visit_insn()s instruction processing
Date: Mon,  8 Jan 2024 16:35:33 +0100
Message-ID: <20240108153515.008223531@linuxfoundation.org>
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

[ Upstream commit 653ae3a874aca6764a4c1f5a8bf1b072ade0d6f4 ]

Instead of referencing processed instruction repeatedly as insns[t]
throughout entire visit_insn() function, take a local insn pointer and
work with it in a cleaner way.

It makes enhancing this function further a bit easier as well.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20230302235015.2044271-7-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 3feb263bb516 ("bpf: handle ldimm64 properly in check_cfg()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d1393e07ab2c9..73d500c51bd86 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11115,44 +11115,43 @@ static int visit_func_call_insn(int t, struct bpf_insn *insns,
  */
 static int visit_insn(int t, struct bpf_verifier_env *env)
 {
-	struct bpf_insn *insns = env->prog->insnsi;
+	struct bpf_insn *insns = env->prog->insnsi, *insn = &insns[t];
 	int ret;
 
-	if (bpf_pseudo_func(insns + t))
+	if (bpf_pseudo_func(insn))
 		return visit_func_call_insn(t, insns, env, true);
 
 	/* All non-branch instructions have a single fall-through edge. */
-	if (BPF_CLASS(insns[t].code) != BPF_JMP &&
-	    BPF_CLASS(insns[t].code) != BPF_JMP32)
+	if (BPF_CLASS(insn->code) != BPF_JMP &&
+	    BPF_CLASS(insn->code) != BPF_JMP32)
 		return push_insn(t, t + 1, FALLTHROUGH, env, false);
 
-	switch (BPF_OP(insns[t].code)) {
+	switch (BPF_OP(insn->code)) {
 	case BPF_EXIT:
 		return DONE_EXPLORING;
 
 	case BPF_CALL:
-		if (insns[t].imm == BPF_FUNC_timer_set_callback)
+		if (insn->imm == BPF_FUNC_timer_set_callback)
 			/* Mark this call insn as a prune point to trigger
 			 * is_state_visited() check before call itself is
 			 * processed by __check_func_call(). Otherwise new
 			 * async state will be pushed for further exploration.
 			 */
 			mark_prune_point(env, t);
-		return visit_func_call_insn(t, insns, env,
-					    insns[t].src_reg == BPF_PSEUDO_CALL);
+		return visit_func_call_insn(t, insns, env, insn->src_reg == BPF_PSEUDO_CALL);
 
 	case BPF_JA:
-		if (BPF_SRC(insns[t].code) != BPF_K)
+		if (BPF_SRC(insn->code) != BPF_K)
 			return -EINVAL;
 
 		/* unconditional jump with single edge */
-		ret = push_insn(t, t + insns[t].off + 1, FALLTHROUGH, env,
+		ret = push_insn(t, t + insn->off + 1, FALLTHROUGH, env,
 				true);
 		if (ret)
 			return ret;
 
-		mark_prune_point(env, t + insns[t].off + 1);
-		mark_jmp_point(env, t + insns[t].off + 1);
+		mark_prune_point(env, t + insn->off + 1);
+		mark_jmp_point(env, t + insn->off + 1);
 
 		return ret;
 
@@ -11164,7 +11163,7 @@ static int visit_insn(int t, struct bpf_verifier_env *env)
 		if (ret)
 			return ret;
 
-		return push_insn(t, t + insns[t].off + 1, BRANCH, env, true);
+		return push_insn(t, t + insn->off + 1, BRANCH, env, true);
 	}
 }
 
-- 
2.43.0



