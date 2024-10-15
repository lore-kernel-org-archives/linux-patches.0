Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65EA01EBA1A;
	Tue, 15 Oct 2024 12:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994172; cv=none; b=Dd9tG7XJKJefVv6eYWZQQU0jaCnqsG6FqqeKHAH68rcAx3y3MEmCCd4sMXGeiiMMExp82KmJSWc50WISx4tMKhf5YsoKfb5mxdoVW2zOHyWMoS6xrQFqKUXMBdlbKRLPiQcGXIZXJeUQonmPrFCteFa+NlDtv0mtWBD5J0QzI+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994172; c=relaxed/simple;
	bh=ouRmZHrS2cDkp3V6huP3sjkFsUxMbOH0cy1Vh4UOXJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtNp+5qmHZN/iOahSfUewGxwZVx5QatQQQRwpCxJcgIL1xtDQnWK2rBad5+HfnQwl3rvj6N1o+VZvOKWXN95HeD7sju/D689C+y14gn//5uOmiDRMkH3cEN1InxNLS94N7/KvrFSjcvgqLY8LGuFlHBB4A/PbvZ68ARaYKJ2Aus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBJC/Z9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBJC/Z9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF08FC4CEC6;
	Tue, 15 Oct 2024 12:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994172;
	bh=ouRmZHrS2cDkp3V6huP3sjkFsUxMbOH0cy1Vh4UOXJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBJC/Z9zo9lgUTgNdu8GZalQCu58lsoecESl9Mg3Sq3oG5xT4I4ow0xdvmdjDs81A
	 Ah9JJk+NyuKmY5kccA/o8J8K/oA3+I5iCtPKNpse1DhnfF8a2soNqfs5e0FCLaMae7
	 aEhaPiEGCfX6sweluDwlSTkGTU6KJrgESwUPWXhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo van Lil <inguin@gmx.de>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 628/691] net: phy: dp83869: fix memory corruption when enabling fiber
Date: Tue, 15 Oct 2024 13:29:36 +0200
Message-ID: <20241015112505.256354260@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cdf4e22fe85d0..a76fd5f11aca0 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -644,7 +644,6 @@ static int dp83869_configure_fiber(struct phy_device *phydev,
 		     phydev->supported);
 
 	linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT, phydev->supported);
-	linkmode_set_bit(ADVERTISED_FIBRE, phydev->advertising);
 
 	if (dp83869->mode == DP83869_RGMII_1000_BASE) {
 		linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
-- 
2.43.0



