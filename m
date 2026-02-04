Received: from mail115-69.sinamail.sina.com.cn (mail115-69.sinamail.sina.com.cn [218.30.115.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4105393DF9
	for <patches@lists.linux.dev>; Wed,  4 Feb 2026 08:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=218.30.115.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770194023; cv=none; b=kxInJHlKOK4hMTR04eF3wo2bgN5NNEUe3Ec2vzhWb0aNr5pc5Pq8Y2aobR/Eu3mvS9m0/sKkF/iOa9le6i8+ELwweu/iIMHE+ibYGZNyJrNQGSAvojpTvABsB3AHVriYQulhn1QPjTmTA9OKu/aQQUR7+2qvqkD25uwL24r+2o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770194023; c=relaxed/simple;
	bh=uplR7d3QakXfcEJNewTanDErx51xxSFSLq7fHMlabBM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CvmIWAtYExKOZbgliH9BaLfOfHy27OJp2rIUBZR9yzBnEjqwXaiyxml16lxORwjGfmIziK/i/jYtzOzd4AfUdlIR/hzBIvfLHCFgK7bxe9PqlJWRuvdfrTUnTfHec2RUiOnyaI0FjmMm6uVzPYt+SKSTK9EkXWDQZQBgVjYWAi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn; spf=pass smtp.mailfrom=sina.cn; dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b=bao2dEwM; arc=none smtp.client-ip=218.30.115.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b="bao2dEwM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.cn; s=201208; t=1770194022;
	bh=2zHdAh87Ti9W34qJ1WNtQAawfLP9VlEp26E3MqcNpIM=;
	h=From:Subject:Date:Message-Id;
	b=bao2dEwMGKPMH/wmXHvEslJ6mF8tEvYQxmWtA45er3ykwR9bazlh9TVqjF/5FJ9xt
	 Unq2KrvkZzwREIGKYP1dCpCx4rBNGv3R9cdG5tK/x3SiXGkLNXF2aedVqMOtDs269L
	 0ZY+httEF+OruXfCMzLFryLCNnLg3EaSIuGBjDaQ=
X-SMAIL-HELO: NTT-kernel-dev
Received: from unknown (HELO NTT-kernel-dev)([60.247.85.88])
	by sina.cn (10.185.250.22) with ESMTP
	id 6983036000004828; Wed, 4 Feb 2026 16:29:23 +0800 (CST)
X-Sender: jianqkang@sina.cn
X-Auth-ID: jianqkang@sina.cn
Authentication-Results: sina.cn;
	 spf=none smtp.mailfrom=jianqkang@sina.cn;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=jianqkang@sina.cn
X-SMAIL-MID: 2766697602236
X-SMAIL-UIID: CC369951ADE5458180804BB2A1C452BE-20260204-162923-1
From: Jianqiang kang <jianqkang@sina.cn>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	e.kubanski@partner.samsung.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	bjorn@kernel.org,
	magnus.karlsson@intel.com,
	maciej.fijalkowski@intel.com,
	jonathan.lemon@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	i.maximets@samsung.com,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH 6.6.y] xsk: Fix race condition in AF_XDP generic RX path
Date: Wed,  4 Feb 2026 16:29:20 +0800
Message-Id: <20260204082920.3304571-1-jianqkang@sina.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "e.kubanski" <e.kubanski@partner.samsung.com>

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
[ Conflict is resolved when backporting this fix. ]
Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
---
 include/net/xdp_sock.h      | 3 ---
 include/net/xsk_buff_pool.h | 2 ++
 net/xdp/xsk.c               | 6 +++---
 net/xdp/xsk_buff_pool.c     | 1 +
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 69b472604b86..660c22521a29 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -63,9 +63,6 @@ struct xdp_sock {
 
 	struct xsk_queue *tx ____cacheline_aligned_in_smp;
 	struct list_head tx_list;
-	/* Protects generic receive. */
-	spinlock_t rx_lock;
-
 	/* Statistics */
 	u64 rx_dropped;
 	u64 rx_queue_full;
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index b0bdff26fc88..f0d6ce4bda7a 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -54,6 +54,8 @@ struct xsk_buff_pool {
 	refcount_t users;
 	struct xdp_umem *umem;
 	struct work_struct work;
+	/* Protects generic receive in shared and non-shared umem mode. */
+	spinlock_t rx_lock;
 	struct list_head free_list;
 	struct list_head xskb_list;
 	u32 heads_cnt;
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 93c802cfb9c6..569d39f19c56 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -339,13 +339,14 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
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
 
@@ -1647,7 +1648,6 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
 	xs = xdp_sk(sk);
 	xs->state = XSK_READY;
 	mutex_init(&xs->mutex);
-	spin_lock_init(&xs->rx_lock);
 
 	INIT_LIST_HEAD(&xs->map_list);
 	spin_lock_init(&xs->map_list_lock);
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index e83b707da25b..380b0b3f3d8d 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -85,6 +85,7 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 		XDP_PACKET_HEADROOM;
 	pool->umem = umem;
 	pool->addrs = umem->addrs;
+	spin_lock_init(&pool->rx_lock);
 	INIT_LIST_HEAD(&pool->free_list);
 	INIT_LIST_HEAD(&pool->xskb_list);
 	INIT_LIST_HEAD(&pool->xsk_tx_list);
-- 
2.34.1

