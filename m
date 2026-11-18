Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022286;
	b=pIYceHLmZTtcB1k8eB/ZjSTOcFVk4avEaPGDP0gdbWf7A9tcAqoRt7m+6e3nfyk92ack
	 d6zhlchnIMPNFcNlk+S+3P5vjNBWiZ2Qluz1DR2Fn03RtvIoO5PBk7+Mcg1mMvR3M5/X5
	 Ay82OybloAW/kAxiOjp2n5PVD6bCLX1ZhnAAi+PfHVtcSvwZr2e+dau/ZJV1NuB4l2jSZ
	 KTxb7c/3VC0psMDqZUy07/Ii7AT61AESMpqyMc4OVLiPnfAwybTk46c5dU8liRGTQz7Yo
	 BjZAQnI/zqdtpzIdpKL7A3gvM10NDGrB7WR83WKXGat5Ti2ZgJeLm6wOO1Oj5oYRB1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VqobekTtSe8jxp6S5+chGyCVec9fzeCaBXIJX8bi374=;
	b=joYoo2W/GDwLFa7Cs4+iMioamRuqZEal+fz5RQaNo4f2Z0dK/AocX3Avd3ieQURicVLT
	 vkWJ+LetBRGxWJ9X588aKAXxuKoh0roXl7PpX7KzOib39/0/DZfkZeyvPwL+VzM5vlqxq
	 /LcXKOSw7KKXichPMjrYANwjxPtt0097iNU2vax4dXj69A6J3JUoLZ/Yn8ZjCREpNVitQ
	 0Ygr15HEnWlPqoaKIQjeG71qtopTyVt4UNO2GzHpMxqfwjabUq7QLc48zq1roJEt/BM60
	 kihg6niGOWnpUb86s2hc5fQla01ZJGblN+hFZR4NWuLFP7KTQcmENVxbcnZXoE0ZhCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KVwTUIag;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433AF606A31C;
	Wed, 18 Nov 2026 17:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KVwTUIag
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988671F000C4;
	Wed, 18 Nov 2026 17:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022286;
	bh=VqobekTtSe8jxp6S5+chGyCVec9fzeCaBXIJX8bi374=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KVwTUIagYa7Yjpf1ifCWWewUsBv09hFeDA/PE3s1zV/9ahLXNzKInPzC7jzDeZqF6
	 l6tZfrCgbAEiDyb+GhkDVxfozTbjRxPS61J5Sf+3FeRm0qSZ1dKpd9ekG6/XKYLVS6
	 LWXCi4/37ZEB5VwA3SfAb3LpKdm39x3BRZS31uFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2581/2651] blk-mq: dont trust the cookie in blk_mq_poll()
Date: Wed, 18 Nov 2026 16:03:41 +0100
Message-ID: <20261118150417.241844088@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 90fe35f28f44f..7a07ae9dc6fa6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -5245,9 +5245,22 @@ static int blk_hctx_poll(struct request_queue *q, struct blk_mq_hw_ctx *hctx,
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



