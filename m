Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E2051D52A;
	Thu, 17 Sep 2026 15:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659245; cv=none; b=DNXwGpS0O3TbrX92XTqElEl5Xa0o7AZWRlR6w6Waiv0jw9wd8yYLA0Pr6XMemq/YCITD/6URnRooHPP5YC3ZqugCiLn0etBSrB4ZzsZ+NXa3faBMPwqpLVE2CBU77sBeKUeoXSVmPxTgDIvKUwLc0Gy/HFGU6s3f2Bz05dxBn5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659245; c=relaxed/simple;
	bh=hYVSSOJd+w/oHOG0/zAWby5N5SOVF3onTj+OP5i8c3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZgVItMa1cm4dzdNZMPXV1QcZ8JnlCeGxETEcWXRhaL9HV+APU0vAfqNgd/Iz9S7uSBLI9nDCz2bAK/mR1clZ5e1QHk9bp1lL8kYXQu3bW5W6MmN0zy60t0WN0eu29pXXey1YuWwv90w0oymt2YqFvg9Vl3M3LRxEX5i6Kxwbuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQOvscqP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQOvscqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1EA1F00893;
	Thu, 17 Sep 2026 15:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659239;
	bh=10ve7JmHxp62uRkQ1Z/tYB5w0fjvYGQQfIry8XaKhkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aQOvscqP6K3MjSywNQWNvo0fyeNueuMKm371urwD8bMJRgeQROSQBSZdsoMI/gh9p
	 uvNOk1cbVhrQ/xGoY8L6j/KTT4iVsLMb/ZQGw2bPxFdWzgFuzP4Y4fGWvTeEPfP+EA
	 mSHKzzm6QptsO1X+nMlX85dwybtsgeFahjYRHqKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 190/733] bpf: backtracking shouldnt clear outer frame R1-R5 for callbacks
Date: Thu, 17 Sep 2026 16:08:18 +0100
Message-ID: <20260917151355.877787844@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/bpf/backtrack.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/kernel/bpf/backtrack.c b/kernel/bpf/backtrack.c
index ac7341f003b02..53a1e52d73c5a 100644
--- a/kernel/bpf/backtrack.c
+++ b/kernel/bpf/backtrack.c
@@ -521,37 +521,34 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx, int subseq_idx,
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
-			if (subseq_idx >= 0 && bpf_calls_callback(env, subseq_idx))
-				for (i = BPF_REG_1; i <= BPF_REG_5; i++)
-					bt_clear_reg(bt, i);
-			if (bt_reg_mask(bt) & BPF_REGMASK_ARGS) {
+			if (from_subprog_call && (bt_reg_mask(bt) & BPF_REGMASK_ARGS)) {
 				verifier_bug(env, "backtracking exit unexpected regs %x",
 					     bt_reg_mask(bt));
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



