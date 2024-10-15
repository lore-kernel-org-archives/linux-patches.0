Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765341C7274;
	Tue, 15 Oct 2024 12:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993677; cv=none; b=MkuXAOu5jx1zWQoAg4E1EIpxHZIwazp+vY8lXDnDiKZwSRjQagx+1HT+oFfjH1Gz+ZHocuD0Dij7KL3PCY6DzIH7P5E7NVTq8d2kcG4JzwmA6M33K/OoQTw0GubUjPEqDWApF4eT6UottNve3XsNgHiWX8vaepfbzFzvyH0gHLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993677; c=relaxed/simple;
	bh=YTUtRTLbaN+wfEBeOz7Tmmo+3I+rNfFbnlt/Hi0RtRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6Ce2SyDFdV3Ztu7c4WDyHoBDISB0L5NWWi5Hrk0j6+byVEjflqQh7wnNg2d8Ynpj+dg1/hUR1zR7dkZffuU9nXjOX/fwcAcP4j5ZJHK1HqterKa8EkhfOkku2TKe1KNspVm19NLxdG/xfd4mMS926Fd6OV+CDRSfSUjiVgPhCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hYrfSr0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hYrfSr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE393C4CEC6;
	Tue, 15 Oct 2024 12:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993677;
	bh=YTUtRTLbaN+wfEBeOz7Tmmo+3I+rNfFbnlt/Hi0RtRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hYrfSr0MExfAmhsfwCRnOqd2xSY0AdlNcd5PjcOzKATBciywr/stmpGakzqGU4Lt
	 qj2NoyqgE4kKInQopH03swaZoAnZzyr970IjZOIRXME220nz3h7EohDcuVXB7MX4wY
	 h9qTJHjqU0IDW4LwK9DKt6X2AxotPtSOZAZZKcHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sinadin Shan <sinadin.shan@oracle.com>,
	Yifei Liu <yifei.l.liu@oracle.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 481/691] selftests: breakpoints: use remaining time to check if suspend succeed
Date: Tue, 15 Oct 2024 13:27:09 +0200
Message-ID: <20241015112459.430781756@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifei Liu <yifei.l.liu@oracle.com>

[ Upstream commit c66be905cda24fb782b91053b196bd2e966f95b7 ]

step_after_suspend_test fails with device busy error while
writing to /sys/power/state to start suspend. The test believes
it failed to enter suspend state with

$ sudo ./step_after_suspend_test
TAP version 13
Bail out! Failed to enter Suspend state

However, in the kernel message, I indeed see the system get
suspended and then wake up later.

[611172.033108] PM: suspend entry (s2idle)
[611172.044940] Filesystems sync: 0.006 seconds
[611172.052254] Freezing user space processes
[611172.059319] Freezing user space processes completed (elapsed 0.001 seconds)
[611172.067920] OOM killer disabled.
[611172.072465] Freezing remaining freezable tasks
[611172.080332] Freezing remaining freezable tasks completed (elapsed 0.001 seconds)
[611172.089724] printk: Suspending console(s) (use no_console_suspend to debug)
[611172.117126] serial 00:03: disabled
some other hardware get reconnected
[611203.136277] OOM killer enabled.
[611203.140637] Restarting tasks ...
[611203.141135] usb 1-8.1: USB disconnect, device number 7
[611203.141755] done.
[611203.155268] random: crng reseeded on system resumption
[611203.162059] PM: suspend exit

After investigation, I noticed that for the code block
if (write(power_state_fd, "mem", strlen("mem")) != strlen("mem"))
	ksft_exit_fail_msg("Failed to enter Suspend state\n");

The write will return -1 and errno is set to 16 (device busy).
It should be caused by the write function is not successfully returned
before the system suspend and the return value get messed when waking up.
As a result, It may be better to check the time passed of those few
instructions to determine whether the suspend is executed correctly for
it is pretty hard to execute those few lines for 5 seconds.

The timer to wake up the system is set to expire after 5 seconds and
no re-arm. If the timer remaining time is 0 second and 0 nano secomd,
it means the timer expired and wake the system up. Otherwise, the system
could be considered to enter the suspend state failed if there is any
remaining time.

After appling this patch, the test would not fail for it believes the
system does not go to suspend by mistake. It now could continue to the
rest part of the test after suspend.

Fixes: bfd092b8c272 ("selftests: breakpoint: add step_after_suspend_test")
Reported-by: Sinadin Shan <sinadin.shan@oracle.com>
Signed-off-by: Yifei Liu <yifei.l.liu@oracle.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/breakpoints/step_after_suspend_test.c  | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/breakpoints/step_after_suspend_test.c b/tools/testing/selftests/breakpoints/step_after_suspend_test.c
index 2cf6f10ab7c4a..fc02918962c75 100644
--- a/tools/testing/selftests/breakpoints/step_after_suspend_test.c
+++ b/tools/testing/selftests/breakpoints/step_after_suspend_test.c
@@ -153,7 +153,10 @@ void suspend(void)
 	if (err < 0)
 		ksft_exit_fail_msg("timerfd_settime() failed\n");
 
-	if (write(power_state_fd, "mem", strlen("mem")) != strlen("mem"))
+	system("(echo mem > /sys/power/state) 2> /dev/null");
+
+	timerfd_gettime(timerfd, &spec);
+	if (spec.it_value.tv_sec != 0 || spec.it_value.tv_nsec != 0)
 		ksft_exit_fail_msg("Failed to enter Suspend state\n");
 
 	close(timerfd);
-- 
2.43.0



