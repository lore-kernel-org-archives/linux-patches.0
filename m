Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB746311D;
	Tue, 14 May 2024 11:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685836; cv=none; b=AQfjxrPiEtxvUJ0spA2US1rIdY9GeU4BIyEvOpcwWcfwAFAmwDHsVhMhiRFW14GUZypkvVqqz+4Mk/qv2UfN8S818I4TWnf3D7PjsDArRMjvwmDfCCl8JAx5caVbalN1u0EI5K29aEM3vPdbpZuPJvtFFIZr//LKmyctniJtapo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685836; c=relaxed/simple;
	bh=7mZgd8438yw1sV3PrAKUP2A3GAgsG8m0zWW5JIcBfMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1B1L+xC+ICFj36LH1siigEcq2uhRSh/QdIvAogLwEcwFclI5owf1+CsV8xOHuN+tX55ekwkuKjeAk7FQ23a5dSFei6APpNxieW+7X6yeBGC8TOD8c7uiO2ofz5l5zsPcONQtkVgSbd7CoEP3vLbwVlXuvxmwJLGEyBSZbLceI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j06qQ4wc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j06qQ4wc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622C8C2BD10;
	Tue, 14 May 2024 11:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685836;
	bh=7mZgd8438yw1sV3PrAKUP2A3GAgsG8m0zWW5JIcBfMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j06qQ4wcaxozTytmSjFsSAqSG4LUWbzUP3Gl6kwr4bMYmtuFfOwe0WLTjmdT6+xOX
	 KNhx4smSi5ylZsxcXv3qvSB4ogJ3pCoPfbA4WiWNWBqypwl6bCGxuWxNHrhfvQS285
	 oEPPx62IPYW4c9nQg9Qmy8Q9syHytY6Qi9pphJEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 256/301] net: bcmgenet: synchronize EXT_RGMII_OOB_CTRL access
Date: Tue, 14 May 2024 12:18:47 +0200
Message-ID: <20240514101041.922871377@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Berger <opendmb@gmail.com>

commit d85cf67a339685beae1d0aee27b7f61da95455be upstream.

The EXT_RGMII_OOB_CTRL register can be written from different
contexts. It is predominantly written from the adjust_link
handler which is synchronized by the phydev->lock, but can
also be written from a different context when configuring the
mii in bcmgenet_mii_config().

The chances of contention are quite low, but it is conceivable
that adjust_link could occur during resume when WoL is enabled
so use the phydev->lock synchronizer in bcmgenet_mii_config()
to be sure.

Fixes: afe3f907d20f ("net: bcmgenet: power on MII block for all MII modes")
Cc: stable@vger.kernel.org
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -2,7 +2,7 @@
 /*
  * Broadcom GENET MDIO routines
  *
- * Copyright (c) 2014-2017 Broadcom
+ * Copyright (c) 2014-2024 Broadcom
  */
 
 #include <linux/acpi.h>
@@ -274,6 +274,7 @@ int bcmgenet_mii_config(struct net_devic
 	 * block for the interface to work, unconditionally clear the
 	 * Out-of-band disable since we do not need it.
 	 */
+	mutex_lock(&phydev->lock);
 	reg = bcmgenet_ext_readl(priv, EXT_RGMII_OOB_CTRL);
 	reg &= ~OOB_DISABLE;
 	if (priv->ext_phy) {
@@ -285,6 +286,7 @@ int bcmgenet_mii_config(struct net_devic
 			reg |= RGMII_MODE_EN;
 	}
 	bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
+	mutex_unlock(&phydev->lock);
 
 	if (init)
 		dev_info(kdev, "configuring instance for %s\n", phy_name);


