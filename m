Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625527;
	b=Zblghf1nF5wx44Y/Zi6nct8LNC1svUdHG29TBdIjiKAGpJ2B+SyHDdPBIuzgZnTxudex
	 SkTsKx7xh5tX/YxWwSSgzwtV7x5Zm4OsyUsYvzvj7tY9RR4fkGqLPFxqAyzjJsdsYWoeQ
	 0iWJuarw9xbHv1R9mhggpmGHWOJKKHa6FdQHHUwabw827zoH9A9WgHsw9wjFxWJli7NCi
	 yBgX82YCQ5FbcU+MSOEXKU63QfEBrKVRIP92Ioj0rwUrEP0tmrHNj7buRuvRVoPEBLfUA
	 clNN+NR+moJIGKrnF95tI1lzEzWb9oaUaHzVbXFm+L6FPwFo60TaAF2doJCmGOWOfsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e1LvjCFIzIeQLiwNcX/0vwcGTGsggudxy8nmphnouHQ=;
	b=SuKXdUVovPmfZW7jFG98OaKrMVccnSxgQ+3+T8sfiCOB73bSrUQ+8oPg33ml+awPGTrD
	 sQJFca4wPj+DVEeB/WyLKczafWYqloBukIRX/qyPuvhWoT7tkFTp0f45NwqaoVfTEpznN
	 Qhq2VEvWD9aBX5RslFUGGUiZFvqEYXxcaV/kF6DhX8l1bC+kAiaKD1mEHu21TzKUJomEG
	 DEqMeB7xXpV16F3xC0x7iOLaummwJerpNrGdY9VXTgFwd84OaiqGcZka1TMN9LEApEevT
	 xyWvrVN4B1NLgpIYpVNYNn3x46AnyTzZYPXsrBgqD0RqY/Xi9DkV5pEif+453AMERTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZqzEleiy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD68606A31E;
	Wed, 25 Nov 2026 16:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZqzEleiy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB381F000C4;
	Wed, 25 Nov 2026 16:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625526;
	bh=e1LvjCFIzIeQLiwNcX/0vwcGTGsggudxy8nmphnouHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZqzEleiy5KX3CgWOU6VfFdS7JwPZz4JbnhY8SPrZoan7PngBIBca0sX37pjL1spb4
	 KCvTWAgnNQzcgd9KVfENJaaXUPsYq+1jC5WRLNrzCfwa+cnb8DrtlRprqmKHrKTxyt
	 EuX69RcBIVgLkXyEzsUX8V25brMTdsE1jkaZ0NxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 545/816] blk-mq: dont trust the cookie in blk_mq_poll()
Date: Wed, 25 Nov 2026 15:34:53 +0100
Message-ID: <20261125143901.801056489@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 24974185999fd80b676fbe2a6c7a97bbd38aaf3a ]

blk_mq_poll() indexes queue_hw_ctx[] with bio->bi_cookie unchecked. Zone
write plugging keeps the segment count of a plugged write in
__bi_nr_segments, which shares a union with the cookie, and clears
REQ_POLLED, but bio_poll() only looks at the cookie. A plugged polled
write with more segments than there are hardware queues reads past the
array. The bio is also SLAB_TYPESAFE_BY_RCU, so a cookie from a bio
reused for another device can meet the wrong array as well.

Ignore a cookie that is out of range or doesn't name a poll queue.

Fixes: 3e08773c3841 ("block: switch polling to be bio based")
Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261028164415.1262013-28-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 65a08aec007d2..63480b913e352 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -5150,9 +5150,22 @@ static int blk_hctx_poll(struct request_queue *q, struct blk_mq_hw_ctx *hctx,
 int blk_mq_poll(struct request_queue *q, blk_qc_t cookie,
 		struct io_comp_batch *iob, unsigned int flags)
 {
+	struct blk_mq_hw_ctx *hctx;
+
 	if (!blk_mq_can_poll(q))
 		return 0;
-	return blk_hctx_poll(q, xa_load(&q->hctx_table, cookie), iob, flags);
+
+	/*
+	 * The cookie is no more than a hint. iocb_bio_iopoll() may have read it
+	 * from a bio that was reused for another queue right afterwards, and
+	 * zone write plugging keeps the number of segments in the same field.
+	 */
+	if (cookie >= q->nr_hw_queues)
+		return 0;
+	hctx = xa_load(&q->hctx_table, cookie);
+	if (!hctx || hctx->type != HCTX_TYPE_POLL)
+		return 0;
+	return blk_hctx_poll(q, hctx, iob, flags);
 }
 
 int blk_rq_poll(struct request *rq, struct io_comp_batch *iob,
-- 
2.53.0



