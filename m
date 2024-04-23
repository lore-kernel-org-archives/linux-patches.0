Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A13A14389F;
	Tue, 23 Apr 2024 21:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908647; cv=none; b=avy5/MB4HplWMfzhzuefPEvBAJ9pGm4PfjIJwHkg5ziqpP518GnlweiSSskCw3x5y0bIEqJVtf1IPjgnNKATFpF0i2vbjkXPpGRTpQi503QkMLGoI5adikRJjGk2CS50o5T4cpcykDyo2QDDPV5cp2sMTo7EXAX+In1lcFvrOu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908647; c=relaxed/simple;
	bh=nVcmpjzNwg6u8suOQfCL0qpT8Vi5DPs3Gej+XSJ7FRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUojd82PUfUaqg2yJF/R7yUJZVaGvGWcOSV9pKGcgstWkjyoBgdLO3+Y0TddOXA0m9UpECcSZK/Y80HxGr+jXxrziav4Zk5vuGAQ47NPcRRbSA1egicYNGIiA8FLSDWzK0FKCyXY45Gj6Q2K6XUDblP4E5ndQQYd/YpJyx8Xpq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVf0qocp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVf0qocp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA98C32783;
	Tue, 23 Apr 2024 21:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908647;
	bh=nVcmpjzNwg6u8suOQfCL0qpT8Vi5DPs3Gej+XSJ7FRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DVf0qocpP5bpeSB09ISqYEjI755CYUTpLYJF7w9/LO51zcNZoa81iOAib1H7K5VXt
	 m0aRXPIb7QAI506Cih2BslQ7zxeTzf6OfO1lW33nbT814r+4aiysGUkEIrQOgGP1ZP
	 veS2Bo++fjReDhY4cY8UibKAw8FsmNuV/RMkb8xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 106/158] thunderbolt: Avoid notify PM core about runtime PM resume
Date: Tue, 23 Apr 2024 14:39:03 -0700
Message-ID: <20240423213859.199989220@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

commit dcd12acaf384c30437fa5a9a1f71df06fc9835fd upstream.

Currently we notify PM core about occurred wakes after any resume. This
is not actually needed after resume from runtime suspend. Hence, notify
PM core about occurred wakes only after resume from system sleep. Also,
if the wake occurred in USB4 router upstream port, we don't notify the
PM core about it since it is not actually needed and can cause
unexpected autowake (e.g. if /sys/power/wakeup_count is used).

While there add the missing kernel-doc for tb_switch_resume().

Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c |   27 +++++++++++++++++++++++++--
 drivers/thunderbolt/tb.c     |    4 ++--
 drivers/thunderbolt/tb.h     |    3 ++-
 drivers/thunderbolt/usb4.c   |   13 +++++++------
 4 files changed, 36 insertions(+), 11 deletions(-)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -3208,7 +3208,26 @@ static int tb_switch_set_wake(struct tb_
 	return tb_lc_set_wake(sw, flags);
 }
 
