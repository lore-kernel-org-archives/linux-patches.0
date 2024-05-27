Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCACA15FCFE;
	Mon, 27 May 2024 19:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837534; cv=none; b=FAW9jwjKewNsKQY+0BwsTGF+Aa7A+QRSDfV3Yg8BkBRavgLeM7/wd8nJqsDtPrnaWpiHLShJKunjvV0n4cajIMT2lxAWGi9W5t4gxnQCo9pETkPF6Kd4ZTw26W43YsoXnHv49qLEs2III8Rineu9LQkKOd/7wOczY7FdlYp6yB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837534; c=relaxed/simple;
	bh=hRctfSGlU8gNJk9TmljooAXyoO2v6jkfbMnXHEYjwNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfOETQA0/Ql0dbl/OiTyO3e42e/BguqL+NCjY/QDQKmMnynhR8Y6PYBeNzDhh2h8TT1rVDCJHFQp9jQy+yi3IrBO00AWOgob5BnMUsr6uSAbm46NhwHFlwM+SkhWoiVGJxPocAfv9uyiKJ4u1tGxUsF/BKNs7gR12CKuaD6r2xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UN2NP4Xf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UN2NP4Xf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52208C32781;
	Mon, 27 May 2024 19:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837534;
	bh=hRctfSGlU8gNJk9TmljooAXyoO2v6jkfbMnXHEYjwNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UN2NP4XfksAKEueeid/Y/ss5Jyf8PPW8fkUG0z1m8Mr2NVa732mibs9GtFSwtRDCu
	 mbA5dz6KqI9n46Ciz09abAn8pNqGWL3LmBcBI0uIMrd/Fi+RQl4y2RYMhK9NdTAuX8
	 OFuW/+IRwoV9H5SuRAd+mtYHxoik0ZmSK6zwCZCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fdc5123366fb9c3fdc6d@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 041/493] wifi: mac80211: dont use rate mask for scanning
Date: Mon, 27 May 2024 20:50:43 +0200
Message-ID: <20240527185630.157146025@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index d400fe2e8668d..df9b578e58bb2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -932,6 +932,8 @@ enum mac80211_tx_info_flags {
  *	of their QoS TID or other priority field values.
  * @IEEE80211_TX_CTRL_MCAST_MLO_FIRST_TX: first MLO TX, used mostly internally
  *	for sequence number assignment
+ * @IEEE80211_TX_CTRL_SCAN_TX: Indicates that this frame is transmitted
+ *	due to scanning, not in normal operation on the interface.
  * @IEEE80211_TX_CTRL_MLO_LINK: If not @IEEE80211_LINK_UNSPECIFIED, this
  *	frame should be transmitted on the specific link. This really is
  *	only relevant for frames that do not have data present, and is
@@ -952,6 +954,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTRL_NO_SEQNO		= BIT(7),
 	IEEE80211_TX_CTRL_DONT_REORDER		= BIT(8),
 	IEEE80211_TX_CTRL_MCAST_MLO_FIRST_TX	= BIT(9),
+	IEEE80211_TX_CTRL_SCAN_TX		= BIT(10),
 	IEEE80211_TX_CTRL_MLO_LINK		= 0xf0000000,
 };
 
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 0efdaa8f2a92e..3cf252418bd38 100644
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
index f9d5842601fa9..dd0ec34a3f8a8 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -638,6 +638,7 @@ static void ieee80211_send_scan_probe_req(struct ieee80211_sub_if_data *sdata,
 				cpu_to_le16(IEEE80211_SN_TO_SEQ(sn));
 		}
 		IEEE80211_SKB_CB(skb)->flags |= tx_flags;
+		IEEE80211_SKB_CB(skb)->control.flags |= IEEE80211_TX_CTRL_SCAN_TX;
 		ieee80211_tx_skb_tid_band(sdata, skb, 7, channel->band);
 	}
 }
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6fbb15b65902c..a8a4912bf2cb4 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -701,11 +701,16 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
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



