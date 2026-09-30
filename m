Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187C851B179;
	Wed, 30 Sep 2026 17:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789296; cv=none; b=q+sI/AeskdXDRkNFmhIbdAy3QjEN2bJgWkMY5apF1S91QSaMqaPPX1lqqDlLjO6J34yINoDx2FUw2sNmbZeYvuvG4xL2w6yGLsA1eWYl1nlO4jxwrSfAH6uXk5lB0u+kVDyoO6ALcA7Q73rNFUySYI3d9HK9raFXNlsYAlz3sgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789296; c=relaxed/simple;
	bh=Gik76wGx77zl1LUrF4iSTFwMWz0rrZT/4QWAeCK3aH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kP0HmNOjFc/rs4xlMe55A68xX3jahnTBcdP6W+7GZyQBPXwFggljOD50ocz4WZAsjrAF0OggnjzSYPLQoR2fIGCYfjWrMcVKxi9t9N4qylgqNrTQozRBO++3+gU9s8UPqQhTUtF6vsGlOLs1J7t0NImo0EObMKyj79bYoNrAkaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=butYcx76; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="butYcx76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F821F000FF;
	Wed, 30 Sep 2026 17:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789295;
	bh=XOrPgq08VbQOvrlZHzws4hguo3UixVlXEafIZPyci2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=butYcx76hvUikNEskWxgo097jS8MLxmpK96vevkxvtwqHEsoE9gO9KZ1kQJOy8z9W
	 swXAxEkNFd2UogT2+YRCCJd2RQnDpwzlzw+w21KjTeo0W5Do743n3sqlq6lF8WdZk6
	 uROfccDxhuxFPhht0kRcuVIQnHtbBhSVcPsoLiYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 427/877] net: bcmgenet: do not skip WoL power up on GENET V1
Date: Wed, 30 Sep 2026 17:22:18 +0200
Message-ID: <20260930152423.903538995@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit cbbc1aee7776c7fa1d89e6cb963a23e58c495dca ]

bcmgenet_power_up() had an early check for bcmgenet_has_ext(priv) before
dispatching by power mode. GENET V1 does not have the EXT block (unlike
GENET V2+), which causes bcmgenet_power_up() to immediately return 0.

As a consequence, when waking up from GENET_POWER_WOL_MAGIC on GENET V1,
bcmgenet_wol_power_up_cfg() is never invoked to disable the WoL clock,
clear wake event masks, and restore normal PHY and MAC operations.

Move the bcmgenet_has_ext() checks to the GENET_POWER_PASSIVE and
GENET_POWER_CABLE_SENSE cases where the EXT registers are actually
accessed, allowing GENET_POWER_WOL_MAGIC cleanup to execute on all
hardware versions.

Fixes: c3ae64ae0c08 ("net: bcmgenet: handle GENET_POWER_WOL_MAGIC")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260921220021.281418-4-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index fc1d4cef3ad81..dad5adfadb76d 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1699,13 +1699,12 @@ static int bcmgenet_power_up(struct bcmgenet_priv *priv,
 	int ret = 0;
 	u32 reg;
 
-	if (!bcmgenet_has_ext(priv))
-		return ret;
-
-	reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
-
 	switch (mode) {
 	case GENET_POWER_PASSIVE:
+		if (!bcmgenet_has_ext(priv))
+			break;
+
+		reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
 		reg &= ~(EXT_PWR_DOWN_DLL | EXT_PWR_DOWN_BIAS |
 			 EXT_ENERGY_DET_MASK);
 		if (GENET_IS_V5(priv) && !bcmgenet_has_ephy_16nm(priv)) {
@@ -1729,8 +1728,12 @@ static int bcmgenet_power_up(struct bcmgenet_priv *priv,
 		break;
 
 	case GENET_POWER_CABLE_SENSE:
+		if (!bcmgenet_has_ext(priv))
+			break;
+
 		/* enable APD */
 		if (!GENET_IS_V5(priv)) {
+			reg = bcmgenet_ext_readl(priv, EXT_EXT_PWR_MGMT);
 			reg |= EXT_PWR_DN_EN_LD;
 			bcmgenet_ext_writel(priv, reg, EXT_EXT_PWR_MGMT);
 		}
-- 
2.53.0



