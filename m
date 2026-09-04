Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1686F39EF1C;
	Fri,  4 Sep 2026 05:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500356; cv=none; b=i+hkGE/lc5wEuyZ6R1Vi1bFyDuObBY84n7B6m2v9qKU7ZiUbRivSo3uRpP+TqWyGQi7AyE3p4qzi7dw+gtLWxet7JiMWGi4wCYLahU5Zc0Z4NM/6GcyXMfh3lmqkmSK0jgMnK2MhXiKTGPiK016h+9U1QGnhnrnFlEQZi71yBeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500356; c=relaxed/simple;
	bh=Z4oRfeXzqtE1VUYMBCopd5soPM2QpvRY4DZjso1A6vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5GFllZY0s0Qzh8I4Ic+ztSursMVlD2CkDwfW69zjM5rREB16fa1JBdV1BEksQD10LxT6IoJmknJgTDvWAu6Z2M3IWMUQTatoseY8pOMxzF9xC8dTMR0tSUCTUWYubd3YGMmYk7GBKvQdmXd7GSbyidmbw2NKHmWLQwQAi0uMtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wj2p4Bnq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wj2p4Bnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672521F00A3E;
	Fri,  4 Sep 2026 05:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500354;
	bh=CILK+DbtGLJROlRey3V2Ybm9ruS0ERhaaNikC8o4wto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wj2p4BnqGmHPuI9HMDjb5KsXTXn18OeMm7rkeXF4ceUZWIJi/ghkoU/HS7NbbwXNn
	 +isBdsBFKyc2xQp3Ftt682+bIThPBa0AJcB3SUh++ij5jj+p2K8dOgoNnTwV9LABgc
	 /o2J7GQ7LGs8GnqSV5Aged/2vLDpz1sli6IDfEXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 006/552] bpf: Fix incorrect pruning due to atomic fetch precision tracking
Date: Fri,  4 Sep 2026 06:52:43 +0200
Message-ID: <20260904045747.970326716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
 kernel/bpf/verifier.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 459ed144542cc..dcecf88068560 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -611,6 +611,13 @@ static bool is_atomic_load_insn(const struct bpf_insn *insn)
 	       insn->imm == BPF_LOAD_ACQ;
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
@@ -4323,10 +4330,24 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx, int subseq_idx,
 			   * dreg still needs precision before this insn
 			   */
 		}
-	} else if (class == BPF_LDX || is_atomic_load_insn(insn)) {
-		if (!bt_is_reg_set(bt, dreg))
+	} else if (class == BPF_LDX ||
+		   is_atomic_load_insn(insn) ||
+		   is_atomic_fetch_insn(insn)) {
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



