Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146CE19EEA2;
	Tue, 27 Aug 2024 14:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769868; cv=none; b=cqmWq3uusICfRfQfBtgPtWPNhLwdGRLelPUld3/yJUkVP2CWsAa8TDJcs2/p8RiauaZoKY/fdFHz/79g5zm/bZZLuLv7e32J55ObaI9Z4KHdoQHJGB71J3EZwiduvvmgLwSo73Bry8R+5WXE3Jytj6TT298nTiTvGEgFj3lGljQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769868; c=relaxed/simple;
	bh=8bjnbtK8p8RlwOMZ9ZchlDXltaDMDBq0+w6tv9Mhsqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qycXqptOSB0n9TTLb3LsaPgVMKzxm4ueHSvuvjztZp9Du1OCkew4uBGEGl7cTbyS4r+7qdh+jpfB+zc5bWMxv/56cJrSfZBfQwN7xfwT+izwAYAy9+GNxWTof5gI2SvJlNkpFtTrgy6/KI8T0r/eLDJ9sNts1s9+uI9fmvUe2Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVdMI4wV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVdMI4wV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD10C6105E;
	Tue, 27 Aug 2024 14:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769868;
	bh=8bjnbtK8p8RlwOMZ9ZchlDXltaDMDBq0+w6tv9Mhsqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oVdMI4wVKkqwj3Ywm3qcpDFiKskrwxrU5KlhW/6WO4sov9z3t/Mrqt5me0ECjo+ft
	 raiJ8TYskTL2jT3tkaEAIPTMMPDJmI4fnOXDODAtYN7VoFzU61V2oVDnGuHs1oePgH
	 +QDmqKN+A9Iw/g9hiWmt0rYrpTZxcQ+JKbtlxRj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asmaa Mnebhi <asmaa@nvidia.com>,
	David Thompson <davthompson@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/341] mlxbf_gige: disable RX filters until RX path initialized
Date: Tue, 27 Aug 2024 16:34:51 +0200
Message-ID: <20240827143845.699257824@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: David Thompson <davthompson@nvidia.com>

[ Upstream commit df934abb185c71c9f2fa07a5013672d0cbd36560 ]

A recent change to the driver exposed a bug where the MAC RX
filters (unicast MAC, broadcast MAC, and multicast MAC) are
configured and enabled before the RX path is fully initialized.
The result of this bug is that after the PHY is started packets
that match these MAC RX filters start to flow into the RX FIFO.
And then, after rx_init() is completed, these packets will go
into the driver RX ring as well. If enough packets are received
to fill the RX ring (default size is 128 packets) before the call
to request_irq() completes, the driver RX function becomes stuck.

This bug is intermittent but is most likely to be seen where the
oob_net0 interface is connected to a busy network with lots of
broadcast and multicast traffic.

All the MAC RX filters must be disabled until the RX path is ready,
i.e. all initialization is done and all the IRQs are installed.

Fixes: f7442a634ac0 ("mlxbf_gige: call request_irq() after NAPI initialized")
Reviewed-by: Asmaa Mnebhi <asmaa@nvidia.com>
Signed-off-by: David Thompson <davthompson@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240809163612.12852-1-davthompson@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige.h |  8 +++
 .../mellanox/mlxbf_gige/mlxbf_gige_main.c     | 10 ++++
 .../mellanox/mlxbf_gige/mlxbf_gige_regs.h     |  2 +
 .../mellanox/mlxbf_gige/mlxbf_gige_rx.c       | 50 ++++++++++++++++---
 4 files changed, 64 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
index bc94e75a7aebd..e7777700ee18a 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
@@ -40,6 +40,7 @@
  */
 #define MLXBF_GIGE_BCAST_MAC_FILTER_IDX 0
 #define MLXBF_GIGE_LOCAL_MAC_FILTER_IDX 1
+#define MLXBF_GIGE_MAX_FILTER_IDX       3
 
 /* Define for broadcast MAC literal */
 #define BCAST_MAC_ADDR 0xFFFFFFFFFFFF
