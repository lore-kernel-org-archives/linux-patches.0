Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E584837F75E;
	Sat, 12 Sep 2026 19:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241621; cv=none; b=bQq9aoJViO6Tx7nvFhPHMryd7JhwjuQaQcWf75COA5seOh2sP8tmOrbBaontdiXQ+ujpVvpIXjiBMbgkFifmkx5jtTq6doEN3XlxcxiGLATzFjwn5DQP676kUa+Qyfua/COZ7MJ+a0oTDnB3w+WEhA1GSPJ97fr4uB7CMYPHv+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241621; c=relaxed/simple;
	bh=0EEphVmriL6VRJwc+SNuFRa43OLAnt3dwqjPrikR1R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiS33DmAo9J+FppZIQTDQrnsEBrPrqu6nJnnhO7tZ8uiq6wI84AuO4FaocrK/z0Vy+RTwec1KxFsv6+uggM7bHAk8jaCYxkyDT9+vtuNDus9YRRRBEwGc0NdYHCRJPvYPyU6/u/GgeMenll/JzQmyAyLkagZIEaPKOQ/6KIjUio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmOky6cC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmOky6cC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF971F000FF;
	Sat, 12 Sep 2026 19:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241619;
	bh=RJbr7c7prxEO7uea1Cet+ZY4rB2ZiRT9vlpft3KKJiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RmOky6cCaiZtaXPzEKgW5m9qPn4aY0dQ3UXe51lNy5Rere2BWNSIX6AgeWSEgsWBY
	 AyQpfCb5k9G9jFdCJKTgZH6oTabUMB6T/g0EI+FOnB0kX4A0WGFXRetwyjWAuNRk0/
	 mu+7Fl/V+DGCJm1j77sdQRDyL6YhrqAD/D4fAmnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Haoze Xie <royenheart@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Alexander Martyniuk <alexevgmart@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 173/798] netfilter: nf_queue: pin bridge device while NFQUEUE holds fake dst
Date: Sat, 12 Sep 2026 08:56:41 +0200
Message-ID: <20260912065520.984042088@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoze Xie <royenheart@gmail.com>

commit c9c9b37f8c5505224e8d206184df3bb668ee00cf upstream.

The br_netfilter fake rtable is embedded in struct net_bridge and is
attached to bridged packets with skb_dst_set_noref(). If such a packet is
queued to NFQUEUE, __nf_queue() upgrades that fake dst with
skb_dst_force().

At that point the queued skb can hold a real dst reference after bridge
teardown has started. The problem is not that every bridged packet needs
its own dst reference. The problem is that NFQUEUE can keep the bridge
private fake dst alive after unregister begins.

Fix this by keeping the bridge fake dst model unchanged and pinning the
bridge master device only while the packet sits in NFQUEUE. Record the
bridge device in nf_queue_entry when the queued skb carries a bridge fake
dst, take a device reference for the queue lifetime, and drop it when the
queue entry is freed.

Also make sure queued entries are reaped when that bridge device goes
down, and drop the redundant nf_bridge_info_exists() test from the fake
dst detection.

This keeps netdev_priv(br->dev) alive until verdict completion, so the
embedded fake rtable and its metrics backing storage cannot be freed out
from under dst_release(). It also avoids the constant refcount bump and
avoids using ipv4-specific dst helpers for IPv6 bridge traffic.

Fixes: 34666d467cbf ("netfilter: bridge: move br_netfilter out of the core")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Haoze Xie <royenheart@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_queue.h |  1 +
 net/netfilter/nf_queue.c         | 16 ++++++++++++++++
 net/netfilter/nfnetlink_queue.c  |  3 +++
 3 files changed, 20 insertions(+)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 6b4de68a762e3..2637d1512929a 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -16,6 +16,7 @@ struct nf_queue_entry {
 	unsigned int		id;
 	unsigned int		hook_index;	/* index in hook_entries->hook[] */
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	struct net_device	*bridge_dev;
 	struct net_device	*physin;
 	struct net_device	*physout;
 #endif
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index d9d35658a357c..47ed9a353107a 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -67,6 +67,7 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 		nf_queue_sock_put(state->sk);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	dev_put(entry->bridge_dev);
 	dev_put(entry->physin);
 	dev_put(entry->physout);
 #endif
@@ -83,6 +84,8 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
 {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	const struct sk_buff *skb = entry->skb;
+	struct dst_entry *dst = skb_dst(skb);
+	struct net_device *dev = NULL;
 	struct nf_bridge_info *nf_bridge;
 
 	nf_bridge = nf_bridge_info_get(skb);
@@ -93,6 +96,18 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
 		entry->physin = NULL;
 		entry->physout = NULL;
 	}
+
+	if (entry->state.pf == NFPROTO_BRIDGE &&
+	    dst && (dst->flags & DST_FAKE_RTABLE)) {
+		WARN_ON_ONCE(!rcu_read_lock_held());
+		dev = READ_ONCE(dst->dev);
+	}
+
+	/* Must hold a reference on the bridge device: dst_hold() protects
+	 * the dst itself, but the fake rtable is embedded in bridge-private
+	 * storage that netdevice teardown can free independently.
+	 */
+	entry->bridge_dev = dev;
 #endif
 }
 
@@ -109,6 +124,7 @@ bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 	dev_hold(state->out);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	dev_hold(entry->bridge_dev);
 	dev_hold(entry->physin);
 	dev_hold(entry->physout);
 #endif
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 1541d6801001c..f91cc1b8804d1 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -910,6 +910,9 @@ dev_cmp(struct nf_queue_entry *entry, unsigned long ifindex)
 
 	if (physinif == ifindex || physoutif == ifindex)
 		return 1;
+
+	if (entry->bridge_dev && entry->bridge_dev->ifindex == ifindex)
+		return 1;
 #endif
 	if (entry->skb_dev && entry->skb_dev->ifindex == ifindex)
 		return 1;
-- 
2.53.0



