Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66B514388A;
	Tue, 23 Apr 2024 21:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908790; cv=none; b=ETtOXtxg+jxfmQvUsfP+jyvCDnSK7wgiC/7/kNZObYzTQyPYVdUW20DnQT7Um6tLvOC+6bCwWljVveETYLbisTEozTjgwv61Y8aM+TogUeYYmSb3VdnjhwEyXbW3I615cix2L7z6mNvqmvzQgADmkPO7eiCFhEow5MX5RgkRTKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908790; c=relaxed/simple;
	bh=b7EcqujSTL2Ncow19MK1E+dFP7QQdLQ0kS2ba4UOQ54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iB/Ypa2XUz1LUKYCIHCYD4HlW2PAyAxDQB7VpkJBVK9Sw1D/4vvhz4QPYxBPkpgS+L4XzFgTNcieCAs6goNvQDkYydESmLx5TokVQbBzUclGPJ8UFtqWqpn9lB49s1kgOV1bcES8wWm0+AMyvIL0qqNTu5BBkZumQN/MzKAhF6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0QYpuLv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0QYpuLv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D406C116B1;
	Tue, 23 Apr 2024 21:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908790;
	bh=b7EcqujSTL2Ncow19MK1E+dFP7QQdLQ0kS2ba4UOQ54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0QYpuLvrlKuI/MwGmWcgdMKkNHLAIn/j9dvIhdgShdPdtvtVAS1GNoSJdif5V/ov
	 eSaX+JXdka6IXfxJ4rFdLSDc/q5a3b4lFbAG/oTw2MKdMB3Qz2rVeNNvemuEOv2E4h
	 wz0mBmm/ACv4Ykpvcfw0jpTS/I9Pv1FleQEUOBI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 42/71] thunderbolt: Avoid notify PM core about runtime PM resume
Date: Tue, 23 Apr 2024 14:39:55 -0700
Message-ID: <20240423213845.593488588@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2926,7 +2926,26 @@ static int tb_switch_set_wake(struct tb_
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
@@ -2971,6 +2990,9 @@ int tb_switch_resume(struct tb_switch *s
 	if (err)
 		return err;
 
+	if (!runtime)
+		tb_switch_check_wakes(sw);
+
 	/* Disable wakes */
 	tb_switch_set_wake(sw, 0);
 
@@ -3000,7 +3022,8 @@ int tb_switch_resume(struct tb_switch *s
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
@@ -1491,7 +1491,7 @@ static int tb_resume_noirq(struct tb *tb
 	/* remove any pci devices the firmware might have setup */
 	tb_switch_reset(tb->root_switch);
 
-	tb_switch_resume(tb->root_switch);
+	tb_switch_resume(tb->root_switch, false);
 	tb_free_invalid_tunnels(tb);
 	tb_free_unplugged_children(tb->root_switch);
 	tb_restore_children(tb->root_switch);
@@ -1617,7 +1617,7 @@ static int tb_runtime_resume(struct tb *
 	struct tb_tunnel *tunnel, *n;
 
 	mutex_lock(&tb->lock);
-	tb_switch_resume(tb->root_switch);
+	tb_switch_resume(tb->root_switch, true);
 	tb_free_invalid_tunnels(tb);
 	tb_restore_children(tb->root_switch);
 	list_for_each_entry_safe(tunnel, n, &tcm->tunnel_list, list)
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -740,7 +740,7 @@ int tb_switch_configure(struct tb_switch
 int tb_switch_add(struct tb_switch *sw);
 void tb_switch_remove(struct tb_switch *sw);
 void tb_switch_suspend(struct tb_switch *sw, bool runtime);
-int tb_switch_resume(struct tb_switch *sw);
+int tb_switch_resume(struct tb_switch *sw, bool runtime);
 int tb_switch_reset(struct tb_switch *sw);
 void tb_sw_set_unplugged(struct tb_switch *sw);
 struct tb_port *tb_switch_find_port(struct tb_switch *sw,
@@ -1043,6 +1043,7 @@ static inline struct tb_retimer *tb_to_r
 	return NULL;
 }
 
+void usb4_switch_check_wakes(struct tb_switch *sw);
 int usb4_switch_setup(struct tb_switch *sw);
 int usb4_switch_read_uid(struct tb_switch *sw, u64 *uid);
 int usb4_switch_drom_read(struct tb_switch *sw, unsigned int address, void *buf,
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -175,15 +175,18 @@ static inline int usb4_switch_op_data(st
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
 	struct tb_port *port;
 	bool wakeup = false;
 	u32 val;
 
-	if (!device_may_wakeup(&sw->dev))
-		return;
-
 	if (tb_route(sw)) {
 		if (tb_sw_read(sw, &val, TB_CFG_SWITCH, ROUTER_CS_6, 1))
 			return;
@@ -248,8 +251,6 @@ int usb4_switch_setup(struct tb_switch *
 	u32 val = 0;
 	int ret;
 
-	usb4_switch_check_wakes(sw);
-
 	if (!tb_route(sw))
 		return 0;
 


