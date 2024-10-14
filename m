Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C229A26296;
	Mon, 14 Oct 2024 14:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917380; cv=none; b=SRhLe/vIrcEpGV0XYnOz4VE1M6QednVsR2zKLmKNAEXLq88ZchpPsG+GO/8f3AOUHlRXVHq6l11UIGJKWpZ1CVdfdbJLnXHaUE735e9PkyOkSLC/TYqAHcRzQBUTN+UIP0FypS6bIcNh5IMgm4W5VivrU/FwNNgFx07KbuojCxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917380; c=relaxed/simple;
	bh=mWyXPDBrkLuYjx3xlMZr4yiWxnTTkv/4g5VK9XTmJA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoT2bDXZypebKrp75Ph8xnj00rzIqT4DIV/Dhu45xebGxkWS1TQvTYyxUubN4Ru5eAIYaKc7EtmOeW1eSw569mSFjo9Bp8gluH+8TdsciDAzEZBsfF36N+dH0vxZM+cMf/s8bsUKcLAhXMwgDOweo9gp32xcOUGDRq+UJX4s4xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSPYtcyB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSPYtcyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DCEC4CEC3;
	Mon, 14 Oct 2024 14:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917380;
	bh=mWyXPDBrkLuYjx3xlMZr4yiWxnTTkv/4g5VK9XTmJA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSPYtcyB5ueJ/WFvUm08CkiEF3nUhivzXStO3+qUD4Hn6xAzbOcL1xVtD5WvjF2ax
	 WCRXPcbmQ40zJRopzSUQYe446WL5aiDU6FbNTS/45M1ccHukdyXpGhBQmUEl43ffdj
	 Nc0B/w4Psn+hU2u8vRkeTeSH9vajzKMwMeRZSEh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6c6c08700f9480c41fe3@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/798] wifi: rtw88: always wait for both firmware loading attempts
Date: Mon, 14 Oct 2024 16:09:17 +0200
Message-ID: <20241014141218.086052110@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 0e735a4c6137262bcefe45bb52fde7b1f5fc6c4d ]

In 'rtw_wait_firmware_completion()', always wait for both (regular and
wowlan) firmware loading attempts. Otherwise if 'rtw_usb_intf_init()'
has failed in 'rtw_usb_probe()', 'rtw_usb_disconnect()' may issue
'ieee80211_free_hw()' when one of 'rtw_load_firmware_cb()' (usually
the wowlan one) is still in progress, causing UAF detected by KASAN.

Fixes: c8e5695eae99 ("rtw88: load wowlan firmware if wowlan is supported")
Reported-by: syzbot+6c6c08700f9480c41fe3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6c6c08700f9480c41fe3
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240726114657.25396-1-dmantipov@yandex.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 81f3112923f1c..4620a0d5c77b2 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1286,20 +1286,21 @@ static int rtw_wait_firmware_completion(struct rtw_dev *rtwdev)
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
 	struct rtw_fw_state *fw;
+	int ret = 0;
 
 	fw = &rtwdev->fw;
 	wait_for_completion(&fw->completion);
 	if (!fw->firmware)
-		return -EINVAL;
+		ret = -EINVAL;
 
 	if (chip->wow_fw_name) {
 		fw = &rtwdev->wow_fw;
 		wait_for_completion(&fw->completion);
 		if (!fw->firmware)
-			return -EINVAL;
+			ret = -EINVAL;
 	}
 
-	return 0;
+	return ret;
 }
 
 static enum rtw_lps_deep_mode rtw_update_lps_deep_mode(struct rtw_dev *rtwdev,
-- 
2.43.0



