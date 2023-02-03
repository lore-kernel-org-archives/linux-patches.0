Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CDA1FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1F5C4339B;
	Fri,  3 Feb 2023 10:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419864;
	bh=QVWL9Ryh5/fAmRZzxLER3tGYMSZKgPr7dmH+SGZuT/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=druKFEM50F9US6up1HpBTFmGT9Ag2BPa+uMZ7MDlL9FWlzafv/WRonJV0khp/mVKc
	 1HmO8l2nN8tUDjmRHNMCaaAHNINPWf6LIqr1rTxubq3P6N0gei65uEnNS4L/cCoN8N
	 WFblvk4QCHqWLVY4CM5n3y7tVNanUH4faYlwMdA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kyle Huey <me@kylehuey.com>
Subject: [PATCH 5.15 16/20] tools: fix ARRAY_SIZE defines in tools and selftests hdrs
Date: Fri,  3 Feb 2023 11:13:43 +0100
Message-Id: <20230203101008.677359238@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101007.985835823@linuxfoundation.org>
References: <20230203101007.985835823@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shuah Khan <skhan@linuxfoundation.org>

commit 066b34aa5461f6072dbbecb690f4fe446b736ebf upstream.

tools/include/linux/kernel.h and kselftest_harness.h are missing
ifndef guard around ARRAY_SIZE define. Fix them to avoid duplicate
define errors during compile when another file defines it. This
problem was found when compiling selftests that include a header
with ARRAY_SIZE define.

ARRAY_SIZE is defined in several selftests. There are about 25+
duplicate defines in various selftests source and header files.
Add ARRAY_SIZE to kselftest.h in preparation for removing duplicate
ARRAY_SIZE defines from individual test files.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Kyle Huey <me@kylehuey.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/linux/kernel.h                |    2 ++
 tools/testing/selftests/kselftest.h         |    4 ++++
 tools/testing/selftests/kselftest_harness.h |    2 ++
 3 files changed, 8 insertions(+)

--- a/tools/include/linux/kernel.h
+++ b/tools/include/linux/kernel.h
@@ -108,7 +108,9 @@ int vscnprintf(char *buf, size_t size, c
 int scnprintf(char * buf, size_t size, const char * fmt, ...);
 int scnprintf_pad(char * buf, size_t size, const char * fmt, ...);
 
+#ifndef ARRAY_SIZE
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+#endif
 
 /*
  * This looks more complex than it should be. But we need to
--- a/tools/testing/selftests/kselftest.h
+++ b/tools/testing/selftests/kselftest.h
@@ -48,6 +48,10 @@
 #include <stdarg.h>
 #include <stdio.h>
 
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+#endif
+
 /* define kselftest exit codes */
 #define KSFT_PASS  0
 #define KSFT_FAIL  1
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -671,7 +671,9 @@
 #define EXPECT_STRNE(expected, seen) \
 	__EXPECT_STR(expected, seen, !=, 0)
 
+#ifndef ARRAY_SIZE
 #define ARRAY_SIZE(a)	(sizeof(a) / sizeof(a[0]))
+#endif
 
 /* Support an optional handler after and ASSERT_* or EXPECT_*.  The approach is
  * not thread-safe, but it should be fine in most sane test scenarios.


