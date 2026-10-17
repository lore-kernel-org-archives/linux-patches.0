Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FE21E520A;
	Sat, 17 Oct 2026 16:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255448; cv=none; b=KhXS32qjn9tbF7lcYXAYdVOtdBt7D5pVTsdtzPVF23p2Zo6OrGVNvyAVqStqSFBbrqQl+II0tEHBr0COSEab7xKhNdTnoX8EgQozaSbOrjv3huecwDmv+9ifr0bLYWUdrArPF+rqL+jxUW+WpZIU3dNFoniGxI5AkYV8zIajHN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255448; c=relaxed/simple;
	bh=mtt+HDnOD4KN+OhmC0slUrsrDQWO/0pLapFs/KEM0fY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrlErzqGBl6ZIo/flf/HZcJzz66u10KT8MssB4L0LZoTocELsO4dVRllC1BdBpX0djFq9KFBQw1ho3okXr/wBYF8Ns5LgnELiqE2TFitxB5+lwj5gcYsAulVmVGgaoZ2giJRHiqbhN8YhMj7P9jyrcuk58CFmFwbRShnQuaht2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8ZYn//B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8ZYn//B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4608D1F000C4;
	Sat, 17 Oct 2026 16:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255446;
	bh=hJVe1Bt0GIZStOu4WRCfBIK8P+dVzCSsfrmz7pHiOCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s8ZYn//BcMRffYtP7gfiVv5Kk0KM+Rc6KEHE8jgar57eeAjSCWROGQ9pqDIfEDKuq
	 YgjZqyWhsbJJ86eR/DNr3f1tIGAeByUSgppw95I5TaxDsFfXhSDkYK5/BpPq73V0wF
	 Hv7kD+LX4izLcpUQBhIxaF5lB/kkf4dLXXPGIDu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 778/869] bpf: Mark NULL kptr stores precise
Date: Sat, 17 Oct 2026 18:00:19 +0200
Message-ID: <20261017160056.866246990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 75f8d73e6eb7d..ebce193173ce7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5704,8 +5704,15 @@ static int check_map_kptr_access(struct bpf_verifier_env *env, u32 regno,
 				kptr_field->kptr.btf_id, btf_ld_kptr_type(env, kptr_field));
 	} else if (class == BPF_STX) {
 		val_reg = reg_state(env, value_regno);
-		if (!register_is_null(val_reg) &&
-		    map_kptr_match_type(env, kptr_field, val_reg, value_regno))
+		if (register_is_null(val_reg)) {
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



