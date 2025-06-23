Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B20224B01;
	Mon, 23 Jun 2025 22:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716166; cv=none; b=pabLt9ZRR0aGMKwYOhGHlU1OIg/ZI8TicsBD6prReA6kQwOIyv/ZZLL2EkF5idpBmiLqQVZ3GbfDXI487eZw0FWMiAom7d3BwdjH70BXpJJgd4BIOhcg+xP0p4JJl6NVzwnfscEVzHRRxvb4lKUiuRvfsGZf494Q0/Elm/Hap8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716166; c=relaxed/simple;
	bh=K42ok3Pj0VKM6qWK2PL17DtIxEnwwPsZbLuycrWjnTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAjFGufWX9D0n6lFkJAzfP5Ms14JAVldDkpprVCxb5gGZO4MS6ywvmrtTkuaoUx7CMpY4stVc9KJLYND721w2t5pvLXRKFdPWSXXwJ0/Xxu6NzwM+Z4SlsHm18BpAYCOoR4/ECgyrcp6l07p2aRP4kcphtnWTSZNFAsa+eGjTJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ReOlVpym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ReOlVpym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA0AC4CEEA;
	Mon, 23 Jun 2025 22:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716166;
	bh=K42ok3Pj0VKM6qWK2PL17DtIxEnwwPsZbLuycrWjnTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ReOlVpymT/nrjE8ly+/PM8rSDNfF7d45zl5s4t72NTLzHYVxD6aBUu1SUvrBCVk5o
	 8cdm+YHmzKXnF98VW9HrGfCi9S6AQKoPBtd1y5vnP5NQ1f0ym0N3ov/W9SuPm7CUaD
	 XFhmFnedTq74cVlUFQUecEvuNS5s9TITOHySEyPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Wei <weiwei.danny@bytedance.com>,
	Aaron Lu <ziqianlu@bytedance.com>
Subject: [PATCH 5.10 352/355] Revert "bpf: stop setting precise in current state"
Date: Mon, 23 Jun 2025 15:09:13 +0200
Message-ID: <20250623130637.304027346@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <ziqianlu@bytedance.com>

This reverts commit 7ca3e7459f4a5795e78b14390635879f534d9741 which is
commit f63181b6ae79fd3b034cde641db774268c2c3acf upstream.

The backport of bpf precision tracking related changes has caused bpf
verifier to panic while loading some certain bpf prog so revert them.

