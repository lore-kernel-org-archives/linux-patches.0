Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4011625D8E8;
	Tue, 11 Mar 2025 15:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705996; cv=none; b=JXeyixa6TVArCqoUCjR9AWgXmj3vliMYEzzczIbovekmHf9BkVEZUlD9fDepEiT0LOTurHF5B1jeR8WpUqivvNN+DQLvojLTXP2OrRoohOlk+3anNuyEALtpuGazPFmSIJTkDr4tXYodH8Cv++TW47PHNITqZOLrueq8TBZAVpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705996; c=relaxed/simple;
	bh=g5Jjznzo9kUU2KCAi7/I9qNO+HicE7BPV8dxZBc2Mks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXh6SOrgnE8ZPziGrmH3Vh6/kdeJA24W57Q1rzudnefExHhPyAaH+SGNkZARJCionIKtoDg+Vse1TIa6LgfC8HTFHuodK9XaxE9WZFHJHV0RFzdSPgk31becEVi6KPmeTKOp35e0I54Jgjuyj9iFyDNPUupxMDjMKBJ4tkALxHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Y5SQZdQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Y5SQZdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA60BC4CEE9;
	Tue, 11 Mar 2025 15:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705996;
	bh=g5Jjznzo9kUU2KCAi7/I9qNO+HicE7BPV8dxZBc2Mks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Y5SQZdQmAaIYBjLGlBE0qtJsGeztqa27Ds08UUx/EJM86zy137ZQDwvdY1tne+kf
	 vnYUoymQ2QzjuUwaasenmgnID60ZkufNrj6MYSHHalcSaWIydZcTApwwgb7Y1fUDmV
	 fkBmJtxJVAbeVVV2UBJ1v7nLu8kTj73X84A1B/eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 208/328] neighbour: use RCU protection in __neigh_notify()
Date: Tue, 11 Mar 2025 15:59:38 +0100
Message-ID: <20250311145723.172293580@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit becbd5850c03ed33b232083dd66c6e38c0c0e569 ]

__neigh_notify() can be called without RTNL or RCU protection.

Use RCU protection to avoid potential UAF.

Fixes: 426b5303eb43 ("[NETNS]: Modify the neighbour table code so it handles multiple network namespaces")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250207135841.1948589-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 3e007cbadb707..7ef3630ea20d7 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3364,10 +3364,12 @@ static const struct seq_operations neigh_stat_seq_ops = {
 static void __neigh_notify(struct neighbour *n, int type, int flags,
 			   u32 pid)
 {
-	struct net *net = dev_net(n->dev);
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
+	struct net *net;
 
+	rcu_read_lock();
+	net = dev_net_rcu(n->dev);
 	skb = nlmsg_new(neigh_nlmsg_size(), GFP_ATOMIC);
 	if (skb == NULL)
 		goto errout;
@@ -3380,9 +3382,11 @@ static void __neigh_notify(struct neighbour *n, int type, int flags,
 		goto errout;
 	}
 	rtnl_notify(skb, net, 0, RTNLGRP_NEIGH, NULL, GFP_ATOMIC);
-	return;
+	goto out;
 errout:
 	rtnl_set_sk_err(net, RTNLGRP_NEIGH, err);
+out:
+	rcu_read_unlock();
 }
 
 void neigh_app_ns(struct neighbour *n)
-- 
2.39.5



