Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8AC1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9811DC433D2;
	Wed, 28 Dec 2022 15:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242483;
	bh=gsWReIOGe45tATKyEE5K46shtw4sISddqYCRBYxUrLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7s1ube6ucXre1wT6IFGyfc5pzNmhFnKss6aYTrEb7T9ffuXD5QZPG4NpXkY0MEeO
	 2cP1jXyM3E7gTeW+QFdFFJ7OLRBbMVgCqvU6O/DfLhn6J8PC3hZpa+3wiVpljlc8H/
	 /59ILLNB8FjKWwQmip2Or5c8F7xxHMkTg/eOa7mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0415/1073] wifi: rtl8xxxu: Fix use after rcu_read_unlock in rtl8xxxu_bss_info_changed
Date: Wed, 28 Dec 2022 15:33:23 +0100
Message-Id: <20221228144339.294712368@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 7927afb5e27baac694f585b59c436ba323528dc2 ]

Commit a8b5aef2cca1 ("wifi: rtl8xxxu: gen2: Enable 40 MHz channel width")
introduced a line where the pointer returned by ieee80211_find_sta() is
used after rcu_read_unlock().

Move rcu_read_unlock() a bit lower to fix this.

Fixes: a8b5aef2cca1 ("wifi: rtl8xxxu: gen2: Enable 40 MHz channel width")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/3c82ad09-7593-3be1-1d2c-e58505fb43cb@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 2286119ba3d5..e85c6325199b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4654,7 +4654,6 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			if (sta->deflink.ht_cap.cap &
 			    (IEEE80211_HT_CAP_SGI_40 | IEEE80211_HT_CAP_SGI_20))
 				sgi = 1;
-			rcu_read_unlock();
 
 			highest_rate = fls(ramask) - 1;
 			if (highest_rate < DESC_RATE_MCS0) {
@@ -4679,6 +4678,7 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 				else
 					rarpt->txrate.bw = RATE_INFO_BW_20;
 			}
+			rcu_read_unlock();
 			bit_rate = cfg80211_calculate_bitrate(&rarpt->txrate);
 			rarpt->bit_rate = bit_rate;
 			rarpt->desc_rate = highest_rate;
-- 
2.35.1



