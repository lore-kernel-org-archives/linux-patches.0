Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B328985283;
	Wed,  7 Aug 2024 15:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043758; cv=none; b=llswOGNV7JSuWWC/uwUnInz4+TLu24Eu87wVW7XMlKI3evTWayPWuUABXpybUdvgST4R4RHXM1wjvjmWfUk9mZ5dzKqGnpE18aEpUIMJqqqnld8+fD6V+1JDp4CuoV7BnYCreOxK8B2WrTBHsZ2Cx9sHh1F9rRmRZZ/TyjPk2Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043758; c=relaxed/simple;
	bh=zko05CN84FvoSBhab4CiMAvMy4PmqUdRG12x6GzZ+SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dugZUPaWnexO1t0yFZSrtJc8OI22mFY7MwA4E5zC2A4A92MsmhesQeEeY9UTs+VWy8JpGBxIaBqpFblqvl/gV1Vi+1u17u+/nFpVEE3/Fmq7ljoz/CIBUMxgP1HO0U4I7gyChVSmjKdCksKS7p7DIZrBFq15l7VelaVJqvETsbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Npn3sw4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Npn3sw4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B4AC4AF0B;
	Wed,  7 Aug 2024 15:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043758;
	bh=zko05CN84FvoSBhab4CiMAvMy4PmqUdRG12x6GzZ+SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Npn3sw4z5aJehPEc3wPhj6hqyySnoo8iik822SuRq6446NF369KxeGRe2A6mG1l02
	 h61OyMoTWrBgC26UbzXiAASNR0fpZAloyV7wH4AjHecCKAGjBBXppqySnOSKUH1Rv2
	 8SaHqBvRPbhi0gPNzmP0kjUIPYWhDmzgdzMgpnCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.1 52/86] ice: replace synchronize_rcu with synchronize_net
Date: Wed,  7 Aug 2024 17:00:31 +0200
Message-ID: <20240807150040.963488574@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ebc017dd245f1..2677d7c86a6d7 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -41,10 +41,8 @@ static void ice_qp_reset_stats(struct ice_vsi *vsi, u16 q_idx)
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
 
@@ -172,11 +170,12 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
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



