Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40ECA271476;
	Tue, 27 May 2025 17:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365465; cv=none; b=EVWN5bg4acGVeHVH9JawIOYPepa8IFZpwM1qMagzs//OsP8qXlHmvqbyG/JCNC6h1+Zz8GOcxqiv8w8M1XziwvAhL4ybTlIWbYdM0vRM48innRVmRmdHGDAZ0u+IxDJsZ329Qm65qZUmu2Ta+EBwxTOjA8m+yFVXibvsOpcxIY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365465; c=relaxed/simple;
	bh=npThKAFz0zS8F3mkw5o0gNRaBg90+nuDkMFklAKHbQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hj1kGRbF6aOQH/XMvnVW4JygQhQrTw/2NVaq1ufynVTWZvztHaG5vs+MFt2mrO9pLik9+gy7kgbMuHXROHt/jUmTLwcmyK5D2DtNJV8C6dYXQhfT9/rqYkQbsVoNVDbzChbksdpacdMWclYzwa35SwivZv97YjMoH0ZoL/aFPI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E2jfzBUO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E2jfzBUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A120CC4CEE9;
	Tue, 27 May 2025 17:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365465;
	bh=npThKAFz0zS8F3mkw5o0gNRaBg90+nuDkMFklAKHbQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E2jfzBUOYEbQMFu242Vy9LXqy4gUp2BVyvdBg9n2npxwBI9Mc/WvPrb5p1hWe2V08
	 tk89w2YSQwe66HoaTW78+Qt7EZr/QzeuW/XNEBHMrebRuf1qYslckZwZUqnXb5xQfk
	 2y8KP2waAZ81dhp8FxnjF1YBGyiz5eoNYHWEvHVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 377/626] x86/traps: Cleanup and robustify decode_bug()
Date: Tue, 27 May 2025 18:24:30 +0200
Message-ID: <20250527162500.335261796@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit c20ad96c9a8f0aeaf4e4057730a22de2657ad0c2 ]

Notably, don't attempt to decode an immediate when MOD == 3.

Additionally have it return the instruction length, such that WARN
like bugs can more reliably skip to the correct instruction.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Link: https://lore.kernel.org/r/20250207122546.721120726@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/bug.h |  5 ++-
 arch/x86/include/asm/ibt.h |  4 +-
 arch/x86/kernel/traps.c    | 82 ++++++++++++++++++++++++++++----------
 3 files changed, 65 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index 806649c7f23dc..9a0f29be1a9ea 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -22,8 +22,9 @@
 #define SECOND_BYTE_OPCODE_UD2	0x0b
 
 #define BUG_NONE		0xffff
-#define BUG_UD1			0xfffe
-#define BUG_UD2			0xfffd
+#define BUG_UD2			0xfffe
+#define BUG_UD1			0xfffd
+#define BUG_UD1_UBSAN		0xfffc
 
 #ifdef CONFIG_GENERIC_BUG
 
diff --git a/arch/x86/include/asm/ibt.h b/arch/x86/include/asm/ibt.h
index 1e59581d500ca..b778ae6e67ee8 100644
--- a/arch/x86/include/asm/ibt.h
+++ b/arch/x86/include/asm/ibt.h
@@ -41,7 +41,7 @@
 	_ASM_PTR fname "\n\t"				\
 	".popsection\n\t"
 
-static inline __attribute_const__ u32 gen_endbr(void)
+static __always_inline __attribute_const__ u32 gen_endbr(void)
 {
 	u32 endbr;
 
@@ -56,7 +56,7 @@ static inline __attribute_const__ u32 gen_endbr(void)
 	return endbr;
 }
 
