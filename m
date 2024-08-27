Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3452B1C57A6;
	Tue, 27 Aug 2024 14:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769743; cv=none; b=SsFePGznbdwxxJMl+Ez7b/dXarh8v9SbN0x1Uh+lj9gzDMuNB8/8aW2s2XmQxKCOnbSJCuSLHIoLNqJpDjtaTYKDLa1xFOudl275wGp7ZdsiUfAYC8BNdV4ubzwIQh0Udh2Dj4J0P5zlar5+918mIEh9O0QIverNDRzqXmrRjNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769743; c=relaxed/simple;
	bh=QnwtOiheCebMJ5zwxqu+35mZ4YI1oe97ir6dVzGUwAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=II26tQlT6AIDJs9UDSFUc+4kUSuSFxuYucdtARQ+6fVcyow/HSxQg3jmY3L88vzh+EOoROn+MBXO5xN/Ab8CPzAhWNpqF5S7fifIJl2Apl0Rkz9Ec+HUtHcFvGHkOTvmdHSpoghSkNlFiQIaCAye8P9IvT2voIBG3xqD1uwEq1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2J1WKFPp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2J1WKFPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E503C61067;
	Tue, 27 Aug 2024 14:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769743;
	bh=QnwtOiheCebMJ5zwxqu+35mZ4YI1oe97ir6dVzGUwAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2J1WKFPpyJgXkERFuIUh9PuTfXpXbpBOyl93Tkcj0J3z/I4JzvgB1GMR59zVxj5qN
	 u/sLpTDCb6mUyXOPhcc2qLd6WBO4VFV6PpctyzAVBQ0c5XWHZidfOvgriUQQxk2irj
	 n7UlKfyqHjFIgHKtpXeGiZKxxVJfuWfFeFllchb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baojun Xu <baojun.xu@ti.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 015/341] ALSA: hda/tas2781: fix wrong calibrated data order
Date: Tue, 27 Aug 2024 16:34:06 +0200
Message-ID: <20240827143843.985485665@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Baojun Xu <baojun.xu@ti.com>

commit 3beddef84d90590270465a907de1cfe2539ac70d upstream.

Wrong calibration data order cause sound too low in some device.
Fix wrong calibrated data order, add calibration data converssion
by get_unaligned_be32() after reading from UEFI.

Fixes: 5be27f1e3ec9 ("ALSA: hda/tas2781: Add tas2781 HDA driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Baojun Xu <baojun.xu@ti.com>
Link: https://patch.msgid.link/20240813043749.108-1-shenghao-ding@ti.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/tas2781_hda_i2c.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/sound/pci/hda/tas2781_hda_i2c.c
+++ b/sound/pci/hda/tas2781_hda_i2c.c
@@ -2,10 +2,12 @@
 //
 // TAS2781 HDA I2C driver
 //
-// Copyright 2023 Texas Instruments, Inc.
+// Copyright 2023 - 2024 Texas Instruments, Inc.
 //
 // Author: Shenghao Ding <shenghao-ding@ti.com>
+// Current maintainer: Baojun Xu <baojun.xu@ti.com>
 
+#include <asm/unaligned.h>
 #include <linux/acpi.h>
 #include <linux/crc8.h>
 #include <linux/crc32.h>
@@ -425,20 +427,22 @@ static void tas2781_apply_calib(struct t
 	static const unsigned char rgno_array[CALIB_MAX] = {
 		0x74, 0x0c, 0x14, 0x70, 0x7c,
 	};
-	unsigned char *data;
+	int offset = 0;
 	int i, j, rc;
+	__be32 data;
 
 	for (i = 0; i < tas_priv->ndev; i++) {
-		data = tas_priv->cali_data.data +
-			i * TASDEVICE_SPEAKER_CALIBRATION_SIZE;
 		for (j = 0; j < CALIB_MAX; j++) {
+			data = get_unaligned_be32(
+				&tas_priv->cali_data.data[offset]);
 			rc = tasdevice_dev_bulk_write(tas_priv, i,
 				TASDEVICE_REG(0, page_array[j], rgno_array[j]),
-				&(data[4 * j]), 4);
+				(unsigned char *)&data, 4);
 			if (rc < 0)
 				dev_err(tas_priv->dev,
 					"chn %d calib %d bulk_wr err = %d\n",
 					i, j, rc);
+			offset += 4;
 		}
 	}
 }


