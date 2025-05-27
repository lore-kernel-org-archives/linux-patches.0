Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C681DFF0;
	Tue, 27 May 2025 17:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368463; cv=none; b=IJ/g7zy3/QhLLr7lB4uyvbNkSVgyI+7xI1qWv3aDFVc4uxohTcD+qdjl92ASosaKMi+b2N5ir4JyXNke8kOAC3xzh8wliIDTo8svRWHN/ahY2qnf5DTRDkIIB3FPGOQxRYdgwS5UISntrriHWhoYGIoY7jQeXR+usR8Agd9qYMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368463; c=relaxed/simple;
	bh=QawK8FT9bMVCu5zs2KYB6P/DyNAS9dJusJcsPWJ9LfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPesL9perQIUEiQKWBmrI+gWPoisUjbNsOoe7tYDdHX6L/6ESbMdugf4qBL1/+KMBIpNNfao4FNk7D42nRk3Im+Wl1odsCXh7zROZdHFT773qNOuFg8+prZaTEPJfW9/YajQnXUJWN5pBwc3mh8nSUk6q/eoJeAQY4O4rvoYNr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TM86x+Ff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TM86x+Ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034C6C4CEE9;
	Tue, 27 May 2025 17:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368462;
	bh=QawK8FT9bMVCu5zs2KYB6P/DyNAS9dJusJcsPWJ9LfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TM86x+Ffaad3wBzYey1KVrKsIEgzI7hjdm3rPbvXHmPlfctPCX0WRu0M+kNQRufzU
	 KJXz5IgQcbaBrXqo9xwKk4xM8k1vXd/rDNJjOAdqliZAbLmu2joihOh1x/9MV/r8NE
	 Lq7J+MV3HEAhGAbMJ1pYGcUN9QrngcjKQ+nyT/Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 715/783] octeontx2-pf: Add AF_XDP non-zero copy support
Date: Tue, 27 May 2025 18:28:32 +0200
Message-ID: <20250527162542.232684741@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suman Ghosh <sumang@marvell.com>

[ Upstream commit b4164de5041b51cda3438e75bce668e2556057c3 ]

Set xdp rx ring memory type as MEM_TYPE_PAGE_POOL for
af-xdp to work. This is needed since xdp_return_frame
internally will use page pools.

Fixes: 06059a1a9a4a ("octeontx2-pf: Add XDP support to netdev PF")
Signed-off-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 184fb40f731b ("octeontx2-pf: Avoid adding dcbnl_ops for LBK and SDP vf")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 2b49bfec78692..161cf33ef89ed 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1047,6 +1047,7 @@ static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
 	int err, pool_id, non_xdp_queues;
 	struct nix_aq_enq_req *aq;
 	struct otx2_cq_queue *cq;
+	struct otx2_pool *pool;
 
 	cq = &qset->cq[qidx];
 	cq->cq_idx = qidx;
@@ -1055,8 +1056,13 @@ static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
 		cq->cq_type = CQ_RX;
 		cq->cint_idx = qidx;
 		cq->cqe_cnt = qset->rqe_cnt;
-		if (pfvf->xdp_prog)
+		if (pfvf->xdp_prog) {
+			pool = &qset->pool[qidx];
 			xdp_rxq_info_reg(&cq->xdp_rxq, pfvf->netdev, qidx, 0);
+			xdp_rxq_info_reg_mem_model(&cq->xdp_rxq,
+						   MEM_TYPE_PAGE_POOL,
+						   pool->page_pool);
+		}
 	} else if (qidx < non_xdp_queues) {
 		cq->cq_type = CQ_TX;
 		cq->cint_idx = qidx - pfvf->hw.rx_queues;
-- 
2.39.5



