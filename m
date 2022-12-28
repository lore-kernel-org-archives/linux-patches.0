Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5586B1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC517C433F0;
	Wed, 28 Dec 2022 16:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245215;
	bh=LyVP3Y98azTmWDuoPdwqUDaknN1faS2vSn3+8ydW5B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VD2t6q7vQUPrwzGSPwyjcLDGhxR9dYF2tBCIyquLkm4af1C5JcgUMcfeSZrCJOrXl
	 Qrs6m7aIulUFCZpnmMNvxa2nUklQjy8X5ZI016EC/Y6gW5kDkKiLmHOZogXtUNJHLT
	 s/4hqWF6a+I3Y4297J5ZU/MTFspT0ZS13bjVQEyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Andreas Herrmann <aherrmann@suse.de>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0852/1073] blk-iocost: simplify ioc_name
Date: Wed, 28 Dec 2022 15:40:40 +0100
Message-Id: <20221228144351.160644270@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 9df3e65139b923dfe98f76b7057882c7afb2d3e4 ]

Just directly dereference the disk name instead of going through multiple
hoops to find the same value.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andreas Herrmann <aherrmann@suse.de>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20220921180501.1539876-10-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: d36a9ea5e776 ("block: fix use-after-free of q->q_usage_counter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 7936e5f5821c..cba9d3ad58e1 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -664,17 +664,13 @@ static struct ioc *q_to_ioc(struct request_queue *q)
 	return rqos_to_ioc(rq_qos_id(q, RQ_QOS_COST));
 }
 
-static const char *q_name(struct request_queue *q)
-{
-	if (blk_queue_registered(q))
-		return kobject_name(q->kobj.parent);
-	else
-		return "<unknown>";
-}
-
 static const char __maybe_unused *ioc_name(struct ioc *ioc)
 {
-	return q_name(ioc->rqos.q);
+	struct gendisk *disk = ioc->rqos.q->disk;
+
+	if (!disk)
+		return "<unknown>";
+	return disk->disk_name;
 }
 
 static struct ioc_gq *pd_to_iocg(struct blkg_policy_data *pd)
-- 
2.35.1



