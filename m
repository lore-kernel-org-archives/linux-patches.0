Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6BCBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E814EC433EF;
	Tue,  7 Mar 2023 18:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213912;
	bh=jzmWDFyxSzSnMHvCOwIVFygP0DqPfEpRzXvONz0e8zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmulbORrDPhkW9z17o+KwL7Dd0AWpZKbn5Sdi0Xw8IC3f1WAIM7idsV18Vriyl19E
	 lnTyGDbc5Hp8bWOET77kP8vnVUx7Qvj6zuAVg/qarY5Zp28hJ0P7LC9yH14jDFv4j6
	 Kff4hvC831XcKf/Crp9gJWFq6TFbt/fd8+ojcGqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 659/885] io_uring: handle TIF_NOTIFY_RESUME when checking for task_work
Date: Tue,  7 Mar 2023 17:59:53 +0100
Message-Id: <20230307170030.794808610@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
 io_uring/io_uring.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -3,6 +3,7 @@
 
 #include <linux/errno.h>
 #include <linux/lockdep.h>
+#include <linux/resume_user_mode.h>
 #include <linux/io_uring_types.h>
 #include <uapi/linux/eventpoll.h>
 #include "io-wq.h"
@@ -255,6 +256,13 @@ static inline int io_run_task_work(void)
 	 */
 	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
 		clear_notify_signal();
+	/*
+	 * PF_IO_WORKER never returns to userspace, so check here if we have
+	 * notify work that needs processing.
+	 */
+	if (current->flags & PF_IO_WORKER &&
+	    test_thread_flag(TIF_NOTIFY_RESUME))
+		resume_user_mode_work(NULL);
 	if (task_work_pending(current)) {
 		__set_current_state(TASK_RUNNING);
 		task_work_run();


