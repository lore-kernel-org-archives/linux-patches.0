Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2861E3A7582;
	Wed, 20 May 2026 16:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295012; cv=none; b=V+GTWfVdxvA5EHYLtejM3wgwBcizIpG+HnjcmvWKIWHfMH2Ciio54w5kXWMBcW9Lj4m2DjE0BNvSaB83vdnqbxyu8TMCY8fnW+kexQRbQ4a0mZ8U6jkFUdnnZo6W96APfab2UoaJ0JFjipzy2eeHvtnt4LudI8N9bkweO0RaGj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295012; c=relaxed/simple;
	bh=xECFKTtiM0smnOVSfMG+wulRDr8Y0RBJrZ9CGy0TU4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7lxxgfTAajzrKji7//WKTSWyOtk2yy1dGFnM2ERBJiEIBrt0vgI5fdD+39YDllkJAGxaJR43ZAe74GyoDI5GZ3FWnZ0Xax4BgZTiClaDVFcZdTZforzilY+tHSYROh45eQ8klfn/ehyp5QMbeV7DCr63tMSeHrM1AeA0BJpE5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNCNDvo7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNCNDvo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C1B1F000E9;
	Wed, 20 May 2026 16:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295011;
	bh=FnuN92HzXPOKM6bfnSMXN1M3dWKLvkle5iwgxrC5ERw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VNCNDvo75BiMCcRcm/boPZNvmaoZ5hDYpVdwwMnLaWEPun6aJlrWhWA/PAhYF1zWL
	 0YkflRzSAGb18YWQvmeyQd8fG6ZzdSFQyaqcg83KoyBmYRY0yo+433MGckxsGv3N7X
	 RyObHCYFlb83SpYwicKxYs06OSLvUupoMFCCJoPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0216/1146] net: phy: qcom: at803x: Use the correct bit to disable extended next page
Date: Wed, 20 May 2026 18:07:46 +0200
Message-ID: <20260520162153.147004388@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit e7a62edd34b1b4bc5f979988efc2f81c075733fd ]

As noted in the blamed commit, the AR8035 and other PHYs from this
family advertise the Extended Next Page support by default, which may be
understood by some partners as this PHY being multi-gig capable.

The fix is to disable XNP advertising, which is done by setting bit 12
of the Auto-Negotiation Advertisement Register (MII_ADVERTISE).

The blamed commit incorrectly uses MDIO_AN_CTRL1_XNP, which is bit 13 as per
802.3 : 45.2.7.1 AN control register (Register 7.0)

BIT 12 in MII_ADVERTISE is wrapped by ADVERTISE_RESV, used by some
drivers such as the aquantia one. 802.3 Clause 28 defines bit 12 as
Extended Next Page ability, at least in recent versions of the standard.

Let's add a define for it and use it in the at803x driver.

Fixes: 3c51fa5d2afe ("net: phy: ar803x: disable extended next page bit")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260410171021.1277138-1-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/qcom/at803x.c | 2 +-
 include/uapi/linux/mii.h      | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/qcom/at803x.c b/drivers/net/phy/qcom/at803x.c
index 2995b08bac963..63726cf98cd42 100644
--- a/drivers/net/phy/qcom/at803x.c
+++ b/drivers/net/phy/qcom/at803x.c
@@ -524,7 +524,7 @@ static int at803x_config_init(struct phy_device *phydev)
 	 * behaviour but we still need to accommodate it. XNP is only needed
 	 * for 10Gbps support, so disable XNP.
 	 */
-	return phy_modify(phydev, MII_ADVERTISE, MDIO_AN_CTRL1_XNP, 0);
+	return phy_modify(phydev, MII_ADVERTISE, ADVERTISE_XNP, 0);
 }
 
 static void at803x_link_change_notify(struct phy_device *phydev)
diff --git a/include/uapi/linux/mii.h b/include/uapi/linux/mii.h
index 39f7c44baf535..61d6edad4b94a 100644
--- a/include/uapi/linux/mii.h
+++ b/include/uapi/linux/mii.h
@@ -82,7 +82,8 @@
 #define ADVERTISE_100BASE4	0x0200	/* Try for 100mbps 4k packets  */
 #define ADVERTISE_PAUSE_CAP	0x0400	/* Try for pause               */
 #define ADVERTISE_PAUSE_ASYM	0x0800	/* Try for asymetric pause     */
-#define ADVERTISE_RESV		0x1000	/* Unused...                   */
+#define ADVERTISE_XNP		0x1000  /* Extended Next Page */
+#define ADVERTISE_RESV		ADVERTISE_XNP /* Used to be reserved */
 #define ADVERTISE_RFAULT	0x2000	/* Say we can detect faults    */
 #define ADVERTISE_LPACK		0x4000	/* Ack link partners response  */
 #define ADVERTISE_NPAGE		0x8000	/* Next page bit               */
-- 
2.53.0



