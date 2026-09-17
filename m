Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A574FDA76;
	Thu, 17 Sep 2026 18:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668691; cv=none; b=bukXHolW5TzbqygHSxnBs+k/6nOvJPBjHG5BPVvsQpwVEjB1pz2unykfQYOsFS0tYlzpqqg9ACTxeai4DTtFsfIADR0yJdDBnPLKH8beqHLP4Y+pupkhsDdvHrI+wYWfRODA0i9SzwTWGMytS5GcyO/YPy2aEODLEF/Wcmqv8X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668691; c=relaxed/simple;
	bh=tz9kTeameQMSpJXxsSGrb48iGuyYT8qtMX9772hnAII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+895gGI92Yc49LA0Ryz07gZdY0Wa4nJTMsYLW+zCZfPjrUMfH/66s6B5m0o1mbJDdympFMoV7mQHlayzx+nQFR4MVpKE5LjKx2kGUNU1lACBlKcPnCYBv3qnkQ55H9yu3Rsb2shfmYL2dRF2K4ySz5G0LP6mxREbGOIf+XywBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ix26NH9A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ix26NH9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9345A1F000FF;
	Thu, 17 Sep 2026 18:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668690;
	bh=gdkeb1ft6AxVraveA+wDq71AcTFKUmIZKnVxXBD6+xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ix26NH9AwY+f16pcBQBByYFPZY64IADm+0IAaWSoGt+e2TKsZ3YYfyRer4tpsFiI7
	 8XnEm2oAlUsEARK1kipIAZZzIv8mS2Ch1iSOzu2bI50AF0s7PmRGR6DLh/NfuTR4ck
	 kkXEuypbEllbuqeZcaQnOGSihl2CkVCvaoVf1UHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Xixin Liu <liuxixin@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0507/1102] nvme-rdma: fix -EIO cleanup order in queue_rq
Date: Thu, 17 Sep 2026 16:07:30 +0100
Message-ID: <20260917151552.467952148@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 913e6e5a80705..afa71191cd112 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -2002,7 +2002,7 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct ib_device *dev;
 	bool queue_ready = test_bit(NVME_RDMA_Q_LIVE, &queue->flags);
 	blk_status_t ret;
-	int err;
+	int err = 0;
 
 	WARN_ON_ONCE(rq->tag < 0);
 
@@ -2058,16 +2058,18 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
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



