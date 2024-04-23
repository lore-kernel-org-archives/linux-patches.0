Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B137685274;
	Tue, 23 Apr 2024 21:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908566; cv=none; b=KcNbLxtO3cXkolAPF4nTaOFJUGPQEufwiK25Z6lmYPM6q2+/1IC6jEMs3f0aQWsPdQjgCKFU7HDPvcQinmT+RBB3RzfKhMrZjMTGM+mUjcZ7zVgykM33mcjsPO1Urx5YY5h3ueweub9iRADB/cCSPJ9jaE8l7hL4GJWgtlIjImA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908566; c=relaxed/simple;
	bh=hAeCY1TlQ9Ofj1d4WZdla3xHeVLprb5H8LZz1X3xYv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKnZmhfYiPFCPdQeSPJC7LQuGim+UlL3eCMwjHG0BhHckXSmrjm1wVhcyZnK7hf39TiR9LoB4MTSaQlpdEgvNqxzOXddTvX+WEFsaQugbXWZzR3wG2FZnMQ3zmEdY734WmHrAAHqk3VFmSS/qSZw3MG+N0BCqTLqEUkNcCCllIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmwJKEMs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmwJKEMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE1BC32786;
	Tue, 23 Apr 2024 21:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908566;
	bh=hAeCY1TlQ9Ofj1d4WZdla3xHeVLprb5H8LZz1X3xYv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hmwJKEMsJg6vaIPw4hyA2M8YF6CN6X3jqJ81gkl+iwvmllpsQHIFL+tp93IupHsyK
	 /LNEcbBFiDsW/Jy+UHcPmHk7iCFYWI7JDy3Du4t4bpIrWy0/ajGT07v7OE+HTdsv4k
	 W40rrXyyS7x05oQ3Y9G60gOWNzYPdp1lQbp6ZnOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/158] selftests/timers/posix_timers: Reimplement check_timer_distribution()
Date: Tue, 23 Apr 2024 14:37:32 -0700
Message-ID: <20240423213856.210564153@linuxfoundation.org>
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

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit 6d029c25b71f2de2838a6f093ce0fa0e69336154 ]

check_timer_distribution() runs ten threads in a busy loop and tries to
test that the kernel distributes a process posix CPU timer signal to every
thread over time.

There is not guarantee that this is true even after commit bcb7ee79029d
("posix-timers: Prefer delivery of signals to the current thread") because
that commit only avoids waking up the sleeping process leader thread, but
that has nothing to do with the actual signal delivery.

As the signal is process wide the first thread which observes sigpending
and wins the race to lock sighand will deliver the signal. Testing shows
that this hangs on a regular base because some threads never win the race.

The comment "This primarily tests that the kernel does not favour any one."
is wrong. The kernel does favour a thread which hits the timer interrupt
when CLOCK_PROCESS_CPUTIME_ID expires.

Rewrite the test so it only checks that the group leader sleeping in join()
never receives SIGALRM and the thread which burns CPU cycles receives all
signals.

In older kernels which do not have commit bcb7ee79029d ("posix-timers:
Prefer delivery of signals to the current thread") the test-case fails
immediately, the very 1st tick wakes the leader up. Otherwise it quickly
succeeds after 100 ticks.

CI testing wants to use newer selftest versions on stable kernels. In this
case the test is guaranteed to fail.

So check in the failure case whether the kernel version is less than v6.3
and skip the test result in that case.

[ tglx: Massaged change log, renamed the version check helper ]

Fixes: e797203fb3ba ("selftests/timers/posix_timers: Test delivery of signals across threads")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240409133802.GD29396@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest.h           |  13 +++
 tools/testing/selftests/timers/posix_timers.c | 103 ++++++++----------
 2 files changed, 60 insertions(+), 56 deletions(-)

diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
index 529d29a359002..68d5a93dff8dc 100644
--- a/tools/testing/selftests/kselftest.h
+++ b/tools/testing/selftests/kselftest.h
@@ -49,6 +49,7 @@
 #include <unistd.h>
 #include <stdarg.h>
 #include <stdio.h>
+#include <sys/utsname.h>
 #endif
 
 #ifndef ARRAY_SIZE
@@ -327,4 +328,16 @@ static inline int ksft_exit_skip(const char *msg, ...)
 	exit(KSFT_SKIP);
 }
 
+static inline int ksft_min_kernel_version(unsigned int min_major,
+					  unsigned int min_minor)
+{
+	unsigned int major, minor;
+	struct utsname info;
+
+	if (uname(&info) || sscanf(info.release, "%u.%u.", &major, &minor) != 2)
+		ksft_exit_fail_msg("Can't parse kernel version\n");
+
+	return major > min_major || (major == min_major && minor >= min_minor);
+}
+
 #endif /* __KSELFTEST_H */
