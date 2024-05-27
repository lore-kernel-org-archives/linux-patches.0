Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980531EEF7;
	Mon, 27 May 2024 19:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838315; cv=none; b=hCKwEAt/JYadA3enWhKly+KWHPkpzix7A3KwJ1zCB6tnyILgxPlXKOsTkRoLIDqnhpOfaluvXGb4E8s/bjqXuiibH1DuXwzs7pUNI1ojMPre9b5tgK/vQhKZ4p++2NSudnGtfqopra+ZarM4hNVa383B2Ou9Or/YihAeXO7wXA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838315; c=relaxed/simple;
	bh=wUUxiXSfpAOtcP8OuTUB6k/QCL+CgbEMpRr+1HesCAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuWnFiYisnvdaGijpkuTp+5E1qx58nm8WCGONndZll8kJRYPpA47KNG1O+8tVmx7RY4PFWZaYhiMsqYKRFdbK6JegVS/p6ucT4uq1VHCoAncGy1BJ+aIFz2x7eFG+coBmMROp0SGbfl3l0/Pk1BB0l++hGs8iPXSYZ5FIWVo25M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+40XD3n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+40XD3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C80BC32781;
	Mon, 27 May 2024 19:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838315;
	bh=wUUxiXSfpAOtcP8OuTUB6k/QCL+CgbEMpRr+1HesCAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+40XD3nkB5Wut5Ppej+UKfj2doGpWF1v7Uq69nguj26WLGxMd7V6uNvM/6cBu9zH
	 CsUEieVNgAsXtjQnyqrfq+l5B22hXhMg2XoZ18vPO4yBM4u5Inm6ZHBDVm4DVFtx8v
	 Yf5uDuFvnCFtlF+hcFYxcfslRVT2xgue0d0J0E6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.8 345/493] ice: make ice_vsi_cfg_rxq() static
Date: Mon, 27 May 2024 20:55:47 +0200
Message-ID: <20240527185641.564963525@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 3e5fb691faee1d43ee13d4ce2666b0a05e1555b3 ]

Currently, XSK control path in ice driver calls directly
ice_vsi_cfg_rxq() whereas we have ice_vsi_cfg_single_rxq() for that
purpose. Use the latter from XSK side and make ice_vsi_cfg_rxq() static.

