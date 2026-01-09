Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8051DF72C;
	Fri,  9 Jan 2026 12:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962603; cv=none; b=DOYp06HKM41KbUVqGAU6aYzcrwviyqjlHUmvcH/F/sO8aJDCAN6YPFmiJagGseGwlj7n3YS7UzeWYlfZWIqc0l0zkSGAw4Kw9jbapN/WYG2hFb2qMnunn0CXevqwoR/OU75ECDF3QSJCOPCu2M2Xi3McBrdkkAVY8U0iEhYeQrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962603; c=relaxed/simple;
	bh=4zS/UTtNXeuKsQS3DpyN8tLCoM3V016O+PlGnLGi3JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4fuW5puXzX/7KYLA0bhDWnicGMOW/FvoHQsE+wWoiqEuk6GgkJyzvTw70acrA99/GbmEtzugsyU4BfWOYcxUvXgcY1U7po1IFUhEea10Tvenl/1Gv1yi5cAyJej0NI7+XNywWWRPo9q8um7OSOtEGrW6grRTWdLJ7b0CaDxgEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVZ9Ouxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVZ9Ouxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F20C4CEF1;
	Fri,  9 Jan 2026 12:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962603;
	bh=4zS/UTtNXeuKsQS3DpyN8tLCoM3V016O+PlGnLGi3JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVZ9OuxadiRmzhctRPIQXrp2DHldNNzR6EY3ufOxDl0gFU0m3hxLCuDf1Pw9Ry5kc
	 xpExyOmk1VoPwKJ6Xhg7FljZMUshKoULkWXUpZ0kB6/WHSKjpBc+Zj+iYjQrIyZgY5
	 viZ7XU8DF8+paCjDnr60//n0ClrVqQJL5rNROWtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aloka Dixit <quic_alokad@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 391/634] wifi: cfg80211: move puncturing bitmap validation from mac80211
Date: Fri,  9 Jan 2026 12:41:09 +0100
Message-ID: <20260109112132.244200275@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aloka Dixit <quic_alokad@quicinc.com>

[ Upstream commit b25413fed3d43e1ed3340df4d928971bb8639f66 ]

- Move ieee80211_valid_disable_subchannel_bitmap() from mlme.c to
  chan.c, rename it as cfg80211_valid_disable_subchannel_bitmap()
  and export it.
- Modify the prototype to include struct cfg80211_chan_def instead
  of only bandwidth to support a check which returns false if the
  primary channel is punctured.

Signed-off-by: Aloka Dixit <quic_alokad@quicinc.com>
Link: https://lore.kernel.org/r/20230131001227.25014-2-quic_alokad@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: a519be2f5d95 ("wifi: mac80211: do not use old MBSSID elements")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h | 12 +++++++
 net/mac80211/mlme.c    | 73 ++++--------------------------------------
 net/wireless/chan.c    | 69 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+), 67 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d15033420ca3..bf79788f1c5d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -9056,4 +9056,16 @@ static inline int cfg80211_color_change_notify(struct net_device *dev)
 					 0, 0);
 }
 
+/**
+ * cfg80211_valid_disable_subchannel_bitmap - validate puncturing bitmap
+ * @bitmap: bitmap to be validated
+ * @chandef: channel definition
+ *
+ * Validate the puncturing bitmap.
+ *
+ * Return: %true if the bitmap is valid. %false otherwise.
+ */
+bool cfg80211_valid_disable_subchannel_bitmap(u16 *bitmap,
+					      const struct cfg80211_chan_def *chandef);
+
 #endif /* __NET_CFG80211_H */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 25483596f22e..1fb41e5cc577 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -88,67 +88,6 @@ MODULE_PARM_DESC(probe_wait_ms,
  */
 #define IEEE80211_SIGNAL_AVE_MIN_COUNT	4
 
