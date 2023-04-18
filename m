Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE9F2566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048E8C433D2;
	Tue, 18 Apr 2023 12:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681820807;
	bh=gk88B8TVZq2GyERUwdbxwqku2V7lx7C84xjBklNMy5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ew2ja3g5KPNh7IPnfYoZXPZJHP0yRKQYlwusXd/3TXGJgNEK0D1hl5txj0IfA5IsH
	 3MmAstbZy7ydZSCLV2rIllEtdCWTyUxLIhdQwm5nWpQuUeKt4hIL0/PoRuc09X0dwP
	 8bqQXe6WVVUvBxiMM/I12Gw/hb1yQsCW2bUl21tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Coverstone <brian@mainsequence.net>,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/57] wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta
Date: Tue, 18 Apr 2023 14:21:09 +0200
Message-Id: <20230418120259.042953033@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
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
index 5e28be07cad88..5c209f72de701 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -969,7 +969,8 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 	list_del_rcu(&sta->list);
 	sta->removed = true;
 
-	drv_sta_pre_rcu_remove(local, sta->sdata, sta);
+	if (sta->uploaded)
+		drv_sta_pre_rcu_remove(local, sta->sdata, sta);
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
 	    rcu_access_pointer(sdata->u.vlan.sta) == sta)
-- 
2.39.2



