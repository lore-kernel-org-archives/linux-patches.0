Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4AA1AA797;
	Mon, 14 Oct 2024 14:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917080; cv=none; b=X7XyLZ+JqWH2OnR+8hdZUKH6If1MfEyrPO+BYUg18M80Ll+JEZwyLT/w6QSuqjv9d2hThlFq7o7A+SY1wN3vAsGmDcoKXnP2OiaGPgYnhDki+cDgjVeSyUDlnDaObpi8+924ELLYd392w4N1TbAKSoFik1NLg337HKu0eAbhKIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917080; c=relaxed/simple;
	bh=NUs613s+r75cySqV+xro4Zr72ui7ih4X2lUzUqrRdWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJv7KFzAGWNe4WlCxFkG1+zlV89sJdWGbPU3yMfcQQaPWtvsed3b6N7+AGN0J6aaM3QzYvSifAMd3hqSswNJzWfBC3QCy7TRLTWx68paxfJS0ecSErG/NOYGkVfz2JUzdnToUZiagMwviotAnZGggqjCmjgKq7Xi0bCvPX7THcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gwAlxFe6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gwAlxFe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FF1C4CEC3;
	Mon, 14 Oct 2024 14:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917080;
	bh=NUs613s+r75cySqV+xro4Zr72ui7ih4X2lUzUqrRdWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gwAlxFe64SvU5Fd5pblGUR/8s+Ho6lAjBkn0Sk7rxMGImispuvQZq7MmOtM3MPjlK
	 JsXhW3AxEHkcxKhZUDgoWp6jaXFylz4g/nlbDxMBLi/0TwE+hL1w7XrYSj4lfsfvig
	 W/A7JBGU525kwXpY1yG3zIXxg3pbp1OkGea25vh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo van Lil <inguin@gmx.de>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/213] net: phy: dp83869: fix memory corruption when enabling fiber
Date: Mon, 14 Oct 2024 16:20:20 +0200
Message-ID: <20241014141047.419674739@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d7aaefb5226b6..5f056d7db83ee 100644
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



