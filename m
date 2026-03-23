Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB968397E84;
	Mon, 23 Mar 2026 14:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274655; cv=none; b=d1MCdYfOa13hDB2iWar53B/w8NJWEiT8NnaLcD44ncai3Rt2DFZtpdatFU4HxQRLszKqD5GKvR/TDCA4UWuBh5UxuyZ1gTCgti7ux0yOB1RWWufVNi2oer7xHZL+tPiPC2xucdvzGzRGSNvYOdZPizvPGWf4ZN/BjWw/EGAqexU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274655; c=relaxed/simple;
	bh=j8AXq12N6GuRIn3hcNu2b9aNf6xytIuU/QFAobSKAIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISA4MZMWe2MfL2ViEtctl1HcLkwOj6xcR6EzLnVjzgtZwNr5/RBPuVszP/a9gv/wIZiHqc5yJ3/WLSKt0m6g1WtdZbORBPHxFmIwMzJ5qpGzkyTd4i+z+fCyRVHKi7OdNVreiGawiEql3KVYJT7l3/BMoi14V2Jbtz/dnqXIk+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqPAJ+Rd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqPAJ+Rd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD33C4CEF7;
	Mon, 23 Mar 2026 14:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274654;
	bh=j8AXq12N6GuRIn3hcNu2b9aNf6xytIuU/QFAobSKAIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xqPAJ+RdX1zFtcD7QP+ukiG9Uhk17B6vC3GSDp+tTJXbdzL8Sl1tK8FOM3Oi116hN
	 1nvIFpLZYPAbR9tm4ZUnCDJUVIVKXKOoHzZqj8gDNSfR1ETHt+u+tNo5YGueAXzzcP
	 CxTHj/vyWBg9ngQuGhBSJ2YHzsS1YeGszj+sF2J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Michaelis <code@mgjm.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 065/212] io_uring/kbuf: propagate BUF_MORE through early buffer commit path
Date: Mon, 23 Mar 2026 14:44:46 +0100
Message-ID: <20260323134505.827133664@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -518,6 +518,7 @@ enum {
 	REQ_F_BL_NO_RECYCLE_BIT,
 	REQ_F_BUFFERS_COMMIT_BIT,
 	REQ_F_BUF_NODE_BIT,
+	REQ_F_BUF_MORE_BIT,
 	REQ_F_HAS_METADATA_BIT,
 	REQ_F_IMPORT_BUFFER_BIT,
 	REQ_F_SQE_COPIED_BIT,
@@ -603,6 +604,8 @@ enum {
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
 


