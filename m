Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EC11DEFED;
	Tue,  8 Oct 2024 12:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392207; cv=none; b=j7JHelqIH52Lvs0hNfbdS35EA1bcSC9HmPwBHVyW06F4RmE9y7LL7aoYW/76aApKuj82JV0mczhNqRFsGeMig3ecOSOe2kvvZ1QTIfud7qL4iyLeHXe8vzZjAP8Ynf7VQX1/v+i1Kra/Hz2ZQVR4EshWfI6nTrf02/e37Fca66E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392207; c=relaxed/simple;
	bh=Is2JweNhQqM5LKmquZ0v9GIwpXLoJfAmF6q7zNkOKjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JciiAzNE09lFuiAzKvC3QY2UDgJ/PcF7kLUkOdGQC7isAJ9nO2WvhHT1p7YihzusfJLsTSZSMiJbFbya3Zha5CSD4/6ZcR9L/AZonfYBIC3He0JFHLXgzhGy4CGGYRe/XDhMa8hNrhco58cxi4vkuxIKWam7jGvPp/oRmqHDcRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zu5kCtkM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zu5kCtkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82EFC4CEC7;
	Tue,  8 Oct 2024 12:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392207;
	bh=Is2JweNhQqM5LKmquZ0v9GIwpXLoJfAmF6q7zNkOKjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zu5kCtkMRM9aQhSR4VO+TKIddWST7HSw9XyO01XdSnfwQ0A4QFx5WaMu+W6yjgPHQ
	 cc+MEPMAQcMx6oolKwRyx/jppTZ5YJ3xd60Mtv7W4r4VnzxxXHOPchFg6wMKih1QZS
	 FHfFo7fPOPm0wZnxufqX4Wi78kNd1qLV+p6PxbOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juntong Deng <juntong.deng@outlook.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 306/558] bpf: Make the pointer returned by iter next method valid
Date: Tue,  8 Oct 2024 14:05:36 +0200
Message-ID: <20241008115714.358366104@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 8c07efa3905b9..400449959802b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8029,6 +8029,15 @@ static int widen_imprecise_scalars(struct bpf_verifier_env *env,
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
@@ -8113,12 +8122,10 @@ static int process_iter_next_call(struct bpf_verifier_env *env, int insn_idx,
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
@@ -8146,7 +8153,7 @@ static int process_iter_next_call(struct bpf_verifier_env *env, int insn_idx,
 		if (!queued_st)
 			return -ENOMEM;
 
-		queued_iter = &queued_st->frame[iter_frameno]->stack[iter_spi].spilled_ptr;
+		queued_iter = get_iter_from_state(queued_st, meta);
 		queued_iter->iter.state = BPF_ITER_STATE_ACTIVE;
 		queued_iter->iter.depth++;
 		if (prev_st)
@@ -12692,6 +12699,17 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
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



