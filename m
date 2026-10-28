Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209654;
	b=Dif//pZJl1l1E8SZv8NvNw4fYn1dkoljFqL2b4IXeijkMyyGC33ZBLdUYCOW4h2XQqbf
	 zsthGTsaxYNnHvYBdTuGUR+iQ9oKv1AJJQgk2OBAEWrsrkW8K9r4W8LABWwnwe9JZYppg
	 amX3SuTJLOWEieku3RAPCO1rewENakojPviSyn0/LhiTIeSRUKQ5QexAs/bru+GQwyEPA
	 xGxpvgwP9SmZjNTIPgKU6hWg2zEjBOYHei5cVN6eY6do6vlae2DKR/2GZrHuoK3wQfUTm
	 DnByDum4dJM+O7GC+H23JyH53YWxHAen7X+xLKMp+iiR5hxtXNx4rVYKL7zbL28vh6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xQRsfhb5QOhCZDR5AK8oaRacPiUzboakpMyPdq6sTys=;
	b=y5GLWcJLVogzTY1jw67JwY43SL5EhwTW15Fg6Sj7dJi02rgRsU3i20tFq/jGQOciQEC2
	 UvZBUDhPcwFKdi6gzw8Wrt0oNDRkeqA5uisSCkUWEoBjzXxV22a5mRhk12o8dLpPCuE5J
	 MEUHB7wI0mUK6MZ6VDmGCLX7ld8J0e6wgBY8DHwQXwGzfRCh/VCmWGCEBvZtGwhm+QTGF
	 I7PsW6zMyOi6zwRghjZGgGrCu6LY+1C68O0Yjo8l7+tsxCgGORyxieRrcYhQ9bozmRQm3
	 ZsgW7pbyXUJ1vD91LUpZOhd8ZUk4knf7RRsIX2YYlSUhYw2bQwo87xK9GgK3RwO8OQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CM46x7gi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E41606A31A;
	Wed, 28 Oct 2026 17:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CM46x7gi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16611F01828;
	Wed, 28 Oct 2026 17:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209654;
	bh=xQRsfhb5QOhCZDR5AK8oaRacPiUzboakpMyPdq6sTys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CM46x7gijWbQ78Q1VunDJWpaq8RupxxxJBAewzO9Oe8Va1myOiAFfurWoVKcVtTFb
	 x1e9rRl/dN6dSnZx0DM4meCiwl2N3sr3vRStgcQ8hWY3PkZNfy2xvcgVgyyvej38ug
	 wwvdsLcyiu9qLwUcQOzUB0zTeIbcNTCLw6mc2VBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 003/109] ice: fix rxq info registering in mbuf packets
Date: Wed, 28 Oct 2026 17:59:47 +0100
Message-ID: <20261028165942.439776619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 2d3d23450783c..cefd0a18c4c04 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -604,23 +604,12 @@ static int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 
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
@@ -648,14 +637,13 @@ static int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 			ring->truesize = fq.truesize;
 			ring->rx_buf_len = fq.buf_len;
 
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
index 428118475e2ff..53284959eda01 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3313,6 +3313,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
 		rx_rings[i].cached_phctime = pf->ptp.cached_phc_time;
 		rx_rings[i].desc = NULL;
 		rx_rings[i].xdp_buf = NULL;
+		rx_rings[i].xdp_rxq = (struct xdp_rxq_info){ };
 
 		/* this is to allow wr32 to have something to write to
 		 * during early allocation of Rx buffers
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index cc3c07847c35c..9752d61a0a5f1 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -542,7 +542,9 @@ void ice_clean_rx_ring(struct ice_rx_ring *rx_ring)
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
2.53.0



