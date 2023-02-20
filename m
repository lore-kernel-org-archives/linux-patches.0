Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A570863BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B062C43442;
	Mon, 20 Feb 2023 13:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901582;
	bh=CnNDBsju5D2uzWzFIKuWM8hecqUDq8p+RDPq//03iQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1pIyobQNw5KyGi36o+jrq0UpnqFHRkpp3fVNU7633FpVZ+Ig2tWkQwm5yZASDPc+b
	 tV+9UYk4DShAUjCTvzgS3mSdn8uIKXe9WPWHTdRwb6cIwv4XPrgxGywCJ0hqOxIIhk
	 FBOfdCNuOgw8YWDB+HGapjqC36IfyghHpHvqWNQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6cd18e123583550cf469@syzkaller.appspotmail.com,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.1 073/118] freezer,umh: Fix call_usermode_helper_exec() vs SIGKILL
Date: Mon, 20 Feb 2023 14:36:29 +0100
Message-Id: <20230220133603.349883651@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

commit eedeb787ebb53de5c5dcf7b7b39d01bf1b0f037d upstream.

Tetsuo-San noted that commit f5d39b020809 ("freezer,sched: Rewrite
core freezer logic") broke call_usermodehelper_exec() for the KILLABLE
case.

Specifically it was missed that the second, unconditional,
wait_for_completion() was not optional and ensures the on-stack
completion is unused before going out-of-scope.

Fixes: f5d39b020809 ("freezer,sched: Rewrite core freezer logic")
Reported-by: syzbot+6cd18e123583550cf469@syzkaller.appspotmail.com
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Debugged-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/Y90ar35uKQoUrLEK@hirez.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/umh.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/kernel/umh.c b/kernel/umh.c
index 850631518665..fbf872c624cb 100644
--- a/kernel/umh.c
+++ b/kernel/umh.c
@@ -438,21 +438,27 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 	if (wait == UMH_NO_WAIT)	/* task has freed sub_info */
 		goto unlock;
 
-	if (wait & UMH_KILLABLE)
-		state |= TASK_KILLABLE;
-
 	if (wait & UMH_FREEZABLE)
 		state |= TASK_FREEZABLE;
 
-	retval = wait_for_completion_state(&done, state);
-	if (!retval)
-		goto wait_done;
-
 	if (wait & UMH_KILLABLE) {
+		retval = wait_for_completion_state(&done, state | TASK_KILLABLE);
+		if (!retval)
+			goto wait_done;
+
 		/* umh_complete() will see NULL and free sub_info */
 		if (xchg(&sub_info->complete, NULL))
 			goto unlock;
+
+		/*
+		 * fallthrough; in case of -ERESTARTSYS now do uninterruptible
+		 * wait_for_completion_state(). Since umh_complete() shall call
+		 * complete() in a moment if xchg() above returned NULL, this
+		 * uninterruptible wait_for_completion_state() will not block
+		 * SIGKILL'ed processes for long.
+		 */
 	}
+	wait_for_completion_state(&done, state);
 
 wait_done:
 	retval = sub_info->retval;
-- 
2.39.1



