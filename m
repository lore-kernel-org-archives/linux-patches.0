Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215E8274B35;
	Tue, 21 Oct 2025 20:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077345; cv=none; b=jPp7jo5kDaCji7eUSEkranhOclfnqtYcNuH7uMhZqJCZDFkFEhbAUOSLTLmAb/qe3r/bU9wMFUsUnaKB8qbwsTWmkUDwf0ns+4iqV+o7E/uCeADERRfIRUCg3gJTez0P1yErieK7LeXSxWgnt2H5P0bxD9A5Z5Q/bnluOhjbXfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077345; c=relaxed/simple;
	bh=7XJYK9dS+fakoKa6Qcij0M72Axp1dAFIc+jfNrYChAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kpJ5CKMiPDxs2kjWj5fmQVuMJIYAC4kBjso/+7pocbqFRzEZPLkZK75UOETTTMXeOZEdibYQqTJuDgaFwN8yu/1nTu5FeHIMe/CMTVTNvx/UETGpUiqgMoqDt/lGNI8RpKaFDxsDeX9cU6yPgl7BdPd7yS/BDf52Skeaf74jGhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDf/6RqT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDf/6RqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D165C4CEF1;
	Tue, 21 Oct 2025 20:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077345;
	bh=7XJYK9dS+fakoKa6Qcij0M72Axp1dAFIc+jfNrYChAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDf/6RqThVCIUjU4IcUseHcDvIIH7Zkw2D7p4+cPeoSQ200IZxq30yoLz1K25joel
	 FAlDFK8sOYZAPSUoWfcOHpo2/ezMpe/Brqe3m88+pPykr8vY0mV8Yjp1pW7ZXBcVH5
	 7dm9jhTLgncoEgFPa1MjyKjWVR57XhlCI58NYH7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 075/159] net: phy: realtek: Avoid PHYCR2 access if PHYCR2 not present
Date: Tue, 21 Oct 2025 21:50:52 +0200
Message-ID: <20251021195045.004001067@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut@mailbox.org>

[ Upstream commit 2c67301584f2671e320236df6bbe75ae09feb4d0 ]

The driver is currently checking for PHYCR2 register presence in
rtl8211f_config_init(), but it does so after accessing PHYCR2 to
disable EEE. This was introduced in commit bfc17c165835 ("net:
phy: realtek: disable PHY-mode EEE"). Move the PHYCR2 presence
test before the EEE disablement and simplify the code.

Fixes: bfc17c165835 ("net: phy: realtek: disable PHY-mode EEE")
Signed-off-by: Marek Vasut <marek.vasut@mailbox.org>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20251011110309.12664-1-marek.vasut@mailbox.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek/realtek_main.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/realtek/realtek_main.c b/drivers/net/phy/realtek/realtek_main.c
index dd0d675149ad7..64af3b96f0288 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -589,26 +589,25 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 			str_enabled_disabled(val_rxdly));
 	}
 
+	if (!priv->has_phycr2)
+		return 0;
+
 	/* Disable PHY-mode EEE so LPI is passed to the MAC */
 	ret = phy_modify_paged(phydev, RTL8211F_PHYCR_PAGE, RTL8211F_PHYCR2,
 			       RTL8211F_PHYCR2_PHY_EEE_ENABLE, 0);
 	if (ret)
 		return ret;
 
-	if (priv->has_phycr2) {
-		ret = phy_modify_paged(phydev, RTL8211F_PHYCR_PAGE,
-				       RTL8211F_PHYCR2, RTL8211F_CLKOUT_EN,
-				       priv->phycr2);
-		if (ret < 0) {
-			dev_err(dev, "clkout configuration failed: %pe\n",
-				ERR_PTR(ret));
-			return ret;
-		}
-
-		return genphy_soft_reset(phydev);
+	ret = phy_modify_paged(phydev, RTL8211F_PHYCR_PAGE,
+			       RTL8211F_PHYCR2, RTL8211F_CLKOUT_EN,
+			       priv->phycr2);
+	if (ret < 0) {
+		dev_err(dev, "clkout configuration failed: %pe\n",
+			ERR_PTR(ret));
+		return ret;
 	}
 
-	return 0;
+	return genphy_soft_reset(phydev);
 }
 
 static int rtl821x_suspend(struct phy_device *phydev)
-- 
2.51.0



