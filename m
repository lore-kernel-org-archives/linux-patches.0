Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6473B47DE;
	Mon, 23 Mar 2026 15:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278355; cv=none; b=EqFCv4NQoIQGFTsEjXSG3T3JRkcjHJID267Oe14w4TKIpxTapiP+/Gd8EZLL6R8nAv+UrvZkGXVmTm/lz0z7K02/0Ore+UZA9X/xRRYMBiCgfyl5yeSHFmOSlHKO7qnOTWIPoSHpOc6JgwZ27dgettVQrk4fnCFol6Fomq/tkI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278355; c=relaxed/simple;
	bh=5pnITQGUsfobNk0zUidOgVlvPP9uaYBFehhMJyCdbcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9Pq9+4yr7a0ZCqrvoAhdJY+uFIGap/F8bA0WfWEV1BVh/jwMOaLwN30jihmSJdUQw9l5CVRFWb3CxWnGhGstTuT3wSuOBYlbHbMLDcTUtqpxTGUEXpzEhOmEWSur9dTKMrIsMlOKuaMtKHy2IZ+KNWkdt2UQSYS5NQx7rE1Ue0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PbgK4qVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbgK4qVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DBEC2BC9E;
	Mon, 23 Mar 2026 15:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278355;
	bh=5pnITQGUsfobNk0zUidOgVlvPP9uaYBFehhMJyCdbcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbgK4qVFPOxF0QN1N0tGBx1xM2w7Q0qxwGD7gHJNlOGCGqEy2mt9Fd0Nrcr90zqYM
	 OSH38jFqfNp8KOdy8RdLWH0eQxnitnTVHyS6sbq7hum7Mo0XEF4gGlpIlS/p9LGWKf
	 R+AdDnB+gJNqs7y5HRnEooX09ihRQQcU57F5oUdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 238/567] amd-xgbe: fix link status handling in xgbe_rx_adaptation
Date: Mon, 23 Mar 2026 14:42:38 +0100
Message-ID: <20260323134539.722728110@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit 6485cb96be5cd0f4bf39554737ba11322cc9b053 ]

The link status bit is latched low to allow detection of momentary
link drops. If the status indicates that the link is already down,
read it again to obtain the current state.

Fixes: 4f3b20bfbb75 ("amd-xgbe: add support for rx-adaptation")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Link: https://patch.msgid.link/20260306111629.1515676-2-Raju.Rangoju@amd.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 6d2c401bb246e..469b28c159e7d 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -2050,7 +2050,7 @@ static void xgbe_set_rx_adap_mode(struct xgbe_prv_data *pdata,
 static void xgbe_rx_adaptation(struct xgbe_prv_data *pdata)
 {
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
-	unsigned int reg;
+	int reg;
 
 	/* step 2: force PCS to send RX_ADAPT Req to PHY */
 	XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_PMA_RX_EQ_CTRL4,
@@ -2072,11 +2072,20 @@ static void xgbe_rx_adaptation(struct xgbe_prv_data *pdata)
 
 	/* Step 4: Check for Block lock */
 
-	/* Link status is latched low, so read once to clear
-	 * and then read again to get current state
-	 */
-	reg = XMDIO_READ(pdata, MDIO_MMD_PCS, MDIO_STAT1);
 	reg = XMDIO_READ(pdata, MDIO_MMD_PCS, MDIO_STAT1);
+	if (reg < 0)
+		goto set_mode;
+
+	/* Link status is latched low so that momentary link drops
+	 * can be detected. If link was already down read again
+	 * to get the latest state.
+	 */
+	if (!pdata->phy.link && !(reg & MDIO_STAT1_LSTATUS)) {
+		reg = XMDIO_READ(pdata, MDIO_MMD_PCS, MDIO_STAT1);
+		if (reg < 0)
+			goto set_mode;
+	}
+
 	if (reg & MDIO_STAT1_LSTATUS) {
 		/* If the block lock is found, update the helpers
 		 * and declare the link up
-- 
2.51.0



