Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E54F51812D;
	Wed, 30 Sep 2026 18:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791259; cv=none; b=iOX3RlE6S+j7j+R3bqpDcdqcNfQOxHZ0mHc9gsfAaQdVD9rdUn2VGU49yaZXdogYPIOabe3AAIVSfBbISARTTkNVPVt0vDgQIX3GSF221rpsuPeRQitJobJdbwkYs4wvPJ4Ik9Mxd2q6fzZsBTDKskW3eo3kNi4rwnDnQD+jRPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791259; c=relaxed/simple;
	bh=5Wey6s6AGHb/r5EZJGFBeQWo+JZBHqt7vhTbeZkDJrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQcjRbza6LtvweAVHiTzEEjTqfE46RaezgMVy4K8UNbw5NstVm4xMvrcXxkqprLKvfhahwzm7GqnawFAs9G4RskPPiAaHwotWLz8Od9UbwyTN5aCKkQwf7Xa/X3msC3WjJck5y7X7EdzTNaK+0U+8nKGsw28WqL5HBXHUw9Y3yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJkfHzZs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJkfHzZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A891F000FF;
	Wed, 30 Sep 2026 18:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791258;
	bh=agJJmMdzbI+vf7Kpv8K5rxyoxg0KeNm4yv2sRHGle5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJkfHzZscGOyW1yt84PV9EqBucKt5U5w8a6GG16vXq0MsYRajza3t+f07fz74phKH
	 YocQF5OgJAvo1IJowcwvHrfHjK57fZOXRKXmSEgYJZTBL8qfAs3l0AunAZQ3JqfECt
	 3fPaasgZnBtGQqym+fTS94u3SMnNCaomBLAWGzgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Xixin Liu <liuxixin@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 240/752] nvme-rdma: fix -EIO cleanup order in queue_rq
Date: Wed, 30 Sep 2026 17:21:50 +0200
Message-ID: <20260930152403.461140947@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 00c6924bf5f94..40932e82c428e 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -2051,7 +2051,7 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct ib_device *dev;
 	bool queue_ready = test_bit(NVME_RDMA_Q_LIVE, &queue->flags);
 	blk_status_t ret;
-	int err;
+	int err = 0;
 
 	WARN_ON_ONCE(rq->tag < 0);
 
@@ -2107,16 +2107,18 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
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



