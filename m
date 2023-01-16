Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9356833EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DB3C433D2;
	Mon, 16 Jan 2023 15:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884759;
	bh=ukG/HdNWgVHM+ty/gPW+DeYgEngIGjc7rZSfkcTqLwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjoaZBPyHBYWcTPbL3mPCuDFFqRyEFqn5VdPl6Z8TQtg9TrG2sWKkxgGqdITFJ75h
	 3GwDbkjKTwzImAjRD0WLKkUN9hm34D0oU5FVMo9i96CzCckdMIJNbwuh8xgRQfMXQF
	 3JCB/EWxrb5BqLAswctlnE5Ci3XhTVsDaVq90tmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/183] block: mark blk_put_queue as potentially blocking
Date: Mon, 16 Jan 2023 16:50:51 +0100
Message-Id: <20230116154808.781032337@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 63f93fd6fa5717769a78d6d7bea6f7f9a1ccca8e ]

We can't just say that the last reference release may block, as any
reference dropped could be the last one.  So move the might_sleep() from
blk_free_queue to blk_put_queue and update the documentation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20221114042637.1009333-6-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 49e4d04f0486 ("block: Drop spurious might_sleep() from blk_put_queue()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7de1bb16e9a7..815ffce6b988 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -260,8 +260,6 @@ static void blk_free_queue_rcu(struct rcu_head *rcu_head)
 
 static void blk_free_queue(struct request_queue *q)
 {
-	might_sleep();
-
 	percpu_ref_exit(&q->q_usage_counter);
 
 	if (q->poll_stat)
@@ -285,11 +283,11 @@ static void blk_free_queue(struct request_queue *q)
  * Decrements the refcount of the request_queue and free it when the refcount
  * reaches 0.
  *
- * Context: Any context, but the last reference must not be dropped from
- *          atomic context.
+ * Context: Can sleep.
  */
 void blk_put_queue(struct request_queue *q)
 {
+	might_sleep();
 	if (refcount_dec_and_test(&q->refs))
 		blk_free_queue(q);
 }
-- 
2.35.1



