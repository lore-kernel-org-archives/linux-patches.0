Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BF842A83;
	Wed,  7 May 2025 18:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643884; cv=none; b=HTHlKGLqGX7yH5y/8Ea7R+TsqOQMKJAAXH8zHmdlTCI9evQTTmGurKWZr2MbL+o04Qbn+P9h86XLzMXfbdoOBp5Q2fQOtuxRqFbAO5xno+SS2d0MXJGOiBETeGe93ptKLtxtoZY6Zdo+hw7cJakI2EVUKUuHwSG3IUzcwbUGCWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643884; c=relaxed/simple;
	bh=CnGDCJVf1ySKFJqIKuOWCE/5zL7iVtnxWwhmlof3V7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLbfuY75xqTS1WNX4Omc22tjqyV6j4J9i0POiuNqvACIQ7XZWjU+tbDhTvd0SE5/vmwm3DnADIqzdR+AuDrOTbBjP7Ha2th7uzLc2TrQ7ji4AnNc6/cwJUoeY1ckghye+0xFwF1HZRnEsgeMIGDN/MVJY5Lk5hbvvynUGFPou5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ed9Eu9eI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ed9Eu9eI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F69C4CEE2;
	Wed,  7 May 2025 18:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643884;
	bh=CnGDCJVf1ySKFJqIKuOWCE/5zL7iVtnxWwhmlof3V7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ed9Eu9eIippq7GgkDBJmnPaELGORWdI+X9vxo5r0gXUdk+bdzuFiyTqvfR2XgW1tR
	 M/Q5hJPhI4Pue1CzGb6TJoTQOBEnk7TalQUbC+otSJAKk7nxYLsLyKBc4uYTbAWFP8
	 e8IwJ0jC1bzf9WY3ge2GpYiqf0gKn4/XGTquS+Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishal Badole <Vishal.Badole@amd.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.14 019/183] amd-xgbe: Fix to ensure dependent features are toggled with RX checksum offload
Date: Wed,  7 May 2025 20:37:44 +0200
Message-ID: <20250507183825.471098823@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishal Badole <Vishal.Badole@amd.com>

commit f04dd30f1bef1ed2e74a4050af6e5e5e3869bac3 upstream.

According to the XGMAC specification, enabling features such as Layer 3
and Layer 4 Packet Filtering, Split Header and Virtualized Network support
automatically selects the IPC Full Checksum Offload Engine on the receive
side.

When RX checksum offload is disabled, these dependent features must also
be disabled to prevent abnormal behavior caused by mismatched feature
dependencies.

Ensure that toggling RX checksum offload (disabling or enabling) properly
disables or enables all dependent features, maintaining consistent and
expected behavior in the network device.

Cc: stable@vger.kernel.org
Fixes: 1a510ccf5869 ("amd-xgbe: Add support for VXLAN offload capabilities")
Signed-off-by: Vishal Badole <Vishal.Badole@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250424130248.428865-1-Vishal.Badole@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-desc.c |    9 +++++++--
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c  |   24 ++++++++++++++++++++++--
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c  |   11 +++++++++--
 drivers/net/ethernet/amd/xgbe/xgbe.h      |    4 ++++
 4 files changed, 42 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/amd/xgbe/xgbe-desc.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-desc.c
@@ -373,8 +373,13 @@ static int xgbe_map_rx_buffer(struct xgb
 	}
 
 	/* Set up the header page info */
-	xgbe_set_buffer_data(&rdata->rx.hdr, &ring->rx_hdr_pa,
-			     XGBE_SKB_ALLOC_SIZE);
+	if (pdata->netdev->features & NETIF_F_RXCSUM) {
+		xgbe_set_buffer_data(&rdata->rx.hdr, &ring->rx_hdr_pa,
+				     XGBE_SKB_ALLOC_SIZE);
+	} else {
+		xgbe_set_buffer_data(&rdata->rx.hdr, &ring->rx_hdr_pa,
+				     pdata->rx_buf_size);
+	}
 
 	/* Set up the buffer page info */
 	xgbe_set_buffer_data(&rdata->rx.buf, &ring->rx_buf_pa,
--- a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
@@ -320,6 +320,18 @@ static void xgbe_config_sph_mode(struct
 	XGMAC_IOWRITE_BITS(pdata, MAC_RCR, HDSMS, XGBE_SPH_HDSMS_SIZE);
 }
 
+static void xgbe_disable_sph_mode(struct xgbe_prv_data *pdata)
+{
+	unsigned int i;
+
+	for (i = 0; i < pdata->channel_count; i++) {
+		if (!pdata->channel[i]->rx_ring)
+			break;
+
+		XGMAC_DMA_IOWRITE_BITS(pdata->channel[i], DMA_CH_CR, SPH, 0);
+	}
+}
+
 static int xgbe_write_rss_reg(struct xgbe_prv_data *pdata, unsigned int type,
 			      unsigned int index, unsigned int val)
 {
@@ -3545,8 +3557,12 @@ static int xgbe_init(struct xgbe_prv_dat
 	xgbe_config_tx_coalesce(pdata);
 	xgbe_config_rx_buffer_size(pdata);
 	xgbe_config_tso_mode(pdata);
-	xgbe_config_sph_mode(pdata);
-	xgbe_config_rss(pdata);
+
+	if (pdata->netdev->features & NETIF_F_RXCSUM) {
+		xgbe_config_sph_mode(pdata);
+		xgbe_config_rss(pdata);
+	}
+
 	desc_if->wrapper_tx_desc_init(pdata);
 	desc_if->wrapper_rx_desc_init(pdata);
 	xgbe_enable_dma_interrupts(pdata);
@@ -3702,5 +3718,9 @@ void xgbe_init_function_ptrs_dev(struct
 	hw_if->disable_vxlan = xgbe_disable_vxlan;
 	hw_if->set_vxlan_id = xgbe_set_vxlan_id;
 
+	/* For Split Header*/
+	hw_if->enable_sph = xgbe_config_sph_mode;
+	hw_if->disable_sph = xgbe_disable_sph_mode;
+
 	DBGPR("<--xgbe_init_function_ptrs\n");
 }
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2257,10 +2257,17 @@ static int xgbe_set_features(struct net_
 	if (ret)
 		return ret;
 
-	if ((features & NETIF_F_RXCSUM) && !rxcsum)
+	if ((features & NETIF_F_RXCSUM) && !rxcsum) {
+		hw_if->enable_sph(pdata);
+		hw_if->enable_vxlan(pdata);
 		hw_if->enable_rx_csum(pdata);
-	else if (!(features & NETIF_F_RXCSUM) && rxcsum)
+		schedule_work(&pdata->restart_work);
+	} else if (!(features & NETIF_F_RXCSUM) && rxcsum) {
+		hw_if->disable_sph(pdata);
+		hw_if->disable_vxlan(pdata);
 		hw_if->disable_rx_csum(pdata);
+		schedule_work(&pdata->restart_work);
+	}
 
 	if ((features & NETIF_F_HW_VLAN_CTAG_RX) && !rxvlan)
 		hw_if->enable_rx_vlan_stripping(pdata);
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -865,6 +865,10 @@ struct xgbe_hw_if {
 	void (*enable_vxlan)(struct xgbe_prv_data *);
 	void (*disable_vxlan)(struct xgbe_prv_data *);
 	void (*set_vxlan_id)(struct xgbe_prv_data *);
+
+	/* For Split Header */
+	void (*enable_sph)(struct xgbe_prv_data *pdata);
+	void (*disable_sph)(struct xgbe_prv_data *pdata);
 };
 
 /* This structure represents implementation specific routines for an


