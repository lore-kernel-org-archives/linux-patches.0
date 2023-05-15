Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACC11772F
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:03:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8D7C433B4;
	Mon, 15 May 2023 18:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173827;
	bh=a8QJ9EJzBTlBqhii5F/12mBnvY5NzPBsT+SUedInjb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WyMKS8iPDe6PN228c25bNDP+u9uEeVa8fRXfwc1d6TtoFcfPmd/Rf7k6PVa2W2/ZE
	 auFJT5ImOIpMQghVx8c5iISHBvgaeWktpk4vkR4K9kBKwxk3Q4SJVJU5gWKQDd3yHN
	 z9ioJcIRU5gQmaDxuo22uUlnhu9zWn7t7GAZ8KEg=
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
Subject: [PATCH 5.4 219/282] kernel/relay.c: fix read_pos error when multiple readers
Date: Mon, 15 May 2023 18:29:57 +0200
Message-Id: <20230515161728.798725193@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
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
index 9b1cfcd8dc6b1..989f78f16ad5c 100644
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



