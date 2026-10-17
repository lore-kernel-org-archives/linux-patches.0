Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197FD38F253;
	Sat, 17 Oct 2026 15:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252609; cv=none; b=DG9u9rsZykprYVU6BIRkRwx3kDFCe9EO1sLXZTfYbRbZKsus5PBDkUct6mI/zLoBXqtGLuzjMKzGIPk2VgCUHYxeY07z0uP91plaOPoE/fXDxzH5U6sWhG4UEaFLr1u+DUQPegIAr7CHgpPh3JEi30S7Kyfm9hle7lTZECDLfzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252609; c=relaxed/simple;
	bh=U2Jm6dRriw4MwdLc1EoFEo1Bkdue+lgFwgydZzRJ7D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fW1rwEXyvk08SV4T009MXK8jzcaIAjd5KOzHTHYxsRopn4NMwHQEX88K7WoYvj2UpDKPX7Z7i5aM+sPTWyr9+MnBMcIpR/14r7CoLxcZwE46BnG3TzS2Rpe+p/r/OewmbP5JEbUn9Lv0RewTllYR4FdO5zH5NaYkX5UDGDj/jCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CuUJbK6f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CuUJbK6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2F11F000C4;
	Sat, 17 Oct 2026 15:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252608;
	bh=44TMS79gV0cqSbtjB6SCqZIjLTC9jcBnHYadj1FpBh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CuUJbK6fmsqYnMtJ82Ijvlu/HpXCd92CTY9sq0+TK3SN28ioDEBHRRe4dr8yrO1Em
	 1V+PUPGw6AA6KSVFXzSZ3dRDoWuiFHIHWK3x7pyLPFFJaIjAgJUSwE/DY10ASSfz6T
	 zbusRWopSsncBNRynUdGKskiP92nmvlvWTaXMpYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 37/52] ice: change XDP RxQ frag_size from DMA write length to xdp.frame_sz
Date: Sat, 17 Oct 2026 17:54:38 +0200
Message-ID: <20261017155106.041118200@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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
index 9436bdff607e5..0adcc3e1dbfb4 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -626,19 +626,18 @@ static int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 {
 	struct device *dev = ice_pf_to_dev(ring->vsi->back);
 	u32 num_bufs = ICE_RX_DESC_UNUSED(ring);
-	u32 rx_buf_len;
 	int err;
 
 	if (ring->vsi->type == ICE_VSI_PF || ring->vsi->type == ICE_VSI_SF ||
 	    ring->vsi->type == ICE_VSI_LB) {
 		ice_rx_xsk_pool(ring);
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
@@ -655,7 +654,7 @@ static int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 			err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
 						 ring->q_index,
 						 ring->q_vector->napi.napi_id,
-						 ICE_RXBUF_3072);
+						 ice_get_frame_sz(ring));
 			if (err)
 				return err;
 
-- 
2.53.0



