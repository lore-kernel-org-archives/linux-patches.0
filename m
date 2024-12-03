Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066E781ADA;
	Tue,  3 Dec 2024 15:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240797; cv=none; b=sa/TvwLnDtWtArY0Etiiawv0a9xdQUZlix8rkbNH96LuC1h3xg3UCDjBJd0wFBNTAHbvGEbkEmC7aNBmP1/JsDMHCS2mYJLz6JW4BUnur5uE9SC7xSrrha8JwUGl40RU9ZZd1UeZaEMm5E3LsBxUsJ6Y/IUCSI0Uf1LjuFAh/0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240797; c=relaxed/simple;
	bh=ykAUMsd1nYidCPqeNBafXCzkz75HNkQqs8jTXTYVq6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vE2Ub6ms1Lp1nxuMmbJaaoAQnZg1iwWCB2tSrOwTf7koK6gDQlf79kpvV8HaRiYcD5gcfKOxd8jAs8rMfWFMJFufbIMpDt2gMj/2puqPpGpHRO4LrWRSWi/OjzvqC2U7kBJrylzIfgU9Fvl83fBLcDQk3XVv93z71niECDIDzgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrAB5aWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrAB5aWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6980CC4CECF;
	Tue,  3 Dec 2024 15:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240796;
	bh=ykAUMsd1nYidCPqeNBafXCzkz75HNkQqs8jTXTYVq6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wrAB5aWdM2ReSwhhLeCzS5pvTFmhXDWq9gcvAd2ER2dZrhioODiEkkil+dzAcAeoB
	 HZrYVr6vCRG1nD1e/zdtgi7m6m0QaBw6BuyajqxDaYyn5fC2E++TJgmYRs1PpLxmC0
	 +9+df5u+VqW5X+WDmO9UvwBZ+yMej0SelsHytk9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 236/826] ice: consistently use q_idx in ice_vc_cfg_qs_msg()
Date: Tue,  3 Dec 2024 15:39:23 +0100
Message-ID: <20241203144752.964587448@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit a884c304e18a40e1c7a6525a9274e64c2c061c3f ]

The ice_vc_cfg_qs_msg() function is used to configure VF queues in response
to a VIRTCHNL_OP_CONFIG_VSI_QUEUES command.

The virtchnl command contains an array of queue pair data for configuring
Tx and Rx queues. This data includes a queue ID. When configuring the
queues, the driver generally uses this queue ID to determine which Tx and
Rx ring to program. However, a handful of places use the index into the
queue pair data from the VF. While most VF implementations appear to send
this data in order, it is not mandated by the virtchnl and it is not
verified that the queue pair data comes in order.

Fix the driver to consistently use the q_idx field instead of the 'i'
iterator value when accessing the rings. For the Rx case, introduce a local
ring variable to keep lines short.

Fixes: 7ad15440acf8 ("ice: Refactor VIRTCHNL_OP_CONFIG_VSI_QUEUES handling")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 21 +++++++++----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 59f62306b9cb0..b6ec01f6fa73e 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -1715,8 +1715,8 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 
 		/* copy Tx queue info from VF into VSI */
 		if (qpi->txq.ring_len > 0) {
-			vsi->tx_rings[i]->dma = qpi->txq.dma_ring_addr;
-			vsi->tx_rings[i]->count = qpi->txq.ring_len;
+			vsi->tx_rings[q_idx]->dma = qpi->txq.dma_ring_addr;
+			vsi->tx_rings[q_idx]->count = qpi->txq.ring_len;
 
 			/* Disable any existing queue first */
 			if (ice_vf_vsi_dis_single_txq(vf, vsi, q_idx))
@@ -1725,7 +1725,7 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 			/* Configure a queue with the requested settings */
 			if (ice_vsi_cfg_single_txq(vsi, vsi->tx_rings, q_idx)) {
 				dev_warn(ice_pf_to_dev(pf), "VF-%d failed to configure TX queue %d\n",
-					 vf->vf_id, i);
+					 vf->vf_id, q_idx);
 				goto error_param;
 			}
 		}
@@ -1733,24 +1733,23 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 		/* copy Rx queue info from VF into VSI */
 		if (qpi->rxq.ring_len > 0) {
 			u16 max_frame_size = ice_vc_get_max_frame_size(vf);
+			struct ice_rx_ring *ring = vsi->rx_rings[q_idx];
 			u32 rxdid;
 
-			vsi->rx_rings[i]->dma = qpi->rxq.dma_ring_addr;
-			vsi->rx_rings[i]->count = qpi->rxq.ring_len;
+			ring->dma = qpi->rxq.dma_ring_addr;
+			ring->count = qpi->rxq.ring_len;
 
 			if (qpi->rxq.crc_disable)
-				vsi->rx_rings[q_idx]->flags |=
-					ICE_RX_FLAGS_CRC_STRIP_DIS;
+				ring->flags |= ICE_RX_FLAGS_CRC_STRIP_DIS;
 			else
-				vsi->rx_rings[q_idx]->flags &=
-					~ICE_RX_FLAGS_CRC_STRIP_DIS;
+				ring->flags &= ~ICE_RX_FLAGS_CRC_STRIP_DIS;
 
 			if (qpi->rxq.databuffer_size != 0 &&
 			    (qpi->rxq.databuffer_size > ((16 * 1024) - 128) ||
 			     qpi->rxq.databuffer_size < 1024))
 				goto error_param;
 			vsi->rx_buf_len = qpi->rxq.databuffer_size;
-			vsi->rx_rings[i]->rx_buf_len = vsi->rx_buf_len;
+			ring->rx_buf_len = vsi->rx_buf_len;
 			if (qpi->rxq.max_pkt_size > max_frame_size ||
 			    qpi->rxq.max_pkt_size < 64)
 				goto error_param;
@@ -1765,7 +1764,7 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 
 			if (ice_vsi_cfg_single_rxq(vsi, q_idx)) {
 				dev_warn(ice_pf_to_dev(pf), "VF-%d failed to configure RX queue %d\n",
-					 vf->vf_id, i);
+					 vf->vf_id, q_idx);
 				goto error_param;
 			}
 
-- 
2.43.0



