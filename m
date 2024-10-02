Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA7E1D0DDC;
	Wed,  2 Oct 2024 14:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877675; cv=none; b=QiyLjgXsx84fWq6B2Cmg7Gxvw0hZnyuBNsNrCplB1yD5o3BVc65VRTXISZY0iGuuUmHAtdU6X9rYkp9BqzOkQ6+nbsuD3ycTyTyMb+Q2zAt1ndBs4xpa7wLdu/+Uk4ye5AlMY1JBTguQUIn5+Objxw55eAs+M9yr2iVOLbCM2Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877675; c=relaxed/simple;
	bh=RNwCRKWHHxp/zBQWYjywVkB678AEckT+jryiY2kaLrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uHcos4GaQ0o3R6qJhq0x2RusOAAdVw5ZA3nsk0w8L7uML10AkLhBTDaJ3kYmtZtp9VuhTehETufLX9EIeC7J4POgPUYoRKB41US+TqWnJDKKeHn+FenrpBmtLyB91S2x2/movlwN2bkVDDcgk/gsr8PGratS+R2F4mp3pzm/IjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uR+g9oFh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uR+g9oFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E6BC4CECD;
	Wed,  2 Oct 2024 14:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877674;
	bh=RNwCRKWHHxp/zBQWYjywVkB678AEckT+jryiY2kaLrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uR+g9oFhy/gJyFZ8WTpfqg/0qCGTeLZZIyyDFx42/zTnZ1fWdPdgIkkqxiQzgx42i
	 uASGErs7Qfjrd7EAGuMWyxbxmU6k5ahR4/T1dNMzVTEapMf9oULQiH2/VyTlb3cWwl
	 +9HOH5P+DDY1y5vnI+a8gNn9xErbV/zOSGmmIZBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 155/634] selftests:resctrl: Fix build failure on archs without __cpuid_count()
Date: Wed,  2 Oct 2024 14:54:15 +0200
Message-ID: <20241002125817.229338177@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 76c2a6945d3e8..f9214e7cdd134 100644
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
index 55315ed695f47..18565f02163e7 100644
--- a/tools/testing/selftests/resctrl/cat_test.c
+++ b/tools/testing/selftests/resctrl/cat_test.c
@@ -293,12 +293,12 @@ static int cat_run_test(const struct resctrl_test *test, const struct user_param
 
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
@@ -308,6 +308,9 @@ static bool arch_supports_noncont_cat(const struct resctrl_test *test)
 		return false;
 
 	return ((ecx >> 3) & 1);
+#endif /* end arch */
+
+	return false;
 }
 
 static int noncont_cat_run_test(const struct resctrl_test *test,
-- 
2.43.0



