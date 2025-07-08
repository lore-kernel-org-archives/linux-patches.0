Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E142E49AF;
	Tue,  8 Jul 2025 16:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992350; cv=none; b=svnidpBIIaFeJeut86fueHsXVp3Y9xo1Z1NMKexQbROKH71C0FDGFhyBg47zBhheuXIT7aE2GYunp2vDfAfRLrIqLBEkhaf5GZ9GqJJ0lMeaV0XROr0asUh2OFOdVNNNx50MJfVIZWm8ogtP3QkLB4HFGeG564Dne+7mxVbvzTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992350; c=relaxed/simple;
	bh=sxvDtlSsVq8L8ULGsDIF4OzuF4PSDJA4q2OqVEM3wZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvWTb/3vjWOVhmE86GwVIEw+1ytxwRaQFJai36c7to+TcZGbupFe/m0F+zg8/Vy9eB8nFduT6bI2JdAcKU6BzBew51tWMYu629fGCCHBvTVrt+dcJ9JW5lbbpaJYve1xF1ORbm6BNd+8iNVAglExWb8pB5Q7219DTpFLP5CxdMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jIbnmRlK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jIbnmRlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8F9C4CEED;
	Tue,  8 Jul 2025 16:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992350;
	bh=sxvDtlSsVq8L8ULGsDIF4OzuF4PSDJA4q2OqVEM3wZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIbnmRlKbmNVa74CdzND/6THKnhY3hL94M6V1VDELiNRFTeBU2SmF51QnZeUIN28u
	 GRSkYcSS/0M769ySaeIymrkZzwTHW+gY/ge/b4Q+ywOEkvn0mz81BuNbIb09i5bkie
	 cyM1WlhDbwDt96duWl/Mki47zN8hlyBzr51RUVnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/132] amd-xgbe: do not double read link status
Date: Tue,  8 Jul 2025 18:22:53 +0200
Message-ID: <20250708162232.471600182@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 154e7598a32bf..8345d439184eb 100644
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



