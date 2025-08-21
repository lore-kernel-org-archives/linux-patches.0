Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFB22EA731;
	Thu, 21 Aug 2025 21:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810986; cv=none; b=WsBxgovuLC5r2jnwpQwVDo3VvRgn3iUhdcD2YIKkz0Xba7OIty7KFqGYeSN/ufVKqDbhy1KuyAGtanzSofs1BmanJj6cO5Bw7iUZ/u0DtBKWlt95OA2iHKaaU96oBJ2WskwvBDx1Cr36xPdfHwcT0AnXhqB3kqQ2SxgjR7vHTdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810986; c=relaxed/simple;
	bh=edt5ONquqT6iefl+nGEw5FvaJQsAKIBbDF2dxmXAwzw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RCOdRxCLIzupMMuOenw3EFzjqxC9uKHcbz9+pP5Ib8y8SPRk+uzwTithor29XnveXIE4NOYfIGXeMDQnqXtEr8ll/gkCQC1+N3Sw7kb4dJamGl7Sz4WXi3bkR+MfQp8HECQF3sZMIPN1SzklDedAMhpgYMcw8uI8jziNKIZIHqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PyZwQa5Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PyZwQa5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B8FC113D0;
	Thu, 21 Aug 2025 21:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755810985;
	bh=edt5ONquqT6iefl+nGEw5FvaJQsAKIBbDF2dxmXAwzw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=PyZwQa5Q42gL7fCCWeh3RoRfiFAVlwSQniefUY1pvH7Y4HzM42nafXcIbWUrfgemW
	 tiCtzl6n/Ljo4CSzguK19m5W/XWrxQL5X2iDTPnSOuZXXoQ6CiF9VeKCYEodhLs6d+
	 9/5Wnp3dPZMBdqIQ6a70Idmsv+E4BRS4xA6I92H5qSAWcvwhIxmtb4p1lr4pZVBYf8
	 pWtYUttnVycDxQdTexx5S9MQlX/NriKkzdbO7eJFVTFB3ea28Uxw7vxDSWujf1OUHC
	 qVFn/z5C8b8k2ADar1zwSDMAdsAkeW+hiMDFpieco5HFjfFmq04++Q2VGf6rCd2Xkd
	 ZChcLAkfGK6KA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 21 Aug 2025 14:15:48 -0700
Subject: [PATCH v2 11/12] objtool: Drop noinstr hack for KCSAN_WEAK_MEMORY
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250821-bump-min-llvm-ver-15-v2-11-635f3294e5f0@kernel.org>
References: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
In-Reply-To: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Marco Elver <elver@google.com>, 
 "Peter Zijlstra (Intel)" <peterz@infraded.org>, 
 Nathan Chancellor <nathan@kernel.org>, kasan-dev@googlegroups.com
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2230; i=nathan@kernel.org;
 h=from:subject:message-id; bh=edt5ONquqT6iefl+nGEw5FvaJQsAKIBbDF2dxmXAwzw=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnLe1pKmUXsD9i/+j9z9ePwx9LqPVJZDz8/s5gtycyY9
 sm6dpp/RykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZiIkAUjw+U4rycb7d3Y15z+
 +b26TuOmiOx51kfLJoQZbY/yWKm2k5uR4a3eX4Hb6xrrQ3ZM/LHtqZeKibheU0i5ddmN/3mGz1U
 +cwMA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Now that the minimum supported version of LLVM for building the kernel
has been bumped to 15.0.0, __no_kcsan will always ensure that the thread
sanitizer functions are not generated, so remove the check for tsan
functions in is_profiling_func() and the always true depends and
unnecessary select lines in KCSAN_WEAK_MEMORY.

Acked-by: Marco Elver <elver@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infraded.org>
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
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

