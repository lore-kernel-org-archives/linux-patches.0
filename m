Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC97F4BEE3C;
	Sat, 12 Sep 2026 16:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231235; cv=none; b=MYVeOs68IVt8wbatH2L+JVmqQRfBg8ELdeUU12fFH1aKfgOJzGDoxjKF7KK4FL4OA9LFR1MXQt0H8y7Npd7bQJhwTEvFHkaHWoSlTxyjaTZ7J/KFDY6cUoNXfz3Qvg3KL89orEQFGdI/aW+5OpFLPbjsglvD2fbSQp83RG357X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231235; c=relaxed/simple;
	bh=APUjMIWRBygXhgKHfSdHTt3LRkLLc/cKq72WaM6fhug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOUrdzIjNe+cMdSwQ3nodg66QKWUXs+9dB/1ZQE33pexw25UPSNCGwoVyPQefJkemnxsgL/kEb+/AAsphi1KIZQO+IUZTckZQvFGauT8yrv2E59wqXqPKLWY1LZqPGoJ+ATIlQ6eiEtVSuHayO7xNguh9wkhQxAhd43qy46DG4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cwT5BxP4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cwT5BxP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD93A1F000FF;
	Sat, 12 Sep 2026 16:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231233;
	bh=SzCrzzL7xea3fX8aOkCwCt2JZp72Iw7YXRzq7ur90Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cwT5BxP4UARa+8U+PaIO99+4ligWaIEzyQVEr70RiIQA3Eo8JSIbzKxm3tMiLJo7C
	 +djyMdxgHhAypNs4StyqoK6CDXwbBuAmSXqvvtlnbJri+fsDkCKpJMSRU04F9zs+kj
	 97gAg/wOmxj2I20yhgT5eEQomk7DOm0UNuQsfg8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0956/1191] nvme: introduce nvme_start_request
Date: Sat, 12 Sep 2026 09:01:24 +0200
Message-ID: <20260912065609.694242685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 6887fc6495f2dfd55e088c982e983815278ee453 ]

In preparation for nvme-multipath IO stats accounting, we want the
accounting to happen in a centralized place. The request completion
is already centralized, but we need a common helper to request I/O
start.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Stable-dep-of: 8ce883fd068b ("nvme-apple: Drop the PRP null check chicken bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c  | 2 +-
 drivers/nvme/host/fc.c     | 2 +-
 drivers/nvme/host/nvme.h   | 5 +++++
 drivers/nvme/host/pci.c    | 2 +-
 drivers/nvme/host/rdma.c   | 2 +-
 drivers/nvme/host/tcp.c    | 2 +-
 drivers/nvme/target/loop.c | 2 +-
 7 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 8d687c3174def..07b00f4a0e3f2 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -782,7 +782,7 @@ static blk_status_t apple_nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 			goto out_free_cmd;
 	}
 
-	blk_mq_start_request(req);
+	nvme_start_request(req);
 	apple_nvme_submit_cmd(q, cmnd);
 	return BLK_STS_OK;
 
diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index a98c1e59a6502..7fc35b16f6296 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2733,7 +2733,7 @@ nvme_fc_start_fcp_op(struct nvme_fc_ctrl *ctrl, struct nvme_fc_queue *queue,
 	atomic_set(&op->state, FCPOP_STATE_ACTIVE);
 
 	if (!(op->flags & FCOP_FLAGS_AEN))
-		blk_mq_start_request(op->rq);
+		nvme_start_request(op->rq);
 
 	cmdiu->csn = cpu_to_be32(atomic_inc_return(&queue->csn));
 	ret = ctrl->lport->ops->fcp_io(&ctrl->lport->localport,
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 8c97777ba629c..be940d4148c20 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1030,6 +1030,11 @@ static inline void nvme_hwmon_exit(struct nvme_ctrl *ctrl)
 }
 #endif
 
+static inline void nvme_start_request(struct request *rq)
+{
+	blk_mq_start_request(rq);
+}
+
 static inline bool nvme_ctrl_sgl_supported(struct nvme_ctrl *ctrl)
 {
 	return ctrl->sgls & ((1 << 0) | (1 << 1));
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 660e8fbb18136..a12d3ad54a1b6 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -908,7 +908,7 @@ static blk_status_t nvme_prep_rq(struct nvme_dev *dev, struct request *req)
 			goto out_unmap_data;
 	}
 
-	blk_mq_start_request(req);
+	nvme_start_request(req);
 	return BLK_STS_OK;
 out_unmap_data:
 	if (blk_rq_nr_phys_segments(req))
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 47fbf561c01e6..8f511240addd7 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -2045,7 +2045,7 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (ret)
 		goto unmap_qe;
 
-	blk_mq_start_request(rq);
+	nvme_start_request(rq);
 
 	if (IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY) &&
 	    queue->pi_support &&
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 397198c90d2f4..e139f567a8535 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2541,7 +2541,7 @@ static blk_status_t nvme_tcp_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (unlikely(ret))
 		return ret;
 
-	blk_mq_start_request(rq);
+	nvme_start_request(rq);
 
 	nvme_tcp_queue_request(req, true, bd->last);
 
diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index c864e902e91e2..0669b6c8abab9 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -145,7 +145,7 @@ static blk_status_t nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (ret)
 		return ret;
 
-	blk_mq_start_request(req);
+	nvme_start_request(req);
 	iod->cmd.common.flags |= NVME_CMD_SGL_METABUF;
 	iod->req.port = queue->ctrl->port;
 	if (!nvmet_req_init(&iod->req, &queue->nvme_cq,
-- 
2.53.0



