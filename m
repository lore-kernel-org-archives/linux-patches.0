Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2699836D512;
	Tue, 10 Mar 2026 11:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141296; cv=none; b=SfR63b+5MGJonZXAGh/YHM2PSgwbbXVm9Ew4qugWWQqCX5IdKFlpjzox17f+x2fFTI+sTGrtv5ba7ngDYGWqd9e0AJ1qSQj7W46N5mW7GoqwhUUakW9KFtuY9PgkXUawaMC70nAmm8w0td5MW94hrubGFQ0XQJbq2qgAZ4AZaL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141296; c=relaxed/simple;
	bh=1yAQdrr08ss37xuhgPjpg6kpMOftATwfhgoNZOA0Wr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sojkwUnKyqgz0Imndu8jQmSMwN8p5l8AGI034Gahew6OxQlz5soUS6a7dWyAsy3h1BspLlcC5+gx6mClTZlVI1wsGt/q6Z8VaOPHrY8rfWBgkQO8gQXG0Acu5fVvG4GZz+c1eZx65mX+kloB4VhQ5hTxX3gbVFiCsTvkU/GxK9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iUcnEgGl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iUcnEgGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD4DC2BCAF;
	Tue, 10 Mar 2026 11:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141296;
	bh=1yAQdrr08ss37xuhgPjpg6kpMOftATwfhgoNZOA0Wr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUcnEgGlljExUKuGaZyrm9N1Ch6nhS8VAjGPJwGVP8uj4Q0UzUXW6b94JYgYCWvDu
	 VVuZ1NRtG3XKKkrbytmApLs3tBSyTgTnRaE3XmwQlt+A+XGItbCCqmlwZNH8JPZPd7
	 fCqcxx4OynEAQbTBP7wbbc+wxFpnqAqZlZ8reSk0cBp6LGkOsLO9KTYPthpOchewVn
	 yBuuvg+/affdHq8weTutHslRU4BppNh6kmmaWVLSmSgpGbz6xbX+FoHGLOD/zQIQ6s
	 IVjTI9GY7IZGa4IK95BFWjosqBvSciprBTeDdgpjHMWSB9WxNUcnokR8hTt+rCU00g
	 CjgTfu6aQMxpw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Larysa Zaremba <larysa.zaremba@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 300/311] ice: change XDP RxQ frag_size from DMA write length to xdp.frame_sz
Date: Tue, 10 Mar 2026 07:05:47 -0400
Message-ID: <822cb25e72b2db3600478db07c7a62303bd43bf1.1773140655.git.sashal@kernel.org>
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
index 2c117ca7c76aa..5a6da2d501213 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -661,7 +661,6 @@ static int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 {
 	struct device *dev = ice_pf_to_dev(ring->vsi->back);
 	u32 num_bufs = ICE_DESC_UNUSED(ring);
-	u32 rx_buf_len;
 	int err;
 
 	if (ring->vsi->type == ICE_VSI_PF || ring->vsi->type == ICE_VSI_SF ||
@@ -672,12 +671,12 @@ static int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
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
@@ -697,7 +696,7 @@ static int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 			err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
 						 ring->q_index,
 						 ring->q_vector->napi.napi_id,
-						 ring->rx_buf_len);
+						 ring->truesize);
 			if (err)
 				goto err_destroy_fq;
 
-- 
2.51.0

