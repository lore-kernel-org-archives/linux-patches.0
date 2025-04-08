Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26288269811;
	Tue,  8 Apr 2025 12:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113764; cv=none; b=m2ka97kbAquDHlEGGPax8vAnDXjIs/0BoKsY1R7r+CpaDYmGgCYIjEoaxDOcjJ9SRcuFqCb7oKbLmlvamng+pqFeX8ucaJBuf1HwxQHvwweIBoyiS1C4FytoC0dXEfcKvfL8JyIcShzdCr4FF/F34ofX9wkK9LsCHbnmOFqtiuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113764; c=relaxed/simple;
	bh=eEM14DEzRLhJ1lVPgIEEpfuEi5ygaddBZ5fEZ2WMCyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ryM83llV89wcXvx5kz64V/SWg/r8v7IJDw5pOMNAE4SX5hx5r5zENgNGHLNICKFU1QYa5fTRTzxPiydedfU+h2A/LDB2Llf3rZDpcUPQy44cdUQWA/kOfIWuSOhTPE5Ik3G+/dr0dyCWbFVQRNZIgNF2Blw48J1YA46ZfpCw0Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ilFnnk2T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ilFnnk2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDD9C4CEEA;
	Tue,  8 Apr 2025 12:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113764;
	bh=eEM14DEzRLhJ1lVPgIEEpfuEi5ygaddBZ5fEZ2WMCyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ilFnnk2TAaEvBvZwOdSr5KAtbpiJ07EH6PEINGcrEnVHx/IEe2WWROnOT9wXEzqvU
	 pg86jAziTqSfXBUP4roNckfs/51Q4GaKNENTdFl5LpvZisE88wmUdTzvwEbjTc2Qkb
	 YaIBR6qfD92sml5hsDQh3ySbEnNpBu9dfkUavp5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 012/154] netpoll: netpoll_send_skb() returns transmit status
Date: Tue,  8 Apr 2025 12:49:13 +0200
Message-ID: <20250408104815.681236997@linuxfoundation.org>
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

[ Upstream commit 1ddabdfaf70c202b88925edd74c66f4707dbd92e ]

Some callers want to know if the packet has been sent or
dropped, to inform upper stacks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 505ead7ab77f ("netpoll: hold rcu read lock in __netpoll_send_skb()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netpoll.h |  2 +-
 net/core/netpoll.c      | 11 +++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/netpoll.h b/include/linux/netpoll.h
index 2db513437d2c0..f8f5270a891d0 100644
--- a/include/linux/netpoll.h
+++ b/include/linux/netpoll.h
@@ -63,7 +63,7 @@ int netpoll_setup(struct netpoll *np);
 void __netpoll_cleanup(struct netpoll *np);
 void __netpoll_free(struct netpoll *np);
 void netpoll_cleanup(struct netpoll *np);
-void netpoll_send_skb(struct netpoll *np, struct sk_buff *skb);
+netdev_tx_t netpoll_send_skb(struct netpoll *np, struct sk_buff *skb);
 
 #ifdef CONFIG_NETPOLL
 static inline void *netpoll_poll_lock(struct napi_struct *napi)
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 5eefbb2e145a4..408fc07007900 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -323,7 +323,7 @@ static int netpoll_owner_active(struct net_device *dev)
 }
 
 /* call with IRQ disabled */
-static void __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
+static netdev_tx_t __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 {
 	netdev_tx_t status = NETDEV_TX_BUSY;
 	struct net_device *dev;
@@ -338,7 +338,7 @@ static void __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 
 	if (!npinfo || !netif_running(dev) || !netif_device_present(dev)) {
 		dev_kfree_skb_irq(skb);
-		return;
+		return NET_XMIT_DROP;
 	}
 
 	/* don't get messages out of order, and no recursion */
@@ -377,15 +377,18 @@ static void __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 		skb_queue_tail(&npinfo->txq, skb);
 		schedule_delayed_work(&npinfo->tx_work,0);
 	}
+	return NETDEV_TX_OK;
 }
 
-void netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
+netdev_tx_t netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 {
 	unsigned long flags;
+	netdev_tx_t ret;
 
 	local_irq_save(flags);
-	__netpoll_send_skb(np, skb);
+	ret = __netpoll_send_skb(np, skb);
 	local_irq_restore(flags);
+	return ret;
 }
 EXPORT_SYMBOL(netpoll_send_skb);
 
-- 
2.39.5



