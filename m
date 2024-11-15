Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463A82BB1B;
	Fri, 15 Nov 2024 06:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653302; cv=none; b=a+ISCmqvQEcFffu3YR5Sju5SdAvumpNWA2Pd/U5xDdSoWapyLcOd46O4/3qTJfNKhB8oZPKhbqYv7QA6JZaCnu2DCn+z1F7FGwvmAhOmrnzOv57n7IO0/XIlJwyvoHsXnlLiPp2Mvc3Jsbk87s+OpAhGzMZRGVE7rbV/38tUlJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653302; c=relaxed/simple;
	bh=nQ2RuCg/jHbQJlFAFLh8a21CaGg7soj8ouXs5WcEGlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bCuP7VK17Qrptda/42dZiAEbfWmImAJc5rj+9jzTa9H05C7cjlTNgX7aT/O7NKgj68yeJN1TRZSavq4Q3zyWDfadIIO3HXw+AcT291rasWHZxaoL6qf91qJliGHe/jDYW1J0Ww0YMwOg3wx/2xbEg1OGXITcxQU4qbcMtcf4Li8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opdIht4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opdIht4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E75AC4CECF;
	Fri, 15 Nov 2024 06:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653302;
	bh=nQ2RuCg/jHbQJlFAFLh8a21CaGg7soj8ouXs5WcEGlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opdIht4u1UnQGFytto4Cy57g+mxOwSc3++ak05P/LbCBr9ZPZuC2nLW1yp4mq3aoO
	 pyLE++261ZrxoXWCB2jhkwZGUAX05UltZWqaNzGTYRhKSZddmQa7IQVBTT7OZUh2CM
	 sm4aCcvRoHoZxRsHpeaiNWzq3j/yA8w/fg4KVv6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bart=C5=82omiej=20Mary=C5=84czak?= <marynczakbartlomiej@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 46/63] HID: i2c-hid: Delayed i2c resume wakeup for 0x0d42 Goodix touchpad
Date: Fri, 15 Nov 2024 07:38:09 +0100
Message-ID: <20241115063727.574560864@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartłomiej Maryńczak <marynczakbartlomiej@gmail.com>

[ Upstream commit 293c485cbac2607595fdaae2b1fb390fc7b2d014 ]

Patch for Goodix 27c6:0d42 touchpads found in Inspiron 5515 laptops.

After resume from suspend, one can communicate with this device just fine.
We can read data from it or request a reset,
but for some reason the interrupt line will not go up
when new events are available.
(it can correctly respond to a reset with an interrupt tho)

The only way I found to wake this device up
is to send anything to it after ~1.5s mark,
for example a simple read request, or power mode change.

In this patch, I simply delay the resume steps with msleep,
this will cause the set_power request to happen after
the ~1.5s barrier causing the device to resume its event interrupts.

Sleep was used rather than delayed_work
to make this workaround as non-invasive as possible.

[jkosina@suse.com: shortlog update]
Signed-off-by: Bartłomiej Maryńczak <marynczakbartlomiej@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h              |  1 +
 drivers/hid/i2c-hid/i2c-hid-core.c | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 8a991b30e3c6d..25f96494700d8 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -509,6 +509,7 @@
 #define I2C_DEVICE_ID_GOODIX_01E8	0x01e8
 #define I2C_DEVICE_ID_GOODIX_01E9	0x01e9
 #define I2C_DEVICE_ID_GOODIX_01F0	0x01f0
+#define I2C_DEVICE_ID_GOODIX_0D42	0x0d42
 
 #define USB_VENDOR_ID_GOODTOUCH		0x1aad
 #define USB_DEVICE_ID_GOODTOUCH_000f	0x000f
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 2f8a9d3f1e861..8914c7db94718 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -50,6 +50,7 @@
 #define I2C_HID_QUIRK_BAD_INPUT_SIZE		BIT(3)
 #define I2C_HID_QUIRK_NO_WAKEUP_AFTER_RESET	BIT(4)
 #define I2C_HID_QUIRK_NO_SLEEP_ON_SUSPEND	BIT(5)
+#define I2C_HID_QUIRK_DELAY_WAKEUP_AFTER_RESUME BIT(6)
 
 /* Command opcodes */
 #define I2C_HID_OPCODE_RESET			0x01
@@ -140,6 +141,8 @@ static const struct i2c_hid_quirks {
 	{ USB_VENDOR_ID_ELAN, HID_ANY_ID,
 		 I2C_HID_QUIRK_NO_WAKEUP_AFTER_RESET |
 		 I2C_HID_QUIRK_BOGUS_IRQ },
+	{ I2C_VENDOR_ID_GOODIX, I2C_DEVICE_ID_GOODIX_0D42,
+		 I2C_HID_QUIRK_DELAY_WAKEUP_AFTER_RESUME },
 	{ 0, 0 }
 };
 
@@ -981,6 +984,13 @@ static int i2c_hid_core_resume(struct i2c_hid *ihid)
 		return -ENXIO;
 	}
 
+	/* On Goodix 27c6:0d42 wait extra time before device wakeup.
+	 * It's not clear why but if we send wakeup too early, the device will
+	 * never trigger input interrupts.
+	 */
+	if (ihid->quirks & I2C_HID_QUIRK_DELAY_WAKEUP_AFTER_RESUME)
+		msleep(1500);
+
 	/* Instead of resetting device, simply powers the device on. This
 	 * solves "incomplete reports" on Raydium devices 2386:3118 and
 	 * 2386:4B33 and fixes various SIS touchscreens no longer sending
-- 
2.43.0



