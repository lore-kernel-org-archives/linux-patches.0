Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D9C2E62C;
	Mon,  8 Apr 2024 13:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581779; cv=none; b=grbm3H1jNQvlw+mhW+P5eUNlCnMtCh9GwHdsKZrvJO3L7+acy14LT4QGNbVc5b7+bpXGrAuhH/4/SMbB8uDU9Kw+MOVksvyGea9yIDEhVrhn29use+t+0ElrOuB7UgCMSCZNcRLFBOkY0DxxyC9RgrgNozxKLq0hiKsElrcaECs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581779; c=relaxed/simple;
	bh=OA3UvX+bXbpLqEEKWLyGO2UDbJ596WPvXkvBGQ7gF6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPgBoQGiWnJYpQfcxg7EaePPmkgUwM+4VteEb0GapMECMxMlZRg9/GwOn6YYV0TaABio+ueL9S1J/xf8CJnN7J4AbgH5L6ndsKQra4ITJo7KY4Vv6uWo6JOiaWE0I4mVTwzkjtAE2Ty3lbJj4zJC6HlDQ2zrH1hGiiD9FxfkjQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2pbrE3O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2pbrE3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54180C433F1;
	Mon,  8 Apr 2024 13:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581779;
	bh=OA3UvX+bXbpLqEEKWLyGO2UDbJ596WPvXkvBGQ7gF6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2pbrE3OIiHaqz2NAwKGjE0GPpV5riP4x04nNBv2pvMKzZ1ROUkhN8brUrsqJNMpX
	 DxnBI2nG3StwOALxnXi7fMXFfAE9maJzbUF0cNgNUXPHOB8HKMvz0uI4BmnoBGCCVy
	 Ynt+MH2QeoWqT4Ta9NUvSGaqLNDOT9UB3aBDj80c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Lakkaraju <Raju.Lakkaraju@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/252] net: lan743x: Add set RFE read fifo threshold for PCI1x1x chips
Date: Mon,  8 Apr 2024 14:55:38 +0200
Message-ID: <20240408125307.854381868@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>

[ Upstream commit e4a58989f5c839316ac63675e8800b9eed7dbe96 ]

PCI11x1x Rev B0 devices might drop packets when receiving back to back frames
at 2.5G link speed. Change the B0 Rev device's Receive filtering Engine FIFO
threshold parameter from its hardware default of 4 to 3 dwords to prevent the
problem. Rev C0 and later hardware already defaults to 3 dwords.

Fixes: bb4f6bffe33c ("net: lan743x: Add PCI11010 / PCI11414 device IDs")
Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240326065805.686128-1-Raju.Lakkaraju@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 18 ++++++++++++++++++
 drivers/net/ethernet/microchip/lan743x_main.h |  4 ++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index c81cdeb4d4e7e..0b6174748d2b4 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -25,6 +25,8 @@
 #define PCS_POWER_STATE_DOWN	0x6
 #define PCS_POWER_STATE_UP	0x4
 
+#define RFE_RD_FIFO_TH_3_DWORDS	0x3
+
 static void pci11x1x_strap_get_status(struct lan743x_adapter *adapter)
 {
 	u32 chip_rev;
@@ -3223,6 +3225,21 @@ static void lan743x_full_cleanup(struct lan743x_adapter *adapter)
 	lan743x_pci_cleanup(adapter);
 }
 
+static void pci11x1x_set_rfe_rd_fifo_threshold(struct lan743x_adapter *adapter)
+{
+	u16 rev = adapter->csr.id_rev & ID_REV_CHIP_REV_MASK_;
+
+	if (rev == ID_REV_CHIP_REV_PCI11X1X_B0_) {
+		u32 misc_ctl;
+
+		misc_ctl = lan743x_csr_read(adapter, MISC_CTL_0);
+		misc_ctl &= ~MISC_CTL_0_RFE_READ_FIFO_MASK_;
+		misc_ctl |= FIELD_PREP(MISC_CTL_0_RFE_READ_FIFO_MASK_,
+				       RFE_RD_FIFO_TH_3_DWORDS);
+		lan743x_csr_write(adapter, MISC_CTL_0, misc_ctl);
+	}
+}
+
 static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 				 struct pci_dev *pdev)
 {
@@ -3238,6 +3255,7 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 		pci11x1x_strap_get_status(adapter);
 		spin_lock_init(&adapter->eth_syslock_spinlock);
 		mutex_init(&adapter->sgmii_rw_lock);
+		pci11x1x_set_rfe_rd_fifo_threshold(adapter);
 	} else {
 		adapter->max_tx_channels = LAN743X_MAX_TX_CHANNELS;
 		adapter->used_tx_channels = LAN743X_USED_TX_CHANNELS;
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 52609fc13ad95..f0b486f85450e 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -26,6 +26,7 @@
 #define ID_REV_CHIP_REV_MASK_		(0x0000FFFF)
 #define ID_REV_CHIP_REV_A0_		(0x00000000)
 #define ID_REV_CHIP_REV_B0_		(0x00000010)
+#define ID_REV_CHIP_REV_PCI11X1X_B0_	(0x000000B0)
 
 #define FPGA_REV			(0x04)
 #define FPGA_REV_GET_MINOR_(fpga_rev)	(((fpga_rev) >> 8) & 0x000000FF)
@@ -311,6 +312,9 @@
 #define SGMII_CTL_LINK_STATUS_SOURCE_	BIT(8)
 #define SGMII_CTL_SGMII_POWER_DN_	BIT(1)
 
+#define MISC_CTL_0			(0x920)
+#define MISC_CTL_0_RFE_READ_FIFO_MASK_	GENMASK(6, 4)
+
 /* Vendor Specific SGMII MMD details */
 #define SR_VSMMD_PCS_ID1		0x0004
 #define SR_VSMMD_PCS_ID2		0x0005
-- 
2.43.0



