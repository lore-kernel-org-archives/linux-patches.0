Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE57A15E8B;
	Mon, 30 Dec 2024 15:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573815; cv=none; b=C/BROGR6BiHbGnmlKe4x9++JYarSuAyjKyct642t0nR0cqfJ6LYMGdHX2Yo6CGQ9EwW6iImV0Pd6SvEuw6v0DhQsEbYAhUJ/uoMjlU+R6j5kpegqtmQTNgamDuAvhdreyZQYNH8kTm0djiygCA7JIfHxl5qdzH25hq7IP6xw1Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573815; c=relaxed/simple;
	bh=Kx4WKBHFKBVJi5I9l9McHtBdE+rTADdd5AS9kyciJlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bve2rFtC6LMP0sCrnVAmEqYlVdEWx8VtE5VpilxnaZTnFQucHOMIAf7fj+6yRXGVrNSUvC2y8WIcZLxltN+Tpyr4qWsG/wTSENFcaLDhqVXhDmUIsdl+qR28kbEkQgA73K91pwQt5C8Bk7cjnbUSoiP5yJisww4e287JP3wPKNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3IUEpkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3IUEpkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D01C4CED0;
	Mon, 30 Dec 2024 15:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573814;
	bh=Kx4WKBHFKBVJi5I9l9McHtBdE+rTADdd5AS9kyciJlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x3IUEpkc0OiAHKeTKSgoHD8KyWjrILrX8kVVMT485WKS24eDptPXyYYaxDvdVbA+n
	 8I1YJzC9ab/AKkcv/tosNuHvY0eXs89jrsY/xH+CqLAmCDSqnKVDaiwc1Ti5hoB4SY
	 V5FGTI3k8cZ621g4kUCr1xsiGX+ZSCSHRsVYB0Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 42/86] LoongArch: BPF: Adjust the parameter of emit_jirl()
Date: Mon, 30 Dec 2024 16:42:50 +0100
Message-ID: <20241230154213.313135009@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 71e1ed4165c8..4fa53ad82efb 100644
--- a/arch/loongarch/include/asm/inst.h
+++ b/arch/loongarch/include/asm/inst.h
@@ -655,7 +655,17 @@ DEF_EMIT_REG2I16_FORMAT(blt, blt_op)
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
index 497f8b0a5f1e..6595e992fda8 100644
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
 
@@ -841,7 +841,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx, bool ext
 			return ret;
 
 		move_addr(ctx, t1, func_addr);
-		emit_insn(ctx, jirl, t1, LOONGARCH_GPR_RA, 0);
+		emit_insn(ctx, jirl, LOONGARCH_GPR_RA, t1, 0);
 		move_reg(ctx, regmap[BPF_REG_0], LOONGARCH_GPR_A0);
 		break;
 
-- 
2.39.5



