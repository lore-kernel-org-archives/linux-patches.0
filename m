Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1229823DE;
	Wed,  7 May 2025 19:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644506; cv=none; b=LKcomik0WR03acmZLDT9oIEgoE627HKA1+7VDPKgW85QFVYEy1KQLz6BqQaj1rIvG4xPlsC6YEULYwLf3vunBMpZwZumEqupH2Tf5Crygx/2lPeiMircyqeFeXSRC4nN4JzMF1+KgoeUS7DsyqsI6uYDQCbolQTOGXCGadTJ59Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644506; c=relaxed/simple;
	bh=Vs/kmIiKfWJcB7mf/qNjFN+29Dt13Rc+CYCX0YwXAE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLlNHp/9QCG3gC/DuLl7qPWzEAezoMyzpERlEp4uxdBwUFiG3b672PNCEPJ3cx+YdQHmjtUBGqdGIAYFyas5TwJfZO7gDREvsKslWdm3E88qlu/ffSQAZBXdjGQaUaxER+RKtYDpBuR30lxI1ICipoD61+GusPwBg5rG6fKDPrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YWmmVKoM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YWmmVKoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861D2C4CEE9;
	Wed,  7 May 2025 19:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644505;
	bh=Vs/kmIiKfWJcB7mf/qNjFN+29Dt13Rc+CYCX0YwXAE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWmmVKoM9i/QiXshPeyeDjU6jvXeARD+OVx8Nl3wpeo6/HYKj5VJq8ZZ9ihwUakMj
	 B1dI2ek/uv2okcXOcRl7wGNA4vopTLxX+cygkO0TQUIIgvgsenHtqIiYbg4F8Jiwvt
	 oaHWk0K2MRTL0zYeCvzHsQQKny1p2hZ5zqvW6WoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eryk Kubanski <e.kubanski@partner.samsung.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/164] xsk: Fix race condition in AF_XDP generic RX path
Date: Wed,  7 May 2025 20:39:11 +0200
Message-ID: <20250507183823.622756264@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: e.kubanski <e.kubanski@partner.samsung.com>

[ Upstream commit a1356ac7749cafc4e27aa62c0c4604b5dca4983e ]

Move rx_lock from xsk_socket to xsk_buff_pool.
Fix synchronization for shared umem mode in
generic RX path where multiple sockets share
single xsk_buff_pool.

RX queue is exclusive to xsk_socket, while FILL
queue can be shared between multiple sockets.
This could result in race condition where two
CPU cores access RX path of two different sockets
sharing the same umem.

Protect both queues by acquiring spinlock in shared
xsk_buff_pool.

Lock contention may be minimized in the future by some
per-thread FQ buffering.

It's safe and necessary to move spin_lock_bh(rx_lock)
after xsk_rcv_check():
* xs->pool and spinlock_init is synchronized by
  xsk_bind() -> xsk_is_bound() memory barriers.
* xsk_rcv_check() may return true at the moment
  of xsk_release() or xsk_unbind_dev(),
  however this will not cause any data races or
  race conditions. xsk_unbind_dev() removes xdp
  socket from all maps and waits for completion
  of all outstanding rx operations. Packets in
  RX path will either complete safely or drop.

Signed-off-by: Eryk Kubanski <e.kubanski@partner.samsung.com>
Fixes: bf0bdd1343efb ("xdp: fix race on generic receive path")
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://patch.msgid.link/20250416101908.10919-1-e.kubanski@partner.samsung.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp_sock.h      | 3 ---
 include/net/xsk_buff_pool.h | 2 ++
 net/xdp/xsk.c               | 6 +++---
 net/xdp/xsk_buff_pool.c     | 1 +
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index bfe625b55d55d..df3f5f07bc7c2 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -71,9 +71,6 @@ struct xdp_sock {
 	 */
 	u32 tx_budget_spent;
 
-	/* Protects generic receive. */
-	spinlock_t rx_lock;
-
 	/* Statistics */
 	u64 rx_dropped;
 	u64 rx_queue_full;
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index bacb33f1e3e58..823fd5c7a3b18 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -55,6 +55,8 @@ struct xsk_buff_pool {
 	refcount_t users;
 	struct xdp_umem *umem;
 	struct work_struct work;
+	/* Protects generic receive in shared and non-shared umem mode. */
+	spinlock_t rx_lock;
 	struct list_head free_list;
 	struct list_head xskb_list;
 	u32 heads_cnt;
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index b57d5d2904eb4..f031b07baa57a 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -338,13 +338,14 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
 	u32 len = xdp_get_buff_len(xdp);
 	int err;
 
-	spin_lock_bh(&xs->rx_lock);
 	err = xsk_rcv_check(xs, xdp, len);
 	if (!err) {
+		spin_lock_bh(&xs->pool->rx_lock);
 		err = __xsk_rcv(xs, xdp, len);
 		xsk_flush(xs);
+		spin_unlock_bh(&xs->pool->rx_lock);
 	}
-	spin_unlock_bh(&xs->rx_lock);
+
 	return err;
 }
 
@@ -1720,7 +1721,6 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
 	xs = xdp_sk(sk);
 	xs->state = XSK_READY;
 	mutex_init(&xs->mutex);
-	spin_lock_init(&xs->rx_lock);
 
 	INIT_LIST_HEAD(&xs->map_list);
 	spin_lock_init(&xs->map_list_lock);
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 87e865b9b83af..b69dbd8615fc4 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -87,6 +87,7 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 	pool->addrs = umem->addrs;
 	pool->tx_metadata_len = umem->tx_metadata_len;
 	pool->tx_sw_csum = umem->flags & XDP_UMEM_TX_SW_CSUM;
+	spin_lock_init(&pool->rx_lock);
 	INIT_LIST_HEAD(&pool->free_list);
 	INIT_LIST_HEAD(&pool->xskb_list);
 	INIT_LIST_HEAD(&pool->xsk_tx_list);
-- 
2.39.5



