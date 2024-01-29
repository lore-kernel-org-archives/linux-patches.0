Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879CC15F309;
	Mon, 29 Jan 2024 17:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548583; cv=none; b=eIlwzb8dt1iWw1hl/jUKDO+gp3tYwMR2sWzwZd9scnmhoKyoOzf2se9tJMa4fNg7PHYV274DPKtar6O3IwDfoVoLEO/aFPEkHQnUg4BjpjAMkeXRzZpuEE0melsvdiSeEamwc4/zYkxOa5jr3c0eK9HI9vo7kRyZS6Naw+AGJnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548583; c=relaxed/simple;
	bh=zWfIxBqn1SDlravTzIhnpZhH9CxQGgVDjYgLM1JEQ2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYlmDRlgUfl7efire0KAD8Z0bq2CQ5Npw63yumjVHymt/PGRqBAtMzL4h8Lfk4FkB7Y8BHBqbdQxk0HT8ECpHg0etwUcp0xmKQPtZsmQyZOXiZQze7zEAkv3K/QUUEwh+xEY2b0exrswoTnlbURLqctebUnCuvXV0UipWj/JMOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ab4KezEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ab4KezEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F62C433C7;
	Mon, 29 Jan 2024 17:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548583;
	bh=zWfIxBqn1SDlravTzIhnpZhH9CxQGgVDjYgLM1JEQ2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ab4KezEdqlnjVQu2qQwwAys5MZ6JWOO6qh1r7Ed8dHcO+LGwrWQSZxtlGJB4i5so3
	 PYpBEvv4akbiYn/3DmWRMNuEDqLD9dDBPvGxPnhKgchURncR99hzU6fqtt6Xk/ir9v
	 yFc7Cc0EU5X67OxPQl/TUoI5mAIPzes/jO1R983c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 221/331] ice: update xdp_rxq_info::frag_size for ZC enabled Rx queue
Date: Mon, 29 Jan 2024 09:04:45 -0800
Message-ID: <20240129170021.340798129@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

[ Upstream commit 3de38c87174225487fc93befeea7d380db80aef6 ]

Now that ice driver correctly sets up frag_size in xdp_rxq_info, let us
make it work for ZC multi-buffer as well. ice_rx_ring::rx_buf_len for ZC
is being set via xsk_pool_get_rx_frame_size() and this needs to be
propagated up to xdp_rxq_info.

Use a bigger hammer and instead of unregistering only xdp_rxq_info's
memory model, unregister it altogether and register it again and have
xdp_rxq_info with correct frag_size value.

Fixes: 1bbc04de607b ("ice: xsk: add RX multi-buffer support")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/20240124191602.566724-9-maciej.fijalkowski@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_base.c | 37 ++++++++++++++---------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 7fa43827a3f0..4f3e65b47cdc 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -534,19 +534,27 @@ int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 	ring->rx_buf_len = ring->vsi->rx_buf_len;
 
 	if (ring->vsi->type == ICE_VSI_PF) {
-		if (!xdp_rxq_info_is_reg(&ring->xdp_rxq))
-			/* coverity[check_return] */
-			__xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
-					   ring->q_index,
-					   ring->q_vector->napi.napi_id,
-					   ring->vsi->rx_buf_len);
+		if (!xdp_rxq_info_is_reg(&ring->xdp_rxq)) {
+			err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
+						 ring->q_index,
+						 ring->q_vector->napi.napi_id,
+						 ring->rx_buf_len);
+			if (err)
+				return err;
+		}
 
 		ring->xsk_pool = ice_xsk_pool(ring);
 		if (ring->xsk_pool) {
-			xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
+			xdp_rxq_info_unreg(&ring->xdp_rxq);
 
 			ring->rx_buf_len =
 				xsk_pool_get_rx_frame_size(ring->xsk_pool);
+			err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
+						 ring->q_index,
+						 ring->q_vector->napi.napi_id,
+						 ring->rx_buf_len);
+			if (err)
+				return err;
 			err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
 							 MEM_TYPE_XSK_BUFF_POOL,
 							 NULL);
@@ -557,13 +565,14 @@ int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 			dev_info(dev, "Registered XDP mem model MEM_TYPE_XSK_BUFF_POOL on Rx ring %d\n",
 				 ring->q_index);
 		} else {
-			if (!xdp_rxq_info_is_reg(&ring->xdp_rxq))
-				/* coverity[check_return] */
-				__xdp_rxq_info_reg(&ring->xdp_rxq,
-						   ring->netdev,
-						   ring->q_index,
-						   ring->q_vector->napi.napi_id,
-						   ring->vsi->rx_buf_len);
+			if (!xdp_rxq_info_is_reg(&ring->xdp_rxq)) {
+				err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
+							 ring->q_index,
+							 ring->q_vector->napi.napi_id,
+							 ring->rx_buf_len);
+				if (err)
+					return err;
+			}
 
 			err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
 							 MEM_TYPE_PAGE_SHARED,
-- 
2.43.0



