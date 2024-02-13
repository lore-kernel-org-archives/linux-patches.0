Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B05C128;
	Tue, 13 Feb 2024 17:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845971; cv=none; b=psX2RorvMtsvPxIhD3BjI+2ZZW6X0ODCphU4LC1zaeT4CLaYgW8TNMhYcC/FRBZwMS/od0h65Oqdf181tlyprmA08zabgNPO+iYzOdNPWs9jqvmGh6H5h9/dEjRTSF7VDzqUtvyVjshfGrvBhVzrdWtp5t7rd3jrNDqZjdekSw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845971; c=relaxed/simple;
	bh=xbmfULTMzYFdNHGygOs11RDNeON0qU7BlllXGoWSXEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/r3YNa4a8wC6gEg4TRiSl9C2BsxSDHou59WmkGV2wtGM5jOZDA02Sk2ce9M1gQprJxA694zZtv5W6t3HenwXEZKVEsDU7g/uymANvVkRvGpE2HpqR9cr9EzS8qOzriJzy8dzAjOZwa23tQ1fH6PlSeRMFwzMtR+njYrFoRwp/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n0dqGBay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n0dqGBay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAE7C43390;
	Tue, 13 Feb 2024 17:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845971;
	bh=xbmfULTMzYFdNHGygOs11RDNeON0qU7BlllXGoWSXEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n0dqGBayZHRiBkE62lxG+eAgKwP77h3WaCb7fj/szFcuYznWKAWa9HvcukwDyaDDX
	 52nUI25ybbSnORJAQu5E6wY+ymhIs3QGbIXHlAHZSPigPWIHR/tdF4qQGRk4mQTWN1
	 WmvSEMIxeLs2GyRr5IYnI60HpYlSAducpsciIcl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.7 108/124] io_uring/rw: ensure poll based multishot read retries appropriately
Date: Tue, 13 Feb 2024 18:22:10 +0100
Message-ID: <20240213171856.882957889@linuxfoundation.org>
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

commit c79f52f0656eeb3e4a12f7f358f760077ae111b6 upstream.

io_read_mshot() always relies on poll triggering retries, and this works
fine as long as we do a retry per size of the buffer being read. The
buffer size is given by the size of the buffer(s) in the given buffer
group ID.

But if we're reading less than what is available, then we don't always
get to read everything that is available. For example, if the buffers
available are 32 bytes and we have 64 bytes to read, then we'll
correctly read the first 32 bytes and then wait for another poll trigger
before we attempt the next read. This next poll trigger may never
happen, in which case we just sit forever and never make progress, or it
may trigger at some point in the future, and now we're just delivering
the available data much later than we should have.

io_read_mshot() could do retries itself, but that is wasteful as we'll
be going through all of __io_read() again, and most likely in vain.
Rather than do that, bump our poll reference count and have
io_poll_check_events() do one more loop and check with vfs_poll() if we
have more data to read. If we do, io_read_mshot() will get invoked again
directly and we'll read the next chunk.

io_poll_multishot_retry() must only get called from inside
io_poll_issue(), which is our multishot retry handler, as we know we
already "own" the request at this point.

Cc: stable@vger.kernel.org
Link: https://github.com/axboe/liburing/issues/1041
Fixes: fc68fcda0491 ("io_uring/rw: add support for IORING_OP_READ_MULTISHOT")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.h |    9 +++++++++
 io_uring/rw.c   |   10 +++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -24,6 +24,15 @@ struct async_poll {
 	struct io_poll		*double_poll;
 };
 
+/*
+ * Must only be called inside issue_flags & IO_URING_F_MULTISHOT, or
+ * potentially other cases where we already "own" this poll request.
+ */
+static inline void io_poll_multishot_retry(struct io_kiocb *req)
+{
+	atomic_inc(&req->poll_refs);
+}
+
 int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_poll_add(struct io_kiocb *req, unsigned int issue_flags);
 
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -18,6 +18,7 @@
 #include "opdef.h"
 #include "kbuf.h"
 #include "rsrc.h"
+#include "poll.h"
 #include "rw.h"
 
 struct io_rw {
@@ -956,8 +957,15 @@ int io_read_mshot(struct io_kiocb *req,
 		if (io_fill_cqe_req_aux(req,
 					issue_flags & IO_URING_F_COMPLETE_DEFER,
 					ret, cflags | IORING_CQE_F_MORE)) {
-			if (issue_flags & IO_URING_F_MULTISHOT)
+			if (issue_flags & IO_URING_F_MULTISHOT) {
+				/*
+				 * Force retry, as we might have more data to
+				 * be read and otherwise it won't get retried
+				 * until (if ever) another poll is triggered.
+				 */
+				io_poll_multishot_retry(req);
 				return IOU_ISSUE_SKIP_COMPLETE;
+			}
 			return -EAGAIN;
 		}
 	}


