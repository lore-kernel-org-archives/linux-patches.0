Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354AB143889;
	Tue, 23 Apr 2024 21:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908493; cv=none; b=I0W8X/Vl+XYka9HGWxepfzUhwe5wbsHAD9vN7GZuDiFv4sx7/idhdb4aYdeYVYVY6brrUvVdd3MmtIxi+2qyBCzcax1sPmTD8L9oYzJz9x7LIEFm9fL+hECNGlfIgrdpdqYdODBrE7U6z/90V2ymirBEFBt4wnXf7NMFEZdJFq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908493; c=relaxed/simple;
	bh=Ei7pTV09aG8RHGMbCJzgdcLqkT2k2TrE8f6ADZiccJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhwdRPWR1QOTGn/Bgb7ivElqh8nrg5KEwVVTX4x3shOL7W+vgw13AxV28Ls4qhIs/mYn7vwnXEXTGWhLLedc9MH3Mbcic3HdtW+hndiYw2EMmTJDjHOdweJj1gaGQbDzdL1WNe/QJAufX4aGuWVeziGORi59EH3ss1ZrBCgkn10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvpBZdvj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvpBZdvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00217C3277B;
	Tue, 23 Apr 2024 21:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908493;
	bh=Ei7pTV09aG8RHGMbCJzgdcLqkT2k2TrE8f6ADZiccJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvpBZdvjBmE79eQGCJgkdmqD2s7MTrav9i3qdoFyfwL7c6x0eky2DajVzPQMFgiq/
	 F1DWcab1Tk6qVf7+bb5BO+3goqFd3ysDF0UB89igbDuzTeRwisXXTqRrmE2ZvvgP0A
	 YO7JVqNIwMA9pGF7w4Po3HRVZ5W0XiJmsf487qt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanath S <Sanath.S@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.8 069/158] thunderbolt: Make tb_switch_reset() support Thunderbolt 2, 3 and USB4 routers
Date: Tue, 23 Apr 2024 14:38:11 -0700
Message-ID: <20240423213858.205362964@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanath S <Sanath.S@amd.com>

commit ec8162b3f0683ae08a21f20517cf49272b07ee0b upstream.

Currently tb_switch_reset() only did something for Thunderbolt 1
devices. Expand this to support all generations, including USB4, and
both host and device routers.

Signed-off-by: Sanath S <Sanath.S@amd.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c  |  123 +++++++++++++++++++++++++++++++++++++-----
 drivers/thunderbolt/tb_regs.h |    2 
 2 files changed, 111 insertions(+), 14 deletions(-)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -1541,29 +1541,124 @@ static void tb_dump_switch(const struct
 	       regs->__unknown1, regs->__unknown4);
 }
 
