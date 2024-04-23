Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0E485274;
	Tue, 23 Apr 2024 21:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908566; cv=none; b=KHb0jRQJzVJ+x83f6lNyYGArAaFckt0W+Z4Soc++bLkFTBmmJOj/qzPUFstfK7rJKdIs/7B+VvMga/Qs8dsD24dS0SqoBdtgrtKBLXg8TdSg8aKbGyWSlcr+iT1z6KIM3zfloqZQ3jXGqcUzxxfUbkICQuzUp47XkFhCYzUWm+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908566; c=relaxed/simple;
	bh=/aNMV6ngNeMoHqec/50lit2FRmmxo/gAd94LglwTr8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/VnAa+4bFAG/U8rEMqxHe22dubL0boUTK/Okqpxxy1fxGxLAXzgwwDmJYDDF/3hoH5aySnSuR/XQbz6Vyi+mDphpv+mEGtf+QnlNOaD1rXZ+tT8xy1307VKsxH/0fSL75L6lJY3oen5NLqGXhyOCiFKIIGSp9BddCSnHEwrh9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqCrQd1X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqCrQd1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF177C3277B;
	Tue, 23 Apr 2024 21:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908565;
	bh=/aNMV6ngNeMoHqec/50lit2FRmmxo/gAd94LglwTr8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqCrQd1XHAHPvp09gYF/U0cbClSPb9ht7/0NazQJfZhk6eg0P7NBwVnBsf3pDZNUB
	 GVI7VveSmtzwYmHXmKBGrMgohjQ3aLMRdMs/7CPy4oIt6gkjH0IFEWTOunvxy6M5ne
	 b8z/stWJIiM+wlQZx3Z52ogc1jk3mC3quDBloCeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/158] selftests: timers: Convert posix_timers test to generate KTAP output
Date: Tue, 23 Apr 2024 14:37:31 -0700
Message-ID: <20240423213856.177773079@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 071af0c9e582bc47e379e39490a2bc1adfe4ec68 ]

Currently the posix_timers test does not produce KTAP output but rather a
custom format. This means that we only get a pass/fail for the suite, not
for each individual test that the suite does. Convert to using the standard
kselftest output functions which result in KTAP output being generated.

As part of this fix the printing of diagnostics in the unlikely event that
the pthread APIs fail, these were using perror() but the API functions
directly return an error code instead of setting errno.

Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: 6d029c25b71f ("selftests/timers/posix_timers: Reimplement check_timer_distribution()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/timers/posix_timers.c | 81 ++++++++++---------
 1 file changed, 41 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/timers/posix_timers.c b/tools/testing/selftests/timers/posix_timers.c
index 9a42403eaff70..2669c45316b3d 100644
--- a/tools/testing/selftests/timers/posix_timers.c
+++ b/tools/testing/selftests/timers/posix_timers.c
@@ -76,22 +76,21 @@ static int check_diff(struct timeval start, struct timeval end)
 
 static int check_itimer(int which)
 {
+	const char *name;
 	int err;
 	struct timeval start, end;
 	struct itimerval val = {
 		.it_value.tv_sec = DELAY,
 	};
 
-	printf("Check itimer ");
-
 	if (which == ITIMER_VIRTUAL)
-		printf("virtual... ");
+		name = "ITIMER_VIRTUAL";
 	else if (which == ITIMER_PROF)
-		printf("prof... ");
+		name = "ITIMER_PROF";
 	else if (which == ITIMER_REAL)
-		printf("real... ");
-
-	fflush(stdout);
+		name = "ITIMER_REAL";
+	else
+		return -1;
 
 	done = 0;
 
@@ -104,13 +103,13 @@ static int check_itimer(int which)
 
 	err = gettimeofday(&start, NULL);
 	if (err < 0) {
-		perror("Can't call gettimeofday()\n");
+		ksft_perror("Can't call gettimeofday()");
 		return -1;
 	}
 
 	err = setitimer(which, &val, NULL);
 	if (err < 0) {
-		perror("Can't set timer\n");
+		ksft_perror("Can't set timer");
 		return -1;
 	}
 
@@ -123,20 +122,18 @@ static int check_itimer(int which)
 
 	err = gettimeofday(&end, NULL);
 	if (err < 0) {
-		perror("Can't call gettimeofday()\n");
+		ksft_perror("Can't call gettimeofday()");
 		return -1;
 	}
 
-	if (!check_diff(start, end))
-		printf("[OK]\n");
-	else
-		printf("[FAIL]\n");
+	ksft_test_result(check_diff(start, end) == 0, "%s\n", name);
 
 	return 0;
 }
 
 static int check_timer_create(int which)
 {
+	const char *type;
 	int err;
 	timer_t id;
 	struct timeval start, end;
@@ -144,31 +141,32 @@ static int check_timer_create(int which)
 		.it_value.tv_sec = DELAY,
 	};
 
-	printf("Check timer_create() ");
 	if (which == CLOCK_THREAD_CPUTIME_ID) {
-		printf("per thread... ");
+		type = "thread";
 	} else if (which == CLOCK_PROCESS_CPUTIME_ID) {
-		printf("per process... ");
+		type = "process";
+	} else {
+		ksft_print_msg("Unknown timer_create() type %d\n", which);
+		return -1;
 	}
-	fflush(stdout);
 
 	done = 0;
 	err = timer_create(which, NULL, &id);
 	if (err < 0) {
-		perror("Can't create timer\n");
+		ksft_perror("Can't create timer");
 		return -1;
 	}
 	signal(SIGALRM, sig_handler);
 
 	err = gettimeofday(&start, NULL);
 	if (err < 0) {
-		perror("Can't call gettimeofday()\n");
+		ksft_perror("Can't call gettimeofday()");
 		return -1;
 	}
 
 	err = timer_settime(id, 0, &val, NULL);
 	if (err < 0) {
-		perror("Can't set timer\n");
+		ksft_perror("Can't set timer");
 		return -1;
 	}
 
@@ -176,14 +174,12 @@ static int check_timer_create(int which)
 
 	err = gettimeofday(&end, NULL);
 	if (err < 0) {
-		perror("Can't call gettimeofday()\n");
+		ksft_perror("Can't call gettimeofday()");
 		return -1;
 	}
 
-	if (!check_diff(start, end))
-		printf("[OK]\n");
-	else
-		printf("[FAIL]\n");
+	ksft_test_result(check_diff(start, end) == 0,
+			 "timer_create() per %s\n", type);
 
 	return 0;
 }
