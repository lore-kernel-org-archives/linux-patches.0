Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA40F2566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD83C4339B;
	Tue, 18 Apr 2023 12:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821177;
	bh=tO1DfdK90mpkzalf36T5pRNPpf5MJyhSVXUD5xhR4Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G05cupZkMnjJpm+eLl8FpcjgGPhSu1NO3ysYeCiS2/P3alBhDuKlZ6Oax7zxyHYA6
	 jJ16ojGGrb9An56cyJHb3OGiouUzpSpLbmpY0IUXgO1yD0W5P+wQmRzze9PQNgd/id
	 NG1BbqThqFZ80KDCTxbwRYslMxCDZ1JbkIsldH9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Coverstone <brian@mainsequence.net>,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/124] wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta
Date: Tue, 18 Apr 2023 14:20:25 +0200
Message-Id: <20230418120309.825493531@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
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
index d572478c4d68e..2e84360990f0c 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1040,7 +1040,8 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 	list_del_rcu(&sta->list);
 	sta->removed = true;
 
-	drv_sta_pre_rcu_remove(local, sta->sdata, sta);
+	if (sta->uploaded)
+		drv_sta_pre_rcu_remove(local, sta->sdata, sta);
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
 	    rcu_access_pointer(sdata->u.vlan.sta) == sta)
-- 
2.39.2



