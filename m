Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4672E412C05;
	Fri,  7 Aug 2026 15:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115190; cv=none; b=Sw/bwjnFa1uwP2qGbKSTbDJYwUNSHY/oh2jQPVmp1YaiDeWeF2VGmAm+1hRYuEeo28dN7WaEAqPc1KWA+rF3aUgvNTE2zrKEduGKVVW+kM1vBSQC6ZfZhtc1S9KS5gDQYyqUjRxOrkl3WwNyNVpfovrgSAO6ocLBSEV+P4nQJsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115190; c=relaxed/simple;
	bh=iXjZRFmpQkkvsqoqLcuGVpqljg/y8GWoeow7bbAJ7SY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czIWJ0pODgX9C2daOmMjegNpq63rRqOnL9cRhoHaiK4AzZl2QwuX0kqKPADncCLyp4xuQGpIFyDk4d0YL8LYFGD2YpfM2VIz+5iZSfPwFsAIUM5zYwEsZSjC9wQ/LdQv7Ve1R+7yIAt5SNwZjki0KKzjbyrAs9eBL2sI+ctRVaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HB3bIEwh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HB3bIEwh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731311F000E9;
	Fri,  7 Aug 2026 15:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115189;
	bh=8jRxHip1smzPu+lDJrY8zSv7cFZuuFu8kBcG/d/gPBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HB3bIEwhTqLeugjUtpMnAMlEmxh53pLmXzH7y4tboGYnsfHEDKgs+oCFZ4wfQmCcq
	 CZW6wPZAUhOiwpToAElAWwoz7+QpR5zyKyVf/5Zy9yAj16fLgxv0t36sCcTzoeAXwD
	 kZ4Xo/Dn5tSKlIrLDRwi745e4TP2v1LsIck4l/dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 145/396] net: dsa: mt7530: error out on failed reads in MT7531 PHY polling
Date: Fri,  7 Aug 2026 16:35:05 +0200
Message-ID: <20260807143427.438595551@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 77a9ebe8818cf6dd1699bd6728cb5d66307801d7 ]

The MT7531 indirect PHY access functions poll MT7531_PHY_IAC through
a helper which returns 0 when the underlying read fails, so a failed
bus transaction clears MT7531_PHY_ACS_ST and the access carries on,
returning garbage PHY register data to phylib.

Poll using regmap_read_poll_timeout(), which stops on read errors and
propagates them. These functions hold the MDIO bus lock across the
whole sequence, so the unlocked regmap accesses remain correct. Remove
the now-unused _mt7530_unlocked_read().

Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/79e85d68d210cc37342978171aa6432aa2954333.1785213071.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 58 ++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 38 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 4571da0d7a8f6..2a70fa4b5fa3e 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -188,12 +188,6 @@ mt7530_write(struct mt7530_priv *priv, u32 reg, u32 val)
 	mt7530_mutex_unlock(priv);
 }
 
-static u32
-_mt7530_unlocked_read(struct mt7530_dummy_poll *p)
-{
-	return mt7530_mii_read(p->priv, p->reg);
-}
-
 static u32
 _mt7530_read(struct mt7530_dummy_poll *p)
 {
@@ -546,16 +540,13 @@ static int
 mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
 			int regnum)
 {
-	struct mt7530_dummy_poll p;
 	u32 reg, val;
 	int ret;
 
-	INIT_MT7530_DUMMY_POLL(&p, priv, MT7531_PHY_IAC);
-
 	mt7530_mutex_lock(priv);
 
-	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
-				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
+	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
+				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
 	if (ret < 0) {
 		dev_err(priv->dev, "poll timeout\n");
 		goto out;
@@ -565,8 +556,8 @@ mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
 	      MT7531_MDIO_DEV_ADDR(devad) | regnum;
 	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
 
-	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
-				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
+	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
+				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
 	if (ret < 0) {
 		dev_err(priv->dev, "poll timeout\n");
 		goto out;
@@ -576,8 +567,8 @@ mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
 	      MT7531_MDIO_DEV_ADDR(devad);
 	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
 
-	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
-				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
+	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
+				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
 	if (ret < 0) {
 		dev_err(priv->dev, "poll timeout\n");
 		goto out;
@@ -594,16 +585,13 @@ static int
 mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
 			 int regnum, u16 data)
 {
-	struct mt7530_dummy_poll p;
 	u32 val, reg;
 	int ret;
 
-	INIT_MT7530_DUMMY_POLL(&p, priv, MT7531_PHY_IAC);
-
 	mt7530_mutex_lock(priv);
 
-	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
-				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
+	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
+				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
 	if (ret < 0) {
 		dev_err(priv->dev, "poll timeout\n");
 		goto out;
@@ -613,8 +601,8 @@ mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
 	      MT7531_MDIO_DEV_ADDR(devad) | regnum;
 	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
 
-	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
-				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
+	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
+				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
 	if (ret < 0) {
 		dev_err(priv->dev, "poll timeout\n");
 		goto out;
@@ -624,8 +612,8 @@ mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
 	      MT7531_MDIO_DEV_ADDR(devad) | data;
 	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
 
-	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
-				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
+	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
+				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
 	if (ret < 0) {
 		dev_err(priv->dev, "poll timeout\n");
 		goto out;
@@ -640,16 +628,13 @@ mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
 static int
 mt7531_ind_c22_phy_read(struct mt7530_priv *priv, int port, int regnum)
 {
-	struct mt7530_dummy_poll p;
 	int ret;
 	u32 val;
 
-	INIT_MT7530_DUMMY_POLL(&p, priv, MT7531_PHY_IAC);
-
 	mt7530_mutex_lock(priv);
 
-	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
-				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
+	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
+				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
 	if (ret < 0) {
 		dev_err(priv->dev, "poll timeout\n");
 		goto out;
@@ -660,8 +645,8 @@ mt7531_ind_c22_phy_read(struct mt7530_priv *priv, int port, int regnum)
 
 	mt7530_mii_write(priv, MT7531_PHY_IAC, val | MT7531_PHY_ACS_ST);
 
-	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
-				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
+	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
+				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
 	if (ret < 0) {
 		dev_err(priv->dev, "poll timeout\n");
 		goto out;
@@ -678,16 +663,13 @@ static int
 mt7531_ind_c22_phy_write(struct mt7530_priv *priv, int port, int regnum,
 			 u16 data)
 {
-	struct mt7530_dummy_poll p;
 	int ret;
 	u32 reg;
 
-	INIT_MT7530_DUMMY_POLL(&p, priv, MT7531_PHY_IAC);
-
 	mt7530_mutex_lock(priv);
 
-	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, reg,
-				 !(reg & MT7531_PHY_ACS_ST), 20, 100000);
+	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, reg,
+				       !(reg & MT7531_PHY_ACS_ST), 20, 100000);
 	if (ret < 0) {
 		dev_err(priv->dev, "poll timeout\n");
 		goto out;
@@ -698,8 +680,8 @@ mt7531_ind_c22_phy_write(struct mt7530_priv *priv, int port, int regnum,
 
 	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
 
-	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, reg,
-				 !(reg & MT7531_PHY_ACS_ST), 20, 100000);
+	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, reg,
+				       !(reg & MT7531_PHY_ACS_ST), 20, 100000);
 	if (ret < 0) {
 		dev_err(priv->dev, "poll timeout\n");
 		goto out;
-- 
2.53.0



