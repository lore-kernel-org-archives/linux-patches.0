Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B47E111A8
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6FAC433C7;
	Thu, 24 Aug 2023 14:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692886557;
	bh=Y++HytWoCvaiZO567pWmDCksKKn3udrWzokzJMT+iOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMBWokuUyq/ZXNFLmUmD+jpt80hUByO5nHWGAIuIG/J10eHIGKfMwTn2rh1CnR1Ll
	 AXq+nRC9Kn4lzrvS4CDVnKHEKBUzEq12nwBePwls15CWhbA+zLAM2ElGuMh2crgRo3
	 OU7vlgWmCYxJp63NuVqjG3qbk2TUcFZVcg886qEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 07/15] x86/cpu: Cleanup the untrain mess
Date: Thu, 24 Aug 2023 16:15:03 +0200
Message-ID: <20230824141447.520565902@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824141447.155846739@linuxfoundation.org>
References: <20230824141447.155846739@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

commit e7c25c441e9e0fa75b4c83e0b26306b702cfe90d upstream.

Since there can only be one active return_thunk, there only needs be
one (matching) untrain_ret. It fundamentally doesn't make sense to
allow multiple untrain_ret at the same time.

Fold all the 3 different untrain methods into a single (temporary)
helper stub.

Fixes: fb3bd914b3ec ("x86/srso: Add a Speculative RAS Overflow mitigation")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230814121149.042774962@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |   12 ++++--------
 arch/x86/kernel/cpu/bugs.c           |    1 +
 arch/x86/lib/retpoline.S             |    7 +++++++
 3 files changed, 12 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -168,9 +168,9 @@
 .endm
 
 #ifdef CONFIG_CPU_UNRET_ENTRY
-#define CALL_ZEN_UNTRAIN_RET	"call retbleed_untrain_ret"
+#define CALL_UNTRAIN_RET	"call entry_untrain_ret"
 #else
-#define CALL_ZEN_UNTRAIN_RET	""
+#define CALL_UNTRAIN_RET	""
 #endif
 
 /*
@@ -189,14 +189,9 @@
 	defined(CONFIG_CPU_SRSO)
 	ANNOTATE_UNRET_END
 	ALTERNATIVE_2 "",						\
-	              CALL_ZEN_UNTRAIN_RET, X86_FEATURE_UNRET,		\
+		      CALL_UNTRAIN_RET, X86_FEATURE_UNRET,		\
 		      "call entry_ibpb", X86_FEATURE_ENTRY_IBPB
 #endif
-
-#ifdef CONFIG_CPU_SRSO
-	ALTERNATIVE_2 "", "call srso_untrain_ret", X86_FEATURE_SRSO, \
-			  "call srso_alias_untrain_ret", X86_FEATURE_SRSO_ALIAS
-#endif
 .endm
 
 #else /* __ASSEMBLY__ */
@@ -224,6 +219,7 @@ extern void retbleed_untrain_ret(void);
 extern void srso_untrain_ret(void);
 extern void srso_alias_untrain_ret(void);
 
+extern void entry_untrain_ret(void);
 extern void entry_ibpb(void);
 
 #ifdef CONFIG_RETPOLINE
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2429,6 +2429,7 @@ static void __init srso_select_mitigatio
 			 * like ftrace, static_call, etc.
 			 */
 			setup_force_cpu_cap(X86_FEATURE_RETHUNK);
+			setup_force_cpu_cap(X86_FEATURE_UNRET);
 
 			if (boot_cpu_data.x86 == 0x19) {
 				setup_force_cpu_cap(X86_FEATURE_SRSO_ALIAS);
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -233,6 +233,13 @@ SYM_CODE_START(srso_return_thunk)
 	ud2
 SYM_CODE_END(srso_return_thunk)
 
+SYM_FUNC_START(entry_untrain_ret)
+	ALTERNATIVE_2 "jmp retbleed_untrain_ret", \
+		      "jmp srso_untrain_ret", X86_FEATURE_SRSO, \
+		      "jmp srso_alias_untrain_ret", X86_FEATURE_SRSO_ALIAS
+SYM_FUNC_END(entry_untrain_ret)
+__EXPORT_THUNK(entry_untrain_ret)
+
 SYM_CODE_START(__x86_return_thunk)
 	UNWIND_HINT_FUNC
 	ANNOTATE_NOENDBR


