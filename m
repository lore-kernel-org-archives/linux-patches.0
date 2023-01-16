Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B10933EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62DAC433D2;
	Mon, 16 Jan 2023 15:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884762;
	bh=KaKV/VwFmpKCDG21/XCOBCCUIyAsbXXf1yidWqZKlS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glNbwsJDM9gSZxIcA9EaGZTgQx5N2TbImtfIz+jdq6Aw8z0ac7OtbwBnaPwX91X+P
	 rptL5k6Aoks5JGXjbPDQNmA0WSp1jBNOyFZca1+Iwk02cu9EVMEIyxxlGHxzkMOR0X
	 GG5hrVtDVybXRGbVauyyZdYfZNSaj4tOikhuieFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Dan Carpenter <error27@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/183] block: Drop spurious might_sleep() from blk_put_queue()
Date: Mon, 16 Jan 2023 16:50:52 +0100
Message-Id: <20230116154808.823026476@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 49e4d04f0486117ac57a97890eb1db6d52bf82b3 ]

Dan reports the following smatch detected the following:

  block/blk-cgroup.c:1863 blkcg_schedule_throttle() warn: sleeping in atomic context

caused by blkcg_schedule_throttle() calling blk_put_queue() in an
non-sleepable context.

blk_put_queue() acquired might_sleep() in 63f93fd6fa57 ("block: mark
blk_put_queue as potentially blocking") which transferred the might_sleep()
from blk_free_queue().

blk_free_queue() acquired might_sleep() in e8c7d14ac6c3 ("block: revert back
to synchronous request_queue removal") while turning request_queue removal
synchronous. However, this isn't necessary as nothing in the free path
actually requires sleeping.

It's pretty unusual to require a sleeping context in a put operation and
it's not needed in the first place. Let's drop it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lkml.kernel.org/r/Y7g3L6fntnTtOm63@kili
Cc: Christoph Hellwig <hch@lst.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Fixes: e8c7d14ac6c3 ("block: revert back to synchronous request_queue removal") # v5.9+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/Y7iFwjN+XzWvLv3y@slm.duckdns.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 815ffce6b988..f5ae527fb0c3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -282,12 +282,9 @@ static void blk_free_queue(struct request_queue *q)
  *
  * Decrements the refcount of the request_queue and free it when the refcount
  * reaches 0.
- *
- * Context: Can sleep.
  */
 void blk_put_queue(struct request_queue *q)
 {
-	might_sleep();
 	if (refcount_dec_and_test(&q->refs))
 		blk_free_queue(q);
 }
-- 
2.35.1



