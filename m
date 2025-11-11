Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70E530B50B;
	Tue, 11 Nov 2025 01:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825508; cv=none; b=Je2DP7+vee/NKoHXCwKKJvCGiORwnubb8gvbI51NfxEM0Q6aVtKrI077ORhxJ8PYMWgoRK0IBqAuU9cxk8jq9Panh5ByROT7uGvRJoNPd/cel7r3WFQiCsd/n3S3Rr3T+4utiLSL4XhI+KqLaICtI7LskcYT1fMz0OUAEQg1BfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825508; c=relaxed/simple;
	bh=GHXHDlkf1bcIMzWPPfogT1JhKHN3jrbF0c9aiPwirLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UruGBd0E8IHyF98Deg9BKrswLXFuawUuB4NcQcmBm103cIuN/vagO1aogUY5+KceBRTVnIo/7n56RV5zkxyUlyVc2NfSu5mnPZC15FpQ/t5Y85ML9M+F+o78lbFKIYeZrTtO5FH0qU4/7KyVUUZgcWrmzBe0GJYIBgGKorIH49c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TChb4YLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TChb4YLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15843C4CEFB;
	Tue, 11 Nov 2025 01:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825508;
	bh=GHXHDlkf1bcIMzWPPfogT1JhKHN3jrbF0c9aiPwirLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TChb4YLmSlO+MdmmjhQKAJHgcKVmmer0gE0NntQUzdC5wrWWla3x+6/Nqdt9/3E2+
	 0E/TzuZnv6TFqfXq84gfwbmIrJhxuQllOvK5caS9jxaSsZoRfsnXs1q3EnwRZIpb70
	 Rt0xdcIuNQrwiRg1YAIexCAG+Cqtjj1PjhGnRk54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.17 805/849] wifi: mac80211: use wiphy_hrtimer_work for ttlm_work
Date: Tue, 11 Nov 2025 09:46:15 +0900
Message-ID: <20251111004555.891586665@linuxfoundation.org>
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

commit dfa865d490b1bd252045463588a91a4d3c82f3c8 upstream.

The work item may be scheduled relatively far in the future. As the
event happens at a specific point in time, the normal timer accuracy is
not sufficient in that case.

Switch to use wiphy_hrtimer_work so that the accuracy is sufficient.

CC: stable@vger.kernel.org
Fixes: 702e80470a33 ("wifi: mac80211: support handling of advertised TID-to-link mapping")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20251028125710.83c2c611545e.I35498a6d883ea24b0dc4910cf521aa768d2a0e90@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/mlme.c        |   24 ++++++++++++------------
 2 files changed, 13 insertions(+), 13 deletions(-)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -608,7 +608,7 @@ struct ieee80211_if_managed {
 	u16 removed_links;
 
 	/* TID-to-link mapping support */
-	struct wiphy_delayed_work ttlm_work;
+	struct wiphy_hrtimer_work ttlm_work;
 	struct ieee80211_adv_ttlm_info ttlm_info;
 	struct wiphy_work teardown_ttlm_work;
 
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -45,7 +45,7 @@
 #define IEEE80211_ASSOC_TIMEOUT_SHORT	(HZ / 10)
 #define IEEE80211_ASSOC_MAX_TRIES	3
 
-#define IEEE80211_ADV_TTLM_SAFETY_BUFFER_MS msecs_to_jiffies(100)
+#define IEEE80211_ADV_TTLM_SAFETY_BUFFER_MS (100 * USEC_PER_MSEC)
 #define IEEE80211_ADV_TTLM_ST_UNDERFLOW 0xff00
 
 #define IEEE80211_NEG_TTLM_REQ_TIMEOUT (HZ / 5)
@@ -4237,7 +4237,7 @@ static void ieee80211_set_disassoc(struc
 
 	memset(&sdata->u.mgd.ttlm_info, 0,
 	       sizeof(sdata->u.mgd.ttlm_info));
-	wiphy_delayed_work_cancel(sdata->local->hw.wiphy, &ifmgd->ttlm_work);
+	wiphy_hrtimer_work_cancel(sdata->local->hw.wiphy, &ifmgd->ttlm_work);
 
 	memset(&sdata->vif.neg_ttlm, 0, sizeof(sdata->vif.neg_ttlm));
 	wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
@@ -7087,7 +7087,7 @@ static void ieee80211_process_adv_ttlm(s
 			/* if a planned TID-to-link mapping was cancelled -
 			 * abort it
 			 */
-			wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
+			wiphy_hrtimer_work_cancel(sdata->local->hw.wiphy,
 						  &sdata->u.mgd.ttlm_work);
 		} else if (sdata->u.mgd.ttlm_info.active) {
 			/* if no TID-to-link element, set to default mapping in
@@ -7122,7 +7122,7 @@ static void ieee80211_process_adv_ttlm(s
 
 		if (ttlm_info.switch_time) {
 			u16 beacon_ts_tu, st_tu, delay;
-			u32 delay_jiffies;
+			u64 delay_usec;
 			u64 mask;
 
 			/* The t2l map switch time is indicated with a partial
@@ -7144,23 +7144,23 @@ static void ieee80211_process_adv_ttlm(s
 			if (delay > IEEE80211_ADV_TTLM_ST_UNDERFLOW)
 				return;
 
-			delay_jiffies = TU_TO_JIFFIES(delay);
+			delay_usec = ieee80211_tu_to_usec(delay);
 
 			/* Link switching can take time, so schedule it
 			 * 100ms before to be ready on time
 			 */
-			if (delay_jiffies > IEEE80211_ADV_TTLM_SAFETY_BUFFER_MS)
-				delay_jiffies -=
+			if (delay_usec > IEEE80211_ADV_TTLM_SAFETY_BUFFER_MS)
+				delay_usec -=
 					IEEE80211_ADV_TTLM_SAFETY_BUFFER_MS;
 			else
-				delay_jiffies = 0;
+				delay_usec = 0;
 
 			sdata->u.mgd.ttlm_info = ttlm_info;
-			wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
+			wiphy_hrtimer_work_cancel(sdata->local->hw.wiphy,
 						  &sdata->u.mgd.ttlm_work);
-			wiphy_delayed_work_queue(sdata->local->hw.wiphy,
+			wiphy_hrtimer_work_queue(sdata->local->hw.wiphy,
 						 &sdata->u.mgd.ttlm_work,
-						 delay_jiffies);
+						 us_to_ktime(delay_usec));
 			return;
 		}
 	}
@@ -8761,7 +8761,7 @@ void ieee80211_sta_setup_sdata(struct ie
 	timer_setup(&ifmgd->conn_mon_timer, ieee80211_sta_conn_mon_timer, 0);
 	wiphy_delayed_work_init(&ifmgd->tx_tspec_wk,
 				ieee80211_sta_handle_tspec_ac_params_wk);
-	wiphy_delayed_work_init(&ifmgd->ttlm_work,
+	wiphy_hrtimer_work_init(&ifmgd->ttlm_work,
 				ieee80211_tid_to_link_map_work);
 	wiphy_delayed_work_init(&ifmgd->neg_ttlm_timeout_work,
 				ieee80211_neg_ttlm_timeout_work);


