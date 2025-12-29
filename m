Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57183330B1F;
	Mon, 29 Dec 2025 16:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025101; cv=none; b=KLrxDC/9EibGGE7hKhLcbQYIF9345RbjUeo6wXRYEX3RpNbba9lGOt5UXfhs/612WN4dWRFmiQLHujeAE8XaFa0i+P4U8gqU+d86j2hgAWr6n3eU4XJy3dhyxE3brjnXHChwHRJjMabJ7YLwD6seH2kvQ/MxuYYk+75OSAJwIas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025101; c=relaxed/simple;
	bh=OoIdBPRQVihQ9IiqHz2NIs4MYIRDfURFliezr1lYmOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2eMn9fDljDACXidhovROuswgvNnz/cfNxi/8mWf2B2UTL+uzwPYrW+ggGhfGciQGBRJZzYgFtiKJM0NcNmFLWsIOpUGJZo/rM/m9ZzSdDFgcSOvbCO5nlTTCtZUCpz/ocqnWv4ohpR8T1gGD6xiKxMs2y5XrBoWnC3859GORnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dytviOfB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dytviOfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1544C116C6;
	Mon, 29 Dec 2025 16:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025101;
	bh=OoIdBPRQVihQ9IiqHz2NIs4MYIRDfURFliezr1lYmOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dytviOfBXP1JANa/iHFPWCkBwhHTilthk1sD7QLHKHd/5e1d4EfGNeTmyIvzKgGEW
	 XBswEiCHoTBqQNq29nZ+l2Csa97C9IoU6zrS3XIynWgXR64D/PV6ocQZealqFbqpZY
	 zJucp0C8h4uGaWd6zWDHW+0q2f95+NJ+zetwCoIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 062/430] net: phy: realtek: create rtl8211f_config_phy_eee() helper
Date: Mon, 29 Dec 2025 17:07:44 +0100
Message-ID: <20251229160726.648921583@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 4465ae435ddc0162d5033a543658449d53d46d08 ]

To simplify the rtl8211f_config_init() control flow and get rid of
"early" returns for PHYs where the PHYCR2 register is absent, move the
entire logic sub-block that deals with disabling PHY-mode EEE to a
separate function. There, it is much more obvious what the early
"return 0" skips, and it becomes more difficult to accidentally skip
unintended stuff.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20251117234033.345679-7-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 4f0638b12451 ("net: phy: RTL8211FVD: Restore disabling of PHY-mode EEE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek/realtek_main.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/realtek/realtek_main.c b/drivers/net/phy/realtek/realtek_main.c
index 35f40bfdaf113..2c661346050f1 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -662,6 +662,17 @@ static int rtl8211f_config_aldps(struct phy_device *phydev)
 				mask, mask);
 }
 
+static int rtl8211f_config_phy_eee(struct phy_device *phydev)
+{
+	/* RTL8211FVD has no PHYCR2 register */
+	if (phydev->drv->phy_id == RTL_8211FVD_PHYID)
+		return 0;
+
+	/* Disable PHY-mode EEE so LPI is passed to the MAC */
+	return phy_modify_paged(phydev, RTL8211F_PHYCR_PAGE, RTL8211F_PHYCR2,
+				RTL8211F_PHYCR2_PHY_EEE_ENABLE, 0);
+}
+
 static int rtl8211f_config_init(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
@@ -685,17 +696,7 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 		return ret;
 	}
 
-	/* RTL8211FVD has no PHYCR2 register */
-	if (phydev->drv->phy_id == RTL_8211FVD_PHYID)
-		return 0;
-
-	/* Disable PHY-mode EEE so LPI is passed to the MAC */
-	ret = phy_modify_paged(phydev, RTL8211F_PHYCR_PAGE, RTL8211F_PHYCR2,
-			       RTL8211F_PHYCR2_PHY_EEE_ENABLE, 0);
-	if (ret)
-		return ret;
-
-	return 0;
+	return rtl8211f_config_phy_eee(phydev);
 }
 
 static int rtl821x_suspend(struct phy_device *phydev)
-- 
2.51.0



