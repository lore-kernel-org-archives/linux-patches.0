Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928DB1D0DC3;
	Wed,  2 Oct 2024 14:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879162; cv=none; b=MIYfzULYOQPgSJCw/dtGS/q2lIF13WTbzCglVAoLpDSB9D6jUzDRdfdzVrXOpQVA/mANbapwjt7RLOg3y/I6DSqM734yfsEoAB2FzzqjysEHWDZbJ4fT/h+hRc3b4C2BafjSZAgbX+m2H42z9H+bRZNEvkuOfdfQ6SBn/vkJH04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879162; c=relaxed/simple;
	bh=mJyOtXFIb3kAarlhvJ7iBsNr5fGRIuOG7o0ls2lI9iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRckhKhYMT6yvgcqZ2gKfSu1NWjYp3afFDXidLrbdgqInByshpA0y3QnPSQa3QV2rGseW5F+sar1s9cWmJGWZZcQ2uWj054jt8yJq95Su6OhVE3E0JOGSHSdiIsa/YLxNbjWZSVIIrVyz9rAf107YrQqMmO3Z/MMeTfhoVV27aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HqL8Cun2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HqL8Cun2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D10C4CEC2;
	Wed,  2 Oct 2024 14:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879162;
	bh=mJyOtXFIb3kAarlhvJ7iBsNr5fGRIuOG7o0ls2lI9iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HqL8Cun28l3+kVnNDefZ1qY2AuJw5Y2ClHL79fdGwVsz5tvnn30vAxhTa649GxidN
	 99XQWGJ1w1DqrMbXkObEfKeK9rO8YbntvKZyM49MAyzzfHOWIfrtfm/kTp2oLjsRHg
	 IaS+j/92cN2kGeXAjxuMfKEiveDRSaPVMHuFSVd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6c6c08700f9480c41fe3@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/538] wifi: rtw88: always wait for both firmware loading attempts
Date: Wed,  2 Oct 2024 14:54:02 +0200
Message-ID: <20241002125752.111817701@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 63673005c2fb1..b90ea6c88b15d 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1314,20 +1314,21 @@ static int rtw_wait_firmware_completion(struct rtw_dev *rtwdev)
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



