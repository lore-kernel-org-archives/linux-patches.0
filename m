Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0164C10C0;
	Thu, 17 Sep 2026 15:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659438; cv=none; b=mbmlAGJIi41cxfJsvYb9B5uk163njIF6hylovxNt8gh4NokmJu7ySCUDgUzLAV70C/oUz/bvckbYA4Cfj6oYopOodgxNJ2+6XhvsfgztP7h35oVCWuJADKCml7oD0/xo8Q5L7hGNA7etX02Kn/B65dbXEuRiCk1ChRqRl5Buz4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659438; c=relaxed/simple;
	bh=+EfShaMvnYsXvkNgd5ZrysbTaHlvrSpZ+7GYiHf1bP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCTUwcJaTogA3nYlpLe2qk9ewZh/9+kWf7c/pArwEqNFNJE8M+tmOSmRDkeQRm7bzDN3V3QLHuuBeqLU63w15f0No7MaBvq0WEsNbx8o7acBMIluMtqti5PAX+6rRFXbcKB93G1AZmKJ37lSWYvR1eCzaBoPcZVtTkerCItl9sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TIxcD8vZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TIxcD8vZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A5D1F000FF;
	Thu, 17 Sep 2026 15:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659430;
	bh=iq8awfH4wGyfFLqryo6JZzQBNT0c6dF4kZbxJslHjPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TIxcD8vZ8/7aduACmp8czxA8zrbVXDW8LSd2G4x1t53/TJ0851sHBsqj/wZxNPVh3
	 UAN6Vvjtl7N9dAzkpcUgtQxWBPNI1fo45P9oB0CE9mEYqwhnZBi3ykHqEQBYFWskup
	 Qdc1qdAXueG8s6cCXPe7Vw1ED4G7+8y9CAvmXJlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 255/733] bpf: Dont resurrect a scalar id dropped by collect_linked_regs()
Date: Thu, 17 Sep 2026 16:09:23 +0100
Message-ID: <20260917151357.654463967@linuxfoundation.org>
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

[ Upstream commit 73a98f96811e2cb0f4210b1caa8cb322f92f2a2b ]

check_cond_jmp_op() copies the compared registers into
env->{false,true}_reg{1,2} before collect_linked_regs() runs and copies
those snapshots back into both branch states afterwards.

collect_linked_regs() records at most LINKED_REGS_MAX members of a
linked registers group in the jump history and calls clear_scalar_id()
for every member that does not fit. The compared register is not exempt
from that.

As a consequence, sync_linked_regs() might adjust ranges for more
registers than bpf_bt_sync_linked_regs() can propagate precision to.

Collect the linked registers before the snapshots are taken instead.
This might lead to some unnecessary clear_scalar_id's, but from
previous testing situations with many linked registers are
extremely rare.

Fixes: ec1d77cb0ee9 ("bpf: Use bpf_verifier_env buffers for reg_set_min_max")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20260904083325.2083493-3-eddyz87@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 84b05958c3250..2c1da0d38450c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -16142,6 +16142,16 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 			return err;
 	}
 
+	/*
+	 * Collect the linked registers before env->{true,false}_reg{1,2} setup,
+	 * otherwise ids dropped by collect_linked_regs() would be resurrected
+	 * when env->{true,false}_reg{1,2} are copied back.
+	 */
+	if (BPF_SRC(insn->code) == BPF_X && src_reg->type == SCALAR_VALUE && src_reg->id)
+		collect_linked_regs(env, this_branch, src_reg->id, &linked_regs);
+	if (dst_reg->type == SCALAR_VALUE && dst_reg->id)
+		collect_linked_regs(env, this_branch, dst_reg->id, &linked_regs);
+
 	is_jmp32 = BPF_CLASS(insn->code) == BPF_JMP32;
 	env->false_reg1 = *dst_reg;
 	env->false_reg2 = *src_reg;
@@ -16196,10 +16206,6 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 	 * 'this_branch' and 'other_branch' share this history
 	 * if parent state is created.
 	 */
-	if (BPF_SRC(insn->code) == BPF_X && src_reg->type == SCALAR_VALUE && src_reg->id)
-		collect_linked_regs(env, this_branch, src_reg->id, &linked_regs);
-	if (dst_reg->type == SCALAR_VALUE && dst_reg->id)
-		collect_linked_regs(env, this_branch, dst_reg->id, &linked_regs);
 	if (linked_regs.cnt > 1) {
 		err = bpf_push_jmp_history(env, this_branch, 0, 0, 0, linked_regs_pack(&linked_regs));
 		if (err)
-- 
2.53.0



