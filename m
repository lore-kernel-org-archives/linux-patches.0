Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BBD446AC;
	Mon,  1 Apr 2024 16:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987796; cv=none; b=m8YM5PqonH6G8CIc0+js04PPMtb0Ol7vh+85VPQCjkkE1/IZzyN8UlXa3tgyjg+gLHaZK6+mcSv3mt+WlBZyHRPEQkWsTxT/KycrhCar4IszlnvpKGrLAnHL4ZsxPH+RV28sDbzdc5CAYGQ+pr+BoDbKIo6a0Fqylu5RI9mqJWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987796; c=relaxed/simple;
	bh=Y4RKppoGazh+5s4S1E0tTzCHTUfFreL5kIkeZ+7KRlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=remmAx02q5ar8PbhU3DmgwQX96WYSX+c3xpNwQTMajxa9ZG2O1Za5Wqn29eyQB/bbLmhhIOXd+OhliyJsS/khoV1IVjMnqHOSLtoLYDj6dMebJIov5tL27iBt5MQ6EXYHdryfprnDWvSFo6sUuybmdVk1Kg01WTGMG85N4J3D2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iNmEfm50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iNmEfm50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A759C433C7;
	Mon,  1 Apr 2024 16:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987796;
	bh=Y4RKppoGazh+5s4S1E0tTzCHTUfFreL5kIkeZ+7KRlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iNmEfm50DqU6wQ/MfsdDqv5DlrOpsrc1/2HvGO4V0wyP66+rdI8Vg7m9octqMDyEc
	 uDHgGelqYBYOrZMzCxrQQ/pkMsNYsRj3Lj10C2Mk52V0NrpluRTHA34++T18xbPZ9O
	 f1r0yz8m9CdIbw55F6Kt1IfcyTVmOz6Hk6hPwGfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	stable@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.8 387/399] x86/bugs: Fix the SRSO mitigation on Zen3/4
Date: Mon,  1 Apr 2024 17:45:53 +0200
Message-ID: <20240401152600.724360931@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 4535e1a4174c4111d92c5a9a21e542d232e0fcaa upstream.

The original version of the mitigation would patch in the calls to the
untraining routines directly.  That is, the alternative() in UNTRAIN_RET
will patch in the CALL to srso_alias_untrain_ret() directly.

