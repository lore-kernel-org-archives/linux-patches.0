Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9C2515884;
	Wed, 30 Sep 2026 15:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783669; cv=none; b=pLkHfoXdB7kr+eqhVMHVwQNIbkF+T/SWEdzsqL+sHKQCqYSBQLUxZhYKM9J5utNwJ9M/bNR4KBD1nbXEWbFUw8dNa38En76Em9PP4JhXKgahUOHXyBoTpiZ9lWCDLOyiYYdyuvoJuB7iV9YRinVFKJBxp4OfZd5c7NglnptZQeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783669; c=relaxed/simple;
	bh=tsF+eFxcyZSrwqmArpXFcp5OutgIc0M9d3KcRoqna54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpUAL6FJGF77CvB/IwLp7g7UycxIiyO/Gih++Sd4u6tWOMBhK0CjDfNnB6cgkaMTtZSgH3QFj8ZQTe3SQKAbtUlHSVHyiu49Pp3z8Cb69Zyf0hhiiszCCUusX1x4mSxhaf6a3Sibb1ylhFtWdTufhwlxYrwUNeUo5rkCSs62ZLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qk40JRUx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qk40JRUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D041F00893;
	Wed, 30 Sep 2026 15:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783665;
	bh=sUMAdFiBIiwbZtfM6D2TtdK/R6WSB57vsPMOEgg62zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qk40JRUx9GbGwShS0+bc9+5ot2LRXv7hNjiUFcA8YbbOFPRa7262bd9hwllBJl+j/
	 zQBCcxQ5hy7eZ8yStnASse8/VyYNPylquwVRvC6viHdIXLa523shbVcErGv9Hm2G6Y
	 XtHVlY114JmzaP5A6WJCbGyfW0yduGs7DLduTTXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Jiri Kosina <jkosina@suse.com>,
	Suraj Jitindar Singh <surajjs@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 478/595] HID: hyperv: streamline driver probe to avoid devres issues
Date: Wed, 30 Sep 2026 17:26:11 +0200
Message-ID: <20260930152357.967212431@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 66ef47faa90d838cda131fe1f7776456cc3b59f2 upstream

It was found that unloading 'hid_hyperv' module results in a devres
complaint:

 ...
 hv_vmbus: unregistering driver hid_hyperv
 ------------[ cut here ]------------
 WARNING: CPU: 2 PID: 3983 at drivers/base/devres.c:691 devres_release_group+0x1f2/0x2c0
 ...
 Call Trace:
  <TASK>
  ? devres_release_group+0x1f2/0x2c0
  ? __warn+0xd1/0x1c0
  ? devres_release_group+0x1f2/0x2c0
  ? report_bug+0x32a/0x3c0
  ? handle_bug+0x53/0xa0
  ? exc_invalid_op+0x18/0x50
  ? asm_exc_invalid_op+0x1a/0x20
  ? devres_release_group+0x1f2/0x2c0
  ? devres_release_group+0x90/0x2c0
  ? rcu_is_watching+0x15/0xb0
  ? __pfx_devres_release_group+0x10/0x10
  hid_device_remove+0xf5/0x220
  device_release_driver_internal+0x371/0x540
  ? klist_put+0xf3/0x170
  bus_remove_device+0x1f1/0x3f0
  device_del+0x33f/0x8c0
  ? __pfx_device_del+0x10/0x10
  ? cleanup_srcu_struct+0x337/0x500
  hid_destroy_device+0xc8/0x130
  mousevsc_remove+0xd2/0x1d0 [hid_hyperv]
  device_release_driver_internal+0x371/0x540
  driver_detach+0xc5/0x180
  bus_remove_driver+0x11e/0x2a0
  ? __mutex_unlock_slowpath+0x160/0x5e0
  vmbus_driver_unregister+0x62/0x2b0 [hv_vmbus]
  ...

And the issue seems to be that the corresponding devres group is not
allocated. Normally, devres_open_group() is called from
__hid_device_probe() but Hyper-V HID driver overrides 'hid_dev->driver'
with 'mousevsc_hid_driver' stub and basically re-implements
__hid_device_probe() by calling hid_parse() and hid_hw_start() but not
devres_open_group(). hid_device_probe() does not call __hid_device_probe()
for it. Later, when the driver is removed, hid_device_remove() calls
devres_release_group() as it doesn't check whether hdev->driver was
initially overridden or not.

