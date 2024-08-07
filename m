Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359FF80043;
	Wed,  7 Aug 2024 15:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042973; cv=none; b=KG+hLTiOtCjYBuLoH9MbCuiRFw3SX82bljyTW6wsScHC9iqvptQOBMwPalx7iZ7lKdLtDUUSQS1JqMzhy2oYpcC1Y/Wdit0v1H8GeTMrOIY89Sw3bJQ6wvI1R5LyODy9f2ArEO0BQW9hAKxGvBtG844o3uKYNz4aFBseqnnjX4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042973; c=relaxed/simple;
	bh=NNLL6oVKBLpi2nkPRkZHemwM0iHSTlC0lf5Y5KREISI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDpDNN51n0pgIJwF9m03TEmdEk+gxSyqxzGLwBgzIFsfi/f592XHXAl8DV6KyC9fK+UQtSGWq+efoh49FwfHP1AfR1LC8k0f9mf7Pp1PrnQbwDypBIpNkSKmFPodBROuWOT/GzMMSC1I8Qu/UaqTv8QvRClR12CoW4SW8rl50/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UePT74ev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UePT74ev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648AAC32781;
	Wed,  7 Aug 2024 15:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042972;
	bh=NNLL6oVKBLpi2nkPRkZHemwM0iHSTlC0lf5Y5KREISI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UePT74evFlEWLIO/DKKzZ6HI69XEsI2cn91FHiPVdS7VG1OWXUwkURKya81uv1yoj
	 AW5VREiHHr2IhHID8KgM6+86RC/tawB3DLLW2ZSU/jblw9yT9/T9BPgazsExI7g7TZ
	 u34m0o69YssehAHFZSR3TyGUa5xuRRHq2alzfpiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.10 044/123] ice: modify error handling when setting XSK pool in ndo_bpf
Date: Wed,  7 Aug 2024 16:59:23 +0200
Message-ID: <20240807150022.262933475@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit d5922717994911e8f0eab736f3ba0d968c158823 ]

Don't bail out right when spotting an error within ice_qp_{dis,ena}()
but rather track error and go through whole flow of disabling and
enabling queue pair.

Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 30 +++++++++++++-----------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index ba50af9a59293..902096b000f5a 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -162,6 +162,7 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
 	struct ice_tx_ring *tx_ring;
 	struct ice_rx_ring *rx_ring;
 	int timeout = 50;
+	int fail = 0;
 	int err;
 
 	if (q_idx >= vsi->num_rxq || q_idx >= vsi->num_txq)
@@ -186,8 +187,8 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
 
 	ice_fill_txq_meta(vsi, tx_ring, &txq_meta);
 	err = ice_vsi_stop_tx_ring(vsi, ICE_NO_RESET, 0, tx_ring, &txq_meta);
-	if (err)
-		return err;
+	if (!fail)
+		fail = err;
 	if (ice_is_xdp_ena_vsi(vsi)) {
 		struct ice_tx_ring *xdp_ring = vsi->xdp_rings[q_idx];
 
@@ -195,15 +196,15 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
 		ice_fill_txq_meta(vsi, xdp_ring, &txq_meta);
 		err = ice_vsi_stop_tx_ring(vsi, ICE_NO_RESET, 0, xdp_ring,
 					   &txq_meta);
-		if (err)
-			return err;
+		if (!fail)
+			fail = err;
 	}
 
 	ice_vsi_ctrl_one_rx_ring(vsi, false, q_idx, false);
 	ice_qp_clean_rings(vsi, q_idx);
 	ice_qp_reset_stats(vsi, q_idx);
 
-	return 0;
+	return fail;
 }
 
 /**
@@ -216,32 +217,33 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
 static int ice_qp_ena(struct ice_vsi *vsi, u16 q_idx)
 {
 	struct ice_q_vector *q_vector;
+	int fail = 0;
 	int err;
 
 	err = ice_vsi_cfg_single_txq(vsi, vsi->tx_rings, q_idx);
-	if (err)
-		return err;
+	if (!fail)
+		fail = err;
 
 	if (ice_is_xdp_ena_vsi(vsi)) {
 		struct ice_tx_ring *xdp_ring = vsi->xdp_rings[q_idx];
 
 		err = ice_vsi_cfg_single_txq(vsi, vsi->xdp_rings, q_idx);
-		if (err)
-			return err;
+		if (!fail)
+			fail = err;
 		ice_set_ring_xdp(xdp_ring);
 		ice_tx_xsk_pool(vsi, q_idx);
 	}
 
 	err = ice_vsi_cfg_single_rxq(vsi, q_idx);
-	if (err)
-		return err;
+	if (!fail)
+		fail = err;
 
 	q_vector = vsi->rx_rings[q_idx]->q_vector;
 	ice_qvec_cfg_msix(vsi, q_vector);
 
 	err = ice_vsi_ctrl_one_rx_ring(vsi, true, q_idx, true);
-	if (err)
-		return err;
+	if (!fail)
+		fail = err;
 
 	ice_qvec_toggle_napi(vsi, q_vector, true);
 	ice_qvec_ena_irq(vsi, q_vector);
@@ -249,7 +251,7 @@ static int ice_qp_ena(struct ice_vsi *vsi, u16 q_idx)
 	netif_tx_start_queue(netdev_get_tx_queue(vsi->netdev, q_idx));
 	clear_bit(ICE_CFG_BUSY, vsi->state);
 
-	return 0;
+	return fail;
 }
 
 /**
-- 
2.43.0



