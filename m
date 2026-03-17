Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB792F60A7;
	Tue, 17 Mar 2026 17:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767334; cv=none; b=cjseYNIBNoN1Zoo0mSCT/c4whd6bjITjFoxYlQQvBSLzx4lDBY21ZAZKOa/T+pIQ1DT52O3uKygmlOzfntKF3qSMK5FyYC/N8C68o1a1cPUWZbvQULgS6YV/FziuPCM+3KnnttTP0Zjkn70qBkfPbhibBtjJBHVPOJ/qDWAD1gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767334; c=relaxed/simple;
	bh=1nj9BFNXSjU3guZ0EXaD4y/06q/WMIvWGnlNIEo9y7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwqUg7gzCaIXKf1ZnqJx5qXJDurmDyMhY454EEvksiCnNmUlsV5GNL6/CV9ByxN38V14qVhUQ6vl0b04W4TMINbjYcQRiNXQqI7Hfr67Bj64zho9g7IemjrlYBdAO/LiK1czLlqiuVq+dl8I7NMilOPGxs7ag4zc6auEuxPkaB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LxLU7LL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LxLU7LL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD1BC4CEF7;
	Tue, 17 Mar 2026 17:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767334;
	bh=1nj9BFNXSjU3guZ0EXaD4y/06q/WMIvWGnlNIEo9y7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0LxLU7LLpMJsOsL2gGtCwzn+skqv0c1yqVuywQHF5CryZhglnzRgfCwnW6nXCroSy
	 m3vnIch94ALFI61XWuwVWuRAoCX1mjEvf6y5Zt4QHlvySVr9Pjsym5jyR/xdSIZx2h
	 6EVdBSOYXNo9O71O7EpOSX1+X02w2zMXDc5P/M/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 063/333] amd-xgbe: fix link status handling in xgbe_rx_adaptation
Date: Tue, 17 Mar 2026 17:31:32 +0100
Message-ID: <20260317163001.707192073@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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
index 450a573960e7a..92cb061c90ebc 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -1941,7 +1941,7 @@ static void xgbe_set_rx_adap_mode(struct xgbe_prv_data *pdata,
 static void xgbe_rx_adaptation(struct xgbe_prv_data *pdata)
 {
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
-	unsigned int reg;
+	int reg;
 
 	/* step 2: force PCS to send RX_ADAPT Req to PHY */
 	XMDIO_WRITE_BITS(pdata, MDIO_MMD_PMAPMD, MDIO_PMA_RX_EQ_CTRL4,
@@ -1963,11 +1963,20 @@ static void xgbe_rx_adaptation(struct xgbe_prv_data *pdata)
 
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



