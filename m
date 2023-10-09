Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422DF19448
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wqr/z66i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF699C433D9;
	Mon,  9 Oct 2023 13:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856996;
	bh=KHSa7mPNjCDo/PA/B9vyot0n3aDpRpu7kxqm0NLS5Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wqr/z66iw6hLtiNnm7m85/8sCnNADosax/wK8/epjTowlWzD3G68A2H90Eyvu0BMt
	 FY3PVqXICZdsksg26ZFG9QP0EmZZLlsebecNdBQncpg0ZskCLmcf4dGDNOOh0z1ca/
	 VpwRN1Kiei4eueZmF1wIn16DMlHYAqP03atlYb4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Gong <quic_wgong@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 060/163] wifi: cfg80211/mac80211: hold link BSSes when assoc fails for MLO connection
Date: Mon,  9 Oct 2023 15:00:24 +0200
Message-ID: <20231009130125.691845538@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wen Gong <quic_wgong@quicinc.com>

[ Upstream commit 234249d88b091d006b82f8d570343aae5f383736 ]

When connect to MLO AP with more than one link, and the assoc response of
AP is not success, then cfg80211_unhold_bss() is not called for all the
links' cfg80211_bss except the primary link which means the link used by
the latest successful association request. Thus the hold value of the
cfg80211_bss is not reset to 0 after the assoc fail, and then the
__cfg80211_unlink_bss() will not be called for the cfg80211_bss by
__cfg80211_bss_expire().

Then the AP always looks exist even the AP is shutdown or reconfigured
to another type, then it will lead error while connecting it again.

The detail info are as below.

When connect with muti-links AP, cfg80211_hold_bss() is called by
cfg80211_mlme_assoc() for each cfg80211_bss of all the links. When
assoc response from AP is not success(such as status_code==1), the
ieee80211_link_data of non-primary link(sdata->link[link_id]) is NULL
because ieee80211_assoc_success()->ieee80211_vif_update_links() is
not called for the links.

Then struct cfg80211_rx_assoc_resp resp in cfg80211_rx_assoc_resp() and
struct cfg80211_connect_resp_params cr in __cfg80211_connect_result()
will only have the data of the primary link, and finally function
cfg80211_connect_result_release_bsses() only call cfg80211_unhold_bss()
for the primary link. Then cfg80211_bss of the other links will never free
because its hold is always > 0 now.

Hence assign value for the bss and status from assoc_data since it is
valid for this case. Also assign value of addr from assoc_data when the
link is NULL because the addrs of assoc_data and link both represent the
local link addr and they are same value for success connection.

Fixes: 81151ce462e5 ("wifi: mac80211: support MLO authentication/association with one link")
Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
Link: https://lore.kernel.org/r/20230825070055.28164-1-quic_wgong@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h |  2 +-
 net/mac80211/mlme.c    | 11 ++++++-----
 net/wireless/mlme.c    |  3 ++-
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d6fa7c8767ad3..3f03f9b375e56 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -7232,7 +7232,7 @@ struct cfg80211_rx_assoc_resp {
 	int uapsd_queues;
 	const u8 *ap_mld_addr;
 	struct {
-		const u8 *addr;
+		u8 addr[ETH_ALEN] __aligned(2);
 		struct cfg80211_bss *bss;
 		u16 status;
 	} links[IEEE80211_MLD_MAX_NUM_LINKS];
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f93eb38ae0b8d..46d46cfab6c84 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5429,17 +5429,18 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	for (link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS; link_id++) {
 		struct ieee80211_link_data *link;
 
-		link = sdata_dereference(sdata->link[link_id], sdata);
-		if (!link)
-			continue;
-
 		if (!assoc_data->link[link_id].bss)
 			continue;
 
 		resp.links[link_id].bss = assoc_data->link[link_id].bss;
-		resp.links[link_id].addr = link->conf->addr;
+		ether_addr_copy(resp.links[link_id].addr,
+				assoc_data->link[link_id].addr);
 		resp.links[link_id].status = assoc_data->link[link_id].status;
 
+		link = sdata_dereference(sdata->link[link_id], sdata);
+		if (!link)
+			continue;
+
 		/* get uapsd queues configuration - same for all links */
 		resp.uapsd_queues = 0;
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 775cac4d61006..3e2c398abddcc 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -52,7 +52,8 @@ void cfg80211_rx_assoc_resp(struct net_device *dev,
 		cr.links[link_id].bssid = data->links[link_id].bss->bssid;
 		cr.links[link_id].addr = data->links[link_id].addr;
 		/* need to have local link addresses for MLO connections */
-		WARN_ON(cr.ap_mld_addr && !cr.links[link_id].addr);
+		WARN_ON(cr.ap_mld_addr &&
+			!is_valid_ether_addr(cr.links[link_id].addr));
 
 		BUG_ON(!cr.links[link_id].bss->channel);
 
-- 
2.40.1



