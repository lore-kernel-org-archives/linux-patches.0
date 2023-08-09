Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6AB17AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FE6C433C8;
	Wed,  9 Aug 2023 11:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581235;
	bh=obbQYPzl5RKehFgQKAAaBEe6W/plO8aI0m/DKyOEJss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y4p5gMxO2o4c7rqKQadLvSca0WT8HxoacCi79zl3DLGaaeNnvfnhHJZFN00wJ2+wX
	 EpLJNqed33gXTHZuy0N8hlHiEaqCGMnap3yGBYmeLcZa+goqjskyCGaL+8WwtR7IvP
	 PZvNbZ6GGVOZ2BYOu/ywmB704HTd86epIV6ADGCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Borislav Petkov <bp@suse.de>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Li Huafei <lihuafei1@huawei.com>
Subject: [PATCH 5.10 114/201] x86/kprobes: Do not decode opcode in resume_execution()
Date: Wed,  9 Aug 2023 12:41:56 +0200
Message-ID: <20230809103647.596340693@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit abd82e533d88df1521e3da6799b83ce88852ab88 ]

Currently, kprobes decodes the opcode right after single-stepping in
resume_execution(). But the opcode was already decoded while preparing
arch_specific_insn in arch_copy_kprobe().

Decode the opcode in arch_copy_kprobe() instead of in resume_execution()
and set some flags which classify the opcode for the resuming process.

 [ bp: Massage commit message. ]

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Link: https://lkml.kernel.org/r/160830072561.349576.3014979564448023213.stgit@devnote2
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kprobes.h |   11 +-
 arch/x86/kernel/kprobes/core.c |  168 ++++++++++++++++++-----------------------
 2 files changed, 81 insertions(+), 98 deletions(-)

