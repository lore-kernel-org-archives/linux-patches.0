Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379B93DA5A7;
	Mon, 17 Aug 2026 14:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978123; cv=none; b=vFvPaQgTculwty8YUwkT1KIzHScPmBMaQh8CUhDhTl/TRCRtlaqh0RUSaXd3KLoDfAGx6NKF4BVQlbK2WdjpoVbwaicEhHk+Boz13o2EsG1qqySMzYKmRsSqDYXTd/KNa2stqD0alvrnRf6D/NFY+QMHar//N11ZNZ8+Jvsvv/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978123; c=relaxed/simple;
	bh=NLuOINWggMYDMTLTQUxIbozwBg7dG2D4chysXbSs1L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDn+/aIVT3XZr6tnbkS2DN2O0jsShUilm3dplQAHxPtw87u2HGhf1+PUt5Aphqr91jhJ9LCIM5hRuahoE6SAayemgr7F6oBzs55DVqIv6NO9goB12MAbES7uNZzO0CO1zwCty5Otn2S4Ak7ViCTVfs5J+DrYvwtv4sKvd/hGEr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yL718bKq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yL718bKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6741F000E9;
	Mon, 17 Aug 2026 14:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978122;
	bh=Z93Mwkgut2D/Tk2C1OL9p457R21fYU2dEkplfoHIXk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yL718bKqGngLv5UpU0ZbLZIuQVhf6vKOzMEzbR6meZmsWt1puizHfFZsNbJy/6oAY
	 Wi0meTKgQTsJzYZh/PmM8KtaWuJUUX8KyyNQ0tQjxxkUBnLLYgYG5cWBdLROXdyUBo
	 04MA9atQEYWI5k2wGdrtR97Q1kLytw1retzm8c2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <tom.leiming@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Simon Liebold <simonlie@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/181] blk-mq: reinsert cached request to the list
Date: Mon, 17 Aug 2026 15:33:22 +0200
Message-ID: <20260817132539.755427407@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit b051bb6bf0a231117036aa607cadf55be8e63910 ]

A previous commit removed an optimization out of caution for a scenario
that turns out not to be real: all the "queue_exit" goto's are safe to
reinsert the request into the cached_rq's plug list as they are either
from a non-blocking path, or a successful merge that already holds the
queue reference. This optimization is most needed for small sequential
workloads that successfully merge into larger requests.

Fixes: dc278e9bf2b9 ("blk-mq: pop cached request if it is usable")
Suggested-by: Ming Lei <tom.leiming@gmail.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://patch.msgid.link/20260526153531.2365935-1-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Simon Liebold <simonlie@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index fd21976375ed4..6af42682af7d6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3154,7 +3154,7 @@ void blk_mq_submit_bio(struct bio *bio)
 	if (!rq)
 		blk_queue_exit(q);
 	else
-		blk_mq_free_request(rq);
+		rq_list_add_head(&plug->cached_rqs, rq);
 }
 
 #ifdef CONFIG_BLK_MQ_STACKING
-- 
2.53.0