+static int tb_switch_reset_host(struct tb_switch *sw)
+{
+	if (sw->generation > 1) {
+		struct tb_port *port;
+
+		tb_switch_for_each_port(sw, port) {
+			int i, ret;
+
+			/*
+			 * For lane adapters we issue downstream port
+			 * reset and clear up path config spaces.
+			 *
+			 * For protocol adapters we disable the path and
+			 * clear path config space one by one (from 8 to
+			 * Max Input HopID of the adapter).
+			 */
+			if (tb_port_is_null(port) && !tb_is_upstream_port(port)) {
+				ret = tb_port_reset(port);
+				if (ret)
+					return ret;
+			} else if (tb_port_is_usb3_down(port) ||
+				   tb_port_is_usb3_up(port)) {
+				tb_usb3_port_enable(port, false);
+			} else if (tb_port_is_dpin(port) ||
+				   tb_port_is_dpout(port)) {
+				tb_dp_port_enable(port, false);
+			} else if (tb_port_is_pcie_down(port) ||
+				   tb_port_is_pcie_up(port)) {
+				tb_pci_port_enable(port, false);
+			} else {
+				continue;
+			}
+
+			/* Cleanup path config space of protocol adapter */
+			for (i = TB_PATH_MIN_HOPID;
+			     i <= port->config.max_in_hop_id; i++) {
+				ret = tb_path_deactivate_hop(port, i);
+				if (ret)
+					return ret;
+			}
+		}
+	} else {
+		struct tb_cfg_result res;
+
+		/* Thunderbolt 1 uses the "reset" config space packet */
+		res.err = tb_sw_write(sw, ((u32 *) &sw->config) + 2,
+				      TB_CFG_SWITCH, 2, 2);
+		if (res.err)
+			return res.err;
+		res = tb_cfg_reset(sw->tb->ctl, tb_route(sw));
+		if (res.err > 0)
+			return -EIO;
+		else if (res.err < 0)
+			return res.err;
+	}
+
+	return 0;
+}
+
+static int tb_switch_reset_device(struct tb_switch *sw)
+{
+	return tb_port_reset(tb_switch_downstream_port(sw));
+}
+
+static bool tb_switch_enumerated(struct tb_switch *sw)
+{
+	u32 val;
+	int ret;
+
+	/*
+	 * Read directly from the hardware because we use this also
+	 * during system sleep where sw->config.enabled is already set
+	 * by us.
+	 */
+	ret = tb_sw_read(sw, &val, TB_CFG_SWITCH, ROUTER_CS_3, 1);
+	if (ret)
+		return false;
+
+	return !!(val & ROUTER_CS_3_V);
+}
+
 /**
- * tb_switch_reset() - reconfigure route, enable and send TB_CFG_PKG_RESET
- * @sw: Switch to reset
+ * tb_switch_reset() - Perform reset to the router
+ * @sw: Router to reset
+ *
+ * Issues reset to the router @sw. Can be used for any router. For host
+ * routers, resets all the downstream ports and cleans up path config
+ * spaces accordingly. For device routers issues downstream port reset
+ * through the parent router, so as side effect there will be unplug
+ * soon after this is finished.
+ *
+ * If the router is not enumerated does nothing.
  *
- * Return: Returns 0 on success or an error code on failure.
+ * Returns %0 on success or negative errno in case of failure.
  */
 int tb_switch_reset(struct tb_switch *sw)
 {
-	struct tb_cfg_result res;
+	int ret;
 
-	if (sw->generation > 1)
+	/*
+	 * We cannot access the port config spaces unless the router is
+	 * already enumerated. If the router is not enumerated it is
+	 * equal to being reset so we can skip that here.
+	 */
+	if (!tb_switch_enumerated(sw))
 		return 0;
 
-	tb_sw_dbg(sw, "resetting switch\n");
+	tb_sw_dbg(sw, "resetting\n");
+
+	if (tb_route(sw))
+		ret = tb_switch_reset_device(sw);
+	else
+		ret = tb_switch_reset_host(sw);
+
+	if (ret)
+		tb_sw_warn(sw, "failed to reset\n");
 
-	res.err = tb_sw_write(sw, ((u32 *) &sw->config) + 2,
-			      TB_CFG_SWITCH, 2, 2);
-	if (res.err)
-		return res.err;
-	res = tb_cfg_reset(sw->tb->ctl, tb_route(sw));
-	if (res.err > 0)
-		return -EIO;
-	return res.err;
+	return ret;
 }
 
 /**
--- a/drivers/thunderbolt/tb_regs.h
+++ b/drivers/thunderbolt/tb_regs.h
@@ -194,6 +194,8 @@ struct tb_regs_switch_header {
 #define USB4_VERSION_MAJOR_MASK			GENMASK(7, 5)
 
 #define ROUTER_CS_1				0x01
+#define ROUTER_CS_3				0x03
+#define ROUTER_CS_3_V				BIT(31)
 #define ROUTER_CS_4				0x04
 /* Used with the router cmuv field */
 #define ROUTER_CS_4_CMUV_V1			0x10


