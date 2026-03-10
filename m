Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BA3389DEC;
	Tue, 10 Mar 2026 11:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141295; cv=none; b=rLV9dvecrKXjeLF4INv8ZugGLKwXy3wnMfu/T9L0nFssDs2GcJEjHCdXtKN4yM9DXBkin8YpP/VdI3nvRDJsInBdGXGN7zxMlwfD1jBL86f0c9JeGCJfQBO39WxvcN6K5Htmyw0xraycJXBd8hnpRNOAvjRRjXLhVdeFrK/NKCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141295; c=relaxed/simple;
	bh=H2krcg+DlzsR6ZBq9qlChJnFMaTg5s0i3t+RrYo72bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXpa9/Y1BrWlVe+bT1Mlp8svPcDuDG8G8645WjYEtY1oog0/BEhoFKjrMxyJ4wibmMPGJzE2HM/CwF5LdQyKRzUoQAX56OQAckB3DOCmzjGfAsKDFy4S/Ec0ED/1rLidbhRjBo1/Eam9H7BcwKxCexdu/pZwNO4Pj9R10S/rPTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OUXT0W0Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OUXT0W0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEACC19423;
	Tue, 10 Mar 2026 11:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141295;
	bh=H2krcg+DlzsR6ZBq9qlChJnFMaTg5s0i3t+RrYo72bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OUXT0W0ZjM/QhpeG+azGyW27JQkDQ/muzYdX8AFqKErMkRhDDW521OrGZdLu0CkBW
	 Pd15ENfL90sskBeqbf/wCaRjmsq8WcrL8W1aSdVi/kgRNReeBs6m86B18Sj8m/G5tl
	 Hi0E/xaoV/U2LY3nzckgbg09j42Q39Gtb3oC6h5nXPIlOzM0exlUAdL8TYrdukrsGv
	 rAfjD/WuVARTBetWGxQQqX6jKcOLntR6WtXUbXCJ9vb1P+/QFBRc+aYlHHbNs61AmO
	 chYLcatzIOhaGEzWrJbgroGSEYH0z7K+Pum9g+QVmR0HTXE4rJQ1iqBu/YlBxeyFsc
	 ll98tanEhv6FA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Larysa Zaremba <larysa.zaremba@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 299/311] ice: fix rxq info registering in mbuf packets
Date: Tue, 10 Mar 2026 07:05:46 -0400
Message-ID: <7e4cd95afe32a1288f1e87f8d7bf82387fcb2f35.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit 02852b47c706772af795d3e28fca99fc9b923b2c ]

XDP RxQ info contains frag_size, which depends on the MTU. This makes the
old way of registering RxQ info before calculating new buffer sizes
invalid. Currently, it leads to frag_size being outdated, making it
sometimes impossible to grow tailroom in a mbuf packet. E.g. fragments are
actually 3K+, but frag size is still as if MTU was 1500.

Always register new XDP RxQ info after reconfiguring memory pools.

Fixes: 2fba7dc5157b ("ice: Add support for XDP multi-buffer on Rx side")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Link: https://patch.msgid.link/20260305111253.2317394-4-larysa.zaremba@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_base.c    | 26 ++++++--------------
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  1 +
 drivers/net/ethernet/intel/ice/ice_txrx.c    |  4 ++-
 drivers/net/ethernet/intel/ice/ice_xsk.c     |  3 +++
 4 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index f0da50df6791c..2c117ca7c76aa 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -666,23 +666,12 @@ static int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 
 	if (ring->vsi->type == ICE_VSI_PF || ring->vsi->type == ICE_VSI_SF ||
 	    ring->vsi->type == ICE_VSI_LB) {
-		if (!xdp_rxq_info_is_reg(&ring->xdp_rxq)) {
-			err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
-						 ring->q_index,
-						 ring->q_vector->napi.napi_id,
-						 ring->rx_buf_len);
-			if (err)
-				return err;
-		}
-
 		ice_rx_xsk_pool(ring);
 		err = ice_realloc_rx_xdp_bufs(ring, ring->xsk_pool);
 		if (err)
 			return err;
 
 		if (ring->xsk_pool) {
-			xdp_rxq_info_unreg(&ring->xdp_rxq);
-
 			rx_buf_len =
 				xsk_pool_get_rx_frame_size(ring->xsk_pool);
 			err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
@@ -705,14 +694,13 @@ static int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 			if (err)
 				return err;
 
-			if (!xdp_rxq_info_is_reg(&ring->xdp_rxq)) {
-				err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
-							 ring->q_index,
-							 ring->q_vector->napi.napi_id,
-							 ring->rx_buf_len);
-				if (err)
-					goto err_destroy_fq;
-			}
+			err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
+						 ring->q_index,
+						 ring->q_vector->napi.napi_id,
+						 ring->rx_buf_len);
+			if (err)
+				goto err_destroy_fq;
+
 			xdp_rxq_info_attach_page_pool(&ring->xdp_rxq,
 						      ring->pp);
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 5377550a2b6e1..1b343c53874e1 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3332,6 +3332,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
 		rx_rings[i].cached_phctime = pf->ptp.cached_phc_time;
 		rx_rings[i].desc = NULL;
 		rx_rings[i].xdp_buf = NULL;
+		rx_rings[i].xdp_rxq = (struct xdp_rxq_info){ };
 
 		/* this is to allow wr32 to have something to write to
 		 * during early allocation of Rx buffers
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index ad76768a42323..f47b96ceb9a47 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -560,7 +560,9 @@ void ice_clean_rx_ring(struct ice_rx_ring *rx_ring)
 			i = 0;
 	}
 
-	if (rx_ring->vsi->type == ICE_VSI_PF &&
+	if ((rx_ring->vsi->type == ICE_VSI_PF ||
+	     rx_ring->vsi->type == ICE_VSI_SF ||
+	     rx_ring->vsi->type == ICE_VSI_LB) &&
 	    xdp_rxq_info_is_reg(&rx_ring->xdp_rxq)) {
 		xdp_rxq_info_detach_mem_model(&rx_ring->xdp_rxq);
 		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 989ff1fd91103..102631398af3c 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -900,6 +900,9 @@ void ice_xsk_clean_rx_ring(struct ice_rx_ring *rx_ring)
 	u16 ntc = rx_ring->next_to_clean;
 	u16 ntu = rx_ring->next_to_use;
 
+	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
+		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
+
 	while (ntc != ntu) {
 		struct xdp_buff *xdp = *ice_xdp_buf(rx_ring, ntc);
 
-- 
2.51.0

