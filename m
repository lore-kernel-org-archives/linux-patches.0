Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433871C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA379C433EF;
	Wed, 28 Dec 2022 16:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243571;
	bh=s6fayNqqatLK37mt00Hs0aWVIfXz4k3CCqLNpoB4HG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U9muxKWwukEQdrWGeHx6cUq0UBb8dkpR/jMkZup2Hc2kvsvsNiXxH/xp1vOzDNoM2
	 QnJDIoBKnizWkIvAQ7hNAGQp1Tn0B+w9UtBjXj5LIkBRK67sR0juTZi9B3RkON3x+v
	 lkyZC4g2rU5OmzCmjPop8ChMGb1fEv6cGj7GbGSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0514/1146] nvme: pass nr_maps explicitly to nvme_alloc_io_tag_set
Date: Wed, 28 Dec 2022 15:34:13 +0100
Message-Id: <20221228144344.136491692@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit dcef77274ae52136925287b6b59d5c6e6a4adfb9 ]

Don't look at ctrl->ops as only RDMA and TCP actually support multiple
maps.

Fixes: 6dfba1c09c10 ("nvme-fc: use the tagset alloc/free helpers")
Fixes: ceee1953f923 ("nvme-loop: use the tagset alloc/free helpers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c   | 5 ++---
 drivers/nvme/host/fc.c     | 2 +-
 drivers/nvme/host/nvme.h   | 2 +-
 drivers/nvme/host/rdma.c   | 4 +++-
 drivers/nvme/host/tcp.c    | 1 +
 drivers/nvme/target/loop.c | 2 +-
 6 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index a4ea0607bc98..95b73b386719 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4867,7 +4867,7 @@ EXPORT_SYMBOL_GPL(nvme_remove_admin_tag_set);
 
 int nvme_alloc_io_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 		const struct blk_mq_ops *ops, unsigned int flags,
-		unsigned int cmd_size)
+		unsigned int nr_maps, unsigned int cmd_size)
 {
 	int ret;
 
@@ -4881,8 +4881,7 @@ int nvme_alloc_io_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 	set->driver_data = ctrl;
 	set->nr_hw_queues = ctrl->queue_count - 1;
 	set->timeout = NVME_IO_TIMEOUT;
-	if (ops->map_queues)
-		set->nr_maps = ctrl->opts->nr_poll_queues ? HCTX_MAX_TYPES : 2;
+	set->nr_maps = nr_maps;
 	ret = blk_mq_alloc_tag_set(set);
 	if (ret)
 		return ret;
diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 5d57a042dbca..20b0c29a9a34 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2903,7 +2903,7 @@ nvme_fc_create_io_queues(struct nvme_fc_ctrl *ctrl)
 	nvme_fc_init_io_queues(ctrl);
 
 	ret = nvme_alloc_io_tag_set(&ctrl->ctrl, &ctrl->tag_set,
-			&nvme_fc_mq_ops, BLK_MQ_F_SHOULD_MERGE,
+			&nvme_fc_mq_ops, BLK_MQ_F_SHOULD_MERGE, 1,
 			struct_size((struct nvme_fcp_op_w_sgl *)NULL, priv,
 				    ctrl->lport->ops->fcprqst_priv_sz));
 	if (ret)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index a29877217ee6..8a0db9e06dc6 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -743,7 +743,7 @@ int nvme_alloc_admin_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 void nvme_remove_admin_tag_set(struct nvme_ctrl *ctrl);
 int nvme_alloc_io_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 		const struct blk_mq_ops *ops, unsigned int flags,
-		unsigned int cmd_size);
+		unsigned int nr_maps, unsigned int cmd_size);
 void nvme_remove_io_tag_set(struct nvme_ctrl *ctrl);
 
 void nvme_remove_namespaces(struct nvme_ctrl *ctrl);
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 6e079abb22ee..a55d3e8b607d 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -798,7 +798,9 @@ static int nvme_rdma_alloc_tag_set(struct nvme_ctrl *ctrl)
 			    NVME_RDMA_METADATA_SGL_SIZE;
 
 	return nvme_alloc_io_tag_set(ctrl, &to_rdma_ctrl(ctrl)->tag_set,
-			&nvme_rdma_mq_ops, BLK_MQ_F_SHOULD_MERGE, cmd_size);
+			&nvme_rdma_mq_ops, BLK_MQ_F_SHOULD_MERGE,
+			ctrl->opts->nr_poll_queues ? HCTX_MAX_TYPES : 2,
+			cmd_size);
 }
 
 static void nvme_rdma_destroy_admin_queue(struct nvme_rdma_ctrl *ctrl)
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 9b47dcb2a7d9..83735c52d34a 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1868,6 +1868,7 @@ static int nvme_tcp_configure_io_queues(struct nvme_ctrl *ctrl, bool new)
 		ret = nvme_alloc_io_tag_set(ctrl, &to_tcp_ctrl(ctrl)->tag_set,
 				&nvme_tcp_mq_ops,
 				BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_BLOCKING,
+				ctrl->opts->nr_poll_queues ? HCTX_MAX_TYPES : 2,
 				sizeof(struct nvme_tcp_request));
 		if (ret)
 			goto out_free_io_queues;
diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index b45fe3adf015..08c583258e90 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -494,7 +494,7 @@ static int nvme_loop_create_io_queues(struct nvme_loop_ctrl *ctrl)
 		return ret;
 
 	ret = nvme_alloc_io_tag_set(&ctrl->ctrl, &ctrl->tag_set,
-			&nvme_loop_mq_ops, BLK_MQ_F_SHOULD_MERGE,
+			&nvme_loop_mq_ops, BLK_MQ_F_SHOULD_MERGE, 1,
 			sizeof(struct nvme_loop_iod) +
 			NVME_INLINE_SG_CNT * sizeof(struct scatterlist));
 	if (ret)
-- 
2.35.1



