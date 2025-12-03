Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B2234E771;
	Wed,  3 Dec 2025 16:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780915; cv=none; b=WAIwPd+5D0ys1/GEX+KDtwgXzFNVZVZgIfuwGk2KJPrrS5NfZNqv1D8bu9hg0ffr58fL3evI8PetlDL/GIRXXhotBq/SE9p6ik6RyVczQ44Iq6qL1vwggCCDEJJeEbudVMXhrynSGFyGInAqfg8YMCWIG+xndV+lWXYbQzfGj5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780915; c=relaxed/simple;
	bh=poypeU4wGgrKSecdvPV+zNvICxTvccgRGEPbPJDw+HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kw7xcMEwXFxkANbeDTe/XUTQ15Hd0vq8wP1c4zi33QeXWixMYAYaI9EHrqcW+lLuPSOxBPYqK4/Qxw6AARUt3yusUrhZTIswELR/pZUJprHBasdsOEByY9zlFem02Fh+y7dBUH71yn4zuew96/S9jyF3sWAn5yrCnKQ+ibGvTRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXcO/65f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXcO/65f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6218C4CEF5;
	Wed,  3 Dec 2025 16:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780915;
	bh=poypeU4wGgrKSecdvPV+zNvICxTvccgRGEPbPJDw+HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXcO/65fEg0zXRuNw2NGEXxMcrfMxpaDnu3iCCLu1DmTbhUJ4smlq3zyUjk1tIFd8
	 qYgMEXdL438ziZHAElKqe7OCNIZ+DwMahfds6ezsOZcSGNx6IqYeTr5y0qS8SYoS3o
	 bCt3cS3Yk+vhnMqz649oVFJ8dLdIZ+XM2fwfgeGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristram Ha <tristram.ha@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 127/132] net: dsa: microchip: Do not execute PTP driver code for unsupported switches
Date: Wed,  3 Dec 2025 16:30:06 +0100
Message-ID: <20251203152348.020335051@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristram Ha <tristram.ha@microchip.com>

[ Upstream commit 6ed3472173c575cd8aaed6c62eb74f7728404ee6 ]

The PTP driver code only works for certain KSZ switches like KSZ9477,
KSZ9567, LAN937X and their varieties.  This code is enabled by kernel
configuration CONFIG_NET_DSA_MICROCHIP_KSZ_PTP.  As the DSA driver is
common to work with all KSZ switches this PTP code is not appropriate
for other unsupported switches.  The ptp_capable indication is added to
the chip data structure to signal whether to execute those code.

Signed-off-by: Tristram Ha <tristram.ha@microchip.com>
Link: https://patch.msgid.link/20241218020240.70601-1-Tristram.Ha@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0f80e21bf622 ("net: dsa: microchip: Free previously initialized ports on init failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz_common.c |   40 +++++++++++++++++++++++----------
 drivers/net/dsa/microchip/ksz_common.h |    1 
 2 files changed, 30 insertions(+), 11 deletions(-)

--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1342,6 +1342,7 @@ const struct ksz_chip_data ksz_switch_ch
 		.supports_rgmii = {false, false, true},
 		.internal_phy = {true, true, false},
 		.gbit_capable = {false, false, true},
+		.ptp_capable = true,
 		.wr_table = &ksz8563_register_set,
 		.rd_table = &ksz8563_register_set,
 	},
@@ -1553,6 +1554,7 @@ const struct ksz_chip_data ksz_switch_ch
 		.internal_phy	= {true, true, true, true,
 				   true, false, false},
 		.gbit_capable	= {true, true, true, true, true, true, true},
+		.ptp_capable = true,
 		.wr_table = &ksz9477_register_set,
 		.rd_table = &ksz9477_register_set,
 	},
@@ -1680,6 +1682,7 @@ const struct ksz_chip_data ksz_switch_ch
 		.supports_rgmii = {false, false, true},
 		.internal_phy = {true, true, false},
 		.gbit_capable = {true, true, true},
+		.ptp_capable = true,
 	},
 
 	[KSZ8567] = {
@@ -1715,6 +1718,7 @@ const struct ksz_chip_data ksz_switch_ch
 				   true, false, false},
 		.gbit_capable	= {false, false, false, false, false,
 				   true, true},
