Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC280285072;
	Tue, 17 Jun 2025 16:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177013; cv=none; b=tJbUULyGq7BquurMYDqxDcVaw+sdqurOrbz6w8KFucpzghO9+OvihMO16k6CCctkInrndPz2IniIyGLCPXpLEbxZXuREyE2dtcIz/udoEmJlQ8FIVYcxhbcJzdkC5brlNjJKGAY8bxqA+1j2EUvETrOD0DW9KLeXjv7cJ8yPGcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177013; c=relaxed/simple;
	bh=EhBziKREUC14haSdgn1dUFHecoF41cbrC6QoqxZ6GO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8oV6ILYBXBjypgOqUvCEuA4HwuiGadliAsO1LM9wvjVt2MEG/I8b2wm0fKvWniHw1GzmsGZSuzvucgItQMtBoCZqMCntz+S65u2/0KD0AjVpqyxKLFf9qhsmjd426V0RjBt9jCvvhCSYdb3nf25uNWD6JOM/ddGYxMFuw0tyrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6DorLT7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6DorLT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD0EC4CEE3;
	Tue, 17 Jun 2025 16:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177013;
	bh=EhBziKREUC14haSdgn1dUFHecoF41cbrC6QoqxZ6GO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6DorLT7R1M05/CLRmFZd6DsI7ZiQv8ZtAmidTs4ZuJvj0/19ht/xcAUuExYDTAZO
	 aVQ4zBaAxxOrDrVlh0tINf0NZKvhb8hR3g8Oa+6uzXFbeJWbiK5putN4tBRDy2ytZd
	 8khFXj+SlZdtYTZoLuzg11sPXXRADf8p2EuloUZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 339/356] io_uring: add io_file_can_poll() helper
Date: Tue, 17 Jun 2025 17:27:34 +0200
Message-ID: <20250617152351.776583214@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
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

Commit 95041b93e90a06bb613ec4bef9cd4d61570f68e4 upstream.

This adds a flag to avoid dipping dereferencing file and then f_op to
figure out if the file has a poll handler defined or not. We generally
call this at least twice for networked workloads, and if using ring
provided buffers, we do it on every buffer selection. Particularly the
latter is troublesome, as it's otherwise a very fast operation.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring_types.h |    3 +++
 io_uring/io_uring.c            |    2 +-
 io_uring/io_uring.h            |   12 ++++++++++++
 io_uring/kbuf.c                |    3 +--
 io_uring/poll.c                |    2 +-
 io_uring/rw.c                  |    4 ++--
 6 files changed, 20 insertions(+), 6 deletions(-)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -416,6 +416,7 @@ enum {
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
+	REQ_F_CAN_POLL_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -483,6 +484,8 @@ enum {
 	REQ_F_CLEAR_POLLIN	= BIT(REQ_F_CLEAR_POLLIN_BIT),
 	/* hashed into ->cancel_hash_locked, protected by ->uring_lock */
 	REQ_F_HASH_LOCKED	= BIT(REQ_F_HASH_LOCKED_BIT),
+	/* file is pollable */
+	REQ_F_CAN_POLL		= BIT(REQ_F_CAN_POLL_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1953,7 +1953,7 @@ fail:
 	if (req->flags & REQ_F_FORCE_ASYNC) {
 		bool opcode_poll = def->pollin || def->pollout;
 
-		if (opcode_poll && file_can_poll(req->file)) {
+		if (opcode_poll && io_file_can_poll(req)) {
 			needs_poll = true;
 			issue_flags |= IO_URING_F_NONBLOCK;
 		}
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -5,6 +5,7 @@
 #include <linux/lockdep.h>
 #include <linux/resume_user_mode.h>
 #include <linux/kasan.h>
+#include <linux/poll.h>
 #include <linux/io_uring_types.h>
 #include <uapi/linux/eventpoll.h>
 #include "io-wq.h"
@@ -410,4 +411,15 @@ static inline size_t uring_sqe_size(stru
 		return 2 * sizeof(struct io_uring_sqe);
 	return sizeof(struct io_uring_sqe);
 }
+
+static inline bool io_file_can_poll(struct io_kiocb *req)
+{
+	if (req->flags & REQ_F_CAN_POLL)
+		return true;
+	if (file_can_poll(req->file)) {
+		req->flags |= REQ_F_CAN_POLL;
+		return true;
+	}
+	return false;
+}
 #endif
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -148,8 +148,7 @@ static void __user *io_ring_buffer_selec
 	req->buf_list = bl;
 	req->buf_index = buf->bid;
 
-	if (issue_flags & IO_URING_F_UNLOCKED ||
-	    (req->file && !file_can_poll(req->file))) {
+	if (issue_flags & IO_URING_F_UNLOCKED || !io_file_can_poll(req)) {
 		/*
 		 * If we came in unlocked, we have no choice but to consume the
 		 * buffer here, otherwise nothing ensures that the buffer won't
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -717,7 +717,7 @@ int io_arm_poll_handler(struct io_kiocb
 
 	if (!def->pollin && !def->pollout)
 		return IO_APOLL_ABORTED;
-	if (!file_can_poll(req->file))
+	if (!io_file_can_poll(req))
 		return IO_APOLL_ABORTED;
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT))
 		mask |= EPOLLONESHOT;
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -629,7 +629,7 @@ static bool io_rw_should_retry(struct io
 	 * just use poll if we can, and don't attempt if the fs doesn't
 	 * support callback based unlocks
 	 */
-	if (file_can_poll(req->file) || !(req->file->f_mode & FMODE_BUF_RASYNC))
+	if (io_file_can_poll(req) || !(req->file->f_mode & FMODE_BUF_RASYNC))
 		return false;
 
 	wait->wait.func = io_async_buf_func;
@@ -783,7 +783,7 @@ static int __io_read(struct io_kiocb *re
 	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
 		req->flags &= ~REQ_F_REISSUE;
 		/* if we can poll, just do that */
-		if (req->opcode == IORING_OP_READ && file_can_poll(req->file))
+		if (req->opcode == IORING_OP_READ && io_file_can_poll(req))
 			return -EAGAIN;
 		/* IOPOLL retry should happen for io-wq threads */
 		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))


