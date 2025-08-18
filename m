Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480E6286D5E;
	Mon, 18 Aug 2025 13:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522026; cv=none; b=ld33LQdIZepXVxaL6AMOHbY8ZERSq5wcbQ4WGzxezSkf621sn6jWnVkBUXtyzCras5vT6sH32rVX5SlbFt2+vDpZSuHkuuYU07sUPUCkrhHIzGU4JmKdGLXXZgydTamXQD859JeA+B0b6hxW+WnKb2EvbqwuHF2IZXJhbEVHO7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522026; c=relaxed/simple;
	bh=DfwGwnaDa/2TB66R/w5P/evGP/KzLxcAH9LJjTRZvEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2sfO0OJfNSB3Cj6mu+DeNb6KHxdU3F1xvXuBgwg1C5X6J69AH9i/SMDqIxasAftdDWGRMuDPhODm0T87t0EqI00szTg2LrkrsTpnzJiHjqOURr1X5BwUsLX+fYDvLyXHAhlAe6h+0BGzur3vynRM46nS5nSYZVrKJSSGc/hQDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AT6sUAvw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AT6sUAvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1AE9C4CEEB;
	Mon, 18 Aug 2025 13:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522026;
	bh=DfwGwnaDa/2TB66R/w5P/evGP/KzLxcAH9LJjTRZvEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AT6sUAvw1D9WQed8AqJYtDZKi6xjAOCc4A5emrd7Z3VAnG9GeGE8w/Rf42q11/oEJ
	 4pV8QwN+JRcMvH4T0TuYhFK7YBqxvg7IFAbfH2Yl2cqgP483VYWnyJ60r0Os4rx8bf
	 keyRSqUFrVzc6kXKqIARz4YOFt14/AjHZ+h0j5VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 193/444] net: phy: micrel: Add ksz9131_resume()
Date: Mon, 18 Aug 2025 14:43:39 +0200
Message-ID: <20250818124456.105479832@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 88a3c18f82ae..92e9eb4146d9 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -5394,6 +5394,14 @@ static int lan8841_suspend(struct phy_device *phydev)
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
@@ -5639,7 +5647,7 @@ static struct phy_driver ksphy_driver[] = {
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



