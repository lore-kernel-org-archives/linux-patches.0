Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D472355810;
	Tue, 16 Dec 2025 12:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887895; cv=none; b=LBUApdbpBmOAWtHVhP094ULoHnjbSNwoUumiRSY5pFEnwyTvkO8JNTFIUhnp8jUvoW1g7gCn/KV7orj0TrjxrmakC8fIyF/RZ5scsYwPF5PWcFfe80fsZOABK51ZbenZxmquCK4TjQtNpMC8VFPdwk+hIDsmLxJSZbjSKsQS8Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887895; c=relaxed/simple;
	bh=1mED2Nq8ibvBhyqiAz4qk3BxEArGiiNym7x7fYVdEPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGxS829uI2hkpf9gq+VhSRewgDq5r8gAXyVYQXdKLeT9ejdSs/mbTUPFvx8lKPHp5nVinT7kmfgtjppSg6GRs4R/cd3J5/c51QjBSPp/MmJlct0wDCdnYmAhciXRm9FMNMwhrHHDZPTLWZ8IxCQvMypu/3oZs2VEjU+s0jZ1FIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vxw7TI10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vxw7TI10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D928CC4CEF1;
	Tue, 16 Dec 2025 12:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887895;
	bh=1mED2Nq8ibvBhyqiAz4qk3BxEArGiiNym7x7fYVdEPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vxw7TI10kD6l8DChxpA+QQTL7sKU4rZ5J9AvicRnph8J2PKmTjTAn8orNY66R3LV7
	 SqqmHKah8OqNZgxq5xqRQEQ7aTw/Y/di9+o9KIVJX/z+sWoedN3N2OI/OhTTdLP++v
	 bvLceld+q//IvhBTqGj5Oshf9lgkt1fttqq70KUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Teichmann <martin.teichmann@xfel.eu>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 370/614] bpf: properly verify tail call behavior
Date: Tue, 16 Dec 2025 12:12:17 +0100
Message-ID: <20251216111414.767154096@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Martin Teichmann <martin.teichmann@xfel.eu>

[ Upstream commit e3245f8990431950d20631c72236d4e8cb2dcde8 ]

A successful ebpf tail call does not return to the caller, but to the
caller-of-the-caller, often just finishing the ebpf program altogether.

Any restrictions that the verifier needs to take into account - notably
the fact that the tail call might have modified packet pointers - are to
be checked on the caller-of-the-caller. Checking it on the caller made
the verifier refuse perfectly fine programs that would use the packet
pointers after a tail call, which is no problem as this code is only
executed if the tail call was unsuccessful, i.e. nothing happened.

This patch simulates the behavior of a tail call in the verifier. A
conditional jump to the code after the tail call is added for the case
of an unsucessful tail call, and a return to the caller is simulated for
a successful tail call.

For the successful case we assume that the tail call returns an int,
as tail calls are currently only allowed in functions that return and
int. We always assume that the tail call modified the packet pointers,
as we do not know what the tail call did.

For the unsuccessful case we know nothing happened, so we do not need to
add new constraints.

This approach also allows to check other problems that may occur with
tail calls, namely we are now able to check that precision is properly
propagated into subprograms using tail calls, as well as checking the
live slots in such a subprogram.

Fixes: 1a4607ffba35 ("bpf: consider that tail calls invalidate packet pointers")
Link: https://lore.kernel.org/bpf/20251029105828.1488347-1-martin.teichmann@xfel.eu/
Signed-off-by: Martin Teichmann <martin.teichmann@xfel.eu>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20251119160355.1160932-2-martin.teichmann@xfel.eu
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 52c01c011c6fb..89560e455ce7b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4408,6 +4408,11 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx, int subseq_idx,
 					     bt_reg_mask(bt));
 				return -EFAULT;
 			}
+			if (insn->src_reg == BPF_REG_0 && insn->imm == BPF_FUNC_tail_call
+			    && subseq_idx - idx != 1) {
+				if (bt_subprog_enter(bt))
+					return -EFAULT;
+			}
 		} else if (opcode == BPF_EXIT) {
 			bool r0_precise;
 
@@ -10995,6 +11000,10 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 	bool in_callback_fn;
 	int err;
 
+	err = bpf_update_live_stack(env);
+	if (err)
+		return err;
+
 	callee = state->frame[state->curframe];
 	r0 = &callee->regs[BPF_REG_0];
 	if (r0->type == PTR_TO_STACK) {
@@ -11912,6 +11921,25 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		env->prog->call_get_func_ip = true;
 	}
 
+	if (func_id == BPF_FUNC_tail_call) {
+		if (env->cur_state->curframe) {
+			struct bpf_verifier_state *branch;
+
+			mark_reg_scratched(env, BPF_REG_0);
+			branch = push_stack(env, env->insn_idx + 1, env->insn_idx, false);
+			if (IS_ERR(branch))
+				return PTR_ERR(branch);
+			clear_all_pkt_pointers(env);
+			mark_reg_unknown(env, regs, BPF_REG_0);
+			err = prepare_func_exit(env, &env->insn_idx);
+			if (err)
+				return err;
+			env->insn_idx--;
+		} else {
+			changes_data = false;
+		}
+	}
+
 	if (changes_data)
 		clear_all_pkt_pointers(env);
 	return 0;
@@ -19810,9 +19838,6 @@ static int process_bpf_exit_full(struct bpf_verifier_env *env,
 		return PROCESS_BPF_EXIT;
 
 	if (env->cur_state->curframe) {
-		err = bpf_update_live_stack(env);
-		if (err)
-			return err;
 		/* exit from nested function */
 		err = prepare_func_exit(env, &env->insn_idx);
 		if (err)
-- 
2.51.0



