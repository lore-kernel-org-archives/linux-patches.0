Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948F73C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1990CC433C0;
	Mon, 19 Jun 2023 10:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171055;
	bh=27r0tyXi3rEI+hpo4kFpJsSCNtKJyG5BGnB9wB8UBLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5F43aGhUI8jvw7jlpc3OyYhM1YhZZe+V34hL5U9CyXa7i4IbYB3XkdpFu2PsnxgG
	 TBZZxAaeIos/+7XDN2VrtbDw9k1k7PyBKy6GRmQFpiboNd4Y+tnLLom0LFE5RJCMEm
	 bjFeBiJJtJlTzS9TBo0ZmGBomlg3fg55sosbTeI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 132/187] wifi: mac80211: fix link activation settings order
Date: Mon, 19 Jun 2023 12:29:10 +0200
Message-ID: <20230619102203.997608165@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 01605ad6c3e8608d7e147c9b75d67eb8a3d27d88 ]

In the normal MLME code we always call
ieee80211_mgd_set_link_qos_params() before
ieee80211_link_info_change_notify() and some drivers,
notably iwlwifi, rely on that as they don't do anything
(but store the data) in their conf_tx.

Fix the order here to be the same as in the normal code
paths, so this isn't broken.

Fixes: 3d9011029227 ("wifi: mac80211: implement link switching")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230608163202.a2a86bba2f80.Iac97e04827966d22161e63bb6e201b4061e9651b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/link.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index 8c8869cc1fb4c..aab4d7b4def24 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -2,7 +2,7 @@
 /*
  * MLO link handling
  *
- * Copyright (C) 2022 Intel Corporation
+ * Copyright (C) 2022-2023 Intel Corporation
  */
 #include <linux/slab.h>
 #include <linux/kernel.h>
@@ -404,6 +404,7 @@ static int _ieee80211_set_active_links(struct ieee80211_sub_if_data *sdata,
 						 IEEE80211_CHANCTX_SHARED);
 		WARN_ON_ONCE(ret);
 
+		ieee80211_mgd_set_link_qos_params(link);
 		ieee80211_link_info_change_notify(sdata, link,
 						  BSS_CHANGED_ERP_CTS_PROT |
 						  BSS_CHANGED_ERP_PREAMBLE |
@@ -418,7 +419,6 @@ static int _ieee80211_set_active_links(struct ieee80211_sub_if_data *sdata,
 						  BSS_CHANGED_TWT |
 						  BSS_CHANGED_HE_OBSS_PD |
 						  BSS_CHANGED_HE_BSS_COLOR);
-		ieee80211_mgd_set_link_qos_params(link);
 	}
 
 	old_active = sdata->vif.active_links;
-- 
2.39.2



