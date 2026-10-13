Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1669E3D9DA8;
	Tue, 13 Oct 2026 12:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894325; cv=none; b=iL1AhaQge1iLYNY4393lAhSQKzBJetuaDmId+4eqy0F1/E7bzin8ovDatcqILDpP37WUYON3mVHilBKj2zB4bvZunwm1b9XZ5usvvoP16EsItReWFwSgNUDJazo9Ken4pt0RZuIfhqjdeF9Z4LaaoxfS8EKKzswtr/UxupZdTHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894325; c=relaxed/simple;
	bh=RAAcXmip+vbNJTDyG1aQcuZZL8nnLPl8qwTQJuVt9is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njHMCOJ/xnsDHZrelhyOZI7NKckmjCH7G9itBPioT2QJIyZ0HUG+2jYiAabQoSjfp0q7z5uCiv3BwKn8kAmfW5itdNfnENiWzHYQwfUv/OG9D6omeFPbvHjuUKkdbUaODc4Hq1npYjFMBzhKqIVnwjUGbN66zHuTZ3xlEzmum/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxhX7uSk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxhX7uSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A72C1F000FF;
	Tue, 13 Oct 2026 12:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894323;
	bh=D5SBPxnFnmjZBEIPTcBL1nkKgTnrmohYS3e4yRkPHLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CxhX7uSkZsWjQ3qqQ1HjW3fqa9/fsXrdCFgcT+JElt2/Fz2mWraX72DvQisXyPXId
	 CdwX0VOsuEchFR24yi3YjTCEmVhEyGKHdmuuQPlVnwgR8deh12nBIdDy1YNeO64vV3
	 1ARgnuboCURcpwk/lbcVHBpMYQ6jG5288KQuhFxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 521/621] bpf: backtrack_insn(): Handle ld_{abs,ind} subprog exit edge
Date: Tue, 13 Oct 2026 13:38:36 +0200
Message-ID: <20261013112933.186217617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 387b1baefbb776e3f48dc2261e77a49213f470f7 ]

Nicholas Carlini reported a bug in precision backtracking mechanism
for BPF_LD | BPF_{IND,ABS} instructions. These instructions are
modelled as two branches:
- fallthrough;
- implicit exit from current subprogram.

The implicit exit case was not handled by the backtrack_insn()
function. When backtracking such a path backtrack_insn() did not
call bt_subprog_enter(), which meant that backtracking continued
manipulating precision marks in a caller frame, while looking at
instructions in a callee frame.

This lead to segmentation faults during verification (see the
selftest), or unsound state pruning.

Fixes: ee861486e377 ("bpf: Fix ld_{abs,ind} failure path analysis in subprogs")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20260901-bug-016-backtrack-ld-abs-v1-1-59368f1be435@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index faa4f8d69cbbb..59f1f570e4a57 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4573,16 +4573,29 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx, int subseq_idx,
 			  */
 		}
 	} else if (class == BPF_LD) {
-		if (!bt_is_reg_set(bt, dreg))
-			return 0;
-		bt_clear_reg(bt, dreg);
 		/* It's ld_imm64 or ld_abs or ld_ind.
 		 * For ld_imm64 no further tracking of precision
 		 * into parent is necessary
 		 */
-		if (mode == BPF_IND || mode == BPF_ABS)
-			/* to be analyzed */
-			return -ENOTSUPP;
+		if (mode == BPF_IMM) {
+			bt_clear_reg(bt, dreg);
+			return 0;
+		}
+		/*
+		 * BPF_{IND,ABS} are modelled as two branches:
+		 * - fallthrough;
+		 * - implicit subprogram exit.
+		 * It is necessary to switch current frame if
+		 * implicit subprogram exit branch is backtracked.
+		 */
+		if (mode == BPF_IND || mode == BPF_ABS) {
+			if (bt_is_reg_set(bt, dreg))
+				return -ENOTSUPP;
+			if (subseq_idx != idx + 1)
+				if (bt_subprog_enter(bt))
+					return -EFAULT;
+			return 0;
+		}
 	}
 	/* Propagate precision marks to linked registers, to account for
 	 * registers marked as precise in this function.
-- 
2.53.0



