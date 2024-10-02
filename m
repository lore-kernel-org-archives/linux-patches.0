Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826BC16F84F;
	Wed,  2 Oct 2024 13:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875646; cv=none; b=tRBmF5U7iRzaB0q02aeEQQlhKVu9jpQNmPAaIqMnrGBbUdFCOmE5JajlPC7Ga38Ljx9yO05itMpRJqQeB+98/GIyVP7FavMGjqrwTBGvJpIAHHNnUrfdL4tKWPXugSppOSahqHIB+/LigWsh2Z1uWS85qaq2HDHGOWlMMUV2UcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875646; c=relaxed/simple;
	bh=hWJMOdBvjfu6KyizDCprh4deoo/X6oPvDt5sAWrG8SY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D4BGf97Jz6VBW3+ZZ3DM2TKCiXjBn9BLiseiZg5nXtqfNnIL1E+BZfiAQIAcy6SOqXv/hWgI6+EYqX9OK0FGC/30GHRMm39gIbJqs+TUFwJa2RTzXbP3wxKYGPxmvNijIxCPnyK8iPFKNVQU264IcQvxJRmqkDEOt5sT19Hi2yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5Ws3caX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5Ws3caX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53E0C4CEC5;
	Wed,  2 Oct 2024 13:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875646;
	bh=hWJMOdBvjfu6KyizDCprh4deoo/X6oPvDt5sAWrG8SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5Ws3caXMJNUz8ENbqtJ77HEOod9effVfvqN3kNuHMYyvdPCxpew5mOJl7JoZ3HZk
	 lOdtiykMbTesZH+fkWpkyK73Cx/Tm+TrH5AwqqTGQ6pYgwcgJPUAMuy05iriKUQfTL
	 4HhGzrDGj0eBXoH1Cub+GrJ3p0ZJKHYA/ctAS8Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 172/695] selftests:resctrl: Fix build failure on archs without __cpuid_count()
Date: Wed,  2 Oct 2024 14:52:50 +0200
Message-ID: <20241002125829.338091490@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit 7beaf1da074f7ea25454d6c11da142c3892d3c4e ]

When resctrl is built on architectures without __cpuid_count()
support, build fails. resctrl uses __cpuid_count() defined in
kselftest.h.

Even though the problem is seen while building resctrl on aarch64,
this error can be seen on any platform that doesn't support CPUID.

CPUID is a x86/x86-64 feature and code paths with CPUID asm commands
will fail to build on all other architectures.

All others tests call __cpuid_count() do so from x86/x86_64 code paths
when _i386__ or __x86_64__ are defined. resctrl is an exception.

Fix the problem by defining __cpuid_count() only when __i386__ or
__x86_64__ are defined in kselftest.h and changing resctrl to call
__cpuid_count() only when __i386__ or __x86_64__ are defined.

In file included from resctrl.h:24,
                 from cat_test.c:11:
In function ‘arch_supports_noncont_cat’,
    inlined from ‘noncont_cat_run_test’ at cat_test.c:326:6:
../kselftest.h:74:9: error: impossible constraint in ‘asm’
   74 |         __asm__ __volatile__ ("cpuid\n\t"                               \
      |         ^~~~~~~
cat_test.c:304:17: note: in expansion of macro ‘__cpuid_count’
  304 |                 __cpuid_count(0x10, 1, eax, ebx, ecx, edx);
      |                 ^~~~~~~~~~~~~
../kselftest.h:74:9: error: impossible constraint in ‘asm’
   74 |         __asm__ __volatile__ ("cpuid\n\t"                               \
      |         ^~~~~~~
cat_test.c:306:17: note: in expansion of macro ‘__cpuid_count’
  306 |                 __cpuid_count(0x10, 2, eax, ebx, ecx, edx);

Fixes: ae638551ab64 ("selftests/resctrl: Add non-contiguous CBMs CAT test")
Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Closes: https://lore.kernel.org/lkml/20240809071059.265914-1-usama.anjum@collabora.com/
Reported-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest.h        | 2 ++
 tools/testing/selftests/resctrl/cat_test.c | 7 +++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
index b8967b6e29d50..e195ec1568599 100644
--- a/tools/testing/selftests/kselftest.h
+++ b/tools/testing/selftests/kselftest.h
@@ -61,6 +61,7 @@
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
 #endif
 
+#if defined(__i386__) || defined(__x86_64__) /* arch */
 /*
  * gcc cpuid.h provides __cpuid_count() since v4.4.
  * Clang/LLVM cpuid.h provides  __cpuid_count() since v3.4.0.
@@ -75,6 +76,7 @@
 			      : "=a" (a), "=b" (b), "=c" (c), "=d" (d)	\
 			      : "0" (level), "2" (count))
 #endif
+#endif /* end arch */
 
 /* define kselftest exit codes */
 #define KSFT_PASS  0
diff --git a/tools/testing/selftests/resctrl/cat_test.c b/tools/testing/selftests/resctrl/cat_test.c
index 742782438ca3b..94cfdba5308d8 100644
--- a/tools/testing/selftests/resctrl/cat_test.c
+++ b/tools/testing/selftests/resctrl/cat_test.c
@@ -290,12 +290,12 @@ static int cat_run_test(const struct resctrl_test *test, const struct user_param
 
 static bool arch_supports_noncont_cat(const struct resctrl_test *test)
 {
-	unsigned int eax, ebx, ecx, edx;
-
 	/* AMD always supports non-contiguous CBM. */
 	if (get_vendor() == ARCH_AMD)
 		return true;
 
+#if defined(__i386__) || defined(__x86_64__) /* arch */
+	unsigned int eax, ebx, ecx, edx;
 	/* Intel support for non-contiguous CBM needs to be discovered. */
 	if (!strcmp(test->resource, "L3"))
 		__cpuid_count(0x10, 1, eax, ebx, ecx, edx);
@@ -305,6 +305,9 @@ static bool arch_supports_noncont_cat(const struct resctrl_test *test)
 		return false;
 
 	return ((ecx >> 3) & 1);
+#endif /* end arch */
+
+	return false;
 }
 
 static int noncont_cat_run_test(const struct resctrl_test *test,
-- 
2.43.0



