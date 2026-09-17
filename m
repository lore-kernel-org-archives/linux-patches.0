Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5B44E4C5D;
	Thu, 17 Sep 2026 16:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661334; cv=none; b=VO2DusvYlD0tz9gxIYwaqFsTuVIzlJWhbiIw3v0KzPGQe7krRt/63QR1NpH+6/mgRnGj5Y7p46u40SzKiSZJCQucAVICBJ7y0TGWEoJ6Wgw+msosQ5uja+wWnOdrcu3CRO9J+VKje+2gAwStib8/8Pt20M01i1EBdkx/abj4gi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661334; c=relaxed/simple;
	bh=eAzMkf9BKjzrhzMH6VA3wQxASoJCbuU3C4scLh/rhPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0DxGJURSc2NGzN/7oe6baMyVHO1e6i3OBXt3168Q7WMCV6ii4IetqWlCWSWrCQ4RBiYg1zqvSUWKTS+ubpFnBCOb/2hNN1vfO6//dmjHso/m+xnsnVKUD3AtGsTiM4DG8iZgEzxDbGGfJhkZTJrBW3TJOl8Aq1RY9K1M2QIQxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wP3BPBDp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wP3BPBDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235AC1F000FF;
	Thu, 17 Sep 2026 16:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661332;
	bh=vROSEBsJis/0dHX/y5cXAAkg1sCxEzy2Z/FtXOEdWvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wP3BPBDpFUIrIMHdtfUgXPD4+AvOWS5AbHlMm886Y39Kp8ZXcgVbreoIlpStXN1JU
	 PDYevko3lDZB6vGXbWEWoxLNYvhU2485rod1SkfmkaZXaSyKPNwisinIltXJ2OxfsK
	 bWZAmL8o/LB1LpZAV5fRJfsNnhYGMrPgm8TYHGVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0159/1250] thunderbolt: Verify PCIe adapter in detect state before tunnel setup
Date: Thu, 17 Sep 2026 15:59:14 +0100
Message-ID: <20260917151556.390810543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gil Fine <gil.fine@linux.intel.com>

[ Upstream commit 69a7b98770b7e80deec0465d97710611a0e51774 ]

The USB4 Connection Manager guide suggests that a PCIe downstream and
PCIe upstream adapters of the USB4 router is in the Detect state before
setting up a PCIe tunnel.

Add this check by verifying the LTSSM field in ADP_PCIE_CS_0 before
tunnel setup.

Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/tb.h      |  1 +
 drivers/thunderbolt/tb_regs.h | 15 +++++++++++++++
 drivers/thunderbolt/tunnel.c  | 35 +++++++++++++++++++++++++++++++++++
 drivers/thunderbolt/usb4.c    | 24 ++++++++++++++++++++++++
 4 files changed, 75 insertions(+)

diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index 8e2762ff8d517..775ed48cc299a 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -1478,6 +1478,7 @@ int usb4_dp_port_allocate_bandwidth(struct tb_port *port, int bw);
 int usb4_dp_port_requested_bandwidth(struct tb_port *port);
 
 int usb4_pci_port_set_ext_encapsulation(struct tb_port *port, bool enable);
