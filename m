Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DD551EE10;
	Wed, 30 Sep 2026 18:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793193; cv=none; b=jHJWG99/UgiDXnpFoXYHie5TWbowTlYlCoFPAXk/6wFh95Ez4LZHOrgb87Kxit+ZQhNOOJyTsj9y7ZAjoBhy+RxiKERX0QzIUb8vev6FryGsM40D82pbTCV1sRLbVHr6FQIMrnQgCcSAqU5FbbhMJ7ba8z1B8o0ikrMEtZg6GVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793193; c=relaxed/simple;
	bh=5F/hsVH2VOYSL2tm0Pon63zp2zifwH+W0ACde6xSZHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dY7Kws1dJbM+0zUrX7ZC0wUW/aVzWC4JdJoDuM/jchCV8KqAtypjAyjUQE4sNT+WW3ZfJzH6Ms7FeOMCGfo+kGRzfuv1qDGAHBMN8wC8LnzOzkpx+De9eg3rjz78KmD16u5Thd6lAQ0QJMOsoo1f1bOiGNet9sfbzNx5lS/3jZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAsh2tFJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAsh2tFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDECC1F000FF;
	Wed, 30 Sep 2026 18:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793192;
	bh=GAZ/3bLRr4yCak28QJ9r3GMxaOm8Ihziken+O513ZZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XAsh2tFJzCdwDbwDE/lunSnqtKxoVrbFU9Vi8+c8PVwvRRit4a0m6cHFV8W1VnNY1
	 ZzYsrATVhHQRAQD3TKe+67tHN+f9EjFSaYGvNbXEBKtgZ9GVAwZ9j6a/cb9p+q4H/A
	 VCc/4zudjU7CPKR0yPfS+8JwVmSPnu8aTj4dCsu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 166/395] net: bcmgenet: do not skip WoL power up on GENET V1
Date: Wed, 30 Sep 2026 17:27:08 +0200
Message-ID: <20260930152344.249482400@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
index 5050712166aa9..96308c85899f7 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1758,13 +1758,12 @@ static int bcmgenet_power_up(struct bcmgenet_priv *priv,
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
@@ -1788,8 +1787,12 @@ static int bcmgenet_power_up(struct bcmgenet_priv *priv,
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



