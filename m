Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0AE8821
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76624C4339E;
	Fri, 10 Mar 2023 15:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460556;
	bh=IIMQdk/pq2T6PUL9kEChOSc+fiB1XAYvRjkMCWhn9lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7rXedpg4VQpk7n5Gr7ewUvdQNPj7JpW6Lo+JZSOK8/DXYWXyB1HkwvAWFtE000IU
	 3/RY1EtjTrYkVjcqVw2QmavMiTrd7pmx3RjMs6uVKdF/skgAqI8XjX1e+c5S66D7gW
	 QucdDOX1FJ9QTmZWsWrB8fUBZc/dQ3Y6fiUjQT3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 373/529] io_uring: handle TIF_NOTIFY_RESUME when checking for task_work
Date: Fri, 10 Mar 2023 14:38:36 +0100
Message-Id: <20230310133822.278967669@linuxfoundation.org>
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

commit b5d3ae202fbfe055aa2a8ae8524531ee1dcab717 upstream.

If TIF_NOTIFY_RESUME is set, then we need to call resume_user_mode_work()
for PF_IO_WORKER threads. They never return to usermode, hence never get
a chance to process any items that are marked by this flag. Most notably
this includes the final put of files, but also any throttling markers set
by block cgroups.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2460,6 +2460,13 @@ static inline unsigned int io_put_rw_kbu
 
 static inline bool io_run_task_work(void)
 {
+	/*
+	 * PF_IO_WORKER never returns to userspace, so check here if we have
+	 * notify work that needs processing.
+	 */
+	if (current->flags & PF_IO_WORKER &&
+	    test_thread_flag(TIF_NOTIFY_RESUME))
+		tracehook_notify_resume(NULL);
 	if (test_thread_flag(TIF_NOTIFY_SIGNAL) || current->task_works) {
 		__set_current_state(TASK_RUNNING);
 		tracehook_notify_signal();


