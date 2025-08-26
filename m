Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296921E51E1;
	Tue, 26 Aug 2025 12:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213014; cv=none; b=pLOGHBihXEWW5mXUFBlrSt6WzaRGSqsmxuD7XYIegtjRZxIScYH5WKfgkwn6ZdiqMJTIxdJul1QelrLyaDbkhBuPL6dScw/dVBV6i5h09d5REtXE/3DEHm8izdEjeaFuqF9ArPTEAVArFvee2WdCG2TqLyFlH36AexQlyJYRmBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213014; c=relaxed/simple;
	bh=7Xs6hza05cEWjxsHnGRj6A8rXhuXWW83+Z9zeRrqEmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzOf1aPlyj0Oj0vnAiSzRHOZR5z3fJUSkc77NwWFt4tq3QJLy2ygM1/loHfmwwx/Zjsly5wllvm6TUskdsGDanhrjmX/jjVsgXImGR7uOQNeZY2d1xcig4ndCn4ERShs1tnsCqiZAUk2W2AOjhP0OHjdXpld8aF1ih74xaC0COA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ml3S06ei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ml3S06ei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE74C113CF;
	Tue, 26 Aug 2025 12:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213014;
	bh=7Xs6hza05cEWjxsHnGRj6A8rXhuXWW83+Z9zeRrqEmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ml3S06ei63P9Zmd08X2gQCXTARGNuOncNRRTVVLMowirkYel9+I+mt4sw2JDNNSD4
	 kChrcyw1Bor3eDhUmtbypfWbHlVqzq4jV3hSBjkwkTSCz4gDMj/6/VGJVYGl4SBlgD
	 8Xn7DoU+2T+7zSsw1x0oznou5MhQtpWuISCrgBek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/587] net: phy: micrel: Add ksz9131_resume()
Date: Tue, 26 Aug 2025 13:05:07 +0200
Message-ID: <20250826110956.968003369@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d4017c442201..6a114883ed8c 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -4722,6 +4722,14 @@ static int lan8841_suspend(struct phy_device *phydev)
 	return genphy_suspend(phydev);
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
@@ -4968,7 +4976,7 @@ static struct phy_driver ksphy_driver[] = {
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



