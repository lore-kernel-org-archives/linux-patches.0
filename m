Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE811EBFE0;
	Tue, 12 Aug 2025 18:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022087; cv=none; b=raPaUEZ6IaG/j1O6rTLrCBf/l3ub+FO/IP9GW/krCkE5s7EE+qJlAaTjMxcWhXOHwkQETeFzXRDIGeXlumUurTiqfnqMH1i2gtIQsegljWK9GuEOOvv0Fj0kbdw/1HSfaqr4CE+eWHEsHwvoxkmBhw1y8zFkpcQZnXW20vueEcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022087; c=relaxed/simple;
	bh=JzFWGxDp+124GwR8FQqn6zwYbsqnTKGOVfnkw3ys5Og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5qk3rTqplfa32M+WlUjGN+GaNpkM8GpjAtayL9/g95Rhhiywe/fzvlObZX9df7yy/R+dv5523ui+Xb27+5aWpiHpgimlnxjFN040ovI0wGR3gfXmDCmjNXFFMKJj6gcx999cZ+NdLstv6Q9hODZ/+X4oPLzZDJ6Kdf5gkY5daw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=thRohy7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="thRohy7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5E7C4CEF0;
	Tue, 12 Aug 2025 18:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022086;
	bh=JzFWGxDp+124GwR8FQqn6zwYbsqnTKGOVfnkw3ys5Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=thRohy7qjZlQ3Tck8EPDKyLwAZ6lfpbawWVaC8Ck3nQoBYF6lpgDJ0OvF7iX1xT5P
	 IOb6FL5E6P6XPzOCHiOCHZ7N1/c1NyAbq/m/5Ztk2nEV/LwUpckKy0AjujZ69cubLE
	 jR5tUjOWWMFvcRklEWPYuw2Z+ESnRu0/z+WiPtYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moon Hee Lee <moonhee.lee.ca@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/369] selftests: breakpoints: use suspend_stats to reliably check suspend success
Date: Tue, 12 Aug 2025 19:25:48 +0200
Message-ID: <20250812173016.681913562@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moon Hee Lee <moonhee.lee.ca@gmail.com>

[ Upstream commit 07b7c2b4eca3f83ce9cd5ee3fa1c7c001d721c69 ]

The step_after_suspend_test verifies that the system successfully
suspended and resumed by setting a timerfd and checking whether the
timer fully expired. However, this method is unreliable due to timing
races.

In practice, the system may take time to enter suspend, during which the
timer may expire just before or during the transition. As a result,
the remaining time after resume may show non-zero nanoseconds, even if
suspend/resume completed successfully. This leads to false test failures.

Replace the timer-based check with a read from
/sys/power/suspend_stats/success. This counter is incremented only
after a full suspend/resume cycle, providing a reliable and race-free
indicator.

Also remove the unused file descriptor for /sys/power/state, which
remained after switching to a system() call to trigger suspend [1].

[1] https://lore.kernel.org/all/20240930224025.2858767-1-yifei.l.liu@oracle.com/

Link: https://lore.kernel.org/r/20250626191626.36794-1-moonhee.lee.ca@gmail.com
Fixes: c66be905cda2 ("selftests: breakpoints: use remaining time to check if suspend succeed")
Signed-off-by: Moon Hee Lee <moonhee.lee.ca@gmail.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../breakpoints/step_after_suspend_test.c     | 41 ++++++++++++++-----
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/breakpoints/step_after_suspend_test.c b/tools/testing/selftests/breakpoints/step_after_suspend_test.c
index 8d275f03e977..8d233ac95696 100644
--- a/tools/testing/selftests/breakpoints/step_after_suspend_test.c
+++ b/tools/testing/selftests/breakpoints/step_after_suspend_test.c
@@ -127,22 +127,42 @@ int run_test(int cpu)
 	return KSFT_PASS;
 }
 
+/*
+ * Reads the suspend success count from sysfs.
+ * Returns the count on success or exits on failure.
+ */
+static int get_suspend_success_count_or_fail(void)
+{
+	FILE *fp;
+	int val;
+
+	fp = fopen("/sys/power/suspend_stats/success", "r");
+	if (!fp)
+		ksft_exit_fail_msg(
+			"Failed to open suspend_stats/success: %s\n",
+			strerror(errno));
+
+	if (fscanf(fp, "%d", &val) != 1) {
+		fclose(fp);
+		ksft_exit_fail_msg(
+			"Failed to read suspend success count\n");
+	}
+
+	fclose(fp);
+	return val;
+}
+
 void suspend(void)
 {
-	int power_state_fd;
 	int timerfd;
 	int err;
+	int count_before;
+	int count_after;
 	struct itimerspec spec = {};
 
 	if (getuid() != 0)
 		ksft_exit_skip("Please run the test as root - Exiting.\n");
 
-	power_state_fd = open("/sys/power/state", O_RDWR);
-	if (power_state_fd < 0)
-		ksft_exit_fail_msg(
-			"open(\"/sys/power/state\") failed %s)\n",
-			strerror(errno));
-
 	timerfd = timerfd_create(CLOCK_BOOTTIME_ALARM, 0);
 	if (timerfd < 0)
 		ksft_exit_fail_msg("timerfd_create() failed\n");
@@ -152,14 +172,15 @@ void suspend(void)
 	if (err < 0)
 		ksft_exit_fail_msg("timerfd_settime() failed\n");
 
+	count_before = get_suspend_success_count_or_fail();
+
 	system("(echo mem > /sys/power/state) 2> /dev/null");
 
-	timerfd_gettime(timerfd, &spec);
-	if (spec.it_value.tv_sec != 0 || spec.it_value.tv_nsec != 0)
+	count_after = get_suspend_success_count_or_fail();
+	if (count_after <= count_before)
 		ksft_exit_fail_msg("Failed to enter Suspend state\n");
 
 	close(timerfd);
-	close(power_state_fd);
 }
 
 int main(int argc, char **argv)
-- 
2.39.5



