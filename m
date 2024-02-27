Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E601420D2;
	Tue, 27 Feb 2024 14:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043448; cv=none; b=Lx37c9uNLKGv8poNcVbPJO4aggefAo01hhTdzDTLgPbV2/cnRuwPYd767xapLyFSSoi0uAue/Zf0INgjX6cTlSrhLJ2llugIEKNhSXunh0J9D/BcdlAnrylCNGUNL731DvfpUceSXH9EOa/99dioUN19Q08D8X5BMWw3+5sEG8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043448; c=relaxed/simple;
	bh=zd5b6MsQJXYrHWlTB4iroj8WkXW70SJnn7mJHL3pFWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OksAo/ezcGBmaVE6SuKheqO1myL/yAQLl2YF3k2YLurlozmZ7Ctc8qDZQBq6Lf7CgO51uRZJ/KW2+elq6n8qjvQfKBjCqfXU1xqzjWapCIk4F/NvXF844oAAfQw55JKx+KX+0d0PTrsYkFLRsaNDQ6hwJY4ae+koOBL+lldrLSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tjaGAeOx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tjaGAeOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C117C433C7;
	Tue, 27 Feb 2024 14:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043447;
	bh=zd5b6MsQJXYrHWlTB4iroj8WkXW70SJnn7mJHL3pFWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjaGAeOxKjRb7Knal2vCrUH2FoX44IB+0rVq1iFmQnb5X9W2lP6YwrwWAuQ44OGa/
	 IDYMkW00qRRdeK6k2zZI0w1vQePDz6VgzdA2WtdZ25noaDCeLqRgWEl/jJhqd8xd+B
	 D0Gj2nMhP3UPJ6tIV8FxzHIa5c7musqY6IgELwxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 112/195] x86/returnthunk: Allow different return thunks
Date: Tue, 27 Feb 2024 14:26:13 +0100
Message-ID: <20240227131614.161670412@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

Upstream commit: 770ae1b709528a6a173b5c7b183818ee9b45e376

In preparation for call depth tracking on Intel SKL CPUs, make it possible
to patch in a SKL specific return thunk.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220915111147.680469665@infradead.org
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    6 ++++++
 arch/x86/kernel/alternative.c        |   19 ++++++++++++++-----
 arch/x86/kernel/ftrace.c             |    2 +-
 arch/x86/kernel/static_call.c        |    2 +-
 arch/x86/net/bpf_jit_comp.c          |    2 +-
 5 files changed, 23 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -222,6 +222,12 @@ extern void srso_alias_untrain_ret(void)
 extern void entry_untrain_ret(void);
 extern void entry_ibpb(void);
 
+#ifdef CONFIG_CALL_THUNKS
+extern void (*x86_return_thunk)(void);
+#else
+#define x86_return_thunk	(&__x86_return_thunk)
+#endif
+
 #ifdef CONFIG_RETPOLINE
 
 #define GEN(reg) \
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -536,6 +536,11 @@ void __init_or_module noinline apply_ret
 }
 
 #ifdef CONFIG_RETHUNK
+
+#ifdef CONFIG_CALL_THUNKS
+void (*x86_return_thunk)(void) __ro_after_init = &__x86_return_thunk;
+#endif
+
 /*
  * Rewrite the compiler generated return thunk tail-calls.
  *
@@ -551,14 +556,18 @@ static int patch_return(void *addr, stru
 {
 	int i = 0;
 
-	if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
-		return -1;
-
-	bytes[i++] = RET_INSN_OPCODE;
+	if (cpu_feature_enabled(X86_FEATURE_RETHUNK)) {
+		if (x86_return_thunk == __x86_return_thunk)
+			return -1;
+
+		i = JMP32_INSN_SIZE;
+		__text_gen_insn(bytes, JMP32_INSN_OPCODE, addr, x86_return_thunk, i);
+	} else {
+		bytes[i++] = RET_INSN_OPCODE;
+	}
 
 	for (; i < insn->length;)
 		bytes[i++] = INT3_INSN_OPCODE;
-
 	return i;
 }
 
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -361,7 +361,7 @@ create_trampoline(struct ftrace_ops *ops
 
 	ip = trampoline + size;
 	if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
-		__text_gen_insn(ip, JMP32_INSN_OPCODE, ip, &__x86_return_thunk, JMP32_INSN_SIZE);
+		__text_gen_insn(ip, JMP32_INSN_OPCODE, ip, x86_return_thunk, JMP32_INSN_SIZE);
 	else
 		memcpy(ip, retq, sizeof(retq));
 
--- a/arch/x86/kernel/static_call.c
+++ b/arch/x86/kernel/static_call.c
@@ -80,7 +80,7 @@ static void __ref __static_call_transfor
 
 	case RET:
 		if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
-			code = text_gen_insn(JMP32_INSN_OPCODE, insn, &__x86_return_thunk);
+			code = text_gen_insn(JMP32_INSN_OPCODE, insn, x86_return_thunk);
 		else
 			code = &retinsn;
 		break;
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -432,7 +432,7 @@ static void emit_return(u8 **pprog, u8 *
 	u8 *prog = *pprog;
 
 	if (cpu_feature_enabled(X86_FEATURE_RETHUNK)) {
-		emit_jump(&prog, &__x86_return_thunk, ip);
+		emit_jump(&prog, x86_return_thunk, ip);
 	} else {
 		EMIT1(0xC3);		/* ret */
 		if (IS_ENABLED(CONFIG_SLS))


