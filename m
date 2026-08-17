Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3609426693;
	Mon, 17 Aug 2026 14:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978114; cv=none; b=uOmX8dF8QJA6y9G8Nz82B2fkVALGd4L3V2SE7/TpE2UAgRqSA60wL5LxFcnUm9nGQ+ETmOn5vra3eCSMy9nFHvlhoy+RrI64rhCIwicF/eEX1AYzxLGTl7lASGkSX5mpflcB6u7IuYvFwv6OV6yHT0Cz6+6JT95ExFDw+1QCcg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978114; c=relaxed/simple;
	bh=/10qVygN+9iEximTbSlLCHnMSRx4Q6loqXZSzZtNFB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAsn21XyR8idKVE1jiFReYYvhQ3tOpGwJoEF6VN1s9rnF1D/jFqby/25scII7kfFfXryeamLWkQSKBAWLG5spdt648nB6Kv/UlvAXqEuBhQRnYh6hqJygxyox2uI9ayKgKZRd8iw6nNhkLWqgacLLm7cTKP/xv9z5RoOrhAotxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fsQfhXZO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fsQfhXZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DBD1F000E9;
	Mon, 17 Aug 2026 14:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978113;
	bh=Rf9z00l4qeeLO7GDfNvENgzAGMLfhI/J/YzexAVs/p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fsQfhXZOi5USTyXpOLjENvZx2SHa5KmAKMUq8xz/DAztnyR9EDB/4WBica977Et4q
	 B7LEYRyBWmJZDfows+Ghw1PCE3wtl2YmscoUvs7NRF6zchSTtxIV/1X4/c1qlHkUP0
	 DeuCZelkJUWAizJkFKDfH84YCfk9ZU9qE7dOq+G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Simon Liebold <simonlie@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/181] block: Reorder the request allocation code in blk_mq_submit_bio()
Date: Mon, 17 Aug 2026 15:33:20 +0200
Message-ID: <20260817132539.662739209@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 44e41381591dc5b4ea67a9f170b4ec85c817586e ]

Help the CPU branch predictor in case of a cache hit by handling the cache
hit scenario first.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20241218212246.1073149-2-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: dc278e9bf2b9 ("blk-mq: pop cached request if it is usable")
Signed-off-by: Simon Liebold <simonlie@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5bfaa8e4b9cf6..c1dff0d9f9439 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3121,12 +3121,12 @@ void blk_mq_submit_bio(struct bio *bio)
 	}
 
 new_request:
-	if (!rq) {
+	if (rq) {
+		blk_mq_use_cached_rq(rq, plug, bio);
+	} else {
 		rq = blk_mq_get_new_requests(q, plug, bio, nr_segs);
 		if (unlikely(!rq))
 			goto queue_exit;
-	} else {
-		blk_mq_use_cached_rq(rq, plug, bio);
 	}
 
 	trace_block_getrq(bio);
-- 
2.53.0



