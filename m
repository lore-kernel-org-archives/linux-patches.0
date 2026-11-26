Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704276;
	b=ivZkIQpMnVpUYV1lcKXK1JXJStU/XLB4yG2vDk4T+2QO9zLBU889rYScuv/WWg5yv8XR
	 V0vskUHm+Wck0FqtHpaKn11AU6NFGyXccqWXY7XA/dC3orgweZKyldhG5kp/wVjkipiEF
	 lP3Q5ZO0vRpevarNMra9WV3jxv6qHHCHOgwpfWK4sU5X3hQBvyaqIYpbqd6g9Eh86eowU
	 LSE2RggBh4XHxiaUG9MIJ/PrmOQF721BRRUe1sHAX/rSdERGIR+ygKc48eaKCLTYFOWJR
	 3eJWcSImiDsnfpozLUPL4WYmKXatdi8pUAsw8RlrNp3e4xVuq705lDWjMKClqdlUwvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704276;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KZoo44mjjCqsvEfl8pUhkEqm93DGHgA3FL2eMIqAa1k=;
	b=ma2LPZUufl7gzswnYfuZulYi1ZFNSfyPpy+RSxKg++P7ch93vR6IazdXk09McwR/qfFw
	 ZU83yNOYQTwFcnE4NZ4wLA/bsf3asAn9kcnkvvDZMoKQwrWc5ZynVC/D2i5rvMzzqRYdI
	 G6U40eMC1RMjXgqZqg22tVHdtBy4LmDct5JbGehmHGKilX9hV5sB2qIptkqdK6ugnK+Wf
	 fQ6A9KzaNEUedF25iB+8cOSLycy9UCB3JuT7sOomYARJCs8aAENXA9CjXrx5KV1W4izDu
	 Qz3YRJE1/Y98YZY5VC4SpXZlZN+6jaFGszurlKyhfdqBMKR6CU9wWBJcTTfWpOeD+5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ahG/KNWG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C609A606A31C;
	Thu, 26 Nov 2026 14:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ahG/KNWG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2FF1F000C0;
	Thu, 26 Nov 2026 14:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704276;
	bh=KZoo44mjjCqsvEfl8pUhkEqm93DGHgA3FL2eMIqAa1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ahG/KNWGiB6FCyPja3o9413MfTmEUYWTMPwiMdUeUieFxktSH1Y+01yIhnXZFTxrQ
	 hasudZUuwcz5UdUaEmF5UAO0lghdrkcgtHEzB3BZQY1O9AenT11d9BQRqoYoRnkHL3
	 ATUOXuP+roy8bQV8fgjnZAt86LKzkYYWLHSL3LLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/265] net: dsa: b53: Enable IGMP and MLD control packet CPU copies
Date: Thu, 26 Nov 2026 15:36:37 +0100
Message-ID: <20261126143609.770049950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b80e4216f98c8..e975c1f627afd 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -669,6 +669,59 @@ void b53_brcm_hdr_setup(struct dsa_switch *ds, int port)
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
@@ -1095,6 +1148,10 @@ static int b53_setup(struct dsa_switch *ds)
 			b53_disable_port(ds, port);
 	}
 
+	ret = b53_enable_mcast_snooping(dev);
+	if (ret)
+		return ret;
+
 	return b53_setup_devlink_resources(ds);
 }
 
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index bdb2ade7ad622..4f011e80f577e 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -317,6 +317,7 @@ static inline int b53_switch_get_reset_gpio(struct b53_device *dev)
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
index 7c64317e0f191..7377729440e65 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -948,6 +948,7 @@ static int bcm_sf2_sw_setup(struct dsa_switch *ds)
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	unsigned int port;
+	int ret;
 
 	/* Enable all valid ports and disable those unused */
 	for (port = 0; port < priv->hw_params.num_ports; port++) {
@@ -963,6 +964,10 @@ static int bcm_sf2_sw_setup(struct dsa_switch *ds)
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



