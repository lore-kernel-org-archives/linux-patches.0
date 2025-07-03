Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4756B2EFD8A;
	Thu,  3 Jul 2025 14:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554443; cv=none; b=bTIYjz0XeQw9y+2+4d0b8GJX5pitIS1IbjBH+kd5mLADaA3xn3BAC3TAJeyM5jq7XOyB1zhj9ULfsCmE1CkVjW3FXDVeajQXICGGvNqyLG/kD3vbdICHCKQFw6qT8dbi/JUfbzW74PQDwxNpAUjBwXGMc6rFK8h8NxjmBCcRnf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554443; c=relaxed/simple;
	bh=Xaco5PkhDR311TRmWAG5EAElCJ0cMB2vgi6yQs1Uq2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fL5Tpgb2wdJk1kvstyJf5Vj6xGQPpKCgKjv9P3cr876rzIgliliZ04M3aBe/yymVBRdyqkLbvKFNDd/EJWG6C6P6Fg1iVjaOWUQhblec5TfDJ1t3LldXpzOscovksX+CI6I5TUcI8SM33D9qB5YaGrfVw7CK9zHDsqq1tM2Xy3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YE02oR8Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YE02oR8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5199AC4CEF1;
	Thu,  3 Jul 2025 14:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554442;
	bh=Xaco5PkhDR311TRmWAG5EAElCJ0cMB2vgi6yQs1Uq2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YE02oR8QVljfciU5yQzL5R7Soq8Spu6UD0tI792+TkNQgUPuXmpBFrqY0/Z6jRZRS
	 MPX6ObuEwbF4FWdZMxorTmTFpus7iArc9BAc9jdVdqDBmZ4Tzh04p0K27kiCrzN1Zo
	 Jzh87an8Llu6jbo/9dh81PJoWCQeEdHRtmxY3yJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 188/218] io_uring/net: mark iov as dynamically allocated even for single segments
Date: Thu,  3 Jul 2025 16:42:16 +0200
Message-ID: <20250703144003.713458259@linuxfoundation.org>
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

Commit 9a709b7e98e6fa51600b5f2d24c5068efa6d39de upstream.

A bigger array of vecs could've been allocated, but
io_ring_buffers_peek() still decided to cap the mapped range depending
on how much data was available. Hence don't rely on the segment count
to know if the request should be marked as needing cleanup, always
check upfront if the iov array is different than the fast_iov array.

Fixes: 26ec15e4b0c1 ("io_uring/kbuf: don't truncate end buffer for multiple buffer peeks")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1118,6 +1118,12 @@ static int io_recv_buf_select(struct io_
 		if (unlikely(ret < 0))
 			return ret;
 
+		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->free_iov) {
+			kmsg->free_iov_nr = ret;
+			kmsg->free_iov = arg.iovs;
+			req->flags |= REQ_F_NEED_CLEANUP;
+		}
+
 		/* special case 1 vec, can be a fast path */
 		if (ret == 1) {
 			sr->buf = arg.iovs[0].iov_base;
@@ -1126,11 +1132,6 @@ static int io_recv_buf_select(struct io_
 		}
 		iov_iter_init(&kmsg->msg.msg_iter, ITER_DEST, arg.iovs, ret,
 				arg.out_len);
-		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->free_iov) {
-			kmsg->free_iov_nr = ret;
-			kmsg->free_iov = arg.iovs;
-			req->flags |= REQ_F_NEED_CLEANUP;
-		}
 	} else {
 		void __user *buf;
 


