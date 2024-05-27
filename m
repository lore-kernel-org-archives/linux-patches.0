Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF59C17727;
	Mon, 27 May 2024 19:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838320; cv=none; b=e78kW1j++X2VCV/joZgmCdE4X+AzOi+rlUNpcGjjQQ4aZFrNzB+OVWA6UrI5megMAzxmaXrBwj+oQQsNGdLvpHIIvuE5OT7wpyvnQQd8NxaqnKsRf84OAzMb9NpZd1jkKpz+22d1mj8r4a405FmIiARb0AvCXIXk21N1i64B4/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838320; c=relaxed/simple;
	bh=DSVu94BTwnofbe99S/WqH0Mmq2B5+OYtJy42vmpmark=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmyEMRj+rdw35rzEE2zAfgTYVN/ddjaP1ODe3yaTQQNT45K2TvYT5JUD2JqvRzojV+H/K678ewGycXe6XIHNqYtuCxQFIxqi+boaPIcNSRPdwCRB5JA7qSzmNRVkkNxMOchb5yS5nZ3U9ZEKBBei9uBfV1Y2FYP0kWwC4jOUFLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHxIBfnA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHxIBfnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB03C2BBFC;
	Mon, 27 May 2024 19:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838320;
	bh=DSVu94BTwnofbe99S/WqH0Mmq2B5+OYtJy42vmpmark=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHxIBfnADRIIaTgz7MRvEyEEZRqGjo0nnAigI55bH8r5Ix5uMmQzEMfblGszoWnPO
	 lWD2DHXSkh7sYz1W6h1b9lsE/m9fJgGGa4C60RfMKe17MLRFsi5f8UkQXk0l8t7oGv
	 Oq+PaAtbnnJZwlJK6ZVY5HxaUEaUia3JRbNzg4lo=
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
Subject: [PATCH 6.8 346/493] ice: make ice_vsi_cfg_txq() static
Date: Mon, 27 May 2024 20:55:48 +0200
Message-ID: <20240527185641.596850106@linuxfoundation.org>
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

[ Upstream commit a292ba981324ec790eb671df1c64fae5c98c4b3d ]

Currently, XSK control path in ice driver calls directly
ice_vsi_cfg_txq() whereas we have ice_vsi_cfg_single_txq() for that
purpose. Use the latter from XSK side and make ice_vsi_cfg_txq() static.

ice_vsi_cfg_txq() resides in ice_base.c and is rather big, so to reduce
the code churn let us move the callers of it from ice_lib.c to
ice_base.c.

This change puts ice_qp_ena() on nice diet due to the checks and
operations that ice_vsi_cfg_single_{r,t}xq() do internally.

add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-182 (-182)
Function                                     old     new   delta
ice_xsk_pool_setup                          2165    1983    -182
Total: Before=472597, After=472415, chg -0.04%

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: e77f43d531af ("Bluetooth: hci_core: Fix not handling hdev->le_num_of_adv_sets=1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_base.c | 76 ++++++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_base.h |  7 ++-
 drivers/net/ethernet/intel/ice/ice_lib.c  | 73 ----------------------
 drivers/net/ethernet/intel/ice/ice_lib.h  |  6 --
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 20 +-----
 5 files changed, 82 insertions(+), 100 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 9263754c9525d..d2fd315556a39 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -882,7 +882,7 @@ void ice_vsi_free_q_vectors(struct ice_vsi *vsi)
  * @ring: Tx ring to be configured
  * @qg_buf: queue group buffer
  */
-int
+static int
 ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_tx_ring *ring,
 		struct ice_aqc_add_tx_qgrp *qg_buf)
 {
@@ -953,6 +953,80 @@ ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_tx_ring *ring,
 	return 0;
 }
 
