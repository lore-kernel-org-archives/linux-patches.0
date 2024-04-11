Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A3D145323;
	Thu, 11 Apr 2024 10:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830255; cv=none; b=Qtas3gMq5H43VM7aq11gfDkBd6PTJyz/t7zfRl6VB0Q18mWPA2SvK4fht33/Jpba6QqWD+DjjI7fgyPi7hF1IPG3L+/w+V60Unz3sEIzcjUOr6ZlRuQbbb1lZSrlmRHxGHGSmaVBtFkfKacUm8QvSJvScyXwkqzkb4yZbHQ+45M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830255; c=relaxed/simple;
	bh=QHLQ1f2UlCT/5dwQCZrXkBuPTYqmzT2nujX2ee+MtOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcsjd9a1KI4ZfseEV+DKqqsTJJ0Ur8WzBfW5RmCAsXOC3RJDtArLwLeKZEuuyCGw0HeyVUUAi3F1T0n7MT6zBIjvG96OA3z2hCudLQKr0ikBpM6PvsijrYtWGYegEwvAX8VukIf1tO/dL2lKxF9l92Vz1Z2Sr1vRekXKK8pET98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udaY4hZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udaY4hZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C44C43390;
	Thu, 11 Apr 2024 10:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830254;
	bh=QHLQ1f2UlCT/5dwQCZrXkBuPTYqmzT2nujX2ee+MtOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udaY4hZscIxCirP2+ieIFdGk2HjbSlHuidKsQ9W8TKEqRAB2oqanyHS8rGMspWBCJ
	 1fhnItbFHZSCgAMWUyw0Jqg8CHHY/ZgDRNIrIlQYbTxCZf85yolj5ESwyIkpj7AGk6
	 h7PRCi5rbwag2El1VQrETyEzg8GJ+cj32Qmb9LMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 086/143] HID: input: avoid polling stylus battery on Chromebook Pompom
Date: Thu, 11 Apr 2024 11:55:54 +0200
Message-ID: <20240411095423.499015059@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 9a5b1521e2d0d7ace70c6e5eed073babcec91409 ]

Internal touchscreen on Trogdor Pompom (AKA Dynabook Chromebook C1)
supports USI stylus. Unfortunately the HID descriptor for the stylus
interface does not contain "Stylus" physical collection, which makes
the kernel to try and pull battery information, resulting in errors.

Apply HID_BATTERY_QUIRK_AVOID_QUERY to the device.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h   | 1 +
 drivers/hid/hid-input.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 828a5c022c640..175b6680087e0 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -430,6 +430,7 @@
 #define I2C_DEVICE_ID_HP_SPECTRE_X360_14T_EA100_V1	0x2BED
 #define I2C_DEVICE_ID_HP_SPECTRE_X360_14T_EA100_V2	0x2BEE
 #define I2C_DEVICE_ID_HP_ENVY_X360_15_EU0556NG		0x2D02
+#define I2C_DEVICE_ID_CHROMEBOOK_TROGDOR_POMPOM	0x2F81
 
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index c8b20d44b1472..e03d300d2bac4 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -411,6 +411,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_ENVY_X360_15_EU0556NG),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_CHROMEBOOK_TROGDOR_POMPOM),
+	  HID_BATTERY_QUIRK_AVOID_QUERY },
 	{}
 };
 
-- 
2.43.0