@@ -175,6 +176,13 @@ enum mlxbf_gige_res {
 int mlxbf_gige_mdio_probe(struct platform_device *pdev,
 			  struct mlxbf_gige *priv);
 void mlxbf_gige_mdio_remove(struct mlxbf_gige *priv);
+
+void mlxbf_gige_enable_multicast_rx(struct mlxbf_gige *priv);
+void mlxbf_gige_disable_multicast_rx(struct mlxbf_gige *priv);
+void mlxbf_gige_enable_mac_rx_filter(struct mlxbf_gige *priv,
+				     unsigned int index);
+void mlxbf_gige_disable_mac_rx_filter(struct mlxbf_gige *priv,
+				      unsigned int index);
 void mlxbf_gige_set_mac_rx_filter(struct mlxbf_gige *priv,
 				  unsigned int index, u64 dmac);
 void mlxbf_gige_get_mac_rx_filter(struct mlxbf_gige *priv,
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index 7bb92e2dacda6..57e68bfd3b1a8 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -168,6 +168,10 @@ static int mlxbf_gige_open(struct net_device *netdev)
 	if (err)
 		goto napi_deinit;
 
+	mlxbf_gige_enable_mac_rx_filter(priv, MLXBF_GIGE_BCAST_MAC_FILTER_IDX);
+	mlxbf_gige_enable_mac_rx_filter(priv, MLXBF_GIGE_LOCAL_MAC_FILTER_IDX);
+	mlxbf_gige_enable_multicast_rx(priv);
+
 	/* Set bits in INT_EN that we care about */
 	int_en = MLXBF_GIGE_INT_EN_HW_ACCESS_ERROR |
 		 MLXBF_GIGE_INT_EN_TX_CHECKSUM_INPUTS |
@@ -379,6 +383,7 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 	void __iomem *plu_base;
 	void __iomem *base;
 	int addr, phy_irq;
+	unsigned int i;
 	int err;
 
 	base = devm_platform_ioremap_resource(pdev, MLXBF_GIGE_RES_MAC);
@@ -423,6 +428,11 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 	priv->rx_q_entries = MLXBF_GIGE_DEFAULT_RXQ_SZ;
 	priv->tx_q_entries = MLXBF_GIGE_DEFAULT_TXQ_SZ;
 
+	for (i = 0; i <= MLXBF_GIGE_MAX_FILTER_IDX; i++)
+		mlxbf_gige_disable_mac_rx_filter(priv, i);
+	mlxbf_gige_disable_multicast_rx(priv);
+	mlxbf_gige_disable_promisc(priv);
+
 	/* Write initial MAC address to hardware */
 	mlxbf_gige_initial_mac(priv);
 
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
index cd0973229c9bb..74bd46bab4c05 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
@@ -62,6 +62,8 @@
 #define MLXBF_GIGE_TX_STATUS_DATA_FIFO_FULL           BIT(1)
 #define MLXBF_GIGE_RX_MAC_FILTER_DMAC_RANGE_START     0x0520
 #define MLXBF_GIGE_RX_MAC_FILTER_DMAC_RANGE_END       0x0528
+#define MLXBF_GIGE_RX_MAC_FILTER_GENERAL              0x0530
+#define MLXBF_GIGE_RX_MAC_FILTER_EN_MULTICAST         BIT(1)
 #define MLXBF_GIGE_RX_MAC_FILTER_COUNT_DISC           0x0540
 #define MLXBF_GIGE_RX_MAC_FILTER_COUNT_DISC_EN        BIT(0)
 #define MLXBF_GIGE_RX_MAC_FILTER_COUNT_PASS           0x0548
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c
index 6999843584934..eb62620b63c7f 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c
@@ -11,15 +11,31 @@
 #include "mlxbf_gige.h"
 #include "mlxbf_gige_regs.h"
 
-void mlxbf_gige_set_mac_rx_filter(struct mlxbf_gige *priv,
-				  unsigned int index, u64 dmac)
+void mlxbf_gige_enable_multicast_rx(struct mlxbf_gige *priv)
 {
 	void __iomem *base = priv->base;
-	u64 control;
+	u64 data;
 
-	/* Write destination MAC to specified MAC RX filter */
-	writeq(dmac, base + MLXBF_GIGE_RX_MAC_FILTER +
-	       (index * MLXBF_GIGE_RX_MAC_FILTER_STRIDE));
+	data = readq(base + MLXBF_GIGE_RX_MAC_FILTER_GENERAL);
+	data |= MLXBF_GIGE_RX_MAC_FILTER_EN_MULTICAST;
+	writeq(data, base + MLXBF_GIGE_RX_MAC_FILTER_GENERAL);
+}
+
+void mlxbf_gige_disable_multicast_rx(struct mlxbf_gige *priv)
+{
+	void __iomem *base = priv->base;
+	u64 data;
+
+	data = readq(base + MLXBF_GIGE_RX_MAC_FILTER_GENERAL);
+	data &= ~MLXBF_GIGE_RX_MAC_FILTER_EN_MULTICAST;
+	writeq(data, base + MLXBF_GIGE_RX_MAC_FILTER_GENERAL);
+}
+
+void mlxbf_gige_enable_mac_rx_filter(struct mlxbf_gige *priv,
+				     unsigned int index)
+{
+	void __iomem *base = priv->base;
+	u64 control;
 
 	/* Enable MAC receive filter mask for specified index */
 	control = readq(base + MLXBF_GIGE_CONTROL);
@@ -27,6 +43,28 @@ void mlxbf_gige_set_mac_rx_filter(struct mlxbf_gige *priv,
 	writeq(control, base + MLXBF_GIGE_CONTROL);
 }
 
+void mlxbf_gige_disable_mac_rx_filter(struct mlxbf_gige *priv,
+				      unsigned int index)
+{
+	void __iomem *base = priv->base;
+	u64 control;
+
+	/* Disable MAC receive filter mask for specified index */
+	control = readq(base + MLXBF_GIGE_CONTROL);
+	control &= ~(MLXBF_GIGE_CONTROL_EN_SPECIFIC_MAC << index);
+	writeq(control, base + MLXBF_GIGE_CONTROL);
+}
+
+void mlxbf_gige_set_mac_rx_filter(struct mlxbf_gige *priv,
+				  unsigned int index, u64 dmac)
+{
+	void __iomem *base = priv->base;
+
+	/* Write destination MAC to specified MAC RX filter */
+	writeq(dmac, base + MLXBF_GIGE_RX_MAC_FILTER +
+	       (index * MLXBF_GIGE_RX_MAC_FILTER_STRIDE));
+}
+
 void mlxbf_gige_get_mac_rx_filter(struct mlxbf_gige *priv,
 				  unsigned int index, u64 *dmac)
 {
-- 
2.43.0



