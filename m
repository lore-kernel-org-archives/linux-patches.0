Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BBD495F0;
	Mon,  1 Apr 2024 17:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991367; cv=none; b=O2sI0LxgbxOE0u5utoxNS6sNBiIfKMQv6W0w4NP0W0ygv8BQZWqYgvOhu7icj+JbwEYf1qDOggoPCoKAsBZn8K2L2npb3TIx0UZUYNaZbkQoGdN3EWpg2R8xYIguewRmum5la57lcLUpnPOFL1yIk1VRyDK2aDyzor8w2aVI0Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991367; c=relaxed/simple;
	bh=2VVGgtAegL5qrdrobAE93z3/bnXJulR6uM7ND425zcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Quc4RJn354hpiAZYgP03lCVGCdVwKD6hk59WEzTVYHfbZTDIUiqVhEopBZQtqaUsiSICcWlzKGAk3GDInFn8iY1KI+2X2IXDPz3mAxrigj8puyg4w5PNKcJbocjYiW5u+wDxoLx2Wku+bwhB+8WpN5vKHKS/D0J8h3LA1EWosGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHKQvEQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHKQvEQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17658C433F1;
	Mon,  1 Apr 2024 17:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991367;
	bh=2VVGgtAegL5qrdrobAE93z3/bnXJulR6uM7ND425zcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHKQvEQ3O6fAktT9v1Z4duikc16DhDA+8F47hyYwsI+hCTeCB1YpfoY59DwLmUw6o
	 e8OBMU83MWVw3fwa1uWHDGwGMRcleyb07UF+3xQffxK8ym77dKT+bPtuagEEd+VIv/
	 VMAfr/2oKq45txXpoB9QaSpivjCcg0oZITbcxlw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ranygh@riseup.net,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 215/272] wifi: mac80211: check/clear fast rx for non-4addr sta VLAN changes
Date: Mon,  1 Apr 2024 17:46:45 +0200
Message-ID: <20240401152537.644698985@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2075,15 +2075,14 @@ static int ieee80211_change_station(stru
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


