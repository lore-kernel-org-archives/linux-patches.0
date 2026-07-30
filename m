Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A7E43991B;
	Thu, 30 Jul 2026 14:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423189; cv=none; b=lajJhVOBNtwlpLA40RDk6p7RIWVkO1+ZlHSSHwKwJ/lo+taCfUdx8+ok837raCV0VA9FmrVoVz9fWsqO39eSKEai9SRQpf9aLif0U1okYf8MD7NsUi23bH1T3Y26kdhv0tQMB+WREFNHoSip5lIKQ/JoIVLTlzSIlqkieKW6Nw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423189; c=relaxed/simple;
	bh=0PpQLf5XLAcYjUvjc3eGsjq59l1mOKDztWHvJUiDPSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R70sGWQA1+Ku/Ofn//hK2bU8/CKqgtaMAm/xaPCrfv+5Cnk578qn2+RGxCxPGzOXeQnIre9z082rQDseMU0o6z01TgeHyGlVHjJlsmt2LjLtz5XtEipf4PTIUUaMLmcN/MSMdr7U7Oqqi4JpS1I2ETt+sEddS6y0/LHskRZe1/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkuxdRid; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkuxdRid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31391F000E9;
	Thu, 30 Jul 2026 14:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423188;
	bh=fTyGN3p3fst0ENfVHTkhUshBaBiiBCQGYz4tV54I4u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PkuxdRidWXlgukRK2ucGSdxSDCRbC3JWHTusyUxniG0wav7Y5SVtqX241owOnZY7m
	 OkX33MmQng7TVyJnHkkfNm60F/xnvAqPRqmKMKO8wtuLKWqWKexa4rFPSY4IlDwLQN
	 NstgfVk/vFmvXD0ae7a6u1uUx5G1+2O7LERjzRCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Breitenberger <bre@keba.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 652/744] net: stmmac: intel: skip SerDes reconfig when rate is unchanged
Date: Thu, 30 Jul 2026 16:15:25 +0200
Message-ID: <20260730141458.128725223@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Breitenberger <bre@keba.com>

commit 0ab78ead2481adb52f9eb5b403865c529f6f2348 upstream.

intel_mac_finish() is registered as the phylink mac_finish()
callback for the Elkhart Lake SGMII ports. phylink calls it at
the end of every major link reconfiguration, including the
initial one during probe.

The callback selects the PMC ModPHY LCPLL programming for the
requested MAC-side interface and then power-cycles the SerDes.
On Elkhart Lake that ModPHY is also used by the on-die AHCI
SATA PHY. Reapplying the programming during the initial
boot-time link-up disturbs the shared analog block while it is
still driving SATA, so the SATA link fails to train:

  ata1: SATA link down (SStatus 1 SControl 300)

The disk carrying the root filesystem is never detected and the
system hangs at rootwait. Ethernet itself comes up normally,
which makes the failure look unrelated to the network driver.

Before mac_finish() runs, the legacy SerDes power-up path has
already programmed SERDES_GCR0 for the current interface. The
1G and 2.5G ModPHY tables selected by mac_finish() correspond
to the SerDes lane rate, so read that rate back from SERDES_GCR0
and skip the PMC reprogramming and SerDes power-cycle when it
already matches the selected interface.

This keeps the disruptive reprogramming out of the boot path
when the SerDes is configured correctly, while preserving the
previous behavior when a real SGMII/1000BASE-X to 2500BASE-X
rate change is needed. If the register read fails, reconfigure
as before.

Fixes: a42f6b3f1cc1 ("net: stmmac: configure SerDes according to the interface mode")
Cc: stable@vger.kernel.org
Signed-off-by: Markus Breitenberger <bre@keba.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260713171619.192452-1-bre@breiti.cc
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c |   31 ++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -524,6 +524,32 @@ static int intel_set_reg_access(const st
 	return ret;
 }
 
+/*
+ * Return true if the SerDes lane rate must change to serve @interface.
+ * If the current rate cannot be determined, reconfigure as before.
+ */
+static bool intel_serdes_needs_reconfig(struct stmmac_priv *priv,
+					struct intel_priv_data *intel_priv,
+					phy_interface_t interface)
+{
+	u32 cur_rate, want_rate;
+	int data;
+
+	if (!intel_priv->mdio_adhoc_addr)
+		return true;
+
+	data = mdiobus_read(priv->mii, intel_priv->mdio_adhoc_addr,
+			    SERDES_GCR0);
+	if (data < 0)
+		return true;
+
+	cur_rate = (data & SERDES_RATE_MASK) >> SERDES_RATE_PCIE_SHIFT;
+	want_rate = interface == PHY_INTERFACE_MODE_2500BASEX ?
+			SERDES_RATE_PCIE_GEN2 : SERDES_RATE_PCIE_GEN1;
+
+	return cur_rate != want_rate;
+}
+
 static int intel_mac_finish(struct net_device *ndev,
 			    void *intel_data,
 			    unsigned int mode,
@@ -535,6 +561,11 @@ static int intel_mac_finish(struct net_d
 	int max_regs = 0;
 	int ret = 0;
 
+	if (!intel_serdes_needs_reconfig(priv, intel_priv, interface)) {
+		priv->plat->phy_interface = interface;
+		return 0;
+	}
+
 	ret = intel_tsn_lane_is_available(ndev, intel_priv);
 	if (ret < 0) {
 		netdev_info(priv->dev, "No TSN lane available to set the registers.\n");


