Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8442D5C68;
	Sat, 12 Sep 2026 16:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229125; cv=none; b=WUJ7h92jjP6yBi2xJ0eLam25oFN764Xoiq0cqWpujjTTzmKXaV13jd8c3dJI4IEtv/hySmEaIzO7SpgCI08CYxtY9P5WaopjlY+pDYRM9f5ON4Exz+Kkvl1RvtG76FfnhAGm8tsI5lMqfREYXBJ7oZ7bY+3fci47YDOcn50iXcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229125; c=relaxed/simple;
	bh=gU92w7u2cgPtTKYbu2Moeu2ZD2VghnAm92MpJ5v2o9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJJpj3PnMx0te2bzIVIOA9KA1JFbsVT6Y69lU2Z04Hk/fnuk4k9jwwdf2A561SjgyOKcgJlQi74MURd5J+sLIPry2gMEIjzGNtsF8xdC35OmrYNW1P5BsuWpghsGnBS7zP0mH9ZXBIuSgg9Edqgy4FvRxHfyeizo9RsIWKIfrbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iqk17MG0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iqk17MG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B221F000FF;
	Sat, 12 Sep 2026 16:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229120;
	bh=NrVCyyqVl6wIobEgGvm9kUZN9xagIgrcXThaZKMNZhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iqk17MG0iYh6l+QknxSY4/XWPVRd4ca/YJFJHRUu/sOpbwkLYK2xPVpLwlYS2XaLf
	 P4kb9et/Bic17VIWBZy7a5cOIEOdJGFATrkmZXMSENraRfqLGVzgG/mY4dtcDzAY3o
	 t8zd+Hbnr7ReISh7HyduLNnA8vmr+Rz3MK9iLUKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0526/1191] nvmet-rdma: factor out response resource cleanup
Date: Sat, 12 Sep 2026 08:54:14 +0200
Message-ID: <20260912065600.062724689@linuxfoundation.org>
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
index d964032291cbb..1d371a4ecc844 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -659,18 +659,25 @@ static void nvmet_rdma_rw_ctx_destroy(struct nvmet_rdma_rsp *rsp)
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



