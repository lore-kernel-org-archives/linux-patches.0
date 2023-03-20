Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735211C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D473DC433D2;
	Mon, 20 Mar 2023 15:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325537;
	bh=K/d7B1d5nJmC3yZ09eO/+KaCt5Sa6DnyLc22sCCMx/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Db06j/f1s+4BfE1tDMgqpLJdqBM9+4hc9hIUlaiyICVOHDeLGc30ZHEgazSZDixTm
	 pn8RaLlinVazwVPYTNrRjKcCbwngtkBocF+VNrhGcOJJ84wZgYZZHSJ2huOBCQui0E
	 QiLP6VenKNQ9NmvLUrOrcGs7s/9xUsaVefOfuWJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Patalano <mpatalan@redhat.com>,
	Chris Leech <cleech@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 054/211] blk-mq: fix "bad unlock balance detected" on q->srcu in __blk_mq_run_dispatch_ops
Date: Mon, 20 Mar 2023 15:53:09 +0100
Message-Id: <20230320145515.504413292@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Leech <cleech@redhat.com>

[ Upstream commit 00e885efcfbb8712d3e1bfc1ae30639c15ca1d3b ]

The 'q' parameter of the macro __blk_mq_run_dispatch_ops may not be one
local variable, such as, it is rq->q, then request queue pointed by
this variable could be changed to another queue in case of
BLK_MQ_F_TAG_QUEUE_SHARED after 'dispatch_ops' returns, then
'bad unlock balance' is triggered.

Fixes the issue by adding one local variable for doing srcu lock/unlock.

Fixes: 2a904d00855f ("blk-mq: remove hctx_lock and hctx_unlock")
Cc: Marco Patalano <mpatalan@redhat.com>
Signed-off-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230310010913.1014789-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.h b/block/blk-mq.h
index ef59fee62780d..a7482d2cc82e7 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -378,12 +378,13 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
 #define __blk_mq_run_dispatch_ops(q, check_sleep, dispatch_ops)	\
 do {								\
 	if ((q)->tag_set->flags & BLK_MQ_F_BLOCKING) {		\
+		struct blk_mq_tag_set *__tag_set = (q)->tag_set; \
 		int srcu_idx;					\
 								\
 		might_sleep_if(check_sleep);			\
-		srcu_idx = srcu_read_lock((q)->tag_set->srcu);	\
+		srcu_idx = srcu_read_lock(__tag_set->srcu);	\
 		(dispatch_ops);					\
-		srcu_read_unlock((q)->tag_set->srcu, srcu_idx);	\
+		srcu_read_unlock(__tag_set->srcu, srcu_idx);	\
 	} else {						\
 		rcu_read_lock();				\
 		(dispatch_ops);					\
-- 
2.39.2



