Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FCBE571;
	Mon, 14 Oct 2024 14:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916996; cv=none; b=o/jFXkyxUOnf3ZZ8vSczwZPjkl8a2LJPpLwD+RI184rEKy0wT/9VqNwEvVuljKmYbMaVZmVK2DoOn05dCSffS+bVakaN9ZOvjLciFgi9dvnRJDps/+DJ9GB8C77RKaqBkIINW70CbpslyfwNkJwDawKGxUWjMXmP0v0xrCS8mTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916996; c=relaxed/simple;
	bh=Gwu2uwQGBgufY1GONbCTr6lWuaW+IM+4S5sSfgMfOFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKGNTpZbB5tKtR4VJF4ORkB5b+GkxD0R1GY/o6Qq4UcwawOEqzMm0xWR1qLohXYAna4sruQENHA0dIImQhFGqbCj72kA57Yu7d52oFkLZgEbQmKdu5GVA4YGt9miLJobA0d3X6dXyPxc8aRToiSA+NLnt2xGZ43twlnLHKBfdlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qy/SZztj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qy/SZztj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48828C4CEC3;
	Mon, 14 Oct 2024 14:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916996;
	bh=Gwu2uwQGBgufY1GONbCTr6lWuaW+IM+4S5sSfgMfOFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qy/SZztj701TVPrsWe7WfRWlRpg286QlIybxcwxwrsGbEymyIyIWNbLc37fgORWvt
	 uri3ELmNg3rLDBNJeaNo8DRi/ulgtpbFAQ5htNz/QvsTXHHA1cAlUKkb9hMl/+M0cU
	 3L8etnlkflj1ZLMkju0W/RaXsgfOZGUiOdz3q0no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 123/213] net: phy: bcm84881: Fix some error handling paths
Date: Mon, 14 Oct 2024 16:20:29 +0200
Message-ID: <20241014141047.769531078@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 9234a2549cb6ac038bec36cc7c084218e9575513 ]

If phy_read_mmd() fails, the error code stored in 'bmsr' should be returned
instead of 'val' which is likely to be 0.

Fixes: 75f4d8d10e01 ("net: phy: add Broadcom BCM84881 PHY driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/3e1755b0c40340d00e089d6adae5bca2f8c79e53.1727982168.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/bcm84881.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/bcm84881.c b/drivers/net/phy/bcm84881.c
index 9717a1626f3fa..37a64a37b2ae3 100644
--- a/drivers/net/phy/bcm84881.c
+++ b/drivers/net/phy/bcm84881.c
@@ -120,7 +120,7 @@ static int bcm84881_aneg_done(struct phy_device *phydev)
 
 	bmsr = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_C22 + MII_BMSR);
 	if (bmsr < 0)
-		return val;
+		return bmsr;
 
 	return !!(val & MDIO_AN_STAT1_COMPLETE) &&
 	       !!(bmsr & BMSR_ANEGCOMPLETE);
@@ -146,7 +146,7 @@ static int bcm84881_read_status(struct phy_device *phydev)
 
 	bmsr = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_C22 + MII_BMSR);
 	if (bmsr < 0)
-		return val;
+		return bmsr;
 
 	phydev->autoneg_complete = !!(val & MDIO_AN_STAT1_COMPLETE) &&
 				   !!(bmsr & BMSR_ANEGCOMPLETE);
-- 
2.43.0



