Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E6F24B34;
	Tue, 25 Jun 2024 09:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309157; cv=none; b=ZdQANtbPIdnUNbO+Jec57sZxFfQ3CAvpIVYodvj+rlJXvbTg56IJ7sqtGk+jh6U6HGyvy0cvpGJXkidfX4puamK+x2PsJ64M/hCCbqxsbglfn3UoiyFc/Pos5rN7pOHFfBOOE5+FD9BREkmj80xyeC7PkOBq8Kyuop24gy09I3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309157; c=relaxed/simple;
	bh=8xZEgIr0HBWLwlBkrWfiE2jqo5i2DuscIHEVAQDs4sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bq5iBDhAUkbQkltc/tfWtl62ZEwzCZls7Y/2LAa+fnCmduPGXtHP8T/BBYv3q+olmd2P+7EEol19LuH3fcAYHD4xd4csvDkytxlJeYazt1bfuxRUmsVtn9rNRAFDJA0G4bPlXIfoZaXeYKqEyOX4B/mBb4zminOFF0xN9egPmrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPHIJNFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPHIJNFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B13C32781;
	Tue, 25 Jun 2024 09:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309156;
	bh=8xZEgIr0HBWLwlBkrWfiE2jqo5i2DuscIHEVAQDs4sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zPHIJNFeGStUyF38A5KHYMFL3L4qEHvxNEriXV9T3c7lqGT4CXCWdvIMlmTFBvpNo
	 QuF5UmsGyHL/FRHMV03aE1unj/h3ZbpVSb4QgyWh9psseB3E6OMCGIGIbYmr2Yr3Xf
	 8fKzkeM2oqbDP4wiO+8+HhtvgXNrnm4Lk24nWbTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Raju Lakkaraju <Raju.Lakkaraju@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/192] net: lan743x: disable WOL upon resume to restore full data path operation
Date: Tue, 25 Jun 2024 11:32:36 +0200
Message-ID: <20240625085540.399000064@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

[ Upstream commit 7725363936a88351b71495774c1e0e852ae4cdca ]

When Wake-on-LAN (WoL) is active and the system is in suspend mode, triggering
a system event can wake the system from sleep, which may block the data path.
To restore normal data path functionality after waking, disable all wake-up
events. Furthermore, clear all Write 1 to Clear (W1C) status bits by writing
1's to them.

Fixes: 4d94282afd95 ("lan743x: Add power management support")
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 30 ++++++++++++++++---
 drivers/net/ethernet/microchip/lan743x_main.h | 24 +++++++++++++++
 2 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 0b6174748d2b4..e5d9d9983c7f5 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -3519,7 +3519,7 @@ static void lan743x_pm_set_wol(struct lan743x_adapter *adapter)
 
 	/* clear wake settings */
 	pmtctl = lan743x_csr_read(adapter, PMT_CTL);
-	pmtctl |= PMT_CTL_WUPS_MASK_;
+	pmtctl |= PMT_CTL_WUPS_MASK_ | PMT_CTL_RES_CLR_WKP_MASK_;
 	pmtctl &= ~(PMT_CTL_GPIO_WAKEUP_EN_ | PMT_CTL_EEE_WAKEUP_EN_ |
 		PMT_CTL_WOL_EN_ | PMT_CTL_MAC_D3_RX_CLK_OVR_ |
 		PMT_CTL_RX_FCT_RFE_D3_CLK_OVR_ | PMT_CTL_ETH_PHY_WAKE_EN_);
@@ -3654,6 +3654,7 @@ static int lan743x_pm_resume(struct device *dev)
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
+	u32 data;
 	int ret;
 
 	pci_set_power_state(pdev, PCI_D0);
@@ -3672,6 +3673,30 @@ static int lan743x_pm_resume(struct device *dev)
 		return ret;
 	}
 
