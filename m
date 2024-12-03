Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362C71F6691;
	Tue,  3 Dec 2024 15:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238407; cv=none; b=iDlta1gcHVl7kWCXxYt3wG95QbvcLlcZSfteK4/oi2vbMwCVh0JsM3CB1zSwjyJISuPsZ0rpppp9l6bN0Z/ALtb+HCsJTbxuKUn0K5mcTh4khp/43+GSyyQPY1cNti4qYsGgqrKIRiyPAZaUJ5RyFK964z96kS48lGcQqEAmn8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238407; c=relaxed/simple;
	bh=AfykGuirblxk87HXrucTMBVIUf4zkoTNzhO5ZVzP4mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVYXNF0xdBBq1r7MDK2Mr4YE1eb8/XLqaXYqUJSzzY5T+wP7ojwha4y31yqK46igYLmUil8Jz4VxHmXGPldmbFa+sTLKXQDBP0sASnu6r0GMFALbOBtuFv0JYL50ayvuYYaJl15f5NiLr79uk4qen/KZ7pT7DW8P+1teXPFeyOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzbJceS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzbJceS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF03C4CECF;
	Tue,  3 Dec 2024 15:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238407;
	bh=AfykGuirblxk87HXrucTMBVIUf4zkoTNzhO5ZVzP4mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzbJceS+kEl9gNMoGnvO2dquvU4wMWxm73F0MvXJVL3ChjbsxtS2uAtP/i3ilor+a
	 T75XMTMOAVtMrR7TJZGxsjlETL2dfs0+QNax/Vo5Mk8GOGRD/0ziox2IeZ3MSx2Jgu
	 1SRUWFxmnN+O6xOEhE+QHwgZWvGdvRSJPyJUgUNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 265/817] ice: consistently use q_idx in ice_vc_cfg_qs_msg()
Date: Tue,  3 Dec 2024 15:37:17 +0100
Message-ID: <20241203144006.133076612@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 1c6ce0c4ed4ee..d7fd4bc18f021 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -1711,8 +1711,8 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 
 		/* copy Tx queue info from VF into VSI */
 		if (qpi->txq.ring_len > 0) {
-			vsi->tx_rings[i]->dma = qpi->txq.dma_ring_addr;
-			vsi->tx_rings[i]->count = qpi->txq.ring_len;
+			vsi->tx_rings[q_idx]->dma = qpi->txq.dma_ring_addr;
+			vsi->tx_rings[q_idx]->count = qpi->txq.ring_len;
 
 			/* Disable any existing queue first */
 			if (ice_vf_vsi_dis_single_txq(vf, vsi, q_idx))
@@ -1721,7 +1721,7 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 			/* Configure a queue with the requested settings */
 			if (ice_vsi_cfg_single_txq(vsi, vsi->tx_rings, q_idx)) {
 				dev_warn(ice_pf_to_dev(pf), "VF-%d failed to configure TX queue %d\n",
-					 vf->vf_id, i);
+					 vf->vf_id, q_idx);
 				goto error_param;
 			}
 		}
@@ -1729,24 +1729,23 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
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
@@ -1761,7 +1760,7 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 
 			if (ice_vsi_cfg_single_rxq(vsi, q_idx)) {
 				dev_warn(ice_pf_to_dev(pf), "VF-%d failed to configure RX queue %d\n",
-					 vf->vf_id, i);
+					 vf->vf_id, q_idx);
 				goto error_param;
 			}
 
-- 
2.43.0



