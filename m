Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA61B1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1E7C433C9;
	Mon, 11 Sep 2023 14:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441003;
	bh=HeszEDWz4YVma/400r1EiiSigMPCOFzOWDor/Zq0h6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iycescCCsRs510BvsF9jMtazkTljvdHaGk5tGS1EKansg1U5ff/tjyVDl+JA59fzN
	 Ft7YSTQ0b0xq/KmpAGqX/f96CjmFwcrxRcELhWZcICvAGOg2j8nQaefbygrdx/XHRR
	 gzJALaxZQut9mi7EW462YZOfoyJenRGPYcjvG0x8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 262/739] blk-flush: fix rq->flush.seq for post-flush requests
Date: Mon, 11 Sep 2023 15:41:01 +0200
Message-ID: <20230911134658.461209605@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengming Zhou <zhouchengming@bytedance.com>

[ Upstream commit 28b241237470981a96fbd82077c8044466b61e5f ]

If the policy == (REQ_FSEQ_DATA | REQ_FSEQ_POSTFLUSH), it means that the
data sequence and post-flush sequence need to be done for this request.

The rq->flush.seq should record what sequences have been done (or don't
need to be done). So in this case, pre-flush doesn't need to be done,
we should init rq->flush.seq to REQ_FSEQ_PREFLUSH not REQ_FSEQ_POSTFLUSH.

Fixes: 615939a2ae73 ("blk-mq: defer to the normal submission path for post-flush requests")
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230717040058.3993930-3-chengming.zhou@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-flush.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 8220517c2d67d..fdc489e0ea162 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -443,7 +443,7 @@ bool blk_insert_flush(struct request *rq)
 		 * the post flush, and then just pass the command on.
 		 */
 		blk_rq_init_flush(rq);
-		rq->flush.seq |= REQ_FSEQ_POSTFLUSH;
+		rq->flush.seq |= REQ_FSEQ_PREFLUSH;
 		spin_lock_irq(&fq->mq_flush_lock);
 		list_move_tail(&rq->flush.list, &fq->flush_data_in_flight);
 		spin_unlock_irq(&fq->mq_flush_lock);
-- 
2.40.1



