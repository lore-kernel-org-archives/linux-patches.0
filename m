Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979D71F5849;
	Wed, 19 Mar 2025 14:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395169; cv=none; b=UbhVrbXA81Xuq+hRfi0kl8MRXla6TUjiX4uPDtzCHN0W56bAO2E8LoHX+8VeXLqHqgp5SuF+fn4hoONIafchDVY6JCKnOalJ6PAK60SQj5BWvsvN6/lugT7YDftqXnaTD9xBMj0s5IGbkdsYvzs+a/eOcBYDmfdQDr4JRHFCivM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395169; c=relaxed/simple;
	bh=dXHAuZRBX9+uth8zGPq9sFh+mLHTogGQ+3qWvcSfqZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ftc4VOfMIJCrREOuS4VaVnfX0A1UP5FKORRo0c9ax00a1AzSAM0HpyNtAGsKm5WAshbGgrgVtCw8vqTTykGzUXGqSljmPoHPk4p2quhWiTJ06zwAsdQo8VSvGgGBtuGPQRa22DeOMl+/m0HBDUAM5JiOSTtk/1IdeQaZMBVPKGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skM/F585; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skM/F585"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698B9C4CEE4;
	Wed, 19 Mar 2025 14:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395169;
	bh=dXHAuZRBX9+uth8zGPq9sFh+mLHTogGQ+3qWvcSfqZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skM/F585QLShIP2xIVp1WXq26sbiw8ZnBg+iKoi6X8P14xGLjxB6VhBYiKEqd0Ty/
	 BZ1iWilcSiXzV2FHkPSrkfr6A/Nil27KKlU0gJGeXESHD4yPDba1/F3kzQNifYHZyd
	 FejiWR+CPnFoULG598z+ds7eZerMwRkAN4ZVUihw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/166] netpoll: hold rcu read lock in __netpoll_send_skb()
Date: Wed, 19 Mar 2025 07:29:51 -0700
Message-ID: <20250319143020.530562722@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 505ead7ab77f289f12d8a68ac83da068e4d4408b ]

The function __netpoll_send_skb() is being invoked without holding the
RCU read lock. This oversight triggers a warning message when
CONFIG_PROVE_RCU_LIST is enabled:

	net/core/netpoll.c:330 suspicious rcu_dereference_check() usage!

	 netpoll_send_skb
	 netpoll_send_udp
	 write_ext_msg
	 console_flush_all
	 console_unlock
	 vprintk_emit

To prevent npinfo from disappearing unexpectedly, ensure that
__netpoll_send_skb() is protected with the RCU read lock.

Fixes: 2899656b494dcd1 ("netpoll: take rcu_read_lock_bh() in netpoll_send_skb_on_dev()")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250306-netpoll_rcu_v2-v2-1-bc4f5c51742a@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netpoll.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 1791462f1600a..1a4d2a61b060b 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -326,6 +326,7 @@ static int netpoll_owner_active(struct net_device *dev)
 static netdev_tx_t __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 {
 	netdev_tx_t status = NETDEV_TX_BUSY;
+	netdev_tx_t ret = NET_XMIT_DROP;
 	struct net_device *dev;
 	unsigned long tries;
 	/* It is up to the caller to keep npinfo alive. */
@@ -334,11 +335,12 @@ static netdev_tx_t __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 	lockdep_assert_irqs_disabled();
 
 	dev = np->dev;
+	rcu_read_lock();
 	npinfo = rcu_dereference_bh(dev->npinfo);
 
 	if (!npinfo || !netif_running(dev) || !netif_device_present(dev)) {
 		dev_kfree_skb_irq(skb);
-		return NET_XMIT_DROP;
+		goto out;
 	}
 
 	/* don't get messages out of order, and no recursion */
@@ -377,7 +379,10 @@ static netdev_tx_t __netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 		skb_queue_tail(&npinfo->txq, skb);
 		schedule_delayed_work(&npinfo->tx_work,0);
 	}
-	return NETDEV_TX_OK;
+	ret = NETDEV_TX_OK;
+out:
+	rcu_read_unlock();
+	return ret;
 }
 
 netdev_tx_t netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
-- 
2.39.5



