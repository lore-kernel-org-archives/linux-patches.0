Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2D0145B26;
	Thu, 11 Apr 2024 10:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831389; cv=none; b=iiJtvUwif2sGRJ25AMj4Jp68QYLB2PWZdVLVJ4aLzRY0ZhHDdAyqnkAv3+RL3BdxntiZzikPJOhiUraJAHJlhm4T/uA4WhVA+4wx73YtTwV3B9fGeIWeDsD5uAeE6z2mLYp35NlHnTYY9NtE+DAFMKEPqNftPttWhYPNR51n1co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831389; c=relaxed/simple;
	bh=COFVKlh2racAAVz5DU3YA+41zTjaGNUNLR8drrQRxqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwT/9ubg4ZECbwordjJBc3njwrlI1pvUZjKvjBJCC6MS/EOYky49GANB22MOg/inRJVYy+lB1q1MbTotkDWWoFOSBOWEgIW/m3uA+tmDDhmlXZIaQ4nsuVUFMHMgwwkS38y6pTYIsnzMCDRFT+CDHA2PgccdH30AZ/somBnpcEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f68mAXkM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f68mAXkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDE1C433F1;
	Thu, 11 Apr 2024 10:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831389;
	bh=COFVKlh2racAAVz5DU3YA+41zTjaGNUNLR8drrQRxqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f68mAXkMJcyfFMnpykxVz53w8CxxmfgWCR6JDNAo0Ox4k0wW/hjcaVbErAZqyc83d
	 WQgR+mBBOO4+RnwfE6I0so8c29+RMVPwFTAbm+QOI5CKCxaRhxHyhsq69r7trLHGN6
	 PWsMuz3ONbijNr5oEcN2ogAxZ0fV0ANpUDUppHb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/114] HID: input: avoid polling stylus battery on Chromebook Pompom
Date: Thu, 11 Apr 2024 11:56:34 +0200
Message-ID: <20240411095418.907764802@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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
index 72046039d1be7..0a4daff4846ff 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -427,6 +427,7 @@
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



