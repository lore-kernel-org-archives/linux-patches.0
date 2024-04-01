Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1469383BA;
	Mon,  1 Apr 2024 16:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987576; cv=none; b=D0f4EiPkOY20ICJQDlsJESC/LWV2hXc3Hecr3bkogUdNXjX9Xfy+MqqLO6IfL2q+kZzOOtpWrDp+NzpEmSfExdwmsN9F2Ttyp9yNwWBPNrQ+74xokzcKvR9i+Bvf+H2ZHjQaBR+C/qQ/CvJ75Rl+62Jh7hGKBEGJgm8XNhn3tLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987576; c=relaxed/simple;
	bh=ABYdlW2rEBpZFugLjYzcTf0Ep6/CPmSHoBFbjQS8ntI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhDf9wZzMIg9E9EErNxeqFQi+IBptz31rpLJJ9A/G11BjMzKuFBiQsAawuOMFBaHcgL9DGoXD2qcqKH5F7lvG9lQ5Z7CkjCiNMqX7y382OrPKsxh254MMONq7Rm4dF7lUB4oic6fo4iF3L9lDPV8uXWsptvm2lPx4xEB56tX6o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSF1UFTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSF1UFTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E120C433F1;
	Mon,  1 Apr 2024 16:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987576;
	bh=ABYdlW2rEBpZFugLjYzcTf0Ep6/CPmSHoBFbjQS8ntI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PSF1UFToKBjdz9H7TZVJNifdZJv0OBRH8DA5hel1q7UEzSIgeYjJk8DAK9zox8Szb
	 JijG4ER24t+V45CzxHWIYveJZlzczg25skPuKSrrBpsW4GyGUcCqGPCywUAM/+L5+B
	 G+mx4VuEVYnYrqdVNuov/zVvigGh7eallbZ1rWi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ranygh@riseup.net,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.8 299/399] wifi: mac80211: check/clear fast rx for non-4addr sta VLAN changes
Date: Mon,  1 Apr 2024 17:44:25 +0200
Message-ID: <20240401152558.120026480@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2164,15 +2164,14 @@ static int ieee80211_change_station(stru
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


