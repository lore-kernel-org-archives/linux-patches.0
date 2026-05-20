Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DE53B0AD6;
	Wed, 20 May 2026 17:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299160; cv=none; b=usKesDtz+bECsyP+2QoHo2PX7NC8RVCd6PCUW0ExlV41kSkHqobYZBoEnAtbcLzGgTLV5/K+sXTunlb8yyilWvTI0TzPdwAlDN5+4sMLN0PJQD/nvS8SWJ/1G3R6eTex64rAfuZ+S33EBcqfDxS8KOGWJxk+QQjeOGPKpQO5y7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299160; c=relaxed/simple;
	bh=aHfKMZviPcZ5/OZ0HSAuTZ75HkFkOjYNOJksmdk2m4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8VvkCJEuWzTGoeRbxrRqngjRw/2dcjCWW0iVfOG8PkJMMX5iWWRbzhuG77+AuLjGwRQIeX+S63QTyYmTozr3ZY67ITM22W0R8BmSGG9H/7RvLeRHT4qkrfPStoUG73O/9nw6K1hHiDfdDR+ytx/uLsxF7otLx1sALIPB+eoLys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1zAbkJl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1zAbkJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BE31F000E9;
	Wed, 20 May 2026 17:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299159;
	bh=22J7IeiOuMqwuvbdksTW0R8yYXbFGX9zVccPof/Evvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1zAbkJlsU7S98oKDpmfQ6WSBfyS90k8Kc5GbfbqlaBR0q9bzJtOIFY9ZBIWNtPCa
	 xkv0k9CRaS3X4nIWrQvoLtNrHhNWOCHOFu0llLtvRayormMPqebRKuke0DQ633F2bq
	 ZatUGcgBchwhXpUDg92JiIcxGHdUAqYc+7Dh3G8o=
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
Subject: [PATCH 6.18 685/957] ice: fix ice_ptp_read_tx_hwtstamp_status_eth56g
Date: Wed, 20 May 2026 18:19:28 +0200
Message-ID: <20260520162149.395728923@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 22d6df06b0bc7..d461e00d15e9e 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -2219,13 +2219,19 @@ int ice_ptp_read_tx_hwtstamp_status_eth56g(struct ice_hw *hw, u32 *ts_status)
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



