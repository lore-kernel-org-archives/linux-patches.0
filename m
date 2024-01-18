Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8C51B96D;
	Thu, 18 Jan 2024 10:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575146; cv=none; b=DdCO2wagqBVWOb/NMlaS7O+fxNCq4KpBDL850VcNp2Zmz6HVxYtzI93fQ3Ngp0P6HviHCKvTDfjV5plE7KhuV+3esIayVu9/fsOQnMfggHOgvqEGh4Tq0/d4vxUfBulhsa1Ibe3SgoR6XP/BYelSXY0ppfYBf/t7XTQWrTKXzfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575146; c=relaxed/simple;
	bh=dhNqs2r1bX9x1qvjq7RLWnG2LZmh17+Ze1Tz0gEn2jI=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=nBoK+ZnYdbC9qodtH5lE5f1sC9Js8tTtXDoGT6AcDfQcug78hwwcKLs802nF3IN1XlHAwVf4fOLdBUASsndLlzEnsDueyp5ePWuG5eiGRGZ/N9EyCUXWNAGd3LBEcWpfuuF3wwx4FS5j4qL1hk1LVuqwQUVVImjd64EhgIqrIVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcngbZ77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcngbZ77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EF0C433C7;
	Thu, 18 Jan 2024 10:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575145;
	bh=dhNqs2r1bX9x1qvjq7RLWnG2LZmh17+Ze1Tz0gEn2jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KcngbZ77S1YiD9VAsDZOBvZXYHL35JjuftuepZB2ywD5VQ4SXYOVHYYCBnpktqhvS
	 TVRNRHADpOm2YiklTgKdQJ7gtUHkXl9e/Z5LfVw8QdXwlFfBq+RW6lN2Zj8U9/N+pd
	 HKk0UueUlMR/WJTy5jQhx+yIWECDuSJ3e1MC9hGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/150] kunit: Warn if tests are slow
Date: Thu, 18 Jan 2024 11:47:05 +0100
Message-ID: <20240118104320.187147670@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <mripard@kernel.org>

[ Upstream commit f8f2847f739dc899d0e563eac01299dadefa64ff ]

Kunit recently gained support to setup attributes, the first one being
the speed of a given test, then allowing to filter out slow tests.

A slow test is defined in the documentation as taking more than one
second. There's an another speed attribute called "super slow" but whose
definition is less clear.

Add support to the test runner to check the test execution time, and
report tests that should be marked as slow but aren't.

Signed-off-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/test.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/lib/kunit/test.c b/lib/kunit/test.c
index 421f13981412..e451cfe6143e 100644
--- a/lib/kunit/test.c
+++ b/lib/kunit/test.c
@@ -372,6 +372,36 @@ void kunit_init_test(struct kunit *test, const char *name, char *log)
 }
 EXPORT_SYMBOL_GPL(kunit_init_test);
 
+/* Only warn when a test takes more than twice the threshold */
+#define KUNIT_SPEED_WARNING_MULTIPLIER	2
+
+/* Slow tests are defined as taking more than 1s */
+#define KUNIT_SPEED_SLOW_THRESHOLD_S	1
+
+#define KUNIT_SPEED_SLOW_WARNING_THRESHOLD_S	\
+	(KUNIT_SPEED_WARNING_MULTIPLIER * KUNIT_SPEED_SLOW_THRESHOLD_S)
+
+#define s_to_timespec64(s) ns_to_timespec64((s) * NSEC_PER_SEC)
+
+static void kunit_run_case_check_speed(struct kunit *test,
+				       struct kunit_case *test_case,
+				       struct timespec64 duration)
+{
+	struct timespec64 slow_thr =
+		s_to_timespec64(KUNIT_SPEED_SLOW_WARNING_THRESHOLD_S);
+	enum kunit_speed speed = test_case->attr.speed;
+
+	if (timespec64_compare(&duration, &slow_thr) < 0)
+		return;
+
+	if (speed == KUNIT_SPEED_VERY_SLOW || speed == KUNIT_SPEED_SLOW)
+		return;
+
+	kunit_warn(test,
+		   "Test should be marked slow (runtime: %lld.%09lds)",
+		   duration.tv_sec, duration.tv_nsec);
+}
+
 /*
  * Initializes and runs test case. Does not clean up or do post validations.
  */
@@ -379,6 +409,8 @@ static void kunit_run_case_internal(struct kunit *test,
 				    struct kunit_suite *suite,
 				    struct kunit_case *test_case)
 {
+	struct timespec64 start, end;
+
 	if (suite->init) {
 		int ret;
 
@@ -390,7 +422,13 @@ static void kunit_run_case_internal(struct kunit *test,
 		}
 	}
 
+	ktime_get_ts64(&start);
+
 	test_case->run_case(test);
+
+	ktime_get_ts64(&end);
+
+	kunit_run_case_check_speed(test, test_case, timespec64_sub(end, start));
 }
 
 static void kunit_case_internal_cleanup(struct kunit *test)
-- 
2.43.0



