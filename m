Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCC435294D;
	Fri, 21 Nov 2025 14:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733616; cv=none; b=Lror/G7GROzFeiDhwcrv05Hb18QdzXnosemw4EYAcuCm8yi/MBpo6veNmLN0tXU6yuax95G8LoMTqbLoCRQTB5r6oRd4h1UkjMFgffh5x7GTEKuLNFChUcfFaBA5zxm1/W4NptsgTx5mHPnrmYSS9p6ehKcc5/AV092RIhREKIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733616; c=relaxed/simple;
	bh=PG9664oFUXIOjiLrD9XHSboEaXOc+b0FZlkQ6kd4GMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckqeLC3NFEavgYIot8QC8nLyA13lqmPc2iqOMwG9wpLCou2N5gLzPqlEcR01IEWZOJYwHtfsyxRIWYAslKcDyu+ESanslfZFFo8qeEiy5LKFbtNQwtItmOjcSEv+RIExTxXD3aLrDxXT3fnQXYJL5M4KHyWBPWa3WzRR7xvOjPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0YkRdbp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0YkRdbp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B59C4CEF1;
	Fri, 21 Nov 2025 14:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733616;
	bh=PG9664oFUXIOjiLrD9XHSboEaXOc+b0FZlkQ6kd4GMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0YkRdbptcgJqx3ilaa8UhYoxvdLU7R+qL84zD/xM4+hwmKlIXSSVhRdWVj2m1i40
	 PhMGlY0flWMGYTBCRKKiUTNEPleoAYf6m/SfEXC4PA6FdRCeBkJHeTrRY3ZuUVvFpG
	 6oJqKPVOrmXve6GV8vjksQsMQ0O1t3LXDCdmZEE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 497/529] netpoll: remove netpoll_srcu
Date: Fri, 21 Nov 2025 14:13:16 +0100
Message-ID: <20251121130248.696311189@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9a95eedc81deb86af1ac56f2c2bfe8306b27b82a ]

netpoll_srcu is currently used from netpoll_poll_disable() and
__netpoll_cleanup()

Both functions run under RTNL, using netpoll_srcu adds confusion
and no additional protection.

Moreover the synchronize_srcu() call in __netpoll_cleanup() is
performed before clearing np->dev->npinfo, which violates RCU rules.

After this patch, netpoll_poll_disable() and netpoll_poll_enable()
simply use rtnl_dereference().

This saves a big chunk of memory (more than 192KB on platforms
with 512 cpus)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20240905084909.2082486-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 49c8d2c1f94c ("net: netpoll: fix incorrect refcount handling causing incorrect cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netpoll.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -48,8 +48,6 @@
 
 static struct sk_buff_head skb_pool;
 
-DEFINE_STATIC_SRCU(netpoll_srcu);
-
 #define USEC_PER_POLL	50
 
 #define MAX_SKB_SIZE							\
@@ -220,24 +218,21 @@ EXPORT_SYMBOL(netpoll_poll_dev);
 void netpoll_poll_disable(struct net_device *dev)
 {
 	struct netpoll_info *ni;
-	int idx;
+
 	might_sleep();
-	idx = srcu_read_lock(&netpoll_srcu);
-	ni = srcu_dereference(dev->npinfo, &netpoll_srcu);
+	ni = rtnl_dereference(dev->npinfo);
 	if (ni)
 		down(&ni->dev_lock);
-	srcu_read_unlock(&netpoll_srcu, idx);
 }
 EXPORT_SYMBOL(netpoll_poll_disable);
 
 void netpoll_poll_enable(struct net_device *dev)
 {
 	struct netpoll_info *ni;
-	rcu_read_lock();
-	ni = rcu_dereference(dev->npinfo);
+
+	ni = rtnl_dereference(dev->npinfo);
 	if (ni)
 		up(&ni->dev_lock);
-	rcu_read_unlock();
 }
 EXPORT_SYMBOL(netpoll_poll_enable);
 
@@ -843,8 +838,6 @@ void __netpoll_cleanup(struct netpoll *n
 	if (!npinfo)
 		return;
 
-	synchronize_srcu(&netpoll_srcu);
-
 	if (refcount_dec_and_test(&npinfo->refcnt)) {
 		const struct net_device_ops *ops;
 


