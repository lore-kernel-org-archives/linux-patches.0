Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12FC1C07C2;
	Tue, 15 Oct 2024 12:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997002; cv=none; b=KjEyIpARNjLuJY9Kx/REXCVwKvRzqS11CJdaE3gJ4U2PrkbrXhWzNRwdkW+z91KbvbgLRvhqV9NY1vHlvxqgy4AgzhGr4nGEK9hSUTLkkSaAUZ//cp8jK1rGtkwVV2Kt2MxeqT+PutpifdwftXMl+0bxKv1+Ec7cKjXOs7ZnJZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997002; c=relaxed/simple;
	bh=CiUlOniYWyo4165gNUJ6kZvVERzy+J7tY7NvaVENtco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fiBQA92yjLCMM/CX5TY3foyOtXP0faLMIyZSDia9nHdXdpPI4dmuT8vdwagkqLsAC3ZeKRJCY/y7M+yCoQiavE2Qxz0QeamGLc2uGogiOqF37d4CvjIlD5prP5IzCW8vIEYNmdGfCETiM5Dl/q0ASwhiDBmjT9mGLfQRJGePhPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVKlZ1ug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVKlZ1ug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25066C4CEC6;
	Tue, 15 Oct 2024 12:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997002;
	bh=CiUlOniYWyo4165gNUJ6kZvVERzy+J7tY7NvaVENtco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZVKlZ1ugE8yMb0c7CPpCDbrawqzGzGBaC/rKka7lJSPT9/wN1o1NOYGgB8COB95/p
	 R9wDDJddqmUCQmUfYOUmDaNEEMwRoW8FTrNuwHnDk+ksJCxQ8b7pDWjUlIulZpXMq2
	 l+34My8uEEmVsp9JMMDpB2MCHdo2vkFYdDfVKmIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6c6c08700f9480c41fe3@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/518] wifi: rtw88: always wait for both firmware loading attempts
Date: Tue, 15 Oct 2024 14:39:23 +0200
Message-ID: <20241015123919.287597159@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2ef1416899f03..91eea38f62cd3 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1007,20 +1007,21 @@ static int rtw_wait_firmware_completion(struct rtw_dev *rtwdev)
 {
 	struct rtw_chip_info *chip = rtwdev->chip;
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
 
 static int rtw_power_on(struct rtw_dev *rtwdev)
-- 
2.43.0



