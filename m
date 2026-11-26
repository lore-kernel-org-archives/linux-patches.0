Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705192;
	b=Gs5WsTO3PzHYLfAIioVAOsJBEpkTlIO3I7+AA89xXPOMDKfbJBgXm4zBYl/00qf8FHbZ
	 UtbNyfpnxrEY4isOBQvNLK5rvrWRzdNtG/0pN5Cs42rDz6WKgTy7+6Xe2LJnZtzEvimVs
	 TmZBijKH0scTVykyV07UA681aSs4c+SzE7H2K5JbeV5abIgk7mwdXaGBEXhha6fe7CgoH
	 eY5qPpIwHM7DH2LXgPgu0Dfi7uJ8wsH5PaRoP++er1awCQq3KC+lvbmHirz+MFCwK9Zlh
	 o1Z8eOthhXgjKjYPrLj9FHyBoxTdU7EmP/qMwtpYxrl2MWOHPA5CeaX40Yc6tn3a3xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LJtXpGEbTezJ0bLHuJCmz0dxw734jYMcCA9lAbdKF98=;
	b=Slei8mUTOGMWn2Zgxyur5KmPX7NrJuhn7DgS2ZzVbV2LMoN21A3CpIWVuwOMrtKrQlvW
	 4C7vvPRJb2W1KLT03saoplnqC+xe91I1apKWQO3K2Nq3DJ9pm2ZuKExsWgX2WVJmO9VS2
	 F5evvAmmdVctrQXF4qYCUaBCSGO6RsgthOcOorLS3RKBpwSdBQCUghSz0yAhPiT+P8/2J
	 C9Fot6vvHabZ6U+iXntKIemUVkrlWWRQ07eTIFSuRn/ffatFuqBXDhAyvgmRRPDCy0ngk
	 2qHVkh6umsP/b5RlIJ2asQSURHK7Ed3C05NDeao0fpma/L1sVbef2Vb57pBeCVT/SZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gSefc9cM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873F5606A31C;
	Thu, 26 Nov 2026 14:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gSefc9cM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DF11F000C4;
	Thu, 26 Nov 2026 14:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705192;
	bh=LJtXpGEbTezJ0bLHuJCmz0dxw734jYMcCA9lAbdKF98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gSefc9cMe5L3AoqAv5G8kBJ+A/EpVtjRiQocg6zMb4ko3UF3Y/58KMqcxU23HlRzy
	 N/1wj2xhswRBFvDAnIOW6dGlix9t8iLUAP0feck/W93BqgsXmnv5v5bfU5ulKwOe/O
	 DfEJMkm0rDgboRLUktrmzZRSsKfPd2uu7VoZLw9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/319] net: dsa: b53: Enable IGMP and MLD control packet CPU copies
Date: Thu, 26 Nov 2026 15:37:26 +0100
Message-ID: <20261126144008.501557479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 3362cb822ea750399a15b741713181fd8560bd17 ]

IGMPv2 reports and MLDv1 reports are addressed to the multicast group
itself. Once the first listener is installed in the ARL table, subsequent
reports can follow that entry without reaching the CPU. The bridge then
fails to learn additional listeners, although static MDB forwarding works.

Enable the high-level protocol classifiers so that IGMP and MLD control
packets are copied to the CPU independently of the multicast ARL lookup.
Retain normal L2 forwarding by clearing the CPU-only forwarding modes,
and preserve unrelated protocol-control fields.

Handle the BCM5395's 16-bit register and different classifier fields
separately from the 32-bit layout on the BCM531xx, BCM5301x and newer
integrated RoboSwitch families, including BCM7445, BCM7278 and BCM4908.
Export the helper and call it from bcm_sf2_sw_setup() as well, since SF2
uses its own setup operation instead of b53_setup(). This also restores
the classifiers after the switch reset on resume. Leave older devices
with different IGMP controls untouched, and propagate register access
failures during setup.

The SF2 setup integration and BCM4908 chip gate were updated with
assistance from OpenAI Codex in response to review feedback.

Fixes: 5d65b64a3d97 ("net: dsa: b53: Add support for MDB")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261028235100.3892374-2-florian.fainelli@broadcom.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 57 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/b53/b53_priv.h   |  1 +
 drivers/net/dsa/b53/b53_regs.h   | 17 ++++++++++
 drivers/net/dsa/bcm_sf2.c        |  5 +++
 4 files changed, 80 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index a43cbb481529d..d1751f2028582 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -709,6 +709,59 @@ void b53_brcm_hdr_setup(struct dsa_switch *ds, int port)
 }
 EXPORT_SYMBOL(b53_brcm_hdr_setup);
 
