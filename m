Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C391FF61E;
	Mon,  2 Jun 2025 15:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877421; cv=none; b=Db3D5LCE4DbxOufBgZgKe4ZOzuZUoCDkF9K1grNXV9kk6cBg5awNJRm7zUrWZsdTUNJjTaEnx/9jyEiACJKj/2vxbedP2XBW6a789YQw3gPsjLNtHsL4DK2NtgR5Y58FdRwwzxD2F7TFGze6cN8pTdgKJxGese2GwoJatVcj4TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877421; c=relaxed/simple;
	bh=YLvi/2M7ikLuI/t1wI+7/3ObHHdvJmijlWCgIkqC5y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDi9DvSBQwMiDJW9brAHWiXKOFpU5vD1P4lJeWmsOVjvbGVNw0t9qYQaUkaefacOS2bF1QbpTv9EkZ8thVNHvuVhV+gqVAB4U7FwRPVb8LByCkoT7dCLyceXPu2cH2ShChr/kYpvloE2EZLf1mKQe1Dy+4SIsb9flKOY0UcMt84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMvDW7RJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMvDW7RJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB1DC4CEEB;
	Mon,  2 Jun 2025 15:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877421;
	bh=YLvi/2M7ikLuI/t1wI+7/3ObHHdvJmijlWCgIkqC5y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMvDW7RJC49AZ1XuSE96jJXwoQIceRTzWFWIjBqwKf47RHCD1HebAs5rwvPygA80V
	 Bl7adcznjx9e5z8Eb6q6Tv8UA2ODPtv0BU2U1YH3Z3WHQBDBfDjJYbEkyxEziGYMhu
	 Wam4C0gNxzdj6PD/S/PfHLQm3yAodLwiv9fHOM0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thangaraj Samynathan <thangaraj.s@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 242/325] net: lan743x: Restore SGMII CTRL register on resume
Date: Mon,  2 Jun 2025 15:48:38 +0200
Message-ID: <20250602134329.619370093@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2e69ba0143b15..fd35554191793 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -3253,6 +3253,7 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 				 struct pci_dev *pdev)
 {
 	struct lan743x_tx *tx;
+	u32 sgmii_ctl;
 	int index;
 	int ret;
 
@@ -3265,6 +3266,15 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
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
@@ -3313,7 +3323,6 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 
 static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
 {
-	u32 sgmii_ctl;
 	int ret;
 
 	adapter->mdiobus = devm_mdiobus_alloc(&adapter->pdev->dev);
@@ -3325,10 +3334,6 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
 	adapter->mdiobus->priv = (void *)adapter;
 	if (adapter->is_pci11x1x) {
 		if (adapter->is_sgmii_en) {
-			sgmii_ctl = lan743x_csr_read(adapter, SGMII_CTL);
-			sgmii_ctl |= SGMII_CTL_SGMII_ENABLE_;
-			sgmii_ctl &= ~SGMII_CTL_SGMII_POWER_DN_;
-			lan743x_csr_write(adapter, SGMII_CTL, sgmii_ctl);
 			netif_dbg(adapter, drv, adapter->netdev,
 				  "SGMII operation\n");
 			adapter->mdiobus->probe_capabilities = MDIOBUS_C22_C45;
@@ -3338,10 +3343,6 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
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



