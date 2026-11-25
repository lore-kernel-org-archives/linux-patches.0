Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621436;
	b=j7AURPb6GqrQI9i1P88LQ2cjC4ziWh9P07zofTHmIc+08Bxxh0TUh1ywEdVB1+sTCGHI
	 4cdowssS3NfusFb1OwlkrmsyqxLUivl7GLu8+E0Ghx8wFMnpXyW7ZvNgSN0sRFtgiX3A+
	 f+k8cL82N07R2n8GZ+jcgGbTsrTSqzSAYj//HaE/e464NtSnHyXP8CaEg47YeCkyf5yHI
	 jRAEZpTJcXfeNOfY/cW3Q063j2/Ff8xw5VKtxnr2FiTdce6hoAO7y/28tPuMLpMOsPOK6
	 IEspUlUOhuM4K3agh/acbiMIXaurOEVi4UOktafZ5OkVEKs51xsGSz49q3hmXlgWRAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lGfYTz6MKwlNhpMvNHaCDX7Rv6+rUb7bZXidAHCDJNs=;
	b=b2rW+V9mn8dwnNiDxqDMxQr9TOlIOOsjqfW+5yNYIhltVsD+sD7BAf/YTctnnfpTTag3
	 c2r+rjHyiFo1TcaHRx7gBIKajxwePuLiTR6iwFTzGl/mz7p57aisB2cxbRrr6hV9Hm2av
	 HzLS2IEtdinG73fB7ht5Ivz/hjk5EP2PYtgpYW0nF2Kmy11dJ1bCpW7Y4+a2ux6h5JKcq
	 e022JT9x8div9jpbbs0zx+odEU5aiGMc1pDprO1MtPyUeFPuIGwRjSbVzx4XsISv0KUhI
	 6MXEmKgciXtT3uJkrPrvd6tN3rG0NkoI5sJLbDlhqiFXbyuIb4dXxVqFvUt2h/PgLtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LQ3s0gPf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8E9606A333;
	Wed, 25 Nov 2026 15:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LQ3s0gPf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27531F000D0;
	Wed, 25 Nov 2026 15:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621435;
	bh=lGfYTz6MKwlNhpMvNHaCDX7Rv6+rUb7bZXidAHCDJNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQ3s0gPfy325Llk0Y5svd21y5VuWI8Mu8LZENZdjiVIehF6FhN0dCwYGNhD1/jckN
	 mNnrCl5LabyzcjzsIZR6Xu85vfORPETUhs2TQMtJlUpUnqADFXtixXeGxZ11IeVrnG
	 DZqVpM+exQK9Ayd6aFZFu5XXl5ckLelENtJLw51w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 225/990] net: dsa: b53: Enable IGMP and MLD control packet CPU copies
Date: Wed, 25 Nov 2026 15:26:32 +0100
Message-ID: <20261125143827.359582878@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 508b46237011d..af73a9f70773d 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -816,6 +816,59 @@ void b53_brcm_hdr_setup(struct dsa_switch *ds, int port)
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
@@ -1316,6 +1369,10 @@ static int b53_setup(struct dsa_switch *ds)
 			b53_disable_port(ds, port);
 	}
 
+	ret = b53_enable_mcast_snooping(dev);
+	if (ret)
+		return ret;
+
 	return b53_setup_devlink_resources(ds);
 }
 
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index bd6849e5bb939..dce06110deb8b 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -490,6 +490,7 @@ static inline int b53_switch_get_reset_gpio(struct b53_device *dev)
 /* Exported functions towards other drivers */
 void b53_imp_vlan_setup(struct dsa_switch *ds, int cpu_port);
 int b53_configure_vlan(struct dsa_switch *ds);
+int b53_enable_mcast_snooping(struct b53_device *dev);
 void b53_get_strings(struct dsa_switch *ds, int port, u32 stringset,
 		     uint8_t *data);
 void b53_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *data);
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index b6fe7d207a2c1..a9414851ea287 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -270,6 +270,23 @@
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
index de3efa3ce9a75..f3b56ea87b07b 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1059,6 +1059,7 @@ static int bcm_sf2_sw_setup(struct dsa_switch *ds)
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	unsigned int port;
+	int ret;
 
 	/* Enable all valid ports and disable those unused */
 	for (port = 0; port < priv->hw_params.num_ports; port++) {
@@ -1074,6 +1075,10 @@ static int bcm_sf2_sw_setup(struct dsa_switch *ds)
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



