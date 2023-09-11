Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A97911706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F55C433C8;
	Mon, 11 Sep 2023 14:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444053;
	bh=wZJuxpDKhHGog+WmYGMcPnmrQZc/gBBshzPBnOLhoTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/HTV34t+ymJ3/womLYGQL2+LBJY34RxwOrWr16684neYAJVy+h4dBmpIs+y4CeFI
	 S3LAvc/XSZ/qExO2Su9RWJEKRc4bTFqQ8M8JOjaGmw9s2TPGT2AswmFH2qr8++Q8hU
	 fgSOjrIxYIhoiBjj3lF9w4Ur7RJzAMekwinl/8ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Margolin <mrgolin@amazon.com>,
	Yossi Leybovich <sleybo@amazon.com>,
	Yonatan Nachum <ynachum@amazon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 594/737] RDMA/efa: Fix wrong resources deallocation order
Date: Mon, 11 Sep 2023 15:47:33 +0200
Message-ID: <20230911134707.134510216@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonatan Nachum <ynachum@amazon.com>

[ Upstream commit dc202c57e9a1423aed528e4b8dc949509cd32191 ]

When trying to destroy QP or CQ, we first decrease the refcount and
potentially free memory regions allocated for the object and then
request the device to destroy the object. If the device fails, the
object isn't fully destroyed so the user/IB core can try to destroy the
object again which will lead to underflow when trying to decrease an
already zeroed refcount.

Deallocate resources in reverse order of allocating them to safely free
them.

Fixes: ff6629f88c52 ("RDMA/efa: Do not delay freeing of DMA pages")
Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Reviewed-by: Yossi Leybovich <sleybo@amazon.com>
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
Link: https://lore.kernel.org/r/20230822082725.31719-1-ynachum@amazon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/efa/efa_verbs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 2a195c4b0f17d..3538d59521e41 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -449,12 +449,12 @@ int efa_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 
 	ibdev_dbg(&dev->ibdev, "Destroy qp[%u]\n", ibqp->qp_num);
 
-	efa_qp_user_mmap_entries_remove(qp);
-
 	err = efa_destroy_qp_handle(dev, qp->qp_handle);
 	if (err)
 		return err;
 
+	efa_qp_user_mmap_entries_remove(qp);
+
 	if (qp->rq_cpu_addr) {
 		ibdev_dbg(&dev->ibdev,
 			  "qp->cpu_addr[0x%p] freed: size[%lu], dma[%pad]\n",
@@ -1013,8 +1013,8 @@ int efa_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 		  "Destroy cq[%d] virt[0x%p] freed: size[%lu], dma[%pad]\n",
 		  cq->cq_idx, cq->cpu_addr, cq->size, &cq->dma_addr);
 
-	efa_cq_user_mmap_entries_remove(cq);
 	efa_destroy_cq_idx(dev, cq->cq_idx);
+	efa_cq_user_mmap_entries_remove(cq);
 	if (cq->eq) {
 		xa_erase(&dev->cqs_xa, cq->cq_idx);
 		synchronize_irq(cq->eq->irq.irqn);
-- 
2.40.1



