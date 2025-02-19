Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A051AF0C8;
	Wed, 19 Feb 2025 08:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954552; cv=none; b=LIdLBVjcAaX3hfGKKqGTS2MHAtX1ZUdy50J/r+Vjb5dJDhPOW273L/VwoWf+y8w/sYX0WhlnfO5pIgk1XitrrEK63MhJiLybE2+8V2Z2XnfMgk9Ndyror1OaUFMlVxqOkO44K0JvslXhmgYu7JSMxcVAIlEKIefqu9Wu4EYCvlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954552; c=relaxed/simple;
	bh=12kWgU/FEbvFRHLQQ+v0t1yblNF7UDF5kl01giYLas4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lp+DAItFUTYea4/ZNgpuYyjXzsOKCsz9oVTsL1YVqEqeqZHCKKnItvByXAJTPBt7O/j92od9UmPd75lZnPLbeU/wKlWQUoQwQi3RTnkbhPnHbQPJIIErqio+spw5KZ6d4XJOEEtlp7almV7/okF2SjjPzOo+VJ/X+2uhAzjMJJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0crD4mB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0crD4mB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B866BC4CED1;
	Wed, 19 Feb 2025 08:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954552;
	bh=12kWgU/FEbvFRHLQQ+v0t1yblNF7UDF5kl01giYLas4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0crD4mB3Gxp7mUeTivHB2ulGQHBEUUMq38xuT/xmQ+haR+Y1b5bRellak001OsN54
	 Bfe958sp4F+8GrN+7alPulE6uAwhgbFRjF2VpNvpR0P0TeibMJrUqEvnhn4Zy0gx0P
	 LqMwiv2Qu7ndtOkkEM6de1vdFlY5Rgm4ekRVRYEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 237/274] neighbour: use RCU protection in __neigh_notify()
Date: Wed, 19 Feb 2025 09:28:11 +0100
Message-ID: <20250219082618.855763114@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 89656d180bc60..bd0251bd74a1f 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3447,10 +3447,12 @@ static const struct seq_operations neigh_stat_seq_ops = {
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
@@ -3463,9 +3465,11 @@ static void __neigh_notify(struct neighbour *n, int type, int flags,
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



