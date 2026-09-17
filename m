Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C39C547042;
	Thu, 17 Sep 2026 18:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670842; cv=none; b=fb++FfhC7xZvvdG+mCpNOH946pDAsV7bmIKHznB3Lsnh2N0+vU9qxF1m0aB7U5/9nvwNLAtO7e5rfw3QSHjyO695+Nk1pGDZmsQNhXEjwCZ2NpLfIFqxlXQmb3wiBkcm+/XaFJtZPNC1rtc/dtmXv2US7dUOZEbRRewISEt58/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670842; c=relaxed/simple;
	bh=h67vohP2QQSN7s8hH4k03bOfBypYWPm7W/28JO7kGR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQoUI404wmsmawgCRJX/QsW4BZatUk7NQxyte3WqZWeB+4QgV5dPiPnC4EaCvsqhU+93kPv+tev0oVtSN5Q8/Dnu6W8o4DURXCMWP9yRfg75MchlTngMEeKUniKkzyzAU+dPItGc9yLpJOkMkleznfiarD2INWjENpIFCbc9dU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bt6rWbHy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bt6rWbHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFBB1F000FF;
	Thu, 17 Sep 2026 18:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670840;
	bh=yO9i1W9AOpssoOaPIM927+IfRvUTysM09dvSvhnaOwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bt6rWbHyijc79TiBqAcKVocZ6g31qDbl4WQACvrVUmO4GdkHDDqgRId8yHmGzds0l
	 KmiyhUrx2C7SMh0M4ms1Vmwgv7Lcc8ZWm859JdO7gFj8cRL2llOi1K4kBwzV91BrPc
	 kC7vxSOSIeo69RzBAyWhwCpvrxChf0UI99OHoGyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0787/1102] net: phy: add phy_disable_eee
Date: Thu, 17 Sep 2026 16:12:10 +0100
Message-ID: <20260917151600.224366029@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit b55498ff14bd14860d48dc8d2a0b6889b218c408 ]

If a MAC driver doesn't support EEE, then the PHY shouldn't advertise it.
Add phy_disable_eee() for this purpose.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/fd51738c-dcd6-4d61-b8c5-faa6ac0f1026@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ccbe7540e4aa ("net: phy: mediatek-ge: disable EEE on the MT7530 PHY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 16 ++++++++++++++++
 include/linux/phy.h          |  1 +
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index f2d067b907bf9..8ec06756c033b 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3043,6 +3043,22 @@ void phy_support_eee(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(phy_support_eee);
 
+/**
+ * phy_disable_eee - Disable EEE for the PHY
+ * @phydev: Target phy_device struct
+ *
+ * This function is used by MAC drivers for MAC's which don't support EEE.
+ * It disables EEE on the PHY layer.
+ */
+void phy_disable_eee(struct phy_device *phydev)
+{
+	linkmode_zero(phydev->supported_eee);
+	linkmode_zero(phydev->advertising_eee);
+	phydev->eee_cfg.tx_lpi_enabled = false;
+	phydev->eee_cfg.eee_enabled = false;
+}
+EXPORT_SYMBOL_GPL(phy_disable_eee);
+
 /**
  * phy_support_sym_pause - Enable support of symmetrical pause
  * @phydev: target phy_device struct
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 49283facf9320..957fb0cdb02c2 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -2040,6 +2040,7 @@ void phy_advertise_eee_all(struct phy_device *phydev);
 void phy_support_sym_pause(struct phy_device *phydev);
 void phy_support_asym_pause(struct phy_device *phydev);
 void phy_support_eee(struct phy_device *phydev);
+void phy_disable_eee(struct phy_device *phydev);
 void phy_set_sym_pause(struct phy_device *phydev, bool rx, bool tx,
 		       bool autoneg);
 void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx);
-- 
2.53.0



