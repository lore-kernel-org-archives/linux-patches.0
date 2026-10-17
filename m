Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EA22C026C;
	Sat, 17 Oct 2026 16:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254315; cv=none; b=bPH0htUA/fJ3uLMyJMci6P9HNgd8tCmLPqRlwwc2hDLs7NUGb6HopCsYv/4NZEkCWOtwXptrkTNy1Kan8gIijWNLLLH53FixrmYR9UBFLso40v0IjHVX/RySP/hXdb6GFPtubziR5NfO2971jhxwce6ManFDPAJkOZFs5zZNBVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254315; c=relaxed/simple;
	bh=R6BwtnkXpRNIQuNDdp14Zd+tf10/T2Z2IpKG3t4VSWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InXDFhpfngTanS1pHDO42iuVqnTmZpsG9hFR8uOVmr6SORMJJ7PVXjIKhyslSyUDxk0ZmgD6YQQCZQwQKLwAPK6Ds5nzYUZQw7ICoESImV3W+YiI8pez8LEq8YeO7ukYmF2zdtTtz0rLau5ArpRNeyeiJWYcUhBEtaLz4aTzj9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzIbT4lF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzIbT4lF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE2E1F000C4;
	Sat, 17 Oct 2026 16:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254313;
	bh=6MwOqO+N25zu6vrY/38I39hdJMbR8dg3pp8PS43HmG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzIbT4lFiTTPIW7l+1sQwj5UUrr0uLvmlsxQNvGuwVU1nNO0uQMwL7MktysuUPkdo
	 pKZMky4fpB6W9LkmHsHM5rvWf37/LXZ0no3xDHJI9+biXTdkBy6RdG7pp7Si/Efbbb
	 jYIPQ9un7zGtXjm1cb/81Ed7HYhL41d/v9wIYGVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes@sipsolutions.net>,
	Kaixuan Li <kaixuan.li@ntu.edu.sg>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 406/869] wifi: mac80211: defer link RX stats percpu free to RCU
Date: Sat, 17 Oct 2026 17:54:07 +0200
Message-ID: <20261017160047.544129521@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e5781b8355d5e..09f212134c823 100644
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
 static void sta_remove_link(struct sta_info *sta, unsigned int link_id,
 			    bool unhash)
 {
@@ -379,10 +388,8 @@ static void sta_remove_link(struct sta_info *sta, unsigned int link_id,
 	sta->sta.valid_links &= ~BIT(link_id);
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



