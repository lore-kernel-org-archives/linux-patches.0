Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214754;
	b=0y2TA0FTIZF8MhSss/sYgg5LebNHD6NBfBD9/9yyDs6SwkYLeUx9InqwcnsxT8Gxdc5O
	 0580iMtk9KydVy9A2AcJrXAsms8FGHJL1pYWa/h/sT/PHOghmttorst3erd041YKXsyLc
	 uHm3Oheln5AW0WbItn7W0alUFEKh34NlKU1WYKoWgr2dvODLq2O/xF+bDaMZhd8LEMtxy
	 YqCF4n+qRMhLrRqjIWewSqmr+59vBIjZ3vZ8c44C/miEMV/LaX31O5r1xhOw6jtT1+XLa
	 hflcJ9Kyn/1IWJ1Qr+InQP6qmfchYwKq4om/4jyVx4wrAqyigaUxRoK8vtgt1Oijxjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wQr/cmItbe7s2LPRjq8pNvHgNYzetRhyyiOa/E1O/Is=;
	b=Y7qycZyy3lVf5CW/jFNHWGu0hfVBiqJHUYTR2zWBJ04htdafUOnlX2rDqZ4EiKaJ49uI
	 AnqksNDHoSlAcN+D8YlXrYD3F1w1bBQi3g/YJMlAJGirn2Atjn/x57mDFQVpDb+DNdPav
	 +adLMFULAKJuLsYt8CJr6c/LQhe9CoFUHNqvyo4JKml/5uP/BSYqaDzK9amFszFYDW8Dc
	 KteX6JDb12TxpHc9Cvk7bIx7aSq2iosVyyYkB66t+W55eSq65Phcf+P7dXp75kxI5zKTr
	 OYBYBopf+u+yiskgfGmG8+daVxcfPOapnxUq4qq8sVtC+yLRT9mqzN94B7qaOaCw7QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=law+bJCn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D28606A323;
	Wed, 28 Oct 2026 19:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=law+bJCn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759551F01828;
	Wed, 28 Oct 2026 19:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214754;
	bh=wQr/cmItbe7s2LPRjq8pNvHgNYzetRhyyiOa/E1O/Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=law+bJCnkjDiZeLG/hwRG/29wEQYsVqN997bnFYq13JzIeYQDZHfpNGAC3FJDPWQj
	 hYGcjZ0MGr0FhlbR7ZqjNve5t6UMaWu+uv5ub1Jzdp9qVY4n3roxYseEcHZ3QH3Voj
	 ov3+rrNmn5FSckpxzbHsT5MVoi/2R1Xy6dujoxjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0970/1887] bpf: Fix incorrect pruning due to atomic fetch precision tracking
Date: Wed, 28 Oct 2026 17:51:06 +0100
Message-ID: <20261028170521.485147996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 179ee84a89114b854ac2dd1d293633a7f6c8dac1 ]

When backtrack_insn encounters a BPF_STX instruction with BPF_ATOMIC
and BPF_FETCH, the src register (or r0 for BPF_CMPXCHG) also acts as
a destination, thus receiving the old value from the memory location.

The current backtracking logic does not account for this. It treats
atomic fetch operations the same as regular stores where the src
register is only an input. This leads the backtrack_insn to fail to
propagate precision to the stack location, which is then not marked
as precise!

Later, the verifier's path pruning can incorrectly consider two states
equivalent when they differ in terms of stack state. Meaning, two
branches can be treated as equivalent and thus get pruned when they
should not be seen as such.

Fix it as follows: Extend the BPF_LDX handling in backtrack_insn to
also cover atomic fetch operations via is_atomic_fetch_insn() helper.
When the fetch dst register is being tracked for precision, clear it,
and propagate precision over to the stack slot. For non-stack memory,
the precision walk stops at the atomic instruction, same as regular
BPF_LDX. This covers all fetch variants.

