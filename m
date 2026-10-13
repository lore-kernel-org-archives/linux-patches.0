Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF93E3AE18C;
	Tue, 13 Oct 2026 12:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893581; cv=none; b=JDda73vBp0IxJLhTGWxz7BS5wER/DA1z0F/i09s1bgMyhmoCoYY1LzcQonQoRpRdWk+067H+NH3lMiGiQJqYwUSbtVyp3d+vpReocvFhMlZIhi92F9+14KqbvuP+9bSW2MYK2hHKfSfnZuNmXr6H983AAjh4eokyNFKLhmE3VOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893581; c=relaxed/simple;
	bh=qRJyYlRgi+mQL1aWJ7V8mNNtTLkiLe8uzMCetG37mqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPEFuu9Ho1Z+fDdYyy4Y4Iki+PjAcPgswoC8lvmny13T4GffwtbYuspDjgw2MF3b92MOPvk1HAQov198vlwhru3kqV08FZFcsJvrlYdOb2ipqpHuZ48C3rHM64MaHgWPWLhmR0sF5iLNBgfOlDdsNanWW6IY8/CLztpp2w2bjpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AneYxMdm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AneYxMdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478701F000FF;
	Tue, 13 Oct 2026 12:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893579;
	bh=AEqhG5ZMKMXLHYGhSf4cPhFrOQFh4PId7vPzotfwnSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AneYxMdmEvnBV8pf5kKqMi5qyjUA1EkEAkaFOzqrzDuP6iYwctuOu9QWqb5lz/+Gf
	 zepH64DAWpaBLK8klRnOVZmyTqXrUaj+6XwZKD2ywyyJ3q4TFSRdMdfa4647Afva5F
	 JqgYae+1amJNhtUZebMT3dU0SpLwzmyyQTcuSjJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 273/621] wifi: mac80211: validate extension-frame layout before RX
Date: Tue, 13 Oct 2026 13:34:28 +0200
Message-ID: <20261013112927.339486564@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 57d503ce32eccfa7650065ca4c560f7e29a2e676 ]

Extension frames only have the extension header at the regular 802.11
header offset. The generic RX path can still reach helpers and interface
dispatch code that read regular header address fields before unsupported
extension subtypes are dropped.

mac80211 currently only handles S1G beacon extension frames. Drop other
extension subtypes before they can reach regular-header RX processing.
For S1G beacons, linearize the SKB with the management-frame path and
require the fixed S1G beacon header, including optional fixed fields
indicated by frame control, before generic RX dispatch.

Route S1G beacons through the station/default-link RX path without
regular-header station lookup. Avoid regular-header address reads in the
mac80211 RX paths that process S1G extension beacons, including
accept-frame, duplicate-detection, address-copy, and MLO
address-translation paths.

Also make ieee80211_get_bssid() length-safe before returning the S1G
source-address pointer.

Fixes: 09a740ce352e ("mac80211: receive and process S1G beacons")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260611161943.91069-5-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c   | 34 ++++++++++++++++++++++++++++++++--
 net/mac80211/util.c |  3 +++
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f61ff900f863a..3567544c34044 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1443,6 +1443,9 @@ ieee80211_rx_h_check_dup(struct ieee80211_rx_data *rx)
 	if (status->flag & RX_FLAG_DUP_VALIDATED)
 		return RX_CONTINUE;
 
+	if (ieee80211_is_ext(hdr->frame_control))
+		return RX_CONTINUE;
+
 	/*
 	 * Drop duplicate 802.11 retransmissions
 	 * (IEEE 802.11-2012: 9.3.2.10 "Duplicate detection and recovery")
@@ -4387,8 +4390,12 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	u8 *bssid = ieee80211_get_bssid(hdr, skb->len, sdata->vif.type);
-	bool multicast = is_multicast_ether_addr(hdr->addr1) ||
-			 ieee80211_is_s1g_beacon(hdr->frame_control);
+	bool multicast;
+
+	if (ieee80211_is_s1g_beacon(hdr->frame_control))
+		return sdata->vif.type == NL80211_IFTYPE_STATION && bssid;
+
+	multicast = is_multicast_ether_addr(hdr->addr1);
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_STATION:
@@ -5037,6 +5044,11 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 		hdr = (struct ieee80211_hdr *)rx->skb->data;
 	}
 
+	if (ieee80211_is_s1g_beacon(hdr->frame_control)) {
+		ieee80211_invoke_rx_handlers(rx);
+		return true;
+	}
+
 	if (unlikely(rx->sta && rx->sta->sta.mlo) &&
 	    is_unicast_ether_addr(hdr->addr1) &&
 	    !ieee80211_is_probe_resp(hdr->frame_control) &&
@@ -5121,6 +5133,13 @@ static bool ieee80211_rx_for_interface(struct ieee80211_rx_data *rx,
 	struct sta_info *sta;
 	int link_id = -1;
 
+	if (ieee80211_is_s1g_beacon(hdr->frame_control)) {
+		if (!ieee80211_rx_data_set_sta(rx, NULL, -1))
+			return false;
+
+		return ieee80211_prepare_and_rx_handle(rx, skb, consume);
+	}
+
 	/*
 	 * Look up link station first, in case there's a
 	 * chance that they might have a link address that
@@ -5196,6 +5215,17 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 			err = -ENOBUFS;
 		else
 			err = skb_linearize(skb);
+	} else if (ieee80211_is_s1g_beacon(fc)) {
+		size_t s1g_hdr_len = offsetof(struct ieee80211_ext,
+					      u.s1g_beacon.variable) +
+				     ieee80211_s1g_optional_len(fc);
+
+		if (skb->len < s1g_hdr_len)
+			err = -ENOBUFS;
+		else
+			err = skb_linearize(skb);
+	} else if (ieee80211_is_ext(fc)) {
+		err = -EINVAL;
 	} else {
 		err = !pskb_may_pull(skb, ieee80211_hdrlen(fc));
 	}
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3ed47a8ebf5cc..1b5a0ca31167f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -73,6 +73,9 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 	if (ieee80211_is_s1g_beacon(fc)) {
 		struct ieee80211_ext *ext = (void *) hdr;
 
+		if (len < offsetofend(struct ieee80211_ext, u.s1g_beacon.sa))
+			return NULL;
+
 		return ext->u.s1g_beacon.sa;
 	}
 
-- 
2.53.0



