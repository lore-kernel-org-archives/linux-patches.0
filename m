Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B7B1E1E11;
	Wed, 19 Mar 2025 14:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395050; cv=none; b=Qhk1F5KvrQLZ65eZFocKRY33wZ55OKt6QS8I9bvtxjpuaCrqIQSGCcKPs4JYbWzNSYlKBYBytQc59MQeF1A865afsmYEf+y6zqNb9v4sQSM8td7ToTbFLS7lbArXV+KWKDJXuILDrYb4rx2IGqhRw24DPqwwlA8MHOGmd07sqNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395050; c=relaxed/simple;
	bh=l/6oIgKxa7ETyrfTDiP0GaNYvTjkYAYAdfAksnJsRc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgUV/es/pBZ36DtECBmBAgF8HwX2ADw4FkqRpfDwQ9ddDjbb+AtcRCEzef9dB31a3hVFrZMtRFEaPosG6OAkvzNnu44iGlksdYd3aBM3zHu4nUfsg4SP0sf7oNLASNYSq1GiUCWn0qMUsu4O5zwUwf4a5k6xZfwjrTZJagq4DI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ifBa65VW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ifBa65VW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398C6C4CEE4;
	Wed, 19 Mar 2025 14:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395050;
	bh=l/6oIgKxa7ETyrfTDiP0GaNYvTjkYAYAdfAksnJsRc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifBa65VWT5JtNbUxkxwB5d29xcCbsvbQeLzlZPesQlsb7IgBMYGYnf2FeMZjGoUMa
	 SzFdfOJPths2Ycb5uDVV722NvR3XtipRI0RaHe9+Hw7sOf/sPqn7zzvRrBpQ3/CUiX
	 0yHmjqMozfo1iKZe21mOio3/Wg77/6qLw17ZSgfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/231] HID: ignore non-functional sensor in HP 5MP Camera
Date: Wed, 19 Mar 2025 07:29:30 -0700
Message-ID: <20250319143028.735313445@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>

[ Upstream commit 363236d709e75610b628c2a4337ccbe42e454b6d ]

The HP 5MP Camera (USB ID 0408:5473) reports a HID sensor interface that
is not actually implemented. Attempting to access this non-functional
sensor via iio_info causes system hangs as runtime PM tries to wake up
an unresponsive sensor.

  [453] hid-sensor-hub 0003:0408:5473.0003: Report latency attributes: ffffffff:ffffffff
  [453] hid-sensor-hub 0003:0408:5473.0003: common attributes: 5:1, 2:1, 3:1 ffffffff:ffffffff

Add this device to the HID ignore list since the sensor interface is
non-functional by design and should not be exposed to userspace.

Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index ceb3b1a72e235..6e8bcb1518bd7 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1089,6 +1089,7 @@
 #define USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3001		0x3001
 #define USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3003		0x3003
 #define USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3008		0x3008
+#define USB_DEVICE_ID_QUANTA_HP_5MP_CAMERA_5473		0x5473
 
 #define I2C_VENDOR_ID_RAYDIUM		0x2386
 #define I2C_PRODUCT_ID_RAYDIUM_4B33	0x4b33
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index e0bbf0c6345d6..5d7a418ccdbec 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -891,6 +891,7 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_DPAD) },
 #endif
 	{ HID_USB_DEVICE(USB_VENDOR_ID_YEALINK, USB_DEVICE_ID_YEALINK_P1K_P4K_B2K) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_HP_5MP_CAMERA_5473) },
 	{ }
 };
 
-- 
2.39.5