+	ret = lan743x_csr_read(adapter, MAC_WK_SRC);
+	netif_dbg(adapter, drv, adapter->netdev,
+		  "Wakeup source : 0x%08X\n", ret);
+
+	/* Clear the wol configuration and status bits. Note that
+	 * the status bits are "Write One to Clear (W1C)"
+	 */
+	data = MAC_WUCSR_EEE_TX_WAKE_ | MAC_WUCSR_EEE_RX_WAKE_ |
+	       MAC_WUCSR_RFE_WAKE_FR_ | MAC_WUCSR_PFDA_FR_ | MAC_WUCSR_WUFR_ |
+	       MAC_WUCSR_MPR_ | MAC_WUCSR_BCAST_FR_;
+	lan743x_csr_write(adapter, MAC_WUCSR, data);
+
+	data = MAC_WUCSR2_NS_RCD_ | MAC_WUCSR2_ARP_RCD_ |
+	       MAC_WUCSR2_IPV6_TCPSYN_RCD_ | MAC_WUCSR2_IPV4_TCPSYN_RCD_;
+	lan743x_csr_write(adapter, MAC_WUCSR2, data);
+
+	data = MAC_WK_SRC_ETH_PHY_WK_ | MAC_WK_SRC_IPV6_TCPSYN_RCD_WK_ |
+	       MAC_WK_SRC_IPV4_TCPSYN_RCD_WK_ | MAC_WK_SRC_EEE_TX_WK_ |
+	       MAC_WK_SRC_EEE_RX_WK_ | MAC_WK_SRC_RFE_FR_WK_ |
+	       MAC_WK_SRC_PFDA_FR_WK_ | MAC_WK_SRC_MP_FR_WK_ |
+	       MAC_WK_SRC_BCAST_FR_WK_ | MAC_WK_SRC_WU_FR_WK_ |
+	       MAC_WK_SRC_WK_FR_SAVED_;
+	lan743x_csr_write(adapter, MAC_WK_SRC, data);
+
 	/* open netdev when netdev is at running state while resume.
 	 * For instance, it is true when system wakesup after pm-suspend
 	 * However, it is false when system wakes up after suspend GUI menu
@@ -3680,9 +3705,6 @@ static int lan743x_pm_resume(struct device *dev)
 		lan743x_netdev_open(netdev);
 
 	netif_device_attach(netdev);
-	ret = lan743x_csr_read(adapter, MAC_WK_SRC);
-	netif_info(adapter, drv, adapter->netdev,
-		   "Wakeup source : 0x%08X\n", ret);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index f0b486f85450e..ee6de01d89bcc 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -61,6 +61,7 @@
 #define PMT_CTL_RX_FCT_RFE_D3_CLK_OVR_		BIT(18)
 #define PMT_CTL_GPIO_WAKEUP_EN_			BIT(15)
 #define PMT_CTL_EEE_WAKEUP_EN_			BIT(13)
+#define PMT_CTL_RES_CLR_WKP_MASK_		GENMASK(9, 8)
 #define PMT_CTL_READY_				BIT(7)
 #define PMT_CTL_ETH_PHY_RST_			BIT(4)
 #define PMT_CTL_WOL_EN_				BIT(3)
@@ -227,12 +228,31 @@
 #define MAC_WUCSR				(0x140)
 #define MAC_MP_SO_EN_				BIT(21)
 #define MAC_WUCSR_RFE_WAKE_EN_			BIT(14)
+#define MAC_WUCSR_EEE_TX_WAKE_			BIT(13)
+#define MAC_WUCSR_EEE_RX_WAKE_			BIT(11)
+#define MAC_WUCSR_RFE_WAKE_FR_			BIT(9)
+#define MAC_WUCSR_PFDA_FR_			BIT(7)
+#define MAC_WUCSR_WUFR_				BIT(6)
+#define MAC_WUCSR_MPR_				BIT(5)
+#define MAC_WUCSR_BCAST_FR_			BIT(4)
 #define MAC_WUCSR_PFDA_EN_			BIT(3)
 #define MAC_WUCSR_WAKE_EN_			BIT(2)
 #define MAC_WUCSR_MPEN_				BIT(1)
 #define MAC_WUCSR_BCST_EN_			BIT(0)
 
 #define MAC_WK_SRC				(0x144)
+#define MAC_WK_SRC_ETH_PHY_WK_			BIT(17)
+#define MAC_WK_SRC_IPV6_TCPSYN_RCD_WK_		BIT(16)
+#define MAC_WK_SRC_IPV4_TCPSYN_RCD_WK_		BIT(15)
+#define MAC_WK_SRC_EEE_TX_WK_			BIT(14)
+#define MAC_WK_SRC_EEE_RX_WK_			BIT(13)
+#define MAC_WK_SRC_RFE_FR_WK_			BIT(12)
+#define MAC_WK_SRC_PFDA_FR_WK_			BIT(11)
+#define MAC_WK_SRC_MP_FR_WK_			BIT(10)
+#define MAC_WK_SRC_BCAST_FR_WK_			BIT(9)
+#define MAC_WK_SRC_WU_FR_WK_			BIT(8)
+#define MAC_WK_SRC_WK_FR_SAVED_			BIT(7)
+
 #define MAC_MP_SO_HI				(0x148)
 #define MAC_MP_SO_LO				(0x14C)
 
@@ -295,6 +315,10 @@
 #define RFE_INDX(index)			(0x580 + (index << 2))
 
 #define MAC_WUCSR2			(0x600)
+#define MAC_WUCSR2_NS_RCD_		BIT(7)
+#define MAC_WUCSR2_ARP_RCD_		BIT(6)
+#define MAC_WUCSR2_IPV6_TCPSYN_RCD_	BIT(5)
+#define MAC_WUCSR2_IPV4_TCPSYN_RCD_	BIT(4)
 
 #define SGMII_ACC			(0x720)
 #define SGMII_ACC_SGMII_BZY_		BIT(31)
-- 
2.43.0