Before:

  0: (b7) r1 = 8                        ; R1=8
  1: (7b) *(u64 *)(r10 -8) = r1         ; R1=8 R10=fp0 fp-8=8
  2: (b7) r2 = 0                        ; R2=0
  3: (db) r2 = atomic64_fetch_add((u64 *)(r10 -8), r2)          ; R2=8 R10=fp0 fp-8=mmmmmmmm
  4: (bf) r3 = r10                      ; R3=fp0 R10=fp0
  5: (0f) r3 += r2
  mark_precise: frame0: last_idx 5 first_idx 0 subseq_idx -1
  mark_precise: frame0: regs=r2 stack= before 4: (bf) r3 = r10
  mark_precise: frame0: regs=r2 stack= before 3: (db) r2 = atomic64_fetch_add((u64 *)(r10 -8), r2)
  mark_precise: frame0: regs=r2 stack= before 2: (b7) r2 = 0
  6: R2=8 R3=fp8
  6: (b7) r0 = 0                        ; R0=0
  7: (95) exit

After:

  0: (b7) r1 = 8                        ; R1=8
  1: (7b) *(u64 *)(r10 -8) = r1         ; R1=8 R10=fp0 fp-8=8
  2: (b7) r2 = 0                        ; R2=0
  3: (db) r2 = atomic64_fetch_add((u64 *)(r10 -8), r2)          ; R2=8 R10=fp0 fp-8=mmmmmmmm
  4: (bf) r3 = r10                      ; R3=fp0 R10=fp0
  5: (0f) r3 += r2
  mark_precise: frame0: last_idx 5 first_idx 0 subseq_idx -1
  mark_precise: frame0: regs=r2 stack= before 4: (bf) r3 = r10
  mark_precise: frame0: regs=r2 stack= before 3: (db) r2 = atomic64_fetch_add((u64 *)(r10 -8), r2)
  mark_precise: frame0: regs= stack=-8 before 2: (b7) r2 = 0
  mark_precise: frame0: regs= stack=-8 before 1: (7b) *(u64 *)(r10 -8) = r1
  mark_precise: frame0: regs=r1 stack= before 0: (b7) r1 = 8
  6: R2=8 R3=fp8
  6: (b7) r0 = 0                        ; R0=0
  7: (95) exit

Fixes: 5ffa25502b5a ("bpf: Add instructions for atomic_[cmp]xchg")
Fixes: 5ca419f2864a ("bpf: Add BPF_FETCH field / create atomic_fetch_add instruction")
Reported-by: STAR Labs SG <info@starlabs.sg>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260331222020.401848-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d7e9b84ff491b..2e26fdfa59e99 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -473,6 +473,13 @@ static bool is_cmpxchg_insn(const struct bpf_insn *insn)
 	       insn->imm == BPF_CMPXCHG;
 }
 
+static bool is_atomic_fetch_insn(const struct bpf_insn *insn)
+{
+	return BPF_CLASS(insn->code) == BPF_STX &&
+	       BPF_MODE(insn->code) == BPF_ATOMIC &&
+	       (insn->imm & BPF_FETCH);
+}
+
 /* string representation of 'enum bpf_reg_type'
  *
  * Note that reg_type_str() can not appear more than once in a single verbose()
@@ -2608,10 +2615,25 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx,
 			   * dreg still needs precision before this insn
 			   */
 		}
-	} else if (class == BPF_LDX) {
-		if (!(*reg_mask & dreg))
+	} else if (class == BPF_LDX || is_atomic_fetch_insn(insn)) {
+		u32 load_reg = dreg;
+		u8 base_reg = insn->src_reg;
+
+		/*
+		 * Atomic fetch operation writes the old value into
+		 * a register (sreg or r0) and if it was tracked for
+		 * precision, propagate to the stack slot like we do
+		 * in regular ldx.
+		 */
+		if (is_atomic_fetch_insn(insn)) {
+			load_reg = insn->imm == BPF_CMPXCHG ?
+				   1u << BPF_REG_0 : sreg;
+			base_reg = insn->dst_reg;
+		}
+
+		if (!(*reg_mask & load_reg))
 			return 0;
-		*reg_mask &= ~dreg;
+		*reg_mask &= ~load_reg;
 
 		/* scalars can only be spilled into stack w/o losing precision.
 		 * Load from any other memory can be zero extended.
@@ -2619,7 +2641,7 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx,
 		 * by 'precise' mark in corresponding register of this state.
 		 * No further tracking necessary.
 		 */
-		if (insn->src_reg != BPF_REG_FP)
+		if (base_reg != BPF_REG_FP)
 			return 0;
 
 		/* dreg = *(u64 *)[fp - off] was a fill from the stack.
-- 
2.53.0



