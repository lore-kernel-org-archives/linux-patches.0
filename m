Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB71C3F2116;
	Wed, 20 May 2026 17:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297758; cv=none; b=uc1aM6a0UYnMhNPwohT+gQg0Mbvl167I63dtSDUxcjLhZfVsixgbJr+aijo0zuEQdbx0KbjjWaHB3Wwk8pzgC3FaPyM68mw6AAa279WQOQ4A7cTswQxAP4BbJFcq3vBqglGircJ88VR1EUoI6pCVTQqdpIwSEEYFLLIn6QscpU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297758; c=relaxed/simple;
	bh=JGBrYJ5IXmrK+NA63Tra5g+DGFQrB8+W01oI8Yhig0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OktSuz7lhj9zA63AuoZY4Ypq3m3dv4jzOlFgf8v+m/KaEHbtDCuCKmN58tDIz7v4NjO02qOXaMy7TbFzjK5uUjnkiwcGU8UO3tGoZd+Ob+yga4o+9tuTecCuW6claff0RVI56KYdRU2qGjawhFN2QJkUIOIBvwcemA0JrgQFqw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7Mgq2Vf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7Mgq2Vf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7651F000E9;
	Wed, 20 May 2026 17:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297756;
	bh=0cNZ+GQKdEY9gnkJfI1rPFtAGOs6dAzr9MI2yDPd100=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k7Mgq2VfLsblG/6sdy3GhqOUL6KiXXivGiBwCVoQxNz7GdsKB4H9qSTchE3gMMUUc
	 vT69+NB9rTFsEhTDxHL5kdFLQ48ImHYWCELsqciYMyruUzvun1xKEy0KtdzmCAtlLM
	 /tdJWOGXoeYl2+f/iqaIXnye44Y75Jw9HYdRsmls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 152/957] bpf: Relax scalar id equivalence for state pruning
Date: Wed, 20 May 2026 18:10:35 +0200
Message-ID: <20260520162137.849248484@linuxfoundation.org>
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

[ Upstream commit b0388bafa4949bd30af7b3be5ee415f2a25ac014 ]

Scalar register IDs are used by the verifier to track relationships
between registers and enable bounds propagation across those
relationships. Once an ID becomes singular (i.e. only a single
register/stack slot carries it), it can no longer contribute to bounds
propagation and effectively becomes stale. The previous commit makes the
verifier clear such ids before caching the state.

When comparing the current and cached states for pruning, these stale
IDs can cause technically equivalent states to be considered different
and thus prevent pruning.

For example, in the selftest added in the next commit, two registers -
r6 and r7 are not linked to any other registers and get cached with
id=0, in the current state, they are both linked to each other with
id=A.  Before this commit, check_scalar_ids would give temporary ids to
r6 and r7 (say tid1 and tid2) and then check_ids() would map tid1->A,
and when it would see tid2->A, it would not consider these state
equivalent.

Relax scalar ID equivalence by treating rold->id == 0 as "independent":
if the old state did not rely on any ID relationships for a register,
then any ID/linking present in the current state only adds constraints
and is always safe to accept for pruning. Implement this by returning
true immediately in check_scalar_ids() when old_id == 0.

Maintain correctness for the opposite direction (old_id != 0 && cur_id
== 0) by still allocating a temporary ID for cur_id == 0. This avoids
incorrectly allowing multiple independent current registers (id==0) to
satisfy a single linked old ID during mapping.

Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Link: https://lore.kernel.org/r/20260203165102.2302462-5-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 2f2ec8e7730e ("bpf: Enforce regsafe base id consistency for BPF_ADD_CONST scalars")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c                         | 63 +++++++++++++++----
 .../selftests/bpf/progs/verifier_scalar_ids.c |  8 ++-
 2 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6d5fc1af7a1f6..0cf6ca1f870f7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -18808,13 +18808,29 @@ static bool check_ids(u32 old_id, u32 cur_id, struct bpf_idmap *idmap)
 	return false;
 }
 
