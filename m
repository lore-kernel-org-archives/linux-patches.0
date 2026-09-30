Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A15F37BE7A;
	Wed, 30 Sep 2026 16:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784926; cv=none; b=et3Rytj1ItULywE9OhlucVguCCuyI35B1yqoKXeSS08t03LlrZBLGuFlr8uKSiQQAr7YlO3BcK5sYxUQAjuUI+oQ/x9aHZF+zuFHWP+H0LPa1rHg14wJWg+h7GQjOCvJyDq39UVh6D9qmh1Ngi4OtdB38sFxxWuMvZ3GZMPHfLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784926; c=relaxed/simple;
	bh=zOwrnmZybzcHw6CNTfoms1liqjsWOr7859gM+1e6iv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6jvhzo1O8xczJjw88DouOby6P6oI4YDkSzWWKltepwyvJXeBYtc2mLtnwESEGrnTp/itx3Cx0E4+ie6azG98xK0Ml9KN6oQsqsNesn04Sej7uWTBNl4/u9bRVBfueWZOjArh3WHVdtYNiUzw9H3orO3xyFAuPSWLGCrraP6wd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f70rFsmV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f70rFsmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB161F00898;
	Wed, 30 Sep 2026 16:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784918;
	bh=GP4QuSj9CpaePI69BBPt+etFaWg7O5NyOtEoiWFIwjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f70rFsmVgUTyB6+4GOiDX78zpUfEGcZTCCIdBGNM+7X6BlVK+Km0+ZIpA0TG8ifQH
	 gpHcLWA111eBnOw6zEXy+dnYs185D4xmzKNjZboyuhgiW1NIj05twTZiULAjaoZoQY
	 xObAjFmtruSFuRf1NNeIuqKZPcQaV5qkpXpCZn0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Xixin Liu <liuxixin@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 325/982] nvme-rdma: fix -EIO cleanup order in queue_rq
Date: Wed, 30 Sep 2026 17:17:41 +0200
Message-ID: <20260930152423.799269043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xixin Liu <liuxixin@kylinos.cn>

[ Upstream commit d61828199c6cb4b76d48403c77023cd4bb9d09fc ]

On -EIO, the RDMA queue_rq path reports a host path error and then
still cleans up the command and unmaps the SQE DMA. The path error
helper completes the request, so that is double cleanup and DMA unmap
after the request is already complete.

Unmap the SQE first, then report the host path error. Skip the outer
command cleanup on that path.

Fixes: 62eca39722fd ("nvme-rdma: handle nvme_rdma_post_send failures better")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/rdma.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 8f511240addd7..ac76f1ac17090 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -2022,7 +2022,7 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct ib_device *dev;
 	bool queue_ready = test_bit(NVME_RDMA_Q_LIVE, &queue->flags);
 	blk_status_t ret;
-	int err;
+	int err = 0;
 
 	WARN_ON_ONCE(rq->tag < 0);
 
@@ -2078,16 +2078,18 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 err_unmap:
 	nvme_rdma_unmap_data(queue, rq);
 err:
-	if (err == -EIO)
-		ret = nvme_host_path_error(rq);
-	else if (err == -ENOMEM || err == -EAGAIN)
-		ret = BLK_STS_RESOURCE;
-	else
-		ret = BLK_STS_IOERR;
-	nvme_cleanup_cmd(rq);
+	if (err != -EIO) {
+		nvme_cleanup_cmd(rq);
+		if (err == -ENOMEM || err == -EAGAIN)
+			ret = BLK_STS_RESOURCE;
+		else
+			ret = BLK_STS_IOERR;
+	}
 unmap_qe:
 	ib_dma_unmap_single(dev, req->sqe.dma, sizeof(struct nvme_command),
 			    DMA_TO_DEVICE);
+	if (err == -EIO)
+		return nvme_host_path_error(rq);
 	return ret;
 }
 
-- 
2.53.0



