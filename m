Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB23126FA77;
	Tue, 12 Aug 2025 19:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025648; cv=none; b=W1TBjaoh0zfnSQRG8S0qlEW0l0BuKCUQhEog9k45aNK7SDp5COQxYI4C4pS7Xo1ru54WND0qnxzZGO9wWExypLMb6WaeunNtWj4VAtBVvfwBQsc300YlHt25rytfMRrXIIcbrP4jlbDrZ8cnoA4APTckMQsdzSULSTZlGJWOOMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025648; c=relaxed/simple;
	bh=0xFS734lUwY3vNhCYpUVihvT5sFoYiynl6pzWBWCxrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pyrbfr9ogEFdeOR2ixcCuQakhWUDwVs5XWa6vS5MTlGFhh2JEmBQfzZgKVcjPoo8ZH5m/hv/ZbjUqA8QunmIScAoPjXJZxN9mwb7rLqEKIcqVagmGiatD7TaoLR/tI+37icg/Q7Bhsj2RNkm6RhwY5s1nPCB4q1Kd2H+2t9MVIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRoicdPT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRoicdPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2241EC4CEF0;
	Tue, 12 Aug 2025 19:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025648;
	bh=0xFS734lUwY3vNhCYpUVihvT5sFoYiynl6pzWBWCxrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRoicdPTJe8wtyeYwafflAvn1U7odcQFU7dDsLI9zYPgA3sc+U6vCA0ff1wiHT1hl
	 YGi2dNlfoY+3QntQnkeqGoZ9Tm8Mze2ouMhBC99Y6/n3AxIzOQNZmPWfpCi8corlvS
	 g/95AzF3P23XSzQtRBspixU7jINa6ss+pEiru1rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Chung Chen <damon.chen@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 103/480] wifi: rtw89: fix EHT 20MHz TX rate for non-AP STA
Date: Tue, 12 Aug 2025 19:45:11 +0200
Message-ID: <20250812174401.721388657@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Chung Chen <damon.chen@realtek.com>

[ Upstream commit fe30a8ae853bade282fce63e740b5f34bdc55f6e ]

The 4-octet EHT MCS/NSS subfield is only used for 20 MHz-only
non-AP STA. Correct the interpretation of this subfield to
prevent improper rate limitations.

Fixes: f1dfcee2eae9 ("wifi: rtw89: Correct EHT TX rate on 20MHz connection")
Signed-off-by: Kuan-Chung Chen <damon.chen@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250605114207.12381-6-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/phy.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/phy.c b/drivers/net/wireless/realtek/rtw89/phy.c
index f4eee642e5ce..4bdc6d9da625 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -119,10 +119,12 @@ static u64 get_eht_mcs_ra_mask(u8 *max_nss, u8 start_mcs, u8 n_nss)
 	return mask;
 }
 
-static u64 get_eht_ra_mask(struct ieee80211_link_sta *link_sta)
+static u64 get_eht_ra_mask(struct rtw89_vif_link *rtwvif_link,
+			   struct ieee80211_link_sta *link_sta)
 {
-	struct ieee80211_sta_eht_cap *eht_cap = &link_sta->eht_cap;
+	struct ieee80211_vif *vif = rtwvif_link_to_vif(rtwvif_link);
 	struct ieee80211_eht_mcs_nss_supp_20mhz_only *mcs_nss_20mhz;
+	struct ieee80211_sta_eht_cap *eht_cap = &link_sta->eht_cap;
 	struct ieee80211_eht_mcs_nss_supp_bw *mcs_nss;
 	u8 *he_phy_cap = link_sta->he_cap.he_cap_elem.phy_cap_info;
 
@@ -136,8 +138,8 @@ static u64 get_eht_ra_mask(struct ieee80211_link_sta *link_sta)
 		/* MCS 9, 11, 13 */
 		return get_eht_mcs_ra_mask(mcs_nss->rx_tx_max_nss, 9, 3);
 	case IEEE80211_STA_RX_BW_20:
-		if (!(he_phy_cap[0] &
-		      IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_MASK_ALL)) {
+		if (vif->type == NL80211_IFTYPE_AP &&
+		    !(he_phy_cap[0] & IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_MASK_ALL)) {
 			mcs_nss_20mhz = &eht_cap->eht_mcs_nss_supp.only_20mhz;
 			/* MCS 7, 9, 11, 13 */
 			return get_eht_mcs_ra_mask(mcs_nss_20mhz->rx_tx_max_nss, 7, 4);
@@ -332,7 +334,7 @@ static void rtw89_phy_ra_sta_update(struct rtw89_dev *rtwdev,
 	/* Set the ra mask from sta's capability */
 	if (link_sta->eht_cap.has_eht) {
 		mode |= RTW89_RA_MODE_EHT;
-		ra_mask |= get_eht_ra_mask(link_sta);
+		ra_mask |= get_eht_ra_mask(rtwvif_link, link_sta);
 
 		if (rtwdev->hal.no_mcs_12_13)
 			high_rate_masks = rtw89_ra_mask_eht_mcs0_11;
-- 
2.39.5



