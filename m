Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BC013DBB3;
	Tue, 27 Feb 2024 14:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043453; cv=none; b=GElhUHyHy9s7b/fbk7bq6QrM84kz+QeMODwZCX8yoxqwRhlVp3vIO1fCA0YT7A8XhiUbUePsothOAHXh18wvzhviOW9OaOv2hpO4DJ4sMlwJw48CD4tkZR6Ps69TfqnhkTgo0DYtTPLZu+l3latutHmuwmhn1C1KdiIVlPN9V4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043453; c=relaxed/simple;
	bh=YkRJhG8B277mJDDi459OxwwEa7hA7bpiFHGF/zG1qxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIxqEaNJLJV7rRKm0jxiC5QXSkL1iFyZaXHqZuU6AA4Hx0+DGYNn8mFTmk8OrqdS2TlRhs2pSdoxoCHnKN5ZnNlhfm8TrSnx59fUstUipgczlGVfrL5+PWDVSy6fY7S/hVBmK354Qa/toVvqrpc95cW6coudkY6kUNZcLwf2mQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0j3oEcNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0j3oEcNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6DCC433C7;
	Tue, 27 Feb 2024 14:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043453;
	bh=YkRJhG8B277mJDDi459OxwwEa7hA7bpiFHGF/zG1qxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0j3oEcNzAt3o7ntOT1NvrV7Dkn9tDhqxvbFhZPrzDPtstGaY9pub+K6X3/ltubvMa
	 54+v7hueRufvO1tSIZvQJ6/bMN96zKiVLdUIBK+5HOARpH8Y+MRqTzpAp/widhnnhH
	 m8TdQki8EWKaeWOFNwqTZYxz+pk7TF3Ba300CKdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 114/195] x86/alternative: Make custom return thunk unconditional
Date: Tue, 27 Feb 2024 14:26:15 +0100
Message-ID: <20240227131614.226628490@linuxfoundation.org>
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
@@ -205,7 +205,11 @@
 typedef u8 retpoline_thunk_t[RETPOLINE_THUNK_SIZE];
 extern retpoline_thunk_t __x86_indirect_thunk_array[];
 
+#ifdef CONFIG_RETHUNK
 extern void __x86_return_thunk(void);
+#else
+static inline void __x86_return_thunk(void) {}
+#endif
 
 extern void retbleed_return_thunk(void);
 extern void srso_return_thunk(void);
@@ -218,11 +222,7 @@ extern void srso_alias_untrain_ret(void)
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
@@ -537,10 +537,6 @@ void __init_or_module noinline apply_ret
 
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


