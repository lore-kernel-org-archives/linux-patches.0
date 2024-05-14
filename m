Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A695712C554;
	Tue, 14 May 2024 11:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686656; cv=none; b=cqUt6n60Od/ZqxEwov6s9lsYXmMsMEMT9yIWhfXJm+KtBl3msTjCXTe4k8uRERxGH/tbyUo4ZY0P1/ht1uCINAm4ywcv6uKd/M4E240PV4PPtU2Tz8GEmkvyIHqh1D2xmlcaeb2PHuA+hrUM8Z+evaE5vm3zgwR//aSg/0BadN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686656; c=relaxed/simple;
	bh=1DT2pRd5jKYqGYZBIcBAkH3/et59EGFXLCdficKLm00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnrlVmPj1EdTqD/UNoBhMJfQOUa39GaVbUWUI0PDtwctgs2rPIZbUD7ePnpf1YKddUo3Z02LQ2Z5wuURbI8fiu3m1r+IkYIw/EC7DVfp+iSYkOzaqEeHkMJfYlAq7n/V9nGNQVboVDXPxVwwBOvkWwXukO2U+Tra/2IBOcKsfiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qrdR2Svf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrdR2Svf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA2AC2BD10;
	Tue, 14 May 2024 11:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686656;
	bh=1DT2pRd5jKYqGYZBIcBAkH3/et59EGFXLCdficKLm00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qrdR2SvfsGbPmgJTArE2NmBeSd6ajQ3I74F1gETduMuIs+Jba+himdlhrX3xKmuhQ
	 +P3TuECE7L1gIQDrcj8VMrLPhTODXI3MtxEzfRxns11M4TVsyWAed8AVPG2YNIhtuJ
	 HXEQCg4RZilXu0lmYZfqk9dBWbSVGpXneiFq8Ku0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 212/236] net: bcmgenet: synchronize EXT_RGMII_OOB_CTRL access
Date: Tue, 14 May 2024 12:19:34 +0200
Message-ID: <20240514101028.408258022@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -71,10 +71,12 @@ static void bcmgenet_mac_config(struct n
 	 * transmit -- 25MHz(100Mbps) or 125MHz(1Gbps).
 	 * Receive clock is provided by the PHY.
 	 */
+	mutex_lock(&phydev->lock);
 	reg = bcmgenet_ext_readl(priv, EXT_RGMII_OOB_CTRL);
 	reg &= ~OOB_DISABLE;
 	reg |= RGMII_LINK;
 	bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
+	mutex_unlock(&phydev->lock);
 
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	reg &= ~((CMD_SPEED_MASK << CMD_SPEED_SHIFT) |


