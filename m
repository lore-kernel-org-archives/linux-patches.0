Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E1E3F9D2;
	Fri, 21 Nov 2025 13:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732031; cv=none; b=fc6EdxzvEtje0Ld3fMDEhhzv5jNHa9AME4b0Bf4TWHWJwU+4Cyv66l6Sn727DOrR11eGYeWCDcpImq8XCZpGrWCWTIHL6PaSOqoLDgxojA5NOH6JT7OxVcnvVgJTUeB75NW19271RZdJmau2K3miFD5qzVBUJNZ2SbYodmkszDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732031; c=relaxed/simple;
	bh=z8cYRqaO3kN/Umzoz7ukhhpT2HhyQFdJtAsLHi2g+po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOe/aYA50bQjCS2Fjyk6b2V2XlC7MDNN9/l9RL+CsNfAMqSy1uP3jsmdVFKEEOrAiWSDIbgUzUuE59f7Ow/0c56Kirj8pZHaCgAvLATkwKj4zdMVVwc2RBQKftC485YJnnqroPlbP3Kx1CCyV+YB/UvBDJ0qHpqOTU58SFKPuEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xMmIigNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xMmIigNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A994C4CEF1;
	Fri, 21 Nov 2025 13:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732030;
	bh=z8cYRqaO3kN/Umzoz7ukhhpT2HhyQFdJtAsLHi2g+po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xMmIigNvIJgBVORjJVOIeHqBW7ok+80W30+EYf2yf98TFkp8HOAyzsg3ROYpMfFeb
	 Q2eJUi2mg/vlqLJh27iEB4nV8mIcFT1aJhsWwMk4B1PO1U2ddlgnbO7iaABhKON/un
	 6HNu9/lJ+l42yIwaI2Pcf6UmMdxXHCz8pNvCp63o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 166/185] net: netpoll: Individualize the skb pool
Date: Fri, 21 Nov 2025 14:13:13 +0100
Message-ID: <20251121130149.869999916@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 221a9c1df790fa711d65daf5ba05d0addc279153 ]

The current implementation of the netpoll system uses a global skb
pool, which can lead to inefficient memory usage and
waste when targets are disabled or no longer in use.

This can result in a significant amount of memory being unnecessarily
allocated and retained, potentially causing performance issues and
limiting the availability of resources for other system components.

Modify the netpoll system to assign a skb pool to each target instead of
using a global one.

This approach allows for more fine-grained control over memory
allocation and deallocation, ensuring that resources are only allocated
and retained as needed.

Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20241114-skb_buffers_v2-v3-1-9be9f52a8b69@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 49c8d2c1f94c ("net: netpoll: fix incorrect refcount handling causing incorrect cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netpoll.h |    1 +
 net/core/netpoll.c      |   31 +++++++++++++------------------
 2 files changed, 14 insertions(+), 18 deletions(-)

--- a/include/linux/netpoll.h
+++ b/include/linux/netpoll.h
@@ -32,6 +32,7 @@ struct netpoll {
 	bool ipv6;
 	u16 local_port, remote_port;
 	u8 remote_mac[ETH_ALEN];
+	struct sk_buff_head skb_pool;
 };
 
 struct netpoll_info {
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -45,9 +45,6 @@
 
 #define MAX_UDP_CHUNK 1460
 #define MAX_SKBS 32
-
-static struct sk_buff_head skb_pool;
-
 #define USEC_PER_POLL	50
 
 #define MAX_SKB_SIZE							\
@@ -234,20 +231,23 @@ void netpoll_poll_enable(struct net_devi
 		up(&ni->dev_lock);
 }
 
-static void refill_skbs(void)
+static void refill_skbs(struct netpoll *np)
 {
+	struct sk_buff_head *skb_pool;
 	struct sk_buff *skb;
 	unsigned long flags;
 
-	spin_lock_irqsave(&skb_pool.lock, flags);
-	while (skb_pool.qlen < MAX_SKBS) {
+	skb_pool = &np->skb_pool;
+
+	spin_lock_irqsave(&skb_pool->lock, flags);
+	while (skb_pool->qlen < MAX_SKBS) {
 		skb = alloc_skb(MAX_SKB_SIZE, GFP_ATOMIC);
 		if (!skb)
 			break;
 
-		__skb_queue_tail(&skb_pool, skb);
+		__skb_queue_tail(skb_pool, skb);
 	}
-	spin_unlock_irqrestore(&skb_pool.lock, flags);
+	spin_unlock_irqrestore(&skb_pool->lock, flags);
 }
 
 static void zap_completion_queue(void)
@@ -284,12 +284,12 @@ static struct sk_buff *find_skb(struct n
 	struct sk_buff *skb;
 
 	zap_completion_queue();
-	refill_skbs();
+	refill_skbs(np);
 repeat:
 
 	skb = alloc_skb(len, GFP_ATOMIC);
 	if (!skb)
-		skb = skb_dequeue(&skb_pool);
+		skb = skb_dequeue(&np->skb_pool);
 
 	if (!skb) {
 		if (++count < 10) {
@@ -678,6 +678,8 @@ int netpoll_setup(struct netpoll *np)
 	struct in_device *in_dev;
 	int err;
 
+	skb_queue_head_init(&np->skb_pool);
+
 	rtnl_lock();
 	if (np->dev_name[0]) {
 		struct net *net = current->nsproxy->net_ns;
@@ -778,7 +780,7 @@ put_noaddr:
 	}
 
 	/* fill up the skb queue */
-	refill_skbs();
+	refill_skbs(np);
 
 	err = __netpoll_setup(np, ndev);
 	if (err)
@@ -804,13 +806,6 @@ unlock:
 }
 EXPORT_SYMBOL(netpoll_setup);
 
-static int __init netpoll_init(void)
-{
-	skb_queue_head_init(&skb_pool);
-	return 0;
-}
-core_initcall(netpoll_init);
-
 static void rcu_cleanup_netpoll_info(struct rcu_head *rcu_head)
 {
 	struct netpoll_info *npinfo =


