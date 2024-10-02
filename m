Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3414A1D04B4;
	Wed,  2 Oct 2024 14:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880583; cv=none; b=rl6aL43ft3Oovi60XiEBLFBbcasfpQTDx6CEL+SVqArtf8jjVgWJeLWdewSVyLuWfMkK0pM7egx+vgIaUmHKH/ON/NqAC6UoSRdmBcRI2QCGjINpzwY76gbWwFDZJTM11UumQBG/I4U4Mqmx+FZH1P2kMD3xmcgz5efKUbR9oFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880583; c=relaxed/simple;
	bh=/1aLaJdkVeA9u2aK2dvcCIpzkmz9HhQKWjLJTrv+ddc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5c+wQmtWoTxZcxgzDXYurc7v9iGv+IjlFOa1B3sHjepZPSGBqwzMIOtqHpKBd7HMswhIFjh1+SnJqDg4kqDaFq8vK9S0SX3og7QgoZ3HCUd7NFp2CAwtjteBV8rRLVQTxm6rioFeVROvOFRlI8GlNnA8Z8H4Wrng6GZQlvgcGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QiFaGb8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QiFaGb8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B007AC4CEC2;
	Wed,  2 Oct 2024 14:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880583;
	bh=/1aLaJdkVeA9u2aK2dvcCIpzkmz9HhQKWjLJTrv+ddc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QiFaGb8AtYi2LKPYXcl1C7iMH/Q7H5YBZmKRIeel8XrJZ+DaYaH1NFDDEw+lh5R21
	 ONJTRavO8k4Vsc82Q6h3kyK2KqQrqT2QKy9vpJs8WLW6COI/VzmO7dUf3yclTMKLBi
	 DxEz9jv3HHJHA3JcGdURwb+eHvFs/Zde5wImkugc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Qin Wan <qin.wan@hp.com>,
	Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Subject: [PATCH 6.6 509/538] thunderbolt: Change bandwidth reservations to comply USB4 v2
Date: Wed,  2 Oct 2024 15:02:28 +0200
Message-ID: <20241002125812.534814359@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Gil Fine <gil.fine@linux.intel.com>

[ Upstream commit 582e70b0d3a412d15389a3c9c07a44791b311715 ]

USB4 v2 Connection Manager guide (section 6.1.2.3) suggests to reserve
bandwidth in a sligthly different manner. It suggests to keep minimum of
1500 Mb/s for each path that carry a bulk traffic. Here we change the
bandwidth reservations to comply to the above for USB 3.x and PCIe
protocols over Gen 4 link, taking weights into account (that's 1500 Mb/s
for PCIe and 3000 Mb/s for USB 3.x).

For Gen 3 and below we use the existing reservation.

Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Qin Wan <qin.wan@hp.com>
Signed-off-by: Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.c     |   11 +++++++
 drivers/thunderbolt/tunnel.c |   66 +++++++++++++++++++++++++++++++++++++++++--
 drivers/thunderbolt/tunnel.h |    2 +
 3 files changed, 76 insertions(+), 3 deletions(-)

