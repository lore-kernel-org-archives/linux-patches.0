Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7506E51C29;
	Mon,  8 Jan 2024 15:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gND6ikw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A80C433C9;
	Mon,  8 Jan 2024 15:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728470;
	bh=uf9yssLZQA6lSJhSCxmeRMk4ebUdyMsBa5zq3lZH4XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gND6ikwKOccOGQK2/HaM0RIQPmCNZMUXwn9kYX4b0ZiefccpB+FoXUo5H/OJPkDX
	 Ait2/Gad7znIH7FwOYfiQqCfP0OzF+/oYh//FiJg25B0F71z/H0sYegAJkIjVwIKtO
	 FvXxNQWQmelsK0orGM2388Hf5WZRK90DaUaemRtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/150] bpf: fix precision backtracking instruction iteration
Date: Mon,  8 Jan 2024 16:35:36 +0100
Message-ID: <20240108153515.146424663@linuxfoundation.org>
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

[ Upstream commit 4bb7ea946a370707315ab774432963ce47291946 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 95521beec66c5..142e10d49fd81 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2551,12 +2551,29 @@ static int push_jmp_history(struct bpf_verifier_env *env,
 
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
@@ -3052,9 +3069,9 @@ static int __mark_chain_precision(struct bpf_verifier_env *env, int frame, int r
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
-- 
2.43.0



