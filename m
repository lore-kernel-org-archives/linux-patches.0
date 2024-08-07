Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8199978C92;
	Wed,  7 Aug 2024 15:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043386; cv=none; b=Cz8apnRTXF+tLLlG+aO20Qoe3dl9gew+o6ze5evZpcWwu3M21lJhrVxbTMaWX6C8fUtGJCU2CgM0NFYsXCb8caOFdsj0l5qAJYJFRbErrFV24eBHRE99RCqLUvTVxVHdlVA07YqAwmoG+Tp64mNw98B4U7k6Sg0h23Uavg8rqMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043386; c=relaxed/simple;
	bh=P7yjuPWJk2Sy69Tb+5wGWun4CMBvwqx1S11B9L92+QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PF/pnW7nFCL2I/OKcQ6VnmXajmZtET6d4dWKSkGwxARDVFc482AnvpvQ6yRe4xM45Qa1lQBGAy3CJcOail0glNx+uT0AkLBFCmqh4h3H2v8LYe2Dg39nktzCgnjZ1YFm+NWRuitOElItbBRCFdbNnd1L+eJXRUauKBVQrG0/Jpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NyzZgOAV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NyzZgOAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF946C32781;
	Wed,  7 Aug 2024 15:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043386;
	bh=P7yjuPWJk2Sy69Tb+5wGWun4CMBvwqx1S11B9L92+QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NyzZgOAVHSgtyE5OtfkZkrSQDNI8H9odtKU6ly7EYlDfrdeaVv9i9inbm7OdBEX9G
	 kupRZ314N+cRpELhtmPLNWM4ZsDNz/m5MTMKqGBLNKLn2vTtD9SYkyvK91L4DVrX59
	 SOuaOmW/LfI3/3zmqVVIeBvcsarnHl1JKD2E50hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.6 071/121] ice: replace synchronize_rcu with synchronize_net
Date: Wed,  7 Aug 2024 17:00:03 +0200
Message-ID: <20240807150021.724958589@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 405d9999aa0b4ae467ef391d1d9c7e0d30ad0841 ]

Given that ice_qp_dis() is called under rtnl_lock, synchronize_net() can
be called instead of synchronize_rcu() so that XDP rings can finish its
job in a faster way. Also let us do this as earlier in XSK queue disable
flow.

Additionally, turn off regular Tx queue before disabling irqs and NAPI.

Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index a8d0cd3d831a0..67511153081ae 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -52,10 +52,8 @@ static void ice_qp_reset_stats(struct ice_vsi *vsi, u16 q_idx)
 static void ice_qp_clean_rings(struct ice_vsi *vsi, u16 q_idx)
 {
 	ice_clean_tx_ring(vsi->tx_rings[q_idx]);
-	if (ice_is_xdp_ena_vsi(vsi)) {
-		synchronize_rcu();
+	if (ice_is_xdp_ena_vsi(vsi))
 		ice_clean_tx_ring(vsi->xdp_rings[q_idx]);
-	}
 	ice_clean_rx_ring(vsi->rx_rings[q_idx]);
 }
 
@@ -180,11 +178,12 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
 		usleep_range(1000, 2000);
 	}
 
+	synchronize_net();
+	netif_tx_stop_queue(netdev_get_tx_queue(vsi->netdev, q_idx));
+
 	ice_qvec_dis_irq(vsi, rx_ring, q_vector);
 	ice_qvec_toggle_napi(vsi, q_vector, false);
 
-	netif_tx_stop_queue(netdev_get_tx_queue(vsi->netdev, q_idx));
-
 	ice_fill_txq_meta(vsi, tx_ring, &txq_meta);
 	err = ice_vsi_stop_tx_ring(vsi, ICE_NO_RESET, 0, tx_ring, &txq_meta);
 	if (err)
-- 
2.43.0



