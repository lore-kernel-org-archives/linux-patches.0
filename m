Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4B679C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60098C433C1;
	Wed, 30 Nov 2022 18:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833832;
	bh=uM6qCBzOPg5dA41HLGDA2VeYI+OxPscQz9tdaJvdYF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JqxWNlkk2Bqjs1ctavGUy4tlgtWers9lihwXY01nrQTFRICn3DmMF0GOxm3srI3Tf
	 10B9onPSX4zJOVUKxSgC1UiaRKeQPsgykZh9ikZKEwpPW3TMJ1gALwIx9oYIFcPKxD
	 biVKbv9T/hjghCvxi6598OCSjHlgfMO2wTFloJjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Alan Adamson <alan.adamson@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Daniel Wagner <dwagner@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 031/289] nvme: quiet user passthrough command errors
Date: Wed, 30 Nov 2022 19:20:16 +0100
Message-Id: <20221130180544.839375130@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

[ Upstream commit d7ac8dca938cd60cf7bd9a89a229a173c6bcba87 ]

The driver is spamming the kernel logs for entirely harmless errors from
user space submitting unsupported commands. Just silence the errors.
The application has direct access to command status, so there's no need
to log these.

And since every passthrough command now uses the quiet flag, move the
setting to the common initializer.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Alan Adamson <alan.adamson@oracle.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Tested-by: Alan Adamson <alan.adamson@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 3 +--
 drivers/nvme/host/pci.c  | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ed47c256dbd2..01c36284e542 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -675,6 +675,7 @@ void nvme_init_request(struct request *req, struct nvme_command *cmd)
 	if (req->mq_hctx->type == HCTX_TYPE_POLL)
 		req->cmd_flags |= REQ_POLLED;
 	nvme_clear_nvme_request(req);
+	req->rq_flags |= RQF_QUIET;
 	memcpy(nvme_req(req)->cmd, cmd, sizeof(*cmd));
 }
 EXPORT_SYMBOL_GPL(nvme_init_request);
@@ -1037,7 +1038,6 @@ int __nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 			goto out;
 	}
 
-	req->rq_flags |= RQF_QUIET;
 	ret = nvme_execute_rq(req, at_head);
 	if (result && ret >= 0)
 		*result = nvme_req(req)->result;
@@ -1225,7 +1225,6 @@ static void nvme_keep_alive_work(struct work_struct *work)
 	rq->timeout = ctrl->kato * HZ;
 	rq->end_io = nvme_keep_alive_end_io;
 	rq->end_io_data = ctrl;
-	rq->rq_flags |= RQF_QUIET;
 	blk_execute_rq_nowait(rq, false);
 }
 
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 1a6423e94eb3..0f34114c4596 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1438,7 +1438,6 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req)
 
 	abort_req->end_io = abort_endio;
 	abort_req->end_io_data = NULL;
-	abort_req->rq_flags |= RQF_QUIET;
 	blk_execute_rq_nowait(abort_req, false);
 
 	/*
@@ -2489,7 +2488,6 @@ static int nvme_delete_queue(struct nvme_queue *nvmeq, u8 opcode)
 	req->end_io_data = nvmeq;
 
 	init_completion(&nvmeq->delete_done);
-	req->rq_flags |= RQF_QUIET;
 	blk_execute_rq_nowait(req, false);
 	return 0;
 }
-- 
2.35.1



