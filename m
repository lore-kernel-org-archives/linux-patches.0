Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E01036A376;
	Wed, 20 May 2026 17:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297771; cv=none; b=As4xnqvTmO+SD5Bv5+cNb0lxObpyB6gZaf6yrGumkXyEqOajPCazCNnB+56IQhVdDzDGc19TcRw7xn27YTQm2TG9HNosKs8xW+eySvZlAlhXdT6vz/ghMHa/NedE8VW8+Fop2lszBllkgQQvtlkgXPq6WvovDxlAl/rpc3yh/Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297771; c=relaxed/simple;
	bh=OOp+Z3URAoTKcDJiU3WXbFnpkY5MfaP6j7GDGuxtvo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKLaJSp7V61lEjiFjBdh+m02yKOoJWKRkQv6vGnA9gw7HygFD1t1zsW+qahb2nkcghT9Z0ALq4LyroSVt4ce5or7b4EZqKyIaYA2bULfTPvsjZ/p31oeSfOlEWmFEMQ+GY7t/tNx536i0KhJlj/Q33LXf9AZPzIndIjQ++zrIRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HuhE/SM1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HuhE/SM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7B21F000E9;
	Wed, 20 May 2026 17:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297769;
	bh=+0/ueQUHhpE/n8yYT9+CdnCczkAh31EhYn2/ncYyH+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HuhE/SM18NIJNktPP8tsqFejwjYXqLewQERnkepdX3EPiJVSUkZ91eEq8aRCc6hky
	 Dn8d4gjgmXt1U6NlKWbcxyJ2LfkHsDqhjDv7s/ci3/I8Cjf6GyYvdogCi6Fxl6gqMM
	 qAp1vd4jZJZA5eLQJh0yt7FYtdDAPeQdSVp7IvBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 130/957] bpf: Support negative offsets, BPF_SUB, and alu32 for linked register tracking
Date: Wed, 20 May 2026 18:10:13 +0200
Message-ID: <20260520162137.374873895@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit 7a433e519364c3c19643e5c857f4fbfaebec441c ]

Previously, the verifier only tracked positive constant deltas between
linked registers using BPF_ADD. This limitation meant patterns like:

  r1 = r0;
  r1 += -4;
  if r1 s>= 0 goto l0_%=;   // r1 >= 0 implies r0 >= 4
  // verifier couldn't propagate bounds back to r0
  if r0 != 0 goto l0_%=;
	r0 /= 0; // Verifier thinks this is reachable
  l0_%=:

Similar limitation exists for 32-bit registers.

With this change, the verifier can now track negative deltas in reg->off
enabling bound propagation for the above pattern.

