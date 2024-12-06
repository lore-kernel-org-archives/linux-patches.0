Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC0110E0;
	Fri,  6 Dec 2024 14:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497089; cv=none; b=eqVMHsBfPHkB4v6EHF7zY0YJyRdaPEMOx0a5Fqzeofrxp5mrWm6k+99RdvJetNo2iE+GZU/EbIIohziC6n36E6RkL65pmaqJRhbmVUaybqzkFJO+KUbW9MxeoWYguD9czhpg0F32nV/7Q1dbpvAaczuV37YO7gYnjYKGgudlQQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497089; c=relaxed/simple;
	bh=uJfP+auvJVJsXsbgG/rcHXp+X3eJd7pkDK/wojU88FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqE+Bg9sX6Vi8DOjSG+euRfR2BzzZhlarM76NuE5WwL+1uLi9cvWWx4BflPbajkbmtOAQpU59XuTIoh9eV6/nGa3b9bVcIVBX0QLEj28G++wGv1JguxmYPxWs0trNDVdtrwJXXgEZj+DXn+UvsZNRMj2Fr6kPGhdE9ZQUvWyhx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svvFhdwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svvFhdwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49824C4CED1;
	Fri,  6 Dec 2024 14:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497089;
	bh=uJfP+auvJVJsXsbgG/rcHXp+X3eJd7pkDK/wojU88FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=svvFhdwtfc1W/KG5t+nYjluz75XKvQmig/2zd8+C2txg4C23UMUo0XnUCiBkxSXfF
	 tNwjJmV9N9+5DbO4FUK4jsfpQQ+kgnBb/nkksWJnUkoI47Pg0HDP4Eak4+PCrZd35l
	 kpIU58wlTA+ueKHmZs8OJtos4PrZc2s8o238ecZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 192/676] ice: consistently use q_idx in ice_vc_cfg_qs_msg()
Date: Fri,  6 Dec 2024 15:30:11 +0100
Message-ID: <20241206143700.844589909@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index 216c029661db2..9f7268bb2ee3b 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -1645,8 +1645,8 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 
 		/* copy Tx queue info from VF into VSI */
 		if (qpi->txq.ring_len > 0) {
-			vsi->tx_rings[i]->dma = qpi->txq.dma_ring_addr;
-			vsi->tx_rings[i]->count = qpi->txq.ring_len;
+			vsi->tx_rings[q_idx]->dma = qpi->txq.dma_ring_addr;
+			vsi->tx_rings[q_idx]->count = qpi->txq.ring_len;
 
 			/* Disable any existing queue first */
 			if (ice_vf_vsi_dis_single_txq(vf, vsi, q_idx))
@@ -1655,7 +1655,7 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 			/* Configure a queue with the requested settings */
 			if (ice_vsi_cfg_single_txq(vsi, vsi->tx_rings, q_idx)) {
 				dev_warn(ice_pf_to_dev(pf), "VF-%d failed to configure TX queue %d\n",
-					 vf->vf_id, i);
+					 vf->vf_id, q_idx);
 				goto error_param;
 			}
 		}
@@ -1663,10 +1663,11 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 		/* copy Rx queue info from VF into VSI */
 		if (qpi->rxq.ring_len > 0) {
 			u16 max_frame_size = ice_vc_get_max_frame_size(vf);
+			struct ice_rx_ring *ring = vsi->rx_rings[q_idx];
 			u32 rxdid;
 
-			vsi->rx_rings[i]->dma = qpi->rxq.dma_ring_addr;
-			vsi->rx_rings[i]->count = qpi->rxq.ring_len;
+			ring->dma = qpi->rxq.dma_ring_addr;
+			ring->count = qpi->rxq.ring_len;
 
 			if (qpi->rxq.crc_disable &&
 			    !(vf->driver_caps & VIRTCHNL_VF_OFFLOAD_CRC)) {
@@ -1674,18 +1675,16 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 			}
 
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
@@ -1700,7 +1699,7 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 
 			if (ice_vsi_cfg_single_rxq(vsi, q_idx)) {
 				dev_warn(ice_pf_to_dev(pf), "VF-%d failed to configure RX queue %d\n",
-					 vf->vf_id, i);
+					 vf->vf_id, q_idx);
 				goto error_param;
 			}
 
-- 
2.43.0



