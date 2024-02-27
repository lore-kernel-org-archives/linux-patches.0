Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A98146E78;
	Tue, 27 Feb 2024 14:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044167; cv=none; b=c3/cYcz0YlLCuLvP/92ELhcLF9R3VSdsQYiBmuMoOuKH+uMcbM0vlosCiLuxwaRTLWocrWiVvdONvlmZXnMEVhzqKifFnrxv46GPiU4Ua2KiFwEo5j/SWmyY+/aS3F8rWdfAe8jwwNNW3GaedyYUBJ2hcSz64xw40pZp0gRd9W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044167; c=relaxed/simple;
	bh=Pfe4Ds++qbZKADJdyGM9etO94qJiuKcNs/KRvJFGy58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oj9kVM5NrCJmKmIf9IYBn6lT7mPw/0CWDy2jGIRQfcJR6YqALlVTBbQUF1KjaCEMW73Gowm5pyxhkSzePddnMD0vGWvU2oznpdTh+5/pPJnwXgPSjLQnrAUdKT2S9uRJHjaXDzPSEcvPupC8tetoM872FS+/4HfWJ9hqeGJBz2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrSAUtxw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrSAUtxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F59AC433C7;
	Tue, 27 Feb 2024 14:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044167;
	bh=Pfe4Ds++qbZKADJdyGM9etO94qJiuKcNs/KRvJFGy58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KrSAUtxwIBBx0cAWGvCptim+xR1e2xEtKzK3lOrILvtfyBH9sCWHwrlHf9LygHb4r
	 3iXNaPav9O9iNhRDmqubNOHOOxfaljKQDhFMn6KQQxH1ti82cHkeMQj0dL5s2BNgJP
	 29xyQejqeGDzKQYNIVAAvMHBHHIY6kqLtxjQliLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.10 087/122] x86/returnthunk: Allow different return thunks
Date: Tue, 27 Feb 2024 14:27:28 +0100
Message-ID: <20240227131601.553195027@linuxfoundation.org>
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
 arch/x86/kernel/cpu/bugs.c           |    2 ++
 arch/x86/kernel/ftrace.c             |    2 +-
 arch/x86/kernel/static_call.c        |    2 +-
 arch/x86/net/bpf_jit_comp.c          |    2 +-
 6 files changed, 25 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -207,6 +207,12 @@ extern void srso_alias_untrain_ret(void)
 extern void entry_untrain_ret(void);
 extern void entry_ibpb(void);
 
+#ifdef CONFIG_CALL_THUNKS
+extern void (*x86_return_thunk)(void);
+#else
+#define x86_return_thunk	(&__x86_return_thunk)
+#endif
+
 #ifdef CONFIG_RETPOLINE
 
 typedef u8 retpoline_thunk_t[RETPOLINE_THUNK_SIZE];
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -676,6 +676,11 @@ void __init_or_module noinline apply_ret
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
@@ -691,14 +696,18 @@ static int patch_return(void *addr, stru
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
 
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -61,7 +61,9 @@ EXPORT_SYMBOL_GPL(x86_pred_cmd);
 
 static DEFINE_MUTEX(spec_ctrl_mutex);
 
+#ifdef CONFIG_CALL_THUNKS
 void (*x86_return_thunk)(void) __ro_after_init = &__x86_return_thunk;
+#endif
 
 /* Update SPEC_CTRL MSR and its cached copy unconditionally */
 static void update_spec_ctrl(u64 val)
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -368,7 +368,7 @@ create_trampoline(struct ftrace_ops *ops
 
 	ip = trampoline + size;
 	if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
-		__text_gen_insn(ip, JMP32_INSN_OPCODE, ip, &__x86_return_thunk, JMP32_INSN_SIZE);
+		__text_gen_insn(ip, JMP32_INSN_OPCODE, ip, x86_return_thunk, JMP32_INSN_SIZE);
 	else
 		memcpy(ip, retq, sizeof(retq));
 
--- a/arch/x86/kernel/static_call.c
+++ b/arch/x86/kernel/static_call.c
@@ -41,7 +41,7 @@ static void __ref __static_call_transfor
 
 	case RET:
 		if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
-			code = text_gen_insn(JMP32_INSN_OPCODE, insn, &__x86_return_thunk);
+			code = text_gen_insn(JMP32_INSN_OPCODE, insn, x86_return_thunk);
 		else
 			code = &retinsn;
 		break;
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -405,7 +405,7 @@ static void emit_return(u8 **pprog, u8 *
 	int cnt = 0;
 
 	if (cpu_feature_enabled(X86_FEATURE_RETHUNK)) {
-		emit_jump(&prog, &__x86_return_thunk, ip);
+		emit_jump(&prog, x86_return_thunk, ip);
 	} else {
 		EMIT1(0xC3);		/* ret */
 		if (IS_ENABLED(CONFIG_SLS))