For alu32, we make sure the destination register has the upper 32 bits
as 0s before creating the link. BPF_ADD_CONST is split into
BPF_ADD_CONST64 and BPF_ADD_CONST32, the latter is used in case of alu32
and sync_linked_regs uses this to zext the result if known_reg has this
flag.

Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260204151741.2678118-2-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: d7f14173c0d5 ("bpf: Fix linked reg delta tracking when src_reg == dst_reg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h                  |  6 ++-
 kernel/bpf/verifier.c                         | 50 +++++++++++++++----
 .../selftests/bpf/progs/verifier_bounds.c     |  2 +-
 3 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 4c497e839526a..4867b0e8b5d9d 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -147,8 +147,12 @@ struct bpf_reg_state {
 	 * registers. Example:
 	 * r1 = r2;    both will have r1->id == r2->id == N
 	 * r1 += 10;   r1->id == N | BPF_ADD_CONST and r1->off == 10
+	 * r3 = r2;    both will have r3->id == r2->id == N
+	 * w3 += 10;   r3->id == N | BPF_ADD_CONST32 and r3->off == 10
 	 */
-#define BPF_ADD_CONST (1U << 31)
+#define BPF_ADD_CONST64 (1U << 31)
+#define BPF_ADD_CONST32 (1U << 30)
+#define BPF_ADD_CONST (BPF_ADD_CONST64 | BPF_ADD_CONST32)
 	u32 id;
 	/* PTR_TO_SOCKET and PTR_TO_TCP_SOCK could be a ptr returned
 	 * from a pointer-cast helper, bpf_sk_fullsock() and
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0d1ec2b5d469a..6cf8b13db301b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15787,6 +15787,13 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
 		verbose(env, "verifier internal error: no src_reg\n");
 		return -EFAULT;
 	}
+	/*
+	 * For alu32 linked register tracking, we need to check dst_reg's
+	 * umax_value before the ALU operation. After adjust_scalar_min_max_vals(),
+	 * alu32 ops will have zero-extended the result, making umax_value <= U32_MAX.
+	 */
+	u64 dst_umax = dst_reg->umax_value;
+
 	err = adjust_scalar_min_max_vals(env, insn, dst_reg, *src_reg);
 	if (err)
 		return err;
@@ -15796,26 +15803,44 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
 	 * r1 += 0x1
 	 * if r2 < 1000 goto ...
 	 * use r1 in memory access
-	 * So for 64-bit alu remember constant delta between r2 and r1 and
-	 * update r1 after 'if' condition.
+	 * So remember constant delta between r2 and r1 and update r1 after
+	 * 'if' condition.
 	 */
 	if (env->bpf_capable &&
-	    BPF_OP(insn->code) == BPF_ADD && !alu32 &&
-	    dst_reg->id && is_reg_const(src_reg, false)) {
-		u64 val = reg_const_value(src_reg, false);
+	    (BPF_OP(insn->code) == BPF_ADD || BPF_OP(insn->code) == BPF_SUB) &&
+	    dst_reg->id && is_reg_const(src_reg, alu32)) {
+		u64 val = reg_const_value(src_reg, alu32);
+		s32 off;
+
+		if (!alu32 && ((s64)val < S32_MIN || (s64)val > S32_MAX))
+			goto clear_id;
+
+		if (alu32 && (dst_umax > U32_MAX))
+			goto clear_id;
 
-		if ((dst_reg->id & BPF_ADD_CONST) ||
-		    /* prevent overflow in sync_linked_regs() later */
-		    val > (u32)S32_MAX) {
+		off = (s32)val;
+
+		if (BPF_OP(insn->code) == BPF_SUB) {
+			/* Negating S32_MIN would overflow */
+			if (off == S32_MIN)
+				goto clear_id;
+			off = -off;
+		}
+
+		if (dst_reg->id & BPF_ADD_CONST) {
 			/*
 			 * If the register already went through rX += val
 			 * we cannot accumulate another val into rx->off.
 			 */
+clear_id:
 			dst_reg->off = 0;
 			dst_reg->id = 0;
 		} else {
-			dst_reg->id |= BPF_ADD_CONST;
-			dst_reg->off = val;
+			if (alu32)
+				dst_reg->id |= BPF_ADD_CONST32;
+			else
+				dst_reg->id |= BPF_ADD_CONST64;
+			dst_reg->off = off;
 		}
 	} else {
 		/*
@@ -16888,7 +16913,7 @@ static void sync_linked_regs(struct bpf_verifier_state *vstate, struct bpf_reg_s
 			u32 saved_id = reg->id;
 
 			fake_reg.type = SCALAR_VALUE;
-			__mark_reg_known(&fake_reg, (s32)reg->off - (s32)known_reg->off);
+			__mark_reg_known(&fake_reg, (s64)reg->off - (s64)known_reg->off);
 
 			/* reg = known_reg; reg += delta */
 			copy_register_state(reg, known_reg);
@@ -16903,6 +16928,9 @@ static void sync_linked_regs(struct bpf_verifier_state *vstate, struct bpf_reg_s
 			scalar32_min_max_add(reg, &fake_reg);
 			scalar_min_max_add(reg, &fake_reg);
 			reg->var_off = tnum_add(reg->var_off, fake_reg.var_off);
+			if (known_reg->id & BPF_ADD_CONST32)
+				zext_32_to_64(reg);
+			reg_bounds_sync(reg);
 		}
 	}
 }
diff --git a/tools/testing/selftests/bpf/progs/verifier_bounds.c b/tools/testing/selftests/bpf/progs/verifier_bounds.c
index e772ae430915f..ea5db79da40ef 100644
--- a/tools/testing/selftests/bpf/progs/verifier_bounds.c
+++ b/tools/testing/selftests/bpf/progs/verifier_bounds.c
@@ -1477,7 +1477,7 @@ __naked void sub64_full_overflow(void)
 SEC("socket")
 __description("64-bit subtraction, partial overflow, result in unbounded reg")
 __success __log_level(2)
-__msg("3: (1f) r3 -= r2 {{.*}} R3=scalar()")
+__msg("3: (1f) r3 -= r2 {{.*}} R3=scalar(id=1-1)")
 __retval(0)
 __naked void sub64_partial_overflow(void)
 {
-- 
2.53.0



