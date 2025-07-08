Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961F21714B7;
	Tue,  8 Jul 2025 16:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992376; cv=none; b=OXsiHWnztqHoCM9G+5xbhquIuHhcxPvPpuVPbzlAEK1pYebP9v3PcBabYw25agOHUC6c9b1PJ2rdorhjo/gp2DGwDZJ0/WFSENZfv6PGn8Okf5qfbgzfTS5bsmYFTS9+JuFSqgPR1xhfk/ZzSJJwEkww4U/48IkZOdlVYTOgR5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992376; c=relaxed/simple;
	bh=iz7leSBzopyB079DXk7LJrwosRKpySC9BmTWej3yveQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lerp6VwGBHey0+LJIpeGf64aXX9KMC76HlGNJxbzwg3vWx6uDSn7MqjG7E/eSrMcuLGoSCRR5sMMuQRBRLJ/H7Z5+EmbHCivh9Sl8mwYr6tS89BHZjZ6zgpR2FBaaClnMPyQWIPmicoEGoZnAYNXCQBdcOt6wyGjtnBXXWHkDrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQjHrH+U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQjHrH+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0060EC4CEED;
	Tue,  8 Jul 2025 16:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992376;
	bh=iz7leSBzopyB079DXk7LJrwosRKpySC9BmTWej3yveQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQjHrH+UOHHoMMtl0fkURg2GrZ1Xdfki38vBbD8TvtJUboDpERdq/X+BGq2QSKGHs
	 VvvmZO7KQwUCqO1VYruBAS4NGYaxjpZLPnNZzqLuRPi24Hg/6s4Txa/vfyFtsPvBN0
	 DZGqWkySdn7Uw6BQ05Ll5I+WV3qFY0PNOr/Gxtpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/132] wifi: mac80211: finish link init before RCU publish
Date: Tue,  8 Jul 2025 18:23:01 +0200
Message-ID: <20250708162232.696338623@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d87c3ca0f8f1ca4c25f2ed819e954952f4d8d709 ]

Since the link/conf pointers can be accessed without any
protection other than RCU, make sure the data is actually
set up before publishing the structures.

Fixes: b2e8434f1829 ("wifi: mac80211: set up/tear down client vif links properly")
Link: https://patch.msgid.link/20250624130749.9a308b713c74.I4a80f5eead112a38730939ea591d2e275c721256@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/link.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index 16cbaea93fc32..af4d2b2e9a26f 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -28,8 +28,16 @@ void ieee80211_link_init(struct ieee80211_sub_if_data *sdata,
 	if (link_id < 0)
 		link_id = 0;
 
-	rcu_assign_pointer(sdata->vif.link_conf[link_id], link_conf);
-	rcu_assign_pointer(sdata->link[link_id], link);
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
+		struct ieee80211_sub_if_data *ap_bss;
+		struct ieee80211_bss_conf *ap_bss_conf;
+
+		ap_bss = container_of(sdata->bss,
+				      struct ieee80211_sub_if_data, u.ap);
+		ap_bss_conf = sdata_dereference(ap_bss->vif.link_conf[link_id],
+						ap_bss);
+		memcpy(link_conf, ap_bss_conf, sizeof(*link_conf));
+	}
 
 	link->sdata = sdata;
 	link->link_id = link_id;
@@ -65,6 +73,9 @@ void ieee80211_link_init(struct ieee80211_sub_if_data *sdata,
 
 		ieee80211_link_debugfs_add(link);
 	}
+
+	rcu_assign_pointer(sdata->vif.link_conf[link_id], link_conf);
+	rcu_assign_pointer(sdata->link[link_id], link);
 }
 
 void ieee80211_link_stop(struct ieee80211_link_data *link)
-- 
2.39.5



