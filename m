Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3642EA72B;
	Tue, 22 Jul 2025 13:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192339; cv=none; b=fM/QtQKyoiuooVLbUwfcLJcqbKW43RZM+BJ6Zyav23fNIdr4apgvzdUKJ6k3DeISa7yr3BNsVtGRPcTxzzxayO8HEC3WoFEPQNkJX05cZmray5b4ZEb02sg1tMyRMWc7GMzBAncQazjTp9pqf86d+JyfsKPIo+6jRt6iAHTn+Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192339; c=relaxed/simple;
	bh=ehhiGFMBsia+rW4HO2Og8HT8NiIfPX0lxzt6b4oGQkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnxiqPnIrIzRIsJE33m3IFfbv+SmRdl3com77mULFBTZilc+MSTUVFoFVvYH0iE+aeo3s3NdvX1pgdpyxHxs1tILjk+RiMBcRRoN8oE+DpBsheK6/WbD/9k7ACxIDYwIbyB0IXu6Fpxn0KMSm9GxC4hWRsD0dssS8nh+k0EbrhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2kIY/ox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2kIY/ox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E5CC4CEF5;
	Tue, 22 Jul 2025 13:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192338;
	bh=ehhiGFMBsia+rW4HO2Og8HT8NiIfPX0lxzt6b4oGQkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2kIY/oxEYF3XEcEkEMm8s/UvJXFnYXLZHUaIxbhpB0pX0aaJLs9QhUZnfB3XLMhy
	 gPaTn2+yqItjXK+JcmcxYvAzE7PZ0v9lw7RsaF2E5gZ9HiRykjuSDzbQAcER2UwNGR
	 FikCTnZ1K2bCBiL5BI7wg9YIGWsrdyN4tvZLQtj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Kovacs <Alexander.Kovacs@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 010/111] thunderbolt: Fix wake on connect at runtime
Date: Tue, 22 Jul 2025 15:43:45 +0200
Message-ID: <20250722134333.761374816@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 58d71d4242ce057955c783a14c82270c71f9e1e8 upstream.

commit 1a760d10ded37 ("thunderbolt: Fix a logic error in wake on connect")
fixated on the USB4 port sysfs wakeup file not working properly to control
policy, but it had an unintended side effect that the sysfs file controls
policy both at runtime and at suspend time. The sysfs file is supposed to
only control behavior while system is suspended.

Pass whether programming a port for runtime into usb4_switch_set_wake()
and if runtime then ignore the value in the sysfs file.

Cc: stable@vger.kernel.org
Reported-by: Alexander Kovacs <Alexander.Kovacs@amd.com>
Tested-by: Alexander Kovacs <Alexander.Kovacs@amd.com>
Fixes: 1a760d10ded37 ("thunderbolt: Fix a logic error in wake on connect")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c |    8 ++++----
 drivers/thunderbolt/tb.h     |    2 +-
 drivers/thunderbolt/usb4.c   |   12 +++++-------
 3 files changed, 10 insertions(+), 12 deletions(-)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -3439,7 +3439,7 @@ void tb_sw_set_unplugged(struct tb_switc
 	}
 }
 
-static int tb_switch_set_wake(struct tb_switch *sw, unsigned int flags)
+static int tb_switch_set_wake(struct tb_switch *sw, unsigned int flags, bool runtime)
 {
 	if (flags)
 		tb_sw_dbg(sw, "enabling wakeup: %#x\n", flags);
@@ -3447,7 +3447,7 @@ static int tb_switch_set_wake(struct tb_
 		tb_sw_dbg(sw, "disabling wakeup\n");
 
 	if (tb_switch_is_usb4(sw))
-		return usb4_switch_set_wake(sw, flags);
+		return usb4_switch_set_wake(sw, flags, runtime);
 	return tb_lc_set_wake(sw, flags);
 }
 
@@ -3523,7 +3523,7 @@ int tb_switch_resume(struct tb_switch *s
 		tb_switch_check_wakes(sw);
 
 	/* Disable wakes */
-	tb_switch_set_wake(sw, 0);
+	tb_switch_set_wake(sw, 0, true);
 
 	err = tb_switch_tmu_init(sw);
 	if (err)
@@ -3604,7 +3604,7 @@ void tb_switch_suspend(struct tb_switch
 		flags |= TB_WAKE_ON_USB4 | TB_WAKE_ON_USB3 | TB_WAKE_ON_PCIE;
 	}
 
-	tb_switch_set_wake(sw, flags);
+	tb_switch_set_wake(sw, flags, runtime);
 
 	if (tb_switch_is_usb4(sw))
 		usb4_switch_set_sleep(sw);
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -1266,7 +1266,7 @@ int usb4_switch_read_uid(struct tb_switc
 int usb4_switch_drom_read(struct tb_switch *sw, unsigned int address, void *buf,
 			  size_t size);
 bool usb4_switch_lane_bonding_possible(struct tb_switch *sw);
-int usb4_switch_set_wake(struct tb_switch *sw, unsigned int flags);
+int usb4_switch_set_wake(struct tb_switch *sw, unsigned int flags, bool runtime);
 int usb4_switch_set_sleep(struct tb_switch *sw);
 int usb4_switch_nvm_sector_size(struct tb_switch *sw);
 int usb4_switch_nvm_read(struct tb_switch *sw, unsigned int address, void *buf,
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -405,12 +405,12 @@ bool usb4_switch_lane_bonding_possible(s
  * usb4_switch_set_wake() - Enabled/disable wake
  * @sw: USB4 router
  * @flags: Wakeup flags (%0 to disable)
+ * @runtime: Wake is being programmed during system runtime
  *
  * Enables/disables router to wake up from sleep.
  */
-int usb4_switch_set_wake(struct tb_switch *sw, unsigned int flags)
+int usb4_switch_set_wake(struct tb_switch *sw, unsigned int flags, bool runtime)
 {
-	struct usb4_port *usb4;
 	struct tb_port *port;
 	u64 route = tb_route(sw);
 	u32 val;
@@ -440,13 +440,11 @@ int usb4_switch_set_wake(struct tb_switc
 			val |= PORT_CS_19_WOU4;
 		} else {
 			bool configured = val & PORT_CS_19_PC;
-			usb4 = port->usb4;
+			bool wakeup = runtime || device_may_wakeup(&port->usb4->dev);
 
-			if (((flags & TB_WAKE_ON_CONNECT) &&
-			      device_may_wakeup(&usb4->dev)) && !configured)
+			if ((flags & TB_WAKE_ON_CONNECT) && wakeup && !configured)
 				val |= PORT_CS_19_WOC;
-			if (((flags & TB_WAKE_ON_DISCONNECT) &&
-			      device_may_wakeup(&usb4->dev)) && configured)
+			if ((flags & TB_WAKE_ON_DISCONNECT) && wakeup && configured)
 				val |= PORT_CS_19_WOD;
 			if ((flags & TB_WAKE_ON_USB4) && configured)
 				val |= PORT_CS_19_WOU4;