Link: https://lkml.kernel.org/r/20250605070921.GA3795@bytedance/
Reported-by: Wei Wei <weiwei.danny@bytedance.com>
Signed-off-by: Aaron Lu <ziqianlu@bytedance.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |  103 +++++---------------------------------------------
 1 file changed, 12 insertions(+), 91 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2028,11 +2028,8 @@ static void mark_all_scalars_precise(str
 
 	/* big hammer: mark all scalars precise in this path.
 	 * pop_stack may still get !precise scalars.
-	 * We also skip current state and go straight to first parent state,
-	 * because precision markings in current non-checkpointed state are
-	 * not needed. See why in the comment in __mark_chain_precision below.
 	 */
-	for (st = st->parent; st; st = st->parent) {
+	for (; st; st = st->parent)
 		for (i = 0; i <= st->curframe; i++) {
 			func = st->frame[i];
 			for (j = 0; j < BPF_REG_FP; j++) {
@@ -2050,88 +2047,8 @@ static void mark_all_scalars_precise(str
 				reg->precise = true;
 			}
 		}
-	}
 }
 
-/*
- * __mark_chain_precision() backtracks BPF program instruction sequence and
- * chain of verifier states making sure that register *regno* (if regno >= 0)
- * and/or stack slot *spi* (if spi >= 0) are marked as precisely tracked
- * SCALARS, as well as any other registers and slots that contribute to
- * a tracked state of given registers/stack slots, depending on specific BPF
- * assembly instructions (see backtrack_insns() for exact instruction handling
- * logic). This backtracking relies on recorded jmp_history and is able to
- * traverse entire chain of parent states. This process ends only when all the
- * necessary registers/slots and their transitive dependencies are marked as
- * precise.
- *
- * One important and subtle aspect is that precise marks *do not matter* in
- * the currently verified state (current state). It is important to understand
- * why this is the case.
- *
- * First, note that current state is the state that is not yet "checkpointed",
- * i.e., it is not yet put into env->explored_states, and it has no children
- * states as well. It's ephemeral, and can end up either a) being discarded if
- * compatible explored state is found at some point or BPF_EXIT instruction is
- * reached or b) checkpointed and put into env->explored_states, branching out
- * into one or more children states.
- *
- * In the former case, precise markings in current state are completely
- * ignored by state comparison code (see regsafe() for details). Only
- * checkpointed ("old") state precise markings are important, and if old
- * state's register/slot is precise, regsafe() assumes current state's
- * register/slot as precise and checks value ranges exactly and precisely. If
- * states turn out to be compatible, current state's necessary precise
- * markings and any required parent states' precise markings are enforced
- * after the fact with propagate_precision() logic, after the fact. But it's
- * important to realize that in this case, even after marking current state
- * registers/slots as precise, we immediately discard current state. So what
- * actually matters is any of the precise markings propagated into current
- * state's parent states, which are always checkpointed (due to b) case above).
- * As such, for scenario a) it doesn't matter if current state has precise
- * markings set or not.
- *
- * Now, for the scenario b), checkpointing and forking into child(ren)
- * state(s). Note that before current state gets to checkpointing step, any
- * processed instruction always assumes precise SCALAR register/slot
- * knowledge: if precise value or range is useful to prune jump branch, BPF
- * verifier takes this opportunity enthusiastically. Similarly, when
- * register's value is used to calculate offset or memory address, exact
- * knowledge of SCALAR range is assumed, checked, and enforced. So, similar to
- * what we mentioned above about state comparison ignoring precise markings
- * during state comparison, BPF verifier ignores and also assumes precise
- * markings *at will* during instruction verification process. But as verifier
- * assumes precision, it also propagates any precision dependencies across
- * parent states, which are not yet finalized, so can be further restricted
- * based on new knowledge gained from restrictions enforced by their children
- * states. This is so that once those parent states are finalized, i.e., when
- * they have no more active children state, state comparison logic in
- * is_state_visited() would enforce strict and precise SCALAR ranges, if
- * required for correctness.
- *
- * To build a bit more intuition, note also that once a state is checkpointed,
- * the path we took to get to that state is not important. This is crucial
- * property for state pruning. When state is checkpointed and finalized at
- * some instruction index, it can be correctly and safely used to "short
- * circuit" any *compatible* state that reaches exactly the same instruction
- * index. I.e., if we jumped to that instruction from a completely different
- * code path than original finalized state was derived from, it doesn't
- * matter, current state can be discarded because from that instruction
- * forward having a compatible state will ensure we will safely reach the
- * exit. States describe preconditions for further exploration, but completely
- * forget the history of how we got here.
- *
- * This also means that even if we needed precise SCALAR range to get to
- * finalized state, but from that point forward *that same* SCALAR register is
- * never used in a precise context (i.e., it's precise value is not needed for
- * correctness), it's correct and safe to mark such register as "imprecise"
- * (i.e., precise marking set to false). This is what we rely on when we do
- * not set precise marking in current state. If no child state requires
- * precision for any given SCALAR register, it's safe to dictate that it can
- * be imprecise. If any child state does require this register to be precise,
- * we'll mark it precise later retroactively during precise markings
- * propagation from child state to parent states.
- */
 static int __mark_chain_precision(struct bpf_verifier_env *env, int frame, int regno,
 				  int spi)
 {
@@ -2149,10 +2066,6 @@ static int __mark_chain_precision(struct
 	if (!env->bpf_capable)
 		return 0;
 
-	/* Do sanity checks against current state of register and/or stack
-	 * slot, but don't set precise flag in current state, as precision
-	 * tracking in the current state is unnecessary.
-	 */
 	func = st->frame[frame];
 	if (regno >= 0) {
 		reg = &func->regs[regno];
@@ -2160,7 +2073,11 @@ static int __mark_chain_precision(struct
 			WARN_ONCE(1, "backtracing misuse");
 			return -EFAULT;
 		}
-		new_marks = true;
+		if (!reg->precise)
+			new_marks = true;
+		else
+			reg_mask = 0;
+		reg->precise = true;
 	}
 
 	while (spi >= 0) {
@@ -2173,7 +2090,11 @@ static int __mark_chain_precision(struct
 			stack_mask = 0;
 			break;
 		}
-		new_marks = true;
+		if (!reg->precise)
+			new_marks = true;
+		else
+			stack_mask = 0;
+		reg->precise = true;
 		break;
 	}
 
@@ -9358,7 +9279,7 @@ static bool regsafe(struct bpf_verifier_
 		if (env->explore_alu_limits)
 			return false;
 		if (rcur->type == SCALAR_VALUE) {
-			if (!rold->precise)
+			if (!rold->precise && !rcur->precise)
 				return true;
 			/* new val must satisfy old val knowledge */
 			return range_within(rold, rcur) &&


