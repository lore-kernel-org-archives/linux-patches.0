Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5EA1AAE28;
	Sat, 17 Oct 2026 17:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257722; cv=none; b=pwxreICmQncpHYrAQG7bHV9HHWjMk56npB52WSICzVI5Y5w2Iz3LX0imZHIo30ioy9zrijhjnbsmv4g8xuPy+mv2FuSfEU1tLXcMDBjKc8Hu2H5b+0WGzdt6xM/xk55W3m7DK0JXtowkCObjZdH01Idh/e1e+XlXz5T+P79EZbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257722; c=relaxed/simple;
	bh=U1ub3M7PetB/HUKUZl3YRyhK35b+2GT6kvBjvofz/Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJHmRCPHAgF4fEOuoA6admKTyyrvdnfPxvveGpJKZJKe/dYKrxP7VbtpoMVDHyGENwrIFDxZlblYYL0ZPImCWkm69q29EjPcmVmPGRLZ3VC5MxSv6gZ9NJc/FPyjreED95AaSk1n8t6OZeHos6Qd0VL9iJ+Qkiw0LdCKdOtvlkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enrYZHSM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enrYZHSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF191F000C4;
	Sat, 17 Oct 2026 17:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257721;
	bh=Ri2Ps0r0Fr7F2aiTvXhVlHo8ouye6NCBSBs9Ld2caz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=enrYZHSMQlJd25vLRpCeKdl44CXCETjZY+bf7MdbAcrLhSBAWix0CHGwE1qm1VApD
	 d1+trR+df+VlQrvNsK169BoYUZT2T/DEV0hRStj4Vsl44AhePFtJJgcvLxVB7Q9yT9
	 QVYG9S4HtaGwt9twiKYQJuH84aybBv1Zpru9l2ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zac Ecob <zacecob@protonmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0648/1674] bpf: Fix a sdiv overflow issue
Date: Sat, 17 Oct 2026 17:48:40 +0200
Message-ID: <20261017160447.741249133@linuxfoundation.org>
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

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit 7dd34d7b7dcf9309fc6224caf4dd5b35bedddcb7 ]

