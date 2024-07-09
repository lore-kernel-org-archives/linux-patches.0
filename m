Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883DF158A19;
	Tue,  9 Jul 2024 11:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524580; cv=none; b=lDlSE9Ybu2PQksMniFw47bFrHNdvzwvBd0B920Asmp9wLEi4qTnBA0OiSNP5aM1qjjGs8BN+sP7yJNAtK2LmXMdGFtVDmvVsGt7UMApcV2e4TfACD2VdB5llvWPOF4QheH3Cr8q0HRk+3IK02xge8Kl6g8aMkquJU25jaaLLLHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524580; c=relaxed/simple;
	bh=vMPQnpt29QzA9vU8Mwmxw86DnUplP+mEN76MRbHK/L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZvYJ1Qq44lSdEFgY7aKKbMSIg9LrMd6wHZjSd408g5w5FFQP0YiJSZX33AZPYxqZe//3Eh416ctvtPz1mEu421nCi7vmDlBcICdrF07/7rdx/UchXhvbk0fU5KhjwSNI1sRJqXUOVM/2YE2s7fkPIdJR1gd0xlFFCtkd2SeZfuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VR7euxPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VR7euxPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65C7C32786;
	Tue,  9 Jul 2024 11:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524580;
	bh=vMPQnpt29QzA9vU8Mwmxw86DnUplP+mEN76MRbHK/L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VR7euxPk+SSpKAQE84U1jSKpdPYWqcp+f2lhMGKrH01emrxClUR6NjZyUXqZ8T9LZ
	 nMBp4WCvjWWRcBJ7eR5GxP4xHGMCwnS9uyqsh/kOmqtQgk6c3z3jO0e7kzbxejU7YM
	 7vFcELTT17sIoypEJEUPzA6I+8XhemLamzp2oeF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brendan Higgins <brendanhiggins@google.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kees Cook <keescook@chromium.org>,
	David Gow <davidgow@google.com>,
	Rae Moar <rmoar@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/102] kunit: Handle test faults
Date: Tue,  9 Jul 2024 13:09:54 +0200
Message-ID: <20240709110652.582448806@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

[ Upstream commit 3a35c13007dea132a65f07de05c26b87837fadc2 ]

Previously, when a kernel test thread crashed (e.g. NULL pointer
dereference, general protection fault), the KUnit test hanged for 30
seconds and exited with a timeout error.

Fix this issue by waiting on task_struct->vfork_done instead of the
custom kunit_try_catch.try_completion, and track the execution state by
initially setting try_result with -EINTR and only setting it to 0 if
the test passed.

Fix kunit_generic_run_threadfn_adapter() signature by returning 0
instead of calling kthread_complete_and_exit().  Because thread's exit
code is never checked, always set it to 0 to make it clear.  To make
this explicit, export kthread_exit() for KUnit tests built as module.

Fix the -EINTR error message, which couldn't be reached until now.

This is tested with a following patch.

Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Gow <davidgow@google.com>
Tested-by: Rae Moar <rmoar@google.com>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20240408074625.65017-5-mic@digikod.net
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/kunit/try-catch.h |  3 ---
 kernel/kthread.c          |  1 +
 lib/kunit/try-catch.c     | 19 ++++++++++++-------
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/kunit/try-catch.h b/include/kunit/try-catch.h
index c507dd43119d5..7c966a1adbd30 100644
--- a/include/kunit/try-catch.h
+++ b/include/kunit/try-catch.h
@@ -14,13 +14,11 @@
 
 typedef void (*kunit_try_catch_func_t)(void *);
 
-struct completion;
 struct kunit;
 
 /**
  * struct kunit_try_catch - provides a generic way to run code which might fail.
  * @test: The test case that is currently being executed.
- * @try_completion: Completion that the control thread waits on while test runs.
  * @try_result: Contains any errno obtained while running test case.
  * @try: The function, the test case, to attempt to run.
  * @catch: The function called if @try bails out.
@@ -46,7 +44,6 @@ struct kunit;
 struct kunit_try_catch {
 	/* private: internal use only. */
 	struct kunit *test;
-	struct completion *try_completion;
 	int try_result;
 	kunit_try_catch_func_t try;
 	kunit_try_catch_func_t catch;
diff --git a/kernel/kthread.c b/kernel/kthread.c
index f97fd01a29325..742e7c24b29f4 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -305,6 +305,7 @@ void __noreturn kthread_exit(long result)
 	kthread->result = result;
 	do_exit(0);
 }
+EXPORT_SYMBOL(kthread_exit);
 
 /**
  * kthread_complete_and_exit - Exit the current kthread.
diff --git a/lib/kunit/try-catch.c b/lib/kunit/try-catch.c
index 9c9e4dcf06d96..34d30a6f23054 100644
--- a/lib/kunit/try-catch.c
+++ b/lib/kunit/try-catch.c
@@ -18,7 +18,7 @@
 void __noreturn kunit_try_catch_throw(struct kunit_try_catch *try_catch)
 {
 	try_catch->try_result = -EFAULT;
-	kthread_complete_and_exit(try_catch->try_completion, -EFAULT);
+	kthread_exit(0);
 }
 EXPORT_SYMBOL_GPL(kunit_try_catch_throw);
 
@@ -26,9 +26,12 @@ static int kunit_generic_run_threadfn_adapter(void *data)
 {
 	struct kunit_try_catch *try_catch = data;
 
+	try_catch->try_result = -EINTR;
 	try_catch->try(try_catch->context);
+	if (try_catch->try_result == -EINTR)
+		try_catch->try_result = 0;
 
-	kthread_complete_and_exit(try_catch->try_completion, 0);
+	return 0;
 }
 
 static unsigned long kunit_test_timeout(void)
@@ -58,13 +61,11 @@ static unsigned long kunit_test_timeout(void)
 
 void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
 {
-	DECLARE_COMPLETION_ONSTACK(try_completion);
 	struct kunit *test = try_catch->test;
 	struct task_struct *task_struct;
 	int exit_code, time_remaining;
 
 	try_catch->context = context;
-	try_catch->try_completion = &try_completion;
 	try_catch->try_result = 0;
 	task_struct = kthread_create(kunit_generic_run_threadfn_adapter,
 				     try_catch, "kunit_try_catch_thread");
@@ -74,8 +75,12 @@ void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
 	}
 	get_task_struct(task_struct);
 	wake_up_process(task_struct);
-
-	time_remaining = wait_for_completion_timeout(&try_completion,
+	/*
+	 * As for a vfork(2), task_struct->vfork_done (pointing to the
+	 * underlying kthread->exited) can be used to wait for the end of a
+	 * kernel thread.
+	 */
+	time_remaining = wait_for_completion_timeout(task_struct->vfork_done,
 						     kunit_test_timeout());
 	if (time_remaining == 0) {
 		try_catch->try_result = -ETIMEDOUT;
@@ -91,7 +96,7 @@ void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
 	if (exit_code == -EFAULT)
 		try_catch->try_result = 0;
 	else if (exit_code == -EINTR)
-		kunit_err(test, "wake_up_process() was never called\n");
+		kunit_err(test, "try faulted\n");
 	else if (exit_code == -ETIMEDOUT)
 		kunit_err(test, "try timed out\n");
 	else if (exit_code)
-- 
2.43.0



