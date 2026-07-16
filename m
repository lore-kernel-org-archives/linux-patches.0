Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65C73F0774;
	Thu, 16 Jul 2026 14:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210409; cv=none; b=nSw5WpGmcWWtW8AYZnHJJYER6UZqJj/egY7b+j5k2Mf3C5fExcYNff4Seb5A+2ZSOgdb5oE5XibfM5BZJKDjIKkHtjvZv0birpas2LsNhTcT3E8k0+InbsxBmpOCWw+SNxDSwsOY/inH/6PEk3QHCVUzAUi/eN9Dai5zyhtPZcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210409; c=relaxed/simple;
	bh=7lGmVyNKIy5KKKX+AC9K56KjwXBqkCi0/eJslNmNbWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JEePE77gusz1oZhs8MLiPz4JdcSoAERdpsUXWYodaNx1GFolpD65jPq1rVgqRa5oOQY/BE3c+LJo5f0ILPpTUYlHhUNSC1qF2z6K96xu2uXSUoOh1joqME0Zrin3yCUH1oL/5BkAZuil8RRrfBzK73vWW1y5UbMzUArS/X9P7Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGZeZZTW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGZeZZTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13891F000E9;
	Thu, 16 Jul 2026 14:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210408;
	bh=6hEcPY2b+wNz3JRXSrPy1l4UanK0bEXeH/eR8BNKU+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CGZeZZTWaLhGjGSg7tI2RfwGpv5TcEaAuEY5M3o2+pPKU0mtnzYGTXlfaoaa6bJ/D
	 6ZtMDmAbkRjR9Xjp6cZra+iXq7PLUH5KpSfL3RWOXSjDQCfA02kcBOn7jcMVJy66MH
	 gEe6DmWk55YDYMwkKHD5js2yKusq5pps3jjKNqaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 035/480] platform/x86: intel-hid: Protect ACPI notify handler against recursion
Date: Thu, 16 Jul 2026 15:26:22 +0200
Message-ID: <20260716133045.459994899@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

commit c085d82613d5618814b84406c8b2d64f1bc305e7 upstream.

Since commit e2ffcda16290 ("ACPI: OSL: Allow Notify () handlers to run on
all CPUs") ACPI notify handlers like the intel-hid notify_handler() may
run on multiple CPU cores racing with themselves.

On convertibles and detachables (matched by DMI chassis-type 31 and 32 in
dmi_auto_add_switch[]) the SW_TABLET_MODE input device is registered
lazily from notify_handler() on the first tablet-mode event, via
intel_hid_switches_setup(). When two such events race on different CPUs
both can pass the !priv->switches check and register the priv->switches
input device twice, resulting in a duplicate sysfs entry and a subsequent
NULL pointer dereference.

This is the same class of bug fixed by commit e075c3b13a0a ("platform/x86:
intel-vbtn: Protect ACPI notify handler against recursion") for the
sibling intel-vbtn driver.

Protect intel-hid notify_handler() from racing with itself with a mutex
to fix this.

Fixes: e2ffcda16290 ("ACPI: OSL: Allow Notify () handlers to run on all CPUs")
Cc: stable@vger.kernel.org
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260605174905.131095-1-sammiee5311@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/hid.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -7,11 +7,13 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/cleanup.h>
 #include <linux/dmi.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/platform_device.h>
 #include <linux/string_choices.h>
 #include <linux/suspend.h>
@@ -224,6 +226,7 @@ static const struct dmi_system_id dmi_au
 };
 
 struct intel_hid_priv {
+	struct mutex mutex; /* Avoid notify_handler() racing with itself */
 	struct input_dev *input_dev;
 	struct input_dev *array;
 	struct input_dev *switches;
@@ -559,6 +562,8 @@ static void notify_handler(acpi_handle h
 	struct key_entry *ke;
 	int err;
 
+	guard(mutex)(&priv->mutex);
+
 	/*
 	 * Some convertible have unreliable VGBS return which could cause incorrect
 	 * SW_TABLET_MODE report, in these cases we enable support when receiving
@@ -714,6 +719,10 @@ static int intel_hid_probe(struct platfo
 		return -ENOMEM;
 	dev_set_drvdata(&device->dev, priv);
 
+	err = devm_mutex_init(&device->dev, &priv->mutex);
+	if (err)
+		return err;
+
 	/* See dual_accel_detect.h for more info on the dual_accel check. */
 	if (enable_sw_tablet_mode == TABLET_SW_AUTO) {
 		if (dmi_check_system(dmi_vgbs_allow_list))


