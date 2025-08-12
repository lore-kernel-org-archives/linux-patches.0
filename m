Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5913D2C21F6;
	Tue, 12 Aug 2025 18:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024516; cv=none; b=DARi+7sNlVd1HdW1BFHh7ugu9v6ZACQ53Sf1LXVvWsNinO58XYenDih07RzBrTpjREGaHcg1HMM+WjIFuiOw2NcVbyMW9e54AzEOYMUD3apCNBC9qArRByr7KU3ESKeeuMUAaPV9ifNWpWn8vYaM4/9GYNe8ajH1bGcp72LJ0eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024516; c=relaxed/simple;
	bh=ddjfuyAnKV4wRaRY0QDaVUgTFvMGnWgatuAsfWVq3Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oyNWqpnuS7H8k8CEF4MGl3maRlNXntQcCDVfAD0pJK7AzaIfdc3F3gVpYThfpTVgGfFJ3QkQGQCvSDM4fbBGEnchJJK3umKCCdgWKF4Ss+W55GMku7WrM8vh5s6gom5zyDEUyJVz0nU660jSjLh8KcT64pE0ohs3HRuCHEfgS1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dnIMKdg9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dnIMKdg9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6320C4CEF0;
	Tue, 12 Aug 2025 18:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024516;
	bh=ddjfuyAnKV4wRaRY0QDaVUgTFvMGnWgatuAsfWVq3Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dnIMKdg9zVLfRVS6YcsWTrXHDLJnyrzRdbiN5C9cqC9Pi+6zN8RL/VhMGiTUU965G
	 zhER62cwMnIv34tSOvkEAKlb6+fToCM6tl3c9e5Em/DRQLP+PWLENB0TzRYFFFRF0g
	 BLGs2LtxbFlaf6WJAwBB6BIVc07UInEO6OourGBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shashank Balaji <shashank.mahadasyam@sony.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 397/627] selftests/cgroup: fix cpu.max tests
Date: Tue, 12 Aug 2025 19:31:32 +0200
Message-ID: <20250812173434.399078995@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shashank Balaji <shashank.mahadasyam@sony.com>

[ Upstream commit 954bacce36d976fe472090b55987df66da00c49b ]

Current cpu.max tests (both the normal one and the nested one) are broken.

They setup cpu.max with 1000 us quota and the default period (100,000 us).
A cpu hog is run for a duration of 1s as per wall clock time. This corresponds
to 10 periods, hence an expected usage of 10,000 us. We want the measured
usage (as per cpu.stat) to be close to 10,000 us.

Previously, this approximate equality test was done by
`!values_close(usage_usec, expected_usage_usec, 95)`: if the absolute
difference between usage_usec and expected_usage_usec is greater than 95% of
their sum, then we pass. And expected_usage_usec was set to 1,000,000 us.
Mathematically, this translates to the following being true for pass:

	|usage - expected_usage| > (usage + expected_usage)*0.95

	If usage > expected_usage:
		usage - expected_usage > (usage + expected_usage)*0.95
		0.05*usage > 1.95*expected_usage
		usage > 39*expected_usage = 39s

	If usage < expected_usage:
		expected_usage - usage > (usage + expected_usage)*0.95
		0.05*expected_usage > 1.95*usage
		usage < 0.0256*expected_usage = 25,600 us

Combined,

	Pass if usage < 25,600 us or > 39 s,

which makes no sense given that all we need is for usage_usec to be close to
10,000 us.

Fix this by explicitly calcuating the expected usage duration based on the
configured quota, default period, and the duration, and compare usage_usec
and expected_usage_usec using values_close() with a 10% error margin.

Also, use snprintf to get the quota string to write to cpu.max instead of
hardcoding the quota, ensuring a single source of truth.

Remove the check comparing user_usec and expected_usage_usec, since on running
this test modified with printfs, it's seen that user_usec and usage_usec can
regularly exceed the theoretical expected_usage_usec:

	$ sudo ./test_cpu
	user: 10485, usage: 10485, expected: 10000
	ok 1 test_cpucg_max
	user: 11127, usage: 11127, expected: 10000
	ok 2 test_cpucg_max_nested
	$ sudo ./test_cpu
	user: 10286, usage: 10286, expected: 10000
	ok 1 test_cpucg_max
	user: 10404, usage: 11271, expected: 10000
	ok 2 test_cpucg_max_nested

Hence, a values_close() check of usage_usec and expected_usage_usec is
sufficient.

Fixes: a79906570f9646ae17 ("cgroup: Add test_cpucg_max_nested() testcase")
Fixes: 889ab8113ef1386c57 ("cgroup: Add test_cpucg_max() testcase")
Acked-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Shashank Balaji <shashank.mahadasyam@sony.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_cpu.c | 63 ++++++++++++++++-------
 1 file changed, 43 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index a2b50af8e9ee..2a60e6c41940 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -2,6 +2,7 @@
 
 #define _GNU_SOURCE
 #include <linux/limits.h>
+#include <sys/param.h>
 #include <sys/sysinfo.h>
 #include <sys/wait.h>
 #include <errno.h>
