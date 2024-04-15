Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8933A74BE1;
	Mon, 15 Apr 2024 14:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191447; cv=none; b=A2o/FnJv3NfT5s2N97+joI2qXAvwKT/CezTL9KHB7JIGrj4AB4uWA0QZ8e4iMHzxlJOnw5qBp3hVW8OEd38jO1HYpM9WyL+GBpYKB4JjS6OCwGKLvY4ZtmqlpGC4fs6iltXJyWP/5v780+RCecZ+CJzctGLWwNyGr4Q9xHVWWLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191447; c=relaxed/simple;
	bh=2MZAz3L1cdQ9p9wl6rpJObJ6LfUqOvHEDcKPS5dYwmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8ZjST5Q7kNADK0oZn8UOmp0IyXoVu9vV0YOPjlQ/jej2qO5+vaACr2noHa7U/KpbNPRAkBLSI5rEH/RK7foMRtGXw0B2qWtINm0JVKMt4FT5KUQLqJUfJuNIQai/J+FOnXvPzWr7m53G44bh+i85JCjF++VD+UTwS1Mgd5xdvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kO+V4QT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kO+V4QT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA837C113CC;
	Mon, 15 Apr 2024 14:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191447;
	bh=2MZAz3L1cdQ9p9wl6rpJObJ6LfUqOvHEDcKPS5dYwmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kO+V4QT6qRHTNFL7onV+SCWJf7l0ygCkR1oMhkq04D0B+b4h0FxC0VrQgd2wGhtNA
	 55IrHjpdkyOfJc7t8RgP9fVYbEgdfekTOZd+qLW+F7wZ+Jr18R0k1qZRYqtpMcM67w
	 6regFhF8cfpbC7zHyIilGTs9TGk0Z33WVHSGICSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Stultz <jstultz@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.8 146/172] selftests: kselftest: Mark functions that unconditionally call exit() as __noreturn
Date: Mon, 15 Apr 2024 16:20:45 +0200
Message-ID: <20240415142004.806721020@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit f7d5bcd35d427daac7e206b1073ca14f5db85c27 upstream.

After commit 6d029c25b71f ("selftests/timers/posix_timers: Reimplement
check_timer_distribution()"), clang warns:

  tools/testing/selftests/timers/../kselftest.h:398:6: warning: variable 'major' is used uninitialized whenever '||' condition is true [-Wsometimes-uninitialized]
    398 |         if (uname(&info) || sscanf(info.release, "%u.%u.", &major, &minor) != 2)
        |             ^~~~~~~~~~~~
  tools/testing/selftests/timers/../kselftest.h:401:9: note: uninitialized use occurs here
    401 |         return major > min_major || (major == min_major && minor >= min_minor);
        |                ^~~~~
  tools/testing/selftests/timers/../kselftest.h:398:6: note: remove the '||' if its condition is always false
    398 |         if (uname(&info) || sscanf(info.release, "%u.%u.", &major, &minor) != 2)
        |             ^~~~~~~~~~~~~~~
  tools/testing/selftests/timers/../kselftest.h:395:20: note: initialize the variable 'major' to silence this warning
    395 |         unsigned int major, minor;
        |                           ^
        |                            = 0

This is a false positive because if uname() fails, ksft_exit_fail_msg()
will be called, which unconditionally calls exit(), a noreturn function.
However, clang does not know that ksft_exit_fail_msg() will call exit() at
the point in the pipeline that the warning is emitted because inlining has
not occurred, so it assumes control flow will resume normally after
ksft_exit_fail_msg() is called.

Make it clear to clang that all of the functions that call exit()
unconditionally in kselftest.h are noreturn transitively by marking them
explicitly with '__attribute__((__noreturn__))', which clears up the
warning above and any future warnings that may appear for the same reason.

Fixes: 6d029c25b71f ("selftests/timers/posix_timers: Reimplement check_timer_distribution()")
Reported-by: John Stultz <jstultz@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240411-mark-kselftest-exit-funcs-noreturn-v1-1-b027c948f586@kernel.org
Closes: https://lore.kernel.org/all/20240410232637.4135564-2-jstultz@google.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kselftest.h |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/kselftest.h
+++ b/tools/testing/selftests/kselftest.h
@@ -79,6 +79,9 @@
 #define KSFT_XPASS 3
 #define KSFT_SKIP  4
 
+#ifndef __noreturn
+#define __noreturn       __attribute__((__noreturn__))
+#endif
 #define __printf(a, b)   __attribute__((format(printf, a, b)))
 
 /* counters */
@@ -255,13 +258,13 @@ static inline __printf(1, 2) void ksft_t
 	va_end(args);
 }
 
-static inline int ksft_exit_pass(void)
+static inline __noreturn int ksft_exit_pass(void)
 {
 	ksft_print_cnts();
 	exit(KSFT_PASS);
 }
 
-static inline int ksft_exit_fail(void)
+static inline __noreturn int ksft_exit_fail(void)
 {
 	ksft_print_cnts();
 	exit(KSFT_FAIL);
@@ -288,7 +291,7 @@ static inline int ksft_exit_fail(void)
 		  ksft_cnt.ksft_xfail +	\
 		  ksft_cnt.ksft_xskip)
 
-static inline __printf(1, 2) int ksft_exit_fail_msg(const char *msg, ...)
+static inline __noreturn __printf(1, 2) int ksft_exit_fail_msg(const char *msg, ...)
 {
 	int saved_errno = errno;
 	va_list args;
@@ -303,19 +306,19 @@ static inline __printf(1, 2) int ksft_ex
 	exit(KSFT_FAIL);
 }
 
-static inline int ksft_exit_xfail(void)
+static inline __noreturn int ksft_exit_xfail(void)
 {
 	ksft_print_cnts();
 	exit(KSFT_XFAIL);
 }
 
-static inline int ksft_exit_xpass(void)
+static inline __noreturn int ksft_exit_xpass(void)
 {
 	ksft_print_cnts();
 	exit(KSFT_XPASS);
 }
 
-static inline __printf(1, 2) int ksft_exit_skip(const char *msg, ...)
+static inline __noreturn __printf(1, 2) int ksft_exit_skip(const char *msg, ...)
 {
 	int saved_errno = errno;
 	va_list args;


