Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA26514779;
	Wed, 30 Sep 2026 16:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786553; cv=none; b=SaXggP2fYL/mtb/t6T8zZgdZESfLjT66etsdCleRqJQhJWCwu/qaBOF4HdVokKg72d6poh73VuZRLMw9Sh0xJoPwDf2QTekqaxNAUGt1q/eZpPUJNfebj3mVVN38SeDNhrFoi/0QDfFAVyxzHaSzPXvY94ERywXWjncWlBxmuUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786553; c=relaxed/simple;
	bh=YyzB1khzYqJNcHMRJg/zi2JO2VWQ9bpOOx74E7d7meo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsPuQVYkiydFH1B/nKHOyrSCiX1BpTOx53S7IXfpLbaqJMsa3saeq/1B7jQ7W8lgtIWXL11218EJ3g+NOv3xlWAf1YWNeoAILN8d0oiJjXLI/t8vdntQfUdHIj8IKt7sXX1Ey6Sw7W+4pOWDhBT+SAMoqoLWFCaKnRC/Z5jcYds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJ5Yhtef; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJ5Yhtef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E781F000FF;
	Wed, 30 Sep 2026 16:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786551;
	bh=jF7DQLjPrGf5u5sg4V5jMWTHX9GtrKqloyNrJSsBExg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJ5Yhtef1/cLasFYgjRjaONlCv8nMEHSly9VKEB0TFcJnr9za+i2QQiEVdi9RWkMf
	 87L0CYpP04a9SAf+ZhZJMXP/1WiQIFFmn4HYjG60nmrFFoLFJ1MNidrD8uMPnWO8Ej
	 b5/HwpVAAxUxXwQwQ3hIVA3tBLqUsMWavmcWwc+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 902/982] net: bcmgenet: do not skip WoL power up on GENET V1
Date: Wed, 30 Sep 2026 17:27:18 +0200
Message-ID: <20260930152436.115562626@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ea171dd2f2a06..68acfac5491dc 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1703,13 +1703,12 @@ static int bcmgenet_power_up(struct bcmgenet_priv *priv,
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
@@ -1733,8 +1732,12 @@ static int bcmgenet_power_up(struct bcmgenet_priv *priv,
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



