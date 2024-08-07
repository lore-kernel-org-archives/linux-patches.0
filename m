Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7F582C8E;
	Wed,  7 Aug 2024 15:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043658; cv=none; b=JiWvp5EE2S6AoJw0A4s2iDR7FDJ0LBgIOrynH1dz2+aVsChHrtKqFDLA6emmIgvgwwHu8Zc5kVeSeDHmfbPqls83jLyHGcnIKFNzymZ7eehLYcDw+TXGfD1copq3bspijsdIdhALr3F0iS+NCZB6hpxy6UISZ9yLCNC7h23eGpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043658; c=relaxed/simple;
	bh=u9ihcOTuNqVKtSFnhw1C7NMVnEDAPkh1j3bXqWvRG00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=secAhLztpe1ZEvmcH2hH1N+/lGgfyjBHoPZr9EioxmkIXccyh5MGdDDN6zsvcviCxKB7Vgr2d2QJdMo/8LeyZkjosC15cG7WekgUYGNxxJHoB1CaNtxFLd/0EsTzq7b96TBmrk1Y5wPyvLyj+StK5up0wQq7kJ45KtK7wsMPOmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogCcYAAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogCcYAAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DA1C32781;
	Wed,  7 Aug 2024 15:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043658;
	bh=u9ihcOTuNqVKtSFnhw1C7NMVnEDAPkh1j3bXqWvRG00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogCcYAAvSZ9M4G4obEtc7tI+8F+WyWzHc4PlM5o2y4hTfW4zdPqZ8RORi617VjBMN
	 z6p56F5upC+0FxM9tmHVra0zRhBcu2GCEHS1NqK7YthCiWSSNHDr58ZtHKJbOX9qsb
	 36aLEZ8iRSNZRRbOPugrRGYKaNEizvTx8cZg/XLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.1 51/86] ice: dont busy wait for Rx queue disable in ice_qp_dis()
Date: Wed,  7 Aug 2024 17:00:30 +0200
Message-ID: <20240807150040.932575330@linuxfoundation.org>
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

[ Upstream commit 1ff72a2f67791cd4ddad19ed830445f57b30e992 ]

When ice driver is spammed with multiple xdpsock instances and flow
control is enabled, there are cases when Rx queue gets stuck and unable
to reflect the disable state in QRX_CTRL register. Similar issue has
previously been addressed in commit 13a6233b033f ("ice: Add support to
enable/disable all Rx queues before waiting").

To workaround this, let us simply not wait for a disabled state as later
patch will make sure that regardless of the encountered error in the
process of disabling a queue pair, the Rx queue will be enabled.

Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 61e4730bba59e..ebc017dd245f1 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -191,10 +191,8 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
 		if (err)
 			return err;
 	}
-	err = ice_vsi_ctrl_one_rx_ring(vsi, false, q_idx, true);
-	if (err)
-		return err;
 
+	ice_vsi_ctrl_one_rx_ring(vsi, false, q_idx, false);
 	ice_qp_clean_rings(vsi, q_idx);
 	ice_qp_reset_stats(vsi, q_idx);
 
-- 
2.43.0



