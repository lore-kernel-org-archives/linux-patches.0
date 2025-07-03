Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234772EA49E;
	Thu,  3 Jul 2025 14:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554428; cv=none; b=OFWJq5w/Vnj9y78ox6xxfHWVtZl5idNbCppe8X+wZUX92DLfUipnsqJvuopRDETV+BDtm+ZypXLbOjyH4QjMLjqdF5cPPxXYaCfWWG8yqhLLHMYylzJ/lY7r0rwS6U4VMy9QtT+EmdYZ1ZYRUNRRn7UNeA64O6w1utnxgAxTMFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554428; c=relaxed/simple;
	bh=oUWmiUfmbd935qUgI3aA94tnGgk6dV1MY39EhyyO4tA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pm352eZNpXIJ54AqXm4aROfvmsiMh4RWg9Bs4Ba2cnomQQY85I6xnOPX1+h6MELIn1YhahW8nak9AgQHGYV3iacXKAcGMMaawQ5UVVa7I2D6L6Vj7ZPXF+qr9YX8MTbiqOdTr0ovf5EBK339ZkYrwm1hKeDEk0SzzW6qfpCSLOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0+lqOnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0+lqOnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1E0C4CEED;
	Thu,  3 Jul 2025 14:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554427;
	bh=oUWmiUfmbd935qUgI3aA94tnGgk6dV1MY39EhyyO4tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0+lqOnKikkzFCtjCGTv2f32Djv0m6w97dEQ2y56wu78C+61+BhH52vqj8SHyTWCH
	 8joZKdQMHkfIS2sP2OKJL5vMm0hUpaY6pGB+QncG52rDMGXJ1mjBXM8Ag75XKev+JF
	 6Mh4g1fiZacAH212u5tFduvbvoyungRTq54WpKMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norman Maurer <norman_maurer@apple.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 184/218] io_uring/net: improve recv bundles
Date: Thu,  3 Jul 2025 16:42:12 +0200
Message-ID: <20250703144003.540295586@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 7c71a0af81ba72de9b2c501065e4e718aba9a271 upstream.

Current recv bundles are only supported for multishot receives, and
additionally they also always post at least 2 CQEs if more data is
available than what a buffer will hold. This happens because the initial
bundle recv will do a single buffer, and then do the rest of what is in
the socket as a followup receive. As shown in a test program, if 1k
buffers are available and 32k is available to receive in the socket,
you'd get the following completions:

bundle=1, mshot=0
cqe res 1024
cqe res 1024
[...]
cqe res 1024

bundle=1, mshot=1
cqe res 1024
cqe res 31744

where bundle=1 && mshot=0 will post 32 1k completions, and bundle=1 &&
mshot=1 will post a 1k completion and then a 31k completion.

To support bundle recv without multishot, it's possible to simply retry
the recv immediately and post a single completion, rather than split it
into two completions. With the below patch, the same test looks as
follows:

bundle=1, mshot=0
cqe res 32768

bundle=1, mshot=1
cqe res 32768

where mshot=0 works fine for bundles, and both of them post just a
single 32k completion rather than split it into separate completions.
Posting fewer completions is always a nice win, and not needing
multishot for proper bundle efficiency is nice for cases that can't
necessarily use multishot.

Reported-by: Norman Maurer <norman_maurer@apple.com>
Link: https://lore.kernel.org/r/184f9f92-a682-4205-a15d-89e18f664502@kernel.dk
Fixes: 2f9c9515bdfd ("io_uring/net: support bundles for recv")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -76,6 +76,7 @@ struct io_sr_msg {
 	/* initialised and used only by !msg send variants */
 	u16				addr_len;
 	u16				buf_group;
+	bool				retry;
 	void __user			*addr;
 	void __user			*msg_control;
 	/* used only for send zerocopy */
@@ -203,6 +204,7 @@ static inline void io_mshot_prep_retry(s
 
 	req->flags &= ~REQ_F_BL_EMPTY;
 	sr->done_io = 0;
+	sr->retry = false;
 	sr->len = 0; /* get from the provided buffer */
 	req->buf_index = sr->buf_group;
 }
@@ -409,6 +411,7 @@ int io_sendmsg_prep(struct io_kiocb *req
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	sr->done_io = 0;
+	sr->retry = false;
 
 	if (req->opcode == IORING_OP_SEND) {
 		if (READ_ONCE(sqe->__pad3[0]))
@@ -780,6 +783,7 @@ int io_recvmsg_prep(struct io_kiocb *req
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	sr->done_io = 0;
+	sr->retry = false;
 
 	if (unlikely(sqe->file_index || sqe->addr2))
 		return -EINVAL;
@@ -828,6 +832,9 @@ int io_recvmsg_prep(struct io_kiocb *req
 	return io_recvmsg_prep_setup(req);
 }
 
+/* bits to clear in old and inherit in new cflags on bundle retry */
+#define CQE_F_MASK	(IORING_CQE_F_SOCK_NONEMPTY|IORING_CQE_F_MORE)
+
 /*
  * Finishes io_recv and io_recvmsg.
  *
@@ -847,9 +854,19 @@ static inline bool io_recv_finish(struct
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
 		cflags |= io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, *ret),
 				      issue_flags);
+		if (sr->retry)
+			cflags = req->cqe.flags | (cflags & CQE_F_MASK);
 		/* bundle with no more immediate buffers, we're done */
 		if (req->flags & REQ_F_BL_EMPTY)
 			goto finish;
+		/* if more is available, retry and append to this one */
+		if (!sr->retry && kmsg->msg.msg_inq > 0 && *ret > 0) {
+			req->cqe.flags = cflags & ~CQE_F_MASK;
+			sr->len = kmsg->msg.msg_inq;
+			sr->done_io += *ret;
+			sr->retry = true;
+			return false;
+		}
 	} else {
 		cflags |= io_put_kbuf(req, *ret, issue_flags);
 	}
@@ -1228,6 +1245,7 @@ int io_send_zc_prep(struct io_kiocb *req
 	struct io_kiocb *notif;
 
 	zc->done_io = 0;
+	zc->retry = false;
 	req->flags |= REQ_F_POLL_NO_LAZY;
 
 	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))


