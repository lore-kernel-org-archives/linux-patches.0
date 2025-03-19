Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA64B1C6FEE;
	Wed, 19 Mar 2025 14:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395053; cv=none; b=fdmu4JEp9DtshKblmmfj8koohvU+rEZACR9gureEkKVPtt8goFeKBO+SJkNRWwbF9jd7xA20VgBjjmNhklrUlKUDSzato25nN4S7674w+3Q8/WkVVVjRy++kC/z3ci4Gaczj+8g6aDms0a4SVPyc7c145Yv2M1gzoeuhpkXdxAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395053; c=relaxed/simple;
	bh=YjV1vHZlVvSiZHVtAYEunYhkgPN97hTHwJ+O58CG08E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrhN60vgyn52ahkRx0Ovz211hDa8j65/YbTDaXrGwqWUvRSXxGWHyFFOxMKUrhJhTY+ysfhOefyUIHVmzJOkyuy76HsSwcXf+pHreteC2OZXaeD8pIXuNQdz60jDn4eJO/z1PbcNyE/2ZlTKKTFWVBPGyyRgqRGpZq2fBF2D1JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJAzpUZU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJAzpUZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68C1C4CEE4;
	Wed, 19 Mar 2025 14:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395053;
	bh=YjV1vHZlVvSiZHVtAYEunYhkgPN97hTHwJ+O58CG08E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJAzpUZUHQa2XnxHaMH8I2oI/F8GjdSaLnWwnXqi7WnTzP6OecBHyaJMV3zjNwf19
	 5BppY+7FZicr2S8xiUJhPYm9tPFug3C2H/K45dEB5B7irOAz7NWfiSjvGcRlo3vWVR
	 gMaRp9lfyKifIhyI7tqTWVsyxZ1jk9AMuXjP4m6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Brackenbury <daniel.brackenbury@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/231] HID: topre: Fix n-key rollover on Realforce R3S TKL boards
Date: Wed, 19 Mar 2025 07:29:34 -0700
Message-ID: <20250319143028.835925547@linuxfoundation.org>
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

From: Daniel Brackenbury <daniel.brackenbury@gmail.com>

[ Upstream commit 9271af9d846c7e49c8709b58d5853cb73c00b193 ]

Newer model R3* Topre Realforce keyboards share an issue with their older
R2 cousins where a report descriptor fixup is needed in order for n-key
rollover to work correctly, otherwise only 6-key rollover is available.
This patch adds some new hardware IDs for the R3S 87-key keyboard and
makes amendments to the existing hid-topre driver in order to change the
correct byte in the new model.

Signed-off-by: Daniel Brackenbury <daniel.brackenbury@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/Kconfig     | 3 ++-
 drivers/hid/hid-ids.h   | 1 +
 drivers/hid/hid-topre.c | 7 +++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index f8a56d6312425..4500d7653b05e 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -1154,7 +1154,8 @@ config HID_TOPRE
 	tristate "Topre REALFORCE keyboards"
 	depends on HID
 	help
-	  Say Y for N-key rollover support on Topre REALFORCE R2 108/87 key keyboards.
+	  Say Y for N-key rollover support on Topre REALFORCE R2 108/87 key and
+          Topre REALFORCE R3S 87 key keyboards.
 
 config HID_THINGM
 	tristate "ThingM blink(1) USB RGB LED"
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 6e8bcb1518bd7..a957ebcbc667a 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1296,6 +1296,7 @@
 #define USB_VENDOR_ID_TOPRE			0x0853
 #define USB_DEVICE_ID_TOPRE_REALFORCE_R2_108			0x0148
 #define USB_DEVICE_ID_TOPRE_REALFORCE_R2_87			0x0146
+#define USB_DEVICE_ID_TOPRE_REALFORCE_R3S_87			0x0313
 
 #define USB_VENDOR_ID_TOPSEED		0x0766
 #define USB_DEVICE_ID_TOPSEED_CYBERLINK	0x0204
diff --git a/drivers/hid/hid-topre.c b/drivers/hid/hid-topre.c
index 848361f6225df..ccedf8721722e 100644
--- a/drivers/hid/hid-topre.c
+++ b/drivers/hid/hid-topre.c
@@ -29,6 +29,11 @@ static const __u8 *topre_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		hid_info(hdev,
 			"fixing up Topre REALFORCE keyboard report descriptor\n");
 		rdesc[72] = 0x02;
+	} else if (*rsize >= 106 && rdesc[28] == 0x29 && rdesc[29] == 0xe7 &&
+				    rdesc[30] == 0x81 && rdesc[31] == 0x00) {
+		hid_info(hdev,
+			"fixing up Topre REALFORCE keyboard report descriptor\n");
+		rdesc[31] = 0x02;
 	}
 	return rdesc;
 }
@@ -38,6 +43,8 @@ static const struct hid_device_id topre_id_table[] = {
 			 USB_DEVICE_ID_TOPRE_REALFORCE_R2_108) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TOPRE,
 			 USB_DEVICE_ID_TOPRE_REALFORCE_R2_87) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_TOPRE,
+			 USB_DEVICE_ID_TOPRE_REALFORCE_R3S_87) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, topre_id_table);
-- 
2.39.5