-struct ieee80211_per_bw_puncturing_values {
-	u8 len;
-	const u16 *valid_values;
-};
-
-static const u16 puncturing_values_80mhz[] = {
-	0x8, 0x4, 0x2, 0x1
-};
-
-static const u16 puncturing_values_160mhz[] = {
-	 0x80, 0x40, 0x20, 0x10, 0x8, 0x4, 0x2, 0x1, 0xc0, 0x30, 0xc, 0x3
-};
-
-static const u16 puncturing_values_320mhz[] = {
-	0xc000, 0x3000, 0xc00, 0x300, 0xc0, 0x30, 0xc, 0x3, 0xf000, 0xf00,
-	0xf0, 0xf, 0xfc00, 0xf300, 0xf0c0, 0xf030, 0xf00c, 0xf003, 0xc00f,
-	0x300f, 0xc0f, 0x30f, 0xcf, 0x3f
-};
-
-#define IEEE80211_PER_BW_VALID_PUNCTURING_VALUES(_bw) \
-	{ \
-		.len = ARRAY_SIZE(puncturing_values_ ## _bw ## mhz), \
-		.valid_values = puncturing_values_ ## _bw ## mhz \
-	}
-
-static const struct ieee80211_per_bw_puncturing_values per_bw_puncturing[] = {
-	IEEE80211_PER_BW_VALID_PUNCTURING_VALUES(80),
-	IEEE80211_PER_BW_VALID_PUNCTURING_VALUES(160),
-	IEEE80211_PER_BW_VALID_PUNCTURING_VALUES(320)
-};
-
-static bool ieee80211_valid_disable_subchannel_bitmap(u16 *bitmap,
-						      enum nl80211_chan_width bw)
-{
-	u32 idx, i;
-
-	switch (bw) {
-	case NL80211_CHAN_WIDTH_80:
-		idx = 0;
-		break;
-	case NL80211_CHAN_WIDTH_160:
-		idx = 1;
-		break;
-	case NL80211_CHAN_WIDTH_320:
-		idx = 2;
-		break;
-	default:
-		*bitmap = 0;
-		break;
-	}
-
-	if (!*bitmap)
-		return true;
-
-	for (i = 0; i < per_bw_puncturing[idx].len; i++)
-		if (per_bw_puncturing[idx].valid_values[i] == *bitmap)
-			return true;
-
-	return false;
-}
-
 /*
  * Extract from the given disabled subchannel bitmap (raw format
  * from the EHT Operation Element) the bits for the subchannel
@@ -206,8 +145,8 @@ ieee80211_handle_puncturing_bitmap(struct ieee80211_link_data *link,
 			ieee80211_extract_dis_subch_bmap(eht_oper, chandef,
 							 bitmap);
 
-		if (ieee80211_valid_disable_subchannel_bitmap(&bitmap,
-							      chandef->width))
+		if (cfg80211_valid_disable_subchannel_bitmap(&bitmap,
+							     chandef))
 			break;
 		link->u.mgd.conn_flags |=
 			ieee80211_chandef_downgrade(chandef);
@@ -5621,8 +5560,8 @@ static bool ieee80211_config_puncturing(struct ieee80211_link_data *link,
 	    extracted == link->conf->eht_puncturing)
 		return true;
 
-	if (!ieee80211_valid_disable_subchannel_bitmap(&bitmap,
-						       link->conf->chandef.width)) {
+	if (!cfg80211_valid_disable_subchannel_bitmap(&bitmap,
+						      &link->conf->chandef)) {
 		link_info(link,
 			  "Got an invalid disable subchannel bitmap from AP %pM: bitmap = 0x%x, bw = 0x%x. disconnect\n",
 			  link->u.mgd.bssid,
@@ -7110,8 +7049,8 @@ ieee80211_setup_assoc_link(struct ieee80211_sub_if_data *sdata,
 			u16 bitmap;
 
 			bitmap = get_unaligned_le16(disable_subchannel_bitmap);
-			if (ieee80211_valid_disable_subchannel_bitmap(&bitmap,
-								      link->conf->chandef.width))
+			if (cfg80211_valid_disable_subchannel_bitmap(&bitmap,
+								     &link->conf->chandef))
 				ieee80211_handle_puncturing_bitmap(link,
 								   eht_oper,
 								   bitmap,
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 0e5835cd8c61..0b7e81db383d 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -1460,3 +1460,72 @@ struct cfg80211_chan_def *wdev_chandef(struct wireless_dev *wdev,
 	}
 }
 EXPORT_SYMBOL(wdev_chandef);
+
+struct cfg80211_per_bw_puncturing_values {
+	u8 len;
+	const u16 *valid_values;
+};
+
+static const u16 puncturing_values_80mhz[] = {
+	0x8, 0x4, 0x2, 0x1
+};
+
+static const u16 puncturing_values_160mhz[] = {
+	 0x80, 0x40, 0x20, 0x10, 0x8, 0x4, 0x2, 0x1, 0xc0, 0x30, 0xc, 0x3
+};
+
+static const u16 puncturing_values_320mhz[] = {
+	0xc000, 0x3000, 0xc00, 0x300, 0xc0, 0x30, 0xc, 0x3, 0xf000, 0xf00,
+	0xf0, 0xf, 0xfc00, 0xf300, 0xf0c0, 0xf030, 0xf00c, 0xf003, 0xc00f,
+	0x300f, 0xc0f, 0x30f, 0xcf, 0x3f
+};
+
+#define CFG80211_PER_BW_VALID_PUNCTURING_VALUES(_bw) \
+	{ \
+		.len = ARRAY_SIZE(puncturing_values_ ## _bw ## mhz), \
+		.valid_values = puncturing_values_ ## _bw ## mhz \
+	}
+
+static const struct cfg80211_per_bw_puncturing_values per_bw_puncturing[] = {
+	CFG80211_PER_BW_VALID_PUNCTURING_VALUES(80),
+	CFG80211_PER_BW_VALID_PUNCTURING_VALUES(160),
+	CFG80211_PER_BW_VALID_PUNCTURING_VALUES(320)
+};
+
+bool cfg80211_valid_disable_subchannel_bitmap(u16 *bitmap,
+					      const struct cfg80211_chan_def *chandef)
+{
+	u32 idx, i, start_freq;
+
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_80:
+		idx = 0;
+		start_freq = chandef->center_freq1 - 40;
+		break;
+	case NL80211_CHAN_WIDTH_160:
+		idx = 1;
+		start_freq = chandef->center_freq1 - 80;
+		break;
+	case NL80211_CHAN_WIDTH_320:
+		idx = 2;
+		start_freq = chandef->center_freq1 - 160;
+		break;
+	default:
+		*bitmap = 0;
+		break;
+	}
+
+	if (!*bitmap)
+		return true;
+
+	/* check if primary channel is punctured */
+	if (*bitmap & (u16)BIT((chandef->chan->center_freq - start_freq) / 20))
+		return false;
+
+	for (i = 0; i < per_bw_puncturing[idx].len; i++)
+		if (per_bw_puncturing[idx].valid_values[i] == *bitmap)
+			return true;
+
+	return false;
+}
+EXPORT_SYMBOL(cfg80211_valid_disable_subchannel_bitmap);
-- 
2.51.0



