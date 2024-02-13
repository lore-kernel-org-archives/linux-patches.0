Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C244D5FF04;
	Tue, 13 Feb 2024 17:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845579; cv=none; b=LXOJqOzPl3QUFKk43NNyX9f4e7Hy+/vX0ITmOII26s0vYfQcLy8H3wdman45yObQZJAjzWwP6JKlS2wHlsJc4wrBLjLT5VyXAzm2uxXREXJAJs+WrTUirLi5fD7OYbsLVC7I7RYkd16xSzRwvLnaPK9YJ+MaiL6OW7HTzRw5E4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845579; c=relaxed/simple;
	bh=3XaMkirfwC0HLumJGOtWBkRo7mH4fHYx1CcTrJMmqBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXlIVdV5r8Gu9yRkwDH32XHMn71FlSVFPIeytZ0EJvAOb2wBb0ujOSNdAwQGpHOTC4onkxidRsoxeUd8bI6bht9yCX6WAbxyA2ArbYGh9a0OfgOefUDrEzdsg1ps8a1Rdg0NaYFYc2nRKBHE1KA+JPMRz7Wyc6sknuWliAeqdH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wEiTLIZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wEiTLIZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9348C433F1;
	Tue, 13 Feb 2024 17:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845577;
	bh=3XaMkirfwC0HLumJGOtWBkRo7mH4fHYx1CcTrJMmqBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wEiTLIZc64s2JSCb+cqzxNW0nSddM5GrZy9dwfx2obJh1HzflfNfNx57KSsmTXTqQ
	 NwZ6VxOHN4ppii8ESoJ2bYkt2mK8l38vJ0OiYxLYQj15teL8RXTa3pWb/4pTK0FJAy
	 bOqxFFTXexisttxUFnTIVU1ji5IhU335v8oy5wXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 120/121] io_uring/poll: add requeue return code from poll multishot handling
Date: Tue, 13 Feb 2024 18:22:09 +0100
Message-ID: <20240213171856.488704650@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 704ea888d646cb9d715662944cf389c823252ee0 upstream.

Since our poll handling is edge triggered, multishot handlers retry
internally until they know that no more data is available. In
preparation for limiting these retries, add an internal return code,
IOU_REQUEUE, which can be used to inform the poll backend about the
handler wanting to retry, but that this should happen through a normal
task_work requeue rather than keep hammering on the issue side for this
one request.

No functional changes in this patch, nobody is using this return code
just yet.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.h |    7 +++++++
 io_uring/poll.c     |    9 ++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -31,6 +31,13 @@ enum {
 	IOU_ISSUE_SKIP_COMPLETE	= -EIOCBQUEUED,
 
 	/*
+	 * Requeue the task_work to restart operations on this request. The
+	 * actual value isn't important, should just be not an otherwise
+	 * valid error code, yet less than -MAX_ERRNO and valid internally.
+	 */
+	IOU_REQUEUE		= -3072,
+
+	/*
 	 * Intended only when both IO_URING_F_MULTISHOT is passed
 	 * to indicate to the poll runner that multishot should be
 	 * removed and the result is set on req->cqe.res.
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -226,6 +226,7 @@ enum {
 	IOU_POLL_NO_ACTION = 1,
 	IOU_POLL_REMOVE_POLL_USE_RES = 2,
 	IOU_POLL_REISSUE = 3,
+	IOU_POLL_REQUEUE = 4,
 };
 
 static void __io_poll_execute(struct io_kiocb *req, int mask)
@@ -324,6 +325,8 @@ static int io_poll_check_events(struct i
 			int ret = io_poll_issue(req, ts);
 			if (ret == IOU_STOP_MULTISHOT)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
+			else if (ret == IOU_REQUEUE)
+				return IOU_POLL_REQUEUE;
 			if (ret < 0)
 				return ret;
 		}
@@ -346,8 +349,12 @@ void io_poll_task_func(struct io_kiocb *
 	int ret;
 
 	ret = io_poll_check_events(req, ts);
-	if (ret == IOU_POLL_NO_ACTION)
+	if (ret == IOU_POLL_NO_ACTION) {
 		return;
+	} else if (ret == IOU_POLL_REQUEUE) {
+		__io_poll_execute(req, 0);
+		return;
+	}
 	io_poll_remove_entries(req);
 	io_poll_tw_hash_eject(req, ts);
 


