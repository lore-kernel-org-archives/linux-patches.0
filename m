Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B1732BF33;
	Mon, 18 Aug 2025 18:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755543494; cv=none; b=jpBrORHG+Utn3cyoyOQntjjBtS3kic4uGUym1Lc4z81i3LmQiNRmNuNL3bQBiLIIboFAjvSs40NFQ8c3MXaoKbCt4pI9Hwwxe2rE637ntK255WqPpfBunl4kjhYdd5O+F7UTgszjpdePX4yUDTIBv5ErWOa3spuDxD8350f6PKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755543494; c=relaxed/simple;
	bh=8nczhCzHMt2OUqv/92g+T6OrJZMdvXVJMDe6DkMp4ks=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=K5NobuvdN7Pr1GyAl0DlInGne1aeU3T+U8W4pneVCpvss8PVQxkmfjujP6iyCXYk/XLYb2QrmQirrXI3LiZjUwnJmSFHQ2p6u+1USY+jgaHxMzg5bKwEg+y9tnBW5RNukqpwXLGXvyKJQDibeiJmQdXxgCOUvKo0GgmDzHkmi1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MB3X2jal; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MB3X2jal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B86DC116D0;
	Mon, 18 Aug 2025 18:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755543493;
	bh=8nczhCzHMt2OUqv/92g+T6OrJZMdvXVJMDe6DkMp4ks=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=MB3X2jalAuO/10tXMdzey/jcqLktuHTQtPCnhvyaIkBb0RBy9LdAPiKbfn7f8t+19
	 tEkCHb47UfLK4Y2lZeRCAEgoEExhjvH0rj3M0qefNXyE+MQM/Gw7fWAKkPwcTmDeji
	 /Bq5IJT6WSP4XfEpUJmfU2f3EmmQj4zUyk3+96+uq1dmLkclhGKmsNv0ll1O3SL4kv
	 CKPVF2xgU3ayLxdJIv7vPbnRpxNAblF9asz4X0seMAQ9sMcUL+ZVvqaks0q8MtkhvB
	 CtiJMCvX3N6Kj/ArVgNUez8XWiYj6Uu+F4pwGT+xTk7nuzx9qZOMpg2FJemeyDC9OY
	 S+Pcu8Mp6OnyA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 18 Aug 2025 11:57:25 -0700
Subject: [PATCH 09/10] objtool: Drop noinstr hack for KCSAN_WEAK_MEMORY
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250818-bump-min-llvm-ver-15-v1-9-c8b1d0f955e0@kernel.org>
References: <20250818-bump-min-llvm-ver-15-v1-0-c8b1d0f955e0@kernel.org>
In-Reply-To: <20250818-bump-min-llvm-ver-15-v1-0-c8b1d0f955e0@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2251; i=nathan@kernel.org;
 h=from:subject:message-id; bh=8nczhCzHMt2OUqv/92g+T6OrJZMdvXVJMDe6DkMp4ks=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBmLyxfNWfcv4eSzLJNN6zb8P3FyStn3GKupuWIHXhX0r
 lpQu329Y0cpC4MYF4OsmCJL9WPV44aGc84y3jg1CWYOKxPIEAYuTgGYyCMjRobrHL5WchtvPMtY
 xt5atvnlGcO06P6WmS8rnBWvX9ujsu4ZI8P63o3WT3WW27Z4GdxwYc3+deMsV1nBsu1+3HuLS6N
 dZrMDAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Now that the minimum supported version of LLVM for building the kernel
has been bumped to 15.0.0, __no_kcsan will always ensure that the thread
sanitizer functions are not generated, so remove the check for tsan
functions in is_profiling_func() and the always true depends and
unnecessary select lines in KCSAN_WEAK_MEMORY.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: kasan-dev@googlegroups.com
---
 lib/Kconfig.kcsan     |  6 ------
 tools/objtool/check.c | 10 ----------
 2 files changed, 16 deletions(-)

diff --git a/lib/Kconfig.kcsan b/lib/Kconfig.kcsan
index 609ddfc73de5..4ce4b0c0109c 100644
--- a/lib/Kconfig.kcsan
+++ b/lib/Kconfig.kcsan
@@ -185,12 +185,6 @@ config KCSAN_WEAK_MEMORY
 	bool "Enable weak memory modeling to detect missing memory barriers"
 	default y
 	depends on KCSAN_STRICT
-	# We can either let objtool nop __tsan_func_{entry,exit}() and builtin
-	# atomics instrumentation in .noinstr.text, or use a compiler that can
-	# implement __no_kcsan to really remove all instrumentation.
-	depends on !ARCH_WANTS_NO_INSTR || HAVE_NOINSTR_HACK || \
-		   CC_IS_GCC || CLANG_VERSION >= 140000
-	select OBJTOOL if HAVE_NOINSTR_HACK
 	help
 	  Enable support for modeling a subset of weak memory, which allows
 	  detecting a subset of data races due to missing memory barriers.
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index d14f20ef1db1..efa4c060ff4e 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2453,16 +2453,6 @@ static bool is_profiling_func(const char *name)
 	if (!strncmp(name, "__sanitizer_cov_", 16))
 		return true;
 
-	/*
-	 * Some compilers currently do not remove __tsan_func_entry/exit nor
-	 * __tsan_atomic_signal_fence (used for barrier instrumentation) with
-	 * the __no_sanitize_thread attribute, remove them. Once the kernel's
-	 * minimum Clang version is 14.0, this can be removed.
-	 */
-	if (!strncmp(name, "__tsan_func_", 12) ||
-	    !strcmp(name, "__tsan_atomic_signal_fence"))
-		return true;
-
 	return false;
 }
 

-- 
2.50.1

