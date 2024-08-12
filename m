Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F70183CA6;
	Mon, 12 Aug 2024 16:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479837; cv=none; b=eMBTBQ+Azgbbph/JvtbZSKS6CQKbTVprpWtxczWMd8yeMpJdNGxiCAeoZg3/x30HV5BouSHPLcKCAcBjypZVB1IZiqM32aPMy2TpNcRYF2oEO0/EvJrsBYQIekAspb5mOzqgErjvGqJ2v2qrdo47QTaurtCq7HcTnVHYdMQ/bcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479837; c=relaxed/simple;
	bh=QDpcQKQpVS7dZ12qzOJMfHfdNzP3QM4UNhBwaHJZ9ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ozG1lROJ1+RMVwO7PbIVjEPxpQSgFaiK5ajAakfzwbbEGSAQJ4/SmlR+uXxHxA0T5AjVdhwmMQRVopFaA40yDJK+WtMF5ReIHSxhi9Fp3/Nc7tIAHd1HbR5BfIXF4daQSn4AdEzAZLvj8tDjplwchrPSdqXel6qOyk9NaKnX1rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b87IdasH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b87IdasH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA74C32782;
	Mon, 12 Aug 2024 16:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479837;
	bh=QDpcQKQpVS7dZ12qzOJMfHfdNzP3QM4UNhBwaHJZ9ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b87IdasHhJQRrBm3sF7jhDGQrjPr2CUhKUugkI8Q4qiohkIxZ54Fj2T2HTSdhpL++
	 4a+yizTmWzkT4129aqQ/u9XLZ3EbOABrGfEcBOBq5+cIvBwArBbjnuUWMbM9oprsC7
	 l3S9FzsixuwN27Ui9sMRLDFJAYafxIQBjvcMVvVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	En-Wei Wu <en-wei.wu@canonical.com>,
	Kostadin Stoilov <kmstoilov@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 006/263] platform/x86: intel-vbtn: Protect ACPI notify handler against recursion
Date: Mon, 12 Aug 2024 18:00:07 +0200
Message-ID: <20240812160146.768945897@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit e075c3b13a0a142dcd3151b25d29a24f31b7b640 ]

Since commit e2ffcda16290 ("ACPI: OSL: Allow Notify () handlers to run on
all CPUs") ACPI notify handlers like the intel-vbtn notify_handler() may
run on multiple CPU cores racing with themselves.

This race gets hit on Dell Venue 7140 tablets when undocking from
the keyboard, causing the handler to try and register priv->switches_dev
twice, as can be seen from the dev_info() message getting logged twice:

[ 83.861800] intel-vbtn INT33D6:00: Registering Intel Virtual Switches input-dev after receiving a switch event
[ 83.861858] input: Intel Virtual Switches as /devices/pci0000:00/0000:00:1f.0/PNP0C09:00/INT33D6:00/input/input17
[ 83.861865] intel-vbtn INT33D6:00: Registering Intel Virtual Switches input-dev after receiving a switch event

After which things go seriously wrong:
[ 83.861872] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:1f.0/PNP0C09:00/INT33D6:00/input/input17'
...
[ 83.861967] kobject: kobject_add_internal failed for input17 with -EEXIST, don't try to register things with the same name in the same directory.
[ 83.877338] BUG: kernel NULL pointer dereference, address: 0000000000000018
...

Protect intel-vbtn notify_handler() from racing with itself with a mutex
to fix this.

Fixes: e2ffcda16290 ("ACPI: OSL: Allow Notify () handlers to run on all CPUs")
Reported-by: En-Wei Wu <en-wei.wu@canonical.com>
Closes: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2073001
Tested-by: Kostadin Stoilov <kmstoilov@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240729120443.14779-1-hdegoede@redhat.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/vbtn.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/intel/vbtn.c b/drivers/platform/x86/intel/vbtn.c
index 9b7ce03ba085c..a353e830b65fd 100644
--- a/drivers/platform/x86/intel/vbtn.c
+++ b/drivers/platform/x86/intel/vbtn.c
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
 #include <linux/suspend.h>
 #include "../dual_accel_detect.h"
@@ -66,6 +68,7 @@ static const struct key_entry intel_vbtn_switchmap[] = {
 };
 
 struct intel_vbtn_priv {
+	struct mutex mutex; /* Avoid notify_handler() racing with itself */
 	struct input_dev *buttons_dev;
 	struct input_dev *switches_dev;
 	bool dual_accel;
@@ -155,6 +158,8 @@ static void notify_handler(acpi_handle handle, u32 event, void *context)
 	bool autorelease;
 	int ret;
 
+	guard(mutex)(&priv->mutex);
+
 	if ((ke = sparse_keymap_entry_from_scancode(priv->buttons_dev, event))) {
 		if (!priv->has_buttons) {
 			dev_warn(&device->dev, "Warning: received 0x%02x button event on a device without buttons, please report this.\n",
@@ -290,6 +295,10 @@ static int intel_vbtn_probe(struct platform_device *device)
 		return -ENOMEM;
 	dev_set_drvdata(&device->dev, priv);
 
+	err = devm_mutex_init(&device->dev, &priv->mutex);
+	if (err)
+		return err;
+
 	priv->dual_accel = dual_accel;
 	priv->has_buttons = has_buttons;
 	priv->has_switches = has_switches;
-- 
2.43.0



