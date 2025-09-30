Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7EE27B328;
	Tue, 30 Sep 2025 15:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245512; cv=none; b=D5T7Jh/mGYj+VPtHFeZJLB5y5dEtvAb2GgryRCFAz0R1z/OXAUfQvH4+Agaegf2hwHEd1x8YCORqTAgdw0YuXvOq9r4xRgmq/1eUdoclTq5BgfF0OWyaVKwMCeu+Yt8OzNytVS4EKN65Y/yrlwTXyEacKoNm/6Sdl5AALDJghUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245512; c=relaxed/simple;
	bh=vxXn96wwGc1v+LlzLpceuOGhHOy/XVBeInR0Z1kkvTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UX//VGRLEfX/UaVw2/WCNa0SPKe+YROgq1WmsVdDiaurJAo/6bWpjAXlsiuWR3MJfiYn3xk2o3f7AcOBTW9wR+zVpf27hE1Vo3iqV83yFDv9UH8MJo04iStjaa8WBCh46Nq5Rb8xszoH2ErUwxoLzBwrzHwNtbBjlwRY8OalSYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TSA8tQoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSA8tQoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5D1C4CEF0;
	Tue, 30 Sep 2025 15:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245511;
	bh=vxXn96wwGc1v+LlzLpceuOGhHOy/XVBeInR0Z1kkvTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSA8tQoKTao4FKWDglc0f8Ac/mOJiRHueKq178YEXGhTIF4Fwe8N6l1zAGnRQW7wP
	 voITMYGeAk7ibj/tDaXGbyFihHJZnY6erJW/vgNRyR77qSqWyaP8fsV67jyfRqe8Ag
	 vMmOn3qW4oqQsD4Eu9rGfdf9Jg/MSUbDQr/3KeVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Schiller <ms@dev.tdt.de>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 40/73] net: dsa: lantiq_gswip: do also enable or disable cpu port
Date: Tue, 30 Sep 2025 16:47:44 +0200
Message-ID: <20250930143822.259007980@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 05ecaa007ab18..ee80446802af4 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -688,13 +688,18 @@ static int gswip_port_enable(struct dsa_switch *ds, int port,
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
@@ -707,16 +712,6 @@ static int gswip_port_enable(struct dsa_switch *ds, int port,
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
 
@@ -724,9 +719,6 @@ static void gswip_port_disable(struct dsa_switch *ds, int port)
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



