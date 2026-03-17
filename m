Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7053ED135;
	Tue, 17 Mar 2026 16:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765685; cv=none; b=M7gdjdVJ4OGCRh/WJWadEe+qKtB3FRGu77c7EX/Qanx1AUKH01Vng6hzwhav3tmeB82DqVVohXM01cx7x8364rWikOeFyADPOcUa4OrtkFeZW7FlNXbbY9Jm/MkxA/n17YZwRIdYWdnPpSyuW1iVAy8vi7MBwZhRvTDOU5f0Uq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765685; c=relaxed/simple;
	bh=gS9slH6yVBUsBIlxjvwU4Y75OIr12tT1wu+n2JsalXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tb5lEmw9MyH78KRtlZ4ip2nwx4eTVSR9bOwHMWuo5ZmrOc0bFHI3mUs5Pim0WVCtxymcy3TFneFDaKr0SBvSGnbM3VUa2CrUsCdXeRky3NQPuuKdJ/eqgdFkuwhBQs7S0Op3x+3iM0Y+Nuw8xGTXOcMrWIhSUPGzCsqo1NM7WPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YV3l2GEB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YV3l2GEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F143DC4CEF7;
	Tue, 17 Mar 2026 16:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765685;
	bh=gS9slH6yVBUsBIlxjvwU4Y75OIr12tT1wu+n2JsalXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YV3l2GEByfbhnRPlFkLQCRe7dpso84B5k/gh3kYAEoY5jyZgavl889SL7ltehf6f9
	 bsyxtHWYKy8DoSIIvxxdBkTtgCNvkIw+S7FXim9F/JY5NiWbSdVv5YFR0YqRLX/bCz
	 L3wyLPG/M6mU3sIJzFiSZUAMYD1q2KKFL944bwIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 070/378] amd-xgbe: fix link status handling in xgbe_rx_adaptation
Date: Tue, 17 Mar 2026 17:30:27 +0100
Message-ID: <20260317163009.593618918@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index c63ddb12237ea..13c556dc0d67a 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1942,7 +1942,7 @@ static void xgbe_set_rx_adap_mode(struct xgbe_prv_data *pdata,
 static void xgbe_rx_adaptation(struct xgbe_prv_data *pdata)
 {
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
-	unsigned int reg;
+	int reg;
 
 	/* step 2: force PCS to send RX_ADAPT Req to PHY */
 	XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_PMA_RX_EQ_CTRL4,
@@ -1964,11 +1964,20 @@ static void xgbe_rx_adaptation(struct xgbe_prv_data *pdata)
 
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