-static inline __attribute_const__ u32 gen_endbr_poison(void)
+static __always_inline __attribute_const__ u32 gen_endbr_poison(void)
 {
 	/*
 	 * 4 byte NOP that isn't NOP4 (in fact it is OSP NOP3), such that it
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 5e3e036e6e537..b18fc7539b8d7 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -94,10 +94,17 @@ __always_inline int is_valid_bugaddr(unsigned long addr)
 
 /*
  * Check for UD1 or UD2, accounting for Address Size Override Prefixes.
- * If it's a UD1, get the ModRM byte to pass along to UBSan.
+ * If it's a UD1, further decode to determine its use:
+ *
+ * UBSan{0}:     67 0f b9 00             ud1    (%eax),%eax
+ * UBSan{10}:    67 0f b9 40 10          ud1    0x10(%eax),%eax
+ * static_call:  0f b9 cc                ud1    %esp,%ecx
+ *
+ * Notably UBSAN uses EAX, static_call uses ECX.
  */
-__always_inline int decode_bug(unsigned long addr, u32 *imm)
+__always_inline int decode_bug(unsigned long addr, s32 *imm, int *len)
 {
+	unsigned long start = addr;
 	u8 v;
 
 	if (addr < TASK_SIZE_MAX)
@@ -110,24 +117,42 @@ __always_inline int decode_bug(unsigned long addr, u32 *imm)
 		return BUG_NONE;
 
 	v = *(u8 *)(addr++);
-	if (v == SECOND_BYTE_OPCODE_UD2)
+	if (v == SECOND_BYTE_OPCODE_UD2) {
+		*len = addr - start;
 		return BUG_UD2;
+	}
 
-	if (!IS_ENABLED(CONFIG_UBSAN_TRAP) || v != SECOND_BYTE_OPCODE_UD1)
+	if (v != SECOND_BYTE_OPCODE_UD1)
 		return BUG_NONE;
 
-	/* Retrieve the immediate (type value) for the UBSAN UD1 */
-	v = *(u8 *)(addr++);
-	if (X86_MODRM_RM(v) == 4)
-		addr++;
-
 	*imm = 0;
-	if (X86_MODRM_MOD(v) == 1)
-		*imm = *(u8 *)addr;
-	else if (X86_MODRM_MOD(v) == 2)
-		*imm = *(u32 *)addr;
-	else
-		WARN_ONCE(1, "Unexpected MODRM_MOD: %u\n", X86_MODRM_MOD(v));
+	v = *(u8 *)(addr++);		/* ModRM */
+
+	if (X86_MODRM_MOD(v) != 3 && X86_MODRM_RM(v) == 4)
+		addr++;			/* SIB */
+
+	/* Decode immediate, if present */
+	switch (X86_MODRM_MOD(v)) {
+	case 0: if (X86_MODRM_RM(v) == 5)
+			addr += 4; /* RIP + disp32 */
+		break;
+
+	case 1: *imm = *(s8 *)addr;
+		addr += 1;
+		break;
+
+	case 2: *imm = *(s32 *)addr;
+		addr += 4;
+		break;
+
+	case 3: break;
+	}
+
+	/* record instruction length */
+	*len = addr - start;
+
+	if (X86_MODRM_REG(v) == 0)	/* EAX */
+		return BUG_UD1_UBSAN;
 
 	return BUG_UD1;
 }
@@ -258,10 +283,10 @@ static inline void handle_invalid_op(struct pt_regs *regs)
 static noinstr bool handle_bug(struct pt_regs *regs)
 {
 	bool handled = false;
-	int ud_type;
-	u32 imm;
+	int ud_type, ud_len;
+	s32 ud_imm;
 
-	ud_type = decode_bug(regs->ip, &imm);
+	ud_type = decode_bug(regs->ip, &ud_imm, &ud_len);
 	if (ud_type == BUG_NONE)
 		return handled;
 
@@ -281,15 +306,28 @@ static noinstr bool handle_bug(struct pt_regs *regs)
 	 */
 	if (regs->flags & X86_EFLAGS_IF)
 		raw_local_irq_enable();
-	if (ud_type == BUG_UD2) {
+
+	switch (ud_type) {
+	case BUG_UD2:
 		if (report_bug(regs->ip, regs) == BUG_TRAP_TYPE_WARN ||
 		    handle_cfi_failure(regs) == BUG_TRAP_TYPE_WARN) {
-			regs->ip += LEN_UD2;
+			regs->ip += ud_len;
 			handled = true;
 		}
-	} else if (IS_ENABLED(CONFIG_UBSAN_TRAP)) {
-		pr_crit("%s at %pS\n", report_ubsan_failure(regs, imm), (void *)regs->ip);
+		break;
+
+	case BUG_UD1_UBSAN:
+		if (IS_ENABLED(CONFIG_UBSAN_TRAP)) {
+			pr_crit("%s at %pS\n",
+				report_ubsan_failure(regs, ud_imm),
+				(void *)regs->ip);
+		}
+		break;
+
+	default:
+		break;
 	}
+
 	if (regs->flags & X86_EFLAGS_IF)
 		raw_local_irq_disable();
 	instrumentation_end();
-- 
2.39.5



