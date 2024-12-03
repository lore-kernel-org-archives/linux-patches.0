Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26CB1F707A;
	Tue,  3 Dec 2024 15:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239556; cv=none; b=eKGc9pwCj0kplQsgLj3m54wkYTVMtaoVivfodeJKml0ntmTUj45IZ5wo9S3spugZ/ECZGnxJwKx8keFM6u5SI9YqSr4am8/sN2UEl4sPnyMz0q3aTXmsfbJ5OaGA33MggHkbSmuEMrmy8vHqJ3Fhz5vYkA49AEdqmreKgN+1D20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239556; c=relaxed/simple;
	bh=qkhcrmAThqZWdjGO3H8P+eEKz2DWOQ83MuEfBHHlPrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMte7ktjsbvZ1js6wU1UHMVckeVaJSnmlRNT0eFpTMMJUQ5Nkg8FThYyNyorTlOjGkJMqJVsOhSXNFT3j+tbJTOnCglnS41TTppJKL8fjOUXnRP1C+xSBzk9rAXjX90DoE+64cUZaurRYRycC9/H03L7GOKK3WzMDWDGph/AHyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yITqVQEA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yITqVQEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B205C4CECF;
	Tue,  3 Dec 2024 15:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239556;
	bh=qkhcrmAThqZWdjGO3H8P+eEKz2DWOQ83MuEfBHHlPrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yITqVQEAwKYpb/YafRUXHcawPAdkYGAetW7zkegLHaZihA7Kyw4V9ja0nBsywICY1
	 Vd3VziW3ZpYQ54u1AzyXF8sEyGwayjJ819jr38kB52OC1ebZcbRzq/9CO55nU0g2GI
	 Y28Henv6Han/EbDuPRPgyZFzwQPui/qH+4CRQZzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	kernel test robot <oliver.sang@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Miguel Ojeda <ojeda@kernel.org>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.11 655/817] Compiler Attributes: disable __counted_by for clang < 19.1.3
Date: Tue,  3 Dec 2024 15:43:47 +0100
Message-ID: <20241203144021.524736490@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Hendrik Farr <kernel@jfarr.cc>

commit f06e108a3dc53c0f5234d18de0bd224753db5019 upstream.

This patch disables __counted_by for clang versions < 19.1.3 because
of the two issues listed below. It does this by introducing
CONFIG_CC_HAS_COUNTED_BY.

1. clang < 19.1.2 has a bug that can lead to __bdos returning 0:
https://github.com/llvm/llvm-project/pull/110497

2. clang < 19.1.3 has a bug that can lead to __bdos being off by 4:
https://github.com/llvm/llvm-project/pull/112636

Fixes: c8248faf3ca2 ("Compiler Attributes: counted_by: Adjust name and identifier expansion")
Cc: stable@vger.kernel.org # 6.6.x: 16c31dd7fdf6: Compiler Attributes: counted_by: bump min gcc version
Cc: stable@vger.kernel.org # 6.6.x: 2993eb7a8d34: Compiler Attributes: counted_by: fixup clang URL
Cc: stable@vger.kernel.org # 6.6.x: 231dc3f0c936: lkdtm/bugs: Improve warning message for compilers without counted_by support
Cc: stable@vger.kernel.org # 6.6.x
Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/all/20240913164630.GA4091534@thelio-3990X/
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202409260949.a1254989-oliver.sang@intel.com
Link: https://lore.kernel.org/all/Zw8iawAF5W2uzGuh@archlinux/T/#m204c09f63c076586a02d194b87dffc7e81b8de7b
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Jan Hendrik Farr <kernel@jfarr.cc>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://lore.kernel.org/r/20241029140036.577804-2-kernel@jfarr.cc
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/lkdtm/bugs.c           |    2 +-
 include/linux/compiler_attributes.h |   13 -------------
 include/linux/compiler_types.h      |   19 +++++++++++++++++++
 init/Kconfig                        |    9 +++++++++
 lib/overflow_kunit.c                |    2 +-
 5 files changed, 30 insertions(+), 15 deletions(-)

