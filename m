Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07C114601D;
	Thu, 11 Apr 2024 10:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830889; cv=none; b=TXRr1I0j2GRGfoYDrvprBxq0R5J/0I3NoWbEOKnP0uy9J08IBhDsf6q/t3OZO17xUnOLRrgNfFwK1kQe06s8E+0hxJe68iUaM0r39/MyMCkPDoOqkVio1/BEoBoN1t8a9gYBQX9sWX2gaoNy9IfbfyVqbD1QW8KMM5f3HvCAmds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830889; c=relaxed/simple;
	bh=aLGpvptGJGb/woJVy/5JXRHKx2E2JuXTWSaQ+Wmp9k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VI6ZrDX5MhCvUs+pIlVK18Z0ta3R0pj2sssRKEDN9wCj4jtpJKWFzdm8zmLasXVMo6dhgXqwaOd1ox7fQp3kRkG7UL/IOS6i0B4O7v5i2HABnMNvL6GWJyXRKBkpqRP7R+Z/j9++cH3cYMXqdx8E34zSMxHUUqe+QXqyirlZLhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AaJiWfU/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AaJiWfU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FA0C43390;
	Thu, 11 Apr 2024 10:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830888;
	bh=aLGpvptGJGb/woJVy/5JXRHKx2E2JuXTWSaQ+Wmp9k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AaJiWfU/MTSUpDM/SUwF35ArN9xTDvPupuGFbDdu+rEnESnFhDSfQ0HZKcKICAc/l
	 L3wqmXDllMLz2xNOLqZFM32IPKGDuAeXe2E8f/EMOvXlmiIrP0asPqK+DdogXhtSxQ
	 J/w4/KI3PZU6gbUCIOEUV/r+1XTAQJCtb7FCpwgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ranygh@riseup.net,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 113/215] wifi: mac80211: check/clear fast rx for non-4addr sta VLAN changes
Date: Thu, 11 Apr 2024 11:55:22 +0200
Message-ID: <20240411095428.304186854@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1670,15 +1670,14 @@ static int ieee80211_change_station(stru
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