+		.ptp_capable = true,
 	},
 
 	[KSZ9567] = {
@@ -1747,6 +1751,7 @@ const struct ksz_chip_data ksz_switch_ch
 		.internal_phy	= {true, true, true, true,
 				   true, false, false},
 		.gbit_capable	= {true, true, true, true, true, true, true},
+		.ptp_capable = true,
 	},
 
 	[LAN9370] = {
@@ -1775,6 +1780,7 @@ const struct ksz_chip_data ksz_switch_ch
 		.supports_rmii = {false, false, false, false, true},
 		.supports_rgmii = {false, false, false, false, true},
 		.internal_phy = {true, true, true, true, false},
+		.ptp_capable = true,
 	},
 
 	[LAN9371] = {
@@ -1803,6 +1809,7 @@ const struct ksz_chip_data ksz_switch_ch
 		.supports_rmii = {false, false, false, false, true, true},
 		.supports_rgmii = {false, false, false, false, true, true},
 		.internal_phy = {true, true, true, true, false, false},
+		.ptp_capable = true,
 	},
 
 	[LAN9372] = {
@@ -1835,6 +1842,7 @@ const struct ksz_chip_data ksz_switch_ch
 				   true, true, false, false},
 		.internal_phy	= {true, true, true, true,
 				   false, false, true, true},
+		.ptp_capable = true,
 	},
 
 	[LAN9373] = {
@@ -1867,6 +1875,7 @@ const struct ksz_chip_data ksz_switch_ch
 				   true, true, false, false},
 		.internal_phy	= {true, true, true, false,
 				   false, false, true, true},
+		.ptp_capable = true,
 	},
 
 	[LAN9374] = {
@@ -1899,6 +1908,7 @@ const struct ksz_chip_data ksz_switch_ch
 				   true, true, false, false},
 		.internal_phy	= {true, true, true, true,
 				   false, false, true, true},
+		.ptp_capable = true,
 	},
 };
 EXPORT_SYMBOL_GPL(ksz_switch_chips);
@@ -2556,16 +2566,21 @@ static int ksz_setup(struct dsa_switch *
 			if (ret)
 				goto out_girq;
 
-			ret = ksz_ptp_irq_setup(ds, dp->index);
-			if (ret)
-				goto out_pirq;
+			if (dev->info->ptp_capable) {
+				ret = ksz_ptp_irq_setup(ds, dp->index);
+				if (ret)
+					goto out_pirq;
+			}
 		}
 	}
 
-	ret = ksz_ptp_clock_register(ds);
-	if (ret) {
-		dev_err(dev->dev, "Failed to register PTP clock: %d\n", ret);
-		goto out_ptpirq;
+	if (dev->info->ptp_capable) {
+		ret = ksz_ptp_clock_register(ds);
+		if (ret) {
+			dev_err(dev->dev, "Failed to register PTP clock: %d\n",
+				ret);
+			goto out_ptpirq;
+		}
 	}
 
 	ret = ksz_mdio_register(dev);
@@ -2585,9 +2600,10 @@ static int ksz_setup(struct dsa_switch *
 	return 0;
 
 out_ptp_clock_unregister:
-	ksz_ptp_clock_unregister(ds);
+	if (dev->info->ptp_capable)
+		ksz_ptp_clock_unregister(ds);
 out_ptpirq:
-	if (dev->irq > 0)
+	if (dev->irq > 0 && dev->info->ptp_capable)
 		dsa_switch_for_each_user_port(dp, dev->ds)
 			ksz_ptp_irq_free(ds, dp->index);
 out_pirq:
@@ -2606,11 +2622,13 @@ static void ksz_teardown(struct dsa_swit
 	struct ksz_device *dev = ds->priv;
 	struct dsa_port *dp;
 
-	ksz_ptp_clock_unregister(ds);
+	if (dev->info->ptp_capable)
+		ksz_ptp_clock_unregister(ds);
 
 	if (dev->irq > 0) {
 		dsa_switch_for_each_user_port(dp, dev->ds) {
-			ksz_ptp_irq_free(ds, dp->index);
+			if (dev->info->ptp_capable)
+				ksz_ptp_irq_free(ds, dp->index);
 
 			ksz_irq_free(&dev->ports[dp->index].pirq);
 		}
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -86,6 +86,7 @@ struct ksz_chip_data {
 	bool supports_rgmii[KSZ_MAX_NUM_PORTS];
 	bool internal_phy[KSZ_MAX_NUM_PORTS];
 	bool gbit_capable[KSZ_MAX_NUM_PORTS];
+	bool ptp_capable;
 	const struct regmap_access_table *wr_table;
 	const struct regmap_access_table *rd_table;
 };


