Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385B34DE702;
	Thu, 17 Sep 2026 16:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664236; cv=none; b=bgEujRbZ7wmNrAL6Wm/alLkNEkxL4pxVhnfXza7y4eOxy11EqkN/LL7DioEN/0hTpzKPZWyJ5DSfCNXzmV5W4xEoPgNuu6TSpVJmxCZNBISE2w4ta3c5ptx2AIQTpt0Ib3VHe+IVP0svTt/ubH5iCWoZwYeNmQfLd70orZ/sUc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664236; c=relaxed/simple;
	bh=wulV/C/V0gXyv6JrFD0/xbfm6L/aS42Kth7Z+frTH4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6JAkt70vZq3l/TPqAOoKeHv4vqMo7U8TIVVTZaKtmxTT2KzrErWwqKIqwLdlmH/WtM+I7UMghi8QXp1BeQ+aArzjTI8wbWgCJC5+1yZKNC8oyLob6DUsn9H41bR+DQRlquSo37zOtiwUQ2NKHU0e2VJkh68J3oJksAlTCy86QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a7Ofwdye; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a7Ofwdye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8841F000FF;
	Thu, 17 Sep 2026 16:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664235;
	bh=QXKIqP4P5QY//vL0nrToneRuz20NGoOC3f7lfa0fo6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a7OfwdyeddVZeK276XplzOUmfgEtDVgtWvlj4xIwxVwUmKetRkCB6vul0uY/yseLY
	 sPObQuGPZdLmnFZ6IqeBuf/HIqSnx92romdXb/hbDYRXP4lRAkDPnkA9Pgw/QgQYCN
	 ILTs0BD41eNlDmDbL7Vmbkc1x5mRNy9jrqkdz4j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0305/1250] wifi: mac80211: unify link STA removal in vif link removal
Date: Thu, 17 Sep 2026 16:01:40 +0100
Message-ID: <20260917151600.380445169@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 79fb99e16f60a77cbd2824695d98aa34ebbb9d69 ]

There are multiple cases where interface links are removed
and the station links need to be removed with them, e.g.
in mlme.c we have both received and transmitted multi-link
reconfiguration, doing the two things in different order,
the former deleting STA links when the vif link change may
still fail.

It's also not clear that userspace (hostapd) couldn't, at
least in theory, remove a link from an interface without
removing the station links first, or even leave stations
that aren't MLO-capable, using that link.

Unify this code into ieee80211_vif_update_links() so that
it always happens, always happens in the right order and
is transactional (i.e. failures are handled correctly.)

Link: https://patch.msgid.link/20260529102644.c352f73a4658.I7219a5d72dab2abcecea9b5c52e7eb7a50e68d9b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/link.c | 30 ++++++++++++++++++++++++++++++
 net/mac80211/mlme.c |  8 --------
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index cd02053ff5063..54415ca128d22 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -280,6 +280,7 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 	u16 old_active = sdata->vif.active_links;
 	unsigned long add = new_links & ~old_links;
 	unsigned long rem = old_links & ~new_links;
+	unsigned long sta_rem = rem;
 	unsigned int link_id;
 	int ret;
 	struct link_container *links[IEEE80211_MLD_MAX_NUM_LINKS] = {}, *link;
@@ -287,6 +288,7 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_link_data *old_data[IEEE80211_MLD_MAX_NUM_LINKS];
 	bool use_deflink = old_links == 0; /* set for error case */
 	bool non_sta = sdata->vif.type != NL80211_IFTYPE_STATION;
+	struct sta_info *sta;
 
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
@@ -392,6 +394,34 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 		goto free;
 	}
 
+	/* try to remove links that are now invalid from (MLO) stations */
+	list_for_each_entry(sta, &sdata->local->sta_list, list) {
+		unsigned long rem_links = sta->sta.valid_links & sta_rem;
+
+		if (sta->sdata != sdata)
+			continue;
+
+		/*
+		 * skip stations that would have no links left,
+		 * those will be removed completely later
+		 */
+		if (sta->sta.valid_links == rem_links)
+			continue;
+
+		for_each_set_bit(link_id, &rem_links,
+				 IEEE80211_MLD_MAX_NUM_LINKS)
+			ieee80211_sta_remove_link(sta, link_id);
+	}
+
+	/*
+	 * Remove stations using any removed links. Note that due
+	 * to the above station link removal, this only removes
+	 * stations that were skipped above because they'd have no
+	 * links left after link removal.
+	 */
+	for_each_set_bit(link_id, &sta_rem, IEEE80211_MLD_MAX_NUM_LINKS)
+		sta_info_flush(sdata, link_id);
+
 	/* use deflink/bss_conf again if and only if there are no more links */
 	use_deflink = new_links == 0;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 40283b0951d27..70a34f8862c7b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -10906,14 +10906,6 @@ int ieee80211_mgd_assoc_ml_reconf(struct ieee80211_sub_if_data *sdata,
 			goto err_free;
 		}
 
-		for (link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS;
-		     link_id++) {
-			if (!(req->rem_links & BIT(link_id)))
-				continue;
-
-			ieee80211_sta_remove_link(sta, link_id);
-		}
-
 		/* notify the driver and upper layers */
 		ieee80211_vif_cfg_change_notify(sdata,
 						BSS_CHANGED_MLD_VALID_LINKS);
-- 
2.53.0



