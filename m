Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BC61E98E3;
	Tue, 17 Jun 2025 16:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178994; cv=none; b=u+MIIsWhsDjEv56xNeR8otu3qkyulPahAPwn3s+s6Z9bz3XnEltMbziK9g1Wf/tpruDlXR2XQ4iQCm05+jSgnnMHg5NV3MFDl/uIy/hyaWqaM+to9mUT5iRkLNPsyRqNBqZBJo91ONzeZLKTzHWgf2R6aK3jYXW1gsyOFm+sqAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178994; c=relaxed/simple;
	bh=XkeuJ8XbQKwFjQbZC1Cta5uLIdKMIDJtrNbRHXme3+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8Y44LtuTEgZqk4SyVWOLgTnq1UDGj5KMTemCeyLmPtGSp04flHptZJvkzN5+nQykx2/5kts6LyfruvRLY6ouav01I2huN45609LebWbpHmxuCU9mmZRfWY15Ivts/vtvRSYsiveZf74Y2/KlD880Y1+yx4o1TqYhKDWfB7nFYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+x7hgjk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+x7hgjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B866BC4CEF0;
	Tue, 17 Jun 2025 16:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178994;
	bh=XkeuJ8XbQKwFjQbZC1Cta5uLIdKMIDJtrNbRHXme3+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+x7hgjkpAn/YXHhvHors6AQSPTzBHaX9XMJ43MK7wyky5LP4G4V+tL+Kvr4Dj68j
	 0YH30p5zIxs/FIjcRlQZXjngJT1CLTVpYqX/qZ9Nww1e4KrhFVKBy0lJ65rQERMEqO
	 8KQvLGg6mZswXLtm2zJYW53+IB9ozmocrwKxdq2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 616/780] wifi: cfg80211/mac80211: correctly parse S1G beacon optional elements
Date: Tue, 17 Jun 2025 17:25:24 +0200
Message-ID: <20250617152516.567682141@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Lachlan Hodges <lachlan.hodges@morsemicro.com>

[ Upstream commit 1e1f706fc2ce90eaaf3480b3d5f27885960d751c ]

S1G beacons are not traditional beacons but a type of extension frame.
Extension frames contain the frame control and duration fields, followed
by zero or more optional fields before the frame body. These optional
fields are distinct from the variable length elements.

The presence of optional fields is indicated in the frame control field.
To correctly locate the elements offset, the frame control must be parsed
to identify which optional fields are present. Currently, mac80211 parses
S1G beacons based on fixed assumptions about the frame layout, without
inspecting the frame control field. This can result in incorrect offsets
to the "variable" portion of the frame.

Properly parse S1G beacon frames by using the field lengths defined in
IEEE 802.11-2024, section 9.3.4.3, ensuring that the elements offset is
calculated accurately.

Fixes: 9eaffe5078ca ("cfg80211: convert S1G beacon to scan results")
Fixes: cd418ba63f0c ("mac80211: convert S1G beacon to scan results")
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Link: https://patch.msgid.link/20250603053538.468562-1-lachlan.hodges@morsemicro.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ieee80211.h | 79 ++++++++++++++++++++++++++++++++++-----
 net/mac80211/mlme.c       |  7 +---
 net/mac80211/scan.c       | 11 +++---
 net/wireless/scan.c       | 18 ++++-----
 4 files changed, 83 insertions(+), 32 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 457b4fba88bd0..7edc3fb0641cb 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -111,6 +111,8 @@
 
 /* bits unique to S1G beacon */
 #define IEEE80211_S1G_BCN_NEXT_TBTT	0x100
+#define IEEE80211_S1G_BCN_CSSID		0x200
+#define IEEE80211_S1G_BCN_ANO		0x400
 
 /* see 802.11ah-2016 9.9 NDP CMAC frames */
 #define IEEE80211_S1G_1MHZ_NDP_BITS	25
