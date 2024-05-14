Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704A012880A;
	Tue, 14 May 2024 10:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684041; cv=none; b=qC9pG7BOpuL8xSiWoNhP01Wn4YunknDNeU/Qw7azzG41WItbJH4JotAEQQBXX/FmQQj2Hz+0LxpGZMELeLoQvw2SanRmgWcfrZGTae3gmPGONv76bdYH7mPLG2wisR8B5BxwhRxdamtJSKWcAg5JzKPx6GVT8lKkm5uS7RYHjPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684041; c=relaxed/simple;
	bh=4GYuSIIc/+c4nsxa8jCA/OaGlqlUONMZHkeb+uHdoY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oU4Z3hxxrEJu65WpaF3FQU+bXrIjmLUAvSUfhUwJjNwSUGQoALjfw8SzJa8hYKFvOiIVeP0b2Vaxls6UI+vvRSJqVin1mRDXAZEj88lEZp3hk/hU7hvuvwbpqcWJScInPq1Jv9vxfPNBRj3m+1udIJadkphksdKuVmJzbCx75FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CU14SXuF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CU14SXuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D388DC32781;
	Tue, 14 May 2024 10:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684041;
	bh=4GYuSIIc/+c4nsxa8jCA/OaGlqlUONMZHkeb+uHdoY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CU14SXuFnoroYdOuHnhMYHI+tL3vmgJzM+FpuiB1zyHT3VC9Ivp2MuCYI0iXYay5Q
	 kYxvlDHVIZn9zwO0tmyhIQWogrtLw+fubiuYmkes1Hwj1mSJ1qgYxba9qce3hJvLNC
	 W2Btq/IFEzZ2gk8qpIKP3h5bzkFonj+phJFWTu20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.8 282/336] net: bcmgenet: synchronize EXT_RGMII_OOB_CTRL access
Date: Tue, 14 May 2024 12:18:06 +0200
Message-ID: <20240514101049.265603868@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


