Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02E6BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F20C4339B;
	Tue,  7 Mar 2023 18:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212200;
	bh=CnQo34brO7Gk1qTweuoQ/wz2ZvMjCScRvsLtOp2fd9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMSqS90qgTVKKMb3GpPkqJgEJLqIUxnfQUh4zjp9ZqpkfCQQ35yeDzbh9bjNbg+lo
	 uad+S4VbIRhTP06kKNOLW2cYsTQQbGsNZP+ftzQVb5ZFXnjgHslizGUfxau3X9n5zn
	 svsAQENwCbh1OgijEYccwm1+vkSO5inn+0j1zAHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinke Han <hanjinke.666@bytedance.com>,
	Ming Lei <ming.lei@redhat.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/885] block: Fix io statistics for cgroup in throttle path
Date: Tue,  7 Mar 2023 17:50:42 +0100
Message-Id: <20230307170006.570679696@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jinke Han <hanjinke.666@bytedance.com>

[ Upstream commit 0f7c8f0f7934c389b0f9fa1f151e753d8de6348f ]

In the current code, io statistics are missing for cgroup when bio
was throttled by blk-throttle. Fix it by moving the unreaching code
to submit_bio_noacct_nocheck.

Fixes: 3f98c753717c ("block: don't check bio in blk_throtl_dispatch_work_fn")
Signed-off-by: Jinke Han <hanjinke.666@bytedance.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230216032250.74230-1-hanjinke.666@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5487912befe89..553afcdd638a6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -672,6 +672,18 @@ static void __submit_bio_noacct_mq(struct bio *bio)
 
 void submit_bio_noacct_nocheck(struct bio *bio)
 {
+	blk_cgroup_bio_start(bio);
+	blkcg_bio_issue_init(bio);
+
+	if (!bio_flagged(bio, BIO_TRACE_COMPLETION)) {
+		trace_block_bio_queue(bio);
+		/*
+		 * Now that enqueuing has been traced, we need to trace
+		 * completion as well.
+		 */
+		bio_set_flag(bio, BIO_TRACE_COMPLETION);
+	}
+
 	/*
 	 * We only want one ->submit_bio to be active at a time, else stack
 	 * usage with stacked devices could be a problem.  Use current->bio_list
@@ -776,17 +788,6 @@ void submit_bio_noacct(struct bio *bio)
 
 	if (blk_throtl_bio(bio))
 		return;
-
-	blk_cgroup_bio_start(bio);
-	blkcg_bio_issue_init(bio);
-
-	if (!bio_flagged(bio, BIO_TRACE_COMPLETION)) {
-		trace_block_bio_queue(bio);
-		/* Now that enqueuing has been traced, we need to trace
-		 * completion as well.
-		 */
-		bio_set_flag(bio, BIO_TRACE_COMPLETION);
-	}
 	submit_bio_noacct_nocheck(bio);
 	return;
 
-- 
2.39.2



