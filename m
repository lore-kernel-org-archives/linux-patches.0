Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC88A93C;
	Tue, 13 Feb 2024 17:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707846049; cv=none; b=V7wPDuIgtg4/rc2HwFB0MF3cwEVeaerm74VBLngeJK+ZGDu+nUOZLNa4oEr2zfabIIvDDylgV6ZND2SeEyvXW3FPRKb4AY/Z2hbSKcMuSyfm7QHuffFC/wmvIKpBNxKykttfU+T5n35fnhBwN5JQyJVECxTLeaaadwmbVOpI/5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707846049; c=relaxed/simple;
	bh=uAEW1Nt5n4rzmUGIu7FIeAIiBCFvoxIoWi1sov1IlA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyY8x9ocIsjrMQKiS4KI941bDHlmLBp8gdgsYoQm4tAxTsTn5WN9D5897dtr/EWPl7F3M36aI8BquZuZ345kQg9eyh2L988A3AX6wYgNtNj7T9yGeUONeqyfWRGrmJ5XraygzRNd7ZJrQ/MdO48HNk7eV0BkIgHU+14Of9WspDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NX4qWaxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NX4qWaxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153B1C43390;
	Tue, 13 Feb 2024 17:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707846049;
	bh=uAEW1Nt5n4rzmUGIu7FIeAIiBCFvoxIoWi1sov1IlA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NX4qWaxVWrrNV7gn2nHneedIix6s3h5VKhiWJSaoDxdX0G2+sMmE5OcSDmjBEQxIy
	 /R0S1rVtWpHih4nxC9LidVpFOtmV/oGX6m0fIxpFv2K642wY8rACtfv+pB8tLIMcif
	 IOEgQ8xwzOIckPIoYxnY0giKFesVHvKB8rz99gDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.7 122/124] io_uring/poll: add requeue return code from poll multishot handling
Date: Tue, 13 Feb 2024 18:22:24 +0100
Message-ID: <20240213171857.291558926@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -329,6 +330,8 @@ static int io_poll_check_events(struct i
 			int ret = io_poll_issue(req, ts);
 			if (ret == IOU_STOP_MULTISHOT)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
+			else if (ret == IOU_REQUEUE)
+				return IOU_POLL_REQUEUE;
 			if (ret < 0)
 				return ret;
 		}
@@ -351,8 +354,12 @@ void io_poll_task_func(struct io_kiocb *
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
 


