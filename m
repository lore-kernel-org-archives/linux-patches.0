Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D1733D6FD;
	Wed, 30 Sep 2026 16:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786164; cv=none; b=NWxSgGwYdZHiZj/RRmKILim8a5g489bZGx7i3e86SQxhhLiCwC3MU/joGLslocLixWVTnVMb2OitFCRwyqrYCYunMK+hKAkibTShFzHuDwEBID6iIHDgXugd4g7S3PkrkYTNHGEdd7Lf6wAFLI4lFOUKI1Runq1RQNu02b7YRP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786164; c=relaxed/simple;
	bh=TebQCw9+Ml0BLIftuHgwcqkTpMfHuLif5MlORX/OETc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVjrR7uR8enW2Mno8JrLIsX+ln5s8PIXFbMmfcMiL4tB/y/n0pSeCw4I3AtJJLyoUZk5z+Ick4yhXYRSQXq7ucXzpcCAFh7/EWZN46ORWGpkKlsBYpFDHwxFqddkIFlOTIXDGK7sUlKqtE+hYIHg3kuiFEcIRgqD32yN1ScjPYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGlW/jUU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGlW/jUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B111F00893;
	Wed, 30 Sep 2026 16:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786163;
	bh=LQv0+RzCduuQFpE6JyT/5nesCuXk60WtX5Oc5FQgnnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lGlW/jUUyv2mV7VU7i06Ps1hZ99H4CqktQzUOMFyZpzKVInIPOQQ3gti8iLXf9puh
	 jTJl24vHuG/bvGSguyB2Rvrs7jl1f7v9tr4RvfU/ux88s+WH1cbWyOhl1HJjhAeAx+
	 fh04TCOvJ2rjsc+TrrtmaU4WFWJqn67+5mMUTicw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 764/982] wifi: wilc1000: fix out-of-bounds read in P2P public action frames
Date: Wed, 30 Sep 2026 17:25:00 +0200
Message-ID: <20260930152433.162832321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Ali Ahmet Memis <ali@iusegentoo.com>

commit ba6cb7c0868a412c2eb68e8efd5aa38bfb258a14 upstream.

wilc_wfi_p2p_rx() and mgmt_tx() start parsing a frame once
ieee80211_is_public_action() returns true. That helper only verifies the
frame is long enough for the action category field, that is
offsetofend(struct ieee80211_mgmt, u.action.category), 25 bytes. Both
functions then read the P2P public action header up to oui_subtype at
offset 30 and pass "size - ie_offset" to cfg80211_find_vendor_ie(), where
ie_offset is offsetof(struct ieee80211_mgmt, u) + sizeof(*d), i.e. 32.

A public action frame of 25 to 31 bytes passes the check but is shorter
than that 32 byte header, so oui_subtype can be read out of bounds, and
because the length is unsigned, "size - ie_offset" underflows to a value
close to 4 GiB. cfg80211_find_vendor_ie() takes an unsigned int length,
so even the size_t subtraction in mgmt_tx() is truncated to the same
value. It then walks far past the buffer searching for a vendor element
until it reaches unmapped memory.

In the receive path the frame arrives over the air and needs no
association, so a nearby unauthenticated device can crash the host while
it is in P2P listen. Reject frames shorter than the P2P public action
header in both paths before dereferencing it.

Fixes: 4fb8b5aa2a11 ("staging: wilc1000: refactor p2p action frames handling API's")
Cc: stable@vger.kernel.org
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Link: https://patch.msgid.link/20260807115230.136767-1-ali@iusegentoo.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -1069,6 +1069,13 @@ void wilc_wfi_p2p_rx(struct wilc_vif *vi
 	if (!ieee80211_is_public_action((struct ieee80211_hdr *)buff, size))
 		goto out_rx_mgmt;
 
+	/* ieee80211_is_public_action() only validates up to the category
+	 * byte, so reject frames too short for the P2P public action header
+	 * before dereferencing it or computing size - ie_offset.
+	 */
+	if (size < ie_offset)
+		goto out_rx_mgmt;
+
 	d = (struct wilc_p2p_pub_act_frame *)(&mgmt->u.action);
 	if (d->oui_subtype != GO_NEG_REQ && d->oui_subtype != GO_NEG_RSP &&
 	    d->oui_subtype != P2P_INV_REQ && d->oui_subtype != P2P_INV_RSP)
@@ -1219,6 +1226,13 @@ static int mgmt_tx(struct wiphy *wiphy,
 		goto out_set_timeout;
 	}
 
+	/* ieee80211_is_public_action() only validates up to the category
+	 * byte, so reject frames too short for the P2P public action header
+	 * before dereferencing it or computing len - ie_offset.
+	 */
+	if (len < ie_offset)
+		goto out_set_timeout;
+
 	d = (struct wilc_p2p_pub_act_frame *)(&mgmt->u.action);
 	if (d->oui_type != WLAN_OUI_TYPE_WFA_P2P ||
 	    d->oui_subtype != GO_NEG_CONF) {


