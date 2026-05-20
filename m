Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599633F871A;
	Wed, 20 May 2026 18:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300273; cv=none; b=nYPpWCSGvRTGBRz6vR1BP/NzYYbnNHks1CBopTdECYWi525jrKl7ysaKCIO1YrwKNkf5jphvf+kfVUG/0thEfNkgB/dCyLgI43Fxz2+uDo9qB/2sTAv631kBt4ij5XbE6fDgpnSiJDnUNmzyMqJ2tfOxsY36QKqhc3BToczltWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300273; c=relaxed/simple;
	bh=Hkj0q8E/a4+/Se4udAau4vcnTHd6BmfH/XS3b/UN2S8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIfz6FTfMSoYRhPzQGvnKdrNxlc7taYtp2CTJ8uVKirrBuKmbbIsDaQ7G6PLHXna5LonsdX0idauZ2suR4ht7HoRM8Z7QdaTliEhTaacMZ87ueg6jX91cLgXbdyvdg0EhCs/k2sS85Ew8RCfFQmZt3eXoiA8+QoA8tzfl8jyEZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yueuXDER; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yueuXDER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4691F00893;
	Wed, 20 May 2026 18:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300272;
	bh=y0sekA3wpkOepNbfFlPNZL5ItWDJoSD49BIzOT5rYH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yueuXDERVIJLock2NIp9DZ7gs+9359wcHLOSfvwvUArIDAYEWAmHKuAYIFRN7B5R3
	 k7SEQsMPniz8E8L6ZZLP4XF0oh6Qk0jOJIquwxxjHn8A/PPgkPRmapJPHvHWtnAIRH
	 kd8UKHq1mopPUlAxd1vs52Sb+jQQgLUxgFFK3L14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/666] net: phy: qcom: at803x: Use the correct bit to disable extended next page
Date: Wed, 20 May 2026 18:15:22 +0200
Message-ID: <20260520162113.626604634@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ac909ad8a87b4..11b7540b69582 100644
--- a/drivers/net/phy/qcom/at803x.c
+++ b/drivers/net/phy/qcom/at803x.c
@@ -474,7 +474,7 @@ static int at803x_config_init(struct phy_device *phydev)
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



