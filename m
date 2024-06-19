Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E000B1422B8;
	Wed, 19 Jun 2024 13:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802766; cv=none; b=NnHs5rsFNcsTQkj6HrFRd/SZRRk+aVsNJB9vRRB/wuSqySKshzRE/hQ7og3aCWb6mzyWJJ0zsK9bu0W2ahC4PpxPaFYjrMhvqRR+4WfS7Idwkl+k8Fo82yr/JV925JbE5axg2kE8PoYQgUH/XzYNy2vhYmWLRua2k1Sb0hBY8Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802766; c=relaxed/simple;
	bh=DCgwaCNAxfZmTfH6KZAIhYH02DbBUxleQPBWriXrHUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGKtUeZruAjbdhh6L8oYrcwznToktfbe7H9Z7tJjlWdC5jMnjOlx4vG5twr+iau1CduVH7KNTlBba/ta1q81qnNV49qsblk0kleNu1m955iHSpM/xTOtyxohF9wQOOqFoMW88i6UgI5WcSEaSYEOjNd1+w6rI6/RdLcO/8501gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=giho6jdM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="giho6jdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E88C2BBFC;
	Wed, 19 Jun 2024 13:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802765;
	bh=DCgwaCNAxfZmTfH6KZAIhYH02DbBUxleQPBWriXrHUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=giho6jdMR7cFft1Vpuyqr1s/vS5W4ZET7eyS+mfOtOWt0GvcZZAH5NtYAPFM+soU5
	 eYVrxPUFGTv6hnOZxHbwvbgOYz8mSbLMaJPLrVsPq3AnsJuqPw+nQd4A+AWL2Eaf/S
	 xIaUD/nfCUIGp3JEa657uwAPzTiiH36qjQN0CIaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristram Ha <tristram.ha@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 038/281] net: phy: Micrel KSZ8061: fix errata solution not taking effect problem
Date: Wed, 19 Jun 2024 14:53:17 +0200
Message-ID: <20240619125611.315859433@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristram Ha <tristram.ha@microchip.com>

[ Upstream commit 0a8d3f2e3e8d8aea8af017e14227b91d5989b696 ]

KSZ8061 needs to write to a MMD register at driver initialization to fix
an errata.  This worked in 5.0 kernel but not in newer kernels.  The
issue is the main phylib code no longer resets PHY at the very beginning.
Calling phy resuming code later will reset the chip if it is already
powered down at the beginning.  This wipes out the MMD register write.
Solution is to implement a phy resume function for KSZ8061 to take care
of this problem.

Fixes: 232ba3a51cc2 ("net: phy: Micrel KSZ8061: link failure after cable connect")
Signed-off-by: Tristram Ha <tristram.ha@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 42 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index c2d99344ade41..4b22bb6393e26 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -785,6 +785,17 @@ static int ksz8061_config_init(struct phy_device *phydev)
 {
 	int ret;
 
+	/* Chip can be powered down by the bootstrap code. */
+	ret = phy_read(phydev, MII_BMCR);
+	if (ret < 0)
+		return ret;
+	if (ret & BMCR_PDOWN) {
+		ret = phy_write(phydev, MII_BMCR, ret & ~BMCR_PDOWN);
+		if (ret < 0)
+			return ret;
+		usleep_range(1000, 2000);
+	}
+
 	ret = phy_write_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_DEVID1, 0xB61A);
 	if (ret)
 		return ret;
@@ -2054,6 +2065,35 @@ static int ksz9477_resume(struct phy_device *phydev)
 	return 0;
 }
 
+static int ksz8061_resume(struct phy_device *phydev)
+{
+	int ret;
+
+	/* This function can be called twice when the Ethernet device is on. */
+	ret = phy_read(phydev, MII_BMCR);
+	if (ret < 0)
+		return ret;
+	if (!(ret & BMCR_PDOWN))
+		return 0;
+
+	genphy_resume(phydev);
+	usleep_range(1000, 2000);
+
+	/* Re-program the value after chip is reset. */
+	ret = phy_write_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_DEVID1, 0xB61A);
+	if (ret)
+		return ret;
+
+	/* Enable PHY Interrupts */
+	if (phy_interrupt_is_valid(phydev)) {
+		phydev->interrupts = PHY_INTERRUPT_ENABLED;
+		if (phydev->drv->config_intr)
+			phydev->drv->config_intr(phydev);
+	}
+
+	return 0;
+}
+
 static int kszphy_probe(struct phy_device *phydev)
 {
 	const struct kszphy_type *type = phydev->drv->driver_data;
@@ -4876,7 +4916,7 @@ static struct phy_driver ksphy_driver[] = {
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.suspend	= kszphy_suspend,
-	.resume		= kszphy_resume,
+	.resume		= ksz8061_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ9021,
 	.phy_id_mask	= 0x000ffffe,
-- 
2.43.0