+int b53_enable_mcast_snooping(struct b53_device *dev)
+{
+	u16 val16;
+	u32 val;
+	int ret;
+
+	/* Older switches use different IGMP controls, not HL_PRTC_CTRL. */
+	if (is5325(dev) || is5365(dev) || dev->chip_id == BCM5389_DEVICE_ID ||
+	    is5397_98(dev) || is63xx(dev))
+		return 0;
+
+	/* IGMPv2 and MLDv1 reports use the group's destination MAC. Once
+	 * the first listener is offloaded, ordinary multicast forwarding
+	 * can keep subsequent reports from reaching the bridge CPU.
+	 */
+
+	/* BCM5395 has a narrower register and a single IGMP classifier.
+	 * Its ICMPv6 classifier also covers MLD.
+	 */
+	if (dev->chip_id == BCM5395_DEVICE_ID) {
+		ret = b53_read16(dev, B53_MGMT_PAGE, B53_HL_PRTC_CTRL, &val16);
+		if (ret)
+			return ret;
+
+		val16 |= HL_PRTC_IGMP_IP_EN_5395 | HL_PRTC_ICMPV6_EN;
+		/* Zero forwarding modes copy control traffic to the CPU
+		 * independently of the ARL lookup, retaining L2 forwarding.
+		 */
+		val16 &= ~(HL_PRTC_IGMP_FWD_MODE_5395 |
+			   HL_PRTC_ICMPV6_FWD_MODE);
+
+		return b53_write16(dev, B53_MGMT_PAGE, B53_HL_PRTC_CTRL,
+				   val16);
+	}
+
+	ret = b53_read32(dev, B53_MGMT_PAGE, B53_HL_PRTC_CTRL, &val);
+	if (ret)
+		return ret;
+
+	val |= HL_PRTC_IGMP_RPTLVE_EN | HL_PRTC_IGMP_QRY_EN |
+	       HL_PRTC_IGMP_UKN_EN | HL_PRTC_MLD_RPTDONE_EN |
+	       HL_PRTC_MLD_QRY_EN;
+	/* Zero forwarding modes copy control traffic to the CPU
+	 * independently of the ARL lookup, retaining L2 forwarding.
+	 */
+	val &= ~(HL_PRTC_IGMP_RPTLVE_FWD_MODE | HL_PRTC_IGMP_QRY_FWD_MODE |
+		 HL_PRTC_IGMP_UKN_FWD_MODE | HL_PRTC_MLD_RPTDONE_FWD_MODE |
+		 HL_PRTC_MLD_QRY_FWD_MODE);
+
+	return b53_write32(dev, B53_MGMT_PAGE, B53_HL_PRTC_CTRL, val);
+}
+EXPORT_SYMBOL(b53_enable_mcast_snooping);
+
 static void b53_enable_cpu_port(struct b53_device *dev, int port)
 {
 	u8 port_ctrl;
@@ -1159,6 +1212,10 @@ static int b53_setup(struct dsa_switch *ds)
 			b53_disable_port(ds, port);
 	}
 
+	ret = b53_enable_mcast_snooping(dev);
+	if (ret)
+		return ret;
+
 	return b53_setup_devlink_resources(ds);
 }
 
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 959a52d41f0a1..07a1c765f4cb9 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -319,6 +319,7 @@ static inline int b53_switch_get_reset_gpio(struct b53_device *dev)
 /* Exported functions towards other drivers */
 void b53_imp_vlan_setup(struct dsa_switch *ds, int cpu_port);
 int b53_configure_vlan(struct dsa_switch *ds);
+int b53_enable_mcast_snooping(struct b53_device *dev);
 void b53_get_strings(struct dsa_switch *ds, int port, u32 stringset,
 		     uint8_t *data);
 void b53_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *data);
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index 95f70248c194d..0b4343fcfcfd8 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -255,6 +255,23 @@
 /* Revision ID register (8 bit) */
 #define B53_REV_ID			0x40
 
+/* High-level protocol control (16 bit on BCM5395, otherwise 32 bit) */
+#define B53_HL_PRTC_CTRL			0x50
+#define   HL_PRTC_ICMPV6_EN		BIT(4)
+#define   HL_PRTC_ICMPV6_FWD_MODE		BIT(5)
+#define   HL_PRTC_IGMP_IP_EN_5395		BIT(6)
+#define   HL_PRTC_IGMP_FWD_MODE_5395	BIT(8)
+#define   HL_PRTC_IGMP_RPTLVE_EN		BIT(9)
+#define   HL_PRTC_IGMP_RPTLVE_FWD_MODE	BIT(10)
+#define   HL_PRTC_IGMP_QRY_EN		BIT(11)
+#define   HL_PRTC_IGMP_QRY_FWD_MODE	BIT(12)
+#define   HL_PRTC_IGMP_UKN_EN		BIT(13)
+#define   HL_PRTC_IGMP_UKN_FWD_MODE	BIT(14)
+#define   HL_PRTC_MLD_RPTDONE_EN		BIT(15)
+#define   HL_PRTC_MLD_RPTDONE_FWD_MODE	BIT(16)
+#define   HL_PRTC_MLD_QRY_EN		BIT(17)
+#define   HL_PRTC_MLD_QRY_FWD_MODE		BIT(18)
+
 /* Broadcom header RX control (16 bit) */
 #define B53_BRCM_HDR_RX_DIS		0x60
 
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 6105f4d8faf06..f7b2ef0f3df34 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1041,6 +1041,7 @@ static int bcm_sf2_sw_setup(struct dsa_switch *ds)
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	unsigned int port;
+	int ret;
 
 	/* Enable all valid ports and disable those unused */
 	for (port = 0; port < priv->hw_params.num_ports; port++) {
@@ -1056,6 +1057,10 @@ static int bcm_sf2_sw_setup(struct dsa_switch *ds)
 	b53_configure_vlan(ds);
 	bcm_sf2_enable_acb(ds);
 
+	ret = b53_enable_mcast_snooping(priv->dev);
+	if (ret)
+		return ret;
+
 	return b53_setup_devlink_resources(ds);
 }
 
-- 
2.53.0



