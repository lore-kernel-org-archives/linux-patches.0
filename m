Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FE21DF996;
	Tue,  8 Oct 2024 13:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393666; cv=none; b=UDJm6bB3i0tU4tw5+cPe9dLG8qx/edYqDc/uTcf557CUouqKeJLARvD3qNS0Y/8b8iybHb7CRaCDdGhYXYqE/NymzN39OQ+05mnUzaglKo256larcaZn3JpXdO0NY+e5H/uw8H9v54ZM+D/talP3I6HOOcCYYawtoorn6h+xWvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393666; c=relaxed/simple;
	bh=N7rUW/kN57pEWjnhVpCt4T+Vvk+8ekdPb3mRfxm8l2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZG75pQu9WSwj3owoJfEjSLYXc20ZLdXPYG0xsKWrKeVAvbK3l8olTDVagBx6SG5QQWlNWqRmnt1BOmiCT89Oo3tZUmbm771TFl44Y9C3Znhf6G7Cov8IQIagIrkyuidp+jw4vV5yd0L+oa/iXuvigOMWWxnVTbVEU4Zuf59gRuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sR/IJplY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sR/IJplY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2159C4CECC;
	Tue,  8 Oct 2024 13:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393666;
	bh=N7rUW/kN57pEWjnhVpCt4T+Vvk+8ekdPb3mRfxm8l2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sR/IJplYHy6W0ndqHZMxH9FjKljPgP9G1fabilN1gRE5FAMDDbdoKZkZYsIU7HXF7
	 Cz25+82rWPzI24/3Ovj6/7C3ubOYtTO7SVEYQ+ujyvzA+ujBtF4O8NKF1BYLPx1FJZ
	 256gE7vWW6+SOrBAYgbcDxzkFHPaoYi4VbMnciSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sinadin Shan <sinadin.shan@oracle.com>,
	Yifei Liu <yifei.l.liu@oracle.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 192/386] selftests: breakpoints: use remaining time to check if suspend succeed
Date: Tue,  8 Oct 2024 14:07:17 +0200
Message-ID: <20241008115636.964298774@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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



