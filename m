Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D958630C626;
	Mon, 13 Oct 2025 15:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369112; cv=none; b=WSc1Z3d9DRj8wlyNoq/WTDviHi7yunm2uT7Uaddl4nA37TCvz/QIwT2KXzjckc29mmGmDMl5a5s8u37dUggrRWGyyCZ/RDSkiI/6fhPlBMnc/MrnQkkdyaIpHXGOdCmMd+M7oErWzL2bn8ijN6IdgnbRCxYz9U4rMLsy4IrBmog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369112; c=relaxed/simple;
	bh=1saZZx9D8VCoXBCUAkuIu6tIftiZ0IjciToJ4WfgJlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRIzRrs5Q9FepDMs/jYi5l/XUcNkPevbZ94xPPF4sH70PAOcR2A/tHekoHMcI8UInryx1akjFr1ELeOHg4nbj/ldKQmrExkLdvCPD4wI0wpM+pkDVSldRvWgbzaTY0gkzVk8eJ5fA0NPGBIXiYhrVkiQkByp7NzB9c+iLRUuYuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGbTlpQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGbTlpQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6DCC4CEE7;
	Mon, 13 Oct 2025 15:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369112;
	bh=1saZZx9D8VCoXBCUAkuIu6tIftiZ0IjciToJ4WfgJlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gGbTlpQvvzG1GqD9KtsI8OHQ29Z4wSkJnswkFwz3VsPnn8XYiYN8bzw1bja0qxb2/
	 qeOrnm/R272SRXKHN2WkYoytpww8PMOURM3dYCSJaMuOJP7DN1f18c9KBH66LMHoVh
	 68TOeeR7tPeI9DurVn2Dud4qIfudqddmvh+y36lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 125/563] blk-mq: remove useless checkings in blk_mq_update_nr_requests()
Date: Mon, 13 Oct 2025 16:39:46 +0200
Message-ID: <20251013144415.823048130@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 8bd7195fea6d9662aa3b32498a3828bfd9b63185 ]

1) queue_requests_store() is the only caller of
blk_mq_update_nr_requests(), where queue is already freezed, no need to
check mq_freeze_depth;
2) q->tag_set must be set for request based device, and queue_is_mq() is
already checked in blk_mq_queue_attr_visible(), no need to check
q->tag_set.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: b86433721f46 ("blk-mq: fix potential deadlock while nr_requests grown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 19b50110376c6..f5e713224d819 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4929,21 +4929,14 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 {
 	struct blk_mq_tag_set *set = q->tag_set;
 	struct blk_mq_hw_ctx *hctx;
-	int ret;
+	int ret = 0;
 	unsigned long i;
 
-	if (WARN_ON_ONCE(!q->mq_freeze_depth))
-		return -EINVAL;
-
-	if (!set)
-		return -EINVAL;
-
 	if (q->nr_requests == nr)
 		return 0;
 
 	blk_mq_quiesce_queue(q);
 
-	ret = 0;
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (!hctx->tags)
 			continue;
-- 
2.51.0