@@ -153,9 +155,6 @@
 
 #define IEEE80211_ANO_NETTYPE_WILD              15
 
-/* bits unique to S1G beacon */
-#define IEEE80211_S1G_BCN_NEXT_TBTT    0x100
-
 /* control extension - for IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTL_EXT */
 #define IEEE80211_CTL_EXT_POLL		0x2000
 #define IEEE80211_CTL_EXT_SPR		0x3000
@@ -627,6 +626,42 @@ static inline bool ieee80211_is_s1g_beacon(__le16 fc)
 	       cpu_to_le16(IEEE80211_FTYPE_EXT | IEEE80211_STYPE_S1G_BEACON);
 }
 
+/**
+ * ieee80211_s1g_has_next_tbtt - check if IEEE80211_S1G_BCN_NEXT_TBTT
+ * @fc: frame control bytes in little-endian byteorder
+ * Return: whether or not the frame contains the variable-length
+ *	next TBTT field
+ */
+static inline bool ieee80211_s1g_has_next_tbtt(__le16 fc)
+{
+	return ieee80211_is_s1g_beacon(fc) &&
+		(fc & cpu_to_le16(IEEE80211_S1G_BCN_NEXT_TBTT));
+}
+
+/**
+ * ieee80211_s1g_has_ano - check if IEEE80211_S1G_BCN_ANO
+ * @fc: frame control bytes in little-endian byteorder
+ * Return: whether or not the frame contains the variable-length
+ *	ANO field
+ */
+static inline bool ieee80211_s1g_has_ano(__le16 fc)
+{
+	return ieee80211_is_s1g_beacon(fc) &&
+		(fc & cpu_to_le16(IEEE80211_S1G_BCN_ANO));
+}
+
+/**
+ * ieee80211_s1g_has_cssid - check if IEEE80211_S1G_BCN_CSSID
+ * @fc: frame control bytes in little-endian byteorder
+ * Return: whether or not the frame contains the variable-length
+ *	compressed SSID field
+ */
+static inline bool ieee80211_s1g_has_cssid(__le16 fc)
+{
+	return ieee80211_is_s1g_beacon(fc) &&
+		(fc & cpu_to_le16(IEEE80211_S1G_BCN_CSSID));
+}
+
 /**
  * ieee80211_is_s1g_short_beacon - check if frame is an S1G short beacon
  * @fc: frame control bytes in little-endian byteorder
@@ -1245,16 +1280,40 @@ struct ieee80211_ext {
 			u8 change_seq;
 			u8 variable[0];
 		} __packed s1g_beacon;
-		struct {
-			u8 sa[ETH_ALEN];
-			__le32 timestamp;
-			u8 change_seq;
-			u8 next_tbtt[3];
-			u8 variable[0];
-		} __packed s1g_short_beacon;
 	} u;
 } __packed __aligned(2);
 
+/**
+ * ieee80211_s1g_optional_len - determine length of optional S1G beacon fields
+ * @fc: frame control bytes in little-endian byteorder
+ * Return: total length in bytes of the optional fixed-length fields
+ *
+ * S1G beacons may contain up to three optional fixed-length fields that
+ * precede the variable-length elements. Whether these fields are present
+ * is indicated by flags in the frame control field.
+ *
+ * From IEEE 802.11-2024 section 9.3.4.3:
+ *  - Next TBTT field may be 0 or 3 bytes
+ *  - Short SSID field may be 0 or 4 bytes
+ *  - Access Network Options (ANO) field may be 0 or 1 byte
+ */
+static inline size_t
+ieee80211_s1g_optional_len(__le16 fc)
+{
+	size_t len = 0;
+
+	if (ieee80211_s1g_has_next_tbtt(fc))
+		len += 3;
+
+	if (ieee80211_s1g_has_cssid(fc))
+		len += 4;
+
+	if (ieee80211_s1g_has_ano(fc))
+		len += 1;
+
+	return len;
+}
+
 #define IEEE80211_TWT_CONTROL_NDP			BIT(0)
 #define IEEE80211_TWT_CONTROL_RESP_MODE			BIT(1)
 #define IEEE80211_TWT_CONTROL_NEG_TYPE_BROADCAST	BIT(3)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 35eaf0812c5b2..53d5ffad87be8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7220,11 +7220,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 	bssid = ieee80211_get_bssid(hdr, len, sdata->vif.type);
 	if (ieee80211_is_s1g_beacon(mgmt->frame_control)) {
 		struct ieee80211_ext *ext = (void *) mgmt;
-
-		if (ieee80211_is_s1g_short_beacon(ext->frame_control))
-			variable = ext->u.s1g_short_beacon.variable;
-		else
-			variable = ext->u.s1g_beacon.variable;
+		variable = ext->u.s1g_beacon.variable +
+			   ieee80211_s1g_optional_len(ext->frame_control);
 	}
 
 	baselen = (u8 *) variable - (u8 *) mgmt;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index cb70790718858..5a56487dab69c 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -260,6 +260,7 @@ void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb)
 	struct ieee80211_mgmt *mgmt = (void *)skb->data;
 	struct ieee80211_bss *bss;
 	struct ieee80211_channel *channel;
