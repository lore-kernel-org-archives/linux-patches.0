Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2F7193077;
	Tue, 27 May 2025 17:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367921; cv=none; b=Utcdy8BuAqGYMjHjg659CuVnGK5IGRjhgqlUuYEMZqMKoAVX7C/ej5wtsrdmjQbA5L4GMLkQtEn64Jdw7w5wlLfF/BaX2H/jOK6cC8cGOIrn3XStnz0Uu7Y3wqQ3t0RPuseimWZ916X/3UaCqM6FVBo07XHnwJZHDUWeMy4vGCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367921; c=relaxed/simple;
	bh=x4hWLmF6hkhAdteanyg8cygWaYA3yRm7+PCBcnbMKDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tN8Zr2iJ0es5I6fia0F/IfBippmgzbNPzsmxuHiToVA/Sw4uaYJZv9oGZiW8VVnxp4dURUI7LVDl3SGJA7S+S8vB1rP7dSyClGsjOpbUX1n44r6q/J4zTNtSGQX7BudBIgFc+E7IVPtBwWdo2E0X5kGzQHdBTG10NVq6MvEvrHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hikYOgcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hikYOgcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0C8C4CEE9;
	Tue, 27 May 2025 17:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367921;
	bh=x4hWLmF6hkhAdteanyg8cygWaYA3yRm7+PCBcnbMKDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hikYOgcVTIL0P2R06phS9t9SVbgztP+BW5V82/CF345tfpK9sbJGmbbCjiZwmW4zC
	 ykkeF7HsPGrdHfGshcm4bEEceC/Hh8yS/pRSiR/X/KyK2UCSRK+ycghS1/E4RYU8YR
	 cSY+9RV8lBCjIs4so/EJ/wWTzG9P5UWdbLwQcwqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 540/783] wifi: rtw88: Extend rtw_fw_send_ra_info() for RTL8814AU
Date: Tue, 27 May 2025 18:25:37 +0200
Message-ID: <20250527162535.151608558@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 8f0076726b66a70727a1bef5c087c60291e90ad8 ]

The existing code is suitable for chips with up to 2 spatial streams.
Inform the firmware about the rates it's allowed to use when
transmitting 3 spatial streams.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/08e2f328-1aab-4e50-93ac-c1e5dd9541ac@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/fw.c   | 15 +++++++++++++++
 drivers/net/wireless/realtek/rtw88/fw.h   |  1 +
 drivers/net/wireless/realtek/rtw88/main.h |  1 +
 3 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 02389b7c68768..6b563ac489a74 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -735,6 +735,7 @@ void rtw_fw_send_ra_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si,
 {
 	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
 	bool disable_pt = true;
+	u32 mask_hi;
 
 	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_RA_INFO);
 
@@ -755,6 +756,20 @@ void rtw_fw_send_ra_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si,
 	si->init_ra_lv = 0;
 
 	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
+
+	if (rtwdev->chip->id != RTW_CHIP_TYPE_8814A)
+		return;
+
+	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_RA_INFO_HI);
+
+	mask_hi = si->ra_mask >> 32;
+
+	SET_RA_INFO_RA_MASK0(h2c_pkt, (mask_hi & 0xff));
+	SET_RA_INFO_RA_MASK1(h2c_pkt, (mask_hi & 0xff00) >> 8);
+	SET_RA_INFO_RA_MASK2(h2c_pkt, (mask_hi & 0xff0000) >> 16);
+	SET_RA_INFO_RA_MASK3(h2c_pkt, (mask_hi & 0xff000000) >> 24);
+
+	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
 }
 
 void rtw_fw_media_status_report(struct rtw_dev *rtwdev, u8 mac_id, bool connect)
diff --git a/drivers/net/wireless/realtek/rtw88/fw.h b/drivers/net/wireless/realtek/rtw88/fw.h
index 404de1b0c407b..48ad9ceab6ea1 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.h
+++ b/drivers/net/wireless/realtek/rtw88/fw.h
@@ -557,6 +557,7 @@ static inline void rtw_h2c_pkt_set_header(u8 *h2c_pkt, u8 sub_id)
 #define H2C_CMD_DEFAULT_PORT		0x2c
 #define H2C_CMD_RA_INFO			0x40
 #define H2C_CMD_RSSI_MONITOR		0x42
+#define H2C_CMD_RA_INFO_HI		0x46
 #define H2C_CMD_BCN_FILTER_OFFLOAD_P0	0x56
 #define H2C_CMD_BCN_FILTER_OFFLOAD_P1	0x57
 #define H2C_CMD_WL_PHY_INFO		0x58
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index 62cd4c5263019..a61ea853f98d9 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -191,6 +191,7 @@ enum rtw_chip_type {
 	RTW_CHIP_TYPE_8703B,
 	RTW_CHIP_TYPE_8821A,
 	RTW_CHIP_TYPE_8812A,
+	RTW_CHIP_TYPE_8814A,
 };
 
 enum rtw_tx_queue_type {
-- 
2.39.5