--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -445,7 +445,7 @@ static void lkdtm_FAM_BOUNDS(void)
 
 	pr_err("FAIL: survived access of invalid flexible array member index!\n");
 
-	if (!__has_attribute(__counted_by__))
+	if (!IS_ENABLED(CONFIG_CC_HAS_COUNTED_BY))
 		pr_warn("This is expected since this %s was built with a compiler that does not support __counted_by\n",
 			lkdtm_kernel_info);
 	else if (IS_ENABLED(CONFIG_UBSAN_BOUNDS))
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -95,19 +95,6 @@
 #endif
 
 /*
- * Optional: only supported since gcc >= 15
- * Optional: only supported since clang >= 18
- *
- *   gcc: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108896
- * clang: https://github.com/llvm/llvm-project/pull/76348
- */
-#if __has_attribute(__counted_by__)
-# define __counted_by(member)		__attribute__((__counted_by__(member)))
-#else
-# define __counted_by(member)
-#endif
-
-/*
  * Optional: not supported by gcc
  * Optional: only supported since clang >= 14.0
  *
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -324,6 +324,25 @@ struct ftrace_likely_data {
 #endif
 
 /*
+ * Optional: only supported since gcc >= 15
+ * Optional: only supported since clang >= 18
+ *
+ *   gcc: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108896
+ * clang: https://github.com/llvm/llvm-project/pull/76348
+ *
+ * __bdos on clang < 19.1.2 can erroneously return 0:
+ * https://github.com/llvm/llvm-project/pull/110497
+ *
+ * __bdos on clang < 19.1.3 can be off by 4:
+ * https://github.com/llvm/llvm-project/pull/112636
+ */
+#ifdef CONFIG_CC_HAS_COUNTED_BY
+# define __counted_by(member)		__attribute__((__counted_by__(member)))
+#else
+# define __counted_by(member)
+#endif
+
+/*
  * Apply __counted_by() when the Endianness matches to increase test coverage.
  */
 #ifdef __LITTLE_ENDIAN
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -109,6 +109,15 @@ config CC_HAS_ASM_INLINE
 config CC_HAS_NO_PROFILE_FN_ATTR
 	def_bool $(success,echo '__attribute__((no_profile_instrument_function)) int x();' | $(CC) -x c - -c -o /dev/null -Werror)
 
+config CC_HAS_COUNTED_BY
+	# TODO: when gcc 15 is released remove the build test and add
+	# a gcc version check
+	def_bool $(success,echo 'struct flex { int count; int array[] __attribute__((__counted_by__(count))); };' | $(CC) $(CLANG_FLAGS) -x c - -c -o /dev/null -Werror)
+	# clang needs to be at least 19.1.3 to avoid __bdos miscalculations
+	# https://github.com/llvm/llvm-project/pull/110497
+	# https://github.com/llvm/llvm-project/pull/112636
+	depends on !(CC_IS_CLANG && CLANG_VERSION < 190103)
+
 config PAHOLE_VERSION
 	int
 	default $(shell,$(srctree)/scripts/pahole-version.sh $(PAHOLE))
--- a/lib/overflow_kunit.c
+++ b/lib/overflow_kunit.c
@@ -1187,7 +1187,7 @@ static void DEFINE_FLEX_test(struct kuni
 {
 	/* Using _RAW_ on a __counted_by struct will initialize "counter" to zero */
 	DEFINE_RAW_FLEX(struct foo, two_but_zero, array, 2);
-#if __has_attribute(__counted_by__)
+#ifdef CONFIG_CC_HAS_COUNTED_BY
 	int expected_raw_size = sizeof(struct foo);
 #else
 	int expected_raw_size = sizeof(struct foo) + 2 * sizeof(s16);


