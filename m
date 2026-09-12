Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601281A6813;
	Sat, 12 Sep 2026 07:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197596; cv=none; b=k9Ls0xMuqEBmH8fdBEZ3rz72QCng4g6x8CWgpBP8H8QKF8ENYo/IzLiSHG5um32K1fz736PuIu4Qmmp04AwwKTMeRj7dAHT337GD7qFYIimuzDtxoSqYgp+rHa7CqsWyObeybhmDS9GvuHYCcBzhFLJ1PVhLJvnJWHactcrD71U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197596; c=relaxed/simple;
	bh=mP+GEmUaEHcV0b58ZTRAsoXZbfUmRQWD11bO6V0bjag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fruhBnR/b/EAyjULjUrMtvy1vUagDvZ6uoP1+g1xN4Og83XSHi7ouypZgN2i/eVOVIdzG1VDwoGJYqz24bonkrCSMnFcFCg9OKCT9IE5V3Qd+8+2nODCfgOVx+VWExk297B+7GEacWzDmXyIgTXkDjmF2ckTzVgrDtbhwgBM3dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7JILi8/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7JILi8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78921F000FF;
	Sat, 12 Sep 2026 07:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197591;
	bh=CRa6rMfH41prS/rfrirLwOBM5vW2Yh099b50xIMBRPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7JILi8/oeDLPznQq7GpZBHM+xVOBWKvyO4fzryNDRRf9IeDYTJbfLOS6vFXOQveC
	 SYeFTUgkKf/8sEIP8v+qk0+0fk+EFDs54Q9FOg60rQEVsEMCnS847uOSLDKuXPDp0e
	 YMT0H2prRW+t6achCtS/mPzngUjQ0RL6N2FMR0G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0206/1815] nvmet-rdma: factor out response resource cleanup
Date: Sat, 12 Sep 2026 08:32:36 +0200
Message-ID: <20260912065653.836070633@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit 90096175473f7c86e39c3f74f10343f965f5a05d ]

Move the RDMA read/write context teardown and the request SGL freeing
out of nvmet_rdma_release_rsp() into a new helper function
nvmet_rdma_free_rsp_resources().

This is a refactoring with no functional change, in preparation for the
following patch that uses nvmet_rdma_free_rsp_resources().

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 0114dd303b37 ("nvmet-rdma: fix response resource leak on queue teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index ea1185b8267ef..3c34f235e542e 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -657,18 +657,25 @@ static void nvmet_rdma_rw_ctx_destroy(struct nvmet_rdma_rsp *rsp)
 				    req->sg, req->sg_cnt, nvmet_data_dir(req));
 }
 
-static void nvmet_rdma_release_rsp(struct nvmet_rdma_rsp *rsp)
+static void nvmet_rdma_free_rsp_resources(struct nvmet_rdma_rsp *rsp)
 {
 	struct nvmet_rdma_queue *queue = rsp->queue;
 
-	atomic_add(1 + rsp->n_rdma, &queue->sq_wr_avail);
-
 	if (rsp->n_rdma)
 		nvmet_rdma_rw_ctx_destroy(rsp);
 
 	if (rsp->req.sg < rsp->cmd->inline_sg ||
 	    rsp->req.sg >= rsp->cmd->inline_sg + queue->dev->inline_page_count)
 		nvmet_req_free_sgls(&rsp->req);
+}
+
+static void nvmet_rdma_release_rsp(struct nvmet_rdma_rsp *rsp)
+{
+	struct nvmet_rdma_queue *queue = rsp->queue;
+
+	atomic_add(1 + rsp->n_rdma, &queue->sq_wr_avail);
+
+	nvmet_rdma_free_rsp_resources(rsp);
 
 	if (unlikely(!list_empty_careful(&queue->rsp_wr_wait_list)))
 		nvmet_rdma_process_wr_wait_list(queue);
-- 
2.53.0



