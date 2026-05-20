Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BF23FBB7D;
	Wed, 20 May 2026 18:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301377; cv=none; b=DXx7zdfHiH7g9vFl7aXXMHDFZG0yV6kaXkV30l0kIpB2VhogGKx7m1DD+16SjTThiAo12yBf8YzUo/igLN/TfVXXz8BO8l0dpyCZiG7M4Id/ZjbJEPf1CS5+KQ4rbrlOrVW/xVvNGLTxbnKq8s6XAjjjHChboWAVmBBMyRCW3Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301377; c=relaxed/simple;
	bh=QZ0C7bxeKf+w6I+8SzaJGubY3J1XHKr8h74hIiVQBkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BijRBZZZ97r6V2cEuVnbJcho68vKVDe+6zOfgMpLvAOzwfUXz1stfflTgtBFbuOTMAi0abgnl8Z/motCfEEbPJsiDfZDJHNBkwvwJEijGC8k1kx/2gweA0q6yKBqVle1TR6NaG6yRLiEsgM8TQ6DnzEdamz9E5PamC8oI9Z4cCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EaUa8VDE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EaUa8VDE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E189F1F000E9;
	Wed, 20 May 2026 18:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301375;
	bh=E/MSeq+YnvItqMe1jaS5zSefoVVoZlWCuy2rw/b1izQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EaUa8VDEqC4W++XdKyl4XE4ZeP2fSHzd+ZFkNXKQLrkx5FnXRc5jVmox5h+ryJOu7
	 oRIY/A5S1e/rl1BvErwLRINiakLpKK6F7rssHCcdfh4iZaDpy/9R+VLd8Gqdz+k8PS
	 k8wGwy/WqekfvqJXYo/0E62ivS9JDZpVQYTACeLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 532/666] net/sched: netem: fix queue limit check to include reordered packets
Date: Wed, 20 May 2026 18:22:23 +0200
Message-ID: <20260520162122.803158072@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Stephen Hemminger <stephen@networkplumber.org>

[ Upstream commit 4185701fcce6b426b6c3630b25330dddd9c47b0d ]

The queue limit check in netem_enqueue() uses q->t_len which only
counts packets in the internal tfifo. Packets placed in sch->q by
the reorder path (__qdisc_enqueue_head) are not counted, allowing
the total queue occupancy to exceed sch->limit under reordering.

Include sch->q.qlen in the limit check.

Fixes: f8d4bc455047 ("net/sched: netem: account for backlog updates from child qdisc")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260418032027.900913-3-stephen@networkplumber.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index add20b1ab79b2..542ab3f7e3d07 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -522,7 +522,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 				1 << get_random_u32_below(8);
 	}
 
-	if (unlikely(q->t_len >= sch->limit)) {
+	if (unlikely(sch->q.qlen >= sch->limit)) {
 		/* re-link segs, so that qdisc_drop_all() frees them all */
 		skb->next = segs;
 		qdisc_drop_all(skb, sch, to_free);
-- 
2.53.0



