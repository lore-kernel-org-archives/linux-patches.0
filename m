Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781E1239E7B;
	Mon,  2 Jun 2025 14:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874079; cv=none; b=cPNe7+W2RjrnV6418U41lY3ZDGTgFftaZ4xEb0xp2MB4FIdPHMS9tVxZFSrpJx2tpnTSgLtVMm4oMYcZ6MDKB+jpHS6+r4EwJZE6EDveSNXc4wptNj9soJgeoU6RdTSVzFQAskGQ2W8LHPdwHBWn/hY2WmKBXjQuWFpW3+N6ObU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874079; c=relaxed/simple;
	bh=aJEbamDNI1mToeu3k3XiXrMHdh5JydhRzGRjvyAc87U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsbPUhLXZlDwlQXuOWX9Jubh3CjfRcwPXynZlmDmIzzQrXmoY5tJ7aK/bCfJLpkVayUtD91ARm8+5RfjapgU3M75qQ9wrdaIrbT5CQFmA59K9Uig6InXFefl6ATEllCUjXlciPNDgeTzvZ6BXT1h/iCLSZjzhUWtWAvVp60RzlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CC1LJeLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CC1LJeLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0685BC4CEEB;
	Mon,  2 Jun 2025 14:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874079;
	bh=aJEbamDNI1mToeu3k3XiXrMHdh5JydhRzGRjvyAc87U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CC1LJeLHe4J7vvF3Y/Y8GlSolLYo5y3dIUyCEE1pdkFUdhVL8ey04Yn7aLN48Z9R8
	 ifU8n+UN6+btP9bGC44yH8LAULKSRvKfYIX82EPPGz1qojcA8oYgutjSB4mOI8C27u
	 VmueCySqK7NcW6y2aACN7dgx/XGzfiKieNwnrRj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 351/444] octeontx2-pf: Add AF_XDP non-zero copy support
Date: Mon,  2 Jun 2025 15:46:55 +0200
Message-ID: <20250602134355.178904508@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suman Ghosh <sumang@marvell.com>

[ Upstream commit b4164de5041b51cda3438e75bce668e2556057c3 ]

Set xdp rx ring memory type as MEM_TYPE_PAGE_POOL for
af-xdp to work. This is needed since xdp_return_frame
internally will use page pools.

Fixes: 06059a1a9a4a ("octeontx2-pf: Add XDP support to netdev PF")
Signed-off-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 47adccf7a7776..1999918ca500f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -988,6 +988,7 @@ static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
 	int err, pool_id, non_xdp_queues;
 	struct nix_aq_enq_req *aq;
 	struct otx2_cq_queue *cq;
+	struct otx2_pool *pool;
 
 	cq = &qset->cq[qidx];
 	cq->cq_idx = qidx;
@@ -996,8 +997,13 @@ static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
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



