Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028235;
	b=dpdy/VwfW0AG3cCZbd1S+G46CD6lgz8/ePtgSb5NtCShYu69kbPpcmR6sgYioryQu5CV
	 b9lGvj+mH989tHs7DvBwPrP637y8zG/6q7+148eTxv/wtG4Indx7xIG5wFlqp5Wg+AG8g
	 7yQQVsXyfI9iFdGYWSk2pRlFSl/kyBLPwSB1wufIOB4S31XfYaoIzI8a8a/u1EylocE7J
	 QsVxhudqcqDQdrIUG1iCEW4Yie46kRMeQGdDzvMZElzRd4wTcvaXHwn7Qxr4Qvt5O78pe
	 +R2DLhPszQ0S1KTLUPO14MU1O4L2h3vf/ruG8P0jk3FEV8C3Wi63AG+BhGKP/jVTy3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3OWgtbprkj7bF5PvaTaIJFHcNTc+ltFhPT1wrvWzaOU=;
	b=EvQRvp/UJwa8LvWZ418E36hFb+kXMKvhdvyvIpuH67haAEBRUnl7WVZYINh4rNLy5Xgt
	 NB77Ge0O5/L+G6qsvyotckpxgLH3tnVOWUIz/DWKn7sr6yVXPRqAH6DsP9tzWnqaMsePT
	 TFCYqLes96VwCVlA/QgFsW5BZvQkHrglEbGG8ikUA5lgeqn4/1z0Labi2Rj4L8wcfIm4E
	 CTJSmBgHOJih/XNsfD36e/ULhgY3CKe+YDaE1361j4E+m2WttccYcFawDHsREMijZxmqj
	 hh/lVS3MiEjZy0cQeYvVl6PGGhbGMhwKVG9x/r75ovvsqJW+bVgPlMWu5BinXTfaiRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ggrL5mtE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4283606A325;
	Wed, 18 Nov 2026 18:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ggrL5mtE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12641F000C4;
	Wed, 18 Nov 2026 18:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028235;
	bh=3OWgtbprkj7bF5PvaTaIJFHcNTc+ltFhPT1wrvWzaOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ggrL5mtEWMucrzIWtjZzo986NRTSzygCg1+72bFy0W7CTlnPiAJ7hQpXkg8ptUANi
	 x+rYmzuN4om1tFCzCBHLKRejXn4mh/7BJCowlMZVtc4DSwgZQwjCDrKX6IpysChTwU
	 /1M8XuNqxenFR7GwOLBkQl6sygg0bG3DWtg1czLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2072/2151] blk-mq: dont trust the cookie in blk_mq_poll()
Date: Wed, 18 Nov 2026 16:03:27 +0100
Message-ID: <20261118150237.195016813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e0dfae0e20d58..170e6d068ccef 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -5248,9 +5248,22 @@ static int blk_hctx_poll(struct request_queue *q, struct blk_mq_hw_ctx *hctx,
 int blk_mq_poll(struct request_queue *q, blk_qc_t cookie,
 		struct io_comp_batch *iob, unsigned int flags)
 {
+	struct blk_mq_hw_ctx *hctx;
+
 	if (!blk_mq_can_poll(q))
 		return 0;
-	return blk_hctx_poll(q, q->queue_hw_ctx[cookie], iob, flags);
+
+	/*
+	 * The cookie is no more than a hint. iocb_bio_iopoll() may have read it
+	 * from a bio that was reused for another queue right afterwards, and
+	 * zone write plugging keeps the number of segments in the same field.
+	 */
+	if (cookie >= q->nr_hw_queues)
+		return 0;
+	hctx = q->queue_hw_ctx[cookie];
+	if (hctx->type != HCTX_TYPE_POLL)
+		return 0;
+	return blk_hctx_poll(q, hctx, iob, flags);
 }
 
 int blk_rq_poll(struct request *rq, struct io_comp_batch *iob,
-- 
2.53.0