+	struct ieee80211_ext *ext;
 	size_t min_hdr_len = offsetof(struct ieee80211_mgmt,
 				      u.probe_resp.variable);
 
@@ -269,12 +270,10 @@ void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb)
 		return;
 
 	if (ieee80211_is_s1g_beacon(mgmt->frame_control)) {
-		if (ieee80211_is_s1g_short_beacon(mgmt->frame_control))
-			min_hdr_len = offsetof(struct ieee80211_ext,
-					       u.s1g_short_beacon.variable);
-		else
-			min_hdr_len = offsetof(struct ieee80211_ext,
-					       u.s1g_beacon);
+		ext = (struct ieee80211_ext *)mgmt;
+		min_hdr_len =
+			offsetof(struct ieee80211_ext, u.s1g_beacon.variable) +
+			ieee80211_s1g_optional_len(ext->frame_control);
 	}
 
 	if (skb->len < min_hdr_len)
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index ddd3a97f6609d..e8a4fe44ec2d8 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3250,6 +3250,7 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 	const u8 *ie;
 	size_t ielen;
 	u64 tsf;
+	size_t s1g_optional_len;
 
 	if (WARN_ON(!mgmt))
 		return NULL;
@@ -3264,12 +3265,11 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 
 	if (ieee80211_is_s1g_beacon(mgmt->frame_control)) {
 		ext = (void *) mgmt;
-		if (ieee80211_is_s1g_short_beacon(mgmt->frame_control))
-			min_hdr_len = offsetof(struct ieee80211_ext,
-					       u.s1g_short_beacon.variable);
-		else
-			min_hdr_len = offsetof(struct ieee80211_ext,
-					       u.s1g_beacon.variable);
+		s1g_optional_len =
+			ieee80211_s1g_optional_len(ext->frame_control);
+		min_hdr_len =
+			offsetof(struct ieee80211_ext, u.s1g_beacon.variable) +
+			s1g_optional_len;
 	} else {
 		/* same for beacons */
 		min_hdr_len = offsetof(struct ieee80211_mgmt,
@@ -3285,11 +3285,7 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 		const struct ieee80211_s1g_bcn_compat_ie *compat;
 		const struct element *elem;
 
-		if (ieee80211_is_s1g_short_beacon(mgmt->frame_control))
-			ie = ext->u.s1g_short_beacon.variable;
-		else
-			ie = ext->u.s1g_beacon.variable;
-
+		ie = ext->u.s1g_beacon.variable + s1g_optional_len;
 		elem = cfg80211_find_elem(WLAN_EID_S1G_BCN_COMPAT, ie, ielen);
 		if (!elem)
 			return NULL;
-- 
2.39.5