diff --git a/tools/testing/selftests/timers/posix_timers.c b/tools/testing/selftests/timers/posix_timers.c
index 2669c45316b3d..14355d8472110 100644
--- a/tools/testing/selftests/timers/posix_timers.c
+++ b/tools/testing/selftests/timers/posix_timers.c
@@ -184,80 +184,71 @@ static int check_timer_create(int which)
 	return 0;
 }
 
-int remain;
-__thread int got_signal;
+static pthread_t ctd_thread;
+static volatile int ctd_count, ctd_failed;
 
-static void *distribution_thread(void *arg)
+static void ctd_sighandler(int sig)
 {
-	while (__atomic_load_n(&remain, __ATOMIC_RELAXED));
-	return NULL;
+	if (pthread_self() != ctd_thread)
+		ctd_failed = 1;
+	ctd_count--;
 }
 
-static void distribution_handler(int nr)
+static void *ctd_thread_func(void *arg)
 {
-	if (!__atomic_exchange_n(&got_signal, 1, __ATOMIC_RELAXED))
-		__atomic_fetch_sub(&remain, 1, __ATOMIC_RELAXED);
-}
-
-/*
- * Test that all running threads _eventually_ receive CLOCK_PROCESS_CPUTIME_ID
- * timer signals. This primarily tests that the kernel does not favour any one.
- */
-static int check_timer_distribution(void)
-{
-	int err, i;
-	timer_t id;
-	const int nthreads = 10;
-	pthread_t threads[nthreads];
 	struct itimerspec val = {
 		.it_value.tv_sec = 0,
 		.it_value.tv_nsec = 1000 * 1000,
 		.it_interval.tv_sec = 0,
 		.it_interval.tv_nsec = 1000 * 1000,
 	};
+	timer_t id;
 
-	remain = nthreads + 1;  /* worker threads + this thread */
-	signal(SIGALRM, distribution_handler);
-	err = timer_create(CLOCK_PROCESS_CPUTIME_ID, NULL, &id);
-	if (err < 0) {
-		ksft_perror("Can't create timer");
-		return -1;
-	}
-	err = timer_settime(id, 0, &val, NULL);
-	if (err < 0) {
-		ksft_perror("Can't set timer");
-		return -1;
-	}
+	/* 1/10 seconds to ensure the leader sleeps */
+	usleep(10000);
 
-	for (i = 0; i < nthreads; i++) {
-		err = pthread_create(&threads[i], NULL, distribution_thread,
-				     NULL);
-		if (err) {
-			ksft_print_msg("Can't create thread: %s (%d)\n",
-				       strerror(errno), errno);
-			return -1;
-		}
-	}
+	ctd_count = 100;
+	if (timer_create(CLOCK_PROCESS_CPUTIME_ID, NULL, &id))
+		return "Can't create timer\n";
+	if (timer_settime(id, 0, &val, NULL))
+		return "Can't set timer\n";
 
-	/* Wait for all threads to receive the signal. */
-	while (__atomic_load_n(&remain, __ATOMIC_RELAXED));
+	while (ctd_count > 0 && !ctd_failed)
+		;
 
-	for (i = 0; i < nthreads; i++) {
-		err = pthread_join(threads[i], NULL);
-		if (err) {
-			ksft_print_msg("Can't join thread: %s (%d)\n",
-				       strerror(errno), errno);
-			return -1;
-		}
-	}
+	if (timer_delete(id))
+		return "Can't delete timer\n";
 
-	if (timer_delete(id)) {
-		ksft_perror("Can't delete timer");
-		return -1;
-	}
+	return NULL;
+}
+
+/*
+ * Test that only the running thread receives the timer signal.
+ */
+static int check_timer_distribution(void)
+{
+	const char *errmsg;
 
-	ksft_test_result_pass("check_timer_distribution\n");
+	signal(SIGALRM, ctd_sighandler);
+
+	errmsg = "Can't create thread\n";
+	if (pthread_create(&ctd_thread, NULL, ctd_thread_func, NULL))
+		goto err;
+
+	errmsg = "Can't join thread\n";
+	if (pthread_join(ctd_thread, (void **)&errmsg) || errmsg)
+		goto err;
+
+	if (!ctd_failed)
+		ksft_test_result_pass("check signal distribution\n");
+	else if (ksft_min_kernel_version(6, 3))
+		ksft_test_result_fail("check signal distribution\n");
+	else
+		ksft_test_result_skip("check signal distribution (old kernel)\n");
 	return 0;
+err:
+	ksft_print_msg(errmsg);
+	return -1;
 }
 
 int main(int argc, char **argv)
-- 
2.43.0



