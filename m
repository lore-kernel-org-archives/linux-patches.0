Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7510145B24;
	Tue, 27 Feb 2024 14:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042792; cv=none; b=iRGtwue+VlRQnU/pUw+UX5O4waBTByxm2LRq1JS+PbzKQ7f+mxy1Bt1bJvHFCFGHOxbCOE4Nnl28Y1ZAvUq2x+qHySCM75qiipM8XCEm7+hbWcbZ0fzJRyOviQjblvtcaED+ohK/C08Q4FOKgqFhfTa4z3m48bpZYIfLQWGO2Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042792; c=relaxed/simple;
	bh=j91njg2ale8z6ZVLcfWF8w1fXV6bmwxdmVkriTG2YKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JR/9lniWhhZKIBTJRAH2d7dW4qS4PARAZDBNZR1i6EYxkTqrcv+jHJ/OPcOrLj3VSBVaAB09ttJLuS9Mcfy68Ob9XP5NztQ0zs8fUsRtSU88OZpniqqcjQfPitekGzXbvQmJ7A6ZYvwkGxCeip8s9omz40ffvBjVx2euEo760Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqS+bKDz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqS+bKDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E29C433C7;
	Tue, 27 Feb 2024 14:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042792;
	bh=j91njg2ale8z6ZVLcfWF8w1fXV6bmwxdmVkriTG2YKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqS+bKDzUbE7yhU5y6m0wkS77j3z98RI3Fst287NFACPhnlfTVzvpG+wlluDSACUV
	 Nc0BpvRmHbUZSL1cLzrfLIa3tTRaL6xEsW2RmoRhfouHIfrF/ov20jkffJhxlAR1t/
	 HJ5ntlA7TC61Qpo0bWspej/QHcvdwueUdv1I/t1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.15 094/245] x86/alternative: Make custom return thunk unconditional
Date: Tue, 27 Feb 2024 14:24:42 +0100
Message-ID: <20240227131618.275877842@linuxfoundation.org>
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

Upstream commit: 095b8303f3835c68ac4a8b6d754ca1c3b6230711

There is infrastructure to rewrite return thunks to point to any
random thunk one desires, unwrap that from CALL_THUNKS, which up to
now was the sole user of that.

  [ bp: Make the thunks visible on 32-bit and add ifdeffery for the
    32-bit builds. ]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230814121148.775293785@infradead.org
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    8 ++++----
 arch/x86/kernel/alternative.c        |    4 ----
 arch/x86/kernel/cpu/bugs.c           |    2 ++
 3 files changed, 6 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -190,7 +190,11 @@
 	_ASM_PTR " 999b\n\t"					\
 	".popsection\n\t"
 
+#ifdef CONFIG_RETHUNK
 extern void __x86_return_thunk(void);
+#else
+static inline void __x86_return_thunk(void) {}
+#endif
 
 extern void retbleed_return_thunk(void);
 extern void srso_return_thunk(void);
@@ -203,11 +207,7 @@ extern void srso_alias_untrain_ret(void)
 extern void entry_untrain_ret(void);
 extern void entry_ibpb(void);
 
-#ifdef CONFIG_CALL_THUNKS
 extern void (*x86_return_thunk)(void);
-#else
-#define x86_return_thunk	(&__x86_return_thunk)
-#endif
 
 #ifdef CONFIG_RETPOLINE
 
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -522,10 +522,6 @@ void __init_or_module noinline apply_ret
 
 #ifdef CONFIG_RETHUNK
 
-#ifdef CONFIG_CALL_THUNKS
-void (*x86_return_thunk)(void) __ro_after_init = &__x86_return_thunk;
-#endif
-
 /*
  * Rewrite the compiler generated return thunk tail-calls.
  *
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -62,6 +62,8 @@ EXPORT_SYMBOL_GPL(x86_pred_cmd);
 
 static DEFINE_MUTEX(spec_ctrl_mutex);
 
+void (*x86_return_thunk)(void) __ro_after_init = &__x86_return_thunk;
+
 /* Update SPEC_CTRL MSR and its cached copy unconditionally */
 static void update_spec_ctrl(u64 val)
 {


