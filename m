Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6864519DF4A;
	Thu,  3 Jul 2025 15:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556029; cv=none; b=a8URbbaL+mExWStTSvTGpYWJOqdM/R68S14aLVUsi5Qy5FYYhuYNo6+PrEZu8wYORMfnXeEGwmBSZ58dTgwCafAx/67pWz/R+ytNZKARLfCtnLG+0Cukit54kstQ+/++glcD24E3Rst/QV8cz3rQ1se5Z0P4BK3Kkio0qa+srfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556029; c=relaxed/simple;
	bh=rXD2kj0Z7opCPvXPC/qjMEDApj4g6r+l54Wb614o65k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stn8Dh9lpVKwagTkPiy3GHO7v8Yn6+zrGkhstC9ew38V17X7HakMyKqezrYeVh4wFb+1iOd8NH2xRkQtsvRgY4uWtDc7thOYVsKXeur+W7PpbpRqLaD3C99Sbadbdio8mrq605/S3rjNlwSGukGbGK2XygJw8x5ytp6JvTrs2/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JwBBDBfb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwBBDBfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3343C4CEE3;
	Thu,  3 Jul 2025 15:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556029;
	bh=rXD2kj0Z7opCPvXPC/qjMEDApj4g6r+l54Wb614o65k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JwBBDBfbuqP7q3rviux3CO1NnD4ktJt73JFZUwc+2OZVASFb786gTBEagnltuTjvz
	 pMcXeELYsl/ybrizby1tJI22j3SdvBWdGdcPbCZRrOkS9nyObo2nHGge3XQRUgUFKe
	 UpZ/rRBEXttB0kTsm9Ac0e+Lv/PK8hiTOGlfY04c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
	Dexuan Cui <decui@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Petr Mladek <pmladek@suse.com>,
	Stephen Hemminger <sthemmin@microsoft.com>,
	Tianyu Lan <Tianyu.Lan@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Michael Kelley <mikelley@microsoft.com>,
	Fabio A M Martins <fabiomirmar@gmail.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/132] drivers: hv, hyperv_fb: Untangle and refactor Hyper-V panic notifiers
Date: Thu,  3 Jul 2025 16:42:21 +0200
Message-ID: <20250703143941.462126826@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guilherme G. Piccoli <gpiccoli@igalia.com>

[ Upstream commit d786e00d19f9fc80c2239a07643b08ea75b8b364 ]

Currently Hyper-V guests are among the most relevant users of the panic
infrastructure, like panic notifiers, kmsg dumpers, etc. The reasons rely
both in cleaning-up procedures (closing hypervisor <-> guest connection,
disabling some paravirtualized timer) as well as to data collection
(sending panic information to the hypervisor) and framebuffer management.

The thing is: some notifiers are related to others, ordering matters, some
functionalities are duplicated and there are lots of conditionals behind
sending panic information to the hypervisor. As part of an effort to
clean-up the panic notifiers mechanism and better document things, we
hereby address some of the issues/complexities of Hyper-V panic handling
through the following changes:

(a) We have die and panic notifiers on vmbus_drv.c and both have goals of
sending panic information to the hypervisor, though the panic notifier is
also responsible for a cleaning-up procedure.

This commit clears the code by splitting the panic notifier in two, one
for closing the vmbus connection whereas the other is only for sending
panic info to hypervisor. With that, it was possible to merge the die and
panic notifiers in a single/well-documented function, and clear some
conditional complexities on sending such information to the hypervisor.

(b) There is a Hyper-V framebuffer panic notifier, which relies in doing
a vmbus operation that demands a valid connection. So, we must order this
notifier with the panic notifier from vmbus_drv.c, to guarantee that the
framebuffer code executes before the vmbus connection is unloaded.

Also, this commit removes a useless header.

Although there is code rework and re-ordering, we expect that this change
has no functional regressions but instead optimize the path and increase
panic reliability on Hyper-V. This was tested on Hyper-V with success.

Cc: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Tianyu Lan <Tianyu.Lan@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Tested-by: Fabio A M Martins <fabiomirmar@gmail.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Tested-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20220819221731.480795-11-gpiccoli@igalia.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Stable-dep-of: 09eea7ad0b8e ("Drivers: hv: Allocate interrupt and monitor pages aligned to system page boundary")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/vmbus_drv.c          | 105 +++++++++++++++++++-------------
 drivers/video/fbdev/hyperv_fb.c |   8 +++
 2 files changed, 72 insertions(+), 41 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index dfbfdbf9cbd72..5f6415214a1e4 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -25,7 +25,6 @@
 #include <linux/sched/task_stack.h>
 
 #include <linux/delay.h>
-#include <linux/notifier.h>
 #include <linux/panic_notifier.h>
 #include <linux/ptrace.h>
 #include <linux/screen_info.h>
@@ -68,53 +67,74 @@ static int hyperv_report_reg(void)
 	return !sysctl_record_panic_msg || !hv_panic_page;
 }
 
-static int hyperv_panic_event(struct notifier_block *nb, unsigned long val,
+/*
+ * The panic notifier below is responsible solely for unloading the
+ * vmbus connection, which is necessary in a panic event.
+ *
+ * Notice an intrincate relation of this notifier with Hyper-V
+ * framebuffer panic notifier exists - we need vmbus connection alive
+ * there in order to succeed, so we need to order both with each other
+ * [see hvfb_on_panic()] - this is done using notifiers' priorities.
+ */
+static int hv_panic_vmbus_unload(struct notifier_block *nb, unsigned long val,
 			      void *args)
 {
-	struct pt_regs *regs;
-
 	vmbus_initiate_unload(true);
-
-	/*
-	 * Hyper-V should be notified only once about a panic.  If we will be
-	 * doing hv_kmsg_dump() with kmsg data later, don't do the notification
-	 * here.
-	 */
-	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE
-	    && hyperv_report_reg()) {
-		regs = current_pt_regs();
-		hyperv_report_panic(regs, val, false);
-	}
 	return NOTIFY_DONE;
 }
