Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E311CAA0;
	Sat,  3 Feb 2024 04:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933519; cv=none; b=ZTlKBHkAa894pR/8+I/v3fO5Lh5tOS8hHM77DFXgsUiXQNUkoztpxrrARa1iuDrYpDj7j78hoQhSC2FAKg1jgdi/4jxY2VFw+sBxqOvgOs/W/jnK1mVvy1z6iRO3F+MkryfGWYh+NGWBsP3NfoxGAZkuVdXBFZRpDGyec5On8Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933519; c=relaxed/simple;
	bh=1csxAtKQdukahJ0ppD+cGCffeiv0aWD+JPnUFV0ewyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HI/Jfxj71EiB/Pg7LApFM/V11T8QzJ9z3bHxfiq7hOm4fH/TFBeaQe6GJ1DwXJ0cB8so59WHMinhMhtTd/arfxdPH7OPMWx85KshIWssHex6UWuwdYPPTqjhREBsFi0s8QRV9NkflOkisGmTQTkdnMGjRcCYvcnsBJ6cBnCr3pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOCgrXsg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOCgrXsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD6BC43390;
	Sat,  3 Feb 2024 04:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933519;
	bh=1csxAtKQdukahJ0ppD+cGCffeiv0aWD+JPnUFV0ewyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOCgrXsg5uZFUJw7ig+YTrENt61QzGCXwqfoBcPXRxZBvrO47KXqIXXsPkn/dEoQt
	 zV8CE2bDO3lX349inRVEoJcW0VTjacoZslomr4oiJVgIw2c1JpTAqy0JiC/OKzYaE5
	 4uV1mYdoVf1rWN2/5TzMGrd3TNAD3bnCPHfroRvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/322] wifi: rtw89: fix timeout calculation in rtw89_roc_end()
Date: Fri,  2 Feb 2024 20:02:35 -0800
Message-ID: <20240203035401.012665045@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

[ Upstream commit e416514e309f7e25e577fee45a65f246f67b2261 ]

Since 'rtw89_core_tx_kick_off_and_wait()' assumes timeout
(actually RTW89_ROC_TX_TIMEOUT) in milliseconds, I suppose
that RTW89_ROC_IDLE_TIMEOUT is in milliseconds as well. If
so, 'msecs_to_jiffies()' should be used in a call to
'ieee80211_queue_delayed_work()' from 'rtw89_roc_end()'.
Compile tested only.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20231024143137.30393-1-dmantipov@yandex.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 133bf289bacb..535393eca564 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -2548,7 +2548,7 @@ void rtw89_roc_end(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif)
 
 	if (hw->conf.flags & IEEE80211_CONF_IDLE)
 		ieee80211_queue_delayed_work(hw, &roc->roc_work,
-					     RTW89_ROC_IDLE_TIMEOUT);
+					     msecs_to_jiffies(RTW89_ROC_IDLE_TIMEOUT));
 }
 
 void rtw89_roc_work(struct work_struct *work)
-- 
2.43.0



