Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD1D15E8B;
	Mon, 30 Dec 2024 15:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574185; cv=none; b=lwKWpyAJJOmSRrzY1fUU7RnuUxHFi4H+Yelp/om1zfhih2NaNY475mneyLEfrC/BWSxXEKf2JBSkH39s+2kJ32d6IQ8lxEG+2h2mB9ExQboRp58o7eVZVWcp65kJ0hv1iUUgtcEG6NdYiETJRpQGbmHTIT4nhzeOJwKw2uP0Wkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574185; c=relaxed/simple;
	bh=u27GJ90hHhZI3F8FdziX1ojJlWTcaem+k3q79+D9LQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbwnUv1mfWV3axXK1juy1uaUqY30MidM3+vljizK+dFl+Ltn883eJNz+cXbME3jKd+ETpdYYfnuBaog9GZugXG3Sqj8cJq0Wf4k0WnvGK2DDyvelOkWKyXl4hB1ixmkbzh8GUKcNkexWZ3USF4Y/2DrOiVoDGw6vXXW+hmKgoW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbwUBZbi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbwUBZbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911E9C4CED0;
	Mon, 30 Dec 2024 15:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574185;
	bh=u27GJ90hHhZI3F8FdziX1ojJlWTcaem+k3q79+D9LQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbwUBZbiMRK5R1rCVKrKzjcFqsa3Kc8m5vuUwueVpYMknsnOWX+17uDeyoWDNLpts
	 iMR6kHvyR2KgGWxW3mKHD6FOEFhrR7GN79kfWl1pikdcI6mqBvOfG/p4T780SyDKio
	 TzyTfWtCGeUAiqtR21tAREsjgqCaSLUSEepjCbv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/114] LoongArch: BPF: Adjust the parameter of emit_jirl()
Date: Mon, 30 Dec 2024 16:42:59 +0100
Message-ID: <20241230154220.483718536@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit c1474bb0b7cff4e8481095bd0618b8f6c2f0aeb4 ]

The branch instructions beq, bne, blt, bge, bltu, bgeu and jirl belong
to the format reg2i16, but the sequence of oprand is different for the
instruction jirl. So adjust the parameter order of emit_jirl() to make
it more readable correspond with the Instruction Set Architecture manual.

Here are the instruction formats:

  beq     rj, rd, offs16
  bne     rj, rd, offs16
  blt     rj, rd, offs16
  bge     rj, rd, offs16
  bltu    rj, rd, offs16
  bgeu    rj, rd, offs16
  jirl    rd, rj, offs16

Link: https://loongson.github.io/LoongArch-Documentation/LoongArch-Vol1-EN.html#branch-instructions
Suggested-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/inst.h | 12 +++++++++++-
 arch/loongarch/kernel/inst.c      |  2 +-
 arch/loongarch/net/bpf_jit.c      |  6 +++---
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/loongarch/include/asm/inst.h b/arch/loongarch/include/asm/inst.h
index 944482063f14..3089785ca97e 100644
--- a/arch/loongarch/include/asm/inst.h
+++ b/arch/loongarch/include/asm/inst.h
@@ -683,7 +683,17 @@ DEF_EMIT_REG2I16_FORMAT(blt, blt_op)
 DEF_EMIT_REG2I16_FORMAT(bge, bge_op)
 DEF_EMIT_REG2I16_FORMAT(bltu, bltu_op)
 DEF_EMIT_REG2I16_FORMAT(bgeu, bgeu_op)
-DEF_EMIT_REG2I16_FORMAT(jirl, jirl_op)
+
+static inline void emit_jirl(union loongarch_instruction *insn,
+			     enum loongarch_gpr rd,
+			     enum loongarch_gpr rj,
+			     int offset)
+{
+	insn->reg2i16_format.opcode = jirl_op;
+	insn->reg2i16_format.immediate = offset;
+	insn->reg2i16_format.rd = rd;
+	insn->reg2i16_format.rj = rj;
+}
 
 #define DEF_EMIT_REG2BSTRD_FORMAT(NAME, OP)				\
 static inline void emit_##NAME(union loongarch_instruction *insn,	\
diff --git a/arch/loongarch/kernel/inst.c b/arch/loongarch/kernel/inst.c
index 3050329556d1..14d7d700bcb9 100644
--- a/arch/loongarch/kernel/inst.c
+++ b/arch/loongarch/kernel/inst.c
@@ -332,7 +332,7 @@ u32 larch_insn_gen_jirl(enum loongarch_gpr rd, enum loongarch_gpr rj, int imm)
 		return INSN_BREAK;
 	}
 
-	emit_jirl(&insn, rj, rd, imm >> 2);
+	emit_jirl(&insn, rd, rj, imm >> 2);
 
 	return insn.word;
 }
diff --git a/arch/loongarch/net/bpf_jit.c b/arch/loongarch/net/bpf_jit.c
index dd350cba1252..ea357a3edc09 100644
--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -181,13 +181,13 @@ static void __build_epilogue(struct jit_ctx *ctx, bool is_tail_call)
 		/* Set return value */
 		emit_insn(ctx, addiw, LOONGARCH_GPR_A0, regmap[BPF_REG_0], 0);
 		/* Return to the caller */
-		emit_insn(ctx, jirl, LOONGARCH_GPR_RA, LOONGARCH_GPR_ZERO, 0);
+		emit_insn(ctx, jirl, LOONGARCH_GPR_ZERO, LOONGARCH_GPR_RA, 0);
 	} else {
 		/*
 		 * Call the next bpf prog and skip the first instruction
 		 * of TCC initialization.
 		 */
-		emit_insn(ctx, jirl, LOONGARCH_GPR_T3, LOONGARCH_GPR_ZERO, 1);
+		emit_insn(ctx, jirl, LOONGARCH_GPR_ZERO, LOONGARCH_GPR_T3, 1);
 	}
 }
 
@@ -904,7 +904,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx, bool ext
 			return ret;
 
 		move_addr(ctx, t1, func_addr);
-		emit_insn(ctx, jirl, t1, LOONGARCH_GPR_RA, 0);
+		emit_insn(ctx, jirl, LOONGARCH_GPR_RA, t1, 0);
 		move_reg(ctx, regmap[BPF_REG_0], LOONGARCH_GPR_A0);
 		break;
 
-- 
2.39.5



