Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D0A2E7F1D;
	Tue, 15 Jul 2025 13:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586113; cv=none; b=tzxX5UhZsfHuPWWd0hTInsOB5OwAjbz8GX0Rzx1aKlkF7cNN624hN09h8VWk1UQAUmzKZC4rx5dDjkPg79cRWXxETqbcPFR8mjqSzaBeoxJxeult2Eoj5BieReeArGUo4cTk+KNSjr2Vo3lRBxhthxf04hDzqkOBG41ko51Dqz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586113; c=relaxed/simple;
	bh=IsIyxXTgsNuSTlGGMnty2y533zh4Qca4d84udi0Lc9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwxnwP3tL9xoAnKgJCnK4t/FWJDCfrp7nt3fAsEuii//c3F6r0nmzX1neOc29LrFb2qb/xVC5mdumwyyxa7EwcUeXXZBZmmVFSn5kAjtD/r9b3bwtyE/36A8NQtS7UnHpn12kjsV5nNcKUw9QZ+oQJccRgz4t2scWi0TjZliRUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PtSVd/ol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtSVd/ol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06ADC4CEE3;
	Tue, 15 Jul 2025 13:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586113;
	bh=IsIyxXTgsNuSTlGGMnty2y533zh4Qca4d84udi0Lc9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtSVd/olCReFmNwieormmMwI0eqjzIAIG3gXhnVCugeeSq64NkNauSu8c5hYsyRQm
	 NupqUisAATIJUX//6BYWhRdFTnS+jtr57YAIoyEhIMDvc4ygbB9rgCZkVlGmIvGRGF
	 b5fuWfq5OR8JdKYryAXrvADkYP0+KQZ/Hwac22lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Wei Wei <weiwei.danny@bytedance.com>
Subject: [PATCH 5.15 20/77] bpf: fix precision backtracking instruction iteration
Date: Tue, 15 Jul 2025 15:13:19 +0200
Message-ID: <20250715130752.510143224@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

commit 4bb7ea946a370707315ab774432963ce47291946 upstream.

Fix an edge case in __mark_chain_precision() which prematurely stops
backtracking instructions in a state if it happens that state's first
and last instruction indexes are the same. This situations doesn't
necessarily mean that there were no instructions simulated in a state,
but rather that we starting from the instruction, jumped around a bit,
and then ended up at the same instruction before checkpointing or
marking precision.

To distinguish between these two possible situations, we need to consult
jump history. If it's empty or contain a single record "bridging" parent
state and first instruction of processed state, then we indeed
backtracked all instructions in this state. But if history is not empty,
we are definitely not done yet.

Move this logic inside get_prev_insn_idx() to contain it more nicely.
Use -ENOENT return code to denote "we are out of instructions"
situation.

This bug was exposed by verifier_loop1.c's bounded_recursion subtest, once
the next fix in this patch set is applied.

Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Fixes: b5dc0163d8fd ("bpf: precise scalar_value tracking")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20231110002638.4168352-3-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Aaron Lu <ziqianlu@bytedance.com>
Reported-by: Wei Wei <weiwei.danny@bytedance.com>
Closes: https://lore.kernel.org/all/20250605070921.GA3795@bytedance/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2134,12 +2134,29 @@ static int push_jmp_history(struct bpf_v
 
 /* Backtrack one insn at a time. If idx is not at the top of recorded
  * history then previous instruction came from straight line execution.
+ * Return -ENOENT if we exhausted all instructions within given state.
+ *
+ * It's legal to have a bit of a looping with the same starting and ending
+ * insn index within the same state, e.g.: 3->4->5->3, so just because current
+ * instruction index is the same as state's first_idx doesn't mean we are
+ * done. If there is still some jump history left, we should keep going. We
+ * need to take into account that we might have a jump history between given
+ * state's parent and itself, due to checkpointing. In this case, we'll have
+ * history entry recording a jump from last instruction of parent state and
+ * first instruction of given state.
  */
 static int get_prev_insn_idx(struct bpf_verifier_state *st, int i,
 			     u32 *history)
 {
 	u32 cnt = *history;
 
+	if (i == st->first_insn_idx) {
+		if (cnt == 0)
+			return -ENOENT;
+		if (cnt == 1 && st->jmp_history[0].idx == i)
+			return -ENOENT;
+	}
+
 	if (cnt && st->jmp_history[cnt - 1].idx == i) {
 		i = st->jmp_history[cnt - 1].prev_idx;
 		(*history)--;
@@ -2630,9 +2647,9 @@ static int __mark_chain_precision(struct
 				 * Nothing to be tracked further in the parent state.
 				 */
 				return 0;
-			if (i == first_idx)
-				break;
 			i = get_prev_insn_idx(st, i, &history);
+			if (i == -ENOENT)
+				break;
 			if (i >= env->prog->len) {
 				/* This can happen if backtracking reached insn 0
 				 * and there are still reg_mask or stack_mask


