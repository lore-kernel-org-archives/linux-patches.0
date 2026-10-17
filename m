Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFCC3C4B8D;
	Sat, 17 Oct 2026 18:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260738; cv=none; b=U1wOLH1MBFw97T3pNe9oPF8EP/v1tXEG2g2IdRrEeZk/WVcbIfuwv2Qhc+MIzrZD7Pm7yRlUop/HW2FWbM48zuNo73NYr7tC9VxCG7M+i7nsHdFMYHEK4PSz1pbzGlz8JtiRv1ZMnvr0E7vit0zGHok0KmgFhvVVxxJcIVLwzaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260738; c=relaxed/simple;
	bh=BsLOBVwilcTDyUVShQwm8e0ZzTLuPyODmcbRTjGYK3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJbQSiLJvL07Fjd56EYOFYCXGtcWQyOv7p1S6EFc6TIRTHkYkVChW6hcmPnl4bFEIL+MkpDhEe/DwJ0Cm9333NoyusJqPpciC9s7dYbTePjGBttDM04KFhyNpfVTwC3w3WemnwHAJofLS34Mko5Jdsyw924CPCXBKFZp4J05SOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/bn8MTQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/bn8MTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B858B1F000C4;
	Sat, 17 Oct 2026 18:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260737;
	bh=W3574ff3XMcPokuAhLlS6xdt1KES87WwlGSZNhlZj7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g/bn8MTQJ7Ajw24oNpZ/+e78V1tgch2K6ABjuLA90bopRh/8cfem1UfJfHcFiZhVj
	 5rkOuy0Y9obU0/6EgGSBbB13w94cWg9hwE809cpcj6aQn8UQP77xFftAnoVAVZpwjz
	 kN4EFAPO46HqU+4BrG5izLwpIeGAfXRpacSINRiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1645/1674] bpf: backtrack_insn(): Handle ld_{abs,ind} subprog exit edge
Date: Sat, 17 Oct 2026 18:05:17 +0200
Message-ID: <20261017160513.295207139@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 46db1c02c1ad0..b49de1b31a3e3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4168,16 +4168,29 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx, int subseq_idx,
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



