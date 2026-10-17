Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8E138DC44;
	Sat, 17 Oct 2026 16:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255541; cv=none; b=bBRPyiYYNG0JXRQe/Tz35soMsZ7rModzXIza+RP33o/01w5SbhhXN1W3iCg3fBdCDCXtI+0sn/FXzUM5MuOxBhZVWqRH/rFnIqAjE/8FI5BYL+JaqVZTUjj9Dk8HKZev3goBlJ8xTvNnXujJj+L02o1CrpElBv8btl/jjHQ9nXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255541; c=relaxed/simple;
	bh=2JmP1EZMw37WiFgsALF30mwEc6WuzkPut2OhBFtNtzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1STU2V4KHelcFejD/oDE9UNLDr3LfgK4gvGJ4rTRV4sc7RXX6EZTb9J62BQOxBB95wQqrofXHErHJkgxKenkTWUaJADBONhlVEzgf/Z+LucSY6KY3PnJyY0zWaFrsFmY0wEiN1Y/JzQzai22MuaFy1EiGgMFBzcb+VWAf+nkJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QH7T66Fi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QH7T66Fi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C93E1F000C4;
	Sat, 17 Oct 2026 16:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255540;
	bh=gAWsI9QAGEx5i3tW+iLiwDBdg0Aa+/zJXZFkicazr9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QH7T66FiCZHpyMglJE0N7km030XGfHTr0ha4XWKvWQkyC10Dsf8isJU3fblzugJYm
	 njLbuECLxer3IP/sM9ZnD+yvs6/kz+jY32WnQsF6SquJEPZSbuQ1TCNOcSFFrr+BUV
	 0fJt+Nf9jPVvPA0a/zw+V0s9JOXLXkmGMXBPu+mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 793/869] bpf: backtracking shouldnt clear outer frame R1-R5 for callbacks
Date: Sat, 17 Oct 2026 18:00:34 +0200
Message-ID: <20261017160057.238878152@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit e3e4f66cc4b72333d0886ae2673c360248987889 ]

When processing calls to bpf_loop() verifier marks R1 (and R4) as
precise. R1 tracks loop iterations number and because of the
'callback_depth < R1' mechanics in check_helper_call() must be marked
precise. However, precision propagation for R1 was broken,
when bpf_loop() call was verified on a second iteration.

Consider the following verification trace:
- main: bpf_loop(nr_loops, callback ...)
- callback: BPF_EXIT
- main: bpf_loop(nr_loops, callback ...)
- ...

While the first visit of the call to bpf_loop() propagated R1
precision as expected, the second call to mark_chain_precision() in
the check_helper_call() set R1, but it was immediately reset when
backtrack_insn() processed preceding BPF_EXIT in the loop deleted in
this patch.

Because of that, the second visit of the call to bpf_loop() injected
checkpoint with R1 not marked as precise. Which could trick the
verifier into accepting unsafe programs. See the next patch for an
example of such program.

Commit is structured in a way to minimize conflicts when
'bpf' would be eventually merged with 'bpf-next'.

Fixes: ab5cfac139ab ("bpf: verify callbacks as if they are called unknown number of times")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260831-bug-015-backtrack-cb-args-precise-v1-1-68a8e2a821e0@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 60fc4935288c8..76868b01727f5 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4148,37 +4148,34 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx, int subseq_idx,
 				return -EFAULT;
 			}
 		} else if (opcode == BPF_EXIT) {
-			bool r0_precise;
+			bool from_subprog_call, r0_precise;
+
+			/* BPF_EXIT in subprog or callback always returns
+			 * right after the call instruction, so by checking
+			 * whether the instruction at subseq_idx-1 is subprog
+			 * call or not we can distinguish actual exit from
+			 * *subprog* from exit from *callback*. In the former
+			 * case, we need to propagate r0 precision, if
+			 * necessary. In the former we never do that.
+			 */
+			from_subprog_call = subseq_idx - 1 >= 0 &&
+					    bpf_pseudo_call(&env->prog->insnsi[subseq_idx - 1]);
+
+			r0_precise = from_subprog_call && bt_is_reg_set(bt, BPF_REG_0);
 
 			/* Backtracking to a nested function call, 'idx' is a part of
 			 * the inner frame 'subseq_idx' is a part of the outer frame.
 			 * In case of a regular function call, instructions giving
 			 * precision to registers R1-R5 should have been found already.
-			 * In case of a callback, it is ok to have R1-R5 marked for
-			 * backtracking, as these registers are set by the function
-			 * invoking callback.
+			 * In case of a callback from bpf_loop(), R{1,4} in the calling
+			 * frame would be set as precise and that is correct.
 			 */
-			if (subseq_idx >= 0 && calls_callback(env, subseq_idx))
-				for (i = BPF_REG_1; i <= BPF_REG_5; i++)
-					bt_clear_reg(bt, i);
-			if (bt_reg_mask(bt) & BPF_REGMASK_ARGS) {
+			if (from_subprog_call && (bt_reg_mask(bt) & BPF_REGMASK_ARGS)) {
 				verbose(env, "BUG regs %x\n", bt_reg_mask(bt));
 				WARN_ONCE(1, "verifier backtracking bug");
 				return -EFAULT;
 			}
 
-			/* BPF_EXIT in subprog or callback always returns
-			 * right after the call instruction, so by checking
-			 * whether the instruction at subseq_idx-1 is subprog
-			 * call or not we can distinguish actual exit from
-			 * *subprog* from exit from *callback*. In the former
-			 * case, we need to propagate r0 precision, if
-			 * necessary. In the former we never do that.
-			 */
-			r0_precise = subseq_idx - 1 >= 0 &&
-				     bpf_pseudo_call(&env->prog->insnsi[subseq_idx - 1]) &&
-				     bt_is_reg_set(bt, BPF_REG_0);
-
 			bt_clear_reg(bt, BPF_REG_0);
 			if (bt_subprog_enter(bt))
 				return -EFAULT;
-- 
2.53.0



