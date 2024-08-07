Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAFF85931;
	Wed,  7 Aug 2024 15:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043194; cv=none; b=cDyxApYz6WYPshjm0TMdvOu/St15RCg1C4nOmLM0Z9aUXiyFvR7XyaXJhsxa+rOliblGNIJJZQT1+TgCoqc2EzvN+Mh4Qmf6boYiVLKzjjUq67Mhj7jQERTYU5UpQe1H4WkjrMDpEOIBE4uOfYIFxCclqK5SxxM5BdqDtudp1IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043194; c=relaxed/simple;
	bh=xfGiIh5yXGlfZj3NveTfse8Yf1l3TLUPXy1lpOPENss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRjd+Hy2vUfc7tMg6c729Ti7R+tzh9plk/J7irVPXP4oYeFysIXGFKriOKqnaL0nNgwnVJhXwQ+0/DCqonKYc62H98puw1q6Y9b8E6NjFx67IRq6xmbayE3BHadDX7yKiSPOr0HzPWNBRsJS6QZnzUd8EJu/Yw/CILwpwQa5hoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wK19UdmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wK19UdmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E285C32781;
	Wed,  7 Aug 2024 15:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043194;
	bh=xfGiIh5yXGlfZj3NveTfse8Yf1l3TLUPXy1lpOPENss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wK19UdmJZ28WccdMFaySHsJgO95R43GmQaC8zxH09VRhlM9cxwLctQ/mABqdmzE9w
	 R1WgHC2samV4hb17fBwH3rjDSBrY/OVsDmMdkN8O78sNDOakeE9bAtKrntR2qhpQVb
	 p7vLZksUDBqepGCog/4Z9LAjtCGmdoWvYPBDTp4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZeroBeat <ZeroBeat@gmx.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.10 106/123] wifi: mac80211: use monitor sdata with driver only if desired
Date: Wed,  7 Aug 2024 17:00:25 +0200
Message-ID: <20240807150024.282683738@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 8f4fa0876231c426f880a2bff25ac49fac67d805 upstream.

In commit 0d9c2beed116 ("wifi: mac80211: fix monitor channel
with chanctx emulation") I changed mac80211 to always have an
internal monitor_sdata to have something to have the chanctx
bound to.

However, if the driver didn't also have the WANT_MONITOR flag
this would cause mac80211 to allocate it without telling the
driver (which was intentional) but also use it for later APIs
to the driver without it ever having known about it which was
_not_ intentional.

Check through the code and only use the monitor_sdata in the
relevant places (TX, MU-MIMO follow settings, TX power, and
interface iteration) when the WANT_MONITOR flag is set.

Cc: stable@vger.kernel.org
Fixes: 0d9c2beed116 ("wifi: mac80211: fix monitor channel with chanctx emulation")
Reported-by: ZeroBeat <ZeroBeat@gmx.de>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219086
Tested-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20240725184836.25d334157a8e.I02574086da2c5cf0e18264ce5807db6f14ffd9c0@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c  |    7 +++++--
 net/mac80211/tx.c   |    5 +++--
 net/mac80211/util.c |    2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -114,7 +114,7 @@ static int ieee80211_set_mon_options(str
 
 	/* apply all changes now - no failures allowed */
 
-	if (monitor_sdata)
+	if (monitor_sdata && ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF))
 		ieee80211_set_mu_mimo_follow(monitor_sdata, params);
 
 	if (params->flags) {
@@ -3038,6 +3038,9 @@ static int ieee80211_set_tx_power(struct
 		sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 
 		if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
+			if (!ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF))
+				return -EOPNOTSUPP;
+
 			sdata = wiphy_dereference(local->hw.wiphy,
 						  local->monitor_sdata);
 			if (!sdata)
@@ -3100,7 +3103,7 @@ static int ieee80211_set_tx_power(struct
 	if (has_monitor) {
 		sdata = wiphy_dereference(local->hw.wiphy,
 					  local->monitor_sdata);
-		if (sdata) {
+		if (sdata && ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF)) {
 			sdata->deflink.user_power_level = local->user_power_level;
 			if (txp_type != sdata->vif.bss_conf.txpower_type)
 				update_txp_type = true;
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1768,7 +1768,7 @@ static bool __ieee80211_tx(struct ieee80
 			break;
 		}
 		sdata = rcu_dereference(local->monitor_sdata);
-		if (sdata) {
+		if (sdata && ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF)) {
 			vif = &sdata->vif;
 			info->hw_queue =
 				vif->hw_queue[skb_get_queue_mapping(skb)];
@@ -3957,7 +3957,8 @@ begin:
 			break;
 		}
 		tx.sdata = rcu_dereference(local->monitor_sdata);
-		if (tx.sdata) {
+		if (tx.sdata &&
+		    ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF)) {
 			vif = &tx.sdata->vif;
 			info->hw_queue =
 				vif->hw_queue[skb_get_queue_mapping(skb)];
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -776,7 +776,7 @@ static void __iterate_interfaces(struct
 	sdata = rcu_dereference_check(local->monitor_sdata,
 				      lockdep_is_held(&local->iflist_mtx) ||
 				      lockdep_is_held(&local->hw.wiphy->mtx));
-	if (sdata &&
+	if (sdata && ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF) &&
 	    (iter_flags & IEEE80211_IFACE_ITER_RESUME_ALL || !active_only ||
 	     sdata->flags & IEEE80211_SDATA_IN_DRIVER))
 		iterator(data, sdata->vif.addr, &sdata->vif);


