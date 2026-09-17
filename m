Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C874CDDF3;
	Thu, 17 Sep 2026 15:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659478; cv=none; b=K67a369WPjjzDbz+iQ56L83TokmSydTwDQYhNoIc8mazZM56IbFnFvIscnPmUPrRK306FTw3quWHUcsHFurEUB85ad1/6ih0D5Mhd8l4BREZy2Sratqb2cgmAIoKfG2dU+oZa5r5F09vOwRniYVCdIiA/ychNwXgJk1V1hfMFK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659478; c=relaxed/simple;
	bh=aTIhbx726JHDQa869scVID/iZHGgABYz3eEnKXFRhyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIlUfNSTLU6+0qLhy6z4h+RPl6MwOpipqruD/sx7uAe6JwZ8aUfcvrabk1IONN93nnQ/FDcCXB/OnEa36BLeoZ52aKxjuYfH4/5D4H13FlOkFle95eo+hWixRxtLRVK+9OufLhsz+pn02eLFoCmsNuqKe18oCkixuyPpeVLnFtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HnAdft7M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HnAdft7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291D71F000FF;
	Thu, 17 Sep 2026 15:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659466;
	bh=zuQMp7Jp0USod7ycG3iVBjYevQqJklpRqN8+XQMK8m0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HnAdft7MhRmm5YZQOj4L5wNNOY0YDRgdbMs4XF2HmtLrHIF0jCAbHdwvqsUEUY48J
	 MryXKhD2SsOVRevHBvFjfaukHsVLL8kUXAr3oHNEFHnrxvVNjGuU4YgiLHwWcbNDZa
	 5MqRrIT6JezpaRk24aLwLVt1U0L0Oc1MVYVDSTX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 266/733] bpf: Mark NULL kptr stores precise
Date: Thu, 17 Sep 2026 16:09:34 +0100
Message-ID: <20260917151357.963530514@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit ecdc5043794c9184aa8e6c814603899479c46b35 ]

check_map_kptr_access() permits a scalar store into an untrusted kptr
field only when the register is known to contain zero. Unlike other
verifier checks whose outcome depends on a scalar value, it does not mark
that register precise.

A state checkpoint reached with an imprecise zero can therefore prune a
second path that reaches the store with an arbitrary nonzero scalar. The
program can write attacker-controlled bits into the kptr field and load
them back as a PTR_TO_BTF_ID.

Call mark_chain_precision() before accepting a known-zero register. This
forces state equivalence to compare its scalar range and makes the verifier
visit and reject a path carrying a nonzero value.

Fixes: 61df10c7799e ("bpf: Allow storing unreferenced kptr in map")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260904104203.345917-6-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 72994e41843ca..14bd6889f6de9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4528,8 +4528,15 @@ static int check_map_kptr_access(struct bpf_verifier_env *env,
 			return ret;
 	} else if (class == BPF_STX) {
 		val_reg = reg_state(env, value_regno);
-		if (!bpf_register_is_null(val_reg) &&
-		    map_kptr_match_type(env, kptr_field, val_reg, value_regno))
+		if (bpf_register_is_null(val_reg)) {
+			/*
+			 * This store is valid only because the scalar is known to be
+			 * zero. Mark it precise so another scalar cannot be pruned
+			 * against this state.
+			 */
+			return mark_chain_precision(env, value_regno);
+		}
+		if (map_kptr_match_type(env, kptr_field, val_reg, value_regno))
 			return -EACCES;
 	} else if (class == BPF_ST) {
 		if (insn->imm) {
-- 
2.53.0



