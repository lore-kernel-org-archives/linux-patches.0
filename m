Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE453D9048;
	Wed,  8 Apr 2026 18:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674513; cv=none; b=G6NBy/9cHX2h82qYkktAAUfN7dUbZP89njZMhqFYtRS9esHJkTKmw24Ma5RQDQndhZzrU7E/LGYuP+unG6xdPe1gDe/FsWsXcn3UWw28kLB8ILwTYRLUWmUywCFbA5eNR/76uBg0dB4PB+hZ8hZKyxpiLMJZegzh8RRUFQd7rg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674513; c=relaxed/simple;
	bh=uwWea+/Ve7+Jowm5eI4IKfUr0AXioNP2pROrDhBwibQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzkmpIuphTGm/3UHS+du//z/BM9kclYG42ILAiQ5FAKARUmqXk/jE/2PKyjlPiKpyva+Fq7/8vGysitgCUW1nucPZ6h9nJPzZLjKsO707u0H3JNdOFXIIVaJ8dw/SxvpsDSSoKSI4wuzoZxOLiVqbFoF4aMYKWHKbkRJSy+wOfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pwVuYK0m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pwVuYK0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64789C19425;
	Wed,  8 Apr 2026 18:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674512;
	bh=uwWea+/Ve7+Jowm5eI4IKfUr0AXioNP2pROrDhBwibQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwVuYK0mjnUHS9snVXI4uNz3pbxULQQ/RzV/JMP2y63zJBp5M575Vfaq7V95ecC1E
	 +QRBBcoxBDvT3UxV7CIfsZN0yZS3mVoJ4reZ0wuQsGnjBi7BWmWai94NlTrj1lbL7+
	 Xf7riAa2UMgNzZWGh/GutpxzBC5Zwny7Wvj92Rkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 126/311] bpf: Fix incorrect pruning due to atomic fetch precision tracking
Date: Wed,  8 Apr 2026 20:02:06 +0200
Message-ID: <20260408175944.121274031@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 0aea870b87a6c..d1394e16d108c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -608,6 +608,13 @@ static bool is_atomic_load_insn(const struct bpf_insn *insn)
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
@@ -4356,10 +4363,24 @@ static int backtrack_insn(struct bpf_verifier_env *env, int idx, int subseq_idx,
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



