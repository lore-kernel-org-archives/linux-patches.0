Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DF78F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CF6C433C9;
	Sun, 16 Jul 2023 19:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537414;
	bh=MtxnVlsEN6GGFF26TPDSYZHWhUBTVm/57MZO07suUVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2j031PIGUCN8dQs7JAh3eksRcwPfaMYvHRab6qksq21Fhw4YkU4TH7YgreXScNSW
	 R2gadeH7jLis5SpLM1u3Y2AEgqBzep9ZYpGb8CwTZBUBjfHUCnGUjMSbvH8ENmi7Ee
	 BfdCTRRQjj9IvvwiKnVL+6L7JUmruo5haASlmjcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangwu Zhang <guazhang@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 060/800] blk-mq: dont insert passthrough request into sw queue
Date: Sun, 16 Jul 2023 21:38:33 +0200
Message-ID: <20230716194950.481685843@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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

[ Upstream commit 2293cae703cda162684ae966db6b1b4a11b5e88f ]

In case of real io scheduler, q->elevator is set, so blk_mq_run_hw_queue()
may just check if scheduler queue has request to dispatch, see
__blk_mq_sched_dispatch_requests(). Then IO hang may be caused because
all passthorugh requests may stay in sw queue.

And any passthrough request should have been inserted to hctx->dispatch
always.

Reported-by: Guangwu Zhang <guazhang@redhat.com>
Fixes: d97217e7f024 ("blk-mq: don't queue plugged passthrough requests into scheduler")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230621132208.1142318-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c763f0bc66371..b9f4546139894 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2735,7 +2735,12 @@ static void blk_mq_dispatch_plug_list(struct blk_plug *plug, bool from_sched)
 
 	percpu_ref_get(&this_hctx->queue->q_usage_counter);
 	/* passthrough requests should never be issued to the I/O scheduler */
-	if (this_hctx->queue->elevator && !is_passthrough) {
+	if (is_passthrough) {
+		spin_lock(&this_hctx->lock);
+		list_splice_tail_init(&list, &this_hctx->dispatch);
+		spin_unlock(&this_hctx->lock);
+		blk_mq_run_hw_queue(this_hctx, from_sched);
+	} else if (this_hctx->queue->elevator) {
 		this_hctx->queue->elevator->type->ops.insert_requests(this_hctx,
 				&list, 0);
 		blk_mq_run_hw_queue(this_hctx, from_sched);
-- 
2.39.2