+static struct notifier_block hyperv_panic_vmbus_unload_block = {
+	.notifier_call	= hv_panic_vmbus_unload,
+	.priority	= INT_MIN + 1, /* almost the latest one to execute */
+};
+
+static int hv_die_panic_notify_crash(struct notifier_block *self,
+				     unsigned long val, void *args);
+
+static struct notifier_block hyperv_die_report_block = {
+	.notifier_call = hv_die_panic_notify_crash,
+};
+static struct notifier_block hyperv_panic_report_block = {
+	.notifier_call = hv_die_panic_notify_crash,
+};
 
-static int hyperv_die_event(struct notifier_block *nb, unsigned long val,
-			    void *args)
+/*
+ * The following callback works both as die and panic notifier; its
+ * goal is to provide panic information to the hypervisor unless the
+ * kmsg dumper is used [see hv_kmsg_dump()], which provides more
+ * information but isn't always available.
+ *
+ * Notice that both the panic/die report notifiers are registered only
+ * if we have the capability HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE set.
+ */
+static int hv_die_panic_notify_crash(struct notifier_block *self,
+				     unsigned long val, void *args)
 {
-	struct die_args *die = args;
-	struct pt_regs *regs = die->regs;
+	struct pt_regs *regs;
+	bool is_die;
 
-	/* Don't notify Hyper-V if the die event is other than oops */
-	if (val != DIE_OOPS)
-		return NOTIFY_DONE;
+	/* Don't notify Hyper-V unless we have a die oops event or panic. */
+	if (self == &hyperv_panic_report_block) {
+		is_die = false;
+		regs = current_pt_regs();
+	} else { /* die event */
+		if (val != DIE_OOPS)
+			return NOTIFY_DONE;
+
+		is_die = true;
+		regs = ((struct die_args *)args)->regs;
+	}
 
 	/*
-	 * Hyper-V should be notified only once about a panic.  If we will be
-	 * doing hv_kmsg_dump() with kmsg data later, don't do the notification
-	 * here.
+	 * Hyper-V should be notified only once about a panic/die. If we will
+	 * be calling hv_kmsg_dump() later with kmsg data, don't do the
+	 * notification here.
 	 */
 	if (hyperv_report_reg())
-		hyperv_report_panic(regs, val, true);
+		hyperv_report_panic(regs, val, is_die);
+
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block hyperv_die_block = {
-	.notifier_call = hyperv_die_event,
-};
-static struct notifier_block hyperv_panic_block = {
-	.notifier_call = hyperv_panic_event,
-};
-
 static const char *fb_mmio_name = "fb_range";
 static struct resource *fb_mmio;
 static struct resource *hyperv_mmio;
@@ -1538,16 +1558,17 @@ static int vmbus_bus_init(void)
 		if (hyperv_crash_ctl & HV_CRASH_CTL_CRASH_NOTIFY_MSG)
 			hv_kmsg_dump_register();
 
-		register_die_notifier(&hyperv_die_block);
+		register_die_notifier(&hyperv_die_report_block);
+		atomic_notifier_chain_register(&panic_notifier_list,
+						&hyperv_panic_report_block);
 	}
 
 	/*
-	 * Always register the panic notifier because we need to unload
-	 * the VMbus channel connection to prevent any VMbus
-	 * activity after the VM panics.
+	 * Always register the vmbus unload panic notifier because we
+	 * need to shut the VMbus channel connection on panic.
 	 */
 	atomic_notifier_chain_register(&panic_notifier_list,
-			       &hyperv_panic_block);
+			       &hyperv_panic_vmbus_unload_block);
 
 	vmbus_request_offers();
 
@@ -2814,15 +2835,17 @@ static void __exit vmbus_exit(void)
 
 	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE) {
 		kmsg_dump_unregister(&hv_kmsg_dumper);
-		unregister_die_notifier(&hyperv_die_block);
+		unregister_die_notifier(&hyperv_die_report_block);
+		atomic_notifier_chain_unregister(&panic_notifier_list,
+						&hyperv_panic_report_block);
 	}
 
 	/*
-	 * The panic notifier is always registered, hence we should
+	 * The vmbus panic notifier is always registered, hence we should
 	 * also unconditionally unregister it here as well.
 	 */
 	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &hyperv_panic_block);
+					&hyperv_panic_vmbus_unload_block);
 
 	free_page((unsigned long)hv_panic_page);
 	unregister_sysctl_table(hv_ctl_table_hdr);
diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index 41c496ff55cc4..f3f30ee6cc95a 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -1209,7 +1209,15 @@ static int hvfb_probe(struct hv_device *hdev,
 	par->fb_ready = true;
 
 	par->synchronous_fb = false;
+
+	/*
+	 * We need to be sure this panic notifier runs _before_ the
+	 * vmbus disconnect, so order it by priority. It must execute
+	 * before the function hv_panic_vmbus_unload() [drivers/hv/vmbus_drv.c],
+	 * which is almost at the end of list, with priority = INT_MIN + 1.
+	 */
 	par->hvfb_panic_nb.notifier_call = hvfb_on_panic;
+	par->hvfb_panic_nb.priority = INT_MIN + 10,
 	atomic_notifier_chain_register(&panic_notifier_list,
 				       &par->hvfb_panic_nb);
 
-- 
2.39.5



