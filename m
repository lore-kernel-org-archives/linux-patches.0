Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F034F2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A41C4339B;
	Wed, 12 Apr 2023 08:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289223;
	bh=mITyWvXHvqQgLpYQ1fIZurnKntK/AEZBumbUPsho0Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n8nFSjpbpbjfOQaMzzzeaTt7reayU8UGkAKlhQnLho2mrH1mtfM7zdYGjSMYW8SJr
	 7fxMV6851GCXyIAgT8CKstMyfMwF7zmuCi1vhaPOn0jTBZ3v6Wpppxsig1znUCRY9x
	 lXa/MWfQ6en0yTgjqRDMriiI+flKZhMBnf+SaNZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Coverstone <brian@mainsequence.net>,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 018/173] wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta
Date: Wed, 12 Apr 2023 10:32:24 +0200
Message-Id: <20230412082838.836580016@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
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
index 34cb833db25f5..39731ef51e03a 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1261,7 +1261,8 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 	list_del_rcu(&sta->list);
 	sta->removed = true;
 
-	drv_sta_pre_rcu_remove(local, sta->sdata, sta);
+	if (sta->uploaded)
+		drv_sta_pre_rcu_remove(local, sta->sdata, sta);
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
 	    rcu_access_pointer(sdata->u.vlan.sta) == sta)
-- 
2.39.2



