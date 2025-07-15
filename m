Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADFF2E7631;
	Tue, 15 Jul 2025 13:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587071; cv=none; b=hzQmYu3AajKN6JFlPo5q4zIYskcxoss5ZPjR+lBnffqaXD60hIWH7OrVFw+PMNRjNGvCWX+YOsAvCiumW5GqqbhRfPV1cFOD5vmaA+Mjvg+zpfBdJD5kER9zpJDMVfxgnCxCi1gur0ufJ3MKGHT6hDId+FJFzyZJUexSiIs+6r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587071; c=relaxed/simple;
	bh=1h/oNmcjHKW5bvBOvKNpWHwF2DexvIib41Eb59QBGu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GlQR1IS/I644WIb6PDR513ZzTllj6/s4JzJCVLsta/o0LZIFolz4v62VOle8u3DGeyHOr1o1TYaxYurYCTGkPMcfuLFH1w05eePPZtz82r/YG0wTJ86XJNCJ1kBz3VvWOaBadq27uPyPd7h3q6UfwWNXLS8KWDaO/QINWIR9Ipg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpOBzyaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpOBzyaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A725EC4CEE3;
	Tue, 15 Jul 2025 13:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587071;
	bh=1h/oNmcjHKW5bvBOvKNpWHwF2DexvIib41Eb59QBGu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xpOBzyaW8iBtKtEsfzpJUd77DGs+0JgCEefk6rYM0Vo3Ltsnzs8mmR6GuaXeDq2Y9
	 lJlvX5AbXGCf/TOsAciCvR1j6k0ukfUGGnDAKKL/GPKU9WOI8jrzS5gFeYgcyq3L5Y
	 Ck0t25p9R8s1LLWiOt6PrDE9J2H9boUutUDYVrqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 154/192] net: phy: microchip: Use genphy_soft_reset() to purge stale LPA bits
Date: Tue, 15 Jul 2025 15:14:09 +0200
Message-ID: <20250715130821.094989679@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit b4517c363e0e005c7f81ae3be199eec68e87f122 ]

Enable .soft_reset for the LAN88xx PHY driver by assigning
genphy_soft_reset() to ensure that the phylib core performs a proper
soft reset during reconfiguration.

Previously, the driver left .soft_reset unimplemented, so calls to
phy_init_hw() (e.g., from lan88xx_link_change_notify()) did not fully
reset the PHY. As a result, stale contents in the Link Partner Ability
(LPA) register could persist, causing the PHY to incorrectly report
that the link partner advertised autonegotiation even when it did not.

Using genphy_soft_reset() guarantees a clean reset of the PHY and
corrects the false autoneg reporting in these scenarios.

Fixes: ccb989e4d1ef ("net: phy: microchip: Reset LAN88xx PHY to ensure clean link state on LAN7800/7850")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250709130753.3994461-2-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/microchip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
index 93de88c1c8fd5..5d1ca285d95ba 100644
--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -486,6 +486,7 @@ static struct phy_driver microchip_phy_driver[] = {
 	.config_init	= lan88xx_config_init,
 	.config_aneg	= lan88xx_config_aneg,
 	.link_change_notify = lan88xx_link_change_notify,
+	.soft_reset	= genphy_soft_reset,
 
 	/* Interrupt handling is broken, do not define related
 	 * functions to force polling.
-- 
2.39.5



