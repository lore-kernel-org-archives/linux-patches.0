Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867E915218A;
	Tue,  2 Jul 2024 17:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940304; cv=none; b=bOrXp6rx9azMIhiQg6a94c25forrYwkyDdWMcCtikrqe6fe94dd0fVTSoSm3raZZT8uoUZ+5xtfLHzzlsh8yMQO8+YZoJObm/7NoGMIKBcxRBEmMysICSCEIhGYeHC0eDRL02pwSCXA1f5kCKOJyLwJ+fC4i22atND0wG4v1vE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940304; c=relaxed/simple;
	bh=9jNi7HsIjNibthAe7YPe9qvt2+66VV1DHuJEqPO3lSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gafbOys7pJ27r8znRriSHK42qilzKHlfdNCra3pKzRpErUlZHfjph0W1+My1d1+RgY6WoA1Kb/l/JYVymqjtRQDzIG0JQThS5P0zjWW1BnY/ybpPMQ4UfsB8nP/0DJhwxZn1+H1XNleb7LKxu21wUpbWrn1/o+JsxU8Aoyc6tVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbWhcbv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbWhcbv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3DBC116B1;
	Tue,  2 Jul 2024 17:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940304;
	bh=9jNi7HsIjNibthAe7YPe9qvt2+66VV1DHuJEqPO3lSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbWhcbv+hUK2HYBGxLbt5Zg3K2mNXGkzRJRgp1QFS8lGhh3QIqKO6SLKWjPhngOkg
	 +ZWkc7mveaF5KrU///oFNf3aWKeqBCLg9yWqTCrSZKG+YetN+R5IK7FF1u3YU9x4nY
	 lgcnqDNO3kcZOyGQIYTT6qu+is2DazKhLb44FXpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chia-Yuan Li <leo.li@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 083/222] wifi: rtw89: download firmware with five times retry
Date: Tue,  2 Jul 2024 19:02:01 +0200
Message-ID: <20240702170247.150572969@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chia-Yuan Li <leo.li@realtek.com>

[ Upstream commit a9e1b0ec5bdeedcf062416af4081aa005f8bf1e7 ]

After firmware boots, it reads keys info from efuse and checks secure
checksum, but suddenly failed to access efuse resulting in probe failure,
and driver throws messages:

  rtw89_8852be 0000:03:00.0: fw security fail
  rtw89_8852be 0000:03:00.0: download firmware fail
  rtw89_8852be 0000:03:00.0: [ERR]fwdl 0x1E0 = 0xe2
  rtw89_8852be 0000:03:00.0: [ERR]fwdl 0x83F0 = 0x210090

Retry five times to resolve rare abnormal hardware state.

Signed-off-by: Chia-Yuan Li <leo.li@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://msgid.link/20240329015251.22762-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 27 +++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 185cd339c0855..6c75ebbb21caa 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -1349,13 +1349,12 @@ static void rtw89_fw_prog_cnt_dump(struct rtw89_dev *rtwdev)
 static void rtw89_fw_dl_fail_dump(struct rtw89_dev *rtwdev)
 {
 	u32 val32;
-	u16 val16;
 
 	val32 = rtw89_read32(rtwdev, R_AX_WCPU_FW_CTRL);
 	rtw89_err(rtwdev, "[ERR]fwdl 0x1E0 = 0x%x\n", val32);
 
-	val16 = rtw89_read16(rtwdev, R_AX_BOOT_DBG + 2);
-	rtw89_err(rtwdev, "[ERR]fwdl 0x83F2 = 0x%x\n", val16);
+	val32 = rtw89_read32(rtwdev, R_AX_BOOT_DBG);
+	rtw89_err(rtwdev, "[ERR]fwdl 0x83F0 = 0x%x\n", val32);
 
 	rtw89_fw_prog_cnt_dump(rtwdev);
 }
@@ -1394,8 +1393,9 @@ static int rtw89_fw_download_suit(struct rtw89_dev *rtwdev,
 	return 0;
 }
 
-int rtw89_fw_download(struct rtw89_dev *rtwdev, enum rtw89_fw_type type,
-		      bool include_bb)
+static
+int __rtw89_fw_download(struct rtw89_dev *rtwdev, enum rtw89_fw_type type,
+			bool include_bb)
 {
 	const struct rtw89_mac_gen_def *mac = rtwdev->chip->mac_def;
 	struct rtw89_fw_info *fw_info = &rtwdev->fw;
@@ -1433,7 +1433,7 @@ int rtw89_fw_download(struct rtw89_dev *rtwdev, enum rtw89_fw_type type,
 	ret = rtw89_fw_check_rdy(rtwdev, RTW89_FWDL_CHECK_FREERTOS_DONE);
 	if (ret) {
 		rtw89_warn(rtwdev, "download firmware fail\n");
-		return ret;
+		goto fwdl_err;
 	}
 
 	return ret;
@@ -1443,6 +1443,21 @@ int rtw89_fw_download(struct rtw89_dev *rtwdev, enum rtw89_fw_type type,
 	return ret;
 }
 
+int rtw89_fw_download(struct rtw89_dev *rtwdev, enum rtw89_fw_type type,
+		      bool include_bb)
+{
+	int retry;
+	int ret;
+
+	for (retry = 0; retry < 5; retry++) {
+		ret = __rtw89_fw_download(rtwdev, type, include_bb);
+		if (!ret)
+			return 0;
+	}
+
+	return ret;
+}
+
 int rtw89_wait_firmware_completion(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_fw_info *fw = &rtwdev->fw;
-- 
2.43.0



