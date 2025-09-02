Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0590630DEA4;
	Tue,  2 Sep 2025 13:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819772; cv=none; b=Cj2Hu/Aeo5Smp2/qbQJy471eVwjrRUuTBr5UZg0u8lJxk3YAXnwJXplMtWI8nu09/L3DsGqvfUl8sy5I1cJcZo34zUanhEX/7Wit9TfJhL1VOdoKE1ecZBHC8WynBUayQVS9MYiElIDTFj6MjhF9porGBBbkVpojfAKFcGlfmaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819772; c=relaxed/simple;
	bh=+DUe9EcsuzwEj2fw8OkrukgUm5Sb8GvOsFlZDQokp94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qq4AUj9nERJYYqifT0Q6sy9bx5BC6FJnpLdAGwaZuwpZPnj1tpPMrNNCwqP3RwWRawUkB+WrauZ9c+D7C6bY16ZvP5Sjq677FUaFeEaD1MDWWUplxQ3x4iRgVwR0MIOgMC82Yi5IHA/fzDDdzyxbR76lWnO9iksbJCEHuZt9VNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTVc5Jy7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTVc5Jy7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EBEC4CEED;
	Tue,  2 Sep 2025 13:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819771;
	bh=+DUe9EcsuzwEj2fw8OkrukgUm5Sb8GvOsFlZDQokp94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTVc5Jy7iUKcK1VMVzV0xJUD1LtSCR5XE89LT07yuxRAGM72S5b3BUtEYH/sbYRED
	 PnrUDA/cybg/zH+aIBLR7H51KaQZJSwL+7HsS5W7VPXLS7sAE2dq5tXsqL5YmRIHlX
	 GUXoYGHC3KzNX+9P+M+4VpmjrnVuJk52n1QZzQoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingyue Zhang <chunzhennn@qq.com>,
	Suoxing Zhang <aftern00n@qq.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 102/142] io_uring/kbuf: always use READ_ONCE() to read ring provided buffer lengths
Date: Tue,  2 Sep 2025 15:20:04 +0200
Message-ID: <20250902131952.191321279@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 98b6fa62c84f2e129161e976a5b9b3cb4ccd117b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/kbuf.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 81a13338dfab3..19a8bde5e1e1c 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -36,15 +36,19 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
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
@@ -159,6 +163,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	__u16 tail, head = bl->head;
 	struct io_uring_buf *buf;
 	void __user *ret;
+	u32 buf_len;
 
 	tail = smp_load_acquire(&br->tail);
 	if (unlikely(tail == head))
@@ -168,8 +173,9 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 		req->flags |= REQ_F_BL_EMPTY;
 
 	buf = io_ring_head_to_buf(br, head, bl->mask);
-	if (*len == 0 || *len > buf->len)
-		*len = buf->len;
+	buf_len = READ_ONCE(buf->len);
+	if (*len == 0 || *len > buf_len)
+		*len = buf_len;
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_list = bl;
 	req->buf_index = buf->bid;
@@ -265,7 +271,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 
 	req->buf_index = buf->bid;
 	do {
-		u32 len = buf->len;
+		u32 len = READ_ONCE(buf->len);
 
 		/* truncate end piece, if needed, for non partial buffers */
 		if (len > arg->max_len) {
-- 
2.50.1



