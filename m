Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEEF145B04;
	Thu, 11 Apr 2024 10:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829800; cv=none; b=ue7sRG6RtD1HqojXr1oT8DGIMKT7tE5eTOnsBz919EOWWQW4Qh8gBjXN4ikukdDjhvGLIqZ7XoeNXkwFfm+z5k7pe/ID3bHdUKLWsbcqnSwyJuPNVQfGO5C0pjhK6wb5GF2ON7jiRV21dXW+WrhsUZoXOPh8y3DJY83C2FmcZ0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829800; c=relaxed/simple;
	bh=Rn+/NoXTvu1E/IItL4NfDu0kNmrhckjzCALVZZ2f7wA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUvPBk0z2l+zzswGluEBSeSymBYCwbEge2YiuFV6qnuEgN4F0EwnFpoKLkt16gYR7XLypC5ErINhD57y/RP7kw/TkhX6fw6eUQdhcar26psx3lHJRhknBYFlvuHdQi7raa7EahkvEycrZMMfYOVgnrbKp/nb1m/7Ywem2tb0Hrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phBAVM/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phBAVM/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9D7C433F1;
	Thu, 11 Apr 2024 10:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829800;
	bh=Rn+/NoXTvu1E/IItL4NfDu0kNmrhckjzCALVZZ2f7wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=phBAVM/8RWWdiGkaD0mQth+gc7y2gWd+3iCtq2FAYgaNhrESj5LrwEKA9t6F1dZn+
	 ZuIwR5WWTz56oSa6SEsZA6ysqhkPuyWTXie5m6rA4XdZHb88AkJjkM6XRI7tcftNHs
	 HQB8cawNlWgjW+XxaYVvQwqWBWAfQUDzbTocNTRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ranygh@riseup.net,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 082/175] wifi: mac80211: check/clear fast rx for non-4addr sta VLAN changes
Date: Thu, 11 Apr 2024 11:55:05 +0200
Message-ID: <20240411095422.031663010@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

commit 4f2bdb3c5e3189297e156b3ff84b140423d64685 upstream.

When moving a station out of a VLAN and deleting the VLAN afterwards, the
fast_rx entry still holds a pointer to the VLAN's netdev, which can cause
use-after-free bugs. Fix this by immediately calling ieee80211_check_fast_rx
after the VLAN change.

Cc: stable@vger.kernel.org
Reported-by: ranygh@riseup.net
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://msgid.link/20240316074336.40442-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1548,15 +1548,14 @@ static int ieee80211_change_station(stru
 		}
 
 		if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
-		    sta->sdata->u.vlan.sta) {
-			ieee80211_clear_fast_rx(sta);
+		    sta->sdata->u.vlan.sta)
 			RCU_INIT_POINTER(sta->sdata->u.vlan.sta, NULL);
-		}
 
 		if (test_sta_flag(sta, WLAN_STA_AUTHORIZED))
 			ieee80211_vif_dec_num_mcast(sta->sdata);
 
 		sta->sdata = vlansdata;
+		ieee80211_check_fast_rx(sta);
 		ieee80211_check_fast_xmit(sta);
 
 		if (test_sta_flag(sta, WLAN_STA_AUTHORIZED)) {


