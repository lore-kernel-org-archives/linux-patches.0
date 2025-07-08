Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA09F9E8;
	Tue,  8 Jul 2025 16:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992819; cv=none; b=O0vnqkAdikLx7bSJYCLKRe4TFLwKsVwYIwWVfZ08TvND3rdOyjWl443BAAxQ5GjAEOvT95JDJqAawYku/IP+Bg0QWkUd1JgWVvrhOWAlSreqPSuQNqZjyxv4qHbx1sU9wvp2u8aLSRLmdE8zwrquPH2THY+aT5RCe7s6u4IA+rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992819; c=relaxed/simple;
	bh=DpXr8utQXyqN9jOD9sZ+79O757stDU9FjSnEWCoE4JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gN4pDAQPQ0UyfcHS6lFmqHxXRNLTyqXoA4yz79/0itd2dKCQFZ8GbV7s+V1Txor1uBff4vrmPu3qdStLpFvXDzJYFPjwYECp3GQjeYbQNbYh8Af/aq+/By8mKbBpxnV/hWuCQ8JdAKv4RW8V1YrFEQLUU49MUDWCqso/QIKQCBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wK4qJfN7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wK4qJfN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFD3C4CEED;
	Tue,  8 Jul 2025 16:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992819;
	bh=DpXr8utQXyqN9jOD9sZ+79O757stDU9FjSnEWCoE4JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wK4qJfN7byJUrmA4aedDzSK+XwM0kC1IJe5Jl569pwYxBX2hp/9kxaXc5zOT62yx+
	 vkDpIV0tKvKdQTiycr2a+gL2TrzfZRD3MBOLT/I2xZMBdDJAZWAXjxJfNtUStMYD5P
	 7dP2eczwsTChh4wbuKTleg6wBkGis/jlqb3wKDC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/232] amd-xgbe: do not double read link status
Date: Tue,  8 Jul 2025 18:21:27 +0200
Message-ID: <20250708162243.832752342@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit 16ceda2ef683a50cd0783006c0504e1931cd8879 ]

The link status is latched low so that momentary link drops
can be detected. Always double-reading the status defeats this
design feature. Only double read if link was already down

This prevents unnecessary duplicate readings of the link status.

Fixes: 4f3b20bfbb75 ("amd-xgbe: add support for rx-adaptation")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250701065016.4140707-1-Raju.Rangoju@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c   |  4 ++++
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 24 +++++++++++++--------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 3316c719f9f8c..ed76a8df6ec6e 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -1413,6 +1413,10 @@ static void xgbe_phy_status(struct xgbe_prv_data *pdata)
 
 	pdata->phy.link = pdata->phy_if.phy_impl.link_status(pdata,
 							     &an_restart);
+	/* bail out if the link status register read fails */
+	if (pdata->phy.link < 0)
+		return;
+
 	if (an_restart) {
 		xgbe_phy_config_aneg(pdata);
 		goto adjust_link;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 268399dfcf22f..32e633d113484 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -2855,8 +2855,7 @@ static bool xgbe_phy_valid_speed(struct xgbe_prv_data *pdata, int speed)
 static int xgbe_phy_link_status(struct xgbe_prv_data *pdata, int *an_restart)
 {
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
-	unsigned int reg;
-	int ret;
+	int reg, ret;
 
 	*an_restart = 0;
 
@@ -2890,11 +2889,20 @@ static int xgbe_phy_link_status(struct xgbe_prv_data *pdata, int *an_restart)
 			return 0;
 	}
 
-	/* Link status is latched low, so read once to clear
-	 * and then read again to get current state
-	 */
-	reg = XMDIO_READ(pdata, MDIO_MMD_PCS, MDIO_STAT1);
 	reg = XMDIO_READ(pdata, MDIO_MMD_PCS, MDIO_STAT1);
+	if (reg < 0)
+		return reg;
+
+	/* Link status is latched low so that momentary link drops
+	 * can be detected. If link was already down read again
+	 * to get the latest state.
+	 */
+
+	if (!pdata->phy.link && !(reg & MDIO_STAT1_LSTATUS)) {
+		reg = XMDIO_READ(pdata, MDIO_MMD_PCS, MDIO_STAT1);
+		if (reg < 0)
+			return reg;
+	}
 
 	if (pdata->en_rx_adap) {
 		/* if the link is available and adaptation is done,
@@ -2913,9 +2921,7 @@ static int xgbe_phy_link_status(struct xgbe_prv_data *pdata, int *an_restart)
 			xgbe_phy_set_mode(pdata, phy_data->cur_mode);
 		}
 
-		/* check again for the link and adaptation status */
-		reg = XMDIO_READ(pdata, MDIO_MMD_PCS, MDIO_STAT1);
-		if ((reg & MDIO_STAT1_LSTATUS) && pdata->rx_adapt_done)
+		if (pdata->rx_adapt_done)
 			return 1;
 	} else if (reg & MDIO_STAT1_LSTATUS)
 		return 1;
-- 
2.39.5



