Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7836269B12;
	Tue,  8 Apr 2025 12:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113761; cv=none; b=F1E0TM6GxnxEjapMOTiXJQXDauUCHeMv3lWEdh26+PER/DV4qgKc0ZKuXrQW+yYV+SyqPNIGn5KeV5r+MRcLkxsyONk7TRfDnASTftMHq/IThNNo/ViVjbfASkUb8yPejS90Mn0rnylLY7DQu9w3y4KfyLPV+/bRXSpfVBXatj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113761; c=relaxed/simple;
	bh=Yxby4OngIaRfNtiDO+r7WJlGLM+IXp2MygFTb4oS2HA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bu3aNbMjTZVmqabmKQIfFQauwpj8K3HcTieR8/gFmxm2jqjoXf8ptyAru2NOwC12azAjmI0hgBG9drLDkM3w6tRhi+F34UuNxXBbs9WtkCJHkd5XnftXDK+Ilp1E4uemkatj6CyZuxp7jUQPBJLJLsdfAXkA5R3tbV8rG1QHXfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BvWfxv8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BvWfxv8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3433C4CEE5;
	Tue,  8 Apr 2025 12:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113761;
	bh=Yxby4OngIaRfNtiDO+r7WJlGLM+IXp2MygFTb4oS2HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BvWfxv8jxJ59nD8syk67SqH7Vg0U9/rdN+xHbxFhe/f5K0Bd/3ysEkRIufcV5+zsp
	 4R/ZNzxnTw9XqjiwNhpRl56gKfkC0KYKGNYmpoE8/GT7FVg1yEwIl+WhJBHHNw5fOY
	 t2DJpHA0EHqjAbgwVBzbLP44yZ2D27GSztNckJ1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/154] netpoll: move netpoll_send_skb() out of line
Date: Tue,  8 Apr 2025 12:49:12 +0200
Message-ID: <20250408104815.649819770@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

[ Upstream commit fb1eee476b0d3be3e58dac1a3a96f726c6278bed ]

There is no need to inline this helper, as we intend to add more
code in this function.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 505ead7ab77f ("netpoll: hold rcu read lock in __netpoll_send_skb()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netpoll.h |  9 +--------
 net/core/netpoll.c      | 13 +++++++++++--
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/netpoll.h b/include/linux/netpoll.h
index f5202a59c0274..2db513437d2c0 100644
--- a/include/linux/netpoll.h
+++ b/include/linux/netpoll.h
@@ -63,14 +63,7 @@ int netpoll_setup(struct netpoll *np);
 void __netpoll_cleanup(struct netpoll *np);
 void __netpoll_free(struct netpoll *np);
 void netpoll_cleanup(struct netpoll *np);
-void __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb);
-static inline void netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
-{
-	unsigned long flags;
-	local_irq_save(flags);
-	__netpoll_send_skb(np, skb);
-	local_irq_restore(flags);
-}
+void netpoll_send_skb(struct netpoll *np, struct sk_buff *skb);
 
 #ifdef CONFIG_NETPOLL
 static inline void *netpoll_poll_lock(struct napi_struct *napi)
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 69f80b531a1c3..5eefbb2e145a4 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -323,7 +323,7 @@ static int netpoll_owner_active(struct net_device *dev)
 }
 
 /* call with IRQ disabled */
-void __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
+static void __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 {
 	netdev_tx_t status = NETDEV_TX_BUSY;
 	struct net_device *dev;
@@ -378,7 +378,16 @@ void __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 		schedule_delayed_work(&npinfo->tx_work,0);
 	}
 }
-EXPORT_SYMBOL(__netpoll_send_skb);
+
+void netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__netpoll_send_skb(np, skb);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(netpoll_send_skb);
 
 void netpoll_send_udp(struct netpoll *np, const char *msg, int len)
 {
-- 
2.39.5



