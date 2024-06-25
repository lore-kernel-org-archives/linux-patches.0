Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D7212EBEA;
	Tue, 25 Jun 2024 09:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308609; cv=none; b=ADMAa7ymR+nBruXgjxLUQwisiwj7FL2a7QKN87lu68JMa+OWGegvv7avfc833MSII8cJfqKhFkpmYUSYSi8uVn2J964xHsKrdRwoHni5h2ndwL8yf7h55Eg/mDXqm6Ek72zFk6nPQ/I2xx41yF3G/UVUhFud0R+EQelMcOEfltA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308609; c=relaxed/simple;
	bh=ltXZTsNS+7jIefy/0ulW8yvZULRen9s8E0fFb6dgSjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTyLw9otgCHOVgbXI3Aq22B9o82I69pWf5hWXTDiDNK6zxdrNCdl4yJvQZTcUM+v1vCssMlAqM2kgt1K56dFY3qQlq3wgNqbsv9wnG3dsC1OKJxu83Qjz6x7TOgRK+L+oP3ybwoglAjtqOEWfDBLFvPRDq4yna+rrYhlhc/sboU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKHdM0mh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKHdM0mh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106A5C32781;
	Tue, 25 Jun 2024 09:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308609;
	bh=ltXZTsNS+7jIefy/0ulW8yvZULRen9s8E0fFb6dgSjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKHdM0mhHCYKdNeimi416DyxNR6asGBK9Q6f5/CImtp2cYOnvH+RhPq/B9k2PVbCh
	 5cD/qcK0XQrpoNZvEZ3gBrP6ZFMdLBp9GN4ZxtEAcm/xgmfz3os7t+DEMiBGZUJtG/
	 gCCEVdaI0t3+G+ZRAzcP60dhy1ynTZxh+a1lVr34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.9 180/250] net: phy: dp83tg720: wake up PHYs in managed mode
Date: Tue, 25 Jun 2024 11:32:18 +0200
Message-ID: <20240625085554.960136943@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit cd6f12e173df44a20c2ac2ac110007dc14968088 upstream.

In case this PHY is bootstrapped for managed mode, we need to manually
wake it. Otherwise no link will be detected.

Cc: stable@vger.kernel.org
Fixes: cb80ee2f9bee1 ("net: phy: Add support for the DP83TG720S Ethernet PHY")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20240614094516.1481231-1-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/dp83tg720.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/dp83tg720.c b/drivers/net/phy/dp83tg720.c
index 326c9770a6dc..1186dfc70fb3 100644
--- a/drivers/net/phy/dp83tg720.c
+++ b/drivers/net/phy/dp83tg720.c
@@ -17,6 +17,11 @@
 #define DP83TG720S_PHY_RESET			0x1f
 #define DP83TG720S_HW_RESET			BIT(15)
 
+#define DP83TG720S_LPS_CFG3			0x18c
+/* Power modes are documented as bit fields but used as values */
+/* Power Mode 0 is Normal mode */
+#define DP83TG720S_LPS_CFG3_PWR_MODE_0		BIT(0)
+
 #define DP83TG720S_RGMII_DELAY_CTRL		0x602
 /* In RGMII mode, Enable or disable the internal delay for RXD */
 #define DP83TG720S_RGMII_RX_CLK_SEL		BIT(1)
@@ -154,10 +159,17 @@ static int dp83tg720_config_init(struct phy_device *phydev)
 	 */
 	usleep_range(1000, 2000);
 
-	if (phy_interface_is_rgmii(phydev))
-		return dp83tg720_config_rgmii_delay(phydev);
+	if (phy_interface_is_rgmii(phydev)) {
+		ret = dp83tg720_config_rgmii_delay(phydev);
+		if (ret)
+			return ret;
+	}
 
-	return 0;
+	/* In case the PHY is bootstrapped in managed mode, we need to
+	 * wake it.
+	 */
+	return phy_write_mmd(phydev, MDIO_MMD_VEND2, DP83TG720S_LPS_CFG3,
+			     DP83TG720S_LPS_CFG3_PWR_MODE_0);
 }
 
 static struct phy_driver dp83tg720_driver[] = {
-- 
2.45.2



