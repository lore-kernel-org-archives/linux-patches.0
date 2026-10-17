Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7CD3A380C;
	Sat, 17 Oct 2026 18:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260812; cv=none; b=bzPN2Ua1UG7mWmFYLlk4v8sSYwui5Ifz+rvzRrIOqJCgvvmWC1TPsOY12q3ffaXXWzbpZ0Db2tgM3PknxdRICUwIjDW4jwhltwoP2IvOewe9hU7At/U4G/SD5e7i6WncPHOlNA+MTRXKFkUX82d0nhSMYDQr+wns80LXEw1Z1iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260812; c=relaxed/simple;
	bh=Z3VGq9L7gcDWxg0tKvYfA4TyH/IhvgfdE/3SQnSnb08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBYKXHXePCoS9YYNEU7ggMb3XKiDnfzPD3KE/ffEsn4BcDbedichNhXD4Yhuix4pfgMiNMU+m8S2xEquiMGOj4LqDSRyWBudIA72fT03Ly+W7G7v6IhpRYqwsesmk5kUleLCz8bGPfFYHspKNshlGYFBnNNHuMUbRMyF0cOkbGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cc7VvpVO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cc7VvpVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C231F000C4;
	Sat, 17 Oct 2026 18:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260811;
	bh=WT7WkfD5QQ5MN36438u4AO72XuAxzAXpiODp1kX528g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cc7VvpVOFXgz/HezqjdsFfQRQI42dLc/Bt+VyncFUawwQe/GKIhlt8xDVvqJSojfN
	 21bCy0hGGJojeDjIff3PVv68PQ1dvEjo96ipnXoXeMGPgIzxJ/+LV80gjkcnxGxyaJ
	 HKvI2k2lvCJdTUdGMVrodEShDd3CVZyr5umtbmHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1631/1674] bpf: generalize is_branch_taken to handle all conditional jumps in one place
Date: Sat, 17 Oct 2026 18:05:03 +0200
Message-ID: <20261017160512.944735236@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit b74c2a842bba941945279027083fcee1e9aaa73f ]

Make is_branch_taken() a single entry point for branch pruning decision
making, handling both pointer vs pointer, pointer vs scalar, and scalar
vs scalar cases in one place. This also nicely cleans up check_cond_jmp_op().

Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20231102033759.2541186-15-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: e51179a4e098 ("bpf: Don't predict JMP32 pointer vs zero comparisons")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 49 ++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index da8ab195600cc..749d050e72e0f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14076,6 +14076,19 @@ static void find_good_pkt_pointers(struct bpf_verifier_state *vstate,
 	}));
 }
 
+/* check if register is a constant scalar value */
+static bool is_reg_const(struct bpf_reg_state *reg, bool subreg32)
+{
+	return reg->type == SCALAR_VALUE &&
+	       tnum_is_const(subreg32 ? tnum_subreg(reg->var_off) : reg->var_off);
+}
+
+/* assuming is_reg_const() is true, return constant value of a register */
+static u64 reg_const_value(struct bpf_reg_state *reg, bool subreg32)
+{
+	return subreg32 ? tnum_subreg(reg->var_off).value : reg->var_off.value;
+}
+
 /*
  * <reg1> <op> <reg2>, currently assuming reg2 is a constant
  */
@@ -14317,12 +14330,20 @@ static int is_pkt_ptr_branch_taken(struct bpf_reg_state *dst_reg,
 static int is_branch_taken(struct bpf_reg_state *reg1, struct bpf_reg_state *reg2,
 			   u8 opcode, bool is_jmp32)
 {
-	struct tnum reg2_tnum = is_jmp32 ? tnum_subreg(reg2->var_off) : reg2->var_off;
 	u64 val;
 
-	if (!tnum_is_const(reg2_tnum))
+	if (reg_is_pkt_pointer_any(reg1) && reg_is_pkt_pointer_any(reg2) && !is_jmp32)
+		return is_pkt_ptr_branch_taken(reg1, reg2, opcode);
+
+	/* try to make sure reg2 is a constant SCALAR_VALUE */
+	if (!is_reg_const(reg2, is_jmp32)) {
+		opcode = flip_opcode(opcode);
+		swap(reg1, reg2);
+	}
+	/* for now we expect reg2 to be a constant to make any useful decisions */
+	if (!is_reg_const(reg2, is_jmp32))
 		return -1;
-	val = reg2_tnum.value;
+	val = reg_const_value(reg2, is_jmp32);
 
 	if (__is_pointer_value(false, reg1)) {
 		if (!reg_not_null(reg1))
@@ -14879,27 +14900,7 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 	}
 
 	is_jmp32 = BPF_CLASS(insn->code) == BPF_JMP32;
-
-	if (BPF_SRC(insn->code) == BPF_K) {
-		pred = is_branch_taken(dst_reg, src_reg, opcode, is_jmp32);
-	} else if (src_reg->type == SCALAR_VALUE &&
-		   is_jmp32 && tnum_is_const(tnum_subreg(src_reg->var_off))) {
-		pred = is_branch_taken(dst_reg, src_reg, opcode, is_jmp32);
-	} else if (src_reg->type == SCALAR_VALUE &&
-		   !is_jmp32 && tnum_is_const(src_reg->var_off)) {
-		pred = is_branch_taken(dst_reg, src_reg, opcode, is_jmp32);
-	} else if (dst_reg->type == SCALAR_VALUE &&
-		   is_jmp32 && tnum_is_const(tnum_subreg(dst_reg->var_off))) {
-		pred = is_branch_taken(src_reg, dst_reg, flip_opcode(opcode), is_jmp32);
-	} else if (dst_reg->type == SCALAR_VALUE &&
-		   !is_jmp32 && tnum_is_const(dst_reg->var_off)) {
-		pred = is_branch_taken(src_reg, dst_reg, flip_opcode(opcode), is_jmp32);
-	} else if (reg_is_pkt_pointer_any(dst_reg) &&
-		   reg_is_pkt_pointer_any(src_reg) &&
-		   !is_jmp32) {
-		pred = is_pkt_ptr_branch_taken(dst_reg, src_reg, opcode);
-	}
-
+	pred = is_branch_taken(dst_reg, src_reg, opcode, is_jmp32);
 	if (pred >= 0) {
 		/* If we get here with a dst_reg pointer type it is because
 		 * above is_branch_taken() special cased the 0 comparison.
-- 
2.53.0



