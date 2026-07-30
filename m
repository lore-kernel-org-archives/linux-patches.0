Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC3F4052DC;
	Thu, 30 Jul 2026 14:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423525; cv=none; b=DyTigYDDG+qvK2mnNeqCNYNvO6upeJ9LgGDLeS43bK0EXQPIP+2ILcqvLKgS2W1IcV/aK6jiVQNoBxyvSkQTPjclj2eemHOZltemZfDxm7VsC5mWw/Cl/X73RWALDk3ynbHgdkS1jesYUFD3M1OF32dX6YTq7PjeSU4owV8/dO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423525; c=relaxed/simple;
	bh=hxMVvnJ8UBNUN7Qx0JeyI8iLokJtkoHjaVuvnChfEow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhthmpjXq7hhyF/1L+9nhKZ6qKRRIdf+USWwp1ye4GKLm/n/q6ztPmKNLXoGfOg9BtOh4EmJmJ6JyhGmIU8FnNHeIK8qlILkKJ3BlwWTBiBuuxmoMn8xcUHBI8tpdoWCv8S8zqXpR15NMCi6Zz61QxmfcwPLOK0RBhhF6vXwz2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5qePdEz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5qePdEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161A21F000E9;
	Thu, 30 Jul 2026 14:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423523;
	bh=Of6+2GZQS2NX7/EN9hDn6AS/WkbK9R4Fnt74m+GJ3j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C5qePdEztFZ7h/gimLkj7J0DD5Db4ugmuLt6Z527P3zRxW+8aEV5gPR/9wq2gbZis
	 gqux0BTvoZau+YapVsdJlHKfRr6xoXQYcW4bv+xqSIjLQDVbC0sWXdWkgQT5EudXFc
	 7AawU4I1SHWo2S808EjHY50Q1mSGBHFLPN4E2i34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes@sipsolutions.net>,
	Kaixuan Li <kaixuan.li@ntu.edu.sg>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 072/675] wifi: mac80211: defer link RX stats percpu free to RCU
Date: Thu, 30 Jul 2026 16:06:42 +0200
Message-ID: <20260730141446.659562522@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Maoyi Xie <maoyixie.tju@gmail.com>

[ Upstream commit aa2eb62525188269cdd402a583b9a8ed94657ff0 ]

sta_remove_link() frees a removed MLO link's RX stats percpu buffer right
away, but defers only the link container to RCU:

	sta_info_free_link(&alloc->info);
	kfree_rcu(alloc, rcu_head);

The RX fast path reads link_sta under rcu_read_lock and writes the percpu
stats. A reader that resolved link_sta before the removal keeps the
pointer. The container stays alive from the kfree_rcu, so the read still
works. But the percpu block it points to is already freed. This needs
uses_rss. That is when pcpu_rx_stats exists.

The full STA teardown frees the deflink stats only after
synchronize_net(). The link removal path had no such barrier. The race is
hard to win in practice, but the free should still wait for RCU.

Free the link together with its data from a single RCU callback, so the
percpu block is reclaimed only after readers drain.

Fixes: c71420db653a ("wifi: mac80211: RCU-ify link STA pointers")
Link: https://lore.kernel.org/r/20260626080158.3589711-1-maoyixie.tju@gmail.com
Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Link: https://patch.msgid.link/20260627083028.3826810-1-maoyixie.tju@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index b0d9bb830f2931..54a6b20a4c5cd5 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -355,6 +355,15 @@ static void sta_info_free_link(struct link_sta_info *link_sta)
 	free_percpu(link_sta->pcpu_rx_stats);
 }
 
+static void sta_link_free_rcu(struct rcu_head *head)
+{
+	struct sta_link_alloc *alloc =
+		container_of(head, struct sta_link_alloc, rcu_head);
+
+	sta_info_free_link(&alloc->info);
+	kfree(alloc);
+}
+
 static void sta_accumulate_removed_link_stats(struct sta_info *sta, int link_id)
 {
 	struct link_sta_info *link_sta = wiphy_dereference(sta->local->hw.wiphy,
@@ -427,10 +436,8 @@ static void sta_remove_link(struct sta_info *sta, unsigned int link_id,
 
 	RCU_INIT_POINTER(sta->link[link_id], NULL);
 	RCU_INIT_POINTER(sta->sta.link[link_id], NULL);
-	if (alloc) {
-		sta_info_free_link(&alloc->info);
-		kfree_rcu(alloc, rcu_head);
-	}
+	if (alloc)
+		call_rcu(&alloc->rcu_head, sta_link_free_rcu);
 
 	ieee80211_sta_recalc_aggregates(&sta->sta);
 }
-- 
2.53.0



