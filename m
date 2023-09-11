Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60EF11705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00861C433C7;
	Mon, 11 Sep 2023 14:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442957;
	bh=nm4dhQoStW7eQQHxV/8hJACbQU/Vn6lc8V72hmIFVIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JmNRePNLEfyXe9VctDT4zHiRPyuT4XOUOh+KskUIem1mrVaCZAPAMFYrHG0L/Qyvt
	 R8ALeHO6JQAuAQorTw5i25NxhEejVINcDEs7XOMefneCXmS4mhzeuoi0KASMMTRj0O
	 6kS7wRgTBH+//EpGbGPV/sXuSFWLglnX5Z2m5pd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 180/737] wifi: rtw89: Fix loading of compressed firmware
Date: Mon, 11 Sep 2023 15:40:39 +0200
Message-ID: <20230911134655.584582847@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

[ Upstream commit 942999c48cb382feb53c6da7679a994c97963836 ]

When using compressed firmware, the early firmware load feature will fail.
In most cases, the only downside is that if a device has more than one
firmware version available, only the last one listed will be loaded.
In at least two cases, there is no firmware loaded, and the device fails
initialization. See https://github.com/lwfinger/rtw89/issues/259 and
https://bugzilla.opensuse.org/show_bug.cgi?id=1212808 for examples of
the failure.

When firmware_class.dyndbg=+p" added to the kernel boot parameters, the
following is found:

finger@localhost:~/rtw89>sudo dmesg -t | grep rtw89
firmware_class: __allocate_fw_priv: fw-rtw89/rtw8852b_fw-1.bin fw_priv=00000000638862fb
rtw89_8852be 0000:02:00.0: loading /lib/firmware/updates/5.14.21-150500.53-default/rtw89/rtw8852b_fw-1.bin failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/updates/rtw89/rtw8852b_fw-1.bin failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/5.14.21-150500.53-default/rtw89/rtw8852b_fw-1.bin failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/rtw89/rtw8852b_fw-1.bin failed for no such file or directory.
rtw89_8852be 0000:02:00.0: Direct firmware load for rtw89/rtw8852b_fw-1.bin failed with error -2
firmware_class: __free_fw_priv: fw-rtw89/rtw8852b_fw-1.bin fw_priv=00000000638862fb data=00000000307c30c7 size=0
firmware_class: __allocate_fw_priv: fw-rtw89/rtw8852b_fw.bin fw_priv=00000000638862fb
rtw89_8852be 0000:02:00.0: loading /lib/firmware/updates/5.14.21-150500.53-default/rtw89/rtw8852b_fw.bin failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/updates/rtw89/rtw8852b_fw.bin failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/5.14.21-150500.53-default/rtw89/rtw8852b_fw.bin failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/rtw89/rtw8852b_fw.bin failed for no such file or directory.
rtw89_8852be 0000:02:00.0: Direct firmware load for rtw89/rtw8852b_fw.bin failed with error -2
firmware_class: __free_fw_priv: fw-rtw89/rtw8852b_fw.bin fw_priv=00000000638862fb data=00000000307c30c7 size=0
rtw89_8852be 0000:02:00.0: failed to early request firmware: -2
firmware_class: __allocate_fw_priv: fw-rtw89/rtw8852b_fw.bin fw_priv=00000000638862fb
rtw89_8852be 0000:02:00.0: loading /lib/firmware/updates/5.14.21-150500.53-default/rtw89/rtw8852b_fw.bin failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/updates/rtw89/rtw8852b_fw.bin failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/5.14.21-150500.53-default/rtw89/rtw8852b_fw.bin failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/rtw89/rtw8852b_fw.bin failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/updates/5.14.21-150500.53-default/rtw89/rtw8852b_fw.bin.xz failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/updates/rtw89/rtw8852b_fw.bin.xz failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/5.14.21-150500.53-default/rtw89/rtw8852b_fw.bin.xz failed for no such file or directory.
rtw89_8852be 0000:02:00.0: Loading firmware from /lib/firmware/rtw89/rtw8852b_fw.bin.xz
rtw89_8852be 0000:02:00.0: f/w decompressing rtw89/rtw8852b_fw.bin
firmware_class: fw_set_page_data: fw-rtw89/rtw8852b_fw.bin fw_priv=00000000638862fb data=000000004ed6c2f7 size=1035232
rtw89_8852be 0000:02:00.0: Firmware version 0.27.32.1, cmd version 0, type 1
rtw89_8852be 0000:02:00.0: Firmware version 0.27.32.1, cmd version 0, type 3

The key is that firmware version 0.27.32.1 is loaded.

With this patch, the following is obtained:

