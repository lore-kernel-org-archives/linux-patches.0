Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29897220686;
	Mon, 23 Jun 2025 21:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715920; cv=none; b=YovkIV2n+vf76xOwHr02uwZRY5Y7aTGPw3rUZvEyfrMn1u+TbhFWQHzFCaUGVSR6TgJIrHKUBnZXvgqdFpF5K2yfgkVTrociTTp3vigGZeZsHRqk6rceHf+uRsg8fJ4owr9G8TjjkElKXpIPa3BlHPQ0e3ZE1nJqONvAXllDMpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715920; c=relaxed/simple;
	bh=OZjRjBDvH5XRxa2QOtf+dxkTpbGBLSZz8KCMO78Gzgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPQpZLvz1dE0LvvZEWP54fLTcRdigvi7NZuB5jhVEsdA4smW69p4vfYyCG7IIw5l6Mr2hRV/3o6DImoyrchA5TkKCbb741pW4cRjtaen2XJBH8Dq1p83SX0IURrEYME1UtqY7KzDyTJ09lwWbI3H+wCXBqU0i8IofgMd4u2QAFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5JQVEjf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5JQVEjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CDBC4CEED;
	Mon, 23 Jun 2025 21:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715919;
	bh=OZjRjBDvH5XRxa2QOtf+dxkTpbGBLSZz8KCMO78Gzgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b5JQVEjf/YYHfEo2TTIXcEKFSmOQ0lAjoPHkHB+H5pgk9r30skGNcq5v+ekVg46HG
	 kI6OyVGUlMMGv+HkY45LpsxWJNwgtgy0+tU/O1lmuRqTn8M64gpV4zs1Tfxn11FhA7
	 hKB94aIei+FyIQZ+8iCpr2OuZ8f50f8tSOxhb5Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dian-Syuan Yang <dian_syuan0116@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 216/414] wifi: rtw89: leave idle mode when setting WEP encryption for AP mode
Date: Mon, 23 Jun 2025 15:05:53 +0200
Message-ID: <20250623130647.415260776@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Dian-Syuan Yang <dian_syuan0116@realtek.com>

[ Upstream commit d105652b33245162867ac769bea336976e67efb8 ]

Due to mac80211 triggering the hardware to enter idle mode, it fails
to install WEP key causing connected station can't ping successfully.
Currently, it forces the hardware to leave idle mode before driver
adding WEP keys.

Signed-off-by: Dian-Syuan Yang <dian_syuan0116@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250507031203.8256-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/cam.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/cam.c b/drivers/net/wireless/realtek/rtw89/cam.c
index 8d140b94cb440..0c8ea5e629e6a 100644
--- a/drivers/net/wireless/realtek/rtw89/cam.c
+++ b/drivers/net/wireless/realtek/rtw89/cam.c
@@ -6,6 +6,7 @@
 #include "debug.h"
 #include "fw.h"
 #include "mac.h"
+#include "ps.h"
 
 static struct sk_buff *
 rtw89_cam_get_sec_key_cmd(struct rtw89_dev *rtwdev,
@@ -447,9 +448,11 @@ int rtw89_cam_sec_key_add(struct rtw89_dev *rtwdev,
 
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
+		rtw89_leave_ips_by_hwflags(rtwdev);
 		hw_key_type = RTW89_SEC_KEY_TYPE_WEP40;
 		break;
 	case WLAN_CIPHER_SUITE_WEP104:
+		rtw89_leave_ips_by_hwflags(rtwdev);
 		hw_key_type = RTW89_SEC_KEY_TYPE_WEP104;
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
-- 
2.39.5



