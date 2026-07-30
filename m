Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C71F2D0602;
	Thu, 30 Jul 2026 16:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427224; cv=none; b=AmHVnvSBUjb35jr4XQH2YKDzeGN2vz/yhL2fK7XStNQzpaQhYpE10umXk+afw2xZR589BVwTrv9jvDxZWkATT5MWJSfeHrp7oVkskYXiYWyyZs5uETl4ZJEj5/Z+y8Dh6FWrY4jWl6RJzAJ1kZBKDeGtx31VwQ49mYp0M6iHdnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427224; c=relaxed/simple;
	bh=KjiU7qd/hZHjaazWYMiNkTekhv0KHK2gOUOWLULxbzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rT2UT5ThEtPRcefWp2uM7LMNltwym/hwBLbuUcfODoe5bg19MuG+dnKY139MtNvR9QAtJuO+yvVbWoJq8AL2oZj1ZKAgYUjJP1KF+7bUQWQH2JjctuxoEWyQlTFIi6vkD7KSiqI9L5O0j4Vt/azHcFmGHS/JK9K2xO0nVnV1UXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5OBUHgg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5OBUHgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054F81F000E9;
	Thu, 30 Jul 2026 16:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427223;
	bh=0uUvN/Uuag6vPk5b7a/YZcw/ZEyWf242utJzTENPQy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z5OBUHggkM1R4gQb+PDMajywhg8z5PqcGCATYbDcbGravKHo60Q02TLLGieKvQimj
	 pXea7D7WZeUcXau+mm6o1xNJO8eyYKEWYBIly/HWYuKA1AvGkIucb5fe1viOVrZiDx
	 9XWWZtA2yXIdylEnjs1jo+Hg+WS3IFYiIQGiaSzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huihui Huang <hhhuang@smu.edu.sg>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 096/484] wifi: at76c50x-usb: avoid length underflow in at76_guess_freq()
Date: Thu, 30 Jul 2026 16:09:53 +0200
Message-ID: <20260730141425.537162170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huihui Huang <hhhuang@smu.edu.sg>

commit 61a799ffd1e5a4fd3702d547828b7ff3d161468e upstream.

at76_guess_freq() checks only that the received frame is at least a bare
802.11 header (24 bytes) before subtracting the fixed management-body
offset:

	len -= el_off;

For both beacon and probe response frames, el_off is 36. If the frame is
shorter than el_off, subtracting it causes the calculated IE length to
wrap. The length is eventually passed to cfg80211_find_elem_match() as a
very large unsigned value, so the element walk runs beyond the RX skb.

This path is reached from at76_rx_tasklet() while scanning. If the device
delivers a truncated beacon or probe response, the oversized IE length
causes an out-of-bounds read during scanning.

Skip the IE lookup if the frame does not reach the variable elements,
before subtracting el_off.

Fixes: 1264b951463a ("at76c50x-usb: add driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Huihui Huang <hhhuang@smu.edu.sg>
Link: https://patch.msgid.link/20260715140815.1242033-1-hhhuang@smu.edu.sg
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/atmel/at76c50x-usb.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -1527,13 +1527,16 @@ static inline int at76_guess_freq(struct
 
 	if (ieee80211_is_probe_resp(hdr->frame_control)) {
 		el_off = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
-		el = ((struct ieee80211_mgmt *)hdr)->u.probe_resp.variable;
 	} else if (ieee80211_is_beacon(hdr->frame_control)) {
 		el_off = offsetof(struct ieee80211_mgmt, u.beacon.variable);
-		el = ((struct ieee80211_mgmt *)hdr)->u.beacon.variable;
 	} else {
 		goto exit;
 	}
+
+	if (len < el_off)
+		goto exit;
+
+	el = priv->rx_skb->data + el_off;
 	len -= el_off;
 
 	el = cfg80211_find_ie(WLAN_EID_DS_PARAMS, el, len);


