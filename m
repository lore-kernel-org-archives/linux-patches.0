Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAC32C181;
	Mon, 23 Mar 2026 14:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275438; cv=none; b=W9n+ABJNJgWQ3KXsn8uVG11fHI4mm/RVvQRyYNdnbe6J6Sf40jA1JeMVlvOsVw32moZBCpEFVpy6f9UJ09gkRy3nXbNgiOvOUEbMNIAMr7ef4DiWnRMUMoCCEHHmyoF4UaHHsbtV/w62Yrw2WQ2/HXi3t89JcsfHJwD+SDoo/UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275438; c=relaxed/simple;
	bh=4Byr7RtviH4ahW1zjxBKl37KjLnr+Ma2V2wWJ65ouSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cckn0nYuwzM80NFAixjC98pftNFkVdY2PrReNyC1bfYuuiclr7XyL2lA5x9zymt/xHHBG7U46/uUEwBomHhM4aq65EGnIFbFtXNuBMYGzaaIsmcxqBut8MLTaej+xgbCVw/I9e00h24iSUSOG+TOjDlCkgLnU4S+JqMI9WVGsH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMeZ0S91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMeZ0S91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1002C4CEF7;
	Mon, 23 Mar 2026 14:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275438;
	bh=4Byr7RtviH4ahW1zjxBKl37KjLnr+Ma2V2wWJ65ouSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMeZ0S91Xm7dB/JC0kRuOQq2nskORrlf/DavoPx4kKXLFbZ9PYqBd02YXX0sRLQ5n
	 jnLF6YnnBigy87CSI7h6Kc9SviXsB7cedHnvWzQ6ddCU4tHGk1oXOT2SjlvRWWmu+j
	 MlfWbkxqvxX6Bb/4sxFGrnsxTocryz/pfgNOFfgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/460] amd-xgbe: fix link status handling in xgbe_rx_adaptation
Date: Mon, 23 Mar 2026 14:40:53 +0100
Message-ID: <20260323134528.106697468@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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



