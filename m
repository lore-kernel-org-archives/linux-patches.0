Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022341;
	b=5LJmxRYy+5Cqi0K/40v92YBiaExGXWopMra/OVVA9pIhYVhGKI7ay1v49Vooibw54/h1
	 A04GZse9UHF95tGOMeK2VOPq4t765l7iEUJSjtzLMf29EnunNkLVJuSh4u2wPY8wHdSXg
	 1sn8/EVYfBFuIgDBsXIZNEFyw6sWA2JExpo0bTwoBsy1XVoxi6xW38nyzt8rSj9Y8dTdN
	 n146jIUQopUHZ7ikC5hVGRDR+bfPWrQcl4WJuACfa4p+NikN5cP53btHEOTbClvjv9PHO
	 uVTZeI+K3EEKozaLT/HeTbP+cPMXkHWgWUMFsM20WJAZE98Oh3HfglIIKxzhYbqhb0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7iHz45AofdMUq9C+acf8OQtIXwUf+KqfcH/a0Z7fCSA=;
	b=kctEN38OQ37SbSlXQlWCLSIuc6ZulMxKjwlijLcaATId8VRv37cCGL8DZVtgMYoexN/I
	 eyJlQ/JG5IZQK9gYMA6WNCrl86P1N8xFOqs16juMqP/zAZ9keZcxDVbwUCku49J397II3
	 6ZZt6b7cpDsPFbvVKgQwy4+w2Tnm0pKamhGeC3OItRt54OIUc8nTQf9pxZDQXz68OqzPM
	 pc5lZwldjC6EkmSFpI5qEXJB8g/xA6B8b32uMPe8OVxENk8kOZc/Mkn6N8VrdTpdNn5Bj
	 kz0VHWH6Y6n6/4dEzRLMkdLV+gNglyOzgvNDmXssh9wq76CusrUB3vbAi8Qnc3p8gBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WvbfRtGG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895E2606A325;
	Wed, 18 Nov 2026 17:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WvbfRtGG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79531F000C4;
	Wed, 18 Nov 2026 17:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022341;
	bh=7iHz45AofdMUq9C+acf8OQtIXwUf+KqfcH/a0Z7fCSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WvbfRtGGyNH2pn0kEl8j6fI4UO4N2E721WKNlBh1UcG+18OQmCeMnvsMeBef5wqD5
	 8hwXI7b9ChlIrY4KFKEa3jN6rfnFTnh4zpzxyM6hpee+E87WbaAASpwxZyxdK/aY2A
	 Vpsan6O1sc/0RMHtwZ+I1QBZXkiqEx5FmNT0lJ9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2587/2651] blk-mq: exit the hctxs of a queue under tag_list_lock
Date: Wed, 18 Nov 2026 16:03:47 +0100
Message-ID: <20261118150417.428821517@linuxfoundation.org>
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
index 8daaec930b076..01008b7e4401e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4339,7 +4339,8 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 {
 	struct blk_mq_tag_set *set = q->tag_set;
 
-	mutex_lock(&set->tag_list_lock);
+	lockdep_assert_held(&set->tag_list_lock);
+
 	list_del_rcu(&q->tag_set_list);
 	if (list_is_singular(&set->tag_list)) {
 		/* just transitioned to unshared */
@@ -4347,7 +4348,6 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 		/* update existing queue */
 		blk_mq_update_tag_set_shared(set, false);
 	}
-	mutex_unlock(&set->tag_list_lock);
 }
 
 static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
@@ -4711,10 +4711,16 @@ void blk_mq_exit_queue(struct request_queue *q)
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



