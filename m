Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3A53ED3A4;
	Wed, 20 May 2026 17:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297842; cv=none; b=bt2ck8NT9AaoOUzgyYNPQj8Shnezgi9CEp4cGWHvELkd5+CHHD6uDiBc9LPKisDJtyzdZHfGvO65v8t4uneudqbT2qfWEE1+mVmwGC/KurEtOLZdbz5g4CyxjruX7YzoLsbXq7qLr1m65nYqPUVXpgXiv5mnIyGWX5v0RzQ0SGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297842; c=relaxed/simple;
	bh=4xOc1Y0U3izuAyhaWiqgm7PgW72YN+XjTiW3Ael1Ubc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nX5HZ2//s74hyu55/UrVlhR+CHujt1H7xGTv7XN5G2vswX1JckgphZRAuTh0hjs5jxNOFOY2R9JisvZmaroU8aNut3G7eqnvBblxpSxkyzyHOL9JBkE2fDfm4Grg4G593aXeJjSTcgVbUn7yNEg+UvsYYHHZNJhgUYNCFCKacXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=orc/DIQP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="orc/DIQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37A81F000E9;
	Wed, 20 May 2026 17:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297841;
	bh=W/WsDnn82L/jJ6Hw0lqCBQq3/aLm4SZdcQt0lr0Izl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=orc/DIQPR0A/JIXHm0wXuzvp9U13k4NmsEU5ydvfUAKJpHJQrYl9MRUjzNG+xX8zj
	 alP/H1T3iKB0B+7hyUfc6zSL8s05z7M7Ka9ZuBFkEimnQbjJOJ6i7VWXE+YuJP1SZq
	 HJHmHDMms6WDkvZL3JDeVseCMT/9NZVVwGHaHEZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 185/957] selftests/futex: Fix incorrect result reporting of futex_requeue test item
Date: Wed, 20 May 2026 18:11:08 +0200
Message-ID: <20260520162138.564458204@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuwen Chen <ywen.chen@foxmail.com>

[ Upstream commit d317e2ef9dcf673c9f37cda784284af7c6812757 ]

When using the TEST_HARNESS_MAIN macro definition to declare the main
function, it is required to use the EXPECT*() and ASSERT*() macros in
conjunction and not ksft_test_result_*(). Otherwise, even if a test item
fails, the test will still return a success result because
ksft_test_result_*() does not affect the test harness state.

Convert the code to use EXPECT/ASSERT() variants, which ensures that the
overall test result is fail if one of the EXPECT()s fails.

[ tglx: Massaged change log to explain _why_ ksft_test_result*() is the wrong
  	choice ]

Fixes: f341a20f6d7e ("selftests/futex: Refactor futex_requeue with kselftest_harness.h")
Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/tencent_51851B741CC4B5EC9C22AFF70BA82BB60805@qq.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../futex/functional/futex_requeue.c          | 49 +++----------------
 1 file changed, 8 insertions(+), 41 deletions(-)

diff --git a/tools/testing/selftests/futex/functional/futex_requeue.c b/tools/testing/selftests/futex/functional/futex_requeue.c
index 69e2555b60399..d6be3fbd436a4 100644
--- a/tools/testing/selftests/futex/functional/futex_requeue.c
+++ b/tools/testing/selftests/futex/functional/futex_requeue.c
@@ -34,34 +34,18 @@ TEST(requeue_single)
 	volatile futex_t _f1 = 0;
 	volatile futex_t f2 = 0;
 	pthread_t waiter[10];
-	int res;
 
 	f1 = &_f1;
 
 	/*
 	 * Requeue a waiter from f1 to f2, and wake f2.
 	 */
-	if (pthread_create(&waiter[0], NULL, waiterfn, NULL))
-		ksft_exit_fail_msg("pthread_create failed\n");
+	ASSERT_EQ(0, pthread_create(&waiter[0], NULL, waiterfn, NULL));
 
 	usleep(WAKE_WAIT_US);
 
-	ksft_print_dbg_msg("Requeuing 1 futex from f1 to f2\n");
-	res = futex_cmp_requeue(f1, 0, &f2, 0, 1, 0);
-	if (res != 1)
-		ksft_test_result_fail("futex_requeue simple returned: %d %s\n",
-				      res ? errno : res,
-				      res ? strerror(errno) : "");
-
-	ksft_print_dbg_msg("Waking 1 futex at f2\n");
-	res = futex_wake(&f2, 1, 0);
-	if (res != 1) {
-		ksft_test_result_fail("futex_requeue simple returned: %d %s\n",
-				      res ? errno : res,
-				      res ? strerror(errno) : "");
-	} else {
-		ksft_test_result_pass("futex_requeue simple succeeds\n");
-	}
+	EXPECT_EQ(1, futex_cmp_requeue(f1, 0, &f2, 0, 1, 0));
+	EXPECT_EQ(1, futex_wake(&f2, 1, 0));
 }
 
 TEST(requeue_multiple)
@@ -69,7 +53,7 @@ TEST(requeue_multiple)
 	volatile futex_t _f1 = 0;
 	volatile futex_t f2 = 0;
 	pthread_t waiter[10];
-	int res, i;
+	int i;
 
 	f1 = &_f1;
 
@@ -77,30 +61,13 @@ TEST(requeue_multiple)
 	 * Create 10 waiters at f1. At futex_requeue, wake 3 and requeue 7.
 	 * At futex_wake, wake INT_MAX (should be exactly 7).
 	 */
-	for (i = 0; i < 10; i++) {
-		if (pthread_create(&waiter[i], NULL, waiterfn, NULL))
-			ksft_exit_fail_msg("pthread_create failed\n");
-	}
+	for (i = 0; i < 10; i++)
+		ASSERT_EQ(0, pthread_create(&waiter[i], NULL, waiterfn, NULL));
 
 	usleep(WAKE_WAIT_US);
 
-	ksft_print_dbg_msg("Waking 3 futexes at f1 and requeuing 7 futexes from f1 to f2\n");
-	res = futex_cmp_requeue(f1, 0, &f2, 3, 7, 0);
-	if (res != 10) {
-		ksft_test_result_fail("futex_requeue many returned: %d %s\n",
-				      res ? errno : res,
-				      res ? strerror(errno) : "");
-	}
-
-	ksft_print_dbg_msg("Waking INT_MAX futexes at f2\n");
-	res = futex_wake(&f2, INT_MAX, 0);
-	if (res != 7) {
-		ksft_test_result_fail("futex_requeue many returned: %d %s\n",
-				      res ? errno : res,
-				      res ? strerror(errno) : "");
-	} else {
-		ksft_test_result_pass("futex_requeue many succeeds\n");
-	}
+	EXPECT_EQ(10, futex_cmp_requeue(f1, 0, &f2, 3, 7, 0));
+	EXPECT_EQ(7, futex_wake(&f2, INT_MAX, 0));
 }
 
 TEST_HARNESS_MAIN
-- 
2.53.0



