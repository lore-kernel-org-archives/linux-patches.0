Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211D6155C82;
	Tue, 30 Sep 2025 15:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246239; cv=none; b=lhsBOAJXAmx5Wkxo3eH47cGPRg0dsTc9P+Gajsa0vYUYF9NSWTTjPosMtj/qwyfsVRcg1zFr86U7q09KUKx8jRkLVHArMxwhXzDCNsbbymqJegWq1Iv77LEM7FYEooSXFq8MUjf7LzpXeK8MYE4f6uB+PkRwTUUuubdk+Z5eu38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246239; c=relaxed/simple;
	bh=LXxdTSitdDHpMCIZR60xPi9fSeS+Lx2AddacifcdDqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ow2uaBQFIQ4LsGQV1or1mZ+RPfIPQK0KiO4f5DCvhflirbE1JneTxkpszaNhRfHHtp735FZc+DYqCOlvsqSjreGTKPcG45vyPetMvlOelu+ltX1glpRhayH+KdHgQl8uoPboQvkY/rC6c20/1Bhc1dg522Ib4ScWApW7jjk98nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmoXeiMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmoXeiMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92793C4CEF0;
	Tue, 30 Sep 2025 15:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246239;
	bh=LXxdTSitdDHpMCIZR60xPi9fSeS+Lx2AddacifcdDqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmoXeiMaLvQ2KkQsx/xJw0DQls/k5WOcwdeaRR2dbTM/MqT++Vcg+hV5+RZBJ4OLH
	 aIQaBF+H/uuJSgRziFPjyZy3gjujTYYBqJJb4ROwKYKMCLlIbtJuTD8pYpVttjuLdW
	 IfD3+tEHqJs54DtJkxACXmK3unmRsgk5cITP9Hqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lee <dany97@live.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 64/89] platform/x86: lg-laptop: Fix WMAB call in fan_mode_store()
Date: Tue, 30 Sep 2025 16:48:18 +0200
Message-ID: <20250930143824.561580215@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Lee <dany97@live.ca>

[ Upstream commit 3ed17349f18774c24505b0c21dfbd3cc4f126518 ]

When WMAB is called to set the fan mode, the new mode is read from either
bits 0-1 or bits 4-5 (depending on the value of some other EC register).
Thus when WMAB is called with bits 4-5 zeroed and called again with
bits 0-1 zeroed, the second call undoes the effect of the first call.
This causes writes to /sys/devices/platform/lg-laptop/fan_mode to have
no effect (and causes reads to always report a status of zero).

Fix this by calling WMAB once, with the mode set in bits 0,1 and 4,5.
When the fan mode is returned from WMAB it always has this form, so
there is no need to preserve the other bits.  As a bonus, the driver
now supports the "Performance" fan mode seen in the LG-provided Windows
control app, which provides less aggressive CPU throttling but louder
fan noise and shorter battery life.

Also, correct the documentation to reflect that 0 corresponds to the
default mode (what the Windows app calls "Optimal") and 1 corresponds
to the silent mode.

Fixes: dbf0c5a6b1f8 ("platform/x86: Add LG Gram laptop special features driver")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=204913#c4
Signed-off-by: Daniel Lee <dany97@live.ca>
Link: https://patch.msgid.link/MN2PR06MB55989CB10E91C8DA00EE868DDC1CA@MN2PR06MB5598.namprd06.prod.outlook.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/laptops/lg-laptop.rst         |  4 +--
 drivers/platform/x86/lg-laptop.c              | 34 ++++++++-----------
 2 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/Documentation/admin-guide/laptops/lg-laptop.rst b/Documentation/admin-guide/laptops/lg-laptop.rst
index 67fd6932cef4f..c4dd534f91edd 100644
--- a/Documentation/admin-guide/laptops/lg-laptop.rst
+++ b/Documentation/admin-guide/laptops/lg-laptop.rst
@@ -48,8 +48,8 @@ This value is reset to 100 when the kernel boots.
 Fan mode
 --------
 
-Writing 1/0 to /sys/devices/platform/lg-laptop/fan_mode disables/enables
-the fan silent mode.
+Writing 0/1/2 to /sys/devices/platform/lg-laptop/fan_mode sets fan mode to
+Optimal/Silent/Performance respectively.
 
 
 USB charge
diff --git a/drivers/platform/x86/lg-laptop.c b/drivers/platform/x86/lg-laptop.c
index 4b57102c7f627..6af6cf477c5b5 100644
--- a/drivers/platform/x86/lg-laptop.c
+++ b/drivers/platform/x86/lg-laptop.c
@@ -8,6 +8,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/acpi.h>
+#include <linux/bitfield.h>
 #include <linux/bits.h>
 #include <linux/device.h>
 #include <linux/dev_printk.h>
@@ -75,6 +76,9 @@ MODULE_PARM_DESC(fw_debug, "Enable printing of firmware debug messages");
 #define WMBB_USB_CHARGE 0x10B
 #define WMBB_BATT_LIMIT 0x10C
 
+#define FAN_MODE_LOWER GENMASK(1, 0)
+#define FAN_MODE_UPPER GENMASK(5, 4)
+
 #define PLATFORM_NAME   "lg-laptop"
 
 MODULE_ALIAS("wmi:" WMI_EVENT_GUID0);
@@ -274,29 +278,19 @@ static ssize_t fan_mode_store(struct device *dev,
 			      struct device_attribute *attr,
 			      const char *buffer, size_t count)
 {
-	bool value;
+	unsigned long value;
 	union acpi_object *r;
-	u32 m;
 	int ret;
 
-	ret = kstrtobool(buffer, &value);
+	ret = kstrtoul(buffer, 10, &value);
 	if (ret)
 		return ret;
+	if (value >= 3)
+		return -EINVAL;
 
-	r = lg_wmab(dev, WM_FAN_MODE, WM_GET, 0);
-	if (!r)
-		return -EIO;
-
-	if (r->type != ACPI_TYPE_INTEGER) {
-		kfree(r);
-		return -EIO;
-	}
-
-	m = r->integer.value;
-	kfree(r);
-	r = lg_wmab(dev, WM_FAN_MODE, WM_SET, (m & 0xffffff0f) | (value << 4));
-	kfree(r);
-	r = lg_wmab(dev, WM_FAN_MODE, WM_SET, (m & 0xfffffff0) | value);
+	r = lg_wmab(dev, WM_FAN_MODE, WM_SET,
+		FIELD_PREP(FAN_MODE_LOWER, value) |
+		FIELD_PREP(FAN_MODE_UPPER, value));
 	kfree(r);
 
 	return count;
@@ -305,7 +299,7 @@ static ssize_t fan_mode_store(struct device *dev,
 static ssize_t fan_mode_show(struct device *dev,
 			     struct device_attribute *attr, char *buffer)
 {
-	unsigned int status;
+	unsigned int mode;
 	union acpi_object *r;
 
 	r = lg_wmab(dev, WM_FAN_MODE, WM_GET, 0);
@@ -317,10 +311,10 @@ static ssize_t fan_mode_show(struct device *dev,
 		return -EIO;
 	}
 
-	status = r->integer.value & 0x01;
+	mode = FIELD_GET(FAN_MODE_LOWER, r->integer.value);
 	kfree(r);
 
-	return sysfs_emit(buffer, "%d\n", status);
+	return sysfs_emit(buffer, "%d\n", mode);
 }
 
 static ssize_t usb_charge_store(struct device *dev,
-- 
2.51.0



