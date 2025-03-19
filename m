Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A5F1CC89D;
	Wed, 19 Mar 2025 14:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394882; cv=none; b=fWBTAzOXX5THwy7fOtwuTV/usNAVh2CWyuB1eajgUbO4uDQz8S0zhnTPHq9z8RM70ZlsjE+GS7+XAsjE3UR938pdwyg7C0NwUraVF/8J6zJiiRDTr1tsdpVFqydXfbESUMKVKKowpMIFTpnCajArgAaOID8yam2MWcfVZu6/hNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394882; c=relaxed/simple;
	bh=Mt/AWzHcslEJ8RzA7oXimm6F9+DX81DjqEcMPnDbO0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHIGBNAMLClhvxtP3iZuznrCvInWk4GTn1flc4aBE613x4l44yeyvoCngC0aJHduU0C6BUF03qH2205l7RpB+2lmVJ6UxFpDPvsRUnA2a8rN3pytXWEfGAqdnqGPtRrM5GMSSD6lW0L0bQe1e57T/usa6uiN+rax0y0k72t9URw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=im2Lfm9K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="im2Lfm9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C593C4CEE8;
	Wed, 19 Mar 2025 14:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394882;
	bh=Mt/AWzHcslEJ8RzA7oXimm6F9+DX81DjqEcMPnDbO0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=im2Lfm9KXI5IiW3YhsBepyMEorfo5sp4YSrYOXWguQPlb7WauQR4r+ZucRkY6ZaQr
	 Su2/4rhF0s+jF9LIAQ4/9LCWNw5hB4ylp6hWSjL6bro+u7HxVKg6fSeDw5EUBl6Aml
	 PD9ULdCol0T0N+qQMb03jHG7wUWRVabVtVTF8W7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Brackenbury <daniel.brackenbury@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 083/241] HID: topre: Fix n-key rollover on Realforce R3S TKL boards
Date: Wed, 19 Mar 2025 07:29:13 -0700
Message-ID: <20250319143029.784765262@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 4d2a89d65b658..363c860835d35 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -1167,7 +1167,8 @@ config HID_TOPRE
 	tristate "Topre REALFORCE keyboards"
 	depends on HID
 	help
-	  Say Y for N-key rollover support on Topre REALFORCE R2 108/87 key keyboards.
+	  Say Y for N-key rollover support on Topre REALFORCE R2 108/87 key and
+          Topre REALFORCE R3S 87 key keyboards.
 
 config HID_THINGM
 	tristate "ThingM blink(1) USB RGB LED"
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 43a6f1d243a62..4df0bfc3c8413 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1300,6 +1300,7 @@
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



