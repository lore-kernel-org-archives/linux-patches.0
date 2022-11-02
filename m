Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0047E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D8FC433C1;
	Wed,  2 Nov 2022 03:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358461;
	bh=Rdtz2+NMlHqfzvnBhPb7jsXkgsCrR+NxMxJNqpYP2m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsMHTTiuEXY/oLqoJsq1zXCUa7hNdkzlcgH+YGTBhehPqx+c07EDE49QCey+zP9nm
	 JqcqMZbXU0rq8LMKm2QcP4yWMseGYsE3h+s0R9u708ZqqkBfKpxQvShyky6RNrf7Va
	 PIWg/wBEevmxQWuRxdSjYWqZ3hwGNN4lvTVvZnMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/132] amd-xgbe: fix the SFP compliance codes check for DAC cables
Date: Wed,  2 Nov 2022 03:33:03 +0100
Message-Id: <20221102022101.635959976@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit 09c5f6bf11ac98874339e55f4f5f79a9dbc9b375 ]

The current XGBE code assumes that offset 6 of EEPROM SFP DAC (passive)
cables is NULL. However, some cables (the 5 meter and 7 meter Molex
passive cables) have non-zero data at offset 6. Fix the logic by moving
the passive cable check above the active checks, so as not to be
improperly identified as an active cable. This will fix the issue for
any passive cable that advertises 1000Base-CX in offset 6.

Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 213769054391..21e38b720d87 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1151,7 +1151,10 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
 	}
 
 	/* Determine the type of SFP */
-	if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
+	if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
+	    xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
+		phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
+	else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
 		phy_data->sfp_base = XGBE_SFP_BASE_10000_SR;
 	else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_LR)
 		phy_data->sfp_base = XGBE_SFP_BASE_10000_LR;
@@ -1167,9 +1170,6 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
 		phy_data->sfp_base = XGBE_SFP_BASE_1000_CX;
 	else if (sfp_base[XGBE_SFP_BASE_1GBE_CC] & XGBE_SFP_BASE_1GBE_CC_T)
 		phy_data->sfp_base = XGBE_SFP_BASE_1000_T;
-	else if ((phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE) &&
-		 xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
-		phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
 
 	switch (phy_data->sfp_base) {
 	case XGBE_SFP_BASE_1000_T:
-- 
2.35.1



