Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE23281369;
	Fri,  7 Aug 2026 15:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116010; cv=none; b=TU9xmKVADOhsRzewQcfk/K5rfr5QLqkjX1fYXZIy0aqy8KUOaWzVoI41sTWgAc9QukukC+o/guKLYIkHoMt6OPbQInqwE9vKW2lrizwXK4hAC3iFcCGqTYiYfmZOu1YK4fXOKoHSO3DWhF/oopD7pmpaEHJBbEPsVGmRTw/V57s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116010; c=relaxed/simple;
	bh=uQXh6Oc1JOcxHyI+34gcIzJOXbgTydTD3BIJvIZcgY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJNBbzXPN/om7sU9kzVGV2HDjqMuI3QPbG/yp6UeSEiIAslbce+lZmQma7s2sNv0D0sOpxWbH1rnn84GxYVzLZT/AmkRToEpTZj8EFjJ3E8bUCIgm+urk6JAzeCQxkawMlZ4APF26ql+rFiIjUrwTRRaxfORYWJpfpA0lbU4ZEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVWuBupX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVWuBupX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3426B1F000E9;
	Fri,  7 Aug 2026 15:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116008;
	bh=M0CRXOPrIvyDLVp5K8/xgUG8i9rDo8wj61WwZwxqNl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kVWuBupXpnU6iwKdOGi8KwxG7MNkdqa0A1zS3J43ke/SzC9pCYyxiiKnJQgO1mZul
	 7GbS12rMeIlbtQ+/IM6IdlCe0zGffbsP6kXLngPi6FwzU/hMy+iZP7BDgludOGCZgz
	 FcvM2WpluvmT2kz3nFLjEQf7KuZGyl5Ep/FaRUlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/261] net: dsa: mt7530: error out on failed reads in MT7531 PHY polling
Date: Fri,  7 Aug 2026 16:37:18 +0200
Message-ID: <20260807143417.131901342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8d889bc5f3d1b..aaa5640ad0f1c 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -233,12 +233,6 @@ mt7530_write(struct mt7530_priv *priv, u32 reg, u32 val)
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
@@ -628,16 +622,13 @@ static int
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
@@ -647,8 +638,8 @@ mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
 	      MT7531_MDIO_DEV_ADDR(devad) | regnum;
 	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
 
-	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
-				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
+	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
+				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
 	if (ret < 0) {
 		dev_err(priv->dev, "poll timeout\n");
 		goto out;
@@ -658,8 +649,8 @@ mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
 	      MT7531_MDIO_DEV_ADDR(devad);
 	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
 
-	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
-				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
+	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
+				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
 	if (ret < 0) {
 		dev_err(priv->dev, "poll timeout\n");
 		goto out;
@@ -676,16 +667,13 @@ static int
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
@@ -695,8 +683,8 @@ mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
 	      MT7531_MDIO_DEV_ADDR(devad) | regnum;
 	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
 
-	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
-				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
+	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
+				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
 	if (ret < 0) {
 		dev_err(priv->dev, "poll timeout\n");
 		goto out;
@@ -706,8 +694,8 @@ mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
 	      MT7531_MDIO_DEV_ADDR(devad) | data;
 	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
 
-	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
-				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
+	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
+				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
 	if (ret < 0) {
 		dev_err(priv->dev, "poll timeout\n");
 		goto out;
@@ -722,16 +710,13 @@ mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
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
@@ -742,8 +727,8 @@ mt7531_ind_c22_phy_read(struct mt7530_priv *priv, int port, int regnum)
 
 	mt7530_mii_write(priv, MT7531_PHY_IAC, val | MT7531_PHY_ACS_ST);
 
-	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
-				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
+	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
+				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
 	if (ret < 0) {
 		dev_err(priv->dev, "poll timeout\n");
 		goto out;
@@ -760,16 +745,13 @@ static int
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
@@ -780,8 +762,8 @@ mt7531_ind_c22_phy_write(struct mt7530_priv *priv, int port, int regnum,
 
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