-int tb_switch_resume(struct tb_switch *sw)
+static void tb_switch_check_wakes(struct tb_switch *sw)
+{
+	if (device_may_wakeup(&sw->dev)) {
+		if (tb_switch_is_usb4(sw))
+			usb4_switch_check_wakes(sw);
+	}
+}
+
+/**
+ * tb_switch_resume() - Resume a switch after sleep
+ * @sw: Switch to resume
+ * @runtime: Is this resume from runtime suspend or system sleep
+ *
+ * Resumes and re-enumerates router (and all its children), if still plugged
+ * after suspend. Don't enumerate device router whose UID was changed during
+ * suspend. If this is resume from system sleep, notifies PM core about the
+ * wakes occurred during suspend. Disables all wakes, except USB4 wake of
+ * upstream port for USB4 routers that shall be always enabled.
+ */
+int tb_switch_resume(struct tb_switch *sw, bool runtime)
 {
 	struct tb_port *port;
 	int err;
@@ -3257,6 +3276,9 @@ int tb_switch_resume(struct tb_switch *s
 	if (err)
 		return err;
 
+	if (!runtime)
+		tb_switch_check_wakes(sw);
+
 	/* Disable wakes */
 	tb_switch_set_wake(sw, 0);
 
@@ -3286,7 +3308,8 @@ int tb_switch_resume(struct tb_switch *s
 			 */
 			if (tb_port_unlock(port))
 				tb_port_warn(port, "failed to unlock port\n");
-			if (port->remote && tb_switch_resume(port->remote->sw)) {
+			if (port->remote &&
+			    tb_switch_resume(port->remote->sw, runtime)) {
 				tb_port_warn(port,
 					     "lost during suspend, disconnecting\n");
 				tb_sw_set_unplugged(port->remote->sw);
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -2262,7 +2262,7 @@ static int tb_resume_noirq(struct tb *tb
 	/* remove any pci devices the firmware might have setup */
 	tb_switch_reset(tb->root_switch);
 
-	tb_switch_resume(tb->root_switch);
+	tb_switch_resume(tb->root_switch, false);
 	tb_free_invalid_tunnels(tb);
 	tb_free_unplugged_children(tb->root_switch);
 	tb_restore_children(tb->root_switch);
@@ -2388,7 +2388,7 @@ static int tb_runtime_resume(struct tb *
 	struct tb_tunnel *tunnel, *n;
 
 	mutex_lock(&tb->lock);
-	tb_switch_resume(tb->root_switch);
+	tb_switch_resume(tb->root_switch, true);
 	tb_free_invalid_tunnels(tb);
 	tb_restore_children(tb->root_switch);
 	list_for_each_entry_safe(tunnel, n, &tcm->tunnel_list, list)
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -802,7 +802,7 @@ int tb_switch_configuration_valid(struct
 int tb_switch_add(struct tb_switch *sw);
 void tb_switch_remove(struct tb_switch *sw);
 void tb_switch_suspend(struct tb_switch *sw, bool runtime);
-int tb_switch_resume(struct tb_switch *sw);
+int tb_switch_resume(struct tb_switch *sw, bool runtime);
 int tb_switch_reset(struct tb_switch *sw);
 int tb_switch_wait_for_bit(struct tb_switch *sw, u32 offset, u32 bit,
 			   u32 value, int timeout_msec);
@@ -1224,6 +1224,7 @@ static inline bool tb_switch_is_usb4(con
 	return usb4_switch_version(sw) > 0;
 }
 
+void usb4_switch_check_wakes(struct tb_switch *sw);
 int usb4_switch_setup(struct tb_switch *sw);
 int usb4_switch_configuration_valid(struct tb_switch *sw);
 int usb4_switch_read_uid(struct tb_switch *sw, u64 *uid);
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -155,7 +155,13 @@ static inline int usb4_switch_op_data(st
 				tx_dwords, rx_data, rx_dwords);
 }
 
-static void usb4_switch_check_wakes(struct tb_switch *sw)
+/**
+ * usb4_switch_check_wakes() - Check for wakes and notify PM core about them
+ * @sw: Router whose wakes to check
+ *
+ * Checks wakes occurred during suspend and notify the PM core about them.
+ */
+void usb4_switch_check_wakes(struct tb_switch *sw)
 {
 	bool wakeup_usb4 = false;
 	struct usb4_port *usb4;
@@ -163,9 +169,6 @@ static void usb4_switch_check_wakes(stru
 	bool wakeup = false;
 	u32 val;
 
-	if (!device_may_wakeup(&sw->dev))
-		return;
-
 	if (tb_route(sw)) {
 		if (tb_sw_read(sw, &val, TB_CFG_SWITCH, ROUTER_CS_6, 1))
 			return;
@@ -244,8 +247,6 @@ int usb4_switch_setup(struct tb_switch *
 	u32 val = 0;
 	int ret;
 
-	usb4_switch_check_wakes(sw);
-
 	if (!tb_route(sw))
 		return 0;
 


