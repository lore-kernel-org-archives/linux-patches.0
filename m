Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9F0466B77;
	Tue, 16 Jun 2026 16:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626505; cv=none; b=scgFVcOYM/OoZqzO05tR5LRawsc1r4a2axv7d2jFfE3xlfdurC2zjNBlTZ+7EiyCS4cY+xjW6QLfwfggZca68PFzwsbLj7cQid4/iLx8KguM9O/Kvds7RtoEWcNJj3MhvHC0VjnF2tOVI/1VXGc15kLACnzDeoz6dEzN5EF59IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626505; c=relaxed/simple;
	bh=ukjWm/nKZ710i3LG63NU81bvSy+RbcYtikEdGxrKG7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sOJuaIPuGKw7Lq4b8xOv6Rxlw3mMfMc61zma71kXRIs9QI6cJlRFbOypmzelOYqxFXYU33oI/HMU6vzyq2VpW5rUa++h1xIugxIpwjHBfOLpAJISxYJi8pAfIhtlhqmaVZG//ZCNeSAt4DhQYUujN2iITB5h8dfZ06qT0PTlFxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWP3Gf+P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWP3Gf+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8208E1F000E9;
	Tue, 16 Jun 2026 16:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626504;
	bh=9MWXL/lCT2QdEQVJxJOSkfdi4H8t+rkcZ3eVCj7cusQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tWP3Gf+Per2AIYrQ4MBsouOB8pVyeWMJEvDkSapNFLKFM+tju4a4q0WnWvQ8YS3Yh
	 Qe2AaLXZCyG8NvOV/z+8UA/fech4+7gZKrI3KtZpwMviNTRYiSqTOoyyFXq1++bxDf
	 7Plixjg0g3HBLpiCpKVkhyLYPa9b+JTGUhwcuA9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robert.marko@sartura.hr>,
	Jakub Kicinski <kuba@kernel.org>,
	=?UTF-8?q?Jo=C3=ABl=20Esponde?= <joel.esponde@leroy-agon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/261] net: phy: micrel: fix LAN8814 QSGMII soft reset
Date: Tue, 16 Jun 2026 20:27:25 +0530
Message-ID: <20260616145045.369235953@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Marko <robert.marko@sartura.hr>

[ Upstream commit e027c218c482c6a0ae1948129ccda3b0a2033368 ]

LAN8814 QSGMII soft reset was moved into the probe function to avoid
triggering it for each of 4 PHY-s in the package.

However, that broke QSGMII link between the MAC and PHY on most LAN8814
PHY-s, specificaly for us on the Microchip LAN969x switch.
Reading the QSGMII status registers it was visible that lanes were only
partially synced.

It looks like the reset timing is crucial, so lets move the reset back
into the .config_init function but guard it with phy_package_init_once()
to avoid it being triggered on each of 4 PHY-s in the package.
Change the probe function to use phy_package_probe_once() for coma and PtP
setup.

Fixes: 347bf638d39f ("net: phy: micrel: lan8814 fix reset of the QSGMII interface")
Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Link: https://patch.msgid.link/20260428134138.1741253-1-robert.marko@sartura.hr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Joël Esponde <joel.esponde@leroy-agon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index f0c068075322f9..2dca6e8a5fce5c 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -4093,6 +4093,13 @@ static int lan8814_config_init(struct phy_device *phydev)
 {
 	struct kszphy_priv *lan8814 = phydev->priv;
 
+	if (phy_package_init_once(phydev))
+		/* Reset the PHY */
+		lanphy_modify_page_reg(phydev, LAN8814_PAGE_COMMON_REGS,
+				       LAN8814_QSGMII_SOFT_RESET,
+				       LAN8814_QSGMII_SOFT_RESET_BIT,
+				       LAN8814_QSGMII_SOFT_RESET_BIT);
+
 	/* Disable ANEG with QSGMII PCS Host side */
 	lanphy_modify_page_reg(phydev, LAN8814_PAGE_PORT_REGS,
 			       LAN8814_QSGMII_PCS1G_ANEG_CONFIG,
@@ -4177,13 +4184,7 @@ static int lan8814_probe(struct phy_device *phydev)
 	devm_phy_package_join(&phydev->mdio.dev, phydev,
 			      addr, sizeof(struct lan8814_shared_priv));
 
-	if (phy_package_init_once(phydev)) {
-		/* Reset the PHY */
-		lanphy_modify_page_reg(phydev, LAN8814_PAGE_COMMON_REGS,
-				       LAN8814_QSGMII_SOFT_RESET,
-				       LAN8814_QSGMII_SOFT_RESET_BIT,
-				       LAN8814_QSGMII_SOFT_RESET_BIT);
-
+	if (phy_package_probe_once(phydev)) {
 		err = lan8814_release_coma_mode(phydev);
 		if (err)
 			return err;
-- 
2.53.0



