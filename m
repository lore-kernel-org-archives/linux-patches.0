Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FF627B334;
	Mon, 18 Aug 2025 13:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523729; cv=none; b=pn3Hno07c/0SZJU7Xlx1pyvaPeGvbXYOWDckio7YQcrMlgThamK5Q6RhREfjWmJWbKmA34Bk/aZpamP5TllRnKd1kg9ReF4uPDmT8Dy5VQjZPIrW3ufC0OF1WtDh6zk6CyM7NWynb/xubXOVkqbhNVp2SPFkhwEioVDWJzOVY/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523729; c=relaxed/simple;
	bh=z52ewNhBYZwOW1/AZN5mwoeuTUY+GBqLlZYKBGpSnEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKKVo1Paju2Vc3fj57BXH+OFwQr+SaIs0Jkf52ePmj6wtteScViUq6F7Irh5tBiFg417LnirEIid7gU7y6sfhIZZD2+1HXgf8wP4puOHL1UESKzDfg7u8UssQS3JBT3N+pNxgN0YwjFJg6T5+HvyDpBY8IV2mfw5UK+8tjhJKUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOgrAfEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOgrAfEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A12C4CEEB;
	Mon, 18 Aug 2025 13:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523729;
	bh=z52ewNhBYZwOW1/AZN5mwoeuTUY+GBqLlZYKBGpSnEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BOgrAfEdj+YtR2X8xH+a60Q6pvU2Lzjo/wwDb7znwPaxETPtEu6AXDdZECOlJvW1o
	 tBiKzumFza+V/7hprGIJOnP09fQjLI2EWq/HZfNZKjvZ5PmJn/jIDN6Hd4xRMJwtk/
	 JChqZMqjhjeVd3l8XSgN0ZNfku18XgTb2F56TpPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 224/515] wifi: mac80211: dont use TPE data from assoc response
Date: Mon, 18 Aug 2025 14:43:30 +0200
Message-ID: <20250818124506.995049714@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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
index dc8df3129c00..526b55e28348 100644
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
@@ -5290,7 +5310,9 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
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
@@ -7478,7 +7500,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 
 	changed |= ieee80211_recalc_twt_req(sdata, sband, link, link_sta, elems);
 
-	if (ieee80211_config_bw(link, elems, true, &changed, "beacon")) {
+	if (ieee80211_config_bw(link, elems, true, &changed,
+				IEEE80211_STYPE_BEACON)) {
 		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 				       WLAN_REASON_DEAUTH_LEAVING,
 				       true, deauth_buf);
-- 
2.39.5



