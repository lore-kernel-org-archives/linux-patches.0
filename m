Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33511DD0C8;
	Wed,  6 Nov 2024 12:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895326; cv=none; b=dC5mdT4HPBF2LQdVvNKlOLW4+rLSKEwbILo8UjvXHDAxMr73zwZivQRCWDfFIoy2417WDtwNGllXlRhevD4GaSjkf9IExhsh/QC/CXcH+ZB9GNjs4MJG20eq7PgDocy2yc0KqM/Q5jaLXQg45E5ZJSjrnwCfwndJ0sB/7T64eiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895326; c=relaxed/simple;
	bh=WSxNaOkKGepFnJRNgstK5TTmIIzUpaYO+F/jE6Id9KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5dPzJfIoIhimKrx9kgjYrwK+47jb+NlSoT8QBqudy+9F3SWuOy61MJ+26wj691S97GYfLLQ+U+VXKbABJt7tbHyZ1Rjebu9U5C+M47LObGhRfTdk21nnEmHSdBpKq1STkm7dXgDaBQ64l4xzkvcmyrQs6EceWFyrXdiCe3biZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6eQpzIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6eQpzIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FFDC4CECD;
	Wed,  6 Nov 2024 12:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895326;
	bh=WSxNaOkKGepFnJRNgstK5TTmIIzUpaYO+F/jE6Id9KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6eQpzIJfRlhCc4wjHqX4UCHqGZelMpdg8cQTef3fCW3iFYLvUodV+QcsA6yCpFVT
	 Iu40CCk/bUktLJtpyovIatm6RSfrQ75ocqxZlw7CPuitKt1MO1InKzIyctOaDMFtmq
	 Or6YT+erPhx3d+W9w9vHpuBvqd8u8ttfaSabS0Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sinadin Shan <sinadin.shan@oracle.com>,
	Yifei Liu <yifei.l.liu@oracle.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 181/350] selftests: breakpoints: use remaining time to check if suspend succeed
Date: Wed,  6 Nov 2024 13:01:49 +0100
Message-ID: <20241106120325.410352421@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index f82dcc1f8841e..67a2aaf1f9d94 100644
--- a/tools/testing/selftests/breakpoints/step_after_suspend_test.c
+++ b/tools/testing/selftests/breakpoints/step_after_suspend_test.c
@@ -161,7 +161,10 @@ void suspend(void)
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



