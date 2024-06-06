Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D388F19A2A4;
	Thu,  6 Jun 2024 14:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683277; cv=none; b=EUiU3hpp4axurXmRr4ZT0/pos+KCbKXmNcSjZmgPcdif5xOBR9XLmQcYcjIyjpq7w0LdN+o6rr/q3UMZNHGY76iCbu8rLZaqd+4BrLV4orCmbZtMYH6lhtfdSHoIo8rufqVdegLqCuo/UUqyqD0XHKsP0jrrOmsTVacMrrFGkas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683277; c=relaxed/simple;
	bh=WkMGRVT0b9mYOnIfDvuZpNg8goUCZ/FUixpAvMY5+L0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=urZjuMVOQDKBMK1d5Cv9rI6k0p/aWQFm70Bfeg85t/RT9idiyJAkpn44jUwUq+iendraDw/YYWHwDx0nh1Sy4rQL0xhOaMfvlnUahrtLyxdYLtMuXren++NlZANxfucLMSuQnR3GMHURp0CCAAQOXo/8kpqxTJ7sLB48uegIGUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ToGS8BR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ToGS8BR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA525C32781;
	Thu,  6 Jun 2024 14:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683277;
	bh=WkMGRVT0b9mYOnIfDvuZpNg8goUCZ/FUixpAvMY5+L0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ToGS8BR+y8d13RDbdt0yIJLMYDY/8R4T3XPRjutQSAG1c3GKe1Onuoh5JokFCJ1Ip
	 R5x7VJ+EZEnSX5Lg/INGIkzD0pFVUu8zv+FeXWo4BywOySAlsoCAUn2yQXrLq8tv0o
	 DR5/5ksA2UmMgjMsYtm6P0iAImpuCby5KSxm2LhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brendan Higgins <brendanhiggins@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kees Cook <keescook@chromium.org>,
	David Gow <davidgow@google.com>,
	Rae Moar <rmoar@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/473] kunit: Fix kthread reference
Date: Thu,  6 Jun 2024 16:01:24 +0200
Message-ID: <20240606131705.083879875@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

[ Upstream commit f8aa1b98ce40184521ed95ec26cc115a255183b2 ]

There is a race condition when a kthread finishes after the deadline and
before the call to kthread_stop(), which may lead to use after free.

Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Fixes: adf505457032 ("kunit: fix UAF when run kfence test case test_gfpzero")
Reviewed-by: David Gow <davidgow@google.com>
Reviewed-by: Rae Moar <rmoar@google.com>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20240408074625.65017-3-mic@digikod.net
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/try-catch.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/kunit/try-catch.c b/lib/kunit/try-catch.c
index f7825991d576a..d9d1df28cc52e 100644
--- a/lib/kunit/try-catch.c
+++ b/lib/kunit/try-catch.c
@@ -11,6 +11,7 @@
 #include <linux/completion.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
+#include <linux/sched/task.h>
 
 #include "try-catch-impl.h"
 
@@ -65,13 +66,14 @@ void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
 	try_catch->context = context;
 	try_catch->try_completion = &try_completion;
 	try_catch->try_result = 0;
-	task_struct = kthread_run(kunit_generic_run_threadfn_adapter,
-				  try_catch,
-				  "kunit_try_catch_thread");
+	task_struct = kthread_create(kunit_generic_run_threadfn_adapter,
+				     try_catch, "kunit_try_catch_thread");
 	if (IS_ERR(task_struct)) {
 		try_catch->catch(try_catch->context);
 		return;
 	}
+	get_task_struct(task_struct);
+	wake_up_process(task_struct);
 
 	time_remaining = wait_for_completion_timeout(&try_completion,
 						     kunit_test_timeout());
@@ -81,6 +83,7 @@ void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
 		kthread_stop(task_struct);
 	}
 
+	put_task_struct(task_struct);
 	exit_code = try_catch->try_result;
 
 	if (!exit_code)
-- 
2.43.0



