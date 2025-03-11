Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFB225EFB5;
	Tue, 11 Mar 2025 15:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707225; cv=none; b=OHqXt0VeHqTGucu1K1/47O6q1nDtNOtwvGNkYV7Sizczk3F2ya7tVrkZ6fLnWa6fnx6069LLUzPaEDpup5JGhr62SI/jVnMmVorNnRBy9ZmfrDeQXKsVFDWwqP99tPn/cs6dlIiQQxmk20lGQi1snx4FqNGk1ub5ru9KXKllr+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707225; c=relaxed/simple;
	bh=UvJjvku1j9/JYVrW864jAGwWBvhUyy1JlvnH8PKBKq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/kGDUnDa1GcFHSkY/1F7M4j4ig4siCVP+Euqa9ilvJSuD4zbN8APpSVkXBki8LDkM/R2HcIj4aA6U0lC8zMWki3+sOFhhpNZUIlyqm5QyrzrxiiBDM9Kru1rBuhylLNQStJz0PdvDmYmmLh06t8dVQ0pXUplfVZhd8pdAse/7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdDHnZcN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdDHnZcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88043C4CEE9;
	Tue, 11 Mar 2025 15:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707224;
	bh=UvJjvku1j9/JYVrW864jAGwWBvhUyy1JlvnH8PKBKq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VdDHnZcNkUsAUiSHU7jUqB4Jzqt3mXcfR+o2ojoM3xhJygJEcmIudvfsDfhwIuYmB
	 psnywnsth/1qz03npF3M5bOeFAD0vgkXQqPi7MPel/bU+QLEEv1DKEipQ4gpfzOyO6
	 gCqqiI8C4weUeOe8lk4JhAPZZjj2WNEJy0ZGF3pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 286/462] neighbour: use RCU protection in __neigh_notify()
Date: Tue, 11 Mar 2025 15:59:12 +0100
Message-ID: <20250311145809.669625558@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bd017b220cfed..f04ba63e98515 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3369,10 +3369,12 @@ static const struct seq_operations neigh_stat_seq_ops = {
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
@@ -3385,9 +3387,11 @@ static void __neigh_notify(struct neighbour *n, int type, int flags,
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



