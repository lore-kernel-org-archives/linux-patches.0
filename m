Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E778331203;
	Sat, 12 Sep 2026 19:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242514; cv=none; b=kB5/6Gl2Dh2GK+onYNlyQTPpp45QgH4STnqt5SsU8mc+VsLZQMZgNUc4qmDqWFrJDkPuiDWayHvi6YFTg78/Ad3n+vDe4CeT4gi/Jum1iJkphz/TLMzt8vvFd4rvk0wuVBrWEXbYiGogtMzWTyI06RPyvZvUNfGxOQex56tC4Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242514; c=relaxed/simple;
	bh=Lr1OsRwAhZC3p5809GSNrKOgsM9Ut234V5fs77q1PEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVQwrfxXodqGbxcRPf+znGC/9A6C2bpNkUs0oAK8Y23Zh9LCQdCrNRx10n1bT9oYbFtwUP25buJycFiAU5orpvJjeqtI52QGfCN+ec45fIA8tiLiF6HxTxoYME52/DIFuhszoOYT22SIlPiPtRUYRNcXQGWg/ABLRx/HGIq1Ua8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqHo2Pzw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqHo2Pzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A8D1F000FF;
	Sat, 12 Sep 2026 19:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242510;
	bh=lfUY0GfpMetbYjoj0u211mA/5WXDJGrBbcZG9njj3h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cqHo2PzwtiYwxiHbRmoGsX1j1RB87zgQ/CovLx2ploaDmuyZ20lOmSmmjGbDIvdOA
	 RJvTwGF7fUKtq3xnreJCILqrURMTVyalwRxOcouzrIsbb1vFXH/kHCsuiZtbaV7zwv
	 Kb6v3XsTf6iTFc9XhxFDk7j7SY0eSrc5iCfwnKZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 377/798] nvmet-rdma: factor out response resource cleanup
Date: Sat, 12 Sep 2026 09:00:05 +0200
Message-ID: <20260912065525.797325476@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f3643cad20584..5ce6aa4103d89 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -656,18 +656,25 @@ static void nvmet_rdma_rw_ctx_destroy(struct nvmet_rdma_rsp *rsp)
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



