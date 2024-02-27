Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D54145350;
	Tue, 27 Feb 2024 14:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044175; cv=none; b=MHT+LxQlgP3L/Y96+yerb/GAPjnvlJ1iZQhJlU2/JrHO0dcad7Hj4W8SVAMFD75rMYXe/a/0faa00IZHVtb90Zq9sPJb2W7puqsfURQ5+7JYFrHGEM04OJspUCFLa0O2NcYVTapWtdQ7Q6brj8HPLkw/0wErJxvm+i4AmtXUFe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044175; c=relaxed/simple;
	bh=Ulqts0juJFOVBLJenLoqMWIHny5lUEKAet9TESZ+y40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8D7Y4VVl5j3xsZiImwQrzOU5I+W1AC/7K/bkxjjQ/u5Px6XbqYKZsjdNTFjvtFDBRcBMmYNAessNND+PJUT4gCwo2m1n2ron3EF1kGtiCfO3rdradQqxw3kv7Z6Qd0YLMwrGobd+rn26LdDE/YQABOkciUYlGs28Rex2TYMzTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qYssHczK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYssHczK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144B4C433F1;
	Tue, 27 Feb 2024 14:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044175;
	bh=Ulqts0juJFOVBLJenLoqMWIHny5lUEKAet9TESZ+y40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYssHczKdEuHfW58b1b62j+skP0azvbX2mhSyRcNzquV+Nf+Q0vR43sz25G8ccCJ9
	 PTnXoUc/9FeLA2pJeOZdeC+PAZ49H5PWlaFFjhH/pAj3wP/6A5yJYlpl/q4VLzrYtD
	 M6KGYiQORVBGFX+AbSQRhBtL/0BMKFBBGtYNjblE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.10 089/122] x86/alternative: Make custom return thunk unconditional
Date: Tue, 27 Feb 2024 14:27:30 +0100
Message-ID: <20240227131601.618509293@linuxfoundation.org>
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
@@ -677,10 +677,6 @@ void __init_or_module noinline apply_ret
 
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
@@ -61,6 +61,8 @@ EXPORT_SYMBOL_GPL(x86_pred_cmd);
 
 static DEFINE_MUTEX(spec_ctrl_mutex);
 
+void (*x86_return_thunk)(void) __ro_after_init = &__x86_return_thunk;
+
 /* Update SPEC_CTRL MSR and its cached copy unconditionally */
 static void update_spec_ctrl(u64 val)
 {