Zac Ecob reported a problem where a bpf program may cause kernel crash due
to the following error:
  Oops: divide error: 0000 [#1] PREEMPT SMP KASAN PTI

The failure is due to the below signed divide:
  LLONG_MIN/-1 where LLONG_MIN equals to -9,223,372,036,854,775,808.
LLONG_MIN/-1 is supposed to give a positive number 9,223,372,036,854,775,808,
but it is impossible since for 64-bit system, the maximum positive
number is 9,223,372,036,854,775,807. On x86_64, LLONG_MIN/-1 will
cause a kernel exception. On arm64, the result for LLONG_MIN/-1 is
LLONG_MIN.

Further investigation found all the following sdiv/smod cases may trigger
an exception when bpf program is running on x86_64 platform:
  - LLONG_MIN/-1 for 64bit operation
  - INT_MIN/-1 for 32bit operation
  - LLONG_MIN%-1 for 64bit operation
  - INT_MIN%-1 for 32bit operation
where -1 can be an immediate or in a register.

On arm64, there are no exceptions:
  - LLONG_MIN/-1 = LLONG_MIN
  - INT_MIN/-1 = INT_MIN
  - LLONG_MIN%-1 = 0
  - INT_MIN%-1 = 0
where -1 can be an immediate or in a register.

Insn patching is needed to handle the above cases and the patched codes
produced results aligned with above arm64 result. The below are pseudo
codes to handle sdiv/smod exceptions including both divisor -1 and divisor 0
and the divisor is stored in a register.

sdiv:
      tmp = rX
      tmp += 1 /* [-1, 0] -> [0, 1]
      if tmp >(unsigned) 1 goto L2
      if tmp == 0 goto L1
      rY = 0
  L1:
      rY = -rY;
      goto L3
  L2:
      rY /= rX
  L3:

smod:
      tmp = rX
      tmp += 1 /* [-1, 0] -> [0, 1]
      if tmp >(unsigned) 1 goto L1
      if tmp == 1 (is64 ? goto L2 : goto L3)
      rY = 0;
      goto L2
  L1:
      rY %= rX
  L2:
      goto L4  // only when !is64
  L3:
      wY = wY  // only when !is64
  L4:

  [1] https://lore.kernel.org/bpf/tPJLTEh7S_DxFEqAI2Ji5MBSoZVg7_G-Py2iaZpAaWtM961fFTWtsnlzwvTbzBzaUzwQAoNATXKUlt0LZOFgnDcIyKCswAnAGdUF3LBrhGQ=@protonmail.com/

Reported-by: Zac Ecob <zacecob@protonmail.com>
Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20240913150326.1187788-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 93 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 89 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8edf578a892cd..65d79d0234bb8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -19173,13 +19173,46 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 	int i, ret, cnt, delta = 0;
 
 	for (i = 0; i < insn_cnt; i++, insn++) {
-		/* Make divide-by-zero exceptions impossible. */
+		/* Make sdiv/smod divide-by-minus-one exceptions impossible. */
+		if ((insn->code == (BPF_ALU64 | BPF_MOD | BPF_K) ||
+		     insn->code == (BPF_ALU64 | BPF_DIV | BPF_K) ||
+		     insn->code == (BPF_ALU | BPF_MOD | BPF_K) ||
+		     insn->code == (BPF_ALU | BPF_DIV | BPF_K)) &&
+		    insn->off == 1 && insn->imm == -1) {
+			bool is64 = BPF_CLASS(insn->code) == BPF_ALU64;
+			bool isdiv = BPF_OP(insn->code) == BPF_DIV;
+			struct bpf_insn *patchlet;
+			struct bpf_insn chk_and_sdiv[] = {
+				BPF_RAW_INSN((is64 ? BPF_ALU64 : BPF_ALU) |
+					     BPF_NEG | BPF_K, insn->dst_reg,
+					     0, 0, 0),
+			};
+			struct bpf_insn chk_and_smod[] = {
+				BPF_MOV32_IMM(insn->dst_reg, 0),
+			};
+
+			patchlet = isdiv ? chk_and_sdiv : chk_and_smod;
+			cnt = isdiv ? ARRAY_SIZE(chk_and_sdiv) : ARRAY_SIZE(chk_and_smod);
+
+			new_prog = bpf_patch_insn_data(env, i + delta, patchlet, cnt);
+			if (!new_prog)
+				return -ENOMEM;
+
+			delta    += cnt - 1;
+			env->prog = prog = new_prog;
+			insn      = new_prog->insnsi + i + delta;
+			continue;
+		}
+
+		/* Make divide-by-zero and divide-by-minus-one exceptions impossible. */
 		if (insn->code == (BPF_ALU64 | BPF_MOD | BPF_X) ||
 		    insn->code == (BPF_ALU64 | BPF_DIV | BPF_X) ||
 		    insn->code == (BPF_ALU | BPF_MOD | BPF_X) ||
 		    insn->code == (BPF_ALU | BPF_DIV | BPF_X)) {
 			bool is64 = BPF_CLASS(insn->code) == BPF_ALU64;
 			bool isdiv = BPF_OP(insn->code) == BPF_DIV;
+			bool is_sdiv = isdiv && insn->off == 1;
+			bool is_smod = !isdiv && insn->off == 1;
 			struct bpf_insn *patchlet;
 			struct bpf_insn chk_and_div[] = {
 				/* [R,W]x div 0 -> 0 */
@@ -19199,10 +19232,62 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 				BPF_JMP_IMM(BPF_JA, 0, 0, 1),
 				BPF_MOV32_REG(insn->dst_reg, insn->dst_reg),
 			};
+			struct bpf_insn chk_and_sdiv[] = {
+				/* [R,W]x sdiv 0 -> 0
+				 * LLONG_MIN sdiv -1 -> LLONG_MIN
+				 * INT_MIN sdiv -1 -> INT_MIN
+				 */
+				BPF_MOV64_REG(BPF_REG_AX, insn->src_reg),
+				BPF_RAW_INSN((is64 ? BPF_ALU64 : BPF_ALU) |
+					     BPF_ADD | BPF_K, BPF_REG_AX,
+					     0, 0, 1),
+				BPF_RAW_INSN((is64 ? BPF_JMP : BPF_JMP32) |
+					     BPF_JGT | BPF_K, BPF_REG_AX,
+					     0, 4, 1),
+				BPF_RAW_INSN((is64 ? BPF_JMP : BPF_JMP32) |
+					     BPF_JEQ | BPF_K, BPF_REG_AX,
+					     0, 1, 0),
+				BPF_RAW_INSN((is64 ? BPF_ALU64 : BPF_ALU) |
+					     BPF_MOV | BPF_K, insn->dst_reg,
+					     0, 0, 0),
+				/* BPF_NEG(LLONG_MIN) == -LLONG_MIN == LLONG_MIN */
+				BPF_RAW_INSN((is64 ? BPF_ALU64 : BPF_ALU) |
+					     BPF_NEG | BPF_K, insn->dst_reg,
+					     0, 0, 0),
+				BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+				*insn,
+			};
+			struct bpf_insn chk_and_smod[] = {
+				/* [R,W]x mod 0 -> [R,W]x */
+				/* [R,W]x mod -1 -> 0 */
+				BPF_MOV64_REG(BPF_REG_AX, insn->src_reg),
+				BPF_RAW_INSN((is64 ? BPF_ALU64 : BPF_ALU) |
+					     BPF_ADD | BPF_K, BPF_REG_AX,
+					     0, 0, 1),
+				BPF_RAW_INSN((is64 ? BPF_JMP : BPF_JMP32) |
+					     BPF_JGT | BPF_K, BPF_REG_AX,
+					     0, 3, 1),
+				BPF_RAW_INSN((is64 ? BPF_JMP : BPF_JMP32) |
+					     BPF_JEQ | BPF_K, BPF_REG_AX,
+					     0, 3 + (is64 ? 0 : 1), 1),
+				BPF_MOV32_IMM(insn->dst_reg, 0),
+				BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+				*insn,
+				BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+				BPF_MOV32_REG(insn->dst_reg, insn->dst_reg),
+			};
 
-			patchlet = isdiv ? chk_and_div : chk_and_mod;
-			cnt = isdiv ? ARRAY_SIZE(chk_and_div) :
-				      ARRAY_SIZE(chk_and_mod) - (is64 ? 2 : 0);
+			if (is_sdiv) {
+				patchlet = chk_and_sdiv;
+				cnt = ARRAY_SIZE(chk_and_sdiv);
+			} else if (is_smod) {
+				patchlet = chk_and_smod;
+				cnt = ARRAY_SIZE(chk_and_smod) - (is64 ? 2 : 0);
+			} else {
+				patchlet = isdiv ? chk_and_div : chk_and_mod;
+				cnt = isdiv ? ARRAY_SIZE(chk_and_div) :
+					      ARRAY_SIZE(chk_and_mod) - (is64 ? 2 : 0);
+			}
 
 			new_prog = bpf_patch_insn_data(env, i + delta, patchlet, cnt);
 			if (!new_prog)
-- 
2.53.0



