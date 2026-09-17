Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11994A0F14;
	Thu, 17 Sep 2026 15:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659443; cv=none; b=tvJ2sU/o2Kt5rlVkLJ7rgG5LhSnTsODgwWRqoq5f/NHYJtfLSXS+UPE3r3Tbm14rqHeNGKJ88x8Wm5Va02w6YPvrwMC0noapsLwYcfwtzuAYQqCibPWSSP6VpQ8LxieBT5Y2SUm+aH1/7lD4M88JQLVq6DM3oWFdexfCrgOH4e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659443; c=relaxed/simple;
	bh=d3JgYLMMxtfkLwiYz+78D6eUjqF9z98bW+yhHbuFTmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftqln1HQenXsSX2e5O43s9Iwl73NWx06E+sPx7/qGHtqo1PkulaJmXWzmEoe0ozOq4O3eqNbKbO8f+NQDCmujDlMPyueGhA9sCPDiYzRhsL6goyBFlkBU18X7SsUq7s8X+9BAoTbX+ZUOG2ojN8cNQz/W04xtNmmNePxTDEUmOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXM1m4Zf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXM1m4Zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420981F0089B;
	Thu, 17 Sep 2026 15:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659436;
	bh=C63Bpzojx9h2M5KdF2tXp2hqeG7PIkPpp+hAndaGgR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iXM1m4ZfHROnbEl/Qy8MyfuLxuXuKZkS3GzuTZU1SV2xH4H7xjqOUUNDB9R/ym3mL
	 MggDz+8ADjJFI1rznoK2/9nDVFJ14bP70e6as4AYIPtvuZ4Ox/4qLqX4sbs0y7Vtqu
	 /roTxxBIANsNAPUp0UupHUgEOKAjs517d+f/HEjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 257/733] bpf: Mark the zero register precise for a register-form NULL check
Date: Thu, 17 Sep 2026 16:09:25 +0100
Message-ID: <20260917151357.708215497@linuxfoundation.org>
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

[ Upstream commit 6aed0134d3cda6382385a734ae0158eb7df6b142 ]

check_cond_jmp_op() accepts "if rA <op> rB" as a NULL check for a
nullable pointer rA when rB is a scalar known to be zero,
lifts PTR_MAYBE_NULL from rA in the corresponding branch and does not
mark rB precise. Consider the following program:

  r0 = bpf_get_prandom_u32();
  r6 = 1;                  /* the r6 == 0 path is explored first */
  if (r0 == 0) goto 1f;
  r6 = 0;
1:
  r0 = bpf_map_lookup_elem(map, &0);  /* absent, NULL at runtime */
  if (r0 == r6) goto 2f;   /* taken as a NULL check for r0       */
  *(u8 *)(r0 + 0);         /* verifier: map value; runtime: zero */
2:
  return 0;

The r6 == 0 path is explored first and the dereference is accepted.
The r6 == 1 path is pruned at the checkpoint recorded for (1),
so the comparison is never verified with a non-zero r6. At runtime a
failed lookup returns NULL, NULL != 1 takes the non-NULL edge and the
program dereferences a pointer that is zero.

Fixes: 2f4cb53eed44 ("bpf: detect non null pointer with register operand in JEQ/JNE.")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20260904083325.2083493-7-eddyz87@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d68f54a53c644..f913e3603a5ea 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -16296,6 +16296,15 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 	    type_may_be_null(dst_reg->type) &&
 	    ((BPF_SRC(insn->code) == BPF_K && insn->imm == 0) ||
 	     (BPF_SRC(insn->code) == BPF_X && bpf_register_is_null(src_reg)))) {
+		/*
+		 * For BPF_X the zero is a property of this execution path,
+		 * hence src_reg has to be precise.
+		 */
+		if (BPF_SRC(insn->code) == BPF_X) {
+			err = mark_chain_precision(env, insn->src_reg);
+			if (err)
+				return err;
+		}
 		/* Mark all identical registers in each branch as either
 		 * safe or unknown depending R == 0 or R != 0 conditional.
 		 */
-- 
2.53.0



