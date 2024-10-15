Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FA820721A;
	Tue, 15 Oct 2024 13:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998542; cv=none; b=tG+1942LdX39Y17cfwrpkP0k+vUwsnIiFy5cCY/7Sw+lY/kGhoeVcQshy3qc8NL/Tce7+TeCaDkR7FofJ64yHkg/lcXdpK8mvbncc+S+8e9L9ri1x44dhE1ejk8HhNhb2C/VlPh968Npkk1CllzIva8ILSbF7iEClJdFHcMRgPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998542; c=relaxed/simple;
	bh=6J4kBnTSQdPjBqMw/n/HvjNOuZbhPNhOVknqjfuwsFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3UKDiTzKIC3wTBFjkdlclWH0g8ooTBBq5PGVWlQuqhBiOptx+cjhXtJ2lRlBvpw0fIHB8dG+sz3OJ2XM+RTyg/M4N2wCEaimIN+oqhpJNVLpywxGtRcv8jDSDKL1i45nBg6/B4IdEuBc9rvzKqz9jkVHTpYOJCWTWxIMsI1UMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kbPMiVEU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kbPMiVEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8725AC4CEC6;
	Tue, 15 Oct 2024 13:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998542;
	bh=6J4kBnTSQdPjBqMw/n/HvjNOuZbhPNhOVknqjfuwsFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbPMiVEUVaqXc7TMLuR9AR+HZu7dfEgXOo1CdsheM7jbfJi4B4pa62WgyCArPDmEK
	 SSeWqzpp7AS+KudCNst4qpx+f+30ir/f3+dj1h7se8h1BwgBWkEDwERl3xtDsT8stW
	 lnhQvJFBe1OcWCfUUx9lt+w0vjITkQSQj8o3D+1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo van Lil <inguin@gmx.de>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 476/518] net: phy: dp83869: fix memory corruption when enabling fiber
Date: Tue, 15 Oct 2024 14:46:20 +0200
Message-ID: <20241015123935.376833400@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ingo van Lil <inguin@gmx.de>

[ Upstream commit a842e443ca8184f2dc82ab307b43a8b38defd6a5 ]

When configuring the fiber port, the DP83869 PHY driver incorrectly
calls linkmode_set_bit() with a bit mask (1 << 10) rather than a bit
number (10). This corrupts some other memory location -- in case of
arm64 the priv pointer in the same structure.

Since the advertising flags are updated from supported at the end of the
function the incorrect line isn't needed at all and can be removed.

Fixes: a29de52ba2a1 ("net: dp83869: Add ability to advertise Fiber connection")
Signed-off-by: Ingo van Lil <inguin@gmx.de>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20241002161807.440378-1-inguin@gmx.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83869.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index 65b69ff35e403..01b593e0bb4a1 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -610,7 +610,6 @@ static int dp83869_configure_fiber(struct phy_device *phydev,
 		     phydev->supported);
 
 	linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT, phydev->supported);
-	linkmode_set_bit(ADVERTISED_FIBRE, phydev->advertising);
 
 	if (dp83869->mode == DP83869_RGMII_1000_BASE) {
 		linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
-- 
2.43.0



