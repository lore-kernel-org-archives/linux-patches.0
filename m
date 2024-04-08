Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1871B7A15C;
	Mon,  8 Apr 2024 14:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584830; cv=none; b=Z3V4Xu7F0F58gg26e+5BG1OeGRLmE5rybIt8jGFyaIM7cXs0eX/wo07jyBcz14YYUu7nyg9orj+zdGjZ9Cqxqx+bv7EAlB+nRabM3xNkjpd35+Dirxezym23DdTe2EvN9uTx8wsucR8s2+OsdKjJ9flbP61zhJNQZxYywVrWwbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584830; c=relaxed/simple;
	bh=WoDeIiGR8+I9ON1Y2ROoS2d92EXcqGow8woKO01llwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WB7pSq5i+JR/lqkvylQf+y7sjcN6Z4ptXuBawCNfT6FrNcTzUtuz8lZ/nRg7UG1IIqQtXy6qF4Zs/7gTwWtUk6O8RWHWqSY1GRWqLrQcpnT5z5L7aHNyExlMmFwxBEO2MrinAGgHRhUhLinYAUpmqdcf5ubF+l/EaaFxeV/SY68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vqu4g8MY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vqu4g8MY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FA0C433C7;
	Mon,  8 Apr 2024 14:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584830;
	bh=WoDeIiGR8+I9ON1Y2ROoS2d92EXcqGow8woKO01llwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vqu4g8MY5K/jD+Rzxr+4I/D1FllzeE1NzgTVdyb2B3rydV964utmy6L0uRZx1RMyw
	 QJRPLHZ02SDU0X9P7rN6IleqhFjeDGG+Z2Gibd1tc9+PlimelISXLEq32g7TOz8qlq
	 cn+DmSp7yRjQGuYQ1GSYrnZFV1NX/JenFr+sZH9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ranygh@riseup.net,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 571/690] wifi: mac80211: check/clear fast rx for non-4addr sta VLAN changes
Date: Mon,  8 Apr 2024 14:57:17 +0200
Message-ID: <20240408125420.303384648@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1845,15 +1845,14 @@ static int ieee80211_change_station(stru
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


