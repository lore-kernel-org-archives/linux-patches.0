Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D5FFBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168FAC433EF;
	Mon, 15 May 2023 16:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169117;
	bh=HEuM5DoyHbhD/4ne0xmTZRZIa3UKxcg+6Q7ZMvk95o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yuI9qLb8tue2v0GrUCUZZdnXMAoFI9EXyKFsk/t5U8gnB9ajQKE3rKcr4GAjcZdG6
	 ApOfFZ6Ou+lpT/pagCjd+sOVJd4utNj4R+yLcQLxtzZiZ00xoLz778IwIMjTspZCPK
	 0LZKHPiDbW2vNKz5itmtP8czQa7mzU2CZeMPP5C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengcheng Yang <yangpc@wangsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Jann Horn <jannh@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.19 147/191] kernel/relay.c: fix read_pos error when multiple readers
Date: Mon, 15 May 2023 18:26:24 +0200
Message-Id: <20230515161712.753925865@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pengcheng Yang <yangpc@wangsu.com>

[ Upstream commit 341a7213e5c1ce274cc0f02270054905800ea660 ]

When reading, read_pos should start with bytes_consumed, not file->f_pos.
Because when there is more than one reader, the read_pos corresponding to
file->f_pos may have been consumed, which will cause the data that has
been consumed to be read and the bytes_consumed update error.

Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jann Horn <jannh@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>e
Link: http://lkml.kernel.org/r/1579691175-28949-1-git-send-email-yangpc@wangsu.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 43ec16f1450f ("relayfs: fix out-of-bounds access in relay_file_read")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/relay.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index b7aa7df43955b..0f027e04b0094 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -997,14 +997,14 @@ static void relay_file_read_consume(struct rchan_buf *buf,
 /*
  *	relay_file_read_avail - boolean, are there unconsumed bytes available?
  */
-static int relay_file_read_avail(struct rchan_buf *buf, size_t read_pos)
+static int relay_file_read_avail(struct rchan_buf *buf)
 {
 	size_t subbuf_size = buf->chan->subbuf_size;
 	size_t n_subbufs = buf->chan->n_subbufs;
 	size_t produced = buf->subbufs_produced;
 	size_t consumed = buf->subbufs_consumed;
 
-	relay_file_read_consume(buf, read_pos, 0);
+	relay_file_read_consume(buf, 0, 0);
 
 	consumed = buf->subbufs_consumed;
 
@@ -1065,23 +1065,20 @@ static size_t relay_file_read_subbuf_avail(size_t read_pos,
 
 /**
  *	relay_file_read_start_pos - find the first available byte to read
- *	@read_pos: file read position
  *	@buf: relay channel buffer
  *
- *	If the @read_pos is in the middle of padding, return the
+ *	If the read_pos is in the middle of padding, return the
  *	position of the first actually available byte, otherwise
  *	return the original value.
  */
-static size_t relay_file_read_start_pos(size_t read_pos,
-					struct rchan_buf *buf)
+static size_t relay_file_read_start_pos(struct rchan_buf *buf)
 {
 	size_t read_subbuf, padding, padding_start, padding_end;
 	size_t subbuf_size = buf->chan->subbuf_size;
 	size_t n_subbufs = buf->chan->n_subbufs;
 	size_t consumed = buf->subbufs_consumed % n_subbufs;
+	size_t read_pos = consumed * subbuf_size + buf->bytes_consumed;
 
-	if (!read_pos)
-		read_pos = consumed * subbuf_size + buf->bytes_consumed;
 	read_subbuf = read_pos / subbuf_size;
 	padding = buf->padding[read_subbuf];
 	padding_start = (read_subbuf + 1) * subbuf_size - padding;
@@ -1137,10 +1134,10 @@ static ssize_t relay_file_read(struct file *filp,
 	do {
 		void *from;
 
-		if (!relay_file_read_avail(buf, *ppos))
+		if (!relay_file_read_avail(buf))
 			break;
 
-		read_start = relay_file_read_start_pos(*ppos, buf);
+		read_start = relay_file_read_start_pos(buf);
 		avail = relay_file_read_subbuf_avail(read_start, buf);
 		if (!avail)
 			break;
-- 
2.39.2



