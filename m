Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E822566DE;
	Thu, 17 Apr 2025 18:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912801; cv=none; b=Hyc6Kr8HNUcgVKh+RsznOkcYhjLDMvKfKPBaW07tA2jL73HGNCSxw/qX4Ce7ePP/G6Bb5Motn+nvx+s9l5Y/SiPRV9d9WF7lvV83JzgMu6RJHxo0YN3wTihm0PLl3PVUJrwaVb5kOSR2W/jmAr2Y9O+k0rSx940Dn07mMwG7POw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912801; c=relaxed/simple;
	bh=D75ssAIuSbfezU3ZmsCCIQjtImBWnbAuiqm1NrAuHCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIfMODkTSEp1wyK9ZrZjIR4ZtUOW/ENx1t5jZcZKjN88L12ekRBORBE19/8RisgxvDycbhg89U/KEV1goEoHN94ON0yabXVYt+jx3vAy3B20hnWBlaymy4jaY4qIv6La4dy8OCn4UNdnnMojlqPMkaESKZIDrvIda+6mFahiXqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OrCSwP+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OrCSwP+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED09C4CEE4;
	Thu, 17 Apr 2025 18:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912800;
	bh=D75ssAIuSbfezU3ZmsCCIQjtImBWnbAuiqm1NrAuHCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OrCSwP+Y0UeVanoI5ak3Vl1tm3yNVoyXN+HcflM3qF0e+30gGgN4PPR/OUyyQTl2u
	 qm5r2VtomWIo854eODWU1PW/zaMOXqz6XWMQbTWZzOgtI7jfJRybpN9YTECLFgrmYW
	 X4UFP/tvBHmxKmmNddXYRTqn8wa3WPoNxHMZWM8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 127/449] wifi: mac80211: fix userspace_selectors corruption
Date: Thu, 17 Apr 2025 19:46:55 +0200
Message-ID: <20250417175123.077169627@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 700014d3ad1fd6e55c8f9ffa817514d3fbb5286e ]

Spotted during code review, the selectors need to be large
enough for a 128-bit bitmap, not a single unsigned long,
otherwise we have stack corruption.

We should also allow passing selectors from userspace, but
that should be a separate change.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250308225541.8f1bcf96a504.Ibeb8970c82a30c97279a4cc4e68faca5df1813a5@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9411500a61350..99e9b03d7fe19 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -9648,8 +9648,6 @@ EXPORT_SYMBOL(ieee80211_disable_rssi_reports);
 
 static void ieee80211_ml_reconf_selectors(unsigned long *userspace_selectors)
 {
-	*userspace_selectors = 0;
-
 	/* these selectors are mandatory for ML reconfiguration */
 	set_bit(BSS_MEMBERSHIP_SELECTOR_SAE_H2E, userspace_selectors);
 	set_bit(BSS_MEMBERSHIP_SELECTOR_HE_PHY, userspace_selectors);
@@ -9669,7 +9667,7 @@ void ieee80211_process_ml_reconf_resp(struct ieee80211_sub_if_data *sdata,
 		                sdata->u.mgd.reconf.removed_links;
 	u16 link_mask, valid_links;
 	unsigned int link_id;
-	unsigned long userspace_selectors;
+	unsigned long userspace_selectors[BITS_TO_LONGS(128)] = {};
 	size_t orig_len = len;
 	u8 i, group_key_data_len;
 	u8 *pos;
@@ -9777,7 +9775,7 @@ void ieee80211_process_ml_reconf_resp(struct ieee80211_sub_if_data *sdata,
 	}
 
 	ieee80211_vif_set_links(sdata, valid_links, sdata->vif.dormant_links);
-	ieee80211_ml_reconf_selectors(&userspace_selectors);
+	ieee80211_ml_reconf_selectors(userspace_selectors);
 	link_mask = 0;
 	for (link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS; link_id++) {
 		struct cfg80211_bss *cbss = add_links_data->link[link_id].bss;
@@ -9823,7 +9821,7 @@ void ieee80211_process_ml_reconf_resp(struct ieee80211_sub_if_data *sdata,
 		link->u.mgd.conn = add_links_data->link[link_id].conn;
 		if (ieee80211_prep_channel(sdata, link, link_id, cbss,
 					   true, &link->u.mgd.conn,
-					   &userspace_selectors)) {
+					   userspace_selectors)) {
 			link_info(link, "mlo: reconf: prep_channel failed\n");
 			goto disconnect;
 		}
@@ -10152,14 +10150,14 @@ int ieee80211_mgd_assoc_ml_reconf(struct ieee80211_sub_if_data *sdata,
 	 */
 	if (added_links) {
 		bool uapsd_supported;
-		unsigned long userspace_selectors;
+		unsigned long userspace_selectors[BITS_TO_LONGS(128)] = {};
 
 		data = kzalloc(sizeof(*data), GFP_KERNEL);
 		if (!data)
 			return -ENOMEM;
 
 		uapsd_supported = true;
-		ieee80211_ml_reconf_selectors(&userspace_selectors);
+		ieee80211_ml_reconf_selectors(userspace_selectors);
 		for (link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS;
 		     link_id++) {
 			struct ieee80211_supported_band *sband;
@@ -10235,7 +10233,7 @@ int ieee80211_mgd_assoc_ml_reconf(struct ieee80211_sub_if_data *sdata,
 						     data->link[link_id].bss,
 						     true,
 						     &data->link[link_id].conn,
-						     &userspace_selectors);
+						     userspace_selectors);
 			if (err)
 				goto err_free;
 		}
-- 
2.39.5



