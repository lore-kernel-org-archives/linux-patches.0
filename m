Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AC98821
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A596BC433D2;
	Fri, 10 Mar 2023 15:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460620;
	bh=yqzQAOlMQNaUUbonyPI6kr8UocprRrRpLe2WDssuFYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cubbq4B7Nyt9c3WeW8zctDF4JsVmEnTjTa+s06NWkogq2Ix0DyTG46IKRE/S7G8JU
	 s0I5BBZ5RV0XBXXI/X8XWCCZURAianXR+U9C3o+mn7mRqp9CgTntFR7QJhY00vK3tD
	 3aOv4H56HiH60xbcvqnSf6iXWkGI4ZFBkpQZ3ao8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 378/529] io_uring/poll: allow some retries for poll triggering spuriously
Date: Fri, 10 Mar 2023 14:38:41 +0100
Message-Id: <20230310133822.519205768@linuxfoundation.org>
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

commit c16bda37594f83147b167d381d54c010024efecf upstream.

If we get woken spuriously when polling and fail the operation with
-EAGAIN again, then we generally only allow polling again if data
had been transferred at some point. This is indicated with
REQ_F_PARTIAL_IO. However, if the spurious poll triggers when the socket
was originally empty, then we haven't transferred data yet and we will
fail the poll re-arm. This either punts the socket to io-wq if it's
blocking, or it fails the request with -EAGAIN if not. Neither condition
is desirable, as the former will slow things down, while the latter
will make the application confused.

We want to ensure that a repeated poll trigger doesn't lead to infinite
work making no progress, that's what the REQ_F_PARTIAL_IO check was
for. But it doesn't protect against a loop post the first receive, and
it's unnecessarily strict if we started out with an empty socket.

Add a somewhat random retry count, just to put an upper limit on the
potential number of retries that will be done. This should be high enough
that we won't really hit it in practice, unless something needs to be
aborted anyway.

Cc: stable@vger.kernel.org # v5.10+
Link: https://github.com/axboe/liburing/issues/364
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -486,6 +486,7 @@ struct io_poll_iocb {
 	struct file			*file;
 	struct wait_queue_head		*head;
 	__poll_t			events;
+	int				retries;
 	struct wait_queue_entry		wait;
 };
 
@@ -5749,6 +5750,14 @@ enum {
 	IO_APOLL_READY
 };
 
+/*
+ * We can't reliably detect loops in repeated poll triggers and issue
+ * subsequently failing. But rather than fail these immediately, allow a
+ * certain amount of retries before we give up. Given that this condition
+ * should _rarely_ trigger even once, we should be fine with a larger value.
+ */
+#define APOLL_MAX_RETRY		128
+
 static int io_arm_poll_handler(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
@@ -5760,8 +5769,6 @@ static int io_arm_poll_handler(struct io
 
 	if (!req->file || !file_can_poll(req->file))
 		return IO_APOLL_ABORTED;
-	if ((req->flags & (REQ_F_POLLED|REQ_F_PARTIAL_IO)) == REQ_F_POLLED)
-		return IO_APOLL_ABORTED;
 	if (!def->pollin && !def->pollout)
 		return IO_APOLL_ABORTED;
 
@@ -5779,8 +5786,13 @@ static int io_arm_poll_handler(struct io
 	if (req->flags & REQ_F_POLLED) {
 		apoll = req->apoll;
 		kfree(apoll->double_poll);
+		if (unlikely(!--apoll->poll.retries)) {
+			apoll->double_poll = NULL;
+			return IO_APOLL_ABORTED;
+		}
 	} else {
 		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
+		apoll->poll.retries = APOLL_MAX_RETRY;
 	}
 	if (unlikely(!apoll))
 		return IO_APOLL_ABORTED;


