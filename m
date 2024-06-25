Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB398146A67;
	Tue, 25 Jun 2024 09:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309455; cv=none; b=UJ8Ut7NVO2DwDAXsmNyx33G3r0dGZNmSjjdPTKAwAlzKSl2w45BDLjzerQAKCYLqixj4eWX1mhErhdHR+S77j15heoska1duIGt+8iB8U7t2f/z/Q/i8LD0/egDEt/v66yLKEDVuRycD46MGaCKWgoGnMyM40Pg6obeaPXVgnNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309455; c=relaxed/simple;
	bh=9+Ypk/SAGb//tNWv1db0tHIrxC/JU/h2XC1BpIAqDGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iz/UUPZ6rmRes79QGKqVMeh4SnokmxfjIFMxz7ZPkLhG3JNShNSPBu0ZNYWS10ROfsY975sAdZt4uw7tc6pQR+ZyUQWlxJllVxut41K041i+am2ZBlxTBSrkBmuPMd8xl4BoCttToWomR5OWMI6uF75OnzSCEVWTKQK1ijQ9AhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sGd9E4Cj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sGd9E4Cj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6244CC32781;
	Tue, 25 Jun 2024 09:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309455;
	bh=9+Ypk/SAGb//tNWv1db0tHIrxC/JU/h2XC1BpIAqDGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sGd9E4CjC/IZiOXJjCK7z7f/NsiWSrG0NAwvTsIJHfv4tV2KX1DA/Qii5RejxL7z6
	 HW4iFinUyJz982zTJjS7dpwD62TrXLu5vkVlHGsgNY41wRnQ91zadbsFfpzL+JUmAy
	 TbmlCElgtBEI/NKM1h1Fh0eIImALIMXD3Qw+m0d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/131] HID: asus: fix more n-key report descriptors if n-key quirked
Date: Tue, 25 Jun 2024 11:32:56 +0200
Message-ID: <20240625085526.752517954@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit 59d2f5b7392e988a391e6924e177c1a68d50223d ]

Adjusts the report descriptor for N-Key devices to
make the output count 0x01 which completely avoids
the need for a block of filtering.

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 49 ++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 220d6b2af4d3f..70f3495a22fc5 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -334,36 +334,20 @@ static int asus_raw_event(struct hid_device *hdev,
 	if (drvdata->quirks & QUIRK_MEDION_E1239T)
 		return asus_e1239t_event(drvdata, data, size);
 
-	if (drvdata->quirks & QUIRK_USE_KBD_BACKLIGHT) {
+	/*
+	 * Skip these report ID, the device emits a continuous stream associated
+	 * with the AURA mode it is in which looks like an 'echo'.
+	 */
+	if (report->id == FEATURE_KBD_LED_REPORT_ID1 || report->id == FEATURE_KBD_LED_REPORT_ID2)
+		return -1;
+	if (drvdata->quirks & QUIRK_ROG_NKEY_KEYBOARD) {
 		/*
-		 * Skip these report ID, the device emits a continuous stream associated
-		 * with the AURA mode it is in which looks like an 'echo'.
+		 * G713 and G733 send these codes on some keypresses, depending on
+		 * the key pressed it can trigger a shutdown event if not caught.
 		*/
-		if (report->id == FEATURE_KBD_LED_REPORT_ID1 ||
-				report->id == FEATURE_KBD_LED_REPORT_ID2) {
+		if (data[0] == 0x02 && data[1] == 0x30) {
 			return -1;
-		/* Additional report filtering */
-		} else if (report->id == FEATURE_KBD_REPORT_ID) {
-			/*
-			 * G14 and G15 send these codes on some keypresses with no
-			 * discernable reason for doing so. We'll filter them out to avoid
-			 * unmapped warning messages later.
-			*/
-			if (data[1] == 0xea || data[1] == 0xec || data[1] == 0x02 ||
-					data[1] == 0x8a || data[1] == 0x9e) {
-				return -1;
-			}
 		}
-		if (drvdata->quirks & QUIRK_ROG_NKEY_KEYBOARD) {
-			/*
-			 * G713 and G733 send these codes on some keypresses, depending on
-			 * the key pressed it can trigger a shutdown event if not caught.
-			*/
-			if(data[0] == 0x02 && data[1] == 0x30) {
-				return -1;
-			}
-		}
-
 	}
 
 	if (drvdata->quirks & QUIRK_ROG_CLAYMORE_II_KEYBOARD) {
@@ -1262,6 +1246,19 @@ static __u8 *asus_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		rdesc[205] = 0x01;
 	}
 
+	/* match many more n-key devices */
+	if (drvdata->quirks & QUIRK_ROG_NKEY_KEYBOARD) {
+		for (int i = 0; i < *rsize + 1; i++) {
+			/* offset to the count from 0x5a report part always 14 */
+			if (rdesc[i] == 0x85 && rdesc[i + 1] == 0x5a &&
+			    rdesc[i + 14] == 0x95 && rdesc[i + 15] == 0x05) {
+				hid_info(hdev, "Fixing up Asus N-Key report descriptor\n");
+				rdesc[i + 15] = 0x01;
+				break;
+			}
+		}
+	}
+
 	return rdesc;
 }
 
-- 
2.43.0



