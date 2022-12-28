Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068291875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E764C433D2;
	Wed, 28 Dec 2022 15:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242922;
	bh=ToX4fY0BSQe3Ffz5Qs4DGu9yMSUB0krkhdBXqArhvS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOreidWQCyWya82ZvaQNtEgaD40HlCycfUrpqThfazYiqGbdKDNuC+kiGinybeWBD
	 +3ABnrVbxKr5+glU1zOwDRpEMe9EChz/b7vpXQQtXIi1OtXK9AtAdnxhNXMlk68sB8
	 NrTwV1p6lnYlX8HAEJAVUBuV1CwRjo3N+HUuMP40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0431/1146] wifi: rtl8xxxu: Fix use after rcu_read_unlock in rtl8xxxu_bss_info_changed
Date: Wed, 28 Dec 2022 15:32:50 +0100
Message-Id: <20221228144341.889016261@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 8d00ce805f1c..2d908296cf70 100644
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



