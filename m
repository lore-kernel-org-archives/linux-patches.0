Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04516BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0CFC4339B;
	Tue,  7 Mar 2023 17:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209392;
	bh=fUUY0unCF5oY542uBwo1tkWlQ0VzFf7VXy8HLmQ6c2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/wpmo1TwIOETS7lqSOdZuOnDQxzEc8c0ZpaAv1aOELYKSn76UJBeenQkjMY4+YL7
	 6/9PXzuX5n5Wv3uOafgIbEGkqz6hT/Yic+NL6tZmU23ORcvK1MroN1GXBBYV7AZys2
	 HD0f65mBev2UtMxr0iAKF+sVLo/lnFQOHyt9DYd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0205/1001] wifi: rtw88: Use non-atomic sta iterator in rtw_ra_mask_info_update()
Date: Tue,  7 Mar 2023 17:49:37 +0100
Message-Id: <20230307170030.796916057@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 2931978cd74f4a643deeea5b211523001d95aa44 ]

USB and (upcoming) SDIO support may sleep in the read/write handlers.
Use non-atomic rtw_iterate_stas() in rtw_ra_mask_info_update() because
the iterator function rtw_ra_mask_info_update_iter() needs to read and
write registers from within rtw_update_sta_info(). Using the non-atomic
iterator ensures that we can sleep during USB and SDIO register reads
and writes. This fixes "scheduling while atomic" or "Voluntary context
switch within RCU read-side critical section!" warnings as seen by SDIO
card users (but it also affects USB cards).

Fixes: 78d5bf925f30 ("wifi: rtw88: iterate over vif/sta list non-atomically")
Suggested-by: Ping-Ke Shih <pkshih@realtek.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230108211324.442823-4-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/mac80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index 776a9a9884b5d..3b92ac611d3fd 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -737,7 +737,7 @@ static void rtw_ra_mask_info_update(struct rtw_dev *rtwdev,
 	br_data.rtwdev = rtwdev;
 	br_data.vif = vif;
 	br_data.mask = mask;
-	rtw_iterate_stas_atomic(rtwdev, rtw_ra_mask_info_update_iter, &br_data);
+	rtw_iterate_stas(rtwdev, rtw_ra_mask_info_update_iter, &br_data);
 }
 
 static int rtw_ops_set_bitrate_mask(struct ieee80211_hw *hw,
@@ -746,7 +746,9 @@ static int rtw_ops_set_bitrate_mask(struct ieee80211_hw *hw,
 {
 	struct rtw_dev *rtwdev = hw->priv;
 
+	mutex_lock(&rtwdev->mutex);
 	rtw_ra_mask_info_update(rtwdev, vif, mask);
+	mutex_unlock(&rtwdev->mutex);
 
 	return 0;
 }
-- 
2.39.2