@@ -220,25 +216,25 @@ static int check_timer_distribution(void)
 		.it_interval.tv_nsec = 1000 * 1000,
 	};
 
-	printf("Check timer_create() per process signal distribution... ");
-	fflush(stdout);
-
 	remain = nthreads + 1;  /* worker threads + this thread */
 	signal(SIGALRM, distribution_handler);
 	err = timer_create(CLOCK_PROCESS_CPUTIME_ID, NULL, &id);
 	if (err < 0) {
-		perror("Can't create timer\n");
+		ksft_perror("Can't create timer");
 		return -1;
 	}
 	err = timer_settime(id, 0, &val, NULL);
 	if (err < 0) {
-		perror("Can't set timer\n");
+		ksft_perror("Can't set timer");
 		return -1;
 	}
 
 	for (i = 0; i < nthreads; i++) {
-		if (pthread_create(&threads[i], NULL, distribution_thread, NULL)) {
-			perror("Can't create thread\n");
+		err = pthread_create(&threads[i], NULL, distribution_thread,
+				     NULL);
+		if (err) {
+			ksft_print_msg("Can't create thread: %s (%d)\n",
+				       strerror(errno), errno);
 			return -1;
 		}
 	}
@@ -247,25 +243,30 @@ static int check_timer_distribution(void)
 	while (__atomic_load_n(&remain, __ATOMIC_RELAXED));
 
 	for (i = 0; i < nthreads; i++) {
-		if (pthread_join(threads[i], NULL)) {
-			perror("Can't join thread\n");
+		err = pthread_join(threads[i], NULL);
+		if (err) {
+			ksft_print_msg("Can't join thread: %s (%d)\n",
+				       strerror(errno), errno);
 			return -1;
 		}
 	}
 
 	if (timer_delete(id)) {
-		perror("Can't delete timer\n");
+		ksft_perror("Can't delete timer");
 		return -1;
 	}
 
-	printf("[OK]\n");
+	ksft_test_result_pass("check_timer_distribution\n");
 	return 0;
 }
 
 int main(int argc, char **argv)
 {
-	printf("Testing posix timers. False negative may happen on CPU execution \n");
-	printf("based timers if other threads run on the CPU...\n");
+	ksft_print_header();
+	ksft_set_plan(6);
+
+	ksft_print_msg("Testing posix timers. False negative may happen on CPU execution \n");
+	ksft_print_msg("based timers if other threads run on the CPU...\n");
 
 	if (check_itimer(ITIMER_VIRTUAL) < 0)
 		return ksft_exit_fail();
@@ -294,5 +295,5 @@ int main(int argc, char **argv)
 	if (check_timer_distribution() < 0)
 		return ksft_exit_fail();
 
-	return ksft_exit_pass();
+	ksft_finished();
 }
-- 
2.43.0



