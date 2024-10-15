Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3281E1EBA11;
	Tue, 15 Oct 2024 11:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992365; cv=none; b=Q6+j8d6z1Mylm6ZDIILcn66PHKptxrR57udHGCa0TwYo+kKUvhlqZskglq6JMFV8+VGLErcvjZbEQEFfTo5ks3CADaQT/mqqsdAabaBOWJMpHKDPyFoaxhXaKaNRr7uh8Wc6ucXEi5jsVtG88W34HcUmOT3gsVgJVIIMDxjnKss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992365; c=relaxed/simple;
	bh=An1uQUEj54wweAIdRAPg7HzSIFyMEWqUzgxQrIqoIMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVuWrD11Gtj5GGaiOwSufPhyjCbF1P3kl0yY4IIjrU3y25TNECp4lcJOdmEaUNaosKsKMs/hJfLiMzgPhXPrT8sAC0mQNCYPE5p3eIK/z8PCWkLW714SYSA+RAvqkwQBpK51pjFIpCliSqnNJ1eQxKgV1ardlFaBpRi1Ai9CS8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NlVvP3L9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NlVvP3L9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92744C4CED4;
	Tue, 15 Oct 2024 11:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992365;
	bh=An1uQUEj54wweAIdRAPg7HzSIFyMEWqUzgxQrIqoIMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NlVvP3L9jq8A+6EC6ydUu0Qpl+mNgFo3v0u/j0roXA4Qx6h1/ucvOIrSoPORgDnmU
	 NNx8kZgA3zgOFdduRx+SWcYtQ2hMWzlGcrV9I/MoIAxSSPRuVJcI6g2OUuIs8zUBa9
	 bjS/W7ES25neJdxhUuASUy93U+MPwBhQs3T2M7vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6c6c08700f9480c41fe3@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/691] wifi: rtw88: always wait for both firmware loading attempts
Date: Tue, 15 Oct 2024 13:20:43 +0200
Message-ID: <20241015112444.133429259@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d7b7b2cce9746..23971a5737cf5 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1153,20 +1153,21 @@ static int rtw_wait_firmware_completion(struct rtw_dev *rtwdev)
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
 
 static enum rtw_lps_deep_mode rtw_update_lps_deep_mode(struct rtw_dev *rtwdev,
-- 
2.43.0



