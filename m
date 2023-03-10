Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0975C8821
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA23C433D2;
	Fri, 10 Mar 2023 15:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460559;
	bh=egW0id/2GxR0x5DYz7fpM1U0TR/awPryNL9uOmWQ6FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJFLJlSXIf6bHFt9w0an7QUm4qk5jnhDI2EKx3yo3VCxmSo10ySkikQpIu0vaQaSq
	 MizwQMx5nEdgxwHykDElc7k5qEkSwrnr5KUJthZCpOSdafsAiBXvSq/Ut/u1EaFLnV
	 JjiXyuINDjk6NRlatHxb2lsJyg4haPg+oQW5hq+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 374/529] io_uring: mark task TASK_RUNNING before handling resume/task work
Date: Fri, 10 Mar 2023 14:38:37 +0100
Message-Id: <20230310133822.331319625@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
@@ -2465,8 +2465,10 @@ static inline bool io_run_task_work(void
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