ice_vsi_cfg_rxq() resides in ice_base.c and is rather big, so to reduce
the code churn let us move two callers of it from ice_lib.c to
ice_base.c.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: e77f43d531af ("Bluetooth: hci_core: Fix not handling hdev->le_num_of_adv_sets=1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_base.c | 58 ++++++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_base.h |  3 +-
 drivers/net/ethernet/intel/ice/ice_lib.c  | 56 ----------------------
 drivers/net/ethernet/intel/ice/ice_lib.h  |  4 --
 drivers/net/ethernet/intel/ice/ice_xsk.c  |  2 +-
 5 files changed, 60 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index c979192e44d10..9263754c9525d 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -536,7 +536,7 @@ static void ice_xsk_pool_fill_cb(struct ice_rx_ring *ring)
  *
  * Return 0 on success and a negative value on error.
  */
-int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
+static int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 {
 	struct device *dev = ice_pf_to_dev(ring->vsi->back);
 	u32 num_bufs = ICE_RX_DESC_UNUSED(ring);
@@ -631,6 +631,62 @@ int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 	return 0;
 }
 
+int ice_vsi_cfg_single_rxq(struct ice_vsi *vsi, u16 q_idx)
+{
+	if (q_idx >= vsi->num_rxq)
+		return -EINVAL;
+
+	return ice_vsi_cfg_rxq(vsi->rx_rings[q_idx]);
+}
+
+/**
+ * ice_vsi_cfg_frame_size - setup max frame size and Rx buffer length
+ * @vsi: VSI
+ */
+static void ice_vsi_cfg_frame_size(struct ice_vsi *vsi)
+{
+	if (!vsi->netdev || test_bit(ICE_FLAG_LEGACY_RX, vsi->back->flags)) {
+		vsi->max_frame = ICE_MAX_FRAME_LEGACY_RX;
+		vsi->rx_buf_len = ICE_RXBUF_1664;
+#if (PAGE_SIZE < 8192)
+	} else if (!ICE_2K_TOO_SMALL_WITH_PADDING &&
+		   (vsi->netdev->mtu <= ETH_DATA_LEN)) {
+		vsi->max_frame = ICE_RXBUF_1536 - NET_IP_ALIGN;
+		vsi->rx_buf_len = ICE_RXBUF_1536 - NET_IP_ALIGN;
+#endif
+	} else {
+		vsi->max_frame = ICE_AQ_SET_MAC_FRAME_SIZE_MAX;
+		vsi->rx_buf_len = ICE_RXBUF_3072;
+	}
+}
+
+/**
+ * ice_vsi_cfg_rxqs - Configure the VSI for Rx
+ * @vsi: the VSI being configured
+ *
+ * Return 0 on success and a negative value on error
+ * Configure the Rx VSI for operation.
+ */
+int ice_vsi_cfg_rxqs(struct ice_vsi *vsi)
+{
+	u16 i;
+
+	if (vsi->type == ICE_VSI_VF)
+		goto setup_rings;
+
+	ice_vsi_cfg_frame_size(vsi);
+setup_rings:
+	/* set up individual rings */
+	ice_for_each_rxq(vsi, i) {
+		int err = ice_vsi_cfg_rxq(vsi->rx_rings[i]);
+
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 /**
  * __ice_vsi_get_qs - helper function for assigning queues from PF to VSI
  * @qs_cfg: gathered variables needed for pf->vsi queues assignment
diff --git a/drivers/net/ethernet/intel/ice/ice_base.h b/drivers/net/ethernet/intel/ice/ice_base.h
index 17321ba75602d..85e6076445602 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.h
+++ b/drivers/net/ethernet/intel/ice/ice_base.h
@@ -6,7 +6,8 @@
 
 #include "ice.h"
 
-int ice_vsi_cfg_rxq(struct ice_rx_ring *ring);
+int ice_vsi_cfg_single_rxq(struct ice_vsi *vsi, u16 q_idx);
+int ice_vsi_cfg_rxqs(struct ice_vsi *vsi);
 int __ice_vsi_get_qs(struct ice_qs_cfg *qs_cfg);
 int
 ice_vsi_ctrl_one_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx, bool wait);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index cfc20684f25ab..27b3423c9ff23 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1671,27 +1671,6 @@ static void ice_vsi_set_rss_flow_fld(struct ice_vsi *vsi)
 	}
 }
 
-/**
- * ice_vsi_cfg_frame_size - setup max frame size and Rx buffer length
- * @vsi: VSI
- */
-static void ice_vsi_cfg_frame_size(struct ice_vsi *vsi)
-{
-	if (!vsi->netdev || test_bit(ICE_FLAG_LEGACY_RX, vsi->back->flags)) {
-		vsi->max_frame = ICE_MAX_FRAME_LEGACY_RX;
-		vsi->rx_buf_len = ICE_RXBUF_1664;
-#if (PAGE_SIZE < 8192)
-	} else if (!ICE_2K_TOO_SMALL_WITH_PADDING &&
-		   (vsi->netdev->mtu <= ETH_DATA_LEN)) {
-		vsi->max_frame = ICE_RXBUF_1536 - NET_IP_ALIGN;
-		vsi->rx_buf_len = ICE_RXBUF_1536 - NET_IP_ALIGN;
-#endif
-	} else {
-		vsi->max_frame = ICE_AQ_SET_MAC_FRAME_SIZE_MAX;
-		vsi->rx_buf_len = ICE_RXBUF_3072;
-	}
-}
-
 /**
  * ice_pf_state_is_nominal - checks the PF for nominal state
  * @pf: pointer to PF to check
@@ -1795,14 +1774,6 @@ ice_write_qrxflxp_cntxt(struct ice_hw *hw, u16 pf_q, u32 rxdid, u32 prio,
 	wr32(hw, QRXFLXP_CNTXT(pf_q), regval);
 }
 
-int ice_vsi_cfg_single_rxq(struct ice_vsi *vsi, u16 q_idx)
-{
-	if (q_idx >= vsi->num_rxq)
-		return -EINVAL;
-
-	return ice_vsi_cfg_rxq(vsi->rx_rings[q_idx]);
-}
-
 int ice_vsi_cfg_single_txq(struct ice_vsi *vsi, struct ice_tx_ring **tx_rings, u16 q_idx)
 {
 	DEFINE_FLEX(struct ice_aqc_add_tx_qgrp, qg_buf, txqs, 1);
@@ -1815,33 +1786,6 @@ int ice_vsi_cfg_single_txq(struct ice_vsi *vsi, struct ice_tx_ring **tx_rings, u
 	return ice_vsi_cfg_txq(vsi, tx_rings[q_idx], qg_buf);
 }
 
-/**
- * ice_vsi_cfg_rxqs - Configure the VSI for Rx
- * @vsi: the VSI being configured
- *
- * Return 0 on success and a negative value on error
- * Configure the Rx VSI for operation.
- */
-int ice_vsi_cfg_rxqs(struct ice_vsi *vsi)
-{
-	u16 i;
-
-	if (vsi->type == ICE_VSI_VF)
-		goto setup_rings;
-
-	ice_vsi_cfg_frame_size(vsi);
-setup_rings:
-	/* set up individual rings */
-	ice_for_each_rxq(vsi, i) {
-		int err = ice_vsi_cfg_rxq(vsi->rx_rings[i]);
-
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
 /**
  * ice_vsi_cfg_txqs - Configure the VSI for Tx
  * @vsi: the VSI being configured
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index bfcfc582a4c04..95505a501a935 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -54,12 +54,8 @@ bool ice_pf_state_is_nominal(struct ice_pf *pf);
 
 void ice_update_eth_stats(struct ice_vsi *vsi);
 
-int ice_vsi_cfg_single_rxq(struct ice_vsi *vsi, u16 q_idx);
-
 int ice_vsi_cfg_single_txq(struct ice_vsi *vsi, struct ice_tx_ring **tx_rings, u16 q_idx);
 
-int ice_vsi_cfg_rxqs(struct ice_vsi *vsi);
-
 int ice_vsi_cfg_lan_txqs(struct ice_vsi *vsi);
 
 void ice_vsi_cfg_msix(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 2eecd0f39aa69..9e01f410af772 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -250,7 +250,7 @@ static int ice_qp_ena(struct ice_vsi *vsi, u16 q_idx)
 		ice_tx_xsk_pool(vsi, q_idx);
 	}
 
-	err = ice_vsi_cfg_rxq(rx_ring);
+	err = ice_vsi_cfg_single_rxq(vsi, q_idx);
 	if (err)
 		return err;
 
-- 
2.43.0



