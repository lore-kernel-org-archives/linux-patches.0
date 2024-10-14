Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1F91AAC4;
	Mon, 14 Oct 2024 14:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916165; cv=none; b=nwephu0niwIX1YQM6oF8kVWeTYQ4zrbqJCkLG2JWHQOQqIXQHZHw/jmRKpriUs1819P6M0EsxeJwlf1EYUE/Kh3xRagnCllScS4/ewCX/zJmh2tlvS01bRpZrcwlHS4eZdlwcGgNOXY408ddanO/HfSAS+Qhe4idK6h1RX/cHTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916165; c=relaxed/simple;
	bh=wPOQQmjNN2/W82QGlS7H0LFfwu3FA3jyodKsUkbxqJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaRusahtmROgxnHNUYu4+XPmGg/Z8wjgx223Zne/YdHhliSrKzDDn1IDkPUD0CWQSywBj53QJdeSsA8NIB+q6wdcyKakbgr12Lga5OeQsfGE5rvDTfMIwHR0VxuU3M0ZDimPajfMeKgG5/eXVKwEHxd8pOAu+tnuhfZc4R+WBVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EIpo9TiP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EIpo9TiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40D1C4CEC3;
	Mon, 14 Oct 2024 14:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916165;
	bh=wPOQQmjNN2/W82QGlS7H0LFfwu3FA3jyodKsUkbxqJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EIpo9TiPrM5r2NUIPclVskSJBVPnbP9v0/leEXu5F72lTdTOW+dU0U3ICFgy5GEWr
	 XUONe3A2kRYFsAGKOKaH7luKNnVWo5yedUc2ILI7s7xbp+Hgu5E9L/gtUax6PRb/xZ
	 nDc4HldIADLO/1mhjN6++D6tSrWpPJSToW+V089M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 104/214] net: phy: bcm84881: Fix some error handling paths
Date: Mon, 14 Oct 2024 16:19:27 +0200
Message-ID: <20241014141049.051092159@linuxfoundation.org>
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
index f1d47c2640585..97da3aee49422 100644
--- a/drivers/net/phy/bcm84881.c
+++ b/drivers/net/phy/bcm84881.c
@@ -132,7 +132,7 @@ static int bcm84881_aneg_done(struct phy_device *phydev)
 
 	bmsr = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_C22 + MII_BMSR);
 	if (bmsr < 0)
-		return val;
+		return bmsr;
 
 	return !!(val & MDIO_AN_STAT1_COMPLETE) &&
 	       !!(bmsr & BMSR_ANEGCOMPLETE);
@@ -158,7 +158,7 @@ static int bcm84881_read_status(struct phy_device *phydev)
 
 	bmsr = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_C22 + MII_BMSR);
 	if (bmsr < 0)
-		return val;
+		return bmsr;
 
 	phydev->autoneg_complete = !!(val & MDIO_AN_STAT1_COMPLETE) &&
 				   !!(bmsr & BMSR_ANEGCOMPLETE);
-- 
2.43.0