-/* Similar to check_ids(), but allocate a unique temporary ID
- * for 'old_id' or 'cur_id' of zero.
- * This makes pairs like '0 vs unique ID', 'unique ID vs 0' valid.
+/*
+ * Compare scalar register IDs for state equivalence.
+ *
+ * When old_id == 0, the old register is independent - not linked to any
+ * other register. Any linking in the current state only adds constraints,
+ * making it more restrictive. Since the old state didn't rely on any ID
+ * relationships for this register, it's always safe to accept cur regardless
+ * of its ID. Hence, return true immediately.
+ *
+ * When old_id != 0 but cur_id == 0, we need to ensure that different
+ * independent registers in cur don't incorrectly satisfy the ID matching
+ * requirements of linked registers in old.
+ *
+ * Example: if old has r6.id=X and r7.id=X (linked), but cur has r6.id=0
+ * and r7.id=0 (both independent), without temp IDs both would map old_id=X
+ * to cur_id=0 and pass. With temp IDs: r6 maps X->temp1, r7 tries to map
+ * X->temp2, but X is already mapped to temp1, so the check fails correctly.
  */
 static bool check_scalar_ids(u32 old_id, u32 cur_id, struct bpf_idmap *idmap)
 {
-	old_id = old_id ? old_id : ++idmap->tmp_id_gen;
+	if (!old_id)
+		return true;
+
 	cur_id = cur_id ? cur_id : ++idmap->tmp_id_gen;
 
 	return check_ids(old_id, cur_id, idmap);
@@ -18975,11 +18991,21 @@ static bool regsafe(struct bpf_verifier_env *env, struct bpf_reg_state *rold,
 		}
 		if (!rold->precise && exact == NOT_EXACT)
 			return true;
-		if ((rold->id & BPF_ADD_CONST) != (rcur->id & BPF_ADD_CONST))
-			return false;
-		if ((rold->id & BPF_ADD_CONST) && (rold->off != rcur->off))
-			return false;
-		/* Why check_ids() for scalar registers?
+		/*
+		 * Linked register tracking uses rold->id to detect relationships.
+		 * When rold->id == 0, the register is independent and any linking
+		 * in rcur only adds constraints. When rold->id != 0, we must verify
+		 * id mapping and (for BPF_ADD_CONST) offset consistency.
+		 *
+		 * +------------------+-----------+------------------+---------------+
+		 * |                  | rold->id  | rold + ADD_CONST | rold->id == 0 |
+		 * |------------------+-----------+------------------+---------------|
+		 * | rcur->id         | range,ids | false            | range         |
+		 * | rcur + ADD_CONST | false     | range,ids,off    | range         |
+		 * | rcur->id == 0    | range,ids | false            | range         |
+		 * +------------------+-----------+------------------+---------------+
+		 *
+		 * Why check_ids() for scalar registers?
 		 *
 		 * Consider the following BPF code:
 		 *   1: r6 = ... unbound scalar, ID=a ...
@@ -19003,9 +19029,22 @@ static bool regsafe(struct bpf_verifier_env *env, struct bpf_reg_state *rold,
 		 * ---
 		 * Also verify that new value satisfies old value range knowledge.
 		 */
-		return range_within(rold, rcur) &&
-		       tnum_in(rold->var_off, rcur->var_off) &&
-		       check_scalar_ids(rold->id, rcur->id, idmap);
+
+		/* ADD_CONST mismatch: different linking semantics */
+		if ((rold->id & BPF_ADD_CONST) && !(rcur->id & BPF_ADD_CONST))
+			return false;
+
+		if (rold->id && !(rold->id & BPF_ADD_CONST) && (rcur->id & BPF_ADD_CONST))
+			return false;
+
+		/* Both have offset linkage: offsets must match */
+		if ((rold->id & BPF_ADD_CONST) && rold->off != rcur->off)
+			return false;
+
+		if (!check_scalar_ids(rold->id, rcur->id, idmap))
+			return false;
+
+		return range_within(rold, rcur) && tnum_in(rold->var_off, rcur->var_off);
 	case PTR_TO_MAP_KEY:
 	case PTR_TO_MAP_VALUE:
 	case PTR_TO_MEM:
diff --git a/tools/testing/selftests/bpf/progs/verifier_scalar_ids.c b/tools/testing/selftests/bpf/progs/verifier_scalar_ids.c
index 1fdd85b4b8443..f1c17df9c4f99 100644
--- a/tools/testing/selftests/bpf/progs/verifier_scalar_ids.c
+++ b/tools/testing/selftests/bpf/progs/verifier_scalar_ids.c
@@ -751,9 +751,9 @@ __success __log_level(2)
 /* The exit instruction should be reachable from two states,
  * use two matches and "processed .. insns" to ensure this.
  */
-__msg("13: (95) exit")
-__msg("13: (95) exit")
-__msg("processed 18 insns")
+__msg("15: (95) exit")
+__msg("15: (95) exit")
+__msg("processed 20 insns")
 __flag(BPF_F_TEST_STATE_FREQ)
 __naked void two_old_ids_one_cur_id(void)
 {
@@ -762,9 +762,11 @@ __naked void two_old_ids_one_cur_id(void)
 	"call %[bpf_ktime_get_ns];"
 	"r0 &= 0xff;"
 	"r6 = r0;"
+	"r8 = r0;"
 	"call %[bpf_ktime_get_ns];"
 	"r0 &= 0xff;"
 	"r7 = r0;"
+	"r9 = r0;"
 	"r0 = 0;"
 	/* Maybe make r{6,7} IDs identical */
 	"if r6 > r7 goto l0_%=;"
-- 
2.53.0



