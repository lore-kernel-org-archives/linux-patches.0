Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089F91E7C03;
	Mon, 23 Mar 2026 13:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273943; cv=none; b=WPiScioDwg7Zb9R3+iEI5o5MQ+XaUUQuno2DSRr68xIO6JdTD1j+3X59/0xb7qpBO3pynay3JLUQWjtkb7KrszrgV5PCuqszjcT/brBfbhYEZ2RWnic7QNIjnqQpqbzN31ZHHDmUq8XcvDS0vCcGsGmE1eVpZ/bPyUW57H2q3Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273943; c=relaxed/simple;
	bh=5qVB2AckEStOUgJ5yZmfhV7Q+Taav5aKQNf7oBpj7Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+ZIsF6jUcihBi/mVZSxKpVjIhbFEj/Zyo+dGHpGw5K7DS2UaVgDybe9MfOU318OEDu0lJcdh79jIEqCysmgxJ9YdHMI5abh5bcIOhvXgoIlcSTxHShcc0Uf+UysAM9HmwLMGLd/xD476qoo+K22CaIW9tTmkMvuWsCGspeTUio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0AYQAZcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0AYQAZcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82675C4CEF7;
	Mon, 23 Mar 2026 13:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273942;
	bh=5qVB2AckEStOUgJ5yZmfhV7Q+Taav5aKQNf7oBpj7Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0AYQAZcYcRAS7zTWYhFqaWJRavO4kk4aYoK56b4293KFFPNvjsNB0EoC8SEuMpgFn
	 hbujCl6VwesvnRo5rhCAOb7tFOcaZZGVwAFiUKmTk5KMddWfQUP/xbxdqPuyyEQ6k5
	 ZrBFonlhPGksRYuSCqFqB11o5HMZh2wvOYALrMhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Michaelis <code@mgjm.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.19 057/220] io_uring/kbuf: propagate BUF_MORE through early buffer commit path
Date: Mon, 23 Mar 2026 14:43:54 +0100
Message-ID: <20260323134506.391713507@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 418eab7a6f3c002d8e64d6e95ec27118017019af upstream.

When io_should_commit() returns true (eg for non-pollable files), buffer
commit happens at buffer selection time and sel->buf_list is set to
NULL. When __io_put_kbufs() generates CQE flags at completion time, it
calls __io_put_kbuf_ring() which finds a NULL buffer_list and hence
cannot determine whether the buffer was consumed or not. This means that
IORING_CQE_F_BUF_MORE is never set for non-pollable input with
incrementally consumed buffers.

Likewise for io_buffers_select(), which always commits upfront and
discards the return value of io_kbuf_commit().

Add REQ_F_BUF_MORE to store the result of io_kbuf_commit() during early
commit. Then __io_put_kbuf_ring() can check this flag and set
IORING_F_BUF_MORE accordingy.

Reported-by: Martin Michaelis <code@mgjm.de>
Cc: stable@vger.kernel.org
Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
Link: https://github.com/axboe/liburing/issues/1553
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring_types.h |    3 +++
 io_uring/kbuf.c                |   10 +++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -524,6 +524,7 @@ enum {
 	REQ_F_BL_NO_RECYCLE_BIT,
 	REQ_F_BUFFERS_COMMIT_BIT,
 	REQ_F_BUF_NODE_BIT,
+	REQ_F_BUF_MORE_BIT,
 	REQ_F_HAS_METADATA_BIT,
 	REQ_F_IMPORT_BUFFER_BIT,
 	REQ_F_SQE_COPIED_BIT,
@@ -609,6 +610,8 @@ enum {
 	REQ_F_BUFFERS_COMMIT	= IO_REQ_FLAG(REQ_F_BUFFERS_COMMIT_BIT),
 	/* buf node is valid */
 	REQ_F_BUF_NODE		= IO_REQ_FLAG(REQ_F_BUF_NODE_BIT),
+	/* incremental buffer consumption, more space available */
+	REQ_F_BUF_MORE		= IO_REQ_FLAG(REQ_F_BUF_MORE_BIT),
 	/* request has read/write metadata assigned */
 	REQ_F_HAS_METADATA	= IO_REQ_FLAG(REQ_F_HAS_METADATA_BIT),
 	/*
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -216,7 +216,8 @@ static struct io_br_sel io_ring_buffer_s
 	sel.addr = u64_to_user_ptr(READ_ONCE(buf->addr));
 
 	if (io_should_commit(req, issue_flags)) {
-		io_kbuf_commit(req, sel.buf_list, *len, 1);
+		if (!io_kbuf_commit(req, sel.buf_list, *len, 1))
+			req->flags |= REQ_F_BUF_MORE;
 		sel.buf_list = NULL;
 	}
 	return sel;
@@ -349,7 +350,8 @@ int io_buffers_select(struct io_kiocb *r
 		 */
 		if (ret > 0) {
 			req->flags |= REQ_F_BUFFERS_COMMIT | REQ_F_BL_NO_RECYCLE;
-			io_kbuf_commit(req, sel->buf_list, arg->out_len, ret);
+			if (!io_kbuf_commit(req, sel->buf_list, arg->out_len, ret))
+				req->flags |= REQ_F_BUF_MORE;
 		}
 	} else {
 		ret = io_provided_buffers_select(req, &arg->out_len, sel->buf_list, arg->iovs);
@@ -395,8 +397,10 @@ static inline bool __io_put_kbuf_ring(st
 
 	if (bl)
 		ret = io_kbuf_commit(req, bl, len, nr);
+	if (ret && (req->flags & REQ_F_BUF_MORE))
+		ret = false;
 
-	req->flags &= ~REQ_F_BUFFER_RING;
+	req->flags &= ~(REQ_F_BUFFER_RING | REQ_F_BUF_MORE);
 	return ret;
 }
 


