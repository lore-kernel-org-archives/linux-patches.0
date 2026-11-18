Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028250;
	b=DBIedqC24Dp0jnmi6Z8ho0yEXazcCNXOtDhgo/ErwOHLvbW9iMijG7R9Bscl/X9jb8LC
	 Mb8GR30zyt+gRFWJXchB5L1r4CWi0+LXITT455sxWDcAJbi/Prrq/K8NcCXojN/EInOSD
	 fnx8tl6WkHhKmDjOFri1TlwSO/5j1W+alqWghUTeuIdJqpUndArzEKiUZAjY3+XpG0Evu
	 q3TSUmbau5peiIpeMm0mPjDvgKRd7lc8McnGy7+zDx2oydZI9hJuVC3YBTMkBUjiQPQx/
	 0ozHaRWxNUQbncQE/plpplCa8lPz2R3nTPDSsxik5jN6r7ZaP2iCHoDx1xBttPL5vTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DAPR7s7Zh4BF6lqF7wqhHU96U0ZNCmLp5CBf4LP9k2c=;
	b=LPAC/7sd1HwT51FtPW4VT0deYBIYHX9i5eIyyeCXk8gQC+ZywgriXS1hEwRDNsZxdY7N
	 12CVA7sa5s3EweDNxRp7ujp6Xuaoh3WxmKyufjg0x2XzD852D1LQqgxiTDnjESO9MsStq
	 djPzWH+iLaITYDGkRfuPDx0r+jf5l8zO71QNgZcEpsCy2BZZGYRCm/FDOVL4gks3o54os
	 OWlQvwIy1N78vNhGwf4BA8Q7AGvoUNU0nsOecF6pPk1jMH+da3d0vP4WipvZEh6lKkY5u
	 qEzUMpU4LONCE3X0dj2cSHBsS9hDcdbQpnnDQl/ZMopT2LXMxV1XTPIx9PISdCqbLRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Xh7Q/JlQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A853606A320;
	Wed, 18 Nov 2026 18:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xh7Q/JlQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC5D1F000C4;
	Wed, 18 Nov 2026 18:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028249;
	bh=DAPR7s7Zh4BF6lqF7wqhHU96U0ZNCmLp5CBf4LP9k2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xh7Q/JlQJHAQ2/6v1P85q7xJsF1kBydiMrPmheUcviG8A9EX9yWT/3DcbUweKXMeB
	 3Ti3aTsDAbnPbfukcDxQ5OVBhqX7166tpHpwCJvIbAaI8Mb4V0YXgjIg5z0ToAek2T
	 j0MqNfAvaB5ee3AADyoHOWf6dEQqMFfD/f1x836Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2077/2151] blk-mq: exit the hctxs of a queue under tag_list_lock
Date: Wed, 18 Nov 2026 16:03:32 +0100
Message-ID: <20261118150237.376140218@linuxfoundation.org>
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

[ Upstream commit 89a2381482d8ff8e4fe0b7d32797bb4f77503b89 ]

blk_mq_update_nr_hw_queues() exits and replaces the hctxs of every queue
on set->tag_list under tag_list_lock. blk_mq_exit_queue() exits its
hctxs without the lock and only then takes the queue off the list, so an
update running at the same time exits them again and sets up new ones
that nobody exits. del_gendisk() is kept away by update_nr_hwq_lock,
disk_release() of a never added disk and blk_mq_destroy_queue() are not,
and nvme_alloc_ns() drops such a disk when it finds the queues frozen by
a reset.

Hold tag_list_lock for both steps.

Fixes: 630ef623ed26 ("blk-mq: Swap two calls in blk_mq_exit_queue()")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261028164415.1262013-38-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 97cfdde6d8bfd..2b76b8150d882 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4346,7 +4346,8 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 {
 	struct blk_mq_tag_set *set = q->tag_set;
 
-	mutex_lock(&set->tag_list_lock);
+	lockdep_assert_held(&set->tag_list_lock);
+
 	list_del_rcu(&q->tag_set_list);
 	if (list_is_singular(&set->tag_list)) {
 		/* just transitioned to unshared */
@@ -4354,7 +4355,6 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 		/* update existing queue */
 		blk_mq_update_tag_set_shared(set, false);
 	}
-	mutex_unlock(&set->tag_list_lock);
 }
 
 static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
@@ -4713,10 +4713,16 @@ void blk_mq_exit_queue(struct request_queue *q)
 {
 	struct blk_mq_tag_set *set = q->tag_set;
 
+	/*
+	 * As long as the queue is on set->tag_list, its hctxs belong to
+	 * blk_mq_update_nr_hw_queues() as well, which exits and replaces them.
+	 */
+	mutex_lock(&set->tag_list_lock);
 	/* Checks hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED. */
 	blk_mq_exit_hw_queues(q, set, set->nr_hw_queues);
 	/* May clear BLK_MQ_F_TAG_QUEUE_SHARED in hctx->flags. */
 	blk_mq_del_queue_tag_set(q);
+	mutex_unlock(&set->tag_list_lock);
 }
 
 static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
-- 
2.53.0



