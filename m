Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8012614690D;
	Tue, 27 Feb 2024 14:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044161; cv=none; b=ZYprZC/pC4yKbANIwxnh+8xHWhDQu0QqQO6zkS9Grg3TmLPso4yOY6UtXz7XO8Xt1bCq5MkGHmHQzuQmklMyZr3Y8Poh5tP50hG8gilnwZ9+HkdNWYE6HCVK6m1lt17Jrwp67KbU2aLKAzF4Y/sogTaDZOrBKgj2lQZqeTT5Zio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044161; c=relaxed/simple;
	bh=4+pXp4CiPJYigGy+6tVdOAGsQX6Zpx5Mq4zsyhqo0S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVMzUmJGT/5jzfs4XmWrmUtKY6JSsf+6fB8W5RRQ9k3hHEIqxFBzsiU4ohwTdKTxA+p3c0KV7h1GVQ9xLlmBSqtVo8IZvoLbn0tLrOEMQ/qRqBcrd7znNQa49FsFqE6szsvGQw9G574MQ+f4jmgCk6IZ7TRQMDPLDwotI09/Hsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGRBKTmM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGRBKTmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C84BC433F1;
	Tue, 27 Feb 2024 14:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044161;
	bh=4+pXp4CiPJYigGy+6tVdOAGsQX6Zpx5Mq4zsyhqo0S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DGRBKTmM32Wr9/mhqIUusvE2NZBdz9VnNQW6niDcwslTFl7Nxnq94WdEZpdelODFu
	 ZQOL7g77oGhfI1I6/YfV7Y1rCyJwjGaMjTf39BN9dkf1iAH35/q2SN7gSHYd2R3Pd7
	 uhwPNVoq+WdEBp9rnhZuDbbEj4/8sC2cSduNPrgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.10 085/122] x86/ibt,paravirt: Use text_gen_insn() for paravirt_patch()
Date: Tue, 27 Feb 2024 14:27:26 +0100
Message-ID: <20240227131601.488092151@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

Upstream commit: ba27d1a80871eb8dbeddf34ec7d396c149cbb8d7

Less duplication is more better.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20220308154317.697253958@infradead.org
 [ Keep struct branch. ]
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/text-patching.h |   20 ++++++++++++++------
 arch/x86/kernel/paravirt.c           |   22 +++++-----------------
 2 files changed, 19 insertions(+), 23 deletions(-)

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
@@ -55,28 +55,16 @@ void __init default_banner(void)
 static const unsigned char ud2a[] = { 0x0f, 0x0b };
 
 struct branch {
-	unsigned char opcode;
-	u32 delta;
+       unsigned char opcode;
+       u32 delta;
 } __attribute__((packed));
 
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


