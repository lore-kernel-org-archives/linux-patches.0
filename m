Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C3279FD;
	Thu, 11 Apr 2024 10:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831874; cv=none; b=fdY2/cL4EYwEBN8ywBm3RbUbNQpdT1xcK5QoNqMkAMdpBD4QjOSKRO9t4yh9eFRyURSPVCXO5hrX0TVmDrGzT4x4dGm3jp4MqnjFS58rJorKKT8gGid14313T8sFaVJAgAPBuL7GAqEackXoN9zzF6pICEFkXbyJKxqzuHCapAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831874; c=relaxed/simple;
	bh=vuGxLy44RX1r+w5HsjbnkCn3Hqyo1ptm/QyACC4wNws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+8CB14jK5Fcy3sUD+zGd+PbIhumypKkDsCd7EsCmaovjrGWrzs818xExtobK7LCNajEyPrj1PJnT9EBPMpAinkMZsGmfcWiSr66nODeLx87iBrATlRRCJ0ClPoSp67ntPwtvZPOTdB0N2bfVGjUuY+9j0MjEmVmuUZtogShQb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSKBDWV7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSKBDWV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD063C433F1;
	Thu, 11 Apr 2024 10:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831874;
	bh=vuGxLy44RX1r+w5HsjbnkCn3Hqyo1ptm/QyACC4wNws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSKBDWV7JKC4nM1um13xraVWSrnSl4SzGiqD3r0VD6kVTL5mGB386Ir7pDjUM4Pvu
	 AY/3pdW5K1airprJ176SwxQS81vWeskBYkeu/czhpxI8H9e8TgEcQyWCWYt7i0JnGD
	 qEV0vrEssvdi/bfIjfBtdY6ic1Sjncez7sQZTaek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ranygh@riseup.net,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 156/294] wifi: mac80211: check/clear fast rx for non-4addr sta VLAN changes
Date: Thu, 11 Apr 2024 11:55:19 +0200
Message-ID: <20240411095440.345326657@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1811,15 +1811,14 @@ static int ieee80211_change_station(stru
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


