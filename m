Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E29242D94;
	Tue, 29 Apr 2025 17:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947515; cv=none; b=pjnXh9nPpoLvu3W3OFVWT5pjVfZr9jTz3TLDYoYSUwi5cw/MOpuvhcQwLjHezK3fLvF/IxLeTr+nocLuNHP5Yzr7NGsrCF49SY1w+zRVZzFlECyk+0Wwc5cDJyqBT6UlxM0ObfhHCX37nhzL7SV6YMMpm/Q8A9i1gkn6DQiOs88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947515; c=relaxed/simple;
	bh=pqs4lw0ZVOFFIt/HHCC+FkuQF0TTK0/WqCY+HRMxMW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=am/+loxF2XzGlR18dg0DHEazoJMu9V471wtd8L5mBw7XVLspIgA+OgfGFnbYfV7jJEwy9k/j/pA9wo2f8TBU8BeZ7fbz3V06/Wc1O8C+VFXwU2rKP1Xrc3FT5Od20VDO6KOM2ekwRqoeYPwHRuPQ9ivvYpolER8nWuW8r0IbiHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1EP2IQN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EP2IQN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B0DC4CEE3;
	Tue, 29 Apr 2025 17:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947515;
	bh=pqs4lw0ZVOFFIt/HHCC+FkuQF0TTK0/WqCY+HRMxMW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1EP2IQN8z0MbtsLki6Kv7nHjs4feG0l7hEy2BR9UKCHt+8MfjIsOEzel9AmFD9uMq
	 gNchNfEKe6gD7zKa09HIkcz4KmhIqOj0TgxlOvRjcRPrOub6XaPO/y+NrF7kzadMfd
	 5mCFnwMfdXN12jqgiDa43+OWRDNCukBkJI/dEiCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@infradead.org>,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/280] block: make sure ->nr_integrity_segments is cloned in blk_rq_prep_clone
Date: Tue, 29 Apr 2025 18:39:20 +0200
Message-ID: <20250429161115.874597040@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit fc0e982b8a3a169b1c654d9a1aa45bf292943ef2 ]

Make sure ->nr_integrity_segments is cloned in blk_rq_prep_clone(),
otherwise requests cloned by device-mapper multipath will not have the
proper nr_integrity_segments values set, then BUG() is hit from
sg_alloc_table_chained().

Fixes: b0fd271d5fba ("block: add request clone interface (v2)")
Cc: stable@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250310115453.2271109-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5e6afda59e7a1..a7765e96cf40e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3306,6 +3306,7 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 		rq->special_vec = rq_src->special_vec;
 	}
 	rq->nr_phys_segments = rq_src->nr_phys_segments;
+	rq->nr_integrity_segments = rq_src->nr_integrity_segments;
 
 	if (rq->bio && blk_crypto_rq_bio_prep(rq, rq->bio, gfp_mask) < 0)
 		goto free_and_out;
-- 
2.39.5



