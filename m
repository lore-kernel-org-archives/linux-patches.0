Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F31D3D961;
	Mon,  1 Apr 2024 16:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988978; cv=none; b=qyr31XkzpJCHglIt19dlV1izgRCUoJuLUTwVRXsdzjUshuptnbsC6hg/a32zXjjZH7xCxKgfzW4tSPpOyyb2u0E5Xue2eU0IIXqNSsMf5pM9Z0hJOqLgxQ0le7xW+P2ZIO94WBZm//qJZahGiGwcOJKEZzaOH19nVWVOetGM86k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988978; c=relaxed/simple;
	bh=Ps+lxVMn5n+895Ra2M/y8actCQ/Fv7vZ17VUho0kHlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GI6JbBe4WFIeK6bObKZG1EEiDiQlh7Ufg2T40ADIDg54X8ZM8b7ZPylGzFKU9QocKaj+d6HZfTp/9QtF14hJFNvmzScmL+xitwdiV4Fd77vTgxRj4hvN6L/0d9Oh1zfQVV/htae49zk4JDa0WKA6tABC5Qh4PUoR4HIaMhojflE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZj4Us6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZj4Us6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28E4C433F1;
	Mon,  1 Apr 2024 16:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988978;
	bh=Ps+lxVMn5n+895Ra2M/y8actCQ/Fv7vZ17VUho0kHlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZj4Us6kNgEhmRqKQS0c3wmm0OB/ewQfNiZ95jyFf4VExZRePrdW/MfFi2cDaNjpv
	 1sGefKLY7szzRNHpNrmH5uzFW8g0eqbRW58Mp3j76rb+Dnz1PMsebsuNxqZF5b6+/g
	 +yjH6TomZZQBUyGzZ/8OkhTDSadQa319CJHaB7SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ranygh@riseup.net,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.7 345/432] wifi: mac80211: check/clear fast rx for non-4addr sta VLAN changes
Date: Mon,  1 Apr 2024 17:45:32 +0200
Message-ID: <20240401152603.531412117@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


