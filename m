Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215375;
	b=GhJUud7mqS/9R7jxZUflXiHluKa5sJtGGiJBksJ0VQXdBx1hq0zQ7U3RMHbv2CGADd+5
	 x1AzLkkbbb4GIHRHhTU16QcE8mq/eI8nx6xxqGh/y4lmxt1Z+uVSVo5JeMPntrWxLPTQv
	 FwRYsvfI7pe1gNdrLzJOXK0rCC8kwztqmIaItMSfRjsJkBxTKvSIPLFRQz4r9kkeOun5u
	 6qFaKvBukHI8jUgCzUHO4mdUzwmAkv8cB3vHUoRRdrkpasU2e5+QpuUsv8n2XbB2j15Jc
	 2VpiIg7Yk+2fzq4zH6KGPQN0558hkIEQpA1qbA68LRXQMRPSIX90r8ady7w1Mki+sNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IBs1uEKx1EloL0DeNLXP13taHSh4D1viA+FjL2yTLsU=;
	b=GAn4l9iPFzgpIv2KlbrYzgadZolA5CxTZLpaKyfMoU3ujz8y6tbZ3kG76o5ajoR312ji
	 7dqZjKpJWbMJEkJ8ZwQKvq/IXgZCgsu81dBcwqx8BXqGUPfG+jll1XJqpYjdXNT58sG7/
	 DDKqfAnlVDTrg18p257KNmKwOllYpwKZab/LROY/wfWJd5UDif+q23xWyrQEmnrfgdQ85
	 PJHwh4IPtbTAwklqnmPhqp4WwxB0GFm50ZPK7C2NWRsqqcVfb4jgYHG3hb/sI9+4UYEO4
	 8oWry6YftAzMQxu7FLK/P3gFl00DgFVcRyKrxOX34xUbqExPpw9R/nEPoP1Dk7TpIZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eXqpWorI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D34606A31A;
	Wed, 28 Oct 2026 19:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eXqpWorI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D110F1F01825;
	Wed, 28 Oct 2026 19:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215375;
	bh=IBs1uEKx1EloL0DeNLXP13taHSh4D1viA+FjL2yTLsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eXqpWorIaT8tIh7rNEloK57FIkuGM8UGYdkCoOH2Lb84jRXGwa+EkjF6G+lpksjhv
	 8skhYLR8lDCMLr2T32wfQ9bZAcm4lrL/8GNvZkjX/2N5wLt27OAUBpu7/epbxh0oLW
	 0BGVBsRbp9/l07H1xJum2sx4vLnO12WJ68yrXBn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes@sipsolutions.net>,
	Kaixuan Li <kaixuan.li@ntu.edu.sg>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1190/1887] wifi: mac80211: defer link RX stats percpu free to RCU
Date: Wed, 28 Oct 2026 17:54:46 +0100
Message-ID: <20261028170526.485637150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9b8f25a6126cd..23e66d04f6d7a 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -351,6 +351,15 @@ static void sta_info_free_link(struct link_sta_info *link_sta)
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
@@ -373,10 +382,8 @@ static void sta_remove_link(struct sta_info *sta, unsigned int link_id,
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



