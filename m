Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B231B4135;
	Mon, 23 Dec 2024 16:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970504; cv=none; b=DAwF6Q0ent2nr2MgfOS8eGAjuQQAcxwuGI8GjaYDf22n4qbzkRggtuVRyRe5hfwfAnjNpjRgvsoijTeQEfNEkEvMtPW6Fj3XDIMK0AnKRcabZnH435PSdG1QGbOGo+DmzZHVKeoHbch3QiaINqvx4beqWmRp8TeL88AjHDvoJ1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970504; c=relaxed/simple;
	bh=KWhwHZVLkSshjyOjPGTLHCztpAspSpnrJpgnmIbdpqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSIvhkCxZuzEmWmLdAixThsn3RTzXWF++zCvv1+Wlvm/if6G+j5gGZ7JaYdCAXOZYakBzj+mOrqE3a19CP+TEw7WC++1LRa82UsXqe2x5UVdwB9q6mnwuzGjufhp8z6fiebYt7G6qzBQsANGwafQ50a50n7btRji3WRxr8Gxl4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/E6T/Oo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/E6T/Oo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7276CC4CED3;
	Mon, 23 Dec 2024 16:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970503;
	bh=KWhwHZVLkSshjyOjPGTLHCztpAspSpnrJpgnmIbdpqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/E6T/Oo4dyDHVYV5x2mFLFbGAXv5MP11gfBd3jdtoDctuAbp2BvY5JzihLMIHyDq
	 aXm12uD0ga2cZ9gPtOK/WWUTUyHLbmCTHDKMePkTWNtXjLTLmXnNJNXtPkQPFywBZt
	 JWO+0n1JNgCOiJRTLc2/OHRWO9CD/naPILN17yYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Rainbolt <arainbolt@kfocus.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 072/116] thunderbolt: Improve redrive mode handling
Date: Mon, 23 Dec 2024 16:59:02 +0100
Message-ID: <20241223155402.361448789@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 24740385cb0d6d22ab7fa7adf36546d5b3cdcf73 upstream.

When USB-C monitor is connected directly to Intel Barlow Ridge host, it
goes into "redrive" mode that basically routes the DisplayPort signals
directly from the GPU to the USB-C monitor without any tunneling needed.
However, the host router must be powered on for this to work. Aaron
reported that there are a couple of cases where this will not work with
the current code:

  - Booting with USB-C monitor plugged in.
  - Plugging in USB-C monitor when the host router is in sleep state
    (runtime suspended).
  - Plugging in USB-C device while the system is in system sleep state.

In all these cases once the host router is runtime suspended the picture
on the connected USB-C display disappears too. This is certainly not
what the user expected.

For this reason improve the redrive mode handling to keep the host
router from runtime suspending when detect that any of the above cases
is happening.

Fixes: a75e0684efe5 ("thunderbolt: Keep the domain powered when USB4 port is in redrive mode")
Reported-by: Aaron Rainbolt <arainbolt@kfocus.org>
Closes: https://lore.kernel.org/linux-usb/20241009220118.70bfedd0@kf-ir16/
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -1930,6 +1930,37 @@ static void tb_exit_redrive(struct tb_po
 	}
 }
 
+static void tb_switch_enter_redrive(struct tb_switch *sw)
+{
+	struct tb_port *port;
+
+	tb_switch_for_each_port(sw, port)
+		tb_enter_redrive(port);
+}
+
+/*
+ * Called during system and runtime suspend to forcefully exit redrive
+ * mode without querying whether the resource is available.
+ */
+static void tb_switch_exit_redrive(struct tb_switch *sw)
+{
+	struct tb_port *port;
+
+	if (!(sw->quirks & QUIRK_KEEP_POWER_IN_DP_REDRIVE))
+		return;
+
+	tb_switch_for_each_port(sw, port) {
+		if (!tb_port_is_dpin(port))
+			continue;
+
+		if (port->redrive) {
+			port->redrive = false;
+			pm_runtime_put(&sw->dev);
+			tb_port_dbg(port, "exit redrive mode\n");
+		}
+	}
+}
+
 static void tb_dp_resource_unavailable(struct tb *tb, struct tb_port *port)
 {
 	struct tb_port *in, *out;
@@ -2690,6 +2721,7 @@ static int tb_start(struct tb *tb, bool
 	tb_create_usb3_tunnels(tb->root_switch);
 	/* Add DP IN resources for the root switch */
 	tb_add_dp_resources(tb->root_switch);
+	tb_switch_enter_redrive(tb->root_switch);
 	/* Make the discovered switches available to the userspace */
 	device_for_each_child(&tb->root_switch->dev, NULL,
 			      tb_scan_finalize_switch);
@@ -2705,6 +2737,7 @@ static int tb_suspend_noirq(struct tb *t
 
 	tb_dbg(tb, "suspending...\n");
 	tb_disconnect_and_release_dp(tb);
+	tb_switch_exit_redrive(tb->root_switch);
 	tb_switch_suspend(tb->root_switch, false);
 	tcm->hotplug_active = false; /* signal tb_handle_hotplug to quit */
 	tb_dbg(tb, "suspend finished\n");
@@ -2797,6 +2830,7 @@ static int tb_resume_noirq(struct tb *tb
 		tb_dbg(tb, "tunnels restarted, sleeping for 100ms\n");
 		msleep(100);
 	}
+	tb_switch_enter_redrive(tb->root_switch);
 	 /* Allow tb_handle_hotplug to progress events */
 	tcm->hotplug_active = true;
 	tb_dbg(tb, "resume finished\n");
@@ -2860,6 +2894,12 @@ static int tb_runtime_suspend(struct tb
 	struct tb_cm *tcm = tb_priv(tb);
 
 	mutex_lock(&tb->lock);
+	/*
+	 * The below call only releases DP resources to allow exiting and
+	 * re-entering redrive mode.
+	 */
+	tb_disconnect_and_release_dp(tb);
+	tb_switch_exit_redrive(tb->root_switch);
 	tb_switch_suspend(tb->root_switch, true);
 	tcm->hotplug_active = false;
 	mutex_unlock(&tb->lock);
@@ -2891,6 +2931,7 @@ static int tb_runtime_resume(struct tb *
 	tb_restore_children(tb->root_switch);
 	list_for_each_entry_safe(tunnel, n, &tcm->tunnel_list, list)
 		tb_tunnel_restart(tunnel);
+	tb_switch_enter_redrive(tb->root_switch);
 	tcm->hotplug_active = true;
 	mutex_unlock(&tb->lock);
 