+int usb4_pci_port_ltssm_state(struct tb_port *port);
 
 static inline bool tb_is_usb4_port_device(const struct device *dev)
 {
diff --git a/drivers/thunderbolt/tb_regs.h b/drivers/thunderbolt/tb_regs.h
index 4e43b47f9f119..97404d8d878bf 100644
--- a/drivers/thunderbolt/tb_regs.h
+++ b/drivers/thunderbolt/tb_regs.h
@@ -473,10 +473,25 @@ struct tb_regs_port_header {
 
 /* PCIe adapter registers */
 #define ADP_PCIE_CS_0				0x00
+#define ADP_PCIE_CS_0_LTSSM_MASK		GENMASK(28, 25)
 #define ADP_PCIE_CS_0_PE			BIT(31)
 #define ADP_PCIE_CS_1				0x01
 #define ADP_PCIE_CS_1_EE			BIT(0)
 
+enum tb_pcie_ltssm_state {
+	USB4_PCIE_LTSSM_DETECT,
+	USB4_PCIE_LTSSM_POLLING,
+	USB4_PCIE_LTSSM_CONFIG,
+	USB4_PCIE_LTSSM_CONFIG_IDLE,
+	USB4_PCIE_LTSSM_RECOVERY,
+	USB4_PCIE_LTSSM_RECOVERY_IDLE,
+	USB4_PCIE_LTSSM_L0,
+	USB4_PCIE_LTSSM_L1,
+	USB4_PCIE_LTSSM_L2,
+	USB4_PCIE_LTSSM_DISABLED,
+	USB4_PCIE_LTSSM_HOT_RESET,
+};
+
 /* USB adapter registers */
 #define ADP_USB3_CS_0				0x00
 #define ADP_USB3_CS_0_V				BIT(30)
diff --git a/drivers/thunderbolt/tunnel.c b/drivers/thunderbolt/tunnel.c
index bfa0607b55744..6066355388b7f 100644
--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -296,6 +296,40 @@ static inline void tb_tunnel_changed(struct tb_tunnel *tunnel)
 			tunnel->src_port, tunnel->dst_port);
 }
 
+static int tb_pci_port_ltssm_state_detect(struct tb_port *port)
+{
+	ktime_t timeout = ktime_add_ms(ktime_get(), 500);
+
+	do {
+		int ret;
+
+		ret = usb4_pci_port_ltssm_state(port);
+		if (ret < 0)
+			return ret;
+		if (ret == USB4_PCIE_LTSSM_DETECT)
+			return 0;
+
+		fsleep(50);
+	} while (ktime_before(ktime_get(), timeout));
+
+	return -ETIMEDOUT;
+}
+
+static int tb_pci_pre_activate(struct tb_tunnel *tunnel)
+{
+	struct tb_port *down = tunnel->src_port;
+	struct tb_port *up = tunnel->dst_port;
+	int ret;
+
+	ret = tb_switch_is_usb4(down->sw) ?
+		tb_pci_port_ltssm_state_detect(down) : 0;
+	if (ret)
+		return ret;
+
+	return tb_switch_is_usb4(up->sw) ?
+		tb_pci_port_ltssm_state_detect(up) : 0;
+}
+
 static int tb_pci_set_ext_encapsulation(struct tb_tunnel *tunnel, bool enable)
 {
 	struct tb_port *port = tb_upstream_port(tunnel->dst_port->sw);
@@ -511,6 +545,7 @@ struct tb_tunnel *tb_tunnel_alloc_pci(struct tb *tb, struct tb_port *up,
 	if (!tunnel)
 		return NULL;
 
+	tunnel->pre_activate = tb_pci_pre_activate;
 	tunnel->activate = tb_pci_activate;
 	tunnel->src_port = down;
 	tunnel->dst_port = up;
diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
index 76f01713a8754..276c25c7d37e6 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -3145,3 +3145,27 @@ int usb4_pci_port_set_ext_encapsulation(struct tb_port *port, bool enable)
 	return tb_port_write(port, &val, TB_CFG_PORT,
 			     port->cap_adap + ADP_PCIE_CS_1, 1);
 }
+
+/**
+ * usb4_pci_port_ltssm_state() - Read PCIe adapter LTSSM state
+ * @port: PCIe adapter
+ *
+ * Return:
+ * * LTSSM state of @port.
+ * * Negative errno - On failure.
+ */
+int usb4_pci_port_ltssm_state(struct tb_port *port)
+{
+	u32 val;
+	int ret;
+
+	if (!tb_port_is_pcie_down(port) && !tb_port_is_pcie_up(port))
+		return -EINVAL;
+
+	ret = tb_port_read(port, &val, TB_CFG_PORT,
+			   port->cap_adap + ADP_PCIE_CS_0, 1);
+	if (ret)
+		return ret;
+
+	return FIELD_GET(ADP_PCIE_CS_0_LTSSM_MASK, val);
+}
-- 
2.53.0



