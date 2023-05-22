Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466CF171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9269C433D2;
	Mon, 22 May 2023 19:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784235;
	bh=IdVt9EID+sh18zsIXhi5nhq/d3Y/idBOj8szCQu65bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WLBYa2u30U956ZEvF7OB7R9yvFzligzEGsGpmlxa5GsYJNAYk7pnC7Edn+CiP9/ij
	 pALbUglgEG0ACflcDc6lT3M4+ophiNMwOdy21soJeEJkrhSQ91blinBfDkiikZeKqS
	 EDy7pWP1GUy27yQtp0iCeJ8kLC3M8rC87Cc8BtSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 015/364] net: phy: bcm7xx: Correct read from expansion register
Date: Mon, 22 May 2023 20:05:20 +0100
Message-Id: <20230522190413.207934465@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 582dbb2cc1a0a7427840f5b1e3c65608e511b061 ]

Since the driver works in the "legacy" addressing mode, we need to write
to the expansion register (0x17) with bits 11:8 set to 0xf to properly
select the expansion register passed as argument.

Fixes: f68d08c437f9 ("net: phy: bcm7xxx: Add EPHY entry for 72165")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230508231749.1681169-1-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/bcm-phy-lib.h | 5 +++++
 drivers/net/phy/bcm7xxx.c     | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/bcm-phy-lib.h b/drivers/net/phy/bcm-phy-lib.h
index 9902fb1820997..729db441797a0 100644
--- a/drivers/net/phy/bcm-phy-lib.h
+++ b/drivers/net/phy/bcm-phy-lib.h
@@ -40,6 +40,11 @@ static inline int bcm_phy_write_exp_sel(struct phy_device *phydev,
 	return bcm_phy_write_exp(phydev, reg | MII_BCM54XX_EXP_SEL_ER, val);
 }
 
+static inline int bcm_phy_read_exp_sel(struct phy_device *phydev, u16 reg)
+{
+	return bcm_phy_read_exp(phydev, reg | MII_BCM54XX_EXP_SEL_ER);
+}
+
 int bcm54xx_auxctl_write(struct phy_device *phydev, u16 regnum, u16 val);
 int bcm54xx_auxctl_read(struct phy_device *phydev, u16 regnum);
 
diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index 75593e7d1118f..6cebf3aaa621f 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -487,7 +487,7 @@ static int bcm7xxx_16nm_ephy_afe_config(struct phy_device *phydev)
 	bcm_phy_write_misc(phydev, 0x0038, 0x0002, 0xede0);
 
 	/* Read CORE_EXPA9 */
-	tmp = bcm_phy_read_exp(phydev, 0x00a9);
+	tmp = bcm_phy_read_exp_sel(phydev, 0x00a9);
 	/* CORE_EXPA9[6:1] is rcalcode[5:0] */
 	rcalcode = (tmp & 0x7e) / 2;
 	/* Correct RCAL code + 1 is -1% rprogr, LP: +16 */
-- 
2.39.2



