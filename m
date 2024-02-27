Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA0D13EFE4;
	Tue, 27 Feb 2024 14:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042724; cv=none; b=tGKVMPjqRkSmibZNAEt3Z0KX5ja+fDtOaeb4mbF85K+FpGPY4ZsRiNfo9b14TXDM5J9J4XJEo4YgAfbu7TsIfQkJqyaDFwYkskCBW2MnmvKk8Sctq8pXrnM3H04d1rG7y5MoDiXDUfI2C3NBh9mcuSKLKJzmKTeRQHemgcVL3i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042724; c=relaxed/simple;
	bh=Jh+b6TCfAgioBFXuto7ERJtyfjVTWR85Pd/Tx9iU98o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aah1eHpNHDPCGsx98ejDwA4HhMgFDMzGk0B5FzbwWcpBK1nB6V1fcH0JeAj+GGYGVGA2BgBMqKACx0xtdGfLJSzcNLTvTAyt2vZCb/t8Cc7AffZCNeTW77IQ7aPUU7eErBOfZYAHHZQPJ/12/0VJlG5MjStwCSpS7wGRI4/bwpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ayh3GjtC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ayh3GjtC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C15C433F1;
	Tue, 27 Feb 2024 14:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042723;
	bh=Jh+b6TCfAgioBFXuto7ERJtyfjVTWR85Pd/Tx9iU98o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ayh3GjtCs27O8PhxLtPLVBMHAtalLz0b0H+td/LEEueGMhy1x/ZNLhHE8HawyyXni
	 YPMEAm7gdqcrvlfAZi3pRSwanN123FxU/uFmB0tAiXg797LQuJUud1MeS/RWWzwrfO
	 Z1PYYPksdj9DQ7tuWqxTZommslfxS8a2g5tCDJos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.15 090/245] x86/ibt,paravirt: Use text_gen_insn() for paravirt_patch()
Date: Tue, 27 Feb 2024 14:24:38 +0100
Message-ID: <20240227131618.152566601@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

Upstream commit: ba27d1a80871eb8dbeddf34ec7d396c149cbb8d7

Less duplication is more better.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20220308154317.697253958@infradead.org
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/text-patching.h |   20 ++++++++++++++------
 arch/x86/kernel/paravirt.c           |   23 +++--------------------
 2 files changed, 17 insertions(+), 26 deletions(-)

--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -96,32 +96,40 @@ union text_poke_insn {
 };
 
 static __always_inline
-void *text_gen_insn(u8 opcode, const void *addr, const void *dest)
+void __text_gen_insn(void *buf, u8 opcode, const void *addr, const void *dest, int size)
 {
-	static union text_poke_insn insn; /* per instance */
-	int size = text_opcode_size(opcode);
+	union text_poke_insn *insn = buf;
+
+	BUG_ON(size < text_opcode_size(opcode));
 
 	/*
 	 * Hide the addresses to avoid the compiler folding in constants when
 	 * referencing code, these can mess up annotations like
 	 * ANNOTATE_NOENDBR.
 	 */
+	OPTIMIZER_HIDE_VAR(insn);
 	OPTIMIZER_HIDE_VAR(addr);
 	OPTIMIZER_HIDE_VAR(dest);
 
-	insn.opcode = opcode;
+	insn->opcode = opcode;
 
 	if (size > 1) {
-		insn.disp = (long)dest - (long)(addr + size);
+		insn->disp = (long)dest - (long)(addr + size);
 		if (size == 2) {
 			/*
 			 * Ensure that for JMP8 the displacement
 			 * actually fits the signed byte.
 			 */
-			BUG_ON((insn.disp >> 31) != (insn.disp >> 7));
+			BUG_ON((insn->disp >> 31) != (insn->disp >> 7));
 		}
 	}
+}
 
+static __always_inline
+void *text_gen_insn(u8 opcode, const void *addr, const void *dest)
+{
+	static union text_poke_insn insn; /* per instance */
+	__text_gen_insn(&insn, opcode, addr, dest, text_opcode_size(opcode));
 	return &insn.text;
 }
 
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -58,29 +58,12 @@ static void paravirt_BUG(void)
 	BUG();
 }
 
-struct branch {
-	unsigned char opcode;
-	u32 delta;
-} __attribute__((packed));
-
 static unsigned paravirt_patch_call(void *insn_buff, const void *target,
 				    unsigned long addr, unsigned len)
 {
-	const int call_len = 5;
-	struct branch *b = insn_buff;
-	unsigned long delta = (unsigned long)target - (addr+call_len);
-
-	if (len < call_len) {
-		pr_warn("paravirt: Failed to patch indirect CALL at %ps\n", (void *)addr);
-		/* Kernel might not be viable if patching fails, bail out: */
-		BUG_ON(1);
-	}
-
-	b->opcode = 0xe8; /* call */
-	b->delta = delta;
-	BUILD_BUG_ON(sizeof(*b) != call_len);
-
-	return call_len;
+	__text_gen_insn(insn_buff, CALL_INSN_OPCODE,
+			(void *)addr, target, CALL_INSN_SIZE);
+	return CALL_INSN_SIZE;
 }
 
 #ifdef CONFIG_PARAVIRT_XXL


