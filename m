Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CD227B320;
	Mon, 22 Sep 2025 19:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569907; cv=none; b=og0cGu0SHB+Vjm+gDXEEnmBtz0gQoO70ViPwMgR/8vrH4idwgVOKKY8PdzRAAK0cxSO/yYl1Zgbd6E8rhB2/PrQmpLuiEKt5xEeNnm3zz6R8Un4SpVKg8XZdb5oAa+QT9bLDM6j9CK5G2UX/P0V1jZB5bv1D8k55gKatlpBwIMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569907; c=relaxed/simple;
	bh=EbdCp+c6bcHdO1CEczbuBdv+/Qb2Jfr0KZRxESeocR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ss9tdaOfSLkARTwIWhCdfH71bzQyPhmFPfA6NhcGiRBqyyuwcumUe/q47iGtbh/tKdQmYXvZzZzSBiyfw+Nz5EaNUkWAjOFY4gyIM+t8tu9ouyLyN065LcV2GEhdtXXiKqy+nUPz/EWnztemQ+RdL6Nf5B20MPWdJq1MC4k0oSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LTH/EnM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LTH/EnM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77ED9C4CEF0;
	Mon, 22 Sep 2025 19:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569906;
	bh=EbdCp+c6bcHdO1CEczbuBdv+/Qb2Jfr0KZRxESeocR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LTH/EnM8GTYPrIw/G2je5yGbqGhCE1FSRZZCCAh6rPG0WZ/KoYPRYh+dSWB6Ap27M
	 +DTkYm2sbZQT2gef4yLUC/SVyKkDci5TYSo8IDk42Nh4jRwfsh5gLm5eKHsxiEiNFp
	 PfHzYsrilmMV0u1Ydq5kYnjUWB7A9dlO16xk7J+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 046/105] objtool/LoongArch: Mark special atomic instruction as INSN_BUG type
Date: Mon, 22 Sep 2025 21:29:29 +0200
Message-ID: <20250922192410.123330497@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

commit 539d7344d4feaea37e05863e9aa86bd31f28e46f upstream.

When compiling with LLVM and CONFIG_RUST is set, there exists the
following objtool warning:

  rust/compiler_builtins.o: warning: objtool: __rust__unordsf2(): unexpected end of section .text.unlikely.

objdump shows that the end of section .text.unlikely is an atomic
instruction:

  amswap.w        $zero, $ra, $zero

According to the LoongArch Reference Manual, if the amswap.w atomic
memory access instruction has the same register number as rd and rj,
the execution will trigger an Instruction Non-defined Exception, so
mark the above instruction as INSN_BUG type to fix the warning.

Cc: stable@vger.kernel.org
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/arch/loongarch/include/asm/inst.h |   12 ++++++++++++
 tools/objtool/arch/loongarch/decode.c   |   21 +++++++++++++++++++++
 2 files changed, 33 insertions(+)

--- a/tools/arch/loongarch/include/asm/inst.h
+++ b/tools/arch/loongarch/include/asm/inst.h
@@ -51,6 +51,10 @@ enum reg2i16_op {
 	bgeu_op		= 0x1b,
 };
 
+enum reg3_op {
+	amswapw_op	= 0x70c0,
+};
+
 struct reg0i15_format {
 	unsigned int immediate : 15;
 	unsigned int opcode : 17;
@@ -96,6 +100,13 @@ struct reg2i16_format {
 	unsigned int opcode : 6;
 };
 
+struct reg3_format {
+	unsigned int rd : 5;
+	unsigned int rj : 5;
+	unsigned int rk : 5;
+	unsigned int opcode : 17;
+};
+
 union loongarch_instruction {
 	unsigned int word;
 	struct reg0i15_format	reg0i15_format;
@@ -105,6 +116,7 @@ union loongarch_instruction {
 	struct reg2i12_format	reg2i12_format;
 	struct reg2i14_format	reg2i14_format;
 	struct reg2i16_format	reg2i16_format;
+	struct reg3_format	reg3_format;
 };
 
 #define LOONGARCH_INSN_SIZE	sizeof(union loongarch_instruction)
--- a/tools/objtool/arch/loongarch/decode.c
+++ b/tools/objtool/arch/loongarch/decode.c
@@ -281,6 +281,25 @@ static bool decode_insn_reg2i16_fomat(un
 	return true;
 }
 
+static bool decode_insn_reg3_fomat(union loongarch_instruction inst,
+				   struct instruction *insn)
+{
+	switch (inst.reg3_format.opcode) {
+	case amswapw_op:
+		if (inst.reg3_format.rd == LOONGARCH_GPR_ZERO &&
+		    inst.reg3_format.rk == LOONGARCH_GPR_RA &&
+		    inst.reg3_format.rj == LOONGARCH_GPR_ZERO) {
+			/* amswap.w $zero, $ra, $zero */
+			insn->type = INSN_BUG;
+		}
+		break;
+	default:
+		return false;
+	}
+
+	return true;
+}
+
 int arch_decode_instruction(struct objtool_file *file, const struct section *sec,
 			    unsigned long offset, unsigned int maxlen,
 			    struct instruction *insn)
@@ -312,6 +331,8 @@ int arch_decode_instruction(struct objto
 		return 0;
 	if (decode_insn_reg2i16_fomat(inst, insn))
 		return 0;
+	if (decode_insn_reg3_fomat(inst, insn))
+		return 0;
 
 	if (inst.word == 0) {
 		/* andi $zero, $zero, 0x0 */


