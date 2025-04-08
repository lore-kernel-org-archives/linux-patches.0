Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2551AAA0F;
	Tue,  8 Apr 2025 12:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113855; cv=none; b=kTHwygmt5fjMenWRzkFblyux+6O7ZSoS4IcHSeReyxnDdIBvbcM4zApQFeW8m6VNVfT9fKl2T5LeX865MNTNcbBA2oEuKWqC4QvORZ3Azx3ipEI8z4VoViyG0OF1feaVCX8UjHfywsMRl3zUInsvKdOroYqWReqf9TUtgsIOjyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113855; c=relaxed/simple;
	bh=GuvO47yP22s7wYcR4N568YNSGCo+e5nkgHcn1q8+Sac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYF0hD88JSh48s1mwuHZUQq01+86HqEM2tUI0EPAi5gHF141z3ay0Rgy6nK2LhuwW6w+jYPXTIVqe+Qojg7rZmXOa55YG/iMR13/F7cFkbQXzQRkAbjSIWYhjD+i1Kfn6ndSHEXBpz/b8c0+eDP5sOd82ji0sDmUDq03pxn0zic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gjbRcDt/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gjbRcDt/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1696BC4CEE5;
	Tue,  8 Apr 2025 12:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113855;
	bh=GuvO47yP22s7wYcR4N568YNSGCo+e5nkgHcn1q8+Sac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gjbRcDt/K5NU0yMihmJ2Ft/c//Fym1d1jdhK9A+ivgPhY9FZNTdhLe/ig64s3Yelm
	 kzQtD5hUMttKy1OEb5Nm3AFpRMU29MW6oR7v1QDAPFjQ3/C27cdwGzLvlB+XuFqgCB
	 LeRAbD4KmG51eTI860PKaOlRSueo/DgJhPfJkoss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 028/154] HID: ignore non-functional sensor in HP 5MP Camera
Date: Tue,  8 Apr 2025 12:49:29 +0200
Message-ID: <20250408104816.166616747@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index bc0115548a579..d5369577b4755 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1005,6 +1005,7 @@
 #define USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3001		0x3001
 #define USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3003		0x3003
 #define USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3008		0x3008
+#define USB_DEVICE_ID_QUANTA_HP_5MP_CAMERA_5473		0x5473
 
 #define I2C_VENDOR_ID_RAYDIUM		0x2386
 #define I2C_PRODUCT_ID_RAYDIUM_4B33	0x4b33
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 99009fda7b80a..9b375ca53946e 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -876,6 +876,7 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS, USB_DEVICE_ID_SYNAPTICS_DPAD) },
 #endif
 	{ HID_USB_DEVICE(USB_VENDOR_ID_YEALINK, USB_DEVICE_ID_YEALINK_P1K_P4K_B2K) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_HP_5MP_CAMERA_5473) },
 	{ }
 };
 
-- 
2.39.5



