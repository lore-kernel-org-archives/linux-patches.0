Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC1B313E3D;
	Wed,  3 Dec 2025 15:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776879; cv=none; b=sexFXiO5ud+n1EqDb8PeINkqi9mIPcKS2dIue58k1gYrWxy+e9xJ+9kSG2VdQ8AnWUTl2eTWCoqs/jqY7+34uGVn1M1PrZAzzylhjuUxPUGmmxDHtGmiE4jkdmvB1fGL+fvgXCSLphyT95Z1c1dDRvvYDL4lPDiaukqbXN6Y14s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776879; c=relaxed/simple;
	bh=h++pVAUajJgEg5RyUaJxI4Sw1oS9UZIdybDyL53KmAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqohXWjSBf3zNHijp7/72ZPVJxfsNaecdZQ0Sp6EuNg8cMLZPkay+Y16ds+cipETeqojcgVvPHpZagf5CEzGXREQJfeKibu9WLegwSMmKE07LZo/gqx2wbaN7K6ocjxoCg2faS7Aaiu2uOCDDrxDVsh4oluqNNEk+h5yEDKEnnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UF6HDTfI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UF6HDTfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7360DC4CEF5;
	Wed,  3 Dec 2025 15:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776878;
	bh=h++pVAUajJgEg5RyUaJxI4Sw1oS9UZIdybDyL53KmAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UF6HDTfIsor5O4CTmueMpYfyxmQI0Rfy2w3XOmMnGmt4mrpv6nMjQRyQwKt3nUMnG
	 K9W7twVaJmFnLiF48evFl7DiI1exB87OK+AV97X8Y8tFW9epxGOCfNUHOHzBa6tqx0
	 MeB5zTBtfIiSD3sGn8AQc10r/Rk804QFqRdA/qFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Daniel Golle <daniel@makrotopia.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 015/146] net: phy: mxl-gpy: fix link properties on USXGMII and internal PHYs
Date: Wed,  3 Dec 2025 16:26:33 +0100
Message-ID: <20251203152347.026777763@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 081156ce13f8fa4e97b5148dc54d8c0ddf02117b ]

gpy_update_interface() returns early in case the PHY is internal or
connected via USXGMII. In this case the gigabit master/slave property
as well as MDI/MDI-X status also won't be read which seems wrong.
Always read those properties by moving the logic to retrieve them to
gpy_read_status().

Fixes: fd8825cd8c6fc ("net: phy: mxl-gpy: Add PHY Auto/MDI/MDI-X set driver for GPY211 chips")
Fixes: 311abcdddc00a ("net: phy: add support to get Master-Slave configuration")
Suggested-by: "Russell King (Oracle)" <linux@armlinux.org.uk>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://patch.msgid.link/71fccf3f56742116eb18cc070d2a9810479ea7f9.1763650701.git.daniel@makrotopia.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mxl-gpy.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 221b315203d06..2a873f791733a 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -578,13 +578,7 @@ static int gpy_update_interface(struct phy_device *phydev)
 		break;
 	}
 
-	if (phydev->speed == SPEED_2500 || phydev->speed == SPEED_1000) {
-		ret = genphy_read_master_slave(phydev);
-		if (ret < 0)
-			return ret;
-	}
-
-	return gpy_update_mdix(phydev);
+	return 0;
 }
 
 static int gpy_read_status(struct phy_device *phydev)
@@ -639,6 +633,16 @@ static int gpy_read_status(struct phy_device *phydev)
 		ret = gpy_update_interface(phydev);
 		if (ret < 0)
 			return ret;
+
+		if (phydev->speed == SPEED_2500 || phydev->speed == SPEED_1000) {
+			ret = genphy_read_master_slave(phydev);
+			if (ret < 0)
+				return ret;
+		}
+
+		ret = gpy_update_mdix(phydev);
+		if (ret < 0)
+			return ret;
 	}
 
 	return 0;
-- 
2.51.0



