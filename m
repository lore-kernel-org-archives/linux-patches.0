Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A52A3B19A3;
	Wed,  8 Apr 2026 18:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673611; cv=none; b=O6St6zVux+S6EjlF6JuZdFj3ALM4nAclhJ9DiCC0iNYOX01tRaPyd/tQZFSu8mqwn1roq1JBU0WBt+K+JqRP40YiA4WKZB2fBcB/kR+MCLuX7qrli/XFjNERlxVvpz2/+jzygUzsFrFE8Q2ZEe6HRYpfh0p/KGlSZSwzbqtXKTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673611; c=relaxed/simple;
	bh=tFGJS4buQJt8U7MWftdtc7i00+ZUgMBEm1AX3Svww9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPWtTftDPMsPY8Ba3zm0QVevJB9XimbC1icUNyCXHbZTjANr7CoCkZmZ6TUuIJZJxCtK7eqaY5521cn5IIRC1srmxjzqNG3Ithz12gEJNEazooRCta/HIn1oZaej4l8OmU3EghSJZ69x6Kj6iVRUxrBR8Hqs7k7n2WFoRMA+NIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yHpOFUDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yHpOFUDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018F8C19421;
	Wed,  8 Apr 2026 18:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673611;
	bh=tFGJS4buQJt8U7MWftdtc7i00+ZUgMBEm1AX3Svww9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yHpOFUDkrqyJfEiTuRECXxSd2VXQGq3foF0ZG9yatG4aNcu//sE4w09vy6b84WB77
	 T2N2wcFFDvQK+U2lzLIPjUTU9SHoYym0V2H0UlZclsUc34ekkpyXArDhp14BVUNZNp
	 1gH8+JM2qlls0KJPYeanJ5Zx0jJwPBXD225AC7zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingyue Zhang <chunzhennn@qq.com>,
	Suoxing Zhang <aftern00n@qq.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 021/242] io_uring/kbuf: always use READ_ONCE() to read ring provided buffer lengths
Date: Wed,  8 Apr 2026 20:01:01 +0200
Message-ID: <20260408175927.866055110@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

Commit 98b6fa62c84f2e129161e976a5b9b3cb4ccd117b upstream.

Since the buffers are mapped from userspace, it is prudent to use
READ_ONCE() to read the value into a local variable, and use that for
any other actions taken. Having a stable read of the buffer length
avoids worrying about it changing after checking, or being read multiple
times.

Similarly, the buffer may well change in between it being picked and
being committed. Ensure the looping for incremental ring buffer commit
stops if it hits a zero sized buffer, as no further progress can be made
at that point.

Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
Link: https://lore.kernel.org/io-uring/tencent_000C02641F6250C856D0C26228DE29A3D30A@qq.com/
Reported-by: Qingyue Zhang <chunzhennn@qq.com>
Reported-by: Suoxing Zhang <aftern00n@qq.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -36,15 +36,19 @@ static bool io_kbuf_inc_commit(struct io
 {
 	while (len) {
 		struct io_uring_buf *buf;
-		u32 this_len;
+		u32 buf_len, this_len;
 
 		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
-		this_len = min_t(u32, len, buf->len);
-		buf->len -= this_len;
-		if (buf->len) {
+		buf_len = READ_ONCE(buf->len);
+		this_len = min_t(u32, len, buf_len);
+		buf_len -= this_len;
+		/* Stop looping for invalid buffer length of 0 */
+		if (buf_len || !this_len) {
 			buf->addr += this_len;
+			buf->len = buf_len;
 			return false;
 		}
+		buf->len = 0;
 		bl->head++;
 		len -= this_len;
 	}
@@ -167,6 +171,7 @@ static struct io_br_sel io_ring_buffer_s
 	__u16 tail, head = bl->head;
 	struct io_br_sel sel = { };
 	struct io_uring_buf *buf;
+	u32 buf_len;
 
 	tail = smp_load_acquire(&br->tail);
 	if (unlikely(tail == head))
@@ -176,8 +181,9 @@ static struct io_br_sel io_ring_buffer_s
 		req->flags |= REQ_F_BL_EMPTY;
 
 	buf = io_ring_head_to_buf(br, head, bl->mask);
-	if (*len == 0 || *len > buf->len)
-		*len = buf->len;
+	buf_len = READ_ONCE(buf->len);
+	if (*len == 0 || *len > buf_len)
+		*len = buf_len;
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_index = buf->bid;
 	sel.buf_list = bl;
@@ -274,7 +280,7 @@ static int io_ring_buffers_peek(struct i
 
 	req->buf_index = buf->bid;
 	do {
-		u32 len = buf->len;
+		u32 len = READ_ONCE(buf->len);
 
 		/* truncate end piece, if needed, for non partial buffers */
 		if (len > arg->max_len) {


