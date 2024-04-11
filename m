Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27701448EF;
	Thu, 11 Apr 2024 10:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830348; cv=none; b=rxg8GdcvIwLAfb+gItnVEwFDDEVfit5OT5HpxoSehUFPu6kF7ytUmhhddmwHE1YFyj0qUhsn4I2xtjU4YDQKGwktgUiKkyYf2NqRFI0oNOT1SU3mM9emyXCGPT5wpHRNUHSQg7NZ6HF00nQNlQS85tDiGzP5YqB/JjfXs5CqUy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830348; c=relaxed/simple;
	bh=LKEXAVKzl4TOuqB8sbvxnMqOnQIOhKCZKZlG2kXM7Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOyrJ/fyrCnuq1bWUAkoXV9i3EvcJvyIxkWjjG7QqCuyHPWeVMBxOUBS7NqpLbGGab5wYcdJt45Lg09wCwRTec1yLjDAm2ktLch+tVZKmTbHJYpHPoayp71Sny1ZwCITznlZlO+5Dwa2I5lrEJu4tsDEiVPl/qhlW3RuYYeUxMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4GWo/DM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4GWo/DM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466A9C433C7;
	Thu, 11 Apr 2024 10:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830348;
	bh=LKEXAVKzl4TOuqB8sbvxnMqOnQIOhKCZKZlG2kXM7Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4GWo/DMMHuRyzlYCDA84w7SXuRtmh//JJRM05d2C7/BBZgaKaJgTtEMhPyO3QG0K
	 qJejhG/pXyDiJPlDTBqNXlTkNUX1TtUvWyys3Hhc/McjD64EU4ZdiAQ1a+rsrDCDLC
	 knkvHvuwnCBzoP+0lhE4nWTH8HZPlNJWmmRvnk5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 117/143] thunderbolt: Keep the domain powered when USB4 port is in redrive mode
Date: Thu, 11 Apr 2024 11:56:25 +0200
Message-ID: <20240411095424.428475081@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit a75e0684efe567ae5f6a8e91a8360c4c1773cf3a ]

If a DiplayPort cable is directly connected to the host routers USB4
port, there is no tunnel involved but the port is in "redrive" mode
meaning that it is re-driving the DisplayPort signals from its
DisplayPort source. In this case we need to keep the domain powered on
otherwise once the domain enters D3cold the connected monitor blanks
too.

Since this happens only on Intel Barlow Ridge add a quirk that takes
runtime PM reference if we detect that the USB4 port entered redrive
mode (and release it once it exits the mode).

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/quirks.c | 14 +++++++++++
 drivers/thunderbolt/tb.c     | 49 +++++++++++++++++++++++++++++++++++-
 drivers/thunderbolt/tb.h     |  4 +++
 3 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/quirks.c b/drivers/thunderbolt/quirks.c
index e6bfa63b40aee..e81de9c30eac9 100644
--- a/drivers/thunderbolt/quirks.c
+++ b/drivers/thunderbolt/quirks.c
@@ -43,6 +43,12 @@ static void quirk_usb3_maximum_bandwidth(struct tb_switch *sw)
 	}
 }
 
+static void quirk_block_rpm_in_redrive(struct tb_switch *sw)
+{
+	sw->quirks |= QUIRK_KEEP_POWER_IN_DP_REDRIVE;
+	tb_sw_dbg(sw, "preventing runtime PM in DP redrive mode\n");
+}
+
 struct tb_quirk {
 	u16 hw_vendor_id;
 	u16 hw_device_id;
@@ -86,6 +92,14 @@ static const struct tb_quirk tb_quirks[] = {
 		  quirk_usb3_maximum_bandwidth },
 	{ 0x8087, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HUB_40G_BRIDGE, 0x0000, 0x0000,
 		  quirk_usb3_maximum_bandwidth },
+	/*
+	 * Block Runtime PM in DP redrive mode for Intel Barlow Ridge host
+	 * controllers.
+	 */
+	{ 0x8087, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_80G_NHI, 0x0000, 0x0000,
+		  quirk_block_rpm_in_redrive },
+	{ 0x8087, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_40G_NHI, 0x0000, 0x0000,
+		  quirk_block_rpm_in_redrive },
 	/*
 	 * CLx is not supported on AMD USB4 Yellow Carp and Pink Sardine platforms.
 	 */
diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index 846d2813bb1a5..e6681f153c69d 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -1887,6 +1887,49 @@ static void tb_tunnel_dp(struct tb *tb)
 		;
 }
 