--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -58,14 +58,17 @@ struct arch_specific_insn {
 	/* copy of the original instruction */
 	kprobe_opcode_t *insn;
 	/*
-	 * boostable = false: This instruction type is not boostable.
-	 * boostable = true: This instruction has been boosted: we have
+	 * boostable = 0: This instruction type is not boostable.
+	 * boostable = 1: This instruction has been boosted: we have
 	 * added a relative jump after the instruction copy in insn,
 	 * so no single-step and fixup are needed (unless there's
 	 * a post_handler).
 	 */
-	bool boostable;
-	bool if_modifier;
+	unsigned boostable:1;
+	unsigned if_modifier:1;
+	unsigned is_call:1;
+	unsigned is_pushf:1;
+	unsigned is_abs_ip:1;
 	/* Number of bytes of text poked */
 	int tp_len;
 };
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -134,26 +134,6 @@ void synthesize_relcall(void *dest, void
 NOKPROBE_SYMBOL(synthesize_relcall);
 
 /*
- * Skip the prefixes of the instruction.
- */
-static kprobe_opcode_t *skip_prefixes(kprobe_opcode_t *insn)
-{
-	insn_attr_t attr;
-
-	attr = inat_get_opcode_attribute((insn_byte_t)*insn);
-	while (inat_is_legacy_prefix(attr)) {
-		insn++;
-		attr = inat_get_opcode_attribute((insn_byte_t)*insn);
-	}
-#ifdef CONFIG_X86_64
-	if (inat_is_rex_prefix(attr))
-		insn++;
-#endif
-	return insn;
-}
-NOKPROBE_SYMBOL(skip_prefixes);
-
-/*
  * Returns non-zero if INSN is boostable.
  * RIP relative instructions are adjusted at copying time in 64 bits mode
  */
@@ -327,25 +307,6 @@ static int can_probe(unsigned long paddr
 }
 
 /*
- * Returns non-zero if opcode modifies the interrupt flag.
- */
-static int is_IF_modifier(kprobe_opcode_t *insn)
-{
-	/* Skip prefixes */
-	insn = skip_prefixes(insn);
-
-	switch (*insn) {
-	case 0xfa:		/* cli */
-	case 0xfb:		/* sti */
-	case 0xcf:		/* iret/iretd */
-	case 0x9d:		/* popf/popfd */
-		return 1;
-	}
-
-	return 0;
-}
-
-/*
  * Copy an instruction with recovering modified instruction by kprobes
  * and adjust the displacement if the instruction uses the %rip-relative
  * addressing mode. Note that since @real will be the final place of copied
@@ -427,9 +388,9 @@ static int prepare_boost(kprobe_opcode_t
 		synthesize_reljump(buf + len, p->ainsn.insn + len,
 				   p->addr + insn->length);
 		len += JMP32_INSN_SIZE;
-		p->ainsn.boostable = true;
+		p->ainsn.boostable = 1;
 	} else {
-		p->ainsn.boostable = false;
+		p->ainsn.boostable = 0;
 	}
 
 	return len;
@@ -466,6 +427,67 @@ void free_insn_page(void *page)
 	module_memfree(page);
 }
 
+static void set_resume_flags(struct kprobe *p, struct insn *insn)
+{
+	insn_byte_t opcode = insn->opcode.bytes[0];
+
+	switch (opcode) {
+	case 0xfa:		/* cli */
+	case 0xfb:		/* sti */
+	case 0x9d:		/* popf/popfd */
+		/* Check whether the instruction modifies Interrupt Flag or not */
+		p->ainsn.if_modifier = 1;
+		break;
+	case 0x9c:	/* pushfl */
+		p->ainsn.is_pushf = 1;
+		break;
+	case 0xcf:	/* iret */
+		p->ainsn.if_modifier = 1;
+		fallthrough;
+	case 0xc2:	/* ret/lret */
+	case 0xc3:
+	case 0xca:
+	case 0xcb:
+	case 0xea:	/* jmp absolute -- ip is correct */
+		/* ip is already adjusted, no more changes required */
+		p->ainsn.is_abs_ip = 1;
+		/* Without resume jump, this is boostable */
+		p->ainsn.boostable = 1;
+		break;
+	case 0xe8:	/* call relative - Fix return addr */
+		p->ainsn.is_call = 1;
+		break;
+#ifdef CONFIG_X86_32
+	case 0x9a:	/* call absolute -- same as call absolute, indirect */
+		p->ainsn.is_call = 1;
+		p->ainsn.is_abs_ip = 1;
+		break;
+#endif
+	case 0xff:
+		opcode = insn->opcode.bytes[1];
+		if ((opcode & 0x30) == 0x10) {
+			/*
+			 * call absolute, indirect
+			 * Fix return addr; ip is correct.
+			 * But this is not boostable
+			 */
+			p->ainsn.is_call = 1;
+			p->ainsn.is_abs_ip = 1;
+			break;
+		} else if (((opcode & 0x31) == 0x20) ||
+			   ((opcode & 0x31) == 0x21)) {
+			/*
+			 * jmp near and far, absolute indirect
+			 * ip is correct.
+			 */
+			p->ainsn.is_abs_ip = 1;
+			/* Without resume jump, this is boostable */
+			p->ainsn.boostable = 1;
+		}
+		break;
+	}
+}
+
 static int arch_copy_kprobe(struct kprobe *p)
 {
 	struct insn insn;
@@ -483,8 +505,8 @@ static int arch_copy_kprobe(struct kprob
 	 */
 	len = prepare_boost(buf, p, &insn);
 
-	/* Check whether the instruction modifies Interrupt Flag or not */
-	p->ainsn.if_modifier = is_IF_modifier(buf);
+	/* Analyze the opcode and set resume flags */
+	set_resume_flags(p, &insn);
 
 	/* Also, displacement change doesn't affect the first byte */
 	p->opcode = buf[0];
@@ -507,6 +529,9 @@ int arch_prepare_kprobe(struct kprobe *p
 
 	if (!can_probe((unsigned long)p->addr))
 		return -EILSEQ;
+
+	memset(&p->ainsn, 0, sizeof(p->ainsn));
+
 	/* insn: must be on special executable page on x86. */
 	p->ainsn.insn = get_insn_slot();
 	if (!p->ainsn.insn)
@@ -822,11 +847,6 @@ NOKPROBE_SYMBOL(trampoline_handler);
  * 2) If the single-stepped instruction was a call, the return address
  * that is atop the stack is the address following the copied instruction.
  * We need to make it the address following the original instruction.
- *
- * If this is the first time we've single-stepped the instruction at
- * this probepoint, and the instruction is boostable, boost it: add a
- * jump instruction after the copied instruction, that jumps to the next
- * instruction after the probepoint.
  */
 static void resume_execution(struct kprobe *p, struct pt_regs *regs,
 			     struct kprobe_ctlblk *kcb)
@@ -834,60 +854,20 @@ static void resume_execution(struct kpro
 	unsigned long *tos = stack_addr(regs);
 	unsigned long copy_ip = (unsigned long)p->ainsn.insn;
 	unsigned long orig_ip = (unsigned long)p->addr;
-	kprobe_opcode_t *insn = p->ainsn.insn;
-
-	/* Skip prefixes */
-	insn = skip_prefixes(insn);
 
 	regs->flags &= ~X86_EFLAGS_TF;
-	switch (*insn) {
-	case 0x9c:	/* pushfl */
+
+	/* Fixup the contents of top of stack */
+	if (p->ainsn.is_pushf) {
 		*tos &= ~(X86_EFLAGS_TF | X86_EFLAGS_IF);
 		*tos |= kcb->kprobe_old_flags;
-		break;
-	case 0xc2:	/* iret/ret/lret */
-	case 0xc3:
-	case 0xca:
-	case 0xcb:
-	case 0xcf:
-	case 0xea:	/* jmp absolute -- ip is correct */
-		/* ip is already adjusted, no more changes required */
-		p->ainsn.boostable = true;
-		goto no_change;
-	case 0xe8:	/* call relative - Fix return addr */
+	} else if (p->ainsn.is_call) {
 		*tos = orig_ip + (*tos - copy_ip);
-		break;
-#ifdef CONFIG_X86_32
-	case 0x9a:	/* call absolute -- same as call absolute, indirect */
-		*tos = orig_ip + (*tos - copy_ip);
-		goto no_change;
-#endif
-	case 0xff:
-		if ((insn[1] & 0x30) == 0x10) {
-			/*
-			 * call absolute, indirect
-			 * Fix return addr; ip is correct.
-			 * But this is not boostable
-			 */
-			*tos = orig_ip + (*tos - copy_ip);
-			goto no_change;
-		} else if (((insn[1] & 0x31) == 0x20) ||
-			   ((insn[1] & 0x31) == 0x21)) {
-			/*
-			 * jmp near and far, absolute indirect
-			 * ip is correct. And this is boostable
-			 */
-			p->ainsn.boostable = true;
-			goto no_change;
-		}
-		break;
-	default:
-		break;
 	}
 
-	regs->ip += orig_ip - copy_ip;
+	if (!p->ainsn.is_abs_ip)
+		regs->ip += orig_ip - copy_ip;
 
-no_change:
 	restore_btf();
 }
 NOKPROBE_SYMBOL(resume_execution);


