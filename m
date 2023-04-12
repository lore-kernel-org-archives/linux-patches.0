Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F702F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB442C433EF;
	Wed, 12 Apr 2023 08:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289462;
	bh=6jsspnncrAntwUuV6bzkBlyHbR3fRVoAj4G20HCOhuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPvVwILT40YEZsa3f8K1by0+1UB1tkJOwlm0ZdqcNnlsiyjB1GlrWjE+GWH95Oj/a
	 Jo4CRCtyMTlWLg6hVIh3MEx5t+L9o+p10nXZ3F2IWNoC1j43498JAlg+89LXuLqp8u
	 QPLISt5VgHKE7yQWfVLd8t/WyZK7sVi7ZxOKk5jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Martin Belanger <Martin.Belanger@dell.com>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.2 108/173] blk-mq: directly poll requests
Date: Wed, 12 Apr 2023 10:33:54 +0200
Message-Id: <20230412082842.429244847@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Keith Busch <kbusch@kernel.org>

commit 38a8c4d1d45006841f0643f4cb29b5e50758837c upstream.

Polling needs a bio with a valid bi_bdev, but neither of those are
guaranteed for polled driver requests. Make request based polling
directly use blk-mq's polling function instead.

When executing a request from a polled hctx, we know the request's
cookie, and that it's from a live blk-mq queue that supports polling, so
we can safely skip everything that bio_poll provides.

Cc: stable@kernel.org
Reported-by: Martin Belanger <Martin.Belanger@dell.com>
Reported-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Tested-by: Daniel Wagner <dwagner@suse.de>
Revieded-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20230331180056.1155862-1-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1359,8 +1359,6 @@ bool blk_rq_is_poll(struct request *rq)
 		return false;
 	if (rq->mq_hctx->type != HCTX_TYPE_POLL)
 		return false;
-	if (WARN_ON_ONCE(!rq->bio))
-		return false;
 	return true;
 }
 EXPORT_SYMBOL_GPL(blk_rq_is_poll);
@@ -1368,7 +1366,7 @@ EXPORT_SYMBOL_GPL(blk_rq_is_poll);
 static void blk_rq_poll_completion(struct request *rq, struct completion *wait)
 {
 	do {
-		bio_poll(rq->bio, NULL, 0);
+		blk_mq_poll(rq->q, blk_rq_to_qc(rq), NULL, 0);
 		cond_resched();
 	} while (!completion_done(wait));
 }


