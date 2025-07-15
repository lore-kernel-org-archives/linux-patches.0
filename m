Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603132E5421;
	Tue, 15 Jul 2025 13:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587010; cv=none; b=plLfZhPE7xHELzW28y2nzl4LAjswmykw0GxfDyMf3qM1Wy4FpwKe/5ozlyj7wlEb89OlUkT9ce4nSbAA3rWvhklGTSmBF0QUr0e8xJUbn6ZhUE/Mf9W8/SEpA/H571eEqq5v4hlbL7Tum4roOTHWbecrE3xSWRZ+ltUO2A0tqYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587010; c=relaxed/simple;
	bh=sXmazfYvaXLrkuls3EL6I0b8NijK37six/FWdVTxQA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgCxMvWkpemTxuGI8wpcT3gjZo3tIfIZW/yu+b7Vb64PoMPLBETX3GSfhLGEOj+YEUXPqJoeUI8issV6rHrTxGRuW5eZa8XO3j/JEvQ2HFQIKwNpeQcA26DshcfZr6WR2IJhjmBTGhWZPu1FzOO/Mo7dCe6O4CdxBshS2wGEjHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpPFWcfj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpPFWcfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A5EC4CEF1;
	Tue, 15 Jul 2025 13:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587010;
	bh=sXmazfYvaXLrkuls3EL6I0b8NijK37six/FWdVTxQA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpPFWcfja5dLCmhYXUF9oU56MWezCXOWUvueqASglTOjRl+sCts/G8iO4vSfyMkME
	 zTxRMVZUz6EZdJZoDdtItNZZ/PRnTrbvie6vihsjNSlfM+qGBuEWjX+FuTZ0Of8+fj
	 klvUwz/3GAmpFeelz1N1xfU2RkBrlDj8yRAwjwPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Wadsworth <simon@morsemicro.com>,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 133/192] wifi: mac80211: correctly identify S1G short beacon
Date: Tue, 15 Jul 2025 15:13:48 +0200
Message-ID: <20250715130820.238640053@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

[ Upstream commit c5fd399a24c8e2865524361f7dc4d4a6899be4f4 ]

mac80211 identifies a short beacon by the presence of the next
TBTT field, however the standard actually doesn't explicitly state that
the next TBTT can't be in a long beacon or even that it is required in
a short beacon - and as a result this validation does not work for all
vendor implementations.

The standard explicitly states that an S1G long beacon shall contain
the S1G beacon compatibility element as the first element in a beacon
transmitted at a TBTT that is not a TSBTT (Target Short Beacon
Transmission Time) as per IEEE80211-2024 11.1.3.10.1. This is validated
by 9.3.4.3 Table 9-76 which states that the S1G beacon compatibility
element is only allowed in the full set and is not allowed in the
minimum set of elements permitted for use within short beacons.

Correctly identify short beacons by the lack of an S1G beacon
compatibility element as the first element in an S1G beacon frame.

Fixes: 9eaffe5078ca ("cfg80211: convert S1G beacon to scan results")
Signed-off-by: Simon Wadsworth <simon@morsemicro.com>
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Link: https://patch.msgid.link/20250701075541.162619-1-lachlan.hodges@morsemicro.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ieee80211.h | 45 ++++++++++++++++++++++++++++-----------
 net/mac80211/mlme.c       |  7 ++++--
 2 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 7edc3fb0641cb..f16a073928e9f 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -662,18 +662,6 @@ static inline bool ieee80211_s1g_has_cssid(__le16 fc)
 		(fc & cpu_to_le16(IEEE80211_S1G_BCN_CSSID));
 }
 
-/**
- * ieee80211_is_s1g_short_beacon - check if frame is an S1G short beacon
- * @fc: frame control bytes in little-endian byteorder
- * Return: whether or not the frame is an S1G short beacon,
- *	i.e. it is an S1G beacon with 'next TBTT' flag set
- */
-static inline bool ieee80211_is_s1g_short_beacon(__le16 fc)
-{
-	return ieee80211_is_s1g_beacon(fc) &&
-		(fc & cpu_to_le16(IEEE80211_S1G_BCN_NEXT_TBTT));
-}
-
 /**
  * ieee80211_is_atim - check if IEEE80211_FTYPE_MGMT && IEEE80211_STYPE_ATIM
  * @fc: frame control bytes in little-endian byteorder
@@ -4897,6 +4885,39 @@ static inline bool ieee80211_is_ftm(struct sk_buff *skb)
 	return false;
 }
 
+/**
+ * ieee80211_is_s1g_short_beacon - check if frame is an S1G short beacon
+ * @fc: frame control bytes in little-endian byteorder
+ * @variable: pointer to the beacon frame elements
+ * @variable_len: length of the frame elements
+ * Return: whether or not the frame is an S1G short beacon. As per
+ *	IEEE80211-2024 11.1.3.10.1, The S1G beacon compatibility element shall
+ *	always be present as the first element in beacon frames generated at a
+ *	TBTT (Target Beacon Transmission Time), so any frame not containing
+ *	this element must have been generated at a TSBTT (Target Short Beacon
+ *	Transmission Time) that is not a TBTT. Additionally, short beacons are
+ *	prohibited from containing the S1G beacon compatibility element as per
+ *	IEEE80211-2024 9.3.4.3 Table 9-76, so if we have an S1G beacon with
+ *	either no elements or the first element is not the beacon compatibility
+ *	element, we have a short beacon.
+ */
+static inline bool ieee80211_is_s1g_short_beacon(__le16 fc, const u8 *variable,
+						 size_t variable_len)
+{
+	if (!ieee80211_is_s1g_beacon(fc))
+		return false;
+
+	/*
+	 * If the frame does not contain at least 1 element (this is perfectly
+	 * valid in a short beacon) and is an S1G beacon, we have a short
+	 * beacon.
+	 */
+	if (variable_len < 2)
+		return true;
+
+	return variable[0] != WLAN_EID_S1G_BCN_COMPAT;
+}
+
 struct element {
 	u8 id;
 	u8 datalen;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 53d5ffad87be8..dc8df3129c007 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7194,6 +7194,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 	struct ieee80211_bss_conf *bss_conf = link->conf;
 	struct ieee80211_vif_cfg *vif_cfg = &sdata->vif.cfg;
 	struct ieee80211_mgmt *mgmt = (void *) hdr;
+	struct ieee80211_ext *ext = NULL;
 	size_t baselen;
 	struct ieee802_11_elems *elems;
 	struct ieee80211_local *local = sdata->local;
@@ -7219,7 +7220,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 	/* Process beacon from the current BSS */
 	bssid = ieee80211_get_bssid(hdr, len, sdata->vif.type);
 	if (ieee80211_is_s1g_beacon(mgmt->frame_control)) {
-		struct ieee80211_ext *ext = (void *) mgmt;
+		ext = (void *)mgmt;
 		variable = ext->u.s1g_beacon.variable +
 			   ieee80211_s1g_optional_len(ext->frame_control);
 	}
@@ -7406,7 +7407,9 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 	}
 
 	if ((ncrc == link->u.mgd.beacon_crc && link->u.mgd.beacon_crc_valid) ||
-	    ieee80211_is_s1g_short_beacon(mgmt->frame_control))
+	    (ext && ieee80211_is_s1g_short_beacon(ext->frame_control,
+						  parse_params.start,
+						  parse_params.len)))
 		goto free;
 	link->u.mgd.beacon_crc = ncrc;
 	link->u.mgd.beacon_crc_valid = true;
-- 
2.39.5



