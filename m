Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0995C335BC5;
	Mon, 18 Aug 2025 13:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525382; cv=none; b=fpQcVz2oUpP+80ingq1XRrJadyDEpk7SvHkZFG5XKiKoTgAJ17zGzbBUyPlV4FRvS/vT2l+RnQQIALFoGiFr0GEhqg9BDnzQg7yNFI0dTjWz3VNhN20MUWFrkyFhZQr+DJatPJY1rT7+p4ZPkl4eSot7s1tsc0/zyzo3/B9a+o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525382; c=relaxed/simple;
	bh=t+iBC2CCDkdzFuBbe+jbopojYV6Noj0ETj3YbQXcFpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPY/vbmZNsxiGpXEYdy4pSt8N50ggyjwYrzcsnsRYpuhUh7h8DWSj0cgwNeyc7Gp+kMVb5ufQ6AKt8zW3Cmq12ryK/T7/FK1lYb45PC1KXoHdFpHT7GJVUS/BR5Di8MF6czQ9nrYqEv+o1+49P9S638jcy4thP32vPyVXLRXpnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zCnN1O6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zCnN1O6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D54DC4CEEB;
	Mon, 18 Aug 2025 13:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525381;
	bh=t+iBC2CCDkdzFuBbe+jbopojYV6Noj0ETj3YbQXcFpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zCnN1O6peXD2CWpL260xwbVDNNh4X2GUQxXwViH+y79+FIGd2MAOTIG6QygYN6QvI
	 nOBYAOw70i3BwAWydL0QlfvAFJV09jWPFBVI7KlXxsFrZTPTu2yVtKywtiasJnSMwh
	 5Jz6+qXrdlW2DDUs+lSyBmBGvODB0k9kDAP79P1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 246/570] net: phy: micrel: Add ksz9131_resume()
Date: Mon, 18 Aug 2025 14:43:53 +0200
Message-ID: <20250818124515.296637501@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit f25a7eaa897f21396e99f90809af82ca553c9d14 ]

The Renesas RZ/G3E SMARC EVK uses KSZ9131RNXC phy. On deep power state,
PHY loses the power and on wakeup the rgmii delays are not reconfigured
causing it to fail.

Replace the callback kszphy_resume()->ksz9131_resume() for reconfiguring
the rgmii_delay when it exits from PM suspend state.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250711054029.48536-1-biju.das.jz@bp.renesas.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 50c6a4e8cfa1..52c677811616 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -5405,6 +5405,14 @@ static int lan8841_suspend(struct phy_device *phydev)
 	return kszphy_generic_suspend(phydev);
 }
 
+static int ksz9131_resume(struct phy_device *phydev)
+{
+	if (phydev->suspended && phy_interface_is_rgmii(phydev))
+		ksz9131_config_rgmii_delay(phydev);
+
+	return kszphy_resume(phydev);
+}
+
 static struct phy_driver ksphy_driver[] = {
 {
 	.phy_id		= PHY_ID_KS8737,
@@ -5651,7 +5659,7 @@ static struct phy_driver ksphy_driver[] = {
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
 	.suspend	= kszphy_suspend,
-	.resume		= kszphy_resume,
+	.resume		= ksz9131_resume,
 	.cable_test_start	= ksz9x31_cable_test_start,
 	.cable_test_get_status	= ksz9x31_cable_test_get_status,
 	.get_features	= ksz9477_get_features,
-- 
2.39.5



