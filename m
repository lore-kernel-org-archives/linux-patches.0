Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC79329E79;
	Thu,  2 Jul 2026 16:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010237; cv=none; b=gj47F7GOocXEMRvIn0DqhmwP6wfAd1BJev1JRhFtGWAwgBiTg5kxZwmRpU6AgZo/0xb0h6ThQ/K4Yzhe1ERy0t27Ddf7DUXlDVHMQS47sw1TZA/cQui3V21mfC0pKQCHyhJ7g+HiOIMYQW2V+RhtGiUdxOEWrmIeYWDO3Xe0WPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010237; c=relaxed/simple;
	bh=7CsJOexkE2GnZ8lU+ezW0OXlW9o520zpH3HTl55Vd98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfsDIJtwA4wuQzZu6IGRo+QSLabk+MAdtzd2+2eRRBPHl3CW25B07BfNUVstCxcDrIrmxNpJ67dPMldrDVw5jJJvFgCVIkx5VrfS3IH3Jpp53VuBfJ5OrhlUyhtWxRVzVKi49IYFOUrb7lBqnXg6AsKSCWAhcY/HeizJFqUgvYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GvpcQixC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GvpcQixC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22C21F000E9;
	Thu,  2 Jul 2026 16:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010235;
	bh=hHCNI2y0PVFM73c8HTqaafF96mmxgzN8MVYy7no8C7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GvpcQixCRESjRGZvoCUMUJMuylleFSsleE9uWFDnGz1GFHgR/IJSkg3rHMcs/ZLBx
	 uFzs+wXz7sI52iccZMuARkZUAQ4KZu9NkSqVBP8Ws9jUNDbebTe0d8Y6rI5dbZ31PJ
	 3UByI7JlQVjFTlL3/btErwHSkRMd1lm5R/QZH1bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yang.yicong@picoheart.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/204] ACPI: scan: Use async schedule function in acpi_scan_clear_dep_fn()
Date: Thu,  2 Jul 2026 18:18:10 +0200
Message-ID: <20260702155119.353611869@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yicong Yang <yang.yicong@picoheart.com>

[ Upstream commit 7cf28b3797a81b616bb7eb3e90cf131afc452919 ]

The device object rescan in acpi_scan_clear_dep_fn() is scheduled on a
system workqueue which is not guaranteed to be finished before entering
userspace. This may cause some key devices to be missing when userspace
init task tries to find them. Two issues observed on RISCV platforms:

 - Kernel panic due to userspace init cannot have an opened
   console.

   The console device scanning is queued by acpi_scan_clear_dep_queue()
   and not finished by the time userspace init process running, thus by
   the time userspace init runs, no console is present.

 - Entering rescue shell due to the lack of root devices (PCIe nvme in
   our case).

   Same reason as above, the PCIe host bridge scanning is queued on
   a system workqueue and finished after init process runs.

The reason is because both devices (console, PCIe host bridge) depend on
riscv-aplic irqchip to serve their interrupts (console's wired interrupt
and PCI's INTx interrupts). In order to keep the dependency, these
devices are scanned and created after initializing riscv-aplic. The
riscv-aplic is initialized in device_initcall() and a device scan work
is queued via acpi_scan_clear_dep_queue(), which is close to the time
userspace init process is run. Since system_dfl_wq is used in
acpi_scan_clear_dep_queue() with no synchronization, the issues will
happen if userspace init runs before these devices are ready.

The solution is to wait for the queued work to complete before entering
userspace init. One possible way would be to use a dedicated workqueue
instead of system_dfl_wq, and explicitly flush it somewhere in the
initcall stage before entering userspace. Another way is to use
async_schedule_dev_nocall() for scanning these devices. It's designed
for asynchronous initialization and will work in the same way as before
because it's using a dedicated unbound workqueue as well, but the kernel
init code calls async_synchronize_full() right before entering userspace
init which will wait for the work to complete.

Compared to a dedicated workqueue, the second approach is simpler
because the async schedule framework takes care of all of the details.
The ACPI code only needs to focus on its job. A dedicated workqueue for
this could also be redundant because some platforms don't need
acpi_scan_clear_dep_queue() for their device scanning.

Signed-off-by: Yicong Yang <yang.yicong@picoheart.com>
[ rjw: Subject adjustment, changelog edits ]
Link: https://patch.msgid.link/20260128132848.93638-1-yang.yicong@picoheart.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ Vivian: Adjust system_dfl_wq -> system_unbound_wq in removed lines ]
Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c | 41 +++++++++++++++--------------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 0774cc6921100b..4b9c81fbdc3bb2 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -5,6 +5,7 @@
 
 #define pr_fmt(fmt) "ACPI: " fmt
 
+#include <linux/async.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -2364,46 +2365,34 @@ static int acpi_dev_get_next_consumer_dev_cb(struct acpi_dep_data *dep, void *da
 	return 0;
 }
 
-struct acpi_scan_clear_dep_work {
-	struct work_struct work;
-	struct acpi_device *adev;
-};
-
-static void acpi_scan_clear_dep_fn(struct work_struct *work)
+static void acpi_scan_clear_dep_fn(void *dev, async_cookie_t cookie)
 {
-	struct acpi_scan_clear_dep_work *cdw;
-
-	cdw = container_of(work, struct acpi_scan_clear_dep_work, work);
+	struct acpi_device *adev = to_acpi_device(dev);
 
 	acpi_scan_lock_acquire();
-	acpi_bus_attach(cdw->adev, (void *)true);
+	acpi_bus_attach(adev, (void *)true);
 	acpi_scan_lock_release();
 
-	acpi_dev_put(cdw->adev);
-	kfree(cdw);
+	acpi_dev_put(adev);
 }
 
 static bool acpi_scan_clear_dep_queue(struct acpi_device *adev)
 {
-	struct acpi_scan_clear_dep_work *cdw;
-
 	if (adev->dep_unmet)
 		return false;
 
-	cdw = kmalloc(sizeof(*cdw), GFP_KERNEL);
-	if (!cdw)
-		return false;
-
-	cdw->adev = adev;
-	INIT_WORK(&cdw->work, acpi_scan_clear_dep_fn);
 	/*
-	 * Since the work function may block on the lock until the entire
-	 * initial enumeration of devices is complete, put it into the unbound
-	 * workqueue.
+	 * Async schedule the deferred acpi_scan_clear_dep_fn() since:
+	 * - acpi_bus_attach() needs to hold acpi_scan_lock which cannot
+	 *   be acquired under acpi_dep_list_lock (held here)
+	 * - the deferred work at boot stage is ensured to be finished
+	 *   before userspace init task by the async_synchronize_full()
+	 *   barrier
+	 *
+	 * Use _nocall variant since it'll return on failure instead of
+	 * run the function synchronously.
 	 */
-	queue_work(system_unbound_wq, &cdw->work);
-
-	return true;
+	return async_schedule_dev_nocall(acpi_scan_clear_dep_fn, &adev->dev);
 }
 
 static void acpi_scan_delete_dep_data(struct acpi_dep_data *dep)
-- 
2.53.0



