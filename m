Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E765383F5;
	Wed, 23 Sep 2026 14:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174644; cv=none; b=qvuvWQzP8OOP2S+Ibbx0nWsdbP3XKAr73arPmQyqgQg62nQ41BbmHdTA1tj6v7EvfebT4g+qYzFVwmEFbva68YqrPhsynHSBTxglvu+Bzl957iB/Kfoa9Lw5GBHlWcsQSvmyNQ+JmiqtPiPQP9nlsvHJ9qh0AEg4aCmQPG5hyOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174644; c=relaxed/simple;
	bh=yqFlr3emXXirsCPRZynxIBoo3dIQDZN7DhSPWKozIHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atSMgVc4uu6VwXLMMS+sKtz9NdZsKOGzFq1heNzn3ScSw+iqH5SxuFrFMiZXZi2mdA7aNBASbBYD7Yce7uaPnX2qjQYOwLYd7/nZqbT4s5CZOQJhhw2oQbxoPfyhkwK8/JHd1eqEzBTVi3S6RzXH+/aSpNagm3vKVZdSFJF+cgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bG7pKaLn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bG7pKaLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51371F000FF;
	Wed, 23 Sep 2026 14:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174643;
	bh=xQnIMBmeAOsWPKtFNmH8ahgAo3s4Jdyv8oE+2WmSvsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bG7pKaLnCujxVaS9tEgA4tNIgEg8U2TRxToaazr/L+W5Cf9hka4t69/6jZkqhrkNA
	 oPKTi//Et1ux1QwK4HieUr3vA1Ix7ora+r/W3lar/pOV34gB2RaK5jpJEC2BEYP6FU
	 5bob1P2lU9iEez2QEcadQo4L3YYkbb34C5LZkyPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 181/398] x86/alternative: Refactor INT3 call emulation selftest
Date: Wed, 23 Sep 2026 16:04:15 +0200
Message-ID: <20260923140648.124822384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 3049fc4b5f1d2320a84e2902b3ac5a735f60ca04 ]

The INT3 call emulation selftest is a bit fragile as it relies on the
compiler not inserting any extra instructions before the
int3_selftest_ip() definition.

Also, the int3_selftest_ip() symbol overlaps with the int3_selftest
symbol(), which can confuse objtool.

Fix those issues by slightly reworking the functionality and moving
int3_selftest_ip() to a separate asm function.  While at it, improve the
naming.

Acked-by: Petr Mladek <pmladek@suse.com>
Tested-by: Joe Lawrence <joe.lawrence@redhat.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Stable-dep-of: a5f7a5bb3b7f ("x86/kprobes: Fix crash when probing CS CALL instructions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/alternative.c | 51 +++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 109a285cca514..4917d2843feb4 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -2266,21 +2266,34 @@ int alternatives_text_reserved(void *start, void *end)
  * See entry_{32,64}.S for more details.
  */
 
-/*
- * We define the int3_magic() function in assembly to control the calling
- * convention such that we can 'call' it from assembly.
- */
+extern void int3_selftest_asm(unsigned int *ptr);
 
-extern void int3_magic(unsigned int *ptr); /* defined in asm */
+asm (
+"	.pushsection	.init.text, \"ax\", @progbits\n"
+"	.type		int3_selftest_asm, @function\n"
+"int3_selftest_asm:\n"
+	ANNOTATE_NOENDBR
+	/*
+	 * INT3 padded with NOP to CALL_INSN_SIZE. The INT3 triggers an
+	 * exception, then the int3_exception_nb notifier emulates a call to
+	 * int3_selftest_callee().
+	 */
+"	int3; nop; nop; nop; nop\n"
+	ASM_RET
+"	.size		int3_selftest_asm, . - int3_selftest_asm\n"
+"	.popsection\n"
+);
+
+extern void int3_selftest_callee(unsigned int *ptr);
 
 asm (
 "	.pushsection	.init.text, \"ax\", @progbits\n"
-"	.type		int3_magic, @function\n"
-"int3_magic:\n"
+"	.type		int3_selftest_callee, @function\n"
+"int3_selftest_callee:\n"
 	ANNOTATE_NOENDBR
-"	movl	$1, (%" _ASM_ARG1 ")\n"
+"	movl	$0x1234, (%" _ASM_ARG1 ")\n"
 	ASM_RET
-"	.size		int3_magic, .-int3_magic\n"
+"	.size		int3_selftest_callee, . - int3_selftest_callee\n"
 "	.popsection\n"
 );
 
@@ -2289,7 +2302,7 @@ extern void int3_selftest_ip(void); /* defined in asm below */
 static int __init
 int3_exception_notify(struct notifier_block *self, unsigned long val, void *data)
 {
-	unsigned long selftest = (unsigned long)&int3_selftest_ip;
+	unsigned long selftest = (unsigned long)&int3_selftest_asm;
 	struct die_args *args = data;
 	struct pt_regs *regs = args->regs;
 
@@ -2304,7 +2317,7 @@ int3_exception_notify(struct notifier_block *self, unsigned long val, void *data
 	if (regs->ip - INT3_INSN_SIZE != selftest)
 		return NOTIFY_DONE;
 
-	int3_emulate_call(regs, (unsigned long)&int3_magic);
+	int3_emulate_call(regs, (unsigned long)&int3_selftest_callee);
 	return NOTIFY_STOP;
 }
 
@@ -2320,19 +2333,11 @@ static noinline void __init int3_selftest(void)
 	BUG_ON(register_die_notifier(&int3_exception_nb));
 
 	/*
-	 * Basically: int3_magic(&val); but really complicated :-)
-	 *
-	 * INT3 padded with NOP to CALL_INSN_SIZE. The int3_exception_nb
-	 * notifier above will emulate CALL for us.
+	 * Basically: int3_selftest_callee(&val); but really complicated :-)
 	 */
-	asm volatile ("int3_selftest_ip:\n\t"
-		      ANNOTATE_NOENDBR
-		      "    int3; nop; nop; nop; nop\n\t"
-		      : ASM_CALL_CONSTRAINT
-		      : __ASM_SEL_RAW(a, D) (&val)
-		      : "memory");
-
-	BUG_ON(val != 1);
+	int3_selftest_asm(&val);
+
+	BUG_ON(val != 0x1234);
 
 	unregister_die_notifier(&int3_exception_nb);
 }
-- 
2.53.0



