Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E386B1C861D;
	Sat, 17 Oct 2026 16:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253644; cv=none; b=I643uvdvVEPZixGZMr8hl5Nn4tENhVGA3uprksWBdbslKqaYn7EKa08XJVVE+hXnrTQivRMq9Kh1QhpGUbC/UPPoLPhugFJM9BapIJPs3hO7rSZPFLDfaNXeH+pw1dJw8VM2lwJIqxQQ2d43+X6FT4fWmYw0vs8KvuLC4G0ZQUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253644; c=relaxed/simple;
	bh=2CSO7Xv/3bcZKYpHSJARsiR0L2lzWznCL7VBi1rVP9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKEPCC9U19P4mI6k26Rm41TlDojCwU3DHHdEjdCIDytiDbkGjqkvxSSPw2surWqfWs33+o6mq497CGU+IVLDo4GB9lI7fF+hb/tk9lBoCKPEKcLhY08AxlopNLGJGkUCG7BW4TKM08m1U4FMbuy5sOK4Z7sXu3GE3pzk1vjtCgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUVQEYET; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUVQEYET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB3A1F000C5;
	Sat, 17 Oct 2026 16:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253643;
	bh=87sV0EdvhCBwLJ5M6A0nelJILOR+b44OSd/KExpyNWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oUVQEYET7YK3N2/pNV7Tm5GSpuuummEFTiR1Nle4iVLWPLS2VDetxGgiTzC9vqbk0
	 Xf2SYwBNW7kxMFKyT89NuwcfDCxJKkU4ZC6ZvHdUVPRkNLxRx5/dScdR+eXhIWYV4B
	 tB5jpZbyY0Ste0RIGHTpQ75mqqLpr2s521cU+DQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 185/869] ice: change XDP RxQ frag_size from DMA write length to xdp.frame_sz
Date: Sat, 17 Oct 2026 17:50:26 +0200
Message-ID: <20261017160041.800730876@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 98c3764fed396..8d7a2f44469b4 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -546,13 +546,16 @@ static int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 			err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
 						 ring->q_index,
 						 ring->q_vector->napi.napi_id,
-						 ring->rx_buf_len);
+						 ice_get_frame_sz(ring));
 			if (err)
 				return err;
 		}
 
 		ice_rx_xsk_pool(ring);
 		if (ring->xsk_pool) {
+			u32 frag_size =
+				xsk_pool_get_rx_frag_step(ring->xsk_pool);
+
 			xdp_rxq_info_unreg(&ring->xdp_rxq);
 
 			ring->rx_buf_len =
@@ -560,7 +563,7 @@ static int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 			err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
 						 ring->q_index,
 						 ring->q_vector->napi.napi_id,
-						 ring->rx_buf_len);
+						 frag_size);
 			if (err)
 				return err;
 			err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
@@ -578,7 +581,7 @@ static int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
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



