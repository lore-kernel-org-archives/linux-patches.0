Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6269F26296;
	Mon, 14 Oct 2024 14:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917166; cv=none; b=bvBdbJMyok1Z66fIb/yZouf/Bpc23sQOhgsmu5mtiqGJtuBR1ikPNI7BA3itzgooothyVNQgWd8A12ni6mboM0IpaFESNdO68LoPpWJ+1bwVqQynKDM3Sn9FNiugntjGy5Zs5cmorkGw+nplD35fexD0fMx2Ffwh3c7GibkyDN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917166; c=relaxed/simple;
	bh=SkHJMSLuHyELeKGqqXIAE6VAbmpg3FAGtmdf5Ywd844=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpFoclkE3qYsKK0InnLhjseR5/Z87hZoCDKDKdb+b0UeAW3VYtgrYTNulmFoCMz8EZlvuUwGWj8Ez44pIXUhlUzh0EANVIASukKG162u9yxZG0D8d86oVxTx5ofv7OfOu4qKebFkAz8hhDeksSxTMS5MdPqULWDIqMvO6n+e2Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9+NBrCL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9+NBrCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BF1C4CEC3;
	Mon, 14 Oct 2024 14:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917166;
	bh=SkHJMSLuHyELeKGqqXIAE6VAbmpg3FAGtmdf5Ywd844=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9+NBrCLOmUoMmTQ7yGCiXUpWqvw+764gPXDfawv5VZa8Ow8N5z1D+xcFPoUouiMK
	 197wwkdEx2Dc9iE+FLeXt4sTG6qCvxCKxk8LVbZsIyYnIlRWJSCvlZaCF8JrVPUctR
	 FscTaPmohyBm3z9F7zclw1Fud071J8nlebjLnFy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Douglas Anderson <dianders@chromium.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 169/213] HID: i2c-hid: Skip SET_POWER SLEEP for Cirque touchpad on system suspend
Date: Mon, 14 Oct 2024 16:21:15 +0200
Message-ID: <20241014141049.565319887@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 26dd6a5667f500c5d991f90a9ac5998a71afaf5c ]

There's a Cirque touchpad that wakes system up without anything touched
the touchpad. The input report is empty when this happens.
The reason is stated in HID over I2C spec, 7.2.8.2:
"If the DEVICE wishes to wake the HOST from its low power state, it can
issue a wake by asserting the interrupt."

This is fine if OS can put system back to suspend by identifying input
wakeup count stays the same on resume, like Chrome OS Dark Resume [0].
But for regular distro such policy is lacking.

Though the change doesn't bring any impact on power consumption for
touchpad is minimal, other i2c-hid device may depends on SLEEP control
power. So use a quirk to limit the change scope.

[0] https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/power_manager/docs/dark_resume.md

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h              | 3 +++
 drivers/hid/i2c-hid/i2c-hid-core.c | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index f7bf744ba7548..f1d49db9fddce 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -298,6 +298,9 @@
 
 #define USB_VENDOR_ID_CIDC		0x1677
 
+#define I2C_VENDOR_ID_CIRQUE           0x0488
+#define I2C_PRODUCT_ID_CIRQUE_1063     0x1063
+
 #define USB_VENDOR_ID_CJTOUCH		0x24b8
 #define USB_DEVICE_ID_CJTOUCH_MULTI_TOUCH_0020	0x0020
 #define USB_DEVICE_ID_CJTOUCH_MULTI_TOUCH_0040	0x0040
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 6f1eb77cbcded..045db6f0fb4c4 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -49,6 +49,7 @@
 #define I2C_HID_QUIRK_RESET_ON_RESUME		BIT(2)
 #define I2C_HID_QUIRK_BAD_INPUT_SIZE		BIT(3)
 #define I2C_HID_QUIRK_NO_WAKEUP_AFTER_RESET	BIT(4)
+#define I2C_HID_QUIRK_NO_SLEEP_ON_SUSPEND	BIT(5)
 
 /* Command opcodes */
 #define I2C_HID_OPCODE_RESET			0x01
@@ -130,6 +131,8 @@ static const struct i2c_hid_quirks {
 		 I2C_HID_QUIRK_RESET_ON_RESUME },
 	{ USB_VENDOR_ID_ITE, I2C_DEVICE_ID_ITE_LENOVO_LEGION_Y720,
 		I2C_HID_QUIRK_BAD_INPUT_SIZE },
+	{ I2C_VENDOR_ID_CIRQUE, I2C_PRODUCT_ID_CIRQUE_1063,
+		I2C_HID_QUIRK_NO_SLEEP_ON_SUSPEND },
 	/*
 	 * Sending the wakeup after reset actually break ELAN touchscreen controller
 	 */
@@ -945,7 +948,8 @@ static int i2c_hid_core_suspend(struct i2c_hid *ihid, bool force_poweroff)
 		return ret;
 
 	/* Save some power */
-	i2c_hid_set_power(ihid, I2C_HID_PWR_SLEEP);
+	if (!(ihid->quirks & I2C_HID_QUIRK_NO_SLEEP_ON_SUSPEND))
+		i2c_hid_set_power(ihid, I2C_HID_PWR_SLEEP);
 
 	disable_irq(client->irq);
 
-- 
2.43.0



