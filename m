Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5043A9DBE;
	Sat, 17 Oct 2026 16:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253718; cv=none; b=qS6kXAvto78ESd58wZRDQ0a3UF1yMt3mYhO65zYloCuX2/hPy5EDEi6aYWAUrOf6jCD7NFAUglVFLYCIzH7NX7LQKKYBl0dlJj4nMDE6Jpn7uFykhxowk0ndSvkk4F9PRsqvf3PpN2yOyOyr0RwgzFB+FQC4Nd9GkIl8es9sXxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253718; c=relaxed/simple;
	bh=Ydu78R5ZrSgihZSVDkm6iB8W+21la3c1QZiISvIZsi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a25CLZ2YrDgMs+jxPmnqetLJ2WBP4xqG8apZGd3lJUMqWUs0OvzJweewF3n2kGr2S0znrQxsCg4FyYqJvwtiPQpKGX17k3LmswSbj0WGnVmykGXbS2sFeZSa39aGG+VJz7xSYqBs9m++rJQEYeHId9rL6Nt+Nd1PLcdqoxA3z3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ARyD6/o7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARyD6/o7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4F61F000C4;
	Sat, 17 Oct 2026 16:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253714;
	bh=W2z2i1rdd1WqLGxWqhYFDLg4lo9V7ShFw14K54d6hXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ARyD6/o7gXxt2GWOLmL/CQqcU76KRsCOi9iXlw5EyNscXq0LerIOkj61Hzh/1afV5
	 DB5tpskCeF85JZbNWcjMRnImttwofIU/aUS40COpAdwgDn6jYG+UslhuUXp5i7FCWg
	 zzec/D99fzeQqlnctsi3WaB9zGh3o3LQFGB5AgO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 210/869] bpf: Fix incorrect pruning due to atomic fetch precision tracking
Date: Sat, 17 Oct 2026 17:50:51 +0200
Message-ID: <20261017160042.440141479@linuxfoundation.org>
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
 kernel/bpf/verifier.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d598c8f409c3e..5a1c8733f3222 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -578,6 +578,13 @@ static bool is_cmpxchg_insn(const struct bpf_insn *insn)
 	       insn->imm == BPF_CMPXCHG;
 }
 
+static bool is_atomic_fetch_insn(const struct bpf_insn *insn)
+{
+	return BPF_CLASS(insn->code) == BPF_STX &&
+	       BPF_MODE(insn->code) == BPF_ATOMIC &&
+	       (insn->imm & BPF_FETCH);
+}
+
 static int __get_spi(s32 off)
 {
 	return (-off - 1) / BPF_REG_SIZE;
@@ -3968,10 +3975,22 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx, int subseq_idx,
 			   * dreg still needs precision before this insn
 			   */
 		}
-	} else if (class == BPF_LDX) {
-		if (!bt_is_reg_set(bt, dreg))
+	} else if (class == BPF_LDX || is_atomic_fetch_insn(insn)) {
+		u32 load_reg = dreg;
+
+		/*
+		 * Atomic fetch operation writes the old value into
+		 * a register (sreg or r0) and if it was tracked for
+		 * precision, propagate to the stack slot like we do
+		 * in regular ldx.
+		 */
+		if (is_atomic_fetch_insn(insn))
+			load_reg = insn->imm == BPF_CMPXCHG ?
+				   BPF_REG_0 : sreg;
+
+		if (!bt_is_reg_set(bt, load_reg))
 			return 0;
-		bt_clear_reg(bt, dreg);
+		bt_clear_reg(bt, load_reg);
 
 		/* scalars can only be spilled into stack w/o losing precision.
 		 * Load from any other memory can be zero extended.
-- 
2.53.0



