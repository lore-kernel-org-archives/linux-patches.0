Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0E1339B0
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/Rfg1Lv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F0FC433C8;
	Mon,  9 Oct 2023 13:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859029;
	bh=76CQ4L1HY/vwJfg1GGzxb2Qq9R1/nMfuSjRBro4VNk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/Rfg1Lv2OBEgc6Wf8eAJRmS8+YqTeLMW/C37Is7miy9Obupmo8yzCpmTcVTfw2KN
	 vagDBL6XmBc/3PxPF/mxMwzlPux8RJjEPW1IXNrMGyqud10rBLX57C0o9aMNkubYQ8
	 CD3+r/yGzUjOll/jh13CmhHbkfwdZRAt7Ur3Vw6U=
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
	Saranya Muruganandam <saranyamohan@google.com>
Subject: [PATCH 5.10 176/226] block: fix use-after-free of q->q_usage_counter
Date: Mon,  9 Oct 2023 15:02:17 +0200
Message-ID: <20231009130131.240377556@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

commit d36a9ea5e7766961e753ee38d4c331bbe6ef659b upstream.

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
Signed-off-by: Saranya Muruganandam <saranyamohan@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-core.c  |    2 --
 block/blk-sysfs.c |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -414,8 +414,6 @@ void blk_cleanup_queue(struct request_qu
 		blk_mq_sched_free_requests(q);
 	mutex_unlock(&q->sysfs_lock);
 
-	percpu_ref_exit(&q->q_usage_counter);
-
 	/* @q is and will stay empty, shutdown and put */
 	blk_put_queue(q);
 }
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -726,6 +726,8 @@ static void blk_free_queue_rcu(struct rc
 {
 	struct request_queue *q = container_of(rcu_head, struct request_queue,
 					       rcu_head);
+
+	percpu_ref_exit(&q->q_usage_counter);
 	kmem_cache_free(blk_requestq_cachep, q);
 }
 


