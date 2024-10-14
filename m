Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0236443AA9;
	Mon, 14 Oct 2024 14:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917531; cv=none; b=Bf4oQqYV7woRsDszbbSF+0OgZWFnWRBwLntbEMOwmN1PD5el5Rgey3ILIKQhZhjyvoJb1c18jZxC/QZpMy5XKsw0brUmJL4XLyd+I7M8tZW3y9IT7nlR4NhgYwa92Jjc0ZJw80PAq/IxHqC+MaF2PElhCw/Fc43qYHzYoIQZKAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917531; c=relaxed/simple;
	bh=HEumOT+3qg9Q6TYPrPt8RqjB1nGSnN+rYlHSHm9yylU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ta96VBB99D/JQGWFYtBfXZKuB4I1aIryzAH75FoxyM3oBTnqMZL2QQkef4/z/oxJ/BS8JVpqz9jEuA7WnCoBoD9VX63Bh+Y3fmvZ9GVdPY6z62drfAa7b2oY3x53+Hb0EM9AASmhHvCvoyWEgn+lMXCXaZxFX1s7CxHktWrEZ+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdbFyGDu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdbFyGDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EADC4CEC3;
	Mon, 14 Oct 2024 14:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917530;
	bh=HEumOT+3qg9Q6TYPrPt8RqjB1nGSnN+rYlHSHm9yylU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdbFyGDufQ8ayuau2PqGNpg3y7r8/50+dzFrdgGL9FqgRrD9rfofl0enTG48ab5Lf
	 HlQ/vyIfLDcrHH5Sm9Q2xV0VD+K73TKGF7T8udAXxznJCA0dsr2zsnRwlHCinkN/CV
	 P5GddLo8xVe7TWQ9T7oLqwLYzHsM8NtF8SSNb4Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8dd98a9e98ee28dc484a@syzkaller.appspotmail.com,
	Ping-Ke Shih <pkshih@realtek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/798] wifi: mac80211: dont use rate mask for offchannel TX either
Date: Mon, 14 Oct 2024 16:09:32 +0200
Message-ID: <20241014141218.666406340@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit e7a7ef9a0742dbd0818d5b15fba2c5313ace765b ]

Like the commit ab9177d83c04 ("wifi: mac80211: don't use rate mask for
scanning"), ignore incorrect settings to avoid no supported rate warning
reported by syzbot.

The syzbot did bisect and found cause is commit 9df66d5b9f45 ("cfg80211:
fix default HE tx bitrate mask in 2G band"), which however corrects
bitmask of HE MCS and recognizes correctly settings of empty legacy rate
plus HE MCS rate instead of returning -EINVAL.

As suggestions [1], follow the change of SCAN TX to consider this case of
offchannel TX as well.

[1] https://lore.kernel.org/linux-wireless/6ab2dc9c3afe753ca6fdcdd1421e7a1f47e87b84.camel@sipsolutions.net/T/#m2ac2a6d2be06a37c9c47a3d8a44b4f647ed4f024

Reported-by: syzbot+8dd98a9e98ee28dc484a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-wireless/000000000000fdef8706191a3f7b@google.com/
Fixes: 9df66d5b9f45 ("cfg80211: fix default HE tx bitrate mask in 2G band")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240729074816.20323-1-pkshih@realtek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mac80211.h    | 7 ++++---
 net/mac80211/offchannel.c | 1 +
 net/mac80211/rate.c       | 2 +-
 net/mac80211/scan.c       | 2 +-
 net/mac80211/tx.c         | 2 +-
 5 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 87a4f334c22a8..a5a5a29157364 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -885,8 +885,9 @@ enum mac80211_tx_info_flags {
  *	of their QoS TID or other priority field values.
  * @IEEE80211_TX_CTRL_MCAST_MLO_FIRST_TX: first MLO TX, used mostly internally
  *	for sequence number assignment
- * @IEEE80211_TX_CTRL_SCAN_TX: Indicates that this frame is transmitted
- *	due to scanning, not in normal operation on the interface.
+ * @IEEE80211_TX_CTRL_DONT_USE_RATE_MASK: Don't use rate mask for this frame
+ *	which is transmitted due to scanning or offchannel TX, not in normal
+ *	operation on the interface.
  * @IEEE80211_TX_CTRL_MLO_LINK: If not @IEEE80211_LINK_UNSPECIFIED, this
  *	frame should be transmitted on the specific link. This really is
  *	only relevant for frames that do not have data present, and is
@@ -907,7 +908,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTRL_NO_SEQNO		= BIT(7),
 	IEEE80211_TX_CTRL_DONT_REORDER		= BIT(8),
 	IEEE80211_TX_CTRL_MCAST_MLO_FIRST_TX	= BIT(9),
-	IEEE80211_TX_CTRL_SCAN_TX		= BIT(10),
+	IEEE80211_TX_CTRL_DONT_USE_RATE_MASK	= BIT(10),
 	IEEE80211_TX_CTRL_MLO_LINK		= 0xf0000000,
 };
 
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 50dc379ca097e..b2f895ea752dd 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -940,6 +940,7 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	}
 
 	IEEE80211_SKB_CB(skb)->flags = flags;
+	IEEE80211_SKB_CB(skb)->control.flags |= IEEE80211_TX_CTRL_DONT_USE_RATE_MASK;
 
 	skb->dev = sdata->dev;
 
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 3cf252418bd38..78e7ac6c0af0b 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -890,7 +890,7 @@ void ieee80211_get_tx_rates(struct ieee80211_vif *vif,
 	if (ieee80211_is_tx_data(skb))
 		rate_control_apply_mask(sdata, sta, sband, dest, max_rates);
 
-	if (!(info->control.flags & IEEE80211_TX_CTRL_SCAN_TX))
+	if (!(info->control.flags & IEEE80211_TX_CTRL_DONT_USE_RATE_MASK))
 		mask = sdata->rc_rateidx_mask[info->band];
 
 	if (dest[0].idx < 0)
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 62c22ff329ad4..6432dd3ec2a7e 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -647,7 +647,7 @@ static void ieee80211_send_scan_probe_req(struct ieee80211_sub_if_data *sdata,
 				cpu_to_le16(IEEE80211_SN_TO_SEQ(sn));
 		}
 		IEEE80211_SKB_CB(skb)->flags |= tx_flags;
-		IEEE80211_SKB_CB(skb)->control.flags |= IEEE80211_TX_CTRL_SCAN_TX;
+		IEEE80211_SKB_CB(skb)->control.flags |= IEEE80211_TX_CTRL_DONT_USE_RATE_MASK;
 		ieee80211_tx_skb_tid_band(sdata, skb, 7, channel->band);
 	}
 }
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0685ae2ea64eb..62b2817df2ba9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -721,7 +721,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	txrc.skb = tx->skb;
 	txrc.reported_rate.idx = -1;
 
-	if (unlikely(info->control.flags & IEEE80211_TX_CTRL_SCAN_TX)) {
+	if (unlikely(info->control.flags & IEEE80211_TX_CTRL_DONT_USE_RATE_MASK)) {
 		txrc.rate_idx_mask = ~0;
 	} else {
 		txrc.rate_idx_mask = tx->sdata->rc_rateidx_mask[info->band];
-- 
2.43.0



