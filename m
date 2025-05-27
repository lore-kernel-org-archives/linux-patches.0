Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E6819E967;
	Tue, 27 May 2025 17:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366006; cv=none; b=rCtmEP9G62gyhrIz29HicQs5Fbw53a7i4OOKa2W7qydMbgmxaRdbdiPbaLfqcmpj443NFZkVeRKIehuYHj8Tljirz4ChKlDEnv+X4qJdArGcsHU0XYgNaFN/v7pTEZcUAbBPLQxOW7k8gE4Ne8ffqL8KahzgdfDzJAZHj9q0kBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366006; c=relaxed/simple;
	bh=CORxvKi1nkee3b32Btke2bxpGjKp0IOk44kh5xelIkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vi0T3Snj44yXwjDBSQjwR1ZlekdfN1zrlYFjqRJ9m7B47JxFZMKMqe9pZQ6Hfa7U8/UY/39pz3LA2kcElOYjQ3rn/PT2fvjzbfQ4yUcdYPSe+mN7QlcXbNBpiB2L7JpQtS1RdlpiqgHpUOWAx6K1iLm6RvZiHF1i+0crieOcM70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLhkfxnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLhkfxnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596D3C4CEE9;
	Tue, 27 May 2025 17:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366006;
	bh=CORxvKi1nkee3b32Btke2bxpGjKp0IOk44kh5xelIkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLhkfxnbn5SYurLLhivbCpbUZ+5XeqTawZFK1qfsqurznpR/BFjebrXJnWNw1huTf
	 SCH84eR5sk1+xzfElBa6FmBb6bt/Eu8gtCEI5X6RoZpVEGQPhkkkrlI1PJohNGDTpx
	 OK6YWw6lLzxZkwW0IZhdyZkPAr8A5MvV6nug2CqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thangaraj Samynathan <thangaraj.s@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 561/626] net: lan743x: Restore SGMII CTRL register on resume
Date: Tue, 27 May 2025 18:27:34 +0200
Message-ID: <20250527162507.761265323@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 547255ca1c4ef..812ad9d61676a 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -3466,6 +3466,7 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 				 struct pci_dev *pdev)
 {
 	struct lan743x_tx *tx;
+	u32 sgmii_ctl;
 	int index;
 	int ret;
 
@@ -3478,6 +3479,15 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
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
@@ -3526,7 +3536,6 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 
 static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
 {
-	u32 sgmii_ctl;
 	int ret;
 
 	adapter->mdiobus = devm_mdiobus_alloc(&adapter->pdev->dev);
@@ -3538,10 +3547,6 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
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
@@ -3552,10 +3557,6 @@ static int lan743x_mdiobus_init(struct lan743x_adapter *adapter)
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



