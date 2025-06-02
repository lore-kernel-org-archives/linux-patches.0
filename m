Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EF61E0DD8;
	Mon,  2 Jun 2025 14:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874070; cv=none; b=nAm/aqHOCFyv8O4ISH94nzMRHi52o/Qa9OG8oq+SR6tS2H2drXNGBtomahpO+t8NRkeEp+KRbS36MhMRjBH6mThB+08SgDEQ9AhFmoVAii2K3j/ecKV/Liz98Eyp5mtN+kI6DUx9cwa4YnpYsLbkizbgRAi6FhnpQvxYY266xOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874070; c=relaxed/simple;
	bh=F/L1PelHYQF6PMp2dPrDk48Nrk8hzOTAL5zz30HGJjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVM0XzguIeijTrSi/Z5EFqwQ7C964bb/iDpIvfnPbku2QhEWhW+li8VLJQvHlE4QLwzcdWU01tL8hyYI9XaNh/CnnCA1+Vc3Fb80jiuLpHEB+ZW5PZM+CJCAH2lb83W6SrM24lr67XLu8YT5kWwJ8hmjlO7P1e98SdMmaNwAQaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHPG0u63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHPG0u63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931D9C4CEEB;
	Mon,  2 Jun 2025 14:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874069;
	bh=F/L1PelHYQF6PMp2dPrDk48Nrk8hzOTAL5zz30HGJjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHPG0u63rIBVKqPKTNYCoy4YcD6W1TLU1eLuj3f6f9jVqjOkHEK8lVzZyD6EvmF3q
	 kbCp6N6x4KvhHycGyAPszR51jpC6QIAyEWiKu2QgXCwADCKf8PaRfj7x0RzGn/+CpN
	 QHF3rzCoOR6SQkYDLOctHCGtl8qPoP4928T4KDOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thangaraj Samynathan <thangaraj.s@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 348/444] net: lan743x: Restore SGMII CTRL register on resume
Date: Mon,  2 Jun 2025 15:46:52 +0200
Message-ID: <20250602134355.061514301@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thangaraj Samynathan <thangaraj.s@microchip.com>

[ Upstream commit 293e38ff4e4c2ba53f3fd47d8a4a9f0f0414a7a6 ]

SGMII_CTRL register, which specifies the active interface, was not
properly restored when resuming from suspend. This led to incorrect
interface selection after resume particularly in scenarios involving
the FPGA.

To fix this:
- Move the SGMII_CTRL setup out of the probe function.
- Initialize the register in the hardware initialization helper function,
which is called during both device initialization and resume.

This ensures the interface configuration is consistently restored after
suspend/resume cycles.

Fixes: a46d9d37c4f4f ("net: lan743x: Add support for SGMII interface")
Signed-off-by: Thangaraj Samynathan <thangaraj.s@microchip.com>
Link: https://patch.msgid.link/20250516035719.117960-1-thangaraj.s@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 5d2ceff72784f..f971d60484f06 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -3259,6 +3259,7 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 				 struct pci_dev *pdev)
 {
 	struct lan743x_tx *tx;
+	u32 sgmii_ctl;
 	int index;
 	int ret;
 
@@ -3271,6 +3272,15 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 		spin_lock_init(&adapter->eth_syslock_spinlock);
 		mutex_init(&adapter->sgmii_rw_lock);
 		pci11x1x_set_rfe_rd_fifo_threshold(adapter);
+		sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
+		if (adapter->is_sgmii_en) {
+			sgmii_ctl |= SGMII_CTL_SGMII_ENABLE_;
+			sgmii_ctl &= ~SGMII_CTL_SGMII_POWER_DN_;
+		} else {
+			sgmii_ctl &= ~SGMII_CTL_SGMII_ENABLE_;
+			sgmii_ctl |= SGMII_CTL_SGMII_POWER_DN_;
+		}
+		lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
 	} else {
 		adapter->max_tx_channels = LAN743X_MAX_TX_CHANNELS;
 		adapter->used_tx_channels = LAN743X_USED_TX_CHANNELS;
@@ -3319,7 +3329,6 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 
 static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
 {
-	u32 sgmii_ctl;
 	int ret;
 
 	adapter->mdiobus = devm_mdiobus_alloc(&adapter->pdev->dev);
@@ -3331,10 +3340,6 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
 	adapter->mdiobus->priv = (void *)adapter;
 	if (adapter->is_pci11x1x) {
 		if (adapter->is_sgmii_en) {
-			sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
-			sgmii_ctl |= SGMII_CTL_SGMII_ENABLE_;
-			sgmii_ctl &= ~SGMII_CTL_SGMII_POWER_DN_;
-			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
 			netif_dbg(adapter, drv, adapter->netdev,
 				  "SGMII operation\n");
 			adapter->mdiobus->read = lan743x_mdiobus_read_c22;
@@ -3345,10 +3350,6 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
 			netif_dbg(adapter, drv, adapter->netdev,
 				  "lan743x-mdiobus-c45\n");
 		} else {
-			sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
-			sgmii_ctl &= ~SGMII_CTL_SGMII_ENABLE_;
-			sgmii_ctl |= SGMII_CTL_SGMII_POWER_DN_;
-			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
 			netif_dbg(adapter, drv, adapter->netdev,
 				  "RGMII operation\n");
 			// Only C22 support when RGMII I/F
-- 
2.39.5



