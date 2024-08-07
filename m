Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392237F7F5;
	Wed,  7 Aug 2024 15:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043682; cv=none; b=Lqn1NZha6DGJwaydsK927LWOG5NEicWJDgKFIbrMX1OEQMDSSsyz3ClDKkhmNk8pNMyNp0ZAVCTMmA0nv0tfm2t0gwkMITd2cL3TCJuOB+Y0FCu3DlmkUjtbnuz0fNZNmI5lqWtX0fIU8fUCsZoXJ+UOyocuHWtkUqcnwTUuV7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043682; c=relaxed/simple;
	bh=3A37AaYHZuFodeGTBbSdZPbqBeVAkTqMB28B4lPYsOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vc4kX6tC+OErgicbTHJ2Iobv3w8Y20rf6oJUVOwhad7uBO5vgxepV2TPNIbh1zh0qLz8PQqQ3j+1YYFLqivoi1ajyCTP9LrIJojwAG42HV5JM5EG2hO5QJ2UvW8is6a8stJdkdeEK0pKwJg2Frxae9LtcZzhEmrETzDd8e9nQL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0zghC3Al; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0zghC3Al"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF580C32781;
	Wed,  7 Aug 2024 15:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043682;
	bh=3A37AaYHZuFodeGTBbSdZPbqBeVAkTqMB28B4lPYsOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0zghC3AlnBdLedUZRC3mduG12af9Yqr+sXpNjKVjiCcuUssyTVpOV5y2zlDxVr9Ou
	 TjpmeNt3fRdqzFVh7r/tBAncH4SoJmFUnOv/vUed7U5u0vFTN3uGWIz16rSV7Kg5fU
	 1AlavZjv+KRqO32gguFo2dqywl7iruGFK7FNotUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.1 53/86] ice: add missing WRITE_ONCE when clearing ice_rx_ring::xdp_prog
Date: Wed,  7 Aug 2024 17:00:32 +0200
Message-ID: <20240807150040.992892355@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 6044ca26210ba72b3dcc649fae1cbedd9e6ab018 ]

It is read by data path and modified from process context on remote cpu
so it is needed to use WRITE_ONCE to clear the pointer.

Fixes: efc2214b6047 ("ice: Add support for XDP")
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index dbe80e5053a82..bd62781191b3d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -454,7 +454,7 @@ void ice_free_rx_ring(struct ice_rx_ring *rx_ring)
 	if (rx_ring->vsi->type == ICE_VSI_PF)
 		if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
 			xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
-	rx_ring->xdp_prog = NULL;
+	WRITE_ONCE(rx_ring->xdp_prog, NULL);
 	if (rx_ring->xsk_pool) {
 		kfree(rx_ring->xdp_buf);
 		rx_ring->xdp_buf = NULL;
-- 
2.43.0



