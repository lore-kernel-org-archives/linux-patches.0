Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AEA1C862F;
	Tue, 30 Sep 2025 15:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245783; cv=none; b=RUMYb+uNmKRA6+CLTsDIRJCiBLhjrPoNw3Zyr2ASGfFTtYL2oehS0HCHk1l9Lr9yrD4rz2xqgdX4lxqpT10+XnPuwxu+8/aTIPBMxku+/6NfOiUkXh3fI8q+Yt22tg/Rq9jQy+Ie1Pl6Ix2ZMvds0UQC+LMymwbkkcXZgnwk3do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245783; c=relaxed/simple;
	bh=N2BiZcVEp7Uxwl4cQWZN9fIKtMnG8q6g/dJSbblWgVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdqBiEEl7lvd7UIKY7itlg46fEVRZjzLSLuw9ygdjiAd4+dxS3kxBpkInNkj8BakzqTNclG5oKpAduHsfJdGDoU6pTkTSDvEZlEz5hVXoeLKfQzNuGbZ4lGbQxlmOfqf1vfDOeSzRLSgL4GXDaGiI707wu9MXaaPPXimlRx71Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+ZPqsLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+ZPqsLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA20C4CEF0;
	Tue, 30 Sep 2025 15:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245783;
	bh=N2BiZcVEp7Uxwl4cQWZN9fIKtMnG8q6g/dJSbblWgVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+ZPqsLh2Q6O1UUVWYIu8wUOR/6L95UbOr0Zgi0KO20MfQA6b7VdsWJVEcK57CwBk
	 bRCUPbGKHP1MkaSqDLePsm3b2wNbOvNziz+eSdFFEgKXGEqbqpUjxU1WU5dodp810k
	 VXRloZ5n+OkBlDhOFL0itBke+5X06Q7ugabNIJAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Schiller <ms@dev.tdt.de>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 48/91] net: dsa: lantiq_gswip: do also enable or disable cpu port
Date: Tue, 30 Sep 2025 16:47:47 +0200
Message-ID: <20250930143823.173520866@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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
index 3c76a1a14aee3..a2b10b28c11fa 100644
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



