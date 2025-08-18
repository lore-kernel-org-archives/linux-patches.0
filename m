Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A743469F4;
	Mon, 18 Aug 2025 13:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525466; cv=none; b=kEKEFjOsWaxiJACOlt4R6tfMcAkDQANzC0HPrsU+/D4vIOZTa0EX/RPAzGWHRPW26ZHQbsErd/rD9DyMT7STYY+p52141I36JU1peQkIao0cqaL8b1fdYRP2uXQnVH/60NZ3sFp42Nj84UQdl40KP24/iLH6LNmyy4l8XhReuHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525466; c=relaxed/simple;
	bh=YO9r5G3U3AO47aiP4qLuE1moU1AESp+gzzoF2RBS5AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/wUdHuZ0nPuu82uzsYurdgRbBdafOBV6IN20n6kib7Z8JvEIiA1OAiwjH/FzllOW0Le9MprmhJDu3qmMpRf//TuTgjqLm2DazqNVBVGp15CLOouhURqX3WmqngpHCMRiRYWm2MO5/LIbktMmuydZokxUC7fV/pl1b/QUsLfRow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0XSWvVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0XSWvVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BB0C4CEEB;
	Mon, 18 Aug 2025 13:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525466;
	bh=YO9r5G3U3AO47aiP4qLuE1moU1AESp+gzzoF2RBS5AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0XSWvVGXPfcHc+TaAQp5y5GH0PeWtwydA6Lve0irbBwr74ej4dxxhFTx8DeNza4m
	 I8ead2sit0pLqEvXqZ9Lw9PxMTHkOsOSitCxNFTpzts84uZZ8/s++PSI9H/5AeM5Ke
	 +lzIi4VfmED/AdrSwduYDz+OEL/QQXC8/9R4ROOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 240/570] wifi: mac80211: dont use TPE data from assoc response
Date: Mon, 18 Aug 2025 14:43:47 +0200
Message-ID: <20250818124515.063583650@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a597432cc9e640439370d9dc95952220cc13fc2b ]

Since there's no TPE element in the (re)assoc response, trying
to use the data from it just leads to using the defaults, even
though the real values had been set during authentication from
the discovered BSS information.

Fix this by simply not handling the TPE data in assoc response
since it's not intended to be present, if it changes later the
necessary changes will be made by tracking beacons later.

As a side effect, by passing the real frame subtype, now print
a correct value for ML reconfiguration responses.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250709233537.caa1ca853f5a.I588271f386731978163aa9d84ae75d6f79633e16@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0ed68182f79b..42bb996157e9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1218,18 +1218,36 @@ EXPORT_SYMBOL_IF_MAC80211_KUNIT(ieee80211_determine_chan_mode);
 
 static int ieee80211_config_bw(struct ieee80211_link_data *link,
 			       struct ieee802_11_elems *elems,
-			       bool update, u64 *changed,
-			       const char *frame)
+			       bool update, u64 *changed, u16 stype)
 {
 	struct ieee80211_channel *channel = link->conf->chanreq.oper.chan;
 	struct ieee80211_sub_if_data *sdata = link->sdata;
 	struct ieee80211_chan_req chanreq = {};
 	struct cfg80211_chan_def ap_chandef;
 	enum ieee80211_conn_mode ap_mode;
+	const char *frame;
 	u32 vht_cap_info = 0;
 	u16 ht_opmode;
 	int ret;
 
+	switch (stype) {
+	case IEEE80211_STYPE_BEACON:
+		frame = "beacon";
+		break;
+	case IEEE80211_STYPE_ASSOC_RESP:
+		frame = "assoc response";
+		break;
+	case IEEE80211_STYPE_REASSOC_RESP:
+		frame = "reassoc response";
+		break;
+	case IEEE80211_STYPE_ACTION:
+		/* the only action frame that gets here */
+		frame = "ML reconf response";
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	/* don't track any bandwidth changes in legacy/S1G modes */
 	if (link->u.mgd.conn.mode == IEEE80211_CONN_MODE_LEGACY ||
 	    link->u.mgd.conn.mode == IEEE80211_CONN_MODE_S1G)
@@ -1278,7 +1296,9 @@ static int ieee80211_config_bw(struct ieee80211_link_data *link,
 			ieee80211_min_bw_limit_from_chandef(&chanreq.oper))
 		ieee80211_chandef_downgrade(&chanreq.oper, NULL);
 
-	if (ap_chandef.chan->band == NL80211_BAND_6GHZ &&
+	/* TPE element is not present in (re)assoc/ML reconfig response */
+	if (stype == IEEE80211_STYPE_BEACON &&
+	    ap_chandef.chan->band == NL80211_BAND_6GHZ &&
 	    link->u.mgd.conn.mode >= IEEE80211_CONN_MODE_HE) {
 		ieee80211_rearrange_tpe(&elems->tpe, &ap_chandef,
 					&chanreq.oper);
@@ -5294,7 +5314,9 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 	/* check/update if AP changed anything in assoc response vs. scan */
 	if (ieee80211_config_bw(link, elems,
 				link_id == assoc_data->assoc_link_id,
-				changed, "assoc response")) {
+				changed,
+				le16_to_cpu(mgmt->frame_control) &
+					IEEE80211_FCTL_STYPE)) {
 		ret = false;
 		goto out;
 	}
@@ -7482,7 +7504,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 
 	changed |= ieee80211_recalc_twt_req(sdata, sband, link, link_sta, elems);
 
-	if (ieee80211_config_bw(link, elems, true, &changed, "beacon")) {
+	if (ieee80211_config_bw(link, elems, true, &changed,
+				IEEE80211_STYPE_BEACON)) {
 		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 				       WLAN_REASON_DEAUTH_LEAVING,
 				       true, deauth_buf);
-- 
2.39.5



