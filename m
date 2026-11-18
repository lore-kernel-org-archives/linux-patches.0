Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028253;
	b=SAV7TyUiEvHDEWl8RDbl8ERBN9b8M6KZ/Iif9TSzylkl89kL3CDC6nL/ScZ1IQl40c/H
	 G0w2cb5DAhAi8WB0+wRctXSTNg1fibmoLoTTIhSmeOuuLsQzr1SDfE77xR6GytuMgH/8t
	 +wylBhP17XjJ/m5ft8UDtIVr1PJzvjyOOcvANhfnUxyl8xSSGtEtnBOj5NEe3zSHIuFbn
	 cOMs71anVma9qekk1bgN5imxQUoRRkDYBJhkOy4cXBxLgWwqG//4uAPwzOSBRiQLJaYRw
	 m1f1DkFm8ruk5fHMWYv5kEH4XMZrlg1C79U/OHBi4xIxQod/nfkRaMhaGMx3XkPgA6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b0985g1HehxfySsGLyUUSHiaC31s7nYuaz/vmAqLr1M=;
	b=y3TFvIBtA7agrhkWMPmkW1sSx/rrSDHwBZ3GgHhSZKxOEZuhGJACm8WWGqF+xvBsdRVo
	 e1L4MkH7CrloCBuVgw9LcwhXQxfFUwtFpg9jrUMuWCKNfO2VOHEmmehtN2nQUsB3c2ETn
	 pVoIh5bX41lhrzhaKAmUdr+mbvKey3GntO/Y78+bPfq5oe34SnKNwXxHdq7mCEZqb5nUS
	 tQ9HdBGnlPfff9rg4OKO+mQ4ljNJ0MPc+DsVSvvArqiijLDWbNF4UTYbjeX9I31PF4r+C
	 89qggoIb1dlkaraOqacqxBycpx2VvOewVSOBuN+cexJjBp3l3w8mRSSwWBH+tTPLXhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LkOV1heM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF1A606A31C;
	Wed, 18 Nov 2026 18:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LkOV1heM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133911F000C4;
	Wed, 18 Nov 2026 18:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028252;
	bh=b0985g1HehxfySsGLyUUSHiaC31s7nYuaz/vmAqLr1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LkOV1heMS68inUROHCNPQIU06fbR4dVCdpas01AV0jgWIQDIOGzpfsmWltFx6gruk
	 Wy7ULc6k1q6FcGTWBLZTkgTw3f/ZT2iBGfFRyIPGD64YM5DMaChGqS6Oks9A16POQk
	 4y29O6XMAoXeA2+8uGA0/sOiL8RP3BgDtyqqMJYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2078/2151] blk-mq: set up a queue under tag_list_lock
Date: Wed, 18 Nov 2026 16:03:33 +0100
Message-ID: <20261118150237.410608270@linuxfoundation.org>
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

[ Upstream commit 4fcc499ea9bc31b02393904a1903e794d146f5f7 ]

blk_mq_init_allocated_queue() only takes tag_list_lock at the end, when
it adds the queue to the set. Before that it sizes the queue by
set->nr_hw_queues, hands out set->tags[], maps by set->map[], and
blk_mq_map_swqueue() frees tags of the set. An update clearing the maps
at that time makes the new queue free tags that all the other queues
share. An NVMe controller reset during a namespace scan does exactly
that.

Take the lock before the first look at the set. An update can be part of
error handling, so the allocations under the lock must not wait for IO:
memalloc_noio_save(), as in add_disk_fwnode().

Fixes: 868f2f0b7206 ("blk-mq: dynamic h/w context count")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261028164415.1262013-39-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2b76b8150d882..7bdc9b1d7b746 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4362,7 +4362,7 @@ static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
 {
 	unsigned int i;
 
-	mutex_lock(&set->tag_list_lock);
+	lockdep_assert_held(&set->tag_list_lock);
 
 	/*
 	 * Check to see if we're transitioning to shared (from 1 to 2 queues).
@@ -4387,8 +4387,6 @@ static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
 			blk_mq_quiesce_queue_nowait(q);
 	}
 	spin_unlock(&set->quiesce_lock);
-
-	mutex_unlock(&set->tag_list_lock);
 }
 
 /* All allocations will be freed in release handler of q->mq_kobj */
@@ -4661,6 +4659,8 @@ static void blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
 int blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 		struct request_queue *q)
 {
+	unsigned int memflags;
+
 	/* mark the queue as mq asap */
 	q->mq_ops = set->ops;
 
@@ -4679,6 +4679,16 @@ int blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	INIT_LIST_HEAD(&q->unused_hctx_list);
 	spin_lock_init(&q->unused_hctx_lock);
 
+	/*
+	 * Keep blk_mq_update_nr_hw_queues() away until the queue is on
+	 * set->tag_list: it changes the number of hardware queues, the tags and
+	 * the maps, and blk_mq_map_swqueue() allocates and frees tags of the set.
+	 * An update can be part of the error handling of a driver, so it must
+	 * not have to wait for somebody who waits for I/O.
+	 */
+	memflags = memalloc_noio_save();
+	mutex_lock(&set->tag_list_lock);
+
 	blk_mq_realloc_hw_ctxs(set, q);
 	if (!q->nr_hw_queues)
 		goto err_hctxs;
@@ -4698,9 +4708,14 @@ int blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	blk_mq_init_cpu_queues(q, set->nr_hw_queues);
 	blk_mq_map_swqueue(q);
 	blk_mq_add_queue_tag_set(set, q);
+
+	mutex_unlock(&set->tag_list_lock);
+	memalloc_noio_restore(memflags);
 	return 0;
 
 err_hctxs:
+	mutex_unlock(&set->tag_list_lock);
+	memalloc_noio_restore(memflags);
 	blk_mq_release(q);
 err_exit:
 	q->mq_ops = NULL;
-- 
2.53.0