firmware_class: __free_fw_priv: fw-rtw89/rtw8852b_fw.bin fw_priv=000000000849addc data=00000000fd3cabe2 size=1035232
firmware_class: fw_name_devm_release: fw_name-rtw89/rtw8852b_fw.bin devm-000000002d8c3343 released
firmware_class: __allocate_fw_priv: fw-rtw89/rtw8852b_fw-1.bin fw_priv=000000009e1a6364
rtw89_8852be 0000:02:00.0: loading /lib/firmware/updates/6.4.3-1-default/rtw89/rtw8852b_fw-1.bin failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/updates/rtw89/rtw8852b_fw-1.bin failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/6.4.3-1-default/rtw89/rtw8852b_fw-1.bin failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/rtw89/rtw8852b_fw-1.bin failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/updates/6.4.3-1-default/rtw89/rtw8852b_fw-1.bin.zst failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/updates/rtw89/rtw8852b_fw-1.bin.zst failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/6.4.3-1-default/rtw89/rtw8852b_fw-1.bin.zst failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/rtw89/rtw8852b_fw-1.bin.zst failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/updates/6.4.3-1-default/rtw89/rtw8852b_fw-1.bin.xz failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/updates/rtw89/rtw8852b_fw-1.bin.xz failed for no such file or directory.
rtw89_8852be 0000:02:00.0: loading /lib/firmware/6.4.3-1-default/rtw89/rtw8852b_fw-1.bin.xz failed for no such file or directory.
rtw89_8852be 0000:02:00.0: Loading firmware from /lib/firmware/rtw89/rtw8852b_fw-1.bin.xz
rtw89_8852be 0000:02:00.0: f/w decompressing rtw89/rtw8852b_fw-1.bin
firmware_class: fw_set_page_data: fw-rtw89/rtw8852b_fw-1.bin fw_priv=000000009e1a6364 data=00000000fd3cabe2 size=1184992
rtw89_8852be 0000:02:00.0: Loaded FW: rtw89/rtw8852b_fw-1.bin, sha256: 8539efc75f513f4585cf0cd6e79e6507da47fce87225f2d0de391a03aefe9ac8
rtw89_8852be 0000:02:00.0: loaded firmware rtw89/rtw8852b_fw-1.bin
rtw89_8852be 0000:02:00.0: Firmware version 0.29.29.1, cmd version 0, type 5
rtw89_8852be 0000:02:00.0: Firmware version 0.29.29.1, cmd version 0, type 3

Now, version 0.29.29.1 is loaded.

Fixes: ffde7f3476a6 ("wifi: rtw89: add firmware format version to backward compatible with older drivers")
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230724183927.28553-1-Larry.Finger@lwfinger.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 27 +++----------------------
 1 file changed, 3 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index b9b675bf9d050..60b201b24332f 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -305,31 +305,17 @@ rtw89_early_fw_feature_recognize(struct device *device,
 				 struct rtw89_fw_info *early_fw,
 				 int *used_fw_format)
 {
-	union rtw89_compat_fw_hdr buf = {};
 	const struct firmware *firmware;
-	bool full_req = false;
 	char fw_name[64];
 	int fw_format;
 	u32 ver_code;
 	int ret;
 
-	/* If SECURITY_LOADPIN_ENFORCE is enabled, reading partial files will
-	 * be denied (-EPERM). Then, we don't get right firmware things as
-	 * expected. So, in this case, we have to request full firmware here.
-	 */
-	if (IS_ENABLED(CONFIG_SECURITY_LOADPIN_ENFORCE))
-		full_req = true;
-
 	for (fw_format = chip->fw_format_max; fw_format >= 0; fw_format--) {
 		rtw89_fw_get_filename(fw_name, sizeof(fw_name),
 				      chip->fw_basename, fw_format);
 
-		if (full_req)
-			ret = request_firmware(&firmware, fw_name, device);
-		else
-			ret = request_partial_firmware_into_buf(&firmware, fw_name,
-								device, &buf, sizeof(buf),
-								0);
+		ret = request_firmware(&firmware, fw_name, device);
 		if (!ret) {
 			dev_info(device, "loaded firmware %s\n", fw_name);
 			*used_fw_format = fw_format;
@@ -342,10 +328,7 @@ rtw89_early_fw_feature_recognize(struct device *device,
 		return NULL;
 	}
 
-	if (full_req)
-		ver_code = rtw89_compat_fw_hdr_ver_code(firmware->data);
-	else
-		ver_code = rtw89_compat_fw_hdr_ver_code(&buf);
+	ver_code = rtw89_compat_fw_hdr_ver_code(firmware->data);
 
 	if (!ver_code)
 		goto out;
@@ -353,11 +336,7 @@ rtw89_early_fw_feature_recognize(struct device *device,
 	rtw89_fw_iterate_feature_cfg(early_fw, chip, ver_code);
 
 out:
-	if (full_req)
-		return firmware;
-
-	release_firmware(firmware);
-	return NULL;
+	return firmware;
 }
 
 int rtw89_fw_recognize(struct rtw89_dev *rtwdev)
-- 
2.40.1



