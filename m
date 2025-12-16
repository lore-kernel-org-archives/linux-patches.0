Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D6039B6AB;
	Tue, 16 Dec 2025 12:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888652; cv=none; b=qMMNBpV8NviYWA7H4LuPG9DDSHspiWVWWVn1ekSU6hvRlmijV9Twp2vWm9248AwJbKqU5P6vkoVirB/IG917ZP0avr6O+yxxA1mtSqmO1lx25fQvbF2rLZl1Iz8as6WS2WLCTSGrO/Cu9AnLzQgxST+PkdUWxCq150c3zQFBIiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888652; c=relaxed/simple;
	bh=TNK1N0U+B8GVpsChfu7wfEtA3srgaHoOIhZFlZCrZS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkWdfOh64XK1HJBcXy6QfFtqwh38aEBcjPJCt+mtQiU0Fi/eVX83QGsQOCY2Qq9nsc21YCT5hc0vlL0gxpO0cCHR4ywyIsvsS6jBLBvy3iT/40VPNIyCv59LRE4C3yl2YqWMGQAwAbsWT45uzmg4EtnK/eaBZouQGfE0XIZbP2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlVkmlEP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlVkmlEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5125BC4CEF5;
	Tue, 16 Dec 2025 12:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888652;
	bh=TNK1N0U+B8GVpsChfu7wfEtA3srgaHoOIhZFlZCrZS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlVkmlEPqFHYLErwVdGJDhK/JzGLVHWnl6D9rMb2LM3zPliI8Hm5LLEiNskYEvc6o
	 iRyw5IRxQOWhdYNoyX0eskEqMlxiSMFQRPLAOnFKgmnYQqWi3W7xzcY1RX7a25uw6U
	 yQrVKuCdho3GQo5yInlI3NRdbED0RZa0yEsl11v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 564/614] io_uring/kbuf: use READ_ONCE() for userspace-mapped memory
Date: Tue, 16 Dec 2025 12:15:31 +0100
Message-ID: <20251216111421.818267258@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 78385c7299f7514697d196b3233a91bd5e485591 ]

The struct io_uring_buf elements in a buffer ring are in a memory region
accessible from userspace. A malicious/buggy userspace program could
therefore write to them at any time, so they should be accessed with
READ_ONCE() in the kernel. Commit 98b6fa62c84f ("io_uring/kbuf: always
use READ_ONCE() to read ring provided buffer lengths") already switched
the reads of the len field to READ_ONCE(). Do the same for bid and addr.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Cc: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/kbuf.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index a727e020fe036..d974381d93ff7 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -44,7 +44,7 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
 		buf_len -= this_len;
 		/* Stop looping for invalid buffer length of 0 */
 		if (buf_len || !this_len) {
-			buf->addr += this_len;
+			buf->addr = READ_ONCE(buf->addr) + this_len;
 			buf->len = buf_len;
 			return false;
 		}
@@ -198,9 +198,9 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	if (*len == 0 || *len > buf_len)
 		*len = buf_len;
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
-	req->buf_index = buf->bid;
+	req->buf_index = READ_ONCE(buf->bid);
 	sel.buf_list = bl;
-	sel.addr = u64_to_user_ptr(buf->addr);
+	sel.addr = u64_to_user_ptr(READ_ONCE(buf->addr));
 
 	if (io_should_commit(req, issue_flags)) {
 		io_kbuf_commit(req, sel.buf_list, *len, 1);
@@ -280,7 +280,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 	if (!arg->max_len)
 		arg->max_len = INT_MAX;
 
-	req->buf_index = buf->bid;
+	req->buf_index = READ_ONCE(buf->bid);
 	do {
 		u32 len = READ_ONCE(buf->len);
 
@@ -295,7 +295,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 			}
 		}
 
-		iov->iov_base = u64_to_user_ptr(buf->addr);
+		iov->iov_base = u64_to_user_ptr(READ_ONCE(buf->addr));
 		iov->iov_len = len;
 		iov++;
 
-- 
2.51.0



