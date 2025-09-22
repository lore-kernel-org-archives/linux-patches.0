Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE0C2F0C5C;
	Mon, 22 Sep 2025 19:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570282; cv=none; b=iP7S/Ou6iu/Qy7OCyMPAuIkMCu2lCrFGXIMYbZjImQ96YUKPdYSW9m4fO/E4ryjUU2up2NqCnkp2LuLmdpfVUCD8f1dL5Ft/5QhRraBJE8kz2/j5Yi0htlCGDyQfH49Rf7pCNBbtT1q3uw1DdM6T9Uq6x8ncbQhHqfTAu7ZTVNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570282; c=relaxed/simple;
	bh=lafH5kJiaqeRgxFRdUdoQ04DiPl4juTv6X+mnlBiLeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyw0cXTbmIrRsBDWov7g5dJu8JTs4UWmQAmJnPXsQVwRENjlBO6cME8qAYQcLnVV9uGEDiLQKGH3oX4Sio3p9qHpdJefHCAHn9SSjBUXxcVjf28GHLTMlI0H3W2UNb1uUFXhasxOM+ZvRW8olOLNyD/QMj4jfmHUWWPlDzdQ114=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQm9CEod; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQm9CEod"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF866C4CEF0;
	Mon, 22 Sep 2025 19:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570282;
	bh=lafH5kJiaqeRgxFRdUdoQ04DiPl4juTv6X+mnlBiLeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQm9CEodlDP8dhxcwD/heVSPMSZIOj0aWFrgi04gb9I4ddM0iY9Fg20/uwOr5eAk4
	 Owag9Mmik/Tir7y8uhGRnin5uA+b+JqRQ0uwj7Rh3ZK8iRCh/0tMMcHrJsO/vuJXhS
	 Floy8zdHLcxhMxDVWRoWhANDMGY8bEN0XU/RtFkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.16 066/149] objtool/LoongArch: Mark special atomic instruction as INSN_BUG type
Date: Mon, 22 Sep 2025 21:29:26 +0200
Message-ID: <20250922192414.546521469@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -278,6 +278,25 @@ static bool decode_insn_reg2i16_fomat(un
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
@@ -309,6 +328,8 @@ int arch_decode_instruction(struct objto
 		return 0;
 	if (decode_insn_reg2i16_fomat(inst, insn))
 		return 0;
+	if (decode_insn_reg3_fomat(inst, insn))
+		return 0;
 
 	if (inst.word == 0) {
 		/* andi $zero, $zero, 0x0 */