--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -602,6 +602,7 @@ static int tb_available_bandwidth(struct
 	/* Find the minimum available bandwidth over all links */
 	tb_for_each_port_on_path(src_port, dst_port, port) {
 		int link_speed, link_width, up_bw, down_bw;
+		int pci_reserved_up, pci_reserved_down;
 
 		if (!tb_port_is_null(port))
 			continue;
@@ -695,6 +696,16 @@ static int tb_available_bandwidth(struct
 		up_bw -= usb3_consumed_up;
 		down_bw -= usb3_consumed_down;
 
+		/*
+		 * If there is anything reserved for PCIe bulk traffic
+		 * take it into account here too.
+		 */
+		if (tb_tunnel_reserved_pci(port, &pci_reserved_up,
+					   &pci_reserved_down)) {
+			up_bw -= pci_reserved_up;
+			down_bw -= pci_reserved_down;
+		}
+
 		if (up_bw < *available_up)
 			*available_up = up_bw;
 		if (down_bw < *available_down)
--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -31,7 +31,7 @@
 #define TB_USB3_PATH_UP			1
 
 #define TB_USB3_PRIORITY		3
-#define TB_USB3_WEIGHT			3
+#define TB_USB3_WEIGHT			2
 
 /* DP adapters use HopID 8 for AUX and 9 for Video */
 #define TB_DP_AUX_TX_HOPID		8
@@ -61,6 +61,15 @@
 #define TB_DMA_PRIORITY			5
 #define TB_DMA_WEIGHT			1
 
+/*
+ * Reserve additional bandwidth for USB 3.x and PCIe bulk traffic
+ * according to USB4 v2 Connection Manager guide. This ends up reserving
+ * 1500 Mb/s for PCIe and 3000 Mb/s for USB 3.x taking weights into
+ * account.
+ */
+#define USB4_V2_PCI_MIN_BANDWIDTH	(1500 * TB_PCI_WEIGHT)
+#define USB4_V2_USB3_MIN_BANDWIDTH	(1500 * TB_USB3_WEIGHT)
+
 static unsigned int dma_credits = TB_DMA_CREDITS;
 module_param(dma_credits, uint, 0444);
 MODULE_PARM_DESC(dma_credits, "specify custom credits for DMA tunnels (default: "
@@ -150,11 +159,11 @@ static struct tb_tunnel *tb_tunnel_alloc
 
 static int tb_pci_set_ext_encapsulation(struct tb_tunnel *tunnel, bool enable)
 {
+	struct tb_port *port = tb_upstream_port(tunnel->dst_port->sw);
 	int ret;
 
 	/* Only supported of both routers are at least USB4 v2 */
-	if (usb4_switch_version(tunnel->src_port->sw) < 2 ||
-	    usb4_switch_version(tunnel->dst_port->sw) < 2)
+	if (tb_port_get_link_generation(port) < 4)
 		return 0;
 
 	ret = usb4_pci_port_set_ext_encapsulation(tunnel->src_port, enable);
@@ -370,6 +379,51 @@ err_free:
 	return NULL;
 }
 
+/**
+ * tb_tunnel_reserved_pci() - Amount of bandwidth to reserve for PCIe
+ * @port: Lane 0 adapter
+ * @reserved_up: Upstream bandwidth in Mb/s to reserve
+ * @reserved_down: Downstream bandwidth in Mb/s to reserve
+ *
+ * Can be called to any connected lane 0 adapter to find out how much
+ * bandwidth needs to be left in reserve for possible PCIe bulk traffic.
+ * Returns true if there is something to be reserved and writes the
+ * amount to @reserved_down/@reserved_up. Otherwise returns false and
+ * does not touch the parameters.
+ */
+bool tb_tunnel_reserved_pci(struct tb_port *port, int *reserved_up,
+			    int *reserved_down)
+{
+	if (WARN_ON_ONCE(!port->remote))
+		return false;
+
+	if (!tb_acpi_may_tunnel_pcie())
+		return false;
+
+	if (tb_port_get_link_generation(port) < 4)
+		return false;
+
+	/* Must have PCIe adapters */
+	if (tb_is_upstream_port(port)) {
+		if (!tb_switch_find_port(port->sw, TB_TYPE_PCIE_UP))
+			return false;
+		if (!tb_switch_find_port(port->remote->sw, TB_TYPE_PCIE_DOWN))
+			return false;
+	} else {
+		if (!tb_switch_find_port(port->sw, TB_TYPE_PCIE_DOWN))
+			return false;
+		if (!tb_switch_find_port(port->remote->sw, TB_TYPE_PCIE_UP))
+			return false;
+	}
+
+	*reserved_up = USB4_V2_PCI_MIN_BANDWIDTH;
+	*reserved_down = USB4_V2_PCI_MIN_BANDWIDTH;
+
+	tb_port_dbg(port, "reserving %u/%u Mb/s for PCIe\n", *reserved_up,
+		    *reserved_down);
+	return true;
+}
+
 static bool tb_dp_is_usb4(const struct tb_switch *sw)
 {
 	/* Titan Ridge DP adapters need the same treatment as USB4 */
@@ -1747,6 +1801,7 @@ static int tb_usb3_activate(struct tb_tu
 static int tb_usb3_consumed_bandwidth(struct tb_tunnel *tunnel,
 		int *consumed_up, int *consumed_down)
 {
+	struct tb_port *port = tb_upstream_port(tunnel->dst_port->sw);
 	int pcie_weight = tb_acpi_may_tunnel_pcie() ? TB_PCI_WEIGHT : 0;
 
 	/*
@@ -1758,6 +1813,11 @@ static int tb_usb3_consumed_bandwidth(st
 	*consumed_down = tunnel->allocated_down *
 		(TB_USB3_WEIGHT + pcie_weight) / TB_USB3_WEIGHT;
 
+	if (tb_port_get_link_generation(port) >= 4) {
+		*consumed_up = max(*consumed_up, USB4_V2_USB3_MIN_BANDWIDTH);
+		*consumed_down = max(*consumed_down, USB4_V2_USB3_MIN_BANDWIDTH);
+	}
+
 	return 0;
 }
 
--- a/drivers/thunderbolt/tunnel.h
+++ b/drivers/thunderbolt/tunnel.h
@@ -80,6 +80,8 @@ struct tb_tunnel *tb_tunnel_discover_pci
 					 bool alloc_hopid);
 struct tb_tunnel *tb_tunnel_alloc_pci(struct tb *tb, struct tb_port *up,
 				      struct tb_port *down);
+bool tb_tunnel_reserved_pci(struct tb_port *port, int *reserved_up,
+			    int *reserved_down);
 struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in,
 					bool alloc_hopid);
 struct tb_tunnel *tb_tunnel_alloc_dp(struct tb *tb, struct tb_port *in,


