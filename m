Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDEFBA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00A2C433EF;
	Tue,  7 Mar 2023 19:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678216150;
	bh=hAzv0L4n81NbYOSx3XXzwaGEcB+6Kf9kUvCrka6XVN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yHkt48+CwnE4bPIRuwJVbRi5Fa6XTMVUL0nY9Taz+W9ZjZ7Q6BubwAg0d96OZtANa
	 0hdDdQtMNhUg6tZaWXk9w6vQPqbGqy4DMSNRSccXjzIba/icCtCJZxrpUP7ff68DEf
	 B+lDYs8nFbDPZKKhiOL0tJj8IMkDmFGHIThcmYVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 491/567] io_uring: mark task TASK_RUNNING before handling resume/task work
Date: Tue,  7 Mar 2023 18:03:47 +0100
Message-Id: <20230307165927.224227182@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

commit 2f2bb1ffc9983e227424d0787289da5483b0c74f upstream.

Just like for task_work, set the task mode to TASK_RUNNING before doing
potential resume work. We're not holding any locks at this point,
but we may have already set the task state to TASK_INTERRUPTIBLE in
preparation for going to sleep waiting for events. Ensure that we set it
back to TASK_RUNNING if we have work to process, to avoid warnings on
calling blocking operations with !TASK_RUNNING.

Fixes: b5d3ae202fbf ("io_uring: handle TIF_NOTIFY_RESUME when checking for task_work")
Reported-by: kernel test robot <oliver.sang@intel.com>
Link: https://lore.kernel.org/oe-lkp/202302062208.24d3e563-oliver.sang@intel.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2468,8 +2468,10 @@ static inline bool io_run_task_work(void
 	 * notify work that needs processing.
 	 */
 	if (current->flags & PF_IO_WORKER &&
-	    test_thread_flag(TIF_NOTIFY_RESUME))
+	    test_thread_flag(TIF_NOTIFY_RESUME)) {
+		__set_current_state(TASK_RUNNING);
 		tracehook_notify_resume(NULL);
+	}
 	if (test_thread_flag(TIF_NOTIFY_SIGNAL) || current->task_works) {
 		__set_current_state(TASK_RUNNING);
 		tracehook_notify_signal();


