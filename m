Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCF23B3BE1;
	Wed, 30 Sep 2026 19:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795047; cv=none; b=MTB4sWndeRJjosVAdgjHS/ckKZqduNPrH2p/LPViLFBkUDnkK5O1mhD9tktdJ3UB6Bvwxpkse2Gk7E2ipZcESCVsE7BRWdL215XXTctudYrOMewuERX8ujqwEF3/gdr5e2gOvlHzh2FCyhd8XCjjQb9ESIWHN1qagxa2CWC1c00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795047; c=relaxed/simple;
	bh=C4lNQZtQ4FhkHzIcAjN25fZr9zFjzoUUjMII3gVzPvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ox2FkiGJbDgs/YG0NfBZAk4edY+40SqbtoBEBFvDxWGWbSZceWhOqiN5Nz06PdyqzRbakRwu1rP6PbARlPHFuJdDvVwlHLFIpBpLIdHELc4DcLnZcM4LHnoSZsmh4Fl0FmVXY5pbCUFq3LV43PQTcm2bEskrFnHQmuShsc69t3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uo4+oIpe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uo4+oIpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F891F000FF;
	Wed, 30 Sep 2026 19:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795045;
	bh=3QIZzWVKEjOezYsORwON1vDb7nBhBmlOZXogvFN1ZCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uo4+oIpesV9G++MljCxz5ryB+cWx/bmq+i9R9f+k2t5gOnljyHudnjwDLH0D6KWID
	 UxNQ4ae9gCh4ngGFHCrrC6spmeJalJCB+DuiTc8ZalI37xZ+rMhrUHfzKR7gx056QN
	 3AEIxY2ZSsHxg9xPEkcm6BSaYmLxz00g4vuiW0KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Xixin Liu <liuxixin@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0379/1193] nvme-rdma: fix -EIO cleanup order in queue_rq
Date: Wed, 30 Sep 2026 17:17:43 +0200
Message-ID: <20260930152442.603244935@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8803fa04a322a..0e985dd471ab2 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1981,7 +1981,7 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct ib_device *dev;
 	bool queue_ready = test_bit(NVME_RDMA_Q_LIVE, &queue->flags);
 	blk_status_t ret;
-	int err;
+	int err = 0;
 
 	WARN_ON_ONCE(rq->tag < 0);
 
@@ -2037,16 +2037,18 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
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



