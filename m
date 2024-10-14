Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F16C481B3;
	Mon, 14 Oct 2024 15:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919895; cv=none; b=kHXL6+Wh4vBambGqKdDIp4wZ8behgMdsUeAMthEF9kiVAhjmUL4QUnswp6mikYmb9JAVUTggVWSlvf5jfa5JKaSStXBFAYIbyGIuLNSAmOgGFNDM7cbJ9r7lCBlsZc7MJsnm5oZJW2vdpgD5iQICrQgnpZBXUy68C4rfuQ1rFKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919895; c=relaxed/simple;
	bh=/VPr/eur8rsIqvNl7084wmt4fqLRM7hfmNOw1g5Z0LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3T046+2a4j1JnbMwK9YJsQMH2E+BASbt6EgOv4De1Z8A9l8rMtGI3icePGubuJnGWlgDXtJVuo/pJCygBn6dlE8/vf+XY3k/LO+mjlIG1ChjOqZMrPRtyxLrZXIm9LFtJxygNkvJYoetyh3MVfkOe5XJQvjXl5ZHd+q7vWalEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1y4oSTc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1y4oSTc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6083C4CEC3;
	Mon, 14 Oct 2024 15:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919895;
	bh=/VPr/eur8rsIqvNl7084wmt4fqLRM7hfmNOw1g5Z0LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1y4oSTc/HTStdhW0cUrFqxUS2JUZjhd0MhbEJyheiM0I9X6N6Hp9JmK8VxToFH1Hc
	 BrVR68L2+08126HWqrT64gzYR1J8Yc5ImWLks1LlKLTyigJFg4xHfS/hRm2VrChtkR
	 5aRpxzYLATVgE/Tir+eHNYCVURbS2OTqD1+gqslo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo van Lil <inguin@gmx.de>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 731/798] net: phy: dp83869: fix memory corruption when enabling fiber
Date: Mon, 14 Oct 2024 16:21:25 +0200
Message-ID: <20241014141246.788941492@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9ab5eff502b71..b924f98b23973 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -645,7 +645,6 @@ static int dp83869_configure_fiber(struct phy_device *phydev,
 		     phydev->supported);
 
 	linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT, phydev->supported);
-	linkmode_set_bit(ADVERTISED_FIBRE, phydev->advertising);
 
 	if (dp83869->mode == DP83869_RGMII_1000_BASE) {
 		linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
-- 
2.43.0



