Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B5F262BE;
	Mon, 27 May 2024 19:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838139; cv=none; b=FggQBRUZaVZ2zOYzos6c0UD7BW+0RfXD19xrRxJ+PNbv9kO1D3azvRUcSAcTBbJRPY550r38kKkK5k+rKkcdeqAM6SENfimrJNCcepsPzJyHgAJuwHPavB0wUjluB8uzH6Hd9p7Foc9jB0DKobpOPSdLzVchSrlaR4c6lFh6oMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838139; c=relaxed/simple;
	bh=ftPdcez4nZgeJ9UCg6hW7X8lBFw3MJUon4NweT5DcSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KtI1GdAQ8jq0lu+X6TlkS0ubn/ThIp3kTdO49Wi+URAQbETQ6Fwnmd7Wv/PGE3lHqnUR0zROGSD65YgE5ZsTKD+ZLbHR/vWzw8XgIdTdh3tX5o6sn3cpNWU2CyQw9M9AoTdTgUplzdix+AEt960TjfrRHuOccFYU9+zLaxnoAvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y7+ssx87; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y7+ssx87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50744C2BBFC;
	Mon, 27 May 2024 19:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838139;
	bh=ftPdcez4nZgeJ9UCg6hW7X8lBFw3MJUon4NweT5DcSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y7+ssx87gRcif555mFk/qOCFs5qjvgsxTKNd0mSnqsJtSBfygY6ET9j2if8KZi/vP
	 wdNa8ash0uIE+DQ6p9cWtyWn18DlSuv7SJKBQjf7AkHGNpNZEcpRpb/DUhbTQvRwAI
	 9V3QHpmomiuPIwIkoQSrA47zdpL45krzv2J1kRzI=
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
Subject: [PATCH 6.8 281/493] kunit: Fix kthread reference
Date: Mon, 27 May 2024 20:54:43 +0200
Message-ID: <20240527185639.499704509@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



