Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626981C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC550C433D2;
	Wed, 28 Dec 2022 16:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245244;
	bh=DsO4oshAoyrE2z27EaNBuTJqZRv2ZkjUpeyIWUp5rdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p07G8FEMQ5CY//uPK79jor2jEzdKEAebyKX4Pa8AkmU9i/ile1ZMJey7OWOg3WJs4
	 12vedLuT9CBK7Bm66tL+GGdV0fu3sFAxwAOmzOuQAKnsJb+rZIm+dnKIEBD7MtgAnP
	 d1z+3C4eW+1xhpCwSbP6FMif//+IMn0fyk+N/sks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Wensheng <zhangwensheng@huaweicloud.com>,
	Zhong Jinghua <zhongjinghua@huawei.com>,
	Hillf Danton <hdanton@sina.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Dennis Zhou <dennis@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0859/1073] block: fix use-after-free of q->q_usage_counter
Date: Wed, 28 Dec 2022 15:40:47 +0100
Message-Id: <20221228144351.350701784@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit d36a9ea5e7766961e753ee38d4c331bbe6ef659b ]

For blk-mq, queue release handler is usually called after
blk_mq_freeze_queue_wait() returns. However, the
q_usage_counter->release() handler may not be run yet at that time, so
this can cause a use-after-free.

Fix the issue by moving percpu_ref_exit() into blk_free_queue_rcu().
Since ->release() is called with rcu read lock held, it is agreed that
the race should be covered in caller per discussion from the two links.

Reported-by: Zhang Wensheng <zhangwensheng@huaweicloud.com>
Reported-by: Zhong Jinghua <zhongjinghua@huawei.com>
Link: https://lore.kernel.org/linux-block/Y5prfOjyyjQKUrtH@T590/T/#u
Link: https://lore.kernel.org/lkml/Y4%2FmzMd4evRg9yDi@fedora/
Cc: Hillf Danton <hdanton@sina.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Dennis Zhou <dennis@kernel.org>
Fixes: 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of percpu_ref in fast path")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20221215021629.74870-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 818002b8be7c..3459fe316a34 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -255,14 +255,15 @@ EXPORT_SYMBOL_GPL(blk_clear_pm_only);
 
 static void blk_free_queue_rcu(struct rcu_head *rcu_head)
 {
-	kmem_cache_free(blk_requestq_cachep,
-			container_of(rcu_head, struct request_queue, rcu_head));
+	struct request_queue *q = container_of(rcu_head,
+			struct request_queue, rcu_head);
+
+	percpu_ref_exit(&q->q_usage_counter);
+	kmem_cache_free(blk_requestq_cachep, q);
 }
 
 static void blk_free_queue(struct request_queue *q)
 {
-	percpu_ref_exit(&q->q_usage_counter);
-
 	if (q->poll_stat)
 		blk_stat_remove_callback(q, q->poll_cb);
 	blk_stat_free_callback(q->poll_cb);
-- 
2.35.1



