Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD6527713;
	Tue,  9 Jul 2024 11:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524495; cv=none; b=A+UF6HZ1oWjkCglIb4FucQVrB6PRDHg599sIHCWpN+XyYvHvqpcfcV8Mi4bn82Lxfl7kL8KtEZoZiRrffkHVzXg65SOj6XCNH8CcNDXn14ln0b1tab3CO9OhGtZYY1NPZ89MA7CFxNPFoSK/GIEB+gR6I25K5AnwOsHpNi1nz9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524495; c=relaxed/simple;
	bh=qDzEabgrIfYeUb0f3wkDuhHj084UM2kYze+tUNQmJJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sy0MJJnCw/SH/fo+TfmGkm1nBBOliyKATnWWZDAhUjDOp+jY0oJEAUutFvGqTKHFMb8zv84b4U6NPHA4WapJ5koEmN/DuxngdjPoQGaZgSsoUvcSblX6tqh63yWs/mj8R5RvZoeCrW6xZE4kOzrlMnTwktdvHg6PbE8fmaRFh30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Uzg3uKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Uzg3uKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D81DC3277B;
	Tue,  9 Jul 2024 11:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524494;
	bh=qDzEabgrIfYeUb0f3wkDuhHj084UM2kYze+tUNQmJJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Uzg3uKods3TnN5aG6aoqdg1uY/cdh024Ho3npqkpQdl89nbgb+CtKtXlbA919MF3
	 ZCT73SN2dEkVgikizDqDSXKgnqD48mQJDeMnXXmVOTOe9DB1NoBQtRgHJjnGdnrU1Z
	 21qSLfoo7lH8oBuc4QDGa3bU4apDCPwDuS8VMraE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Shuah Khan <shuah@kernel.org>,
	Will Drewry <wad@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.9 168/197] selftests/harness: Fix tests timeout and race condition
Date: Tue,  9 Jul 2024 13:10:22 +0200
Message-ID: <20240709110715.450858968@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

commit 130e42806773013e9cf32d211922c935ae2df86c upstream.

We cannot use CLONE_VFORK because we also need to wait for the timeout
signal.

Restore tests timeout by using the original fork() call in __run_test()
but also in __TEST_F_IMPL().  Also fix a race condition when waiting for
the test child process.

Because test metadata are shared between test processes, only the
parent process must set the test PID (child).  Otherwise, t->pid may be
set to zero, leading to inconsistent error cases:

  #  RUN           layout1.rule_on_mountpoint ...
  # rule_on_mountpoint: Test ended in some other way [127]
  #            OK  layout1.rule_on_mountpoint
  ok 20 layout1.rule_on_mountpoint

As safeguards, initialize the "status" variable with a valid exit code,
and handle unknown test exits as errors.

The use of fork() introduces a new race condition in landlock/fs_test.c
which seems to be specific to hostfs bind mounts, but I haven't found
the root cause and it's difficult to trigger.  I'll try to fix it with
another patch.

Cc: Christian Brauner <brauner@kernel.org>
Cc: Günther Noack <gnoack@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/r/9341d4db-5e21-418c-bf9e-9ae2da7877e1@sirena.org.uk
Fixes: a86f18903db9 ("selftests/harness: Fix interleaved scheduling leading to race conditions")
Fixes: 24cf65a62266 ("selftests/harness: Share _metadata between forked processes")
Link: https://lore.kernel.org/r/20240621180605.834676-1-mic@digikod.net
Tested-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kselftest_harness.h |   43 +++++++++++++++-------------
 1 file changed, 24 insertions(+), 19 deletions(-)

--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -66,8 +66,6 @@
 #include <sys/wait.h>
 #include <unistd.h>
 #include <setjmp.h>
-#include <syscall.h>
-#include <linux/sched.h>
 
 #include "kselftest.h"
 
@@ -82,17 +80,6 @@
 #  define TH_LOG_ENABLED 1
 #endif
 
-/* Wait for the child process to end but without sharing memory mapping. */
-static inline pid_t clone3_vfork(void)
-{
-	struct clone_args args = {
-		.flags = CLONE_VFORK,
-		.exit_signal = SIGCHLD,
-	};
-
-	return syscall(__NR_clone3, &args, sizeof(args));
-}
-
 /**
  * TH_LOG()
  *
@@ -437,7 +424,7 @@ static inline pid_t clone3_vfork(void)
 		} \
 		if (setjmp(_metadata->env) == 0) { \
 			/* _metadata and potentially self are shared with all forks. */ \
-			child = clone3_vfork(); \
+			child = fork(); \
 			if (child == 0) { \
 				fixture_name##_setup(_metadata, self, variant->data); \
 				/* Let setup failure terminate early. */ \
@@ -1016,7 +1003,14 @@ void __wait_for_test(struct __test_metad
 		.sa_flags = SA_SIGINFO,
 	};
 	struct sigaction saved_action;
-	int status;
+	/*
+	 * Sets status so that WIFEXITED(status) returns true and
+	 * WEXITSTATUS(status) returns KSFT_FAIL.  This safe default value
+	 * should never be evaluated because of the waitpid(2) check and
+	 * SIGALRM handling.
+	 */
+	int status = KSFT_FAIL << 8;
+	int child;
 
 	if (sigaction(SIGALRM, &action, &saved_action)) {
 		t->exit_code = KSFT_FAIL;
@@ -1028,7 +1022,15 @@ void __wait_for_test(struct __test_metad
 	__active_test = t;
 	t->timed_out = false;
 	alarm(t->timeout);
-	waitpid(t->pid, &status, 0);
+	child = waitpid(t->pid, &status, 0);
+	if (child == -1 && errno != EINTR) {
+		t->exit_code = KSFT_FAIL;
+		fprintf(TH_LOG_STREAM,
+			"# %s: Failed to wait for PID %d (errno: %d)\n",
+			t->name, t->pid, errno);
+		return;
+	}
+
 	alarm(0);
 	if (sigaction(SIGALRM, &saved_action, NULL)) {
 		t->exit_code = KSFT_FAIL;
@@ -1083,6 +1085,7 @@ void __wait_for_test(struct __test_metad
 				WTERMSIG(status));
 		}
 	} else {
+		t->exit_code = KSFT_FAIL;
 		fprintf(TH_LOG_STREAM,
 			"# %s: Test ended in some other way [%u]\n",
 			t->name,
@@ -1218,6 +1221,7 @@ void __run_test(struct __fixture_metadat
 	struct __test_xfail *xfail;
 	char test_name[1024];
 	const char *diagnostic;
+	int child;
 
 	/* reset test struct */
 	t->exit_code = KSFT_PASS;
@@ -1236,15 +1240,16 @@ void __run_test(struct __fixture_metadat
 	fflush(stdout);
 	fflush(stderr);
 
-	t->pid = clone3_vfork();
-	if (t->pid < 0) {
+	child = fork();
+	if (child < 0) {
 		ksft_print_msg("ERROR SPAWNING TEST CHILD\n");
 		t->exit_code = KSFT_FAIL;
-	} else if (t->pid == 0) {
+	} else if (child == 0) {
 		setpgrp();
 		t->fn(t, variant);
 		_exit(t->exit_code);
 	} else {
+		t->pid = child;
 		__wait_for_test(t);
 	}
 	ksft_print_msg("         %4s  %s\n",


