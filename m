Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F1D2D7386;
	Wed, 20 May 2026 18:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301361; cv=none; b=FUmanxrc3akDIMpvIxQEBfZ01fZmqDjcCCYQ1TYQMqbfWcF4sJj3NFYOBts56DiLAmBOplanKrs3oW/dt678KN1NWXM6ImwbmGdgXJw7ixbl/NjK5ny9ltfDTPzjHf1wa1Vgn3xTzgNnigrpYRzgZM5Feb09n53ZrJb94h7yRYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301361; c=relaxed/simple;
	bh=BY1jCMJbj95ih/yreA7h+Jdp7043h1y6SisofbDvSD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKbuvhT5fpjC4FW0xtl1B6b3BFNuli1daH/yllpKxQ6P2Ga2iatiiNrWsqXZjmBVpZLddh9eU5BrisqP1al1OzGLxOYov6r8DSY2jivyysLUHm2wVeElYf5ZjtRXxWkqc4QTQIKHrDMwyoFXRt8CUrXKJOQPxJWhcxbpH61V4/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQM6vPZL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQM6vPZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2463F1F00893;
	Wed, 20 May 2026 18:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301359;
	bh=KQCFe/wDNJcBHoNmdnV+PIjSIyeCC3dHpST2/q3W38o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQM6vPZLFmnzBteFZNOg5uekV+qbYyRj7IkTitSvzM1KE/2FhIfEf8RKEjgcpmBUE
	 8/6JSxSxykXF/+IfGSATEA1wN+cSnZSBdxBxctContg1UZ0T8+QU8DucMA1+H+MXZD
	 fbMkV8ti/4s1/rm09QUhohQzo1/Om+EmbHqvQOTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Petr Oros <poros@redhat.com>,
	Sunitha Mekala <sunithax.d.mekala@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 484/666] ice: fix ice_ptp_read_tx_hwtstamp_status_eth56g
Date: Wed, 20 May 2026 18:21:35 +0200
Message-ID: <20260520162121.756600695@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 1f75dbc53f68f0fb2acd99f92315e426a3d0b446 ]

The ice_ptp_read_tx_hwtstamp_status_eth56g function calls
ice_read_phy_eth56g with a PHY index. However the function actually expects
a port index. This causes the function to read the wrong PHY_PTP_INT_STATUS
registers, and effectively makes the status wrong for the second set of
ports from 4 to 7.

The ice_read_phy_eth56g function uses the provided port index to determine
which PHY device to read. We could refactor the entire chain to take a PHY
index, but this would impact many code sites. Instead, multiply the PHY
index by the number of ports, so that we read from the first port of each
PHY.

Fixes: 7cab44f1c35f ("ice: Introduce ETH56G PHY model for E825C products")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Petr Oros <poros@redhat.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260420-jk-iwl-net-2026-04-20-ptp-e825c-phy-interrupt-fixes-v1-4-bc2240f42251@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index dc97bee4fd2ea..478ee1c540142 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -2682,13 +2682,19 @@ int ice_ptp_read_tx_hwtstamp_status_eth56g(struct ice_hw *hw, u32 *ts_status)
 	*ts_status = 0;
 
 	for (phy = 0; phy < params->num_phys; phy++) {
+		u8 port;
 		int err;
 
-		err = ice_read_phy_eth56g(hw, phy, PHY_PTP_INT_STATUS, &status);
+		/* ice_read_phy_eth56g expects a port index, so use the first
+		 * port of the PHY
+		 */
+		port = phy * hw->ptp.ports_per_phy;
+
+		err = ice_read_phy_eth56g(hw, port, PHY_PTP_INT_STATUS, &status);
 		if (err)
 			return err;
 
-		*ts_status |= (status & mask) << (phy * hw->ptp.ports_per_phy);
+		*ts_status |= (status & mask) << port;
 	}
 
 	ice_debug(hw, ICE_DBG_PTP, "PHY interrupt err: %x\n", *ts_status);
-- 
2.53.0



