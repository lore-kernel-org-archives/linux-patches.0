Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED012B9A6;
	Thu,  3 Jul 2025 15:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555031; cv=none; b=l0jaQRFoFnBGUBHgoAO37Knx0Ed8xCmTg28kq64INnBDNDW5svvGu/QmeT+18zEjAfps4Jg6VT9AylPwGPCmIIiyrTQpAhhEWFWwlMBoSjjE0ZTTb4ODpv1dzeOTec8h1hlaFO8KuvtocuIiSSxEqO/D3rR8an32acEsa+7xzYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555031; c=relaxed/simple;
	bh=J0D0eIhsh1Jo9Day2HSbmTCmJWceYWnZEEJiTudB8l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0OpwAZzCjN2AYGGYSdxmM2BtLM5MJZS3b0ZCA0zt0ODGrnvWYziYVoeIoIXB1lf1JLfPQfu0FNjidjbDGkx/YP4kSEZDBfVv/tAvIiaFN9v9NgJWD8BlfR7n870RclTYtKWU4hw/mIy60S3mWslGAdy+LGmqHN+kCyg3D71moA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ka8WYOyG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ka8WYOyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7F3C4CEE3;
	Thu,  3 Jul 2025 15:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555030;
	bh=J0D0eIhsh1Jo9Day2HSbmTCmJWceYWnZEEJiTudB8l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ka8WYOyG+bZ3jfGTusl797PdcRIHqhZoPv7Y3H7mEVa3PhGCDDjih4mAHnQ3HHnwQ
	 FwaMVlJYkPC7Zg1nKfTiVmBHkmAgwGSIEs8OpN5UMbXgcZj92tWH1pI00sZUEvP88h
	 nbvvhv3e6OY0VmsELfwN71X4ZTLuEJnEO6rY/XGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 153/263] io_uring/net: mark iov as dynamically allocated even for single segments
Date: Thu,  3 Jul 2025 16:41:13 +0200
Message-ID: <20250703144010.498828697@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 9a709b7e98e6fa51600b5f2d24c5068efa6d39de ]

A bigger array of vecs could've been allocated, but
io_ring_buffers_peek() still decided to cap the mapped range depending
on how much data was available. Hence don't rely on the segment count
to know if the request should be marked as needing cleanup, always
check upfront if the iov array is different than the fast_iov array.

Fixes: 26ec15e4b0c1 ("io_uring/kbuf: don't truncate end buffer for multiple buffer peeks")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/net.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 3feceb2b5b97e..adfdcea01e39b 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1084,6 +1084,12 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 		if (unlikely(ret < 0))
 			return ret;
 
+		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->vec.iovec) {
+			kmsg->vec.nr = ret;
+			kmsg->vec.iovec = arg.iovs;
+			req->flags |= REQ_F_NEED_CLEANUP;
+		}
+
 		/* special case 1 vec, can be a fast path */
 		if (ret == 1) {
 			sr->buf = arg.iovs[0].iov_base;
@@ -1092,11 +1098,6 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 		}
 		iov_iter_init(&kmsg->msg.msg_iter, ITER_DEST, arg.iovs, ret,
 				arg.out_len);
-		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->vec.iovec) {
-			kmsg->vec.nr = ret;
-			kmsg->vec.iovec = arg.iovs;
-			req->flags |= REQ_F_NEED_CLEANUP;
-		}
 	} else {
 		void __user *buf;
 
-- 
2.39.5



