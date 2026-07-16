Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C6C3F482E;
	Thu, 16 Jul 2026 13:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209146; cv=none; b=U0aW5l3P9gRyttqwHxzpeXS+FsKzUomAaEXd6zmgGgn15szAjc1pc8Cnmw/yxWiCH+2Rnej7PR8P5qDuTsR+UsW0mnvhE6asDEsWQQcZXTgp0/6EdWLTIpTkeFPA/v7JFHI7TF8aZN/Pko89ZM83y+HH3n818t2ndl9M0uYIgS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209146; c=relaxed/simple;
	bh=psLIXLL+E5tLYKmIHGR41e+X8ImeptZVOuFHcMliNUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwVpOke1CjxH4Ulp9VUnt+JBuJXHypYlcdVbEIA083tO/rxzVBn17LJEmXss4u5OTOHcLrjw2sVtD4V3hInEGUYHpzGXlfp0YcdDfTxt/CzQQ72BIOPEucUacbeneoHY6XYCPPkSOMRP5se4ZQpmlzyFpCgMfYJUpkmgN7vUe4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAqTNY61; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAqTNY61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7E51F000E9;
	Thu, 16 Jul 2026 13:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209145;
	bh=jyvcz0YlL2hRlYZO2jpM+9UQSvX1FT/P34oOOM5rOWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sAqTNY61TJI+s/jTCd1lY7k73whtYz9ytuuuKAsWIoVbgqqvxKtaRW64D1wp2Lyud
	 HzjH98EWiWLSxb0rpXOJD2IFEVTVPc/BgBdSZY6kckNVkSkc+yv3BpeUzOac2u4hwl
	 /lRShiRswyKo+LDVvLfHAFyvPEj6yBXIOsb09kQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Po-Hao Huang <phhuang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 030/518] wifi: rtw89: correct drop logic for malformed AMPDU frames
Date: Thu, 16 Jul 2026 15:24:58 +0200
Message-ID: <20260716133048.437330106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit 63ccdfac8677387dfdbd9d4336089e9823280704 ]

The previous commit aims to fix issue caused by malformed AMPDU frames.
But the drop logic fails to deal with the first AMPDU packet paired with
certain range of sequence number, and leads to unexpected packet drop.
It is more likely to encounter this failure when there are busy traffic
during rekey process and could lead to disconnection from the AP.
Fix this by adding a initial state judgement and only reset status
during pairwise rekey.

Fixes: bda294ed0ed0 ("wifi: rtw89: Drop malformed AMPDU frames with abnormal PN")
Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260515014433.16168-10-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c     | 3 ++-
 drivers/net/wireless/realtek/rtw89/mac80211.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 70feab97dccb5a..486c1774fb9759 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -3363,7 +3363,8 @@ static bool rtw89_core_skb_pn_valid(struct rtw89_dev *rtwdev,
 		last_pn = tid_stats->last_pn;
 
 		if (pn > last_pn) {
-			if (ieee80211_sn_less(mpdu_sn, tid_stats->last_sn)) {
+			if (last_pn != -1LL &&
+			    ieee80211_sn_less(mpdu_sn, tid_stats->last_sn)) {
 				dev_kfree_skb_any(skb);
 
 				return false;
diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index 501c3af1da01a9..0672d13d13a647 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -964,7 +964,8 @@ static int rtw89_ops_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			rtw89_err(rtwdev, "failed to add key to sec cam\n");
 			return ret;
 		}
-		rtw89_core_tid_rx_stats_reset(rtwdev);
+		if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE)
+			rtw89_core_tid_rx_stats_reset(rtwdev);
 		break;
 	case DISABLE_KEY:
 		flush_work(&rtwdev->txq_work);
-- 
2.53.0



