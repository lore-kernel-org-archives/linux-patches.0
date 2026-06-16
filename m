Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299302EEE68;
	Tue, 16 Jun 2026 15:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625048; cv=none; b=mu/ablv5s+JCwt6qbiNBjK46HB3Hg0oek3L/ZNt6+IbTJGIwmDoiEnAJwh1ofOOJ5sg0JoWaPI/a5yD3Y6XZKzIPfcSxB6gOTGxjcHv8VKkXf7lH7kzYKs6fF1TrC0Xeqkx10Hq0Qr6yTYUw6xDbNEXUezZ5/ZLgI+OnrgwdckY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625048; c=relaxed/simple;
	bh=elLZcBVC8LWOgI5IihS9ay+fOZla7Y8z7g6B2O+DR6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSUlVEaLyX4IKq+P1tQMSv2xa+/waKtKL2qDXPAZTQ5VwdXytS5YbLn9/3JvAX2YAHDv8dToQksBKImlkI3C2A1teStyFERdKo+8kE1ZOyE1LyBpFVHDisSN2Fl467QlZgw8lJ+uej0SK5naea6p9EFxSzFh7c1FfneECuZWFCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SVjSfuZy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVjSfuZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AA61F000E9;
	Tue, 16 Jun 2026 15:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625047;
	bh=+P7FRdcziC7zBUrWtDXhHxQLvVg6YBvl8nVwPUOIAJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SVjSfuZyTWrIQUsSBgrdtPF6D01sPgG5A5IU/nKbNoiyV0qfoODg+6MMkYzusDLkG
	 a+nI+ZkxImnm/n1wdMQoM9BVC4q7xnMH4W8NVo9EW0SDe4ULcScU1aiAPvnAh5pnNp
	 neMPZtJ84FUm1uyJWBw3u6yfsmvTZ85TwaardJ+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Long Li <longli@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 069/325] Drivers: hv: vmbus: Provide option to skip VMBus unload on panic
Date: Tue, 16 Jun 2026 20:27:45 +0530
Message-ID: <20260616145101.143088075@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Michael Kelley <mhklinux@outlook.com>

[ Upstream commit c5c3ef8d49e15d2fc1cec4ad7c91d81b99977440 ]

Currently, VMBus code initiates a VMBus unload in the panic path so
that if a kdump kernel is loaded, it can start fresh in setting up its
own VMBus connection. However, a driver for the VMBus virtual frame
buffer may need to flush dirty portions of the frame buffer back to
the Hyper-V host so that panic information is visible in the graphics
console. To support such flushing, provide exported functions for the
frame buffer driver to specify that the VMBus unload should not be
done by the VMBus driver, and to initiate the VMBus unload itself.
Together these allow a frame buffer driver to delay the VMBus unload
until after it has completed the flush.

Ideally, the VMBus driver could use its own panic-path callback to do
the unload after all frame buffer drivers have finished. But DRM frame
buffer drivers use the kmsg dump callback, and there are no callbacks
after that in the panic path. Hence this somewhat messy approach to
properly sequencing the frame buffer flush and the VMBus unload.

Fixes: 3671f3777758 ("drm/hyperv: Add support for drm_panic")
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel_mgmt.c |  1 +
 drivers/hv/hyperv_vmbus.h |  1 -
 drivers/hv/vmbus_drv.c    | 25 ++++++++++++++++++-------
 include/linux/hyperv.h    |  3 +++
 4 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 65dd299e2944bd..fd1d675ae37a4f 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -944,6 +944,7 @@ void vmbus_initiate_unload(bool crash)
 	else
 		vmbus_wait_for_unload();
 }
+EXPORT_SYMBOL_GPL(vmbus_initiate_unload);
 
 static void vmbus_setup_channel_state(struct vmbus_channel *channel,
 				      struct vmbus_channel_offer_channel *offer)
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 4a01797d485139..34943de7d6ac46 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -376,7 +376,6 @@ void hv_vss_deinit(void);
 int hv_vss_pre_suspend(void);
 int hv_vss_pre_resume(void);
 void hv_vss_onchannelcallback(void *context);
-void vmbus_initiate_unload(bool crash);
 
 static inline void hv_poll_channel(struct vmbus_channel *channel,
 				   void (*cb)(void *))
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 6d2bf7a96aa638..8a090e2a28f928 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -69,19 +69,29 @@ bool vmbus_is_confidential(void)
 }
 EXPORT_SYMBOL_GPL(vmbus_is_confidential);
 
+static bool skip_vmbus_unload;
+
+/*
+ * Allow a VMBus framebuffer driver to specify that in the case of a panic,
+ * it will do the VMbus unload operation once it has flushed any dirty
+ * portions of the framebuffer to the Hyper-V host.
+ */
+void vmbus_set_skip_unload(bool skip)
+{
+	skip_vmbus_unload = skip;
+}
+EXPORT_SYMBOL_GPL(vmbus_set_skip_unload);
+
 /*
  * The panic notifier below is responsible solely for unloading the
  * vmbus connection, which is necessary in a panic event.
- *
- * Notice an intrincate relation of this notifier with Hyper-V
- * framebuffer panic notifier exists - we need vmbus connection alive
- * there in order to succeed, so we need to order both with each other
- * [see hvfb_on_panic()] - this is done using notifiers' priorities.
  */
 static int hv_panic_vmbus_unload(struct notifier_block *nb, unsigned long val,
 			      void *args)
 {
-	vmbus_initiate_unload(true);
+	if (!skip_vmbus_unload)
+		vmbus_initiate_unload(true);
+
 	return NOTIFY_DONE;
 }
 static struct notifier_block hyperv_panic_vmbus_unload_block = {
@@ -2862,7 +2872,8 @@ static void hv_crash_handler(struct pt_regs *regs)
 {
 	int cpu;
 
-	vmbus_initiate_unload(true);
+	if (!skip_vmbus_unload)
+		vmbus_initiate_unload(true);
 	/*
 	 * In crash handler we can't schedule synic cleanup for all CPUs,
 	 * doing the cleanup for current CPU only. This should be sufficient
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index dfc516c1c7193f..b0502a336eb3a5 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1334,6 +1334,9 @@ int vmbus_allocate_mmio(struct resource **new, struct hv_device *device_obj,
 			bool fb_overlap_ok);
 void vmbus_free_mmio(resource_size_t start, resource_size_t size);
 
+void vmbus_initiate_unload(bool crash);
+void vmbus_set_skip_unload(bool skip);
+
 /*
  * GUID definitions of various offer types - services offered to the guest.
  */
-- 
2.53.0



