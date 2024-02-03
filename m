Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C15481AE;
	Sat,  3 Feb 2024 04:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933708; cv=none; b=e5PsNB2GlgMcBcLN8FB+qXJ5Pb5UlDCdrSO3t3917IU2tdbvNE/YjjxYm4kqAhmi/I9TllZuemsizLPIQY6jH//ihwnOBf6VEaYQcV+aqp04uNlZMoF6muLWyvmDQtpOzeWK2OM4pXMh5Li7ZLhWmgdS+9634hUUzCnA7oeJ/a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933708; c=relaxed/simple;
	bh=ONFO7+43lXowTJn9ejqWSQcKBHWP+6aY1w9oYR3mohY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdFF3V3DJl6cvJQsfOFk1gcTtFcP4xPv5fOlJPlgdzSy2svqiYgev5FAqt4YxER5GgOP8liuD6+SQbRZlP0ZTw2CY8cBb4t6I8P9cRC/98CpwG5evhR+rB1LDLsvdYmj6I6RN6IOut1vP3nj48fJyviViKuj1ExUp4EBVmUkXJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8QX+YzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8QX+YzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB5FC433F1;
	Sat,  3 Feb 2024 04:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933708;
	bh=ONFO7+43lXowTJn9ejqWSQcKBHWP+6aY1w9oYR3mohY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w8QX+YzUSiyXTye9ZN4pKW0o4MnhDLwwZ9SiUNlPJ2QbOjHcTcL31Nq975cA4DHdG
	 lZALrvzPdSN6tY1jfi73e18kAcKWNeI5RHs98HNB9L1Z3w3XQpOH2kKChorQN19Ck2
	 a5hCQTrl3BFUhiyPpG6Wr4X5QozCVybVX4X2H3HY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 310/322] octeontx2-pf: Remove xdp queues on program detach
Date: Fri,  2 Feb 2024 20:06:47 -0800
Message-ID: <20240203035409.047604927@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 04f647c8e456fcfabe9c252a4dcaee03b586fa4f ]

XDP queues are created/destroyed when a XDP program
is attached/detached. In current driver xdp_queues are not
getting destroyed on program exit due to incorrect xdp_queue
and tot_tx_queue count values.

This patch fixes the issue by setting tot_tx_queue and xdp_queue
count to correct values. It also fixes xdp.data_hard_start address.

Fixes: 06059a1a9a4a ("octeontx2-pf: Add XDP support to netdev PF")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Link: https://lore.kernel.org/r/20240130120610.16673-1-gakula@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 1 -
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c      | 3 +--
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c    | 7 +++----
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 53f6258a973c..8b7fc0af91ce 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -314,7 +314,6 @@ static int otx2_set_channels(struct net_device *dev,
 	pfvf->hw.tx_queues = channel->tx_count;
 	if (pfvf->xdp_prog)
 		pfvf->hw.xdp_queues = channel->rx_count;
-	pfvf->hw.non_qos_queues =  pfvf->hw.tx_queues + pfvf->hw.xdp_queues;
 
 	if (if_up)
 		err = dev->netdev_ops->ndo_open(dev);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index a57455aebff6..e5fe67e73865 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1744,6 +1744,7 @@ int otx2_open(struct net_device *netdev)
 	/* RQ and SQs are mapped to different CQs,
 	 * so find out max CQ IRQs (i.e CINTs) needed.
 	 */
+	pf->hw.non_qos_queues =  pf->hw.tx_queues + pf->hw.xdp_queues;
 	pf->hw.cint_cnt = max3(pf->hw.rx_queues, pf->hw.tx_queues,
 			       pf->hw.tc_tx_queues);
 
@@ -2643,8 +2644,6 @@ static int otx2_xdp_setup(struct otx2_nic *pf, struct bpf_prog *prog)
 		xdp_features_clear_redirect_target(dev);
 	}
 
-	pf->hw.non_qos_queues += pf->hw.xdp_queues;
-
 	if (if_up)
 		otx2_open(pf->netdev);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 4d519ea833b2..f828d32737af 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -1403,7 +1403,7 @@ static bool otx2_xdp_rcv_pkt_handler(struct otx2_nic *pfvf,
 				     struct otx2_cq_queue *cq,
 				     bool *need_xdp_flush)
 {
-	unsigned char *hard_start, *data;
+	unsigned char *hard_start;
 	int qidx = cq->cq_idx;
 	struct xdp_buff xdp;
 	struct page *page;
@@ -1417,9 +1417,8 @@ static bool otx2_xdp_rcv_pkt_handler(struct otx2_nic *pfvf,
 
 	xdp_init_buff(&xdp, pfvf->rbsize, &cq->xdp_rxq);
 
-	data = (unsigned char *)phys_to_virt(pa);
-	hard_start = page_address(page);
-	xdp_prepare_buff(&xdp, hard_start, data - hard_start,
+	hard_start = (unsigned char *)phys_to_virt(pa);
+	xdp_prepare_buff(&xdp, hard_start, OTX2_HEAD_ROOM,
 			 cqe->sg.seg_size, false);
 
 	act = bpf_prog_run_xdp(prog, &xdp);
-- 
2.43.0



