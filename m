Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4498174EE
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF40C433C8;
	Wed,  9 Aug 2023 10:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578315;
	bh=i+Wyuf2ihGUIbQ+jf9qHIatb0ECYuRajE/rWuuGKUxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cc4lvjDOtE7FuaQWQqhn4BIVSCpiWXk3VjhtFKe6jNm3g0KWYath6LAlvtkGdLSIb
	 Z9RtBaMfFHNs0t99K6CjONzTMfP/bptmL4owXH+SuSPm0JJp/Ea5EqK/XP8Ns3RlgX
	 aP+g2W1trnHQDMKNPHYDa7V/PbEu2yA6peTTIERo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Yury Norov <yury.norov@gmail.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/127] lib/bitmap: workaround const_eval test build failure
Date: Wed,  9 Aug 2023 12:40:03 +0200
Message-ID: <20230809103637.180809899@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yury Norov <yury.norov@gmail.com>

[ Upstream commit 2356d198d2b4ddec24efea98271cb3be230bc787 ]

When building with Clang, and when KASAN and GCOV_PROFILE_ALL are both
enabled, the test fails to build [1]:

>> lib/test_bitmap.c:920:2: error: call to '__compiletime_assert_239' declared with 'error' attribute: BUILD_BUG_ON failed: !__builtin_constant_p(res)
           BUILD_BUG_ON(!__builtin_constant_p(res));
           ^
   include/linux/build_bug.h:50:2: note: expanded from macro 'BUILD_BUG_ON'
           BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
           ^
   include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
   #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                       ^
   include/linux/compiler_types.h:352:2: note: expanded from macro 'compiletime_assert'
           _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
           ^
   include/linux/compiler_types.h:340:2: note: expanded from macro '_compiletime_assert'
           __compiletime_assert(condition, msg, prefix, suffix)
           ^
   include/linux/compiler_types.h:333:4: note: expanded from macro '__compiletime_assert'
                           prefix ## suffix();                             \
                           ^
   <scratch space>:185:1: note: expanded from here
   __compiletime_assert_239

Originally it was attributed to s390, which now looks seemingly wrong. The
issue is not related to bitmap code itself, but it breaks build for a given
configuration.

Disabling the const_eval test under that config may potentially hide other
bugs. Instead, workaround it by disabling GCOV for the test_bitmap unless
the compiler will get fixed.

[1] https://github.com/ClangBuiltLinux/linux/issues/1874

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202307171254.yFcH97ej-lkp@intel.com/
Fixes: dc34d5036692 ("lib: test_bitmap: add compile-time optimization/evaluations assertions")
Co-developed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Makefile      | 6 ++++++
 lib/test_bitmap.c | 8 ++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/lib/Makefile b/lib/Makefile
index 59bd7c2f793a7..5ffe72ec99797 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -81,8 +81,14 @@ obj-$(CONFIG_TEST_STATIC_KEYS) += test_static_key_base.o
 obj-$(CONFIG_TEST_DYNAMIC_DEBUG) += test_dynamic_debug.o
 obj-$(CONFIG_TEST_PRINTF) += test_printf.o
 obj-$(CONFIG_TEST_SCANF) += test_scanf.o
+
 obj-$(CONFIG_TEST_BITMAP) += test_bitmap.o
 obj-$(CONFIG_TEST_STRSCPY) += test_strscpy.o
+ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_KASAN),yy)
+# FIXME: Clang breaks test_bitmap_const_eval when KASAN and GCOV are enabled
+GCOV_PROFILE_test_bitmap.o := n
+endif
+
 obj-$(CONFIG_TEST_UUID) += test_uuid.o
 obj-$(CONFIG_TEST_XARRAY) += test_xarray.o
 obj-$(CONFIG_TEST_MAPLE_TREE) += test_maple_tree.o
diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index a8005ad3bd589..37a9108c4f588 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -1149,6 +1149,10 @@ static void __init test_bitmap_print_buf(void)
 	}
 }
 
+/*
+ * FIXME: Clang breaks compile-time evaluations when KASAN and GCOV are enabled.
+ * To workaround it, GCOV is force-disabled in Makefile for this configuration.
+ */
 static void __init test_bitmap_const_eval(void)
 {
 	DECLARE_BITMAP(bitmap, BITS_PER_LONG);
@@ -1174,11 +1178,7 @@ static void __init test_bitmap_const_eval(void)
 	 * the compiler is fixed.
 	 */
 	bitmap_clear(bitmap, 0, BITS_PER_LONG);
-#if defined(__s390__) && defined(__clang__)
-	if (!const_test_bit(7, bitmap))
-#else
 	if (!test_bit(7, bitmap))
-#endif
 		bitmap_set(bitmap, 5, 2);
 
 	/* Equals to `unsigned long bitopvar = BIT(20)` */
-- 
2.40.1



