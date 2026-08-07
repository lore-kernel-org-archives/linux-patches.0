Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D712E422531;
	Fri,  7 Aug 2026 14:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114044; cv=none; b=Y3x4+7cf1ezzOatVtQYoaTP57qiSfr/PswrtkQpR7Ga2TWErE8xTptxsf/4k5O8M6OB89nGsZGLqkHJTkeLfiSvkwApKunzoTxh8SJscmaoaiwqFLHR+FP+2p+v6DrbX31YrMPc2jG12fG5oyJi0sZ+Vb8AI/P6kagwJ1kiDbv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114044; c=relaxed/simple;
	bh=RvMgiN2k0ImdX5BnP75MhYiJZu8/RsPXxw7j76EvU7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvW1hdjhH/Uz/ipA0Ns5ueycUC3m0+BAsufHRbpWt5ZYFutFW7ewg32OFGCQf4DDoEPjMhE2QgMsd+A6eGNGZ7123b5QmOWzNm25Q/MedlvgPG51lS/5hPVy2y/aqoGioAZE2o7XLeq11Wd6wWtAjNaWuwZAKKLBHv19WhCUx48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vjjYqZjd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vjjYqZjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD911F000E9;
	Fri,  7 Aug 2026 14:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114040;
	bh=FKt8pXfVZpGMCDkSdjNBHrMFKIVi8WmVIgw1zCxzHsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vjjYqZjdkuJTOGcnQ+7aTmg+5WN/f+gzm+0QhpbQAByzviZ+JlIPttRfl8VPC46ky
	 V2CmiRwI/BAUHEfv21rT7++i8AWg4Ct3hw7QP6H+NaFEQKPPawZUpLBE/Ba9erB5Le
	 z44YCQ/eFtBBOZK2TBpKC8zh8Gw3fbToUUXKH/zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/337] net: dsa: mt7530: error out on failed reads in MT7531 PHY polling
Date: Fri,  7 Aug 2026 16:35:24 +0200
Message-ID: <20260807143421.153780869@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
index 21437ce57b64f..b13e905833c3f 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -219,12 +219,6 @@ mt7530_write(struct mt7530_priv *priv, u32 reg, u32 val)
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
@@ -577,16 +571,13 @@ static int
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
@@ -596,8 +587,8 @@ mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
 	      MT7531_MDIO_DEV_ADDR(devad) | regnum;
 	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
 
-	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
-				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
+	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
+				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
 	if (ret < 0) {
 		dev_err(priv->dev, "poll timeout\n");
 		goto out;
@@ -607,8 +598,8 @@ mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
 	      MT7531_MDIO_DEV_ADDR(devad);
 	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
 
-	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
-				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
+	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
+				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
 	if (ret < 0) {
 		dev_err(priv->dev, "poll timeout\n");
 		goto out;
@@ -625,16 +616,13 @@ static int
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
@@ -644,8 +632,8 @@ mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
 	      MT7531_MDIO_DEV_ADDR(devad) | regnum;
 	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
 
-	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
-				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
+	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
+				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
 	if (ret < 0) {
 		dev_err(priv->dev, "poll timeout\n");
 		goto out;
@@ -655,8 +643,8 @@ mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
 	      MT7531_MDIO_DEV_ADDR(devad) | data;
 	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
 
-	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
-				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
+	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
+				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
 	if (ret < 0) {
 		dev_err(priv->dev, "poll timeout\n");
 		goto out;
@@ -671,16 +659,13 @@ mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
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
@@ -691,8 +676,8 @@ mt7531_ind_c22_phy_read(struct mt7530_priv *priv, int port, int regnum)
 
 	mt7530_mii_write(priv, MT7531_PHY_IAC, val | MT7531_PHY_ACS_ST);
 
-	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
-				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
+	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
+				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
 	if (ret < 0) {
 		dev_err(priv->dev, "poll timeout\n");
 		goto out;
@@ -709,16 +694,13 @@ static int
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
@@ -729,8 +711,8 @@ mt7531_ind_c22_phy_write(struct mt7530_priv *priv, int port, int regnum,
 
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



