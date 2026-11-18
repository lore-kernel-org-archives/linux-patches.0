Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042682;
	b=yM+DthOnOQA7IhI8BYz07p2bDaQM89q5nK+b0nMOZde/CWNyZkP+DmE96kD2Ow/g7vv0
	 ox0/w+XFr+nrMEASkE282C2VbfIdINdKV7jxBcJgV4LQ13zWnrL308htxihjef9dxYsNp
	 AtbfIZOR6G40j80loqqgNXI7o2w9ssqQG83uXm6Dr3Xi+zFwK6p6RJ4ySp18s5e8gLqQO
	 QLYazqwMe+z57c8F5HewnbSumPyHh4SoeIWuV+4gXkltpVp52Q4hxyl0PojMu4gK/E5GJ
	 3vhrIEx9iSh5atXHzTaAPkDLblOtkoTU/tCwSFgfJk0/U/0dtKONgXeOBCFU36hVqcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=58DArqvm9L1AqMdX0vx7MJpU70AFQg2GD2C/hrnS6LE=;
	b=1bv0uF1uD5WAaUwmWa8ixUXq+XQpSfz+La53djH1qIhs6TkreerYVgsZ51RWDgC3KMjX
	 ZJnAsHSEa7e1eskbdVLbyDpRpPdyQcYZfXzIhNq3jo7TWvRy2ywSQBbKeLm7ut8SNwhYO
	 HBRCiak+9ZwHT1hOzp+f7rMAPTl8P/MiQmzGm+UQj3x5zJtvol81T8SdXRozY9Ksh1d8J
	 PcOTmSSNtAuixyoknI8JBpuIiwrPw1iaEL5TcVWsrQXnA5q+E/YLYjn9wG5yVORufvVfx
	 m0GMsQ4M6L7KF3UMqHtBaBfj3s8HnZ38CjDfkkHAkE4lYoq5gtYTYVVHpFizxAO9lcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zkrq+vH1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD28606A325;
	Wed, 18 Nov 2026 22:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zkrq+vH1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAFA1F000C4;
	Wed, 18 Nov 2026 22:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042682;
	bh=58DArqvm9L1AqMdX0vx7MJpU70AFQg2GD2C/hrnS6LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zkrq+vH1eCexssNWXtAyu/6pYf/h4GrEBfEfHF5L8K16I2PGtaOOKvX+xy3qkoUHw
	 RaBzT/gXcNrGqpM40/e9SaE0IiVuMNvSXiKGiK9rgSj8rqfEs+q6m0797kgBjEuUew
	 hQ9UFu9gTJ1OnBYBvMaGW+Yw7k5qdWec6BqjYSTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3259/3318] blk-mq: exit the hctxs of a queue under tag_list_lock
Date: Wed, 18 Nov 2026 16:04:41 +0100
Message-ID: <20261118150457.393806709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 00027ff491eeb..72fd729ee9cd4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4178,7 +4178,8 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 {
 	struct blk_mq_tag_set *set = q->tag_set;
 
-	mutex_lock(&set->tag_list_lock);
+	lockdep_assert_held(&set->tag_list_lock);
+
 	list_del_rcu(&q->tag_set_list);
 	if (list_is_singular(&set->tag_list)) {
 		/* just transitioned to unshared */
@@ -4186,7 +4187,6 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 		/* update existing queue */
 		blk_mq_update_tag_set_shared(set, false);
 	}
-	mutex_unlock(&set->tag_list_lock);
 }
 
 static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
@@ -4527,10 +4527,16 @@ void blk_mq_exit_queue(struct request_queue *q)
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



