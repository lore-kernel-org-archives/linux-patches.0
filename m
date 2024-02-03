Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853E156741;
	Sat,  3 Feb 2024 04:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933983; cv=none; b=qBPkmTeZh4n+uNVWB/+SCGmU+f4SdysUlhWaCa8sJtBFaHCtLTSr6HRUeBVsn8bMMPOY0HLmNHJQnDEHFBQRaPAJ2gGMRSn7qqWylO3eLKsZAsP7WCSS4wNtLR0p94rzsgzG947eIMESHHIcG3Ptp1YXJ3VpJSUHWUVSPogcPbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933983; c=relaxed/simple;
	bh=5P+5EZbhWo6qDyuPs8Zqa1n+p2EnDbZTQqOUQtouUTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7CvePO7ouog780KtRNWk+jfP6elT1LV1VQLJyZvoNODL2JiYYSMtwmy6NyhL2EBgQedZ9VvDG8+GX1D4LmnBmdcG8FxfE6J86DVdWniqLjrFwxni4vEikh0u0DdMJkSqJwEB7kzAfsEIKXWqsyjgwLj6pCEp1MEX2zVWykzlH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jp6JX6ls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jp6JX6ls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF7EC433B2;
	Sat,  3 Feb 2024 04:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933983;
	bh=5P+5EZbhWo6qDyuPs8Zqa1n+p2EnDbZTQqOUQtouUTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jp6JX6lsU3cwzIAvpglg7dvjxf0uqmqW1HDAMiho8NCgDigFwmy2aRRp/OabIdQ2h
	 +2lvXSa3w41xwndaSnFeizH0aviYeoo6OU9Ic5a/9+cf/NUFOuE814yNiz/V/NYzC+
	 2yQ/8maRZgaDhTGk4KnCuQH8to2T7OW7XMtz7f/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 341/353] octeontx2-pf: Remove xdp queues on program detach
Date: Fri,  2 Feb 2024 20:07:39 -0800
Message-ID: <20240203035414.558035969@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



