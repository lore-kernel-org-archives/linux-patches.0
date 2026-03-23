Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EEF1A5B84;
	Mon, 23 Mar 2026 14:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277181; cv=none; b=ishkrQ8xlx0Fi/uAixVYAidT04VI4bMa99qAnmolI/oujxH17PUCCMGsEimQgMlLiJu3kHx/97/eiRZ5dTk1RkcJQTmyR+m2FGMGCHox/6QysTnxDOiJ2jPXQ2riT3gr/14X4mRDoslMolp9my2q44HOu0dZKQOsIP0qlWem3M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277181; c=relaxed/simple;
	bh=G7O1XJZGXH6nC4okZtgWgeNCU/MC7H9vLZCBKTkqPjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGiaQxUlBXRN5IuM2CAki5c07ggqygrkQiRHw6HkIfcVWYfHh1UJHxIJ/3sqkNC3uuusCbdVE2P93PPJaECgutavH0dQ9+79kE2+BacCBF3KUXiIWuqgXVLXsxiK1Vj1W//xYF/2LAJ5OrK0uPNFna//0HfZ1DW4z7o1rK1wgGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AO1Eklnr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AO1Eklnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36EE0C4CEF7;
	Mon, 23 Mar 2026 14:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277181;
	bh=G7O1XJZGXH6nC4okZtgWgeNCU/MC7H9vLZCBKTkqPjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AO1EklnrrAlL1C8GGscxiIUjeg2zFwROScsAaGnFujeNwR9aWKt1rrlXnsJdyJYMB
	 S0QLlRWomxzFSB4C3eFQK4uzImTkHRKgUmqAOz99AYxL+EIqZqhvprUWdmIHJ4RUhU
	 Umot4ePafVcf3OS21YKZeQRgAEo3YrFJMFIA/18Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Michaelis <code@mgjm.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 348/460] io_uring/kbuf: propagate BUF_MORE through early buffer commit path
Date: Mon, 23 Mar 2026 14:45:44 +0100
Message-ID: <20260323134535.100704458@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 418eab7a6f3c002d8e64d6e95ec27118017019af upstream.

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
 io_uring/kbuf.c                |    6 ++++--
 io_uring/kbuf.h                |    4 +++-
 3 files changed, 10 insertions(+), 3 deletions(-)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -467,6 +467,7 @@ enum {
 	REQ_F_BL_EMPTY_BIT,
 	REQ_F_BL_NO_RECYCLE_BIT,
 	REQ_F_BUFFERS_COMMIT_BIT,
+	REQ_F_BUF_MORE_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -547,6 +548,8 @@ enum {
 	REQ_F_BL_NO_RECYCLE	= IO_REQ_FLAG(REQ_F_BL_NO_RECYCLE_BIT),
 	/* buffer ring head needs incrementing on put */
 	REQ_F_BUFFERS_COMMIT	= IO_REQ_FLAG(REQ_F_BUFFERS_COMMIT_BIT),
+	/* incremental buffer consumption, more space available */
+	REQ_F_BUF_MORE		= IO_REQ_FLAG(REQ_F_BUF_MORE_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -175,7 +175,8 @@ static void __user *io_ring_buffer_selec
 		 * the transfer completes (or if we get -EAGAIN and must poll of
 		 * retry).
 		 */
-		io_kbuf_commit(req, bl, *len, 1);
+		if (!io_kbuf_commit(req, bl, *len, 1))
+			req->flags |= REQ_F_BUF_MORE;
 		req->buf_list = NULL;
 	}
 	return ret;
@@ -321,7 +322,8 @@ int io_buffers_select(struct io_kiocb *r
 		 */
 		if (ret > 0) {
 			req->flags |= REQ_F_BUFFERS_COMMIT | REQ_F_BL_NO_RECYCLE;
-			io_kbuf_commit(req, bl, arg->out_len, ret);
+			if (!io_kbuf_commit(req, bl, arg->out_len, ret))
+				req->flags |= REQ_F_BUF_MORE;
 		}
 	} else {
 		ret = io_provided_buffers_select(req, &arg->out_len, bl, arg->iovs);
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -165,7 +165,9 @@ static inline bool __io_put_kbuf_ring(st
 		ret = io_kbuf_commit(req, bl, len, nr);
 		req->buf_index = bl->bgid;
 	}
-	req->flags &= ~REQ_F_BUFFER_RING;
+	if (ret && (req->flags & REQ_F_BUF_MORE))
+		ret = false;
+	req->flags &= ~(REQ_F_BUFFER_RING | REQ_F_BUF_MORE);
 	return ret;
 }
 


