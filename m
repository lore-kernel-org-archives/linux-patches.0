Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BE85581F9;
	Thu, 17 Sep 2026 15:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659244; cv=none; b=tR/L1v42sOPV+UZprofkykiMRI5ls563a+7tUtSuxMn4fHG2sS7wbTqTqmd77DLUCeNfNL9Au0hgj8P3DVQ/gqzlvcsI6D8KXvZt7i2DWSn6uNjDEb0ttCwO7c70GDT7NfVnYwiVRAWG+s1moEn0wBcPe6hVjUNaS+W/Yq2mmII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659244; c=relaxed/simple;
	bh=27n5lz932e3Bv8//wUC+OeZsFaF08ri62XutHLMsGOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7zzbrlLKWu1V9OE6LIGFcuurxQAOqpk2tvvujVxJ2Z/E68H0Z0RBI9gGTrbAdTvAySHLRiB7y7lKXRugVYADPOSfwFCLiRsBD5nrH39WgjR+NwHrw7MB3kh5BKcdW26yDfU5iGRmMexGGVBMG4SplGRtjkC1/kbltZvgH23SB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdGfOHoh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdGfOHoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6641B1F000FF;
	Thu, 17 Sep 2026 15:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659236;
	bh=e0ea6klfyS9WsNO846x48zaB/TtS4oRYxTevTBvJw5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdGfOHohNBezWdjHKY2zpg9P/6MZ9FisWp5macvsl0dObim5dUov2yI/BL+sp7pqr
	 kFi4kmstnw15RA/SLBQHAqOyoXJUEBbMor6+xxXD7iPhE6wbfmFgatUHJdJD7mdpjW
	 5Pc0fxaFEfdW+0Q1UZZt9ycEJAqn4q8uFcn9iIkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 189/733] bpf: backtrack_insn(): Handle ld_{abs,ind} subprog exit edge
Date: Thu, 17 Sep 2026 16:08:17 +0100
Message-ID: <20260917151355.851946219@linuxfoundation.org>
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
 kernel/bpf/backtrack.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/backtrack.c b/kernel/bpf/backtrack.c
index 2e4ae0ef08609..ac7341f003b02 100644
--- a/kernel/bpf/backtrack.c
+++ b/kernel/bpf/backtrack.c
@@ -583,16 +583,29 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx, int subseq_idx,
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



