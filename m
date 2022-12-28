Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741041C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA47C433EF;
	Wed, 28 Dec 2022 16:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243731;
	bh=hoHcJ1yWNHEcu8fm58/F1BLXG3UF5mL5jGRp1Ibx4SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GfvW/xEYsuXTw1pTAjVaAc1aMKdzWAqJH/pGA/EFd8o0Ja33fAARNECrJ7zhCYrIy
	 u9lLYMrDZIlKvF/a1T8lXM55bpSEQCbuZPeniACfJSM9Pk5n/tDjjyUT81+9S26r0W
	 qLneBKceH41FaJnMlDpugCePJN0EjcpfVPbN3Pow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0546/1146] net: amd-xgbe: Fix logic around active and passive cables
Date: Wed, 28 Dec 2022 15:34:45 +0100
Message-Id: <20221228144345.002356713@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tom Lendacky <thomas.lendacky@amd.com>

[ Upstream commit 4998006c73afe44e2f639d55bd331c6c26eb039f ]

SFP+ active and passive cables are copper cables with fixed SFP+ end
connectors. Due to a misinterpretation of this, SFP+ active cables could
end up not being recognized, causing the driver to fail to establish a
connection.

Introduce a new enum in SFP+ cable types, XGBE_SFP_CABLE_FIBER, that is
the default cable type, and handle active and passive cables when they are
specifically detected.

Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 4064c3e3dd49..868a768f424c 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -189,6 +189,7 @@ enum xgbe_sfp_cable {
 	XGBE_SFP_CABLE_UNKNOWN = 0,
 	XGBE_SFP_CABLE_ACTIVE,
 	XGBE_SFP_CABLE_PASSIVE,
+	XGBE_SFP_CABLE_FIBER,
 };
 
 enum xgbe_sfp_base {
@@ -1149,16 +1150,18 @@ static void xgbe_phy_sfp_parse_eeprom(struct xgbe_prv_data *pdata)
 	phy_data->sfp_tx_fault = xgbe_phy_check_sfp_tx_fault(phy_data);
 	phy_data->sfp_rx_los = xgbe_phy_check_sfp_rx_los(phy_data);
 
-	/* Assume ACTIVE cable unless told it is PASSIVE */
+	/* Assume FIBER cable unless told otherwise */
 	if (sfp_base[XGBE_SFP_BASE_CABLE] & XGBE_SFP_BASE_CABLE_PASSIVE) {
 		phy_data->sfp_cable = XGBE_SFP_CABLE_PASSIVE;
 		phy_data->sfp_cable_len = sfp_base[XGBE_SFP_BASE_CU_CABLE_LEN];
-	} else {
+	} else if (sfp_base[XGBE_SFP_BASE_CABLE] & XGBE_SFP_BASE_CABLE_ACTIVE) {
 		phy_data->sfp_cable = XGBE_SFP_CABLE_ACTIVE;
+	} else {
+		phy_data->sfp_cable = XGBE_SFP_CABLE_FIBER;
 	}
 
 	/* Determine the type of SFP */
-	if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
+	if (phy_data->sfp_cable != XGBE_SFP_CABLE_FIBER &&
 	    xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
 		phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
 	else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
-- 
2.35.1



