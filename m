Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C266C155333;
	Mon, 16 Sep 2024 12:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488364; cv=none; b=a+fUfHwcotqs1vNmE2xsaNLxcbjkz/YRbPA1/x84odiPRdXA/ArxaQcD6oy0UI60DsVdCV3fFAjEO223Wu6ac2IQ1Zp1zYCUrvL0Gx65IYbPxKurdwCBA/hMgLSIQKGcJ2EZGxckmcVqWD+FIiXKIhivyyiIChWpG+cyaA28lMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488364; c=relaxed/simple;
	bh=SNyrMW/sEqFeMcFvrneXvRs22HP0vvORbBbD8VSY/VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDVFCXaDQswaKpK1RpvxwFzy/HRkbaQRbIGFKmkYtSFDQFZhQpgg7xZhPF2FwOtl7p48aAcfZvO+ke9KBBKpQlOWvpygVPFyjslp2neoyyxxDWQ+oNWxmj4AxucDkO2tGeGyH4Rj1O0jFdp6VErWsfgbspmS1R7l6NHsp4uP3qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbphegK1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbphegK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BFCC4CECC;
	Mon, 16 Sep 2024 12:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488364;
	bh=SNyrMW/sEqFeMcFvrneXvRs22HP0vvORbBbD8VSY/VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbphegK1QkxqSr+ssvUMNuz9yUJ03TCp5nkUr76NeyvQOR7jkINcnkUC60TNvN54C
	 cjydCByIjKD7NIm9AtcUVjG6yYUhCnXNWgwUV8lA4t5Nz6rV6csDK58+3jR+1whM6e
	 2gZQ5n5iBxdkvB99vYMNsRDENhw2lPFcIneqBOe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Paukrt <tomaspaukrt@email.cz>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 087/121] net: phy: dp83822: Fix NULL pointer dereference on DP83825 devices
Date: Mon, 16 Sep 2024 13:44:21 +0200
Message-ID: <20240916114232.020786682@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Paukrt <tomaspaukrt@email.cz>

[ Upstream commit 3f62ea572b3e8e3f10c39a9cb4f04ca9ae5f2952 ]

The probe() function is only used for DP83822 and DP83826 PHY,
leaving the private data pointer uninitialized for the DP83825 models
which causes a NULL pointer dereference in the recently introduced/changed
functions dp8382x_config_init() and dp83822_set_wol().

Add the dp8382x_probe() function, so all PHY models will have a valid
private data pointer to fix this issue and also prevent similar issues
in the future.

Fixes: 9ef9ecfa9e9f ("net: phy: dp8382x: keep WOL settings across suspends")
Signed-off-by: Tomas Paukrt <tomaspaukrt@email.cz>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/66w.ZbGt.65Ljx42yHo5.1csjxu@seznam.cz
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83822.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index efeb643c1373..fc247f479257 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -271,8 +271,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
 				DP83822_ENERGY_DET_INT_EN |
 				DP83822_LINK_QUAL_INT_EN);
 
-		/* Private data pointer is NULL on DP83825 */
-		if (!dp83822 || !dp83822->fx_enabled)
+		if (!dp83822->fx_enabled)
 			misr_status |= DP83822_ANEG_COMPLETE_INT_EN |
 				       DP83822_DUP_MODE_CHANGE_INT_EN |
 				       DP83822_SPEED_CHANGED_INT_EN;
@@ -292,8 +291,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
 				DP83822_PAGE_RX_INT_EN |
 				DP83822_EEE_ERROR_CHANGE_INT_EN);
 
-		/* Private data pointer is NULL on DP83825 */
-		if (!dp83822 || !dp83822->fx_enabled)
+		if (!dp83822->fx_enabled)
 			misr_status |= DP83822_ANEG_ERR_INT_EN |
 				       DP83822_WOL_PKT_INT_EN;
 
@@ -691,10 +689,9 @@ static int dp83822_read_straps(struct phy_device *phydev)
 	return 0;
 }
 
-static int dp83822_probe(struct phy_device *phydev)
+static int dp8382x_probe(struct phy_device *phydev)
 {
 	struct dp83822_private *dp83822;
-	int ret;
 
 	dp83822 = devm_kzalloc(&phydev->mdio.dev, sizeof(*dp83822),
 			       GFP_KERNEL);
@@ -703,6 +700,20 @@ static int dp83822_probe(struct phy_device *phydev)
 
 	phydev->priv = dp83822;
 
+	return 0;
+}
+
+static int dp83822_probe(struct phy_device *phydev)
+{
+	struct dp83822_private *dp83822;
+	int ret;
+
+	ret = dp8382x_probe(phydev);
+	if (ret)
+		return ret;
+
+	dp83822 = phydev->priv;
+
 	ret = dp83822_read_straps(phydev);
 	if (ret)
 		return ret;
@@ -717,14 +728,11 @@ static int dp83822_probe(struct phy_device *phydev)
 
 static int dp83826_probe(struct phy_device *phydev)
 {
-	struct dp83822_private *dp83822;
-
-	dp83822 = devm_kzalloc(&phydev->mdio.dev, sizeof(*dp83822),
-			       GFP_KERNEL);
-	if (!dp83822)
-		return -ENOMEM;
+	int ret;
 
-	phydev->priv = dp83822;
+	ret = dp8382x_probe(phydev);
+	if (ret)
+		return ret;
 
 	dp83826_of_init(phydev);
 
@@ -795,6 +803,7 @@ static int dp83822_resume(struct phy_device *phydev)
 		PHY_ID_MATCH_MODEL(_id),			\
 		.name		= (_name),			\
 		/* PHY_BASIC_FEATURES */			\
+		.probe          = dp8382x_probe,		\
 		.soft_reset	= dp83822_phy_reset,		\
 		.config_init	= dp8382x_config_init,		\
 		.get_wol = dp83822_get_wol,			\
-- 
2.43.0



