Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787F933CEA2;
	Wed, 20 May 2026 18:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302065; cv=none; b=jUQDjdM9e7xLnSePr47pUxRlp2IgYbWad+Hu/nsEKIVTXNBzINmuYGFv0UZRz+CK3mNN60uf3hsJrdk2J0uSvaTWpL2sSAC/xUU/8IHzFrCbpcjGLOQEmvoNNRzrSDHUhRRBLHI9vuA02kDPZiRa5n4mW18rzidB2pVfaJqY94M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302065; c=relaxed/simple;
	bh=qWDndJ3JWCQ3NNxpdSML5boZVcxGxpPgPVCjQ/guFCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqEzOLGLh3VSlG8J4Q65jZjfgs35WtAQnm1peloYOgwkhwgdVSkmge2MyAIZVuDo+ePYKXj7gxtGJjM+0JtNr42Msymplu9fG6cnhzfQDcD0j9MuxcJNZWFcuRJguStEvyB47CA17zblywSUR+Ce6GQETVtwVDFxcGEsqGnYFrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2dwi9lvr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dwi9lvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF6F1F000E9;
	Wed, 20 May 2026 18:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302064;
	bh=uqK248Qia1+7joSGd2edTRD6RGAi60ctcHp/k+55gkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2dwi9lvrT8tRZrD0M7VmYodWKmjwdhQi+78eKHvjQUmcyzbzv+G2WMMf28rKMU8td
	 5j2+bhpm2heP95Anaurgy1wc+7yRACoRUm3pxSCZgyjoBF/G1O+EhKvdMIZCR7Kg1N
	 aruAYbVidPJIa95LRwrkt+GMdmJ5BYhOpsUOyxXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/508] net: phy: qcom: at803x: Use the correct bit to disable extended next page
Date: Wed, 20 May 2026 18:18:27 +0200
Message-ID: <20260520162100.429797706@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ef203b0807e58..0b01b6ff0a4b5 100644
--- a/drivers/net/phy/qcom/at803x.c
+++ b/drivers/net/phy/qcom/at803x.c
@@ -1064,7 +1064,7 @@ static int at803x_config_init(struct phy_device *phydev)
 	 * behaviour but we still need to accommodate it. XNP is only needed
 	 * for 10Gbps support, so disable XNP.
 	 */
-	return phy_modify(phydev, MII_ADVERTISE, MDIO_AN_CTRL1_XNP, 0);
+	return phy_modify(phydev, MII_ADVERTISE, ADVERTISE_XNP, 0);
 }
 
 static int at803x_ack_interrupt(struct phy_device *phydev)
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



