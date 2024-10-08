Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08711DE89F;
	Tue,  8 Oct 2024 13:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393531; cv=none; b=Dnc5zzEedIseILQbpk15ovCKlkwSbUCMo2GM/IlXH1ttj9Yrs/oufZ+6haA9j6wD8sAtQKS4tDCSB9quXcWhQXtjLnyLdNM7ON+3PjUeho/m9bkvJcfm7Yqcnp8vnmBTVJ21htDNe4u0Vg33ggH6rddywqOyF4KfciNTOS5eZwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393531; c=relaxed/simple;
	bh=lswdiBtnkrtm0VMtUFHh1CAe5e6OOAF+WeI+lIOlwiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMk5dGX9DE8+V6niACXi7wmOwo7z7FJVUKiCoh/ly7HChCr7dHyTH+77t+1mEiaLsBWIxNW3BSrJ81DJQVpmRO8FfbizyVkT6VAVT747wNie4j527lASUZASxJEF7H/EBDgq1tA32JwP92VwVt5EWKm1s4AGvf70opZ8WXzM4qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smyUjg5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smyUjg5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E34BC4CEC7;
	Tue,  8 Oct 2024 13:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393530;
	bh=lswdiBtnkrtm0VMtUFHh1CAe5e6OOAF+WeI+lIOlwiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smyUjg5OMv8tG+YFRMLsazuzcaFEFiTtYaFp0Dnr07oTWauLIWjE8uiV1XvmDGLXd
	 vilAqFzebSI7UAXevV2E7q/Oa4w/1K9htVoTHIZfFWumBFjHWUamSHPGIqYQ/Y35yA
	 /Rcfi8EaK9h+zAOchHEinlzgrl4vlHyg29MVr0Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juntong Deng <juntong.deng@outlook.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 179/386] bpf: Make the pointer returned by iter next method valid
Date: Tue,  8 Oct 2024 14:07:04 +0200
Message-ID: <20241008115636.458735990@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Juntong Deng <juntong.deng@outlook.com>

[ Upstream commit 4cc8c50c9abcb2646a7a4fcef3cea5dcb30c06cf ]

Currently we cannot pass the pointer returned by iter next method as
argument to KF_TRUSTED_ARGS or KF_RCU kfuncs, because the pointer
returned by iter next method is not "valid".

This patch sets the pointer returned by iter next method to be valid.

This is based on the fact that if the iterator is implemented correctly,
then the pointer returned from the iter next method should be valid.

This does not make NULL pointer valid. If the iter next method has
KF_RET_NULL flag, then the verifier will ask the ebpf program to
check NULL pointer.

KF_RCU_PROTECTED iterator is a special case, the pointer returned by
iter next method should only be valid within RCU critical section,
so it should be with MEM_RCU, not PTR_TRUSTED.

Another special case is bpf_iter_num_next, which returns a pointer with
base type PTR_TO_MEM. PTR_TO_MEM should not be combined with type flag
PTR_TRUSTED (PTR_TO_MEM already means the pointer is valid).

The pointer returned by iter next method of other types of iterators
is with PTR_TRUSTED.

In addition, this patch adds get_iter_from_state to help us get the
current iterator from the current state.

Signed-off-by: Juntong Deng <juntong.deng@outlook.com>
Link: https://lore.kernel.org/r/AM6PR03MB584869F8B448EA1C87B7CDA399962@AM6PR03MB5848.eurprd03.prod.outlook.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 834394faf2af3..3032a464d31bb 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7846,6 +7846,15 @@ static int widen_imprecise_scalars(struct bpf_verifier_env *env,
 	return 0;
 }
 
+static struct bpf_reg_state *get_iter_from_state(struct bpf_verifier_state *cur_st,
+						 struct bpf_kfunc_call_arg_meta *meta)
+{
+	int iter_frameno = meta->iter.frameno;
+	int iter_spi = meta->iter.spi;
+
+	return &cur_st->frame[iter_frameno]->stack[iter_spi].spilled_ptr;
+}
+
 /* process_iter_next_call() is called when verifier gets to iterator's next
  * "method" (e.g., bpf_iter_num_next() for numbers iterator) call. We'll refer
  * to it as just "iter_next()" in comments below.
@@ -7930,12 +7939,10 @@ static int process_iter_next_call(struct bpf_verifier_env *env, int insn_idx,
 	struct bpf_verifier_state *cur_st = env->cur_state, *queued_st, *prev_st;
 	struct bpf_func_state *cur_fr = cur_st->frame[cur_st->curframe], *queued_fr;
 	struct bpf_reg_state *cur_iter, *queued_iter;
-	int iter_frameno = meta->iter.frameno;
-	int iter_spi = meta->iter.spi;
 
 	BTF_TYPE_EMIT(struct bpf_iter);
 
-	cur_iter = &env->cur_state->frame[iter_frameno]->stack[iter_spi].spilled_ptr;
+	cur_iter = get_iter_from_state(cur_st, meta);
 
 	if (cur_iter->iter.state != BPF_ITER_STATE_ACTIVE &&
 	    cur_iter->iter.state != BPF_ITER_STATE_DRAINED) {
@@ -7963,7 +7970,7 @@ static int process_iter_next_call(struct bpf_verifier_env *env, int insn_idx,
 		if (!queued_st)
 			return -ENOMEM;
 
-		queued_iter = &queued_st->frame[iter_frameno]->stack[iter_spi].spilled_ptr;
+		queued_iter = get_iter_from_state(queued_st, meta);
 		queued_iter->iter.state = BPF_ITER_STATE_ACTIVE;
 		queued_iter->iter.depth++;
 		if (prev_st)
@@ -11995,6 +12002,17 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 			regs[BPF_REG_0].btf = desc_btf;
 			regs[BPF_REG_0].type = PTR_TO_BTF_ID;
 			regs[BPF_REG_0].btf_id = ptr_type_id;
+
+			if (is_iter_next_kfunc(&meta)) {
+				struct bpf_reg_state *cur_iter;
+
+				cur_iter = get_iter_from_state(env->cur_state, &meta);
+
+				if (cur_iter->type & MEM_RCU) /* KF_RCU_PROTECTED */
+					regs[BPF_REG_0].type |= MEM_RCU;
+				else
+					regs[BPF_REG_0].type |= PTR_TRUSTED;
+			}
 		}
 
 		if (is_kfunc_ret_null(&meta)) {
-- 
2.43.0



