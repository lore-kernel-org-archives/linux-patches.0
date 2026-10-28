Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209680;
	b=WJi7Z4UJBULfz6WorDDr5iX7626xQF9795wJXHWWSEdaVCU1lXJVVF+FOUKHqlcYmiaw
	 ZmavP/wyOWB9s5evlJyTyAQ30TPRz80b3SDeUsDzT+akeDRoH5JFAkGWb/0JIMwlRSUB3
	 Xv9xo/D2vxLSb1Klcyn6hQElmtgF3US0rhkAN1vRxjjDbPaWHXV+kLng0LRF4SEiGZTUO
	 LWVusWo89BKcXNlKCwcTg86P0sBBnrp291xjZtQedhKRyf7eqRmO3/PqaNB90d/MpctCK
	 uCh2EMv0a4X0A3LCTg+NRlPMjxwVFv0MEGHMNbz5NLcsX2JDDz6sOnIlhTqb+3V+dDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dl+g1ctmNm/J1QWgZ0avd6aMN65GlnOD52dx+w+WHJ4=;
	b=TLuIDt+vtdBUEkbvHoWI2BP76FOeyz7gFNQUbPO+EVaPwxRL0rRToFPJfCT5HDvshonB
	 rhzuzV0xYqYBaLwSBEsc5dmyziRitzopciVdqfA2f68RorVBXBxwjguGxJjwnEVGn0xb+
	 CIiigthsVqv2eJLfxvNVJwBb9Pzt9qWtVg8fs2Ee7By9AXS/tBLmnAUsIlHjmeCk7d4yj
	 xgoH4eEoZLqlccgEccBu0AskD3OKVsv01ChTqtMcoUfe/9hVxTL67pCGd1F788DffvYU5
	 2xgMAIIYv43E66HdObjGno6LMLFZQ/QLFZlumjUw8UMjJzd0Vk4pt/ZSVKujhkFVbPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lxgwCj3Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EFA606A31D;
	Wed, 28 Oct 2026 17:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lxgwCj3Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E081F01825;
	Wed, 28 Oct 2026 17:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209679;
	bh=Dl+g1ctmNm/J1QWgZ0avd6aMN65GlnOD52dx+w+WHJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lxgwCj3ZnYKO8x7AVPG6uFNAR5pSzH1aQppWslDNwOe+onrWzmTL1J/jcQ35GL4qb
	 s5X2xoqv7Kx2uHtLQIFvwH9dflJxG86ueZi1VZuvvEuIUr3NLNWrjr0C1obGb5qgif
	 Q5A+/s/oTZbMxqyopc0CIqGpLaqrTvF7NABy+z7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/109] ice: change XDP RxQ frag_size from DMA write length to xdp.frame_sz
Date: Wed, 28 Oct 2026 17:59:48 +0100
Message-ID: <20261028165942.463368397@linuxfoundation.org>
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
 drivers/net/ethernet/intel/ice/ice_base.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index cefd0a18c4c04..2e31199546a82 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -599,7 +599,6 @@ static int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 	};
 	struct device *dev = ice_pf_to_dev(ring->vsi->back);
 	u32 num_bufs = ICE_DESC_UNUSED(ring);
-	u32 rx_buf_len;
 	int err;
 
 	if (ring->vsi->type == ICE_VSI_PF || ring->vsi->type == ICE_VSI_SF ||
@@ -610,12 +609,12 @@ static int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 			return err;
 
 		if (ring->xsk_pool) {
-			rx_buf_len =
-				xsk_pool_get_rx_frame_size(ring->xsk_pool);
+			u32 frag_size =
+				xsk_pool_get_rx_frag_step(ring->xsk_pool);
 			err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
 						 ring->q_index,
 						 ring->q_vector->napi.napi_id,
-						 rx_buf_len);
+						 frag_size);
 			if (err)
 				return err;
 			err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
@@ -640,7 +639,7 @@ static int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 			err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
 						 ring->q_index,
 						 ring->q_vector->napi.napi_id,
-						 ring->rx_buf_len);
+						 ring->truesize);
 			if (err)
 				goto err_destroy_fq;
 
-- 
2.53.0



