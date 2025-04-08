Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F6A21ADAE;
	Tue,  8 Apr 2025 11:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110533; cv=none; b=A/i57ful0evB69KPhN0zNA608l7O+cZy64MQGhZL/ShlT3HB418UbvuQCEevt2ExhtvGzwUaL/3d3zyZHH5F2VEn2hqzG5OYk7HEemd8bw+SNlbjQ1mcn3TsPCN2emOhp7ZWE9+i+/LKtP51Sxxxc7lVAjJupcHKzQDzPxbdQXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110533; c=relaxed/simple;
	bh=Yy8m4qcvTjYzcv/l0ZH1aj+DJdfuttKR5r7o0VlmE4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iM0EWj2iiDFMhzkdNKHUnojJb1p0HNMflOSspgMM+BQSA7X6sOzQKMCYhuKO77AyfK659/CZFVV1NHrAscuNViO1kFHwsLKZWApDn+GNmdwojwryYwFBeQ+QkRERV+V0IO3KCeWpxBL+YjKS54IcZrCD1WjyogSbkgcwIQ+PDok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jECiLibb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jECiLibb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94ABC4CEE7;
	Tue,  8 Apr 2025 11:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110533;
	bh=Yy8m4qcvTjYzcv/l0ZH1aj+DJdfuttKR5r7o0VlmE4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jECiLibbLVAH2NEbqz5Krs4B3SpQK6k7gQIWGOd6TWjye6k0jSbnC9bxJI1Ge9abI
	 Lcg7kdgZDt8pNkQZh91WTlrU5GPpq5CDY6FKnqtYn4DZgV2oxM4T8a7Ms2lbe3FsGN
	 DAIlackd8f4eMyzplB3NPNgZ0mbt3HmyDEgTDoyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norman Maurer <norman_maurer@apple.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 100/731] io_uring/net: improve recv bundles
Date: Tue,  8 Apr 2025 12:39:57 +0200
Message-ID: <20250408104916.595769758@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 7c71a0af81ba72de9b2c501065e4e718aba9a271 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/net.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 50e8a3ccc9de9..e9bea0235c130 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -76,6 +76,7 @@ struct io_sr_msg {
 	/* initialised and used only by !msg send variants */
 	u16				buf_group;
 	u16				buf_index;
+	bool				retry;
 	void __user			*msg_control;
 	/* used only for send zerocopy */
 	struct io_kiocb 		*notif;
@@ -187,6 +188,7 @@ static inline void io_mshot_prep_retry(struct io_kiocb *req,
 
 	req->flags &= ~REQ_F_BL_EMPTY;
 	sr->done_io = 0;
+	sr->retry = false;
 	sr->len = 0; /* get from the provided buffer */
 	req->buf_index = sr->buf_group;
 }
@@ -404,6 +406,7 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	sr->done_io = 0;
+	sr->retry = false;
 
 	if (req->opcode != IORING_OP_SEND) {
 		if (sqe->addr2 || sqe->file_index)
@@ -786,6 +789,7 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	sr->done_io = 0;
+	sr->retry = false;
 
 	if (unlikely(sqe->file_index || sqe->addr2))
 		return -EINVAL;
@@ -834,6 +838,9 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return io_recvmsg_prep_setup(req);
 }
 
+/* bits to clear in old and inherit in new cflags on bundle retry */
+#define CQE_F_MASK	(IORING_CQE_F_SOCK_NONEMPTY|IORING_CQE_F_MORE)
+
 /*
  * Finishes io_recv and io_recvmsg.
  *
@@ -853,9 +860,19 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
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
@@ -1234,6 +1251,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_kiocb *notif;
 
 	zc->done_io = 0;
+	zc->retry = false;
 	req->flags |= REQ_F_POLL_NO_LAZY;
 
 	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
-- 
2.39.5



