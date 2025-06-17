Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA832FA638;
	Tue, 17 Jun 2025 16:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179076; cv=none; b=gHPiY0pSnMffGwIo7fltM6XOukWi8hOwxXL+p7TZ3Vk9FOa2GR/MASUgno/WYBZNCC7kRqfHxIInvmM5Mi5gcnFIDkSzPNfgjAbKkrP2EIY8Mvr01aeBaXjwSDI2eAcY8oWXfMF+VnpwICfazjcslV3DPprDWnf5jYzbf1EJNkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179076; c=relaxed/simple;
	bh=Z14TBM8loQ/nGpswZsHCYRKI+YfWFWC6DnI7ev2RQIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9kCtzP+LK+YdiqQAvgAeGLGtiqnOAYqnC5Py92SaU2l54bd+23bs1sEtsNs537bgsXepreYhktP5Mi+jmnO3B3oBgtBWPbG0BaN53hBpSTo8SXeYElRcVP0gmLh0TDX+Rl9hN8YT8m/iQIGGnFGXmUDo348/1ucTckEo6xM39Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrGQGqAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrGQGqAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C669C4CEE3;
	Tue, 17 Jun 2025 16:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179075;
	bh=Z14TBM8loQ/nGpswZsHCYRKI+YfWFWC6DnI7ev2RQIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrGQGqAxl5n8/5S7wW7cf38nrD10UVNCGq+TRT1OfQyaPnWcdvpokxiidfdunNASd
	 FdjKG5r3eH4uCZEIvYbDdTt+EGnef0/Vg5z7wa36RLbwHrGVxAelqIf2k2C+VHfmO3
	 qyzvLq3fR+HlyPUCxsXGo3TdRtU7T0GCyoT3b+RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 612/780] net: dsa: b53: implement setting ageing time
Date: Tue, 17 Jun 2025 17:25:20 +0200
Message-ID: <20250617152516.404503963@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit e39d14a760c039af0653e3df967e7525413924a0 ]

b53 supported switches support configuring ageing time between 1 and
1,048,575 seconds, so add an appropriate setter.

This allows b53 to pass the FDB learning test for both vlan aware and
vlan unaware bridges.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250510092211.276541-1-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 75f4f7b2b130 ("net: dsa: b53: do not configure bcm63xx's IMP port interface")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 28 ++++++++++++++++++++++++++++
 drivers/net/dsa/b53/b53_priv.h   |  1 +
 drivers/net/dsa/b53/b53_regs.h   |  7 +++++++
 drivers/net/dsa/bcm_sf2.c        |  1 +
 4 files changed, 37 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index ba70fbcc0f8bc..c186ee3fb28df 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -21,6 +21,7 @@
 #include <linux/export.h>
 #include <linux/gpio.h>
 #include <linux/kernel.h>
+#include <linux/math.h>
 #include <linux/module.h>
 #include <linux/platform_data/b53.h>
 #include <linux/phy.h>
@@ -1202,6 +1203,10 @@ static int b53_setup(struct dsa_switch *ds)
 	 */
 	ds->untag_vlan_aware_bridge_pvid = true;
 
+	/* Ageing time is set in seconds */
+	ds->ageing_time_min = 1 * 1000;
+	ds->ageing_time_max = AGE_TIME_MAX * 1000;
+
 	ret = b53_reset_switch(dev);
 	if (ret) {
 		dev_err(ds->dev, "failed to reset switch\n");
@@ -2392,6 +2397,28 @@ static int b53_get_max_mtu(struct dsa_switch *ds, int port)
 	return B53_MAX_MTU;
 }
 
+int b53_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
+{
+	struct b53_device *dev = ds->priv;
+	u32 atc;
+	int reg;
+
+	if (is63xx(dev))
+		reg = B53_AGING_TIME_CONTROL_63XX;
+	else
+		reg = B53_AGING_TIME_CONTROL;
+
+	atc = DIV_ROUND_CLOSEST(msecs, 1000);
+
+	if (!is5325(dev) && !is5365(dev))
+		atc |= AGE_CHANGE;
+
+	b53_write32(dev, B53_MGMT_PAGE, reg, atc);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(b53_set_ageing_time);
+
 static const struct phylink_mac_ops b53_phylink_mac_ops = {
 	.mac_select_pcs	= b53_phylink_mac_select_pcs,
 	.mac_config	= b53_phylink_mac_config,
@@ -2415,6 +2442,7 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.port_disable		= b53_disable_port,
 	.support_eee		= b53_support_eee,
 	.set_mac_eee		= b53_set_mac_eee,
+	.set_ageing_time	= b53_set_ageing_time,
 	.port_bridge_join	= b53_br_join,
 	.port_bridge_leave	= b53_br_leave,
 	.port_pre_bridge_flags	= b53_br_flags_pre,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 2cf3e6a81e378..a5ef7071ba07b 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -343,6 +343,7 @@ void b53_get_strings(struct dsa_switch *ds, int port, u32 stringset,
 void b53_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *data);
 int b53_get_sset_count(struct dsa_switch *ds, int port, int sset);
 void b53_get_ethtool_phy_stats(struct dsa_switch *ds, int port, uint64_t *data);
+int b53_set_ageing_time(struct dsa_switch *ds, unsigned int msecs);
 int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
 		bool *tx_fwd_offload, struct netlink_ext_ack *extack);
 void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge);
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index 5f7a0e5c5709d..1fbc5a204bc72 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -220,6 +220,13 @@
 #define   BRCM_HDR_P5_EN		BIT(1) /* Enable tagging on port 5 */
 #define   BRCM_HDR_P7_EN		BIT(2) /* Enable tagging on port 7 */
 
+/* Aging Time control register (32 bit) */
+#define B53_AGING_TIME_CONTROL		0x06
+#define B53_AGING_TIME_CONTROL_63XX	0x08
+#define  AGE_CHANGE			BIT(20)
+#define  AGE_TIME_MASK			0x7ffff
+#define  AGE_TIME_MAX			1048575
+
 /* Mirror capture control register (16 bit) */
 #define B53_MIR_CAP_CTL			0x10
 #define  CAP_PORT_MASK			0xf
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 454a8c7fd7eea..960685596093b 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1235,6 +1235,7 @@ static const struct dsa_switch_ops bcm_sf2_ops = {
 	.port_disable		= bcm_sf2_port_disable,
 	.support_eee		= b53_support_eee,
 	.set_mac_eee		= b53_set_mac_eee,
+	.set_ageing_time	= b53_set_ageing_time,
 	.port_bridge_join	= b53_br_join,
 	.port_bridge_leave	= b53_br_leave,
 	.port_pre_bridge_flags	= b53_br_flags_pre,
-- 
2.39.5



