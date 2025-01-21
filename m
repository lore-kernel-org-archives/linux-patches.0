Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38561F7064;
	Tue, 21 Jan 2025 17:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482262; cv=none; b=ZcsN+QTqgesxdV3M0O5PPKcpTWpzFF25FUKu22XIjEVvzW8PUn3WvAjDgKrhSODLQbaCIga9BpPnBE3muwDvukNfl1lTrRJMzcuWBpo514MLxu3WfhDW/qhNR4T/Hrmd6K4HSOAycSycFdSgSZ1aWHjwPG/iXpNJwoH7laxGcGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482262; c=relaxed/simple;
	bh=8Pk5zxMmxWNWWLxJkVxL0eOMZp2XO1UuVs6XH+xuu1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYGUq1JkhkNW7xna6isKLD/895XJynbKGMAoTbxVgEiq0uvT64jiRNDmq6Df+QOGkooLKLF7TZo9gHy3RMDu4iDn20Hlez9KklGlYRFZdDVGYK9A5jL518acFA8BLikkiR16fWTShuSxDkD0bMx8sOkHvMM9qPah0LaQbhd1Gm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vd/lGIuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vd/lGIuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1C3C4CEDF;
	Tue, 21 Jan 2025 17:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482262;
	bh=8Pk5zxMmxWNWWLxJkVxL0eOMZp2XO1UuVs6XH+xuu1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vd/lGIuhr/w2gQsF5hMYGiN9kxcA0fV2UaUOfQbsOQkBzzbtA9a7X7dvxbdB3gaey
	 OQugZg5FFJx4VsXKqSOg5A/dXBZVcGJqOn4W1fLTSScPP7UQ01THEt8Ufqmn7LnFSh
	 dk7NZIyoS8OUJS9xUDrVRtznzPWjUbPiiGEebHFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/122] gtp: Use for_each_netdev_rcu() in gtp_genl_dump_pdp().
Date: Tue, 21 Jan 2025 18:51:05 +0100
Message-ID: <20250121174533.667459185@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 46841c7053e6d25fb33e0534ef023833bf03e382 ]

gtp_newlink() links the gtp device to a list in dev_net(dev).

However, even after the gtp device is moved to another netns,
it stays on the list but should be invisible.

Let's use for_each_netdev_rcu() for netdev traversal in
gtp_genl_dump_pdp().

Note that gtp_dev_list is no longer used under RCU, so list
helpers are converted to the non-RCU variant.

Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Reported-by: Xiao Liang <shaw.leon@gmail.com>
Closes: https://lore.kernel.org/netdev/CABAhCOQdBL6h9M2C+kd+bGivRJ9Q72JUxW+-gur0nub_=PmFPA@mail.gmail.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 70f981887518a..819ce4b756d23 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1527,7 +1527,7 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 	}
 
 	gn = net_generic(dev_net(dev), gtp_net_id);
-	list_add_rcu(&gtp->list, &gn->gtp_dev_list);
+	list_add(&gtp->list, &gn->gtp_dev_list);
 	dev->priv_destructor = gtp_destructor;
 
 	netdev_dbg(dev, "registered new GTP interface\n");
@@ -1553,7 +1553,7 @@ static void gtp_dellink(struct net_device *dev, struct list_head *head)
 		hlist_for_each_entry_safe(pctx, next, &gtp->tid_hash[i], hlist_tid)
 			pdp_context_delete(pctx);
 
-	list_del_rcu(&gtp->list);
+	list_del(&gtp->list);
 	unregister_netdevice_queue(dev, head);
 }
 
@@ -2279,16 +2279,19 @@ static int gtp_genl_dump_pdp(struct sk_buff *skb,
 	struct gtp_dev *last_gtp = (struct gtp_dev *)cb->args[2], *gtp;
 	int i, j, bucket = cb->args[0], skip = cb->args[1];
 	struct net *net = sock_net(skb->sk);
+	struct net_device *dev;
 	struct pdp_ctx *pctx;
-	struct gtp_net *gn;
-
-	gn = net_generic(net, gtp_net_id);
 
 	if (cb->args[4])
 		return 0;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(gtp, &gn->gtp_dev_list, list) {
+	for_each_netdev_rcu(net, dev) {
+		if (dev->rtnl_link_ops != &gtp_link_ops)
+			continue;
+
+		gtp = netdev_priv(dev);
+
 		if (last_gtp && last_gtp != gtp)
 			continue;
 		else
@@ -2483,9 +2486,9 @@ static void __net_exit gtp_net_exit_batch_rtnl(struct list_head *net_list,
 
 	list_for_each_entry(net, net_list, exit_list) {
 		struct gtp_net *gn = net_generic(net, gtp_net_id);
-		struct gtp_dev *gtp;
+		struct gtp_dev *gtp, *gtp_next;
 
-		list_for_each_entry(gtp, &gn->gtp_dev_list, list)
+		list_for_each_entry_safe(gtp, gtp_next, &gn->gtp_dev_list, list)
 			gtp_dellink(gtp->dev, dev_to_kill);
 	}
 }
-- 
2.39.5



