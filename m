Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096373074BB;
	Tue, 30 Sep 2025 15:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245315; cv=none; b=IBgcCIG3TrPiMeoQ+gCoeB+cyq2uAKgpPOvIUFuXH80mWAh1GwgRCvUm6ynTMVaKTrt3Bb0WdjhuMHBf/33a1vK+PYngnkrdnl9CLGLgeoVP4KtWWCEaUwbl7hA+gefwiev7+yGQNFyvDaK92j0oV7cJ3KBdXN3lZIc+FLg6gtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245315; c=relaxed/simple;
	bh=fSjBmLBDsP5tYyQ51/0sH/ORYDy1aZ6LBJikCuO08GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXL+HFOB5lUHkaJYIywZzPCzqiiBd3/d8gi8ZD+r7et+7MK1fvH2lzdYad7DX+tEq9PHup7/a8hkWjoVn7pLX+z47IRlmI+wM2PXlG1jErCb+t+2MbfyfI91cDGzNt/uH73oX1axCDIiqV5CuJeMs9y8zf0qHSjJwR9dHsVVVqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hfz0ti2c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hfz0ti2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F02EC4CEF0;
	Tue, 30 Sep 2025 15:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245312;
	bh=fSjBmLBDsP5tYyQ51/0sH/ORYDy1aZ6LBJikCuO08GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hfz0ti2cqwQii21C/8LE875wwBeLZRIeu/bGNsQBt24E1XvY2gOWTHKs2T/zoEeLJ
	 7XMzGvjQ4QHh7hMiF87CF8VN+j1i1jvCWMXBgqZWAAv0TlEHGjTYRDMvW2fXp+R/ec
	 VdSr67PrCSeAnIwcuXMRTWsjiKJXb8ML46ODu7nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Schiller <ms@dev.tdt.de>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/151] net: dsa: lantiq_gswip: do also enable or disable cpu port
Date: Tue, 30 Sep 2025 16:47:42 +0200
Message-ID: <20250930143832.858093804@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schiller <ms@dev.tdt.de>

[ Upstream commit 86b9ea6412af41914ef6549f85a849c3b987f4f3 ]

Before commit 74be4babe72f ("net: dsa: do not enable or disable non user
ports"), gswip_port_enable/disable() were also executed for the cpu port
in gswip_setup() which disabled the cpu port during initialization.

Let's restore this by removing the dsa_is_user_port checks. Also, let's
clean up the gswip_port_enable() function so that we only have to check
for the cpu port once. The operation reordering done here is safe.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20240611135434.3180973-7-ms@dev.tdt.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c0054b25e2f1 ("net: dsa: lantiq_gswip: move gswip_add_single_port_br() call to port_setup()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lantiq_gswip.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 2240a3d351225..f1ed7fff23e27 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -661,13 +661,18 @@ static int gswip_port_enable(struct dsa_switch *ds, int port,
 	struct gswip_priv *priv = ds->priv;
 	int err;
 
-	if (!dsa_is_user_port(ds, port))
-		return 0;
-
 	if (!dsa_is_cpu_port(ds, port)) {
+		u32 mdio_phy = 0;
+
 		err = gswip_add_single_port_br(priv, port, true);
 		if (err)
 			return err;
+
+		if (phydev)
+			mdio_phy = phydev->mdio.addr & GSWIP_MDIO_PHY_ADDR_MASK;
+
+		gswip_mdio_mask(priv, GSWIP_MDIO_PHY_ADDR_MASK, mdio_phy,
+				GSWIP_MDIO_PHYp(port));
 	}
 
 	/* RMON Counter Enable for port */
@@ -680,16 +685,6 @@ static int gswip_port_enable(struct dsa_switch *ds, int port,
 	gswip_switch_mask(priv, 0, GSWIP_SDMA_PCTRL_EN,
 			  GSWIP_SDMA_PCTRLp(port));
 
-	if (!dsa_is_cpu_port(ds, port)) {
-		u32 mdio_phy = 0;
-
-		if (phydev)
-			mdio_phy = phydev->mdio.addr & GSWIP_MDIO_PHY_ADDR_MASK;
-
-		gswip_mdio_mask(priv, GSWIP_MDIO_PHY_ADDR_MASK, mdio_phy,
-				GSWIP_MDIO_PHYp(port));
-	}
-
 	return 0;
 }
 
@@ -697,9 +692,6 @@ static void gswip_port_disable(struct dsa_switch *ds, int port)
 {
 	struct gswip_priv *priv = ds->priv;
 
-	if (!dsa_is_user_port(ds, port))
-		return;
-
 	gswip_switch_mask(priv, GSWIP_FDMA_PCTRL_EN, 0,
 			  GSWIP_FDMA_PCTRLp(port));
 	gswip_switch_mask(priv, GSWIP_SDMA_PCTRL_EN, 0,
-- 
2.51.0



