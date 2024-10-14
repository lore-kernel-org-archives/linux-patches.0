Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDA91547F3;
	Mon, 14 Oct 2024 14:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916125; cv=none; b=EawFDAk6Si70aJrRX4CCPaxi93b9/Mieyk77Lw3LXrD64A0hOLu+N5X8a400JoMSXeASXpOzgWhIDFO5IrbsxVADf4fD+QAhbcHVEH1IoUaK5oX7PFIxbVKefpdo+VU0XNJ/5h1Ata2+TQHpJfCTPJMQOXJOOiFTdI7mPRxWE2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916125; c=relaxed/simple;
	bh=zHdVGyCcZr51KvBLRcfKTij+Mcd2NB+875SkeI0JWHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiM77rlKquKBYJtQySFn6RH25DZhBx00dSqRGHBHc5EYs2EQ5snF2V1yeKVImLgIZA0lq+09/4PwZW/roYxZAvQD8diqBSDjmJu7b+1myLmjyvv1VRxUPf0vkdZFG2IxCIQCs0AxKmjzlKtHB/TL9FUP8+f+1J97ka07JgQ+ANw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kuhwqVGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kuhwqVGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F618C4CEC3;
	Mon, 14 Oct 2024 14:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916124;
	bh=zHdVGyCcZr51KvBLRcfKTij+Mcd2NB+875SkeI0JWHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kuhwqVGUEjQH//29Gqknj6xTg/0NQ8ICzRdtnezOb3zd12lfoL1HSGGiQiMq1lQwM
	 vGpIMCieoCKzjox1FY4+tlgCiLKNk9Rd891TIAH6oGB2CGfDn+vqKfNaWN53CoprNE
	 gGO9bmBwHCiw3gu0hXY4ilTCkCLinD3vYbXY6s/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo van Lil <inguin@gmx.de>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 090/214] net: phy: dp83869: fix memory corruption when enabling fiber
Date: Mon, 14 Oct 2024 16:19:13 +0200
Message-ID: <20241014141048.506397175@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