However, even if commit e7c25c441e9e ("x86/cpu: Cleanup the untrain
mess") meant well in trying to clean up the situation, due to micro-
architectural reasons, the untraining routine srso_alias_untrain_ret()
must be the target of a CALL instruction and not of a JMP instruction as
it is done now.

Reshuffle the alternative macros to accomplish that.

Fixes: e7c25c441e9e ("x86/cpu: Cleanup the untrain mess")
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/asm-prototypes.h |    1 +
 arch/x86/include/asm/nospec-branch.h  |   21 ++++++++++++++++-----
 arch/x86/lib/retpoline.S              |   11 ++++++-----
 3 files changed, 23 insertions(+), 10 deletions(-)

--- a/arch/x86/include/asm/asm-prototypes.h
+++ b/arch/x86/include/asm/asm-prototypes.h
@@ -13,6 +13,7 @@
 #include <asm/preempt.h>
 #include <asm/asm.h>
 #include <asm/gsseg.h>
+#include <asm/nospec-branch.h>
 
 #ifndef CONFIG_X86_CMPXCHG64
 extern void cmpxchg8b_emu(void);
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -271,11 +271,20 @@
 .Lskip_rsb_\@:
 .endm
 
+/*
+ * The CALL to srso_alias_untrain_ret() must be patched in directly at
+ * the spot where untraining must be done, ie., srso_alias_untrain_ret()
+ * must be the target of a CALL instruction instead of indirectly
+ * jumping to a wrapper which then calls it. Therefore, this macro is
+ * called outside of __UNTRAIN_RET below, for the time being, before the
+ * kernel can support nested alternatives with arbitrary nesting.
+ */
+.macro CALL_UNTRAIN_RET
 #if defined(CONFIG_CPU_UNRET_ENTRY) || defined(CONFIG_CPU_SRSO)
-#define CALL_UNTRAIN_RET	"call entry_untrain_ret"
-#else
-#define CALL_UNTRAIN_RET	""
+	ALTERNATIVE_2 "", "call entry_untrain_ret", X86_FEATURE_UNRET, \
+		          "call srso_alias_untrain_ret", X86_FEATURE_SRSO_ALIAS
 #endif
+.endm
 
 /*
  * Mitigate RETBleed for AMD/Hygon Zen uarch. Requires KERNEL CR3 because the
@@ -291,8 +300,8 @@
 .macro __UNTRAIN_RET ibpb_feature, call_depth_insns
 #if defined(CONFIG_RETHUNK) || defined(CONFIG_CPU_IBPB_ENTRY)
 	VALIDATE_UNRET_END
-	ALTERNATIVE_3 "",						\
-		      CALL_UNTRAIN_RET, X86_FEATURE_UNRET,		\
+	CALL_UNTRAIN_RET
+	ALTERNATIVE_2 "",						\
 		      "call entry_ibpb", \ibpb_feature,			\
 		     __stringify(\call_depth_insns), X86_FEATURE_CALL_DEPTH
 #endif
@@ -351,6 +360,8 @@ extern void retbleed_return_thunk(void);
 static inline void retbleed_return_thunk(void) {}
 #endif
 
+extern void srso_alias_untrain_ret(void);
+
 #ifdef CONFIG_CPU_SRSO
 extern void srso_return_thunk(void);
 extern void srso_alias_return_thunk(void);
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -163,6 +163,7 @@ SYM_CODE_START_NOALIGN(srso_alias_untrai
 	lfence
 	jmp srso_alias_return_thunk
 SYM_FUNC_END(srso_alias_untrain_ret)
+__EXPORT_THUNK(srso_alias_untrain_ret)
 	.popsection
 
 	.pushsection .text..__x86.rethunk_safe
@@ -224,10 +225,12 @@ SYM_CODE_START(srso_return_thunk)
 SYM_CODE_END(srso_return_thunk)
 
 #define JMP_SRSO_UNTRAIN_RET "jmp srso_untrain_ret"
-#define JMP_SRSO_ALIAS_UNTRAIN_RET "jmp srso_alias_untrain_ret"
 #else /* !CONFIG_CPU_SRSO */
 #define JMP_SRSO_UNTRAIN_RET "ud2"
-#define JMP_SRSO_ALIAS_UNTRAIN_RET "ud2"
+/* Dummy for the alternative in CALL_UNTRAIN_RET. */
+SYM_CODE_START(srso_alias_untrain_ret)
+	RET
+SYM_FUNC_END(srso_alias_untrain_ret)
 #endif /* CONFIG_CPU_SRSO */
 
 #ifdef CONFIG_CPU_UNRET_ENTRY
@@ -319,9 +322,7 @@ SYM_FUNC_END(retbleed_untrain_ret)
 #if defined(CONFIG_CPU_UNRET_ENTRY) || defined(CONFIG_CPU_SRSO)
 
 SYM_FUNC_START(entry_untrain_ret)
-	ALTERNATIVE_2 JMP_RETBLEED_UNTRAIN_RET,				\
-		      JMP_SRSO_UNTRAIN_RET, X86_FEATURE_SRSO,		\
-		      JMP_SRSO_ALIAS_UNTRAIN_RET, X86_FEATURE_SRSO_ALIAS
+	ALTERNATIVE JMP_RETBLEED_UNTRAIN_RET, JMP_SRSO_UNTRAIN_RET, X86_FEATURE_SRSO
 SYM_FUNC_END(entry_untrain_ret)
 __EXPORT_THUNK(entry_untrain_ret)
 


