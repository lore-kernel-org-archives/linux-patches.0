Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C8C847F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08E0C4339C;
	Fri, 10 Mar 2023 13:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456675;
	bh=WyvtTXrSIf4F5EnjKnIMnikvS8JpCCgLWGrp97SG79w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pT7iEeMFh7H2dRn0NfeBdi4p50yXzbyGkAgTCMkFVeyXSUthtSBt7D/tr2jdkCXZQ
	 jFHejPA4R8dyDa+80K0NT1B/TLviJXJs9G+EQ1sZZfn2ugPKjzz1lNyni99fOTldCO
	 ryYlkufCpL/Zx94N5k3gY8gw0eRh4zJ6nVtFfJ18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 085/211] 9p/rdma: unmap receive dma buffer in rdma_request()/post_recv()
Date: Fri, 10 Mar 2023 14:37:45 +0100
Message-Id: <20230310133721.367138995@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 74a25e6e916cb57dab4267a96fbe8864ed21abdb ]

When down_interruptible() or ib_post_send() failed in rdma_request(),
receive dma buffer is not unmapped. Add unmap action to error path.
Also if ib_post_recv() failed in post_recv(), dma buffer is not unmapped.
Add unmap action to error path.

Link: https://lkml.kernel.org/r/20230104020424.611926-1-shaozhengchao@huawei.com
Fixes: fc79d4b104f0 ("9p: rdma: RDMA Transport Support for 9P")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_rdma.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 83f9100d46bff..b84748baf9cbe 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -385,6 +385,7 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
 	struct p9_trans_rdma *rdma = client->trans;
 	struct ib_recv_wr wr;
 	struct ib_sge sge;
+	int ret;
 
 	c->busa = ib_dma_map_single(rdma->cm_id->device,
 				    c->rc.sdata, client->msize,
@@ -402,7 +403,12 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
 	wr.wr_cqe = &c->cqe;
 	wr.sg_list = &sge;
 	wr.num_sge = 1;
-	return ib_post_recv(rdma->qp, &wr, NULL);
+
+	ret = ib_post_recv(rdma->qp, &wr, NULL);
+	if (ret)
+		ib_dma_unmap_single(rdma->cm_id->device, c->busa,
+				    client->msize, DMA_FROM_DEVICE);
+	return ret;
 
  error:
 	p9_debug(P9_DEBUG_ERROR, "EIO\n");
@@ -499,7 +505,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 
 	if (down_interruptible(&rdma->sq_sem)) {
 		err = -EINTR;
-		goto send_error;
+		goto dma_unmap;
 	}
 
 	/* Mark request as `sent' *before* we actually send it,
@@ -509,11 +515,14 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 	WRITE_ONCE(req->status, REQ_STATUS_SENT);
 	err = ib_post_send(rdma->qp, &wr, NULL);
 	if (err)
-		goto send_error;
+		goto dma_unmap;
 
 	/* Success */
 	return 0;
 
+dma_unmap:
+	ib_dma_unmap_single(rdma->cm_id->device, c->busa,
+			    c->req->tc.size, DMA_TO_DEVICE);
  /* Handle errors that happened during or while preparing the send: */
  send_error:
 	WRITE_ONCE(req->status, REQ_STATUS_ERROR);
-- 
2.39.2



