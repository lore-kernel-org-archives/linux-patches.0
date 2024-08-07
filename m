Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EF823CE;
	Wed,  7 Aug 2024 15:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042975; cv=none; b=cvBbS46J2GsDYLk5hF9voZKJGbbB3XPQMooDjoCL6/eVeSBJVou48aeZSDXjPPEiMN3T0eOawt/8ufLfModAOP/DYXx1SayDVVJhCXtdO8WDssEqd45IQ+7ZJIxLGVj9ULUcFwU/TgCTpyikMArv9ZsrdWmInhR2JbKun/pCsbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042975; c=relaxed/simple;
	bh=Uv4/G5SZL0mSV6em7sARF3JcQlvaeIWKEmSO/dkK6LM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEA1wINrhNoPabc4YBb4Ute6Fn1bsXkibS4w9vB3K/lKLkyLkvhXtIuWYcgK7ekbIl7Rv7NQdrwEnCYEKrtG/zhbQbGILiMGi7ZCzmIDFI/wsFjLuMYPdEeVXGjAF5SrvsikiiOPfiF6CmTIaaY0xYfYvIBx1fDTiWaiWL4oj4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTVPYq9B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTVPYq9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1248AC32781;
	Wed,  7 Aug 2024 15:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042975;
	bh=Uv4/G5SZL0mSV6em7sARF3JcQlvaeIWKEmSO/dkK6LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTVPYq9BWr12fWP9mv809GK01IsEgEL+alYW72RRP4Gyjjwgh2982DmMuQkufLswJ
	 GGSVf4t/5vwXeP9jKz5ZuEJgifo7fObeGB2HAXmXDS9ZTLsnFlrruofBeZmStXsxYP
	 VC49odfueEKCLY5kdXDh9lFn3j23Ucl5m2HXumTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.10 045/123] ice: toggle netif_carrier when setting up XSK pool
Date: Wed,  7 Aug 2024 16:59:24 +0200
Message-ID: <20240807150022.296518296@linuxfoundation.org>
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

[ Upstream commit 9da75a511c5558fa3da56759984fd1fa859186f0 ]

This so we prevent Tx timeout issues. One of conditions checked on
running in the background dev_watchdog() is netif_carrier_ok(), so let
us turn it off when we disable the queues that belong to a q_vector
where XSK pool is being configured. Turn carrier on in ice_qp_ena()
only when ice_get_link_status() tells us that physical link is up.

Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 902096b000f5a..3fbe4cfadfbfa 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -180,6 +180,7 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
 	}
 
 	synchronize_net();
+	netif_carrier_off(vsi->netdev);
 	netif_tx_stop_queue(netdev_get_tx_queue(vsi->netdev, q_idx));
 
 	ice_qvec_dis_irq(vsi, rx_ring, q_vector);
@@ -218,6 +219,7 @@ static int ice_qp_ena(struct ice_vsi *vsi, u16 q_idx)
 {
 	struct ice_q_vector *q_vector;
 	int fail = 0;
+	bool link_up;
 	int err;
 
 	err = ice_vsi_cfg_single_txq(vsi, vsi->tx_rings, q_idx);
@@ -248,7 +250,11 @@ static int ice_qp_ena(struct ice_vsi *vsi, u16 q_idx)
 	ice_qvec_toggle_napi(vsi, q_vector, true);
 	ice_qvec_ena_irq(vsi, q_vector);
 
-	netif_tx_start_queue(netdev_get_tx_queue(vsi->netdev, q_idx));
+	ice_get_link_status(vsi->port_info, &link_up);
+	if (link_up) {
+		netif_tx_start_queue(netdev_get_tx_queue(vsi->netdev, q_idx));
+		netif_carrier_on(vsi->netdev);
+	}
 	clear_bit(ICE_CFG_BUSY, vsi->state);
 
 	return fail;
-- 
2.43.0