+int ice_vsi_cfg_single_txq(struct ice_vsi *vsi, struct ice_tx_ring **tx_rings,
+			   u16 q_idx)
+{
+	DEFINE_FLEX(struct ice_aqc_add_tx_qgrp, qg_buf, txqs, 1);
+
+	if (q_idx >= vsi->alloc_txq || !tx_rings || !tx_rings[q_idx])
+		return -EINVAL;
+
+	qg_buf->num_txqs = 1;
+
+	return ice_vsi_cfg_txq(vsi, tx_rings[q_idx], qg_buf);
+}
+
+/**
+ * ice_vsi_cfg_txqs - Configure the VSI for Tx
+ * @vsi: the VSI being configured
+ * @rings: Tx ring array to be configured
+ * @count: number of Tx ring array elements
+ *
+ * Return 0 on success and a negative value on error
+ * Configure the Tx VSI for operation.
+ */
+static int
+ice_vsi_cfg_txqs(struct ice_vsi *vsi, struct ice_tx_ring **rings, u16 count)
+{
+	DEFINE_FLEX(struct ice_aqc_add_tx_qgrp, qg_buf, txqs, 1);
+	int err = 0;
+	u16 q_idx;
+
+	qg_buf->num_txqs = 1;
+
+	for (q_idx = 0; q_idx < count; q_idx++) {
+		err = ice_vsi_cfg_txq(vsi, rings[q_idx], qg_buf);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+
+/**
+ * ice_vsi_cfg_lan_txqs - Configure the VSI for Tx
+ * @vsi: the VSI being configured
+ *
+ * Return 0 on success and a negative value on error
+ * Configure the Tx VSI for operation.
+ */
+int ice_vsi_cfg_lan_txqs(struct ice_vsi *vsi)
+{
+	return ice_vsi_cfg_txqs(vsi, vsi->tx_rings, vsi->num_txq);
+}
+
+/**
+ * ice_vsi_cfg_xdp_txqs - Configure Tx queues dedicated for XDP in given VSI
+ * @vsi: the VSI being configured
+ *
+ * Return 0 on success and a negative value on error
+ * Configure the Tx queues dedicated for XDP in given VSI for operation.
+ */
+int ice_vsi_cfg_xdp_txqs(struct ice_vsi *vsi)
+{
+	int ret;
+	int i;
+
+	ret = ice_vsi_cfg_txqs(vsi, vsi->xdp_rings, vsi->num_xdp_txq);
+	if (ret)
+		return ret;
+
+	ice_for_each_rxq(vsi, i)
+		ice_tx_xsk_pool(vsi, i);
+
+	return 0;
+}
+
 /**
  * ice_cfg_itr - configure the initial interrupt throttle values
  * @hw: pointer to the HW structure
diff --git a/drivers/net/ethernet/intel/ice/ice_base.h b/drivers/net/ethernet/intel/ice/ice_base.h
index 85e6076445602..b711bc921928d 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.h
+++ b/drivers/net/ethernet/intel/ice/ice_base.h
@@ -15,9 +15,10 @@ int ice_vsi_wait_one_rx_ring(struct ice_vsi *vsi, bool ena, u16 rxq_idx);
 int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi);
 void ice_vsi_map_rings_to_vectors(struct ice_vsi *vsi);
 void ice_vsi_free_q_vectors(struct ice_vsi *vsi);
-int
-ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_tx_ring *ring,
-		struct ice_aqc_add_tx_qgrp *qg_buf);
+int ice_vsi_cfg_single_txq(struct ice_vsi *vsi, struct ice_tx_ring **tx_rings,
+			   u16 q_idx);
+int ice_vsi_cfg_lan_txqs(struct ice_vsi *vsi);
+int ice_vsi_cfg_xdp_txqs(struct ice_vsi *vsi);
 void ice_cfg_itr(struct ice_hw *hw, struct ice_q_vector *q_vector);
 void
 ice_cfg_txq_interrupt(struct ice_vsi *vsi, u16 txq, u16 msix_idx, u16 itr_idx);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 27b3423c9ff23..15bdf6ef3c099 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1774,79 +1774,6 @@ ice_write_qrxflxp_cntxt(struct ice_hw *hw, u16 pf_q, u32 rxdid, u32 prio,
 	wr32(hw, QRXFLXP_CNTXT(pf_q), regval);
 }
 
-int ice_vsi_cfg_single_txq(struct ice_vsi *vsi, struct ice_tx_ring **tx_rings, u16 q_idx)
-{
-	DEFINE_FLEX(struct ice_aqc_add_tx_qgrp, qg_buf, txqs, 1);
-
-	if (q_idx >= vsi->alloc_txq || !tx_rings || !tx_rings[q_idx])
-		return -EINVAL;
-
-	qg_buf->num_txqs = 1;
-
-	return ice_vsi_cfg_txq(vsi, tx_rings[q_idx], qg_buf);
-}
-
-/**
- * ice_vsi_cfg_txqs - Configure the VSI for Tx
- * @vsi: the VSI being configured
- * @rings: Tx ring array to be configured
- * @count: number of Tx ring array elements
- *
- * Return 0 on success and a negative value on error
- * Configure the Tx VSI for operation.
- */
-static int
-ice_vsi_cfg_txqs(struct ice_vsi *vsi, struct ice_tx_ring **rings, u16 count)
-{
-	DEFINE_FLEX(struct ice_aqc_add_tx_qgrp, qg_buf, txqs, 1);
-	int err = 0;
-	u16 q_idx;
-
-	qg_buf->num_txqs = 1;
-
-	for (q_idx = 0; q_idx < count; q_idx++) {
-		err = ice_vsi_cfg_txq(vsi, rings[q_idx], qg_buf);
-		if (err)
-			break;
-	}
-
-	return err;
-}
-
-/**
- * ice_vsi_cfg_lan_txqs - Configure the VSI for Tx
- * @vsi: the VSI being configured
- *
- * Return 0 on success and a negative value on error
- * Configure the Tx VSI for operation.
- */
-int ice_vsi_cfg_lan_txqs(struct ice_vsi *vsi)
-{
-	return ice_vsi_cfg_txqs(vsi, vsi->tx_rings, vsi->num_txq);
-}
-
-/**
- * ice_vsi_cfg_xdp_txqs - Configure Tx queues dedicated for XDP in given VSI
- * @vsi: the VSI being configured
- *
- * Return 0 on success and a negative value on error
- * Configure the Tx queues dedicated for XDP in given VSI for operation.
- */
-int ice_vsi_cfg_xdp_txqs(struct ice_vsi *vsi)
-{
-	int ret;
-	int i;
-
-	ret = ice_vsi_cfg_txqs(vsi, vsi->xdp_rings, vsi->num_xdp_txq);
-	if (ret)
-		return ret;
-
-	ice_for_each_rxq(vsi, i)
-		ice_tx_xsk_pool(vsi, i);
-
-	return 0;
-}
-
 /**
  * ice_intrl_usec_to_reg - convert interrupt rate limit to register value
  * @intrl: interrupt rate limit in usecs
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 95505a501a935..b5a1ed7cc4b17 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -54,10 +54,6 @@ bool ice_pf_state_is_nominal(struct ice_pf *pf);
 
 void ice_update_eth_stats(struct ice_vsi *vsi);
 
-int ice_vsi_cfg_single_txq(struct ice_vsi *vsi, struct ice_tx_ring **tx_rings, u16 q_idx);
-
-int ice_vsi_cfg_lan_txqs(struct ice_vsi *vsi);
-
 void ice_vsi_cfg_msix(struct ice_vsi *vsi);
 
 int ice_vsi_start_all_rx_rings(struct ice_vsi *vsi);
@@ -68,8 +64,6 @@ int
 ice_vsi_stop_lan_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 			  u16 rel_vmvf_num);
 
-int ice_vsi_cfg_xdp_txqs(struct ice_vsi *vsi);
-
 int ice_vsi_stop_xdp_tx_rings(struct ice_vsi *vsi);
 
 void ice_cfg_sw_lldp(struct ice_vsi *vsi, bool tx, bool create);
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 9e01f410af772..1857220d27fee 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -218,32 +218,17 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
  */
 static int ice_qp_ena(struct ice_vsi *vsi, u16 q_idx)
 {
-	DEFINE_FLEX(struct ice_aqc_add_tx_qgrp, qg_buf, txqs, 1);
-	u16 size = __struct_size(qg_buf);
 	struct ice_q_vector *q_vector;
-	struct ice_tx_ring *tx_ring;
-	struct ice_rx_ring *rx_ring;
 	int err;
 
-	if (q_idx >= vsi->num_rxq || q_idx >= vsi->num_txq)
-		return -EINVAL;
-
-	qg_buf->num_txqs = 1;
-
-	tx_ring = vsi->tx_rings[q_idx];
-	rx_ring = vsi->rx_rings[q_idx];
-	q_vector = rx_ring->q_vector;
-
-	err = ice_vsi_cfg_txq(vsi, tx_ring, qg_buf);
+	err = ice_vsi_cfg_single_txq(vsi, vsi->tx_rings, q_idx);
 	if (err)
 		return err;
 
 	if (ice_is_xdp_ena_vsi(vsi)) {
 		struct ice_tx_ring *xdp_ring = vsi->xdp_rings[q_idx];
 
-		memset(qg_buf, 0, size);
-		qg_buf->num_txqs = 1;
-		err = ice_vsi_cfg_txq(vsi, xdp_ring, qg_buf);
+		err = ice_vsi_cfg_single_txq(vsi, vsi->xdp_rings, q_idx);
 		if (err)
 			return err;
 		ice_set_ring_xdp(xdp_ring);
@@ -254,6 +239,7 @@ static int ice_qp_ena(struct ice_vsi *vsi, u16 q_idx)
 	if (err)
 		return err;
 
+	q_vector = vsi->rx_rings[q_idx]->q_vector;
 	ice_qvec_cfg_msix(vsi, q_vector);
 
 	err = ice_vsi_ctrl_one_rx_ring(vsi, true, q_idx, true);
-- 
2.43.0



