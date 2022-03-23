Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920506AB9
	for <patches@lists.linux.dev>; Wed, 23 Mar 2022 23:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C254C36AE5;
	Wed, 23 Mar 2022 23:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648076842;
	bh=Mn597HtlR7hHko00l3+ts0+4UStMjYdTUVAbNrYygRE=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=dp6KKePILugWB+Rb8kHTD8NE6OkNB/fN1isvuYuWquBPjfQB64nLPL3xG/T8Z5mbw
	 hjM8LqYOX3Lg5h50O5CtSJU6RLo8G/W5v0BNY4VZM049vTP7LUqDLBeii/+nx/1kJl
	 dzAPislc+nuOm5wGKUw/gdy3W1WA32+zT3bMDbtw=
Date: Wed, 23 Mar 2022 16:07:21 -0700
To: ndesaulniers@google.com,nathan@kernel.org,keescook@chromium.org,glider@google.com,dvyukov@google.com,arnd@arndb.de,elver@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 41/41] Revert "ubsan, kcsan: Don't combine sanitizer with kcov on clang"
Message-Id: <20220323230722.5C254C36AE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Marco Elver <elver@google.com>
Subject: Revert "ubsan, kcsan: Don't combine sanitizer with kcov on clang"

This reverts commit ea91a1d45d19469001a4955583187b0d75915759.

Since df05c0e9496c ("Documentation: Raise the minimum supported version
of LLVM to 11.0.0") the minimum Clang version is now 11.0, which fixed
the UBSAN/KCSAN vs. KCOV incompatibilities.

Link: https://bugs.llvm.org/show_bug.cgi?id=45831
Link: https://lkml.kernel.org/r/YaodyZzu0MTCJcvO@elver.google.com
Link: https://lkml.kernel.org/r/20220128105631.509772-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kcsan |   11 -----------
 lib/Kconfig.ubsan |   12 ------------
 2 files changed, 23 deletions(-)

--- a/lib/Kconfig.kcsan~revert-ubsan-kcsan-dont-combine-sanitizer-with-kcov-on-clang
+++ a/lib/Kconfig.kcsan
@@ -10,21 +10,10 @@ config HAVE_KCSAN_COMPILER
 	  For the list of compilers that support KCSAN, please see
 	  <file:Documentation/dev-tools/kcsan.rst>.
 
-config KCSAN_KCOV_BROKEN
-	def_bool KCOV && CC_HAS_SANCOV_TRACE_PC
-	depends on CC_IS_CLANG
-	depends on !$(cc-option,-Werror=unused-command-line-argument -fsanitize=thread -fsanitize-coverage=trace-pc)
-	help
-	  Some versions of clang support either KCSAN and KCOV but not the
-	  combination of the two.
-	  See https://bugs.llvm.org/show_bug.cgi?id=45831 for the status
-	  in newer releases.
-
 menuconfig KCSAN
 	bool "KCSAN: dynamic data race detector"
 	depends on HAVE_ARCH_KCSAN && HAVE_KCSAN_COMPILER
 	depends on DEBUG_KERNEL && !KASAN
-	depends on !KCSAN_KCOV_BROKEN
 	select STACKTRACE
 	help
 	  The Kernel Concurrency Sanitizer (KCSAN) is a dynamic
--- a/lib/Kconfig.ubsan~revert-ubsan-kcsan-dont-combine-sanitizer-with-kcov-on-clang
+++ a/lib/Kconfig.ubsan
@@ -27,16 +27,6 @@ config UBSAN_TRAP
 	  the system. For some system builders this is an acceptable
 	  trade-off.
 
-config UBSAN_KCOV_BROKEN
-	def_bool KCOV && CC_HAS_SANCOV_TRACE_PC
-	depends on CC_IS_CLANG
-	depends on !$(cc-option,-Werror=unused-command-line-argument -fsanitize=bounds -fsanitize-coverage=trace-pc)
-	help
-	  Some versions of clang support either UBSAN or KCOV but not the
-	  combination of the two.
-	  See https://bugs.llvm.org/show_bug.cgi?id=45831 for the status
-	  in newer releases.
-
 config CC_HAS_UBSAN_BOUNDS
 	def_bool $(cc-option,-fsanitize=bounds)
 
@@ -46,7 +36,6 @@ config CC_HAS_UBSAN_ARRAY_BOUNDS
 config UBSAN_BOUNDS
 	bool "Perform array index bounds checking"
 	default UBSAN
-	depends on !UBSAN_KCOV_BROKEN
 	depends on CC_HAS_UBSAN_ARRAY_BOUNDS || CC_HAS_UBSAN_BOUNDS
 	help
 	  This option enables detection of directly indexed out of bounds
@@ -72,7 +61,6 @@ config UBSAN_ARRAY_BOUNDS
 config UBSAN_LOCAL_BOUNDS
 	bool "Perform array local bounds checking"
 	depends on UBSAN_TRAP
-	depends on !UBSAN_KCOV_BROKEN
 	depends on $(cc-option,-fsanitize=local-bounds)
 	help
 	  This option enables -fsanitize=local-bounds which traps when an
_
