Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650B7421EE4;
	Wed,  4 Feb 2026 15:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218560; cv=none; b=mFEO1Mi3cn2UnA0WjrvrA+DkG5NvzJCCY3M4+IW7+pTsJYSXu0E7dl5oTca1WnlrqS3KEtHG/BHkN9FMAfGRmw9ZlMpsULhOGSfqJ/1Dh1sumCEqWE1kVIYMQ5dI56VhWQoUNB/MZNQnSS3RBCyEK9+mHrQt9XFJjfI3n6cLyhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218560; c=relaxed/simple;
	bh=76Z1IF2GUYuIPxFznPSTfcdM6QCyxTxUNi2aJK+1fxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlxUBGosXTW+yUKae7Gybv1RLRav10p93R/DKVZrcUPiPJ+17s9st81gfKEu0f3QSse+mfhK7ZBQUqBoYktymWYrRc7VmM2U4zOGAGICtaIYEbyO3hutA6mEltvfXviMZ99gEevWdfdZLe1KT9xijB01LecJv9yQotPKr7ABMt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTzwlqTe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTzwlqTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF642C4CEF7;
	Wed,  4 Feb 2026 15:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218560;
	bh=76Z1IF2GUYuIPxFznPSTfcdM6QCyxTxUNi2aJK+1fxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTzwlqTeNdl0Oa5O7MhipEJ5AHP0a/Q077WCZzZ/XtA+xC5twYGhFfzIG/0xqaoeQ
	 kIb1pW45Ub3zq3X8YQoQuwZzg6i0UAWIhxbQNt6qh83Fn+NMymMtlFSv1EwNvY5hV+
	 EiCvd6kZMvay1CIYWAtKfZO6b7K3syhF23Y36d1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eryk Kubanski <e.kubanski@partner.samsung.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jianqiang kang <jianqkang@sina.cn>
Subject: [PATCH 6.6 66/72] xsk: Fix race condition in AF_XDP generic RX path
Date: Wed,  4 Feb 2026 15:41:09 +0100
Message-ID: <20260204143848.031785612@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/xdp_sock.h      |    3 ---
 include/net/xsk_buff_pool.h |    2 ++
 net/xdp/xsk.c               |    6 +++---
 net/xdp/xsk_buff_pool.c     |    1 +
 4 files changed, 6 insertions(+), 6 deletions(-)

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
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -339,13 +339,14 @@ int xsk_generic_rcv(struct xdp_sock *xs,
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
 
@@ -1647,7 +1648,6 @@ static int xsk_create(struct net *net, s
 	xs = xdp_sk(sk);
 	xs->state = XSK_READY;
 	mutex_init(&xs->mutex);
-	spin_lock_init(&xs->rx_lock);
 
 	INIT_LIST_HEAD(&xs->map_list);
 	spin_lock_init(&xs->map_list_lock);
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -85,6 +85,7 @@ struct xsk_buff_pool *xp_create_and_assi
 		XDP_PACKET_HEADROOM;
 	pool->umem = umem;
 	pool->addrs = umem->addrs;
+	spin_lock_init(&pool->rx_lock);
 	INIT_LIST_HEAD(&pool->free_list);
 	INIT_LIST_HEAD(&pool->xskb_list);
 	INIT_LIST_HEAD(&pool->xsk_tx_list);