@@ -645,10 +646,16 @@ test_cpucg_nested_weight_underprovisioned(const char *root)
 static int test_cpucg_max(const char *root)
 {
 	int ret = KSFT_FAIL;
-	long usage_usec, user_usec;
-	long usage_seconds = 1;
-	long expected_usage_usec = usage_seconds * USEC_PER_SEC;
+	long quota_usec = 1000;
+	long default_period_usec = 100000; /* cpu.max's default period */
+	long duration_seconds = 1;
+
+	long duration_usec = duration_seconds * USEC_PER_SEC;
+	long usage_usec, n_periods, remainder_usec, expected_usage_usec;
 	char *cpucg;
+	char quota_buf[32];
+
+	snprintf(quota_buf, sizeof(quota_buf), "%ld", quota_usec);
 
 	cpucg = cg_name(root, "cpucg_test");
 	if (!cpucg)
@@ -657,13 +664,13 @@ static int test_cpucg_max(const char *root)
 	if (cg_create(cpucg))
 		goto cleanup;
 
-	if (cg_write(cpucg, "cpu.max", "1000"))
+	if (cg_write(cpucg, "cpu.max", quota_buf))
 		goto cleanup;
 
 	struct cpu_hog_func_param param = {
 		.nprocs = 1,
 		.ts = {
-			.tv_sec = usage_seconds,
+			.tv_sec = duration_seconds,
 			.tv_nsec = 0,
 		},
 		.clock_type = CPU_HOG_CLOCK_WALL,
@@ -672,14 +679,19 @@ static int test_cpucg_max(const char *root)
 		goto cleanup;
 
 	usage_usec = cg_read_key_long(cpucg, "cpu.stat", "usage_usec");
-	user_usec = cg_read_key_long(cpucg, "cpu.stat", "user_usec");
-	if (user_usec <= 0)
+	if (usage_usec <= 0)
 		goto cleanup;
 
-	if (user_usec >= expected_usage_usec)
-		goto cleanup;
+	/*
+	 * The following calculation applies only since
+	 * the cpu hog is set to run as per wall-clock time
+	 */
+	n_periods = duration_usec / default_period_usec;
+	remainder_usec = duration_usec - n_periods * default_period_usec;
+	expected_usage_usec
+		= n_periods * quota_usec + MIN(remainder_usec, quota_usec);
 
-	if (values_close(usage_usec, expected_usage_usec, 95))
+	if (!values_close(usage_usec, expected_usage_usec, 10))
 		goto cleanup;
 
 	ret = KSFT_PASS;
@@ -698,10 +710,16 @@ static int test_cpucg_max(const char *root)
 static int test_cpucg_max_nested(const char *root)
 {
 	int ret = KSFT_FAIL;
-	long usage_usec, user_usec;
-	long usage_seconds = 1;
-	long expected_usage_usec = usage_seconds * USEC_PER_SEC;
+	long quota_usec = 1000;
+	long default_period_usec = 100000; /* cpu.max's default period */
+	long duration_seconds = 1;
+
+	long duration_usec = duration_seconds * USEC_PER_SEC;
+	long usage_usec, n_periods, remainder_usec, expected_usage_usec;
 	char *parent, *child;
+	char quota_buf[32];
+
+	snprintf(quota_buf, sizeof(quota_buf), "%ld", quota_usec);
 
 	parent = cg_name(root, "cpucg_parent");
 	child = cg_name(parent, "cpucg_child");
@@ -717,13 +735,13 @@ static int test_cpucg_max_nested(const char *root)
 	if (cg_create(child))
 		goto cleanup;
 
-	if (cg_write(parent, "cpu.max", "1000"))
+	if (cg_write(parent, "cpu.max", quota_buf))
 		goto cleanup;
 
 	struct cpu_hog_func_param param = {
 		.nprocs = 1,
 		.ts = {
-			.tv_sec = usage_seconds,
+			.tv_sec = duration_seconds,
 			.tv_nsec = 0,
 		},
 		.clock_type = CPU_HOG_CLOCK_WALL,
@@ -732,14 +750,19 @@ static int test_cpucg_max_nested(const char *root)
 		goto cleanup;
 
 	usage_usec = cg_read_key_long(child, "cpu.stat", "usage_usec");
-	user_usec = cg_read_key_long(child, "cpu.stat", "user_usec");
-	if (user_usec <= 0)
+	if (usage_usec <= 0)
 		goto cleanup;
 
-	if (user_usec >= expected_usage_usec)
-		goto cleanup;
+	/*
+	 * The following calculation applies only since
+	 * the cpu hog is set to run as per wall-clock time
+	 */
+	n_periods = duration_usec / default_period_usec;
+	remainder_usec = duration_usec - n_periods * default_period_usec;
+	expected_usage_usec
+		= n_periods * quota_usec + MIN(remainder_usec, quota_usec);
 
-	if (values_close(usage_usec, expected_usage_usec, 95))
+	if (!values_close(usage_usec, expected_usage_usec, 10))
 		goto cleanup;
 
 	ret = KSFT_PASS;
-- 
2.39.5



