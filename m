Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EAB3BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jNIDKtDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463D5C433C7;
	Wed, 15 Nov 2023 19:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076180;
	bh=X2fI2rxDfAcCrDoPtNKOG2x6mfY0izgMjl90dyhB1xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jNIDKtDDoery+iya5v9v+ddq97O/VTRxtQ6oG7oVoW8ndNlcUcI6d3v/6xI/rs38H
	 vj9lijQHA7+/j06gHG5USh2RiIioyZmi3O8Pmg9sxhZgWFlmIL010G8UbfZ6FfYCSC
	 5LABlrXJGnDA3he3mq7efLGplD2mzYFW4Kj0AWXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 126/550] wifi: mac80211: dont recreate driver link debugfs in reconfig
Date: Wed, 15 Nov 2023 14:11:50 -0500
Message-ID: <20231115191609.423398091@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 822cab1987a0e028e38b60aecd98af0289b46e7b ]

We can delete any that we want to remove, but we can't
recreate the links as they already exist.

Fixes: 170cd6a66d9a ("wifi: mac80211: add netdev per-link debugfs data and driver hook")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230928172905.3d0214838421.I512a0ff86f631ff42bf25ea0cb2e8e8616794a94@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/driver-ops.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index 30cd0c905a24f..aa37a1410f377 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -510,10 +510,13 @@ int drv_change_vif_links(struct ieee80211_local *local,
 	if (ret)
 		return ret;
 
-	for_each_set_bit(link_id, &links_to_add, IEEE80211_MLD_MAX_NUM_LINKS) {
-		link = rcu_access_pointer(sdata->link[link_id]);
+	if (!local->in_reconfig) {
+		for_each_set_bit(link_id, &links_to_add,
+				 IEEE80211_MLD_MAX_NUM_LINKS) {
+			link = rcu_access_pointer(sdata->link[link_id]);
 
-		ieee80211_link_debugfs_drv_add(link);
+			ieee80211_link_debugfs_drv_add(link);
+		}
 	}
 
 	return 0;
-- 
2.42.0



