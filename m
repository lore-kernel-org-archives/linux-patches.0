Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C671C5D56;
	Wed, 19 Feb 2025 08:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953869; cv=none; b=QOncSGnZwSJJYvYr4AD9XaHs/bj8IziesLmgibZOlRn/OrEbV3xsQ3awYibXevLpIkmwmbFwLxtjr6NXVly9jk0+djyAr/jn5aJJv6g6l38G+v09D5gz2ql3qliOul4lZLm0kRViqn9RRFRT79TDZY3qpb6y/k1gi1Ntok4iZMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953869; c=relaxed/simple;
	bh=yfnyN6+56JnicUvH3n06f2eU2Ayec2E73Itpa24636E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGKfZty/cvGE/fk5WBiKcAB9TBgDU/ntTkajKaUjlahyvlO/1aOeCl1Nqi8d988iO+Jm1KbvZRIIAT1WM7A5DegrRJe0YfDBrTFUretf81dMetTPqFYIABSo7HoZHJXcOFyIR2ZjQr3UrfmNeBdBpgfv7Ko9ciea9I5+7LYp3n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iq6mHc4n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iq6mHc4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9FBC4CED1;
	Wed, 19 Feb 2025 08:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953868;
	bh=yfnyN6+56JnicUvH3n06f2eU2Ayec2E73Itpa24636E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iq6mHc4nxAAWQCjApkxX65mH4l8VS3dPASWgPA6KtmyTE5FObTaE4GERX9wGea0uH
	 7In5AwhTNRRzkzE4lpZ13GMGaZs4BMXvM/qKzGNNbMidf4rUqO53Fto9QRzdMg9rqi
	 6v6OW06p3+P4y4Lqm8eD7P+VUljAUjNF8rA39DIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 023/274] vrf: use RCU protection in l3mdev_l3_out()
Date: Wed, 19 Feb 2025 09:24:37 +0100
Message-ID: <20250219082610.446646523@linuxfoundation.org>
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

[ Upstream commit 6d0ce46a93135d96b7fa075a94a88fe0da8e8773 ]

l3mdev_l3_out() can be called without RCU being held:

raw_sendmsg()
 ip_push_pending_frames()
  ip_send_skb()
   ip_local_out()
    __ip_local_out()
     l3mdev_ip_out()

Add rcu_read_lock() / rcu_read_unlock() pair to avoid
a potential UAF.

Fixes: a8e3e1a9f020 ("net: l3mdev: Add hook to output path")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250207135841.1948589-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/l3mdev.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/l3mdev.h b/include/net/l3mdev.h
index 2d6141f28b530..f7fe796e8429a 100644
--- a/include/net/l3mdev.h
+++ b/include/net/l3mdev.h
@@ -198,10 +198,12 @@ struct sk_buff *l3mdev_l3_out(struct sock *sk, struct sk_buff *skb, u16 proto)
 	if (netif_is_l3_slave(dev)) {
 		struct net_device *master;
 
+		rcu_read_lock();
 		master = netdev_master_upper_dev_get_rcu(dev);
 		if (master && master->l3mdev_ops->l3mdev_l3_out)
 			skb = master->l3mdev_ops->l3mdev_l3_out(master, sk,
 								skb, proto);
+		rcu_read_unlock();
 	}
 
 	return skb;
-- 
2.39.5



