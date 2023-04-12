Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E4C2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E69AC433EF;
	Wed, 12 Apr 2023 08:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288568;
	bh=YRrF1L3Y+zL6n2MJc4xh0rN9iKIq0Ipgo9o31f3EB2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGvoXtLDwDeWToGmOm9eYEUfPqYNEWGcPIhkHUwZhvRc+iFJIbYW4alEoqoZjqwV3
	 dyCyieTWxrKjlzAP7GxT9558URMMLyw0x/8eb5pF9fkCMLbemax+q0LDGhZEoQKZMI
	 kR1OnTkEQAxsMM2NVUqMSZR1sgc5GAphfFP5jOlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Coverstone <brian@mainsequence.net>,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 28/93] wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta
Date: Wed, 12 Apr 2023 10:33:29 +0200
Message-Id: <20230412082824.265716649@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 12b220a6171faf10638ab683a975cadcf1a352d6 ]

Avoid potential data corruption issues caused by uninitialized driver
private data structures.

Reported-by: Brian Coverstone <brian@mainsequence.net>
Fixes: 6a9d1b91f34d ("mac80211: add pre-RCU-sync sta removal driver operation")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20230324120924.38412-3-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 14db465289c53..e10bcfa20526d 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1036,7 +1036,8 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 	list_del_rcu(&sta->list);
 	sta->removed = true;
 
-	drv_sta_pre_rcu_remove(local, sta->sdata, sta);
+	if (sta->uploaded)
+		drv_sta_pre_rcu_remove(local, sta->sdata, sta);
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
 	    rcu_access_pointer(sdata->u.vlan.sta) == sta)
-- 
2.39.2



