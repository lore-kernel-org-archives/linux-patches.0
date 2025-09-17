Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C7E30596F;
	Wed, 17 Sep 2025 12:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112711; cv=none; b=uUWvK+s7uPuhES0JJcN8BKDTHx/iW/dx8NnWVJlr8OJ5nCShhnF/WJ6sNak/HT3cZ5Fz966l67XrgpLnMYpzVjxtreW2YTTy68CV3trlSR1baB33Ixhvlqrx11GKSlpcZhuCS8/4Pyxrb3uxUGTusSh1LcCvShzLIGEftW/QpWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112711; c=relaxed/simple;
	bh=77Jmj5bSS6wbn8MXN48NY3DDJIucqD27vIBnDqWYgBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0ojdl4teuPnZdNfWmUdwk73C5uYUxsXRQotrZqm33FbGwiVbVvDWYLm/7HKEZ3yOUvHFx2byj3acLEu3XpIBsFJ+AVHK8ys7EwcyOMU1gmYBCZVdH937kQ+sacVJC1uVQ0PPQ2xQK38aXFf0GnnNXWvc3lu0Oel6PsvP3oYMTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k46Zmwxe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k46Zmwxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A78C4CEF0;
	Wed, 17 Sep 2025 12:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112709;
	bh=77Jmj5bSS6wbn8MXN48NY3DDJIucqD27vIBnDqWYgBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k46ZmwxeSxV1eWVOMQISw7+Gm+A74AYfq3/D9lYb+seG0si7Ljy4YOZ91c/kH+/di
	 2wj+K15u1LEjB2pamFVzkLxw8vOGQlfxWgz2ppcXLSCRk6Sap8rN9mrRdh7S/JwHiD
	 8Yc0/ZmFGwJKtTuuEqI2Xd77VY+Awan7kW4JqEwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Justin Stitt <justinstitt@google.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Dmitriy Vyukov <dvyukov@google.com>,
	Marco Elver <elver@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 051/189] compiler-clang.h: define __SANITIZE_*__ macros only when undefined
Date: Wed, 17 Sep 2025 14:32:41 +0200
Message-ID: <20250917123353.112137120@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 3fac212fe489aa0dbe8d80a42a7809840ca7b0f9 upstream.

Clang 22 recently added support for defining __SANITIZE__ macros similar
to GCC [1], which causes warnings (or errors with CONFIG_WERROR=y or W=e)
with the existing defines that the kernel creates to emulate this behavior
with existing clang versions.

  In file included from <built-in>:3:
  In file included from include/linux/compiler_types.h:171:
  include/linux/compiler-clang.h:37:9: error: '__SANITIZE_THREAD__' macro redefined [-Werror,-Wmacro-redefined]
     37 | #define __SANITIZE_THREAD__
        |         ^
  <built-in>:352:9: note: previous definition is here
    352 | #define __SANITIZE_THREAD__ 1
        |         ^

Refactor compiler-clang.h to only define the sanitizer macros when they
are undefined and adjust the rest of the code to use these macros for
checking if the sanitizers are enabled, clearing up the warnings and
allowing the kernel to easily drop these defines when the minimum
supported version of LLVM for building the kernel becomes 22.0.0 or newer.

Link: https://lkml.kernel.org/r/20250902-clang-update-sanitize-defines-v1-1-cf3702ca3d92@kernel.org
Link: https://github.com/llvm/llvm-project/commit/568c23bbd3303518c5056d7f03444dae4fdc8a9c [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compiler-clang.h |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

--- a/include/linux/compiler-clang.h
+++ b/include/linux/compiler-clang.h
@@ -18,23 +18,42 @@
 #define KASAN_ABI_VERSION 5
 
 /*
+ * Clang 22 added preprocessor macros to match GCC, in hopes of eventually
+ * dropping __has_feature support for sanitizers:
+ * https://github.com/llvm/llvm-project/commit/568c23bbd3303518c5056d7f03444dae4fdc8a9c
+ * Create these macros for older versions of clang so that it is easy to clean
+ * up once the minimum supported version of LLVM for building the kernel always
+ * creates these macros.
+ *
  * Note: Checking __has_feature(*_sanitizer) is only true if the feature is
  * enabled. Therefore it is not required to additionally check defined(CONFIG_*)
  * to avoid adding redundant attributes in other configurations.
  */
+#if __has_feature(address_sanitizer) && !defined(__SANITIZE_ADDRESS__)
+#define __SANITIZE_ADDRESS__
+#endif
+#if __has_feature(hwaddress_sanitizer) && !defined(__SANITIZE_HWADDRESS__)
+#define __SANITIZE_HWADDRESS__
+#endif
+#if __has_feature(thread_sanitizer) && !defined(__SANITIZE_THREAD__)
+#define __SANITIZE_THREAD__
+#endif
 
-#if __has_feature(address_sanitizer) || __has_feature(hwaddress_sanitizer)
-/* Emulate GCC's __SANITIZE_ADDRESS__ flag */
+/*
+ * Treat __SANITIZE_HWADDRESS__ the same as __SANITIZE_ADDRESS__ in the kernel.
+ */
+#ifdef __SANITIZE_HWADDRESS__
 #define __SANITIZE_ADDRESS__
+#endif
+
+#ifdef __SANITIZE_ADDRESS__
 #define __no_sanitize_address \
 		__attribute__((no_sanitize("address", "hwaddress")))
 #else
 #define __no_sanitize_address
 #endif
 
-#if __has_feature(thread_sanitizer)
-/* emulate gcc's __SANITIZE_THREAD__ flag */
-#define __SANITIZE_THREAD__
+#ifdef __SANITIZE_THREAD__
 #define __no_sanitize_thread \
 		__attribute__((no_sanitize("thread")))
 #else