The issue seems to be related to the commit 62c68e7cee33 ("HID: ensure
timely release of driver-allocated resources") but the commit itself seems
to be correct.

Fix the issue by dropping the 'hid_dev->driver' override and using
hid_register_driver()/hid_unregister_driver() instead. Alternatively, it
would have been possible to rely on the default handling but
HID_CONNECT_DEFAULT implies HID_CONNECT_HIDRAW and it doesn't seem to work
for mousevsc as-is.

Fixes: 62c68e7cee33 ("HID: ensure timely release of driver-allocated resources")
Suggested-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Tested-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[ 5.10: context adjusted only - mousevsc_ll_driver is non-const in 5.10
  because the hid_ll_driver constification (d38213a911c5 "HID: hyperv:
  Constify lowlevel HID driver") is not present; the applied diff is
  identical to the upstream commit, no functional change ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-hyperv.c | 58 ++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 17 deletions(-)

diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
index b9f64e3744885..3fdea2a59ce2f 100644
--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -456,6 +456,25 @@ static int mousevsc_hid_raw_request(struct hid_device *hid,
 	return 0;
 }
 
+static int mousevsc_hid_probe(struct hid_device *hid_dev, const struct hid_device_id *id)
+{
+	int ret;
+
+	ret = hid_parse(hid_dev);
+	if (ret) {
+		hid_err(hid_dev, "parse failed\n");
+		return ret;
+	}
+
+	ret = hid_hw_start(hid_dev, HID_CONNECT_HIDINPUT | HID_CONNECT_HIDDEV);
+	if (ret) {
+		hid_err(hid_dev, "hw start failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
 static struct hid_ll_driver mousevsc_ll_driver = {
 	.parse = mousevsc_hid_parse,
 	.open = mousevsc_hid_open,
@@ -465,7 +484,16 @@ static struct hid_ll_driver mousevsc_ll_driver = {
 	.raw_request = mousevsc_hid_raw_request,
 };
 
-static struct hid_driver mousevsc_hid_driver;
+static const struct hid_device_id mousevsc_devices[] = {
+	{ HID_DEVICE(BUS_VIRTUAL, HID_GROUP_ANY, 0x045E, 0x0621) },
+	{ }
+};
+
+static struct hid_driver mousevsc_hid_driver = {
+	.name = "hid-hyperv",
+	.id_table = mousevsc_devices,
+	.probe = mousevsc_hid_probe,
+};
 
 static int mousevsc_probe(struct hv_device *device,
 			const struct hv_vmbus_device_id *dev_id)
@@ -507,7 +535,6 @@ static int mousevsc_probe(struct hv_device *device,
 	}
 
 	hid_dev->ll_driver = &mousevsc_ll_driver;
-	hid_dev->driver = &mousevsc_hid_driver;
 	hid_dev->bus = BUS_VIRTUAL;
 	hid_dev->vendor = input_dev->hid_dev_info.vendor;
 	hid_dev->product = input_dev->hid_dev_info.product;
@@ -522,20 +549,6 @@ static int mousevsc_probe(struct hv_device *device,
 	if (ret)
 		goto probe_err2;
 
-
-	ret = hid_parse(hid_dev);
-	if (ret) {
-		hid_err(hid_dev, "parse failed\n");
-		goto probe_err2;
-	}
-
-	ret = hid_hw_start(hid_dev, HID_CONNECT_HIDINPUT | HID_CONNECT_HIDDEV);
-
-	if (ret) {
-		hid_err(hid_dev, "hw start failed\n");
-		goto probe_err2;
-	}
-
 	device_init_wakeup(&device->device, true);
 
 	input_dev->connected = true;
@@ -615,12 +628,23 @@ static struct  hv_driver mousevsc_drv = {
 
 static int __init mousevsc_init(void)
 {
-	return vmbus_driver_register(&mousevsc_drv);
+	int ret;
+
+	ret = hid_register_driver(&mousevsc_hid_driver);
+	if (ret)
+		return ret;
+
+	ret = vmbus_driver_register(&mousevsc_drv);
+	if (ret)
+		hid_unregister_driver(&mousevsc_hid_driver);
+
+	return ret;
 }
 
 static void __exit mousevsc_exit(void)
 {
 	vmbus_driver_unregister(&mousevsc_drv);
+	hid_unregister_driver(&mousevsc_hid_driver);
 }
 
 MODULE_LICENSE("GPL");
-- 
2.53.0



