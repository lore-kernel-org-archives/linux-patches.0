Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A40157E8F;
	Mon, 29 Jan 2024 17:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548168; cv=none; b=Gns+wBYELQjMfbl0ARBytwIGcp7B3Sxo+3g8V8u/wPB4qBFyLF/xFEnB1T7fgCt/4oCZhQkH5RqbxYHbXyjBavVxuH6TRHU4hDNrx9fLk1FLv8Se+6/dRcpIFs2eUDWljW+jkCW64n74dADf73qh+uZmufHcVpATqBZA6LNrIZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548168; c=relaxed/simple;
	bh=MOTUE2/tGi4Toc2D4+BXeyBU25OSnn0NYCIZaNgj610=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1dGcbzUqIvkhGLFNMKzm1dWchSlv/eM/u8rfzRi8d/Xtz2XiMK8czRu25tkwYNSYByDne3T5otBCMHlfdHuStq3JSR/rPXMXPo29Hux0hiKXUNZdsm6o+HVySu6LQgja7VSUWOllNsq7fh0DDe2H1M83fXe31BJ5+J21IH870U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aYWWEqrU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aYWWEqrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4861C43399;
	Mon, 29 Jan 2024 17:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548167;
	bh=MOTUE2/tGi4Toc2D4+BXeyBU25OSnn0NYCIZaNgj610=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aYWWEqrUtjyKVtoHyUls/xJqhHR3wAKytH+GqtO9R1oN2tmbCl2zdaT4+h1be+jvn
	 XhDnVwihag+GmKtDKI25dfi5lhsU9cgAhYw6ljn3J3WHoRUc3t6Tl99cRQN0AYfSO4
	 2HVZfizodScROA6BayNwtiFwagTQq+3rTjaRJxDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 211/346] ice: remove redundant xdp_rxq_info registration
Date: Mon, 29 Jan 2024 09:04:02 -0800
Message-ID: <20240129170022.588380748@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 2ee788c06493d02ee85855414cca39825e768aaf ]

xdp_rxq_info struct can be registered by drivers via two functions -
xdp_rxq_info_reg() and __xdp_rxq_info_reg(). The latter one allows
drivers that support XDP multi-buffer to set up xdp_rxq_info::frag_size
which in turn will make it possible to grow the packet via
bpf_xdp_adjust_tail() BPF helper.

Currently, ice registers xdp_rxq_info in two spots:
1) ice_setup_rx_ring() // via xdp_rxq_info_reg(), BUG
2) ice_vsi_cfg_rxq()   // via __xdp_rxq_info_reg(), OK

Cited commit under fixes tag took care of setting up frag_size and
updated registration scheme in 2) but it did not help as
1) is called before 2) and as shown above it uses old registration
function. This means that 2) sees that xdp_rxq_info is already
registered and never calls __xdp_rxq_info_reg() which leaves us with
xdp_rxq_info::frag_size being set to 0.

To fix this misbehavior, simply remove xdp_rxq_info_reg() call from
ice_setup_rx_ring().

Fixes: 2fba7dc5157b ("ice: Add support for XDP multi-buffer on Rx side")
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/20240124191602.566724-7-maciej.fijalkowski@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 6878448ba112..9170a3e8f088 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -513,11 +513,6 @@ int ice_setup_rx_ring(struct ice_rx_ring *rx_ring)
 	if (ice_is_xdp_ena_vsi(rx_ring->vsi))
 		WRITE_ONCE(rx_ring->xdp_prog, rx_ring->vsi->xdp_prog);
 
-	if (rx_ring->vsi->type == ICE_VSI_PF &&
-	    !xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
-		if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
-				     rx_ring->q_index, rx_ring->q_vector->napi.napi_id))
-			goto err;
 	return 0;
 
 err:
-- 
2.43.0



