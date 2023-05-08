Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76823168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F125AC433D2;
	Mon,  8 May 2023 11:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544443;
	bh=Ib1jyX5nibVghdm8I0eoXTj9B2t409WaWaMcDU2OhVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1JZaWwLKyCzbhrpcwXSr1lUB7nLmX6qeIvZ0A97lPCwh1N1Tsso4OEDl7aNLCPTD
	 A4j0THKZ3JpyM83AL20JMDcbSLAj4aDKqpzic6s0hmLlfljHIeqMpUebhqVfuF64nU
	 8+/mGLYnvjDiGWb+Mj/JciNGOpzCfO4saCMAl77k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 410/694] blk-mq: dont plug for head insertions in blk_execute_rq_nowait
Date: Mon,  8 May 2023 11:44:05 +0200
Message-Id: <20230508094446.542905108@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

[ Upstream commit 50947d7fe9fa6abe3ddc40769dfb02a51c58edb6 ]

Plugs never insert at head, so don't plug for head insertions.

Fixes: 1c2d2fff6dc0 ("block: wire-up support for passthrough plugging")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20230413064057.707578-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f5bec5258d32b..ae08c4936743d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1345,7 +1345,7 @@ void blk_execute_rq_nowait(struct request *rq, bool at_head)
 	 * device, directly accessing the plug instead of using blk_mq_plug()
 	 * should not have any consequences.
 	 */
-	if (current->plug)
+	if (current->plug && !at_head)
 		blk_add_rq_to_plug(current->plug, rq);
 	else
 		blk_mq_sched_insert_request(rq, at_head, true, false);
-- 
2.39.2



