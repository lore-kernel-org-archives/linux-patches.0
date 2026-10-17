Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F2738E8BB;
	Sat, 17 Oct 2026 16:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253834; cv=none; b=g6fN25nhakhfy//9DLrK50NvPP+jpudCOhLEZDnUyjib/XK7giPgSXGst7sh3kTQFu0wOCHxN3ubAlhTie0BNpDfTujjPoJZIcvei99eeunYEUY3qj0LbNGiWWf9Hwc4p9RNW9aiMHzAl6bGdbFKvNx8LUSM3qEzupJoYdO1EM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253834; c=relaxed/simple;
	bh=AjUW8/9N45Vi/GXR2OLoJKr+UJcNxFOeOujSqQL9Xwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrKs1ouTF+DE1mNXycre7vP0pV0ES/OBSG9nsib6s/A6zscWsLa1gh9h4OHDNid5EwIXLEUVf06ZQfPLX1YXzvhom34dqfSmjTkuECrDKbA2lFMbkG/2YWoC2hF+iK/zX/ythiM3zboyJQv6oXq1wEIBWpsvunDAwc7zChNC0aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9bFNglx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9bFNglx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3CD1F000C4;
	Sat, 17 Oct 2026 16:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253833;
	bh=+AVbdjsOK68IbrdGGnd2VM0JoqyX5iYrfU2/hrNUA04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9bFNglxjl3nkifNK0islSNelGUBRcZb49YPyXwQt6yaDER+03CJ1S9skaAX5Eej5
	 CZWcVTLcl3BThYYBmiBAZfYcjyLTuKK5cXm2Up36tyacf8poD9Q2k3Lopw1KUButqG
	 w1XD3tNRwNfBue+SPHKvsZBZaGTdxrEXMa4WAYYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peilin Ye <yepeilin@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 208/869] bpf: Factor out check_atomic_rmw()
Date: Sat, 17 Oct 2026 17:50:49 +0200
Message-ID: <20261017160042.388827443@linuxfoundation.org>
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

From: Peilin Ye <yepeilin@google.com>

[ Upstream commit 2626ffe9f33f9e27aa0a60b2761c2d0760dbcca4 ]

Currently, check_atomic() only handles atomic read-modify-write (RMW)
instructions.  Since we are planning to introduce other types of atomic
instructions (i.e., atomic load/store), extract the existing RMW
handling logic into its own function named check_atomic_rmw().

Remove the @insn_idx parameter as it is not really necessary.  Use
'env->insn_idx' instead, as in other places in verifier.c.

Signed-off-by: Peilin Ye <yepeilin@google.com>
Link: https://lore.kernel.org/r/6323ac8e73a10a1c8ee547c77ed68cf8eb6b90e1.1740978603.git.yepeilin@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 179ee84a8911 ("bpf: Fix incorrect pruning due to atomic fetch precision tracking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 53 +++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1f5c8b5b74ffb..fdeb3948467d1 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7403,28 +7403,12 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 static int save_aux_ptr_type(struct bpf_verifier_env *env, enum bpf_reg_type type,
 			     bool allow_trust_mismatch);
 
-static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_insn *insn)
+static int check_atomic_rmw(struct bpf_verifier_env *env,
+			    struct bpf_insn *insn)
 {
 	int load_reg;
 	int err;
 
-	switch (insn->imm) {
-	case BPF_ADD:
-	case BPF_ADD | BPF_FETCH:
-	case BPF_AND:
-	case BPF_AND | BPF_FETCH:
-	case BPF_OR:
-	case BPF_OR | BPF_FETCH:
-	case BPF_XOR:
-	case BPF_XOR | BPF_FETCH:
-	case BPF_XCHG:
-	case BPF_CMPXCHG:
-		break;
-	default:
-		verbose(env, "BPF_ATOMIC uses invalid atomic opcode %02x\n", insn->imm);
-		return -EINVAL;
-	}
-
 	if (BPF_SIZE(insn->code) != BPF_W && BPF_SIZE(insn->code) != BPF_DW) {
 		verbose(env, "invalid atomic operand size\n");
 		return -EINVAL;
@@ -7486,12 +7470,12 @@ static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_i
 	/* Check whether we can read the memory, with second call for fetch
 	 * case to simulate the register fill.
 	 */
-	err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
+	err = check_mem_access(env, env->insn_idx, insn->dst_reg, insn->off,
 			       BPF_SIZE(insn->code), BPF_READ, -1, true, false);
 	if (!err && load_reg >= 0)
-		err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
-				       BPF_SIZE(insn->code), BPF_READ, load_reg,
-				       true, false);
+		err = check_mem_access(env, env->insn_idx, insn->dst_reg,
+				       insn->off, BPF_SIZE(insn->code),
+				       BPF_READ, load_reg, true, false);
 	if (err)
 		return err;
 
@@ -7501,13 +7485,34 @@ static int check_atomic(struct bpf_verifier_env *env, int insn_idx, struct bpf_i
 			return err;
 	}
 	/* Check whether we can write into the same memory. */
-	err = check_mem_access(env, insn_idx, insn->dst_reg, insn->off,
+	err = check_mem_access(env, env->insn_idx, insn->dst_reg, insn->off,
 			       BPF_SIZE(insn->code), BPF_WRITE, -1, true, false);
 	if (err)
 		return err;
 	return 0;
 }
 
+static int check_atomic(struct bpf_verifier_env *env, struct bpf_insn *insn)
+{
+	switch (insn->imm) {
+	case BPF_ADD:
+	case BPF_ADD | BPF_FETCH:
+	case BPF_AND:
+	case BPF_AND | BPF_FETCH:
+	case BPF_OR:
+	case BPF_OR | BPF_FETCH:
+	case BPF_XOR:
+	case BPF_XOR | BPF_FETCH:
+	case BPF_XCHG:
+	case BPF_CMPXCHG:
+		return check_atomic_rmw(env, insn);
+	default:
+		verbose(env, "BPF_ATOMIC uses invalid atomic opcode %02x\n",
+			insn->imm);
+		return -EINVAL;
+	}
+}
+
 /* When register 'regno' is used to read the stack (either directly or through
  * a helper function) make sure that it's within stack boundary and, depending
  * on the access type and privileges, that all elements of the stack are
@@ -18916,7 +18921,7 @@ static int do_check(struct bpf_verifier_env *env)
 			enum bpf_reg_type dst_reg_type;
 
 			if (BPF_MODE(insn->code) == BPF_ATOMIC) {
-				err = check_atomic(env, env->insn_idx, insn);
+				err = check_atomic(env, insn);
 				if (err)
 					return err;
 				env->insn_idx++;
-- 
2.53.0



