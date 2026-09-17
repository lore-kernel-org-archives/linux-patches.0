Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C5B4D1784;
	Thu, 17 Sep 2026 17:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665974; cv=none; b=J2EZUnQ4y4kcsmhu6NYa+8ARqvdGlp7Kl8VTJCw/4OjwL/yxWyucynX5C/2UUcnxp3IEmh4hE2Vf1fbfb+ng08wzP11JQ5ngi/YlkUwUtEfgxgM6UYB4u21ySKH8ULfl9pnJGOWqu0DrXp2ZZvjmqI/323ZJP5uzKzstcWZQ1vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665974; c=relaxed/simple;
	bh=LQyDojBJtABxrrs2TYoK1lB+UDF6dVWDIeBTPm4uO50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPcF82729RnJHi6j6X/gPxX7/39h6cAUsOYC1itBDMAYg2zf+cN4v4WgVI3abv4XvwmG74m7LnE5mcccii3rkkMxq2Y591zQYSV8YQIgFrprm16X8zDzUZo/n/onGQtseJQ07JnNiqKURUlcOkd3662tF/fU6EU2eWY8XAne7QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vUSkdXF3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vUSkdXF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C325F1F000FF;
	Thu, 17 Sep 2026 17:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665973;
	bh=qFk/P2LYN5256+WOaSXKkKf91QlH6Gez6oTE6P8og7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vUSkdXF3o9gcrvAlKUBWnjp5AqcK72JeWVXILPSo8cFLY2rLiHM14mQF8xvcKY2zV
	 cx43zH+HDjYavnMdElEuULYQWjQurQXC6oXln7pUWn8ya5SeEcjAlhpDCCu1fhyLqh
	 h5g2fR4i0BGoS0YAPfsRjoAGbTL/31yOSYBLATaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Hu <ivan.hu@canonical.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0882/1250] Bluetooth: btmtk: Declare MT7920 (MT7961 1a) Bluetooth firmware
Date: Thu, 17 Sep 2026 16:11:17 +0100
Message-ID: <20260917151615.890290427@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Hu <ivan.hu@canonical.com>

[ Upstream commit 3d8a8e81ea8ad8813d4c82a12ba53ecb597b217d ]

btmtk_fw_get_filename() constructs the firmware name at runtime, so for
the MT7920 variant (dev_id 0x7961 with fw_flavor set) it requests
"mediatek/BT_RAM_CODE_MT7961_1a_2_hdr.bin" without ever declaring it via
MODULE_FIRMWARE(). Tools that select firmware from module metadata (e.g.
"modinfo -F firmware") therefore omit this blob, so request_firmware()
fails and Bluetooth does not initialise on MT7920, even though the file
is present in linux-firmware.

Declare it with MODULE_FIRMWARE(), as the mt76 driver already does for
the corresponding MT7920 wifi firmware.

Fixes: 1cb63d80fff6 ("Bluetooth: btusb: Add support Mediatek MT7920")
Signed-off-by: Ivan Hu <ivan.hu@canonical.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 1 +
 drivers/bluetooth/btmtk.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index b1059a86312a3..d1817dd6ab650 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -1564,5 +1564,6 @@ MODULE_FIRMWARE(FIRMWARE_MT7663);
 MODULE_FIRMWARE(FIRMWARE_MT7668);
 MODULE_FIRMWARE(FIRMWARE_MT7922);
 MODULE_FIRMWARE(FIRMWARE_MT7961);
+MODULE_FIRMWARE(FIRMWARE_MT7920);
 MODULE_FIRMWARE(FIRMWARE_MT7925);
 MODULE_FIRMWARE(FIRMWARE_MT7927);
diff --git a/drivers/bluetooth/btmtk.h b/drivers/bluetooth/btmtk.h
index 8f40180ca92e3..92e2deb29b586 100644
--- a/drivers/bluetooth/btmtk.h
+++ b/drivers/bluetooth/btmtk.h
@@ -7,6 +7,7 @@
 #define FIRMWARE_MT7922		"mediatek/BT_RAM_CODE_MT7922_1_1_hdr.bin"
 #define FIRMWARE_MT7902		"mediatek/BT_RAM_CODE_MT7902_1_1_hdr.bin"
 #define FIRMWARE_MT7961		"mediatek/BT_RAM_CODE_MT7961_1_2_hdr.bin"
+#define FIRMWARE_MT7920		"mediatek/BT_RAM_CODE_MT7961_1a_2_hdr.bin"
 #define FIRMWARE_MT7925		"mediatek/mt7925/BT_RAM_CODE_MT7925_1_1_hdr.bin"
 #define FIRMWARE_MT7927		"mediatek/mt7927/BT_RAM_CODE_MT6639_2_1_hdr.bin"
 
-- 
2.53.0



