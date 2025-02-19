Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F178C1DEFE3;
	Wed, 19 Feb 2025 09:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957516; cv=none; b=baIMMS6j+tTN8wo7kIMWjNqNMGHbH8X3HMeMUzxszeTq7aw5fGtOF+xFvjQGzfKRB4GMSsvkUZEjYH1feAMOAIVZ2dPB85m1Puf9oIWH6n0v20PVXvemxmI0tmCouUd/0GNn79tGOYFyX/vgMF845HsFZvVQH9L/yrVgBEgNx9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957516; c=relaxed/simple;
	bh=Js0q1PwrdiLLEqYB+e4lBm929zW02TEa6olcH8FW1xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqzX+ykWKNILWD8DwrwqSPf5Mqljo8ZoKSzoTlbZTBz+oZoa+HDW7YCZCeNMJizKuEY2dzzITBbnJ59RE0RxGv687NTz8McXvdmMWt+OIV0quUepZTGFaCuc9QUsnaRqh0alX7Hpz0CrpeoKc01FFR0vF42N8lqS1bq7C9MX5yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSJqyM87; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSJqyM87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FC9C4CEEA;
	Wed, 19 Feb 2025 09:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957514;
	bh=Js0q1PwrdiLLEqYB+e4lBm929zW02TEa6olcH8FW1xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSJqyM87oylwXfRG55VXseRW4lyUKJppScGHVcHJRD+r8RGWBGwc9RtFL7iHNSIdy
	 wv1c79fV/jar4wY8V0R04Vco9f/0bLpJgIemjDiws/jAjgOZtxHYXwWQ62YatNCxSZ
	 hSeI//NHJpwM/wOHhZpCny+6V5zxLe0Q2EVYKl08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 551/578] neighbour: use RCU protection in __neigh_notify()
Date: Wed, 19 Feb 2025 09:29:15 +0100
Message-ID: <20250219082714.634445855@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b127533e74f37..2e2c009b5a2db 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3498,10 +3498,12 @@ static const struct seq_operations neigh_stat_seq_ops = {
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
@@ -3514,9 +3516,11 @@ static void __neigh_notify(struct neighbour *n, int type, int flags,
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



