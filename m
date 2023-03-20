Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749981C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7664C4339B;
	Mon, 20 Mar 2023 15:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324821;
	bh=Ru9OrefBeYiQzfwkMRNWxppRwyJ89LS6QaMGy4Pqwz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kxx+7uqEoE5SEo/tYv0lYZlSliEdlUsDenTzePjHCNZuFnXMKEW8NG4B+5lie5XG5
	 7rouWR1p+4Ib9JVj+iaTcTusLc7sZe632WHkBlfkK1CjtletZxftmGjEcgxBaBE32s
	 GqEW22EowmhU+kpzYN2u0GUchJjRdvYaQvG7g2uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/115] block: null_blk: Fix handling of fake timeout request
Date: Mon, 20 Mar 2023 15:54:09 +0100
Message-Id: <20230320145451.023379029@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 63f886597085f346276e3b3c8974de0100d65f32 ]

When injecting a fake timeout into the null_blk driver using
fail_io_timeout, the request timeout handler does not execute
blk_mq_complete_request(), so the complete callback is never executed
for a timedout request.

The null_blk driver also has a driver-specific fake timeout mechanism
which does not have this problem. Fix the problem with fail_io_timeout
by using the same meachanism as null_blk internal timeout feature, using
the fake_timeout field of null_blk commands.

Reported-by: Akinobu Mita <akinobu.mita@gmail.com>
Fixes: de3510e52b0a ("null_blk: fix command timeout completion handling")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20230314041106.19173-2-damien.lemoal@opensource.wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 4c8b4101516c3..033b0f64f2b9b 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1314,8 +1314,7 @@ static inline void nullb_complete_cmd(struct nullb_cmd *cmd)
 	case NULL_IRQ_SOFTIRQ:
 		switch (cmd->nq->dev->queue_mode) {
 		case NULL_Q_MQ:
-			if (likely(!blk_should_fake_timeout(cmd->rq->q)))
-				blk_mq_complete_request(cmd->rq);
+			blk_mq_complete_request(cmd->rq);
 			break;
 		case NULL_Q_BIO:
 			/*
@@ -1491,7 +1490,8 @@ static blk_status_t null_queue_rq(struct blk_mq_hw_ctx *hctx,
 	cmd->rq = bd->rq;
 	cmd->error = BLK_STS_OK;
 	cmd->nq = nq;
-	cmd->fake_timeout = should_timeout_request(bd->rq);
+	cmd->fake_timeout = should_timeout_request(bd->rq) ||
+		blk_should_fake_timeout(bd->rq->q);
 
 	blk_mq_start_request(bd->rq);
 
-- 
2.39.2



