Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D38D197533;
	Thu,  6 Jun 2024 14:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683156; cv=none; b=pUznyMpzNSxnHFsVdnCeeW7ChyQXd51ODFNuuA2ITISOWLhdpNfM1MSZD04mhswSeTwHEXpbU64qWAArL0bl0PA4vvXUFDj0dH3xtIuswRJKH89RiqA6jzCagVWAucVo0S31+HQwWtjfWPOGukJ/CIfraQ/Yu8zSuhozp7Nusc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683156; c=relaxed/simple;
	bh=ij8cBWS0KsnNpyomDoqbU3moV5fkzpEeY96DiW4m8Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5CruYC5KSoHwONk9S8XQhdh81sQamF6e3Ntb9w79EKfYmT1FkBEHXUX3C0mS/gLMgUCfU0W98nJBKW3DUABQtSszDpWOe7vrJ/HEjz47PDWQOwnrIx3bzaGfyGGtnpyXyTmtUTTZ6PWfpTm6SJW2dQX37RBsRj8YY6y5zsn4cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NNFanryw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NNFanryw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02865C2BD10;
	Thu,  6 Jun 2024 14:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683156;
	bh=ij8cBWS0KsnNpyomDoqbU3moV5fkzpEeY96DiW4m8Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NNFanryw1sAN9hfXl6aLl4073W/dMqzO6VRhyy/lZIXlGh/uOy0kF4CSnVLICK4n5
	 trNbWR1nqlTaf8jpgxNyme0HYXfqeFBOZsdoPXaiLrctLXd5TnLp3cNOL+yGiLbNwd
	 U/kmi4McYUfutf4vKnw6kRnxZ8NzO6lufaI3PRCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fdc5123366fb9c3fdc6d@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/473] wifi: mac80211: dont use rate mask for scanning
Date: Thu,  6 Jun 2024 15:59:16 +0200
Message-ID: <20240606131700.766692554@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit ab9177d83c040eba58387914077ebca56f14fae6 ]

The rate mask is intended for use during operation, and
can be set to only have masks for the currently active
band. As such, it cannot be used for scanning which can
be on other bands as well.

Simply ignore the rate masks during scanning to avoid
warnings from incorrect settings.

Reported-by: syzbot+fdc5123366fb9c3fdc6d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fdc5123366fb9c3fdc6d
Co-developed-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Tested-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://msgid.link/20240326220854.9594cbb418ca.I7f86c0ba1f98cf7e27c2bacf6c2d417200ecea5c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mac80211.h |  3 +++
 net/mac80211/rate.c    |  6 +++++-
 net/mac80211/scan.c    |  1 +
 net/mac80211/tx.c      | 13 +++++++++----
 4 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 43173204d6d5e..87a4f334c22a8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -885,6 +885,8 @@ enum mac80211_tx_info_flags {
  *	of their QoS TID or other priority field values.
  * @IEEE80211_TX_CTRL_MCAST_MLO_FIRST_TX: first MLO TX, used mostly internally
  *	for sequence number assignment
+ * @IEEE80211_TX_CTRL_SCAN_TX: Indicates that this frame is transmitted
+ *	due to scanning, not in normal operation on the interface.
  * @IEEE80211_TX_CTRL_MLO_LINK: If not @IEEE80211_LINK_UNSPECIFIED, this
  *	frame should be transmitted on the specific link. This really is
  *	only relevant for frames that do not have data present, and is
@@ -905,6 +907,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTRL_NO_SEQNO		= BIT(7),
 	IEEE80211_TX_CTRL_DONT_REORDER		= BIT(8),
 	IEEE80211_TX_CTRL_MCAST_MLO_FIRST_TX	= BIT(9),
+	IEEE80211_TX_CTRL_SCAN_TX		= BIT(10),
 	IEEE80211_TX_CTRL_MLO_LINK		= 0xf0000000,
 };
 
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 9d33fd2377c88..a2bc9c5d92b8b 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -877,6 +877,7 @@ void ieee80211_get_tx_rates(struct ieee80211_vif *vif,
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_supported_band *sband;
+	u32 mask = ~0;
 
 	rate_control_fill_sta_table(sta, info, dest, max_rates);
 
@@ -889,9 +890,12 @@ void ieee80211_get_tx_rates(struct ieee80211_vif *vif,
 	if (ieee80211_is_tx_data(skb))
 		rate_control_apply_mask(sdata, sta, sband, dest, max_rates);
 
+	if (!(info->control.flags & IEEE80211_TX_CTRL_SCAN_TX))
+		mask = sdata->rc_rateidx_mask[info->band];
+
 	if (dest[0].idx < 0)
 		__rate_control_send_low(&sdata->local->hw, sband, sta, info,
-					sdata->rc_rateidx_mask[info->band]);
+					mask);
 
 	if (sta)
 		rate_fixup_ratelist(vif, sband, info, dest, max_rates);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index c37e2576f1c13..933d02d7c1284 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -647,6 +647,7 @@ static void ieee80211_send_scan_probe_req(struct ieee80211_sub_if_data *sdata,
 				cpu_to_le16(IEEE80211_SN_TO_SEQ(sn));
 		}
 		IEEE80211_SKB_CB(skb)->flags |= tx_flags;
+		IEEE80211_SKB_CB(skb)->control.flags |= IEEE80211_TX_CTRL_SCAN_TX;
 		ieee80211_tx_skb_tid_band(sdata, skb, 7, channel->band);
 	}
 }
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3d62e8b718740..419baf8efddea 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -720,11 +720,16 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	txrc.bss_conf = &tx->sdata->vif.bss_conf;
 	txrc.skb = tx->skb;
 	txrc.reported_rate.idx = -1;
-	txrc.rate_idx_mask = tx->sdata->rc_rateidx_mask[info->band];
 
-	if (tx->sdata->rc_has_mcs_mask[info->band])
-		txrc.rate_idx_mcs_mask =
-			tx->sdata->rc_rateidx_mcs_mask[info->band];
+	if (unlikely(info->control.flags & IEEE80211_TX_CTRL_SCAN_TX)) {
+		txrc.rate_idx_mask = ~0;
+	} else {
+		txrc.rate_idx_mask = tx->sdata->rc_rateidx_mask[info->band];
+
+		if (tx->sdata->rc_has_mcs_mask[info->band])
+			txrc.rate_idx_mcs_mask =
+				tx->sdata->rc_rateidx_mcs_mask[info->band];
+	}
 
 	txrc.bss = (tx->sdata->vif.type == NL80211_IFTYPE_AP ||
 		    tx->sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
-- 
2.43.0



