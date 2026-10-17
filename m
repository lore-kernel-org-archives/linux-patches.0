Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A4439934B;
	Sat, 17 Oct 2026 17:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258378; cv=none; b=UpJzd7P34IFDzhX0cWYjaVSe2yUQzLSK6j3y9yWFz7XfeZJ7BV7w9y5/aCDKaYTPSHD7JUkk3DEGMm3qjK76wRLuB09GoK18/CTgJe7TkSjfoS6hDLXgQs/j2HN3IEjlb/+lsHTzMWGy+eEZ0NornR/rKJ+Sfub9R7yOtsHv+8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258378; c=relaxed/simple;
	bh=nHB256lG+R6fx7fLspS9s5SmjNi+VG/kbr/bCHPd4xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCZMJ/96kLG3XsGx2sZ1J+AuWHqiZrF2EqThp5/ffv6nM2+459+KLIBx6HHk1A5CDvg5dZo1zWq/IGYvCOSA3EnBQcMuDB2L6eErpIg718sn6Q3x3woB5N8kS22X4Dmm99V2egPkzHIi1OfR+uB+vXxkE2neGkUwQzkoCSbOlYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crdVRxQA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crdVRxQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2441F000C4;
	Sat, 17 Oct 2026 17:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258377;
	bh=7ccN6R0Zlrd/c6ga/9CIW2ZBEh/NXr5vVnAH0JaAWrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=crdVRxQA0UwzebXtsVK49hWB1IrTvdhnFOJQhxP00axTuvOLJCMA8fKDuG0e7Qwz5
	 ApN8i/WoireNZ6LCgbFMn/e6m07eLr1D4gJAL6EYZius0SqIauLm1O6TaWYs35OhXU
	 sZBjoI7NJtLF2JO8GvkqnFc73Bky0pelO8erPLGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0864/1674] ice: change XDP RxQ frag_size from DMA write length to xdp.frame_sz
Date: Sat, 17 Oct 2026 17:52:16 +0200
Message-ID: <20261017160453.292681951@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit e142dc4ef0f451b7ef99d09aaa84e9389af629d7 ]

The only user of frag_size field in XDP RxQ info is
bpf_xdp_frags_increase_tail(). It clearly expects whole buff size instead
of DMA write size. Different assumptions in ice driver configuration lead
to negative tailroom.

This allows to trigger kernel panic, when using
XDP_ADJUST_TAIL_GROW_MULTI_BUFF xskxceiver test and changing packet size to
6912 and the requested offset to a huge value, e.g.
XSK_UMEM__MAX_FRAME_SIZE * 100.

Due to other quirks of the ZC configuration in ice, panic is not observed
in ZC mode, but tailroom growing still fails when it should not.

Use fill queue buffer truesize instead of DMA write size in XDP RxQ info.
Fix ZC mode too by using the new helper.

Fixes: 2fba7dc5157b ("ice: Add support for XDP multi-buffer on Rx side")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Link: https://patch.msgid.link/20260305111253.2317394-5-larysa.zaremba@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_base.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 9a0682b05c4ff..f3a2d564da183 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -557,13 +557,16 @@ int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 			err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
 						 ring->q_index,
 						 ring->q_vector->napi.napi_id,
-						 ring->rx_buf_len);
+						 ice_get_frame_sz(ring));
 			if (err)
 				return err;
 		}
 
 		ring->xsk_pool = ice_xsk_pool(ring);
 		if (ring->xsk_pool) {
+			u32 frag_size =
+				xsk_pool_get_rx_frag_step(ring->xsk_pool);
+
 			xdp_rxq_info_unreg(&ring->xdp_rxq);
 
 			ring->rx_buf_len =
@@ -571,7 +574,7 @@ int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 			err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
 						 ring->q_index,
 						 ring->q_vector->napi.napi_id,
-						 ring->rx_buf_len);
+						 frag_size);
 			if (err)
 				return err;
 			err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
@@ -588,7 +591,7 @@ int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 				err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
 							 ring->q_index,
 							 ring->q_vector->napi.napi_id,
-							 ring->rx_buf_len);
+							 ice_get_frame_sz(ring));
 				if (err)
 					return err;
 			}
-- 
2.53.0



