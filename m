Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7B3246333;
	Tue, 11 Nov 2025 01:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825457; cv=none; b=hYZOLr7S9R7QgZI3L8tWIQkKunVVAxAizCfZ8V0P8WGzasiPWEyJiRahiWuDMBTCQatGAjeMc0ixmiF5LexadMuN7RiJ7j9LhbfwAr19UQ8CBAdUZytXGgv622V/jlKIq5UE3mYZrmxAzl1Z5NmZJg/v4aeG3WpF4Xu4WSxgLT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825457; c=relaxed/simple;
	bh=gNzWxQ3tcV1uNc/1VK7mPbdA/L4PeaDnGaJeEJKwXv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfWy9k2GwqkaemkNSEpV4MYmrC2xURrXOvPtRRPJwRtjjtaDtu8OAoesXsSuUw3AkuKHmlHkQcBqfg5pcs0tkIpq3MB8ZJ/pIla0lgGiF0ae/s2ygcFrqoB4Nba4YAwlHOSfpPK6wBwLwa20u94UAz6qlary3UtbmRjDUHWnOLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EbgtncLl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbgtncLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C829C4CEF5;
	Tue, 11 Nov 2025 01:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825456;
	bh=gNzWxQ3tcV1uNc/1VK7mPbdA/L4PeaDnGaJeEJKwXv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EbgtncLlRxrt/kZ+TnKgeuTdMEkH4369Wenrn52MTGFfpe35LxWhaLHXv7vmTrjqn
	 FYs3YxKwABvv2R5EquLs6iI+IoqU4gteiG8BGlUYUpCelRJD9xrDWUlzDNPZ1YsOiC
	 35seU6KMsBfQg53KumrH8Z0P/FCNa1jj+MJGZnpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.17 803/849] wifi: mac80211: use wiphy_hrtimer_work for ml_reconf_work
Date: Tue, 11 Nov 2025 09:46:13 +0900
Message-ID: <20251111004555.844851482@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

commit 3f654d53dff565095d83a84e3b6187526dadf4c8 upstream.

The work item may be scheduled relatively far in the future. As the
event happens at a specific point in time, the normal timer accuracy is
not sufficient in that case.

Switch to use wiphy_hrtimer_work so that the accuracy is sufficient.

CC: stable@vger.kernel.org
Fixes: 8eb8dd2ffbbb ("wifi: mac80211: Support link removal using Reconfiguration ML element")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20251028125710.24a7b54e9e37.I063c5c15bf7672f94cea75f83e486a3ca52d098f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/mlme.c        |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -604,7 +604,7 @@ struct ieee80211_if_managed {
 	u8 *assoc_req_ies;
 	size_t assoc_req_ies_len;
 
-	struct wiphy_delayed_work ml_reconf_work;
+	struct wiphy_hrtimer_work ml_reconf_work;
 	u16 removed_links;
 
 	/* TID-to-link mapping support */
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4244,7 +4244,7 @@ static void ieee80211_set_disassoc(struc
 				  &ifmgd->neg_ttlm_timeout_work);
 
 	sdata->u.mgd.removed_links = 0;
-	wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
+	wiphy_hrtimer_work_cancel(sdata->local->hw.wiphy,
 				  &sdata->u.mgd.ml_reconf_work);
 
 	wiphy_work_cancel(sdata->local->hw.wiphy,
@@ -6868,7 +6868,7 @@ static void ieee80211_ml_reconfiguration
 		/* In case the removal was cancelled, abort it */
 		if (sdata->u.mgd.removed_links) {
 			sdata->u.mgd.removed_links = 0;
-			wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
+			wiphy_hrtimer_work_cancel(sdata->local->hw.wiphy,
 						  &sdata->u.mgd.ml_reconf_work);
 		}
 		return;
@@ -6898,9 +6898,9 @@ static void ieee80211_ml_reconfiguration
 	}
 
 	sdata->u.mgd.removed_links = removed_links;
-	wiphy_delayed_work_queue(sdata->local->hw.wiphy,
+	wiphy_hrtimer_work_queue(sdata->local->hw.wiphy,
 				 &sdata->u.mgd.ml_reconf_work,
-				 TU_TO_JIFFIES(delay));
+				 us_to_ktime(ieee80211_tu_to_usec(delay)));
 }
 
 static int ieee80211_ttlm_set_links(struct ieee80211_sub_if_data *sdata,
@@ -8752,7 +8752,7 @@ void ieee80211_sta_setup_sdata(struct ie
 			ieee80211_csa_connection_drop_work);
 	wiphy_delayed_work_init(&ifmgd->tdls_peer_del_work,
 				ieee80211_tdls_peer_del_work);
-	wiphy_delayed_work_init(&ifmgd->ml_reconf_work,
+	wiphy_hrtimer_work_init(&ifmgd->ml_reconf_work,
 				ieee80211_ml_reconf_work);
 	wiphy_delayed_work_init(&ifmgd->reconf.wk,
 				ieee80211_ml_sta_reconf_timeout);