+static void tb_enter_redrive(struct tb_port *port)
+{
+	struct tb_switch *sw = port->sw;
+
+	if (!(sw->quirks & QUIRK_KEEP_POWER_IN_DP_REDRIVE))
+		return;
+
+	/*
+	 * If we get hot-unplug for the DP IN port of the host router
+	 * and the DP resource is not available anymore it means there
+	 * is a monitor connected directly to the Type-C port and we are
+	 * in "redrive" mode. For this to work we cannot enter RTD3 so
+	 * we bump up the runtime PM reference count here.
+	 */
+	if (!tb_port_is_dpin(port))
+		return;
+	if (tb_route(sw))
+		return;
+	if (!tb_switch_query_dp_resource(sw, port)) {
+		port->redrive = true;
+		pm_runtime_get(&sw->dev);
+		tb_port_dbg(port, "enter redrive mode, keeping powered\n");
+	}
+}
+
+static void tb_exit_redrive(struct tb_port *port)
+{
+	struct tb_switch *sw = port->sw;
+
+	if (!(sw->quirks & QUIRK_KEEP_POWER_IN_DP_REDRIVE))
+		return;
+
+	if (!tb_port_is_dpin(port))
+		return;
+	if (tb_route(sw))
+		return;
+	if (port->redrive && tb_switch_query_dp_resource(sw, port)) {
+		port->redrive = false;
+		pm_runtime_put(&sw->dev);
+		tb_port_dbg(port, "exit redrive mode\n");
+	}
+}
+
 static void tb_dp_resource_unavailable(struct tb *tb, struct tb_port *port)
 {
 	struct tb_port *in, *out;
@@ -1903,7 +1946,10 @@ static void tb_dp_resource_unavailable(struct tb *tb, struct tb_port *port)
 	}
 
 	tunnel = tb_find_tunnel(tb, TB_TUNNEL_DP, in, out);
-	tb_deactivate_and_free_tunnel(tunnel);
+	if (tunnel)
+		tb_deactivate_and_free_tunnel(tunnel);
+	else
+		tb_enter_redrive(port);
 	list_del_init(&port->list);
 
 	/*
@@ -1930,6 +1976,7 @@ static void tb_dp_resource_available(struct tb *tb, struct tb_port *port)
 	tb_port_dbg(port, "DP %s resource available after hotplug\n",
 		    tb_port_is_dpin(port) ? "IN" : "OUT");
 	list_add_tail(&port->list, &tcm->dp_resources);
+	tb_exit_redrive(port);
 
 	/* Look for suitable DP IN <-> DP OUT pairs now */
 	tb_tunnel_dp(tb);
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index 997c5a5369052..e4d4effb94447 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -23,6 +23,8 @@
 #define QUIRK_FORCE_POWER_LINK_CONTROLLER		BIT(0)
 /* Disable CLx if not supported */
 #define QUIRK_NO_CLX					BIT(1)
+/* Need to keep power on while USB4 port is in redrive mode */
+#define QUIRK_KEEP_POWER_IN_DP_REDRIVE			BIT(2)
 
 /**
  * struct tb_nvm - Structure holding NVM information
@@ -258,6 +260,7 @@ struct tb_bandwidth_group {
  * @group_list: The adapter is linked to the group's list of ports through this
  * @max_bw: Maximum possible bandwidth through this adapter if set to
  *	    non-zero.
+ * @redrive: For DP IN, if true the adapter is in redrive mode.
  *
  * In USB4 terminology this structure represents an adapter (protocol or
  * lane adapter).
@@ -286,6 +289,7 @@ struct tb_port {
 	struct tb_bandwidth_group *group;
 	struct list_head group_list;
 	unsigned int max_bw;
+	bool redrive;
 };
 
 /**
-- 
2.43.0



