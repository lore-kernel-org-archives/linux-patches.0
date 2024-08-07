Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C59823AF;
	Wed,  7 Aug 2024 15:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043381; cv=none; b=uwbiFuNSPcXahunMZX2PBGuYhZ4191WJFxBCj4FeJXI8bR5l/NsO5SLtmWKh5s5fx9vHRZk65F4jhxRe+8qlkET0t+bRfiGf0GQj7yrhP08o0DkwszmIXYomGu/5NyNJKdwfB/byg2DFz43ipRvOjuQawaWDzGw7EzfH0czdNUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043381; c=relaxed/simple;
	bh=5eiBrpFLgWzl2iZQYbyl17ytfj9FWmFFm3LALaTf8CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAtCvseuH/wbOGkYGN2L9yTVMGB8JwCIqJc9zLFp6FWE+TklTYMgHQQ/QuKE3y0jpP9E1JxiMYrBDNe3QChNz9J+HDS9oBaCicGDzeZy+LW5wMVpA5kW6zAOgBbeb+3snADQ7i6Tni5XQK9tpovmXk1oABJcL6ziI8OAuvm9bQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qo3xLSVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qo3xLSVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720EFC32781;
	Wed,  7 Aug 2024 15:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043380;
	bh=5eiBrpFLgWzl2iZQYbyl17ytfj9FWmFFm3LALaTf8CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qo3xLSVfToEx9uihyo+yKzwe9szKUB71sH2RM3SozaZFsBxDKjOVaOFYg4K1PQoy4
	 DHWV+Y6YhWjDD+B4nK8GRyM2TKhpuwO4nPJk3yGk5Ul3kRVVDG0uDcsn+5OcDkTxAK
	 K6kO2husPW8VZSVuUsIYEVlZ5q3FfJtSGE95IE/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.6 069/121] ice: respect netif readiness in AF_XDP ZC related ndos
Date: Wed,  7 Aug 2024 17:00:01 +0200
Message-ID: <20240807150021.659059539@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

From: Michal Kubiak <michal.kubiak@intel.com>

[ Upstream commit ec145a18687fec8dd97eeb4f30057fa4debef577 ]

Address a scenario in which XSK ZC Tx produces descriptors to XDP Tx
ring when link is either not yet fully initialized or process of
stopping the netdev has already started. To avoid this, add checks
against carrier readiness in ice_xsk_wakeup() and in ice_xmit_zc().
One could argue that bailing out early in ice_xsk_wakeup() would be
sufficient but given the fact that we produce Tx descriptors on behalf
of NAPI that is triggered for Rx traffic, the latter is also needed.

Bringing link up is an asynchronous event executed within
ice_service_task so even though interface has been brought up there is
still a time frame where link is not yet ok.

Without this patch, when AF_XDP ZC Tx is used simultaneously with stack
Tx, Tx timeouts occur after going through link flap (admin brings
interface down then up again). HW seem to be unable to transmit
descriptor to the wire after HW tail register bump which in turn causes
bit __QUEUE_STATE_STACK_XOFF to be set forever as
netdev_tx_completed_queue() sees no cleaned bytes on the input.

Fixes: 126cdfe1007a ("ice: xsk: Improve AF_XDP ZC Tx and use batching API")
Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index f53566cb6bfbd..248cb02958acd 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -1068,6 +1068,10 @@ bool ice_xmit_zc(struct ice_tx_ring *xdp_ring)
 
 	ice_clean_xdp_irq_zc(xdp_ring);
 
+	if (!netif_carrier_ok(xdp_ring->vsi->netdev) ||
+	    !netif_running(xdp_ring->vsi->netdev))
+		return true;
+
 	budget = ICE_DESC_UNUSED(xdp_ring);
 	budget = min_t(u16, budget, ICE_RING_QUARTER(xdp_ring));
 
@@ -1111,7 +1115,7 @@ ice_xsk_wakeup(struct net_device *netdev, u32 queue_id,
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_tx_ring *ring;
 
-	if (test_bit(ICE_VSI_DOWN, vsi->state))
+	if (test_bit(ICE_VSI_DOWN, vsi->state) || !netif_carrier_ok(netdev))
 		return -ENETDOWN;
 
 	if (!ice_is_xdp_ena_vsi(vsi))
-- 
2.43.0



