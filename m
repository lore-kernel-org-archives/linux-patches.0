Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD5C81AC1;
	Mon,  8 Apr 2024 13:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582661; cv=none; b=MUQcU3ZYEv9eAY5jjT3di/n2PdU61yIcJPErXVyDwff1FpYcBLZNJ5C8dDwfGvQYzbjA1Xuv5l8ouCcCT/uJ+VV2VYLxfKIIWd7Nm0KyKXssv67JZPCKhF243e3rS+7XvBP7QlshYx3FSCelNNxuRGxb9AOtTojyhFulCEiM/RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582661; c=relaxed/simple;
	bh=Z/fKzRHHkGx+DsHKaN6qwIPn3cGSoje1sB3HvNT8/GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAAdy+1mPgxT0WWpQzp2CP0b8/QaSXM+JX9wuWtLc1dOqETWg3HJPZMdKfBaepyIxXGK4YUg8Ubri8uCJWLEamlZiCdvHGsyy2oDfAIuRNpsg3E0/5K6FFTCUOXJI8mppsn+ihDQA3uo/R1tKuL1mnGiYYzc5zZiBPHQgwXysPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbFXQOY6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbFXQOY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC12DC433F1;
	Mon,  8 Apr 2024 13:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582661;
	bh=Z/fKzRHHkGx+DsHKaN6qwIPn3cGSoje1sB3HvNT8/GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbFXQOY6IauAnoVlMW3iwEP1zKeIYl4x30x1CJMEMAv5LGydzLIfEIle8AF7tADd8
	 Jn9FcpERO9yV38HoflXPam1acRMR7YMgtDQ4D2XnKKUP0IUcW7H5qZZZTlSJ7ZP/uY
	 75cJr2JmmJMUXdXC+/+FMk0wM7kDA6YfhpjNRdlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 163/690] x86/alternatives: Introduce int3_emulate_jcc()
Date: Mon,  8 Apr 2024 14:50:29 +0200
Message-ID: <20240408125405.465779771@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

commit db7adcfd1cec4e95155e37bc066fddab302c6340 upstream.

Move the kprobe Jcc emulation into int3_emulate_jcc() so it can be
used by more code -- specifically static_call() will need this.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20230123210607.057678245@infradead.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/text-patching.h |   31 ++++++++++++++++++++++++++++
 arch/x86/kernel/kprobes/core.c       |   38 +++++++----------------------------
 2 files changed, 39 insertions(+), 30 deletions(-)

--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -181,6 +181,37 @@ void int3_emulate_ret(struct pt_regs *re
 	unsigned long ip = int3_emulate_pop(regs);
 	int3_emulate_jmp(regs, ip);
 }
+
+static __always_inline
+void int3_emulate_jcc(struct pt_regs *regs, u8 cc, unsigned long ip, unsigned long disp)
+{
+	static const unsigned long jcc_mask[6] = {
+		[0] = X86_EFLAGS_OF,
+		[1] = X86_EFLAGS_CF,
+		[2] = X86_EFLAGS_ZF,
+		[3] = X86_EFLAGS_CF | X86_EFLAGS_ZF,
+		[4] = X86_EFLAGS_SF,
+		[5] = X86_EFLAGS_PF,
+	};
+
+	bool invert = cc & 1;
+	bool match;
+
+	if (cc < 0xc) {
+		match = regs->flags & jcc_mask[cc >> 1];
+	} else {
+		match = ((regs->flags & X86_EFLAGS_SF) >> X86_EFLAGS_SF_BIT) ^
+			((regs->flags & X86_EFLAGS_OF) >> X86_EFLAGS_OF_BIT);
+		if (cc >= 0xe)
+			match = match || (regs->flags & X86_EFLAGS_ZF);
+	}
+
+	if ((match && !invert) || (!match && invert))
+		ip += disp;
+
+	int3_emulate_jmp(regs, ip);
+}
+
 #endif /* !CONFIG_UML_X86 */
 
 #endif /* _ASM_X86_TEXT_PATCHING_H */
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -463,50 +463,26 @@ static void kprobe_emulate_call(struct k
 }
 NOKPROBE_SYMBOL(kprobe_emulate_call);
 
-static nokprobe_inline
-void __kprobe_emulate_jmp(struct kprobe *p, struct pt_regs *regs, bool cond)
+static void kprobe_emulate_jmp(struct kprobe *p, struct pt_regs *regs)
 {
 	unsigned long ip = regs->ip - INT3_INSN_SIZE + p->ainsn.size;
 
-	if (cond)
-		ip += p->ainsn.rel32;
+	ip += p->ainsn.rel32;
 	int3_emulate_jmp(regs, ip);
 }
-
-static void kprobe_emulate_jmp(struct kprobe *p, struct pt_regs *regs)
-{
-	__kprobe_emulate_jmp(p, regs, true);
-}
 NOKPROBE_SYMBOL(kprobe_emulate_jmp);
 
-static const unsigned long jcc_mask[6] = {
-	[0] = X86_EFLAGS_OF,
-	[1] = X86_EFLAGS_CF,
-	[2] = X86_EFLAGS_ZF,
-	[3] = X86_EFLAGS_CF | X86_EFLAGS_ZF,
-	[4] = X86_EFLAGS_SF,
-	[5] = X86_EFLAGS_PF,
-};
-
 static void kprobe_emulate_jcc(struct kprobe *p, struct pt_regs *regs)
 {
-	bool invert = p->ainsn.jcc.type & 1;
-	bool match;
+	unsigned long ip = regs->ip - INT3_INSN_SIZE + p->ainsn.size;
 
-	if (p->ainsn.jcc.type < 0xc) {
-		match = regs->flags & jcc_mask[p->ainsn.jcc.type >> 1];
-	} else {
-		match = ((regs->flags & X86_EFLAGS_SF) >> X86_EFLAGS_SF_BIT) ^
-			((regs->flags & X86_EFLAGS_OF) >> X86_EFLAGS_OF_BIT);
-		if (p->ainsn.jcc.type >= 0xe)
-			match = match || (regs->flags & X86_EFLAGS_ZF);
-	}
-	__kprobe_emulate_jmp(p, regs, (match && !invert) || (!match && invert));
+	int3_emulate_jcc(regs, p->ainsn.jcc.type, ip, p->ainsn.rel32);
 }
 NOKPROBE_SYMBOL(kprobe_emulate_jcc);
 
 static void kprobe_emulate_loop(struct kprobe *p, struct pt_regs *regs)
 {
+	unsigned long ip = regs->ip - INT3_INSN_SIZE + p->ainsn.size;
 	bool match;
 
 	if (p->ainsn.loop.type != 3) {	/* LOOP* */
@@ -534,7 +510,9 @@ static void kprobe_emulate_loop(struct k
 	else if (p->ainsn.loop.type == 1)	/* LOOPE */
 		match = match && (regs->flags & X86_EFLAGS_ZF);
 
-	__kprobe_emulate_jmp(p, regs, match);
+	if (match)
+		ip += p->ainsn.rel32;
+	int3_emulate_jmp(regs, ip);
 }
 NOKPROBE_SYMBOL(kprobe_emulate_loop);
 


