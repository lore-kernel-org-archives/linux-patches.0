Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC6C2DF73;
	Mon,  8 Apr 2024 13:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581686; cv=none; b=UCAfhFPXZ5txA2pDpmlXc2QXffla2z3icYQLeG6TdUPnb9zPlolQLUOXHxS3LYldJ8UPzysnrNsM54+ETcLFObxTSGQOSCo7GMHA+7C1KYkk2N55LDwHcVWvTQJFDrGgzRduSeg/+bFpIoWmvvsUxbDI0PEVR6N8wdecyMH7eTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581686; c=relaxed/simple;
	bh=DOFAWIKJzhlZ/5foTLRN1ySUuaib8i1SOZbhSsUyrY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQ0bzheC0HZywkn+kb3NaT+5XfDBv8aPz2b9Gr0em0jBsEn9whPXXJz0+2KTIi+FzVNvRAH0455tiqD4zEv1JezK71mTR7c/bzglVv0ZvSQwArSKnxwc5ycObxozR6G+76mqPL40JAMsm6P2mjC3DZDAyBojCk5hHIBr0pE6DPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLJZRC/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLJZRC/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8890DC433F1;
	Mon,  8 Apr 2024 13:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581685;
	bh=DOFAWIKJzhlZ/5foTLRN1ySUuaib8i1SOZbhSsUyrY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLJZRC/1XxwWM7LjHsDoWHXpfqcjG3ZkQhnjIvvMOP3mINSfHwjpoKLYnwHNUZjyK
	 FBT8WLwKckP6SFN/4j+pgD2nlbE5LqrNFWeutVbP6/C+kZREcLPFza7GAMCbRVHtM+
	 sDxiwdb7uDppjoi2muVWhWJ+EPXVqPVX9CT6wNSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Lakkaraju <Raju.Lakkaraju@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/138] net: lan743x: Add set RFE read fifo threshold for PCI1x1x chips
Date: Mon,  8 Apr 2024 14:57:14 +0200
Message-ID: <20240408125256.858270125@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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
index e804613faa1fc..d5123e8c4a9f4 100644
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
@@ -3217,6 +3219,21 @@ static void lan743x_full_cleanup(struct lan743x_adapter *adapter)
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
@@ -3232,6 +3249,7 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 		pci11x1x_strap_get_status(adapter);
 		spin_lock_init(&adapter->eth_syslock_spinlock);
 		mutex_init(&adapter->sgmii_rw_lock);
+		pci11x1x_set_rfe_rd_fifo_threshold(adapter);
 	} else {
 		adapter->max_tx_channels = LAN743X_MAX_TX_CHANNELS;
 		adapter->used_tx_channels = LAN743X_USED_TX_CHANNELS;
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 67877d3b6dd98..d304be17b9d82 100644
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



