Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A7212EBEA;
	Tue, 25 Jun 2024 09:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308621; cv=none; b=HmWg7KEJTqtmWSc93CYcaqAAMClbKDXsA7IOsD8O9cREBaKyXwUxl6dHWMSMqfKtYp+jbaV8+tyIB8xXrObP8AHLrQayhumpSQxIIFSGBr/ZQ/92I6e2dQFeT5RTb0CxDqFYJzFI4IE9y66X+DiEfsXzfy7JvDVeR3UovAz/Pps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308621; c=relaxed/simple;
	bh=hpcN+LxtHndGzybQfaJmxtnT+WC0AHTD3X3bqXcXMds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVpkOIFYdKfaA0hE9YpXvvesTECF6ENiE7/Vk+83lfxNLOSsaykwQ9U5TkaFHs/LOyxB6e1mMr17Ecm9oruzixvUg+EFPC+a2Gx5xcR/ghtSuupjswflPncTCkhmEMVGCZUTAtaj+YBiTvpjd5j1IGKGfTN70K+x0ARKnyYFoUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqBSpvrb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqBSpvrb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5071C32781;
	Tue, 25 Jun 2024 09:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308621;
	bh=hpcN+LxtHndGzybQfaJmxtnT+WC0AHTD3X3bqXcXMds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqBSpvrb+fXbBRTbe6yHpC5B3P5E/bgcBg5tYL4fO0DsfDw929h32QmLzChB1rkAt
	 KYGLzrgnuEDCXFVkMrPurATdt+E06KkK7BpBghagP8XuRtY+TeotopEWyQbcrdc6QV
	 R6VaWTcbMaVqrsd2ozXnqG3HRWVaBk5xruhlKmpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.9 183/250] net: phy: dp83tg720: get master/slave configuration in link down state
Date: Tue, 25 Jun 2024 11:32:21 +0200
Message-ID: <20240625085555.076107810@linuxfoundation.org>
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

commit 40a64cc9679540ff7c46ecc51178b07d42abbb1c upstream.

Get master/slave configuration for initial system start with the link in
down state. This ensures ethtool shows current configuration.  Also
fixes link reconfiguration with ethtool while in down state, preventing
ethtool from displaying outdated configuration.

Even though dp83tg720_config_init() is executed periodically as long as
the link is in admin up state but no carrier is detected, this is not
sufficient for the link in admin down state where
dp83tg720_read_status() is not periodically executed. To cover this
case, we need an extra read role configuration in
dp83tg720_config_aneg().

Fixes: cb80ee2f9bee1 ("net: phy: Add support for the DP83TG720S Ethernet PHY")
Cc: stable@vger.kernel.org
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20240614094516.1481231-2-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/dp83tg720.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/dp83tg720.c b/drivers/net/phy/dp83tg720.c
index 1186dfc70fb3..c706429b225a 100644
--- a/drivers/net/phy/dp83tg720.c
+++ b/drivers/net/phy/dp83tg720.c
@@ -36,11 +36,20 @@
 
 static int dp83tg720_config_aneg(struct phy_device *phydev)
 {
+	int ret;
+
 	/* Autoneg is not supported and this PHY supports only one speed.
 	 * We need to care only about master/slave configuration if it was
 	 * changed by user.
 	 */
-	return genphy_c45_pma_baset1_setup_master_slave(phydev);
+	ret = genphy_c45_pma_baset1_setup_master_slave(phydev);
+	if (ret)
+		return ret;
+
+	/* Re-read role configuration to make changes visible even if
+	 * the link is in administrative down state.
+	 */
+	return genphy_c45_pma_baset1_read_master_slave(phydev);
 }
 
 static int dp83tg720_read_status(struct phy_device *phydev)
@@ -69,6 +78,8 @@ static int dp83tg720_read_status(struct phy_device *phydev)
 			return ret;
 
 		/* After HW reset we need to restore master/slave configuration.
+		 * genphy_c45_pma_baset1_read_master_slave() call will be done
+		 * by the dp83tg720_config_aneg() function.
 		 */
 		ret = dp83tg720_config_aneg(phydev);
 		if (ret)
@@ -168,8 +179,15 @@ static int dp83tg720_config_init(struct phy_device *phydev)
 	/* In case the PHY is bootstrapped in managed mode, we need to
 	 * wake it.
 	 */
-	return phy_write_mmd(phydev, MDIO_MMD_VEND2, DP83TG720S_LPS_CFG3,
-			     DP83TG720S_LPS_CFG3_PWR_MODE_0);
+	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, DP83TG720S_LPS_CFG3,
+			    DP83TG720S_LPS_CFG3_PWR_MODE_0);
+	if (ret)
+		return ret;
+
+	/* Make role configuration visible for ethtool on init and after
+	 * rest.
+	 */
+	return genphy_c45_pma_baset1_read_master_slave(phydev);
 }
 
 static struct phy_driver dp83tg720_driver[] = {
-- 
2.45.2



