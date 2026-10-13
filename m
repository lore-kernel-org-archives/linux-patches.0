Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A1B4BD373;
	Tue, 13 Oct 2026 12:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893370; cv=none; b=YqsMoJYt6Jw59OlwjnUyXYYyVO+l73LftI3Dc3RnYgpO6cIEUFmOTr7F7UrZoUeXZnV5MsM/6CvmsqFedtbRrS5QlNcGpAbTZjVI0gxEwoblRUvmthPoXbMc+eFOKjKlNx6zv3itSOkYLItkJMih+i5P2HTlR/5/SBDPPbzBewY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893370; c=relaxed/simple;
	bh=oy3I5U6u0TribxmpVqtTNqH5I6wVQdA0HpPJma/Mhf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXgN/E1Ac3NabhfqxTEOydVzsI2V3mn/oFaVMK8zHLDFThCT+nVt7m65d5y/XyEIb3hR54GRiXOAXk5xeu6p9wMDc1MiBcmZPxqqEQMaJbbPO11Qj7HfPTtqylfNLCQJXB0nWhh5RI3YDNKCcPWv8BDSGxSBsPwl2HlHBOkIJrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2XrFAkS4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2XrFAkS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B9E1F000FF;
	Tue, 13 Oct 2026 12:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893369;
	bh=g8d6S9NU29ZPheBr0qwNWxZSTbsOF5t+tqvE9t3oQhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2XrFAkS44+C52bTQ49PCLr9X8nCk7txD3JCUgRVRftlgN9pa3Be6zl6iBSneGqJlf
	 GLA4L4ixZhbHhGrnsscUvPgqGDxEN86qUkeKC5ug7bKWhRgb/aI+NYkJQZi6m129Vr
	 3G03dK1vIvWPB01nE7FJ23c5PepKQmsYXAXDmgk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 160/621] ice: fix rxq info registering in mbuf packets
Date: Tue, 13 Oct 2026 13:32:35 +0200
Message-ID: <20261013112924.656243869@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
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
Stable-dep-of: e142dc4ef0f4 ("ice: change XDP RxQ frag_size from DMA write length to xdp.frame_sz")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_base.c    | 25 +++++---------------
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  1 +
 drivers/net/ethernet/intel/ice/ice_txrx.c    |  8 +++++++
 drivers/net/ethernet/intel/ice/ice_xsk.c     |  3 +++
 4 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index f0aa26144deb5..9436bdff607e5 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -631,19 +631,8 @@ static int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 
 	if (ring->vsi->type == ICE_VSI_PF || ring->vsi->type == ICE_VSI_SF ||
 	    ring->vsi->type == ICE_VSI_LB) {
-		if (!xdp_rxq_info_is_reg(&ring->xdp_rxq)) {
-			err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
-						 ring->q_index,
-						 ring->q_vector->napi.napi_id,
-						 ICE_RXBUF_3072);
-			if (err)
-				return err;
-		}
-
 		ice_rx_xsk_pool(ring);
 		if (ring->xsk_pool) {
-			xdp_rxq_info_unreg(&ring->xdp_rxq);
-
 			rx_buf_len =
 				xsk_pool_get_rx_frame_size(ring->xsk_pool);
 			err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
@@ -663,14 +652,12 @@ static int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 			dev_info(dev, "Registered XDP mem model MEM_TYPE_XSK_BUFF_POOL on Rx ring %d\n",
 				 ring->q_index);
 		} else {
-			if (!xdp_rxq_info_is_reg(&ring->xdp_rxq)) {
-				err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
-							 ring->q_index,
-							 ring->q_vector->napi.napi_id,
-							 ICE_RXBUF_3072);
-				if (err)
-					return err;
-			}
+			err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
+						 ring->q_index,
+						 ring->q_vector->napi.napi_id,
+						 ICE_RXBUF_3072);
+			if (err)
+				return err;
 
 			err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
 							 MEM_TYPE_PAGE_SHARED,
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index b2429f85f2e0d..15efe2f63bdc9 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3308,6 +3308,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
 		rx_rings[i].cached_phctime = pf->ptp.cached_phc_time;
 		rx_rings[i].desc = NULL;
 		rx_rings[i].rx_buf = NULL;
+		rx_rings[i].xdp_rxq = (struct xdp_rxq_info){ };
 		/* this is to allow wr32 to have something to write to
 		 * during early allocation of Rx buffers
 		 */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index e81be0f04b36a..9830d5dfb98bf 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -555,6 +555,14 @@ void ice_clean_rx_ring(struct ice_rx_ring *rx_ring)
 		rx_buf->page_offset = 0;
 	}
 
+	if ((rx_ring->vsi->type == ICE_VSI_PF ||
+	     rx_ring->vsi->type == ICE_VSI_SF ||
+	     rx_ring->vsi->type == ICE_VSI_LB) &&
+	    xdp_rxq_info_is_reg(&rx_ring->xdp_rxq)) {
+		xdp_rxq_info_detach_mem_model(&rx_ring->xdp_rxq);
+		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
+	}
+
 rx_skip_free:
 	if (rx_ring->xsk_pool)
 		memset(rx_ring->xdp_buf, 0, array_size(rx_ring->count, sizeof(*rx_ring->xdp_buf)));
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index b25bc5ba40abf..4a7f999f4355d 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -936,6 +936,9 @@ void ice_xsk_clean_rx_ring(struct ice_rx_ring *rx_ring)
 	u16 ntc = rx_ring->next_to_clean;
 	u16 ntu = rx_ring->next_to_use;
 
+	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
+		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
+
 	while (ntc != ntu) {
 		struct xdp_buff *xdp = *ice_xdp_buf(rx_ring, ntc);
 
-- 
2.53.0



