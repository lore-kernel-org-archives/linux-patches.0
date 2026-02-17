Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F384C6C;
	Tue, 17 Feb 2026 12:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771331648; cv=none; b=jV7z9YrveFn3svv6GGWelFDeRV+AFt95oip7MnToRxz9XpwTfpZpFTDB9TpV9oNGxcB7rTpwO5uPO41bsgXFmBq9sBqjAUNjo+O9DNUGsieuc/B3ogBW+hMW3LcMvnm3y1UrC3ZOfONcym4qCJe/tCD9w8e+65JmFIHBpQCPIaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771331648; c=relaxed/simple;
	bh=j6m6cqD8ofdjC8ZN7L7rV9XANZF18p9TJcWdlw33juE=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=PfSGbH0c56tqagIjQpOyGEqRGL4Hc/m1UzR/ItGjW6jXl7VXH4nlNf019yQXDH9pW+W31rIPER5A5d7ttq5LhSkPhi5VGvl1d8JBWyEhVG6pu/dnn2ScD+k/t9VmOLUsNuajrocyVh9cj7c4zlHXdLvwovIHMvQG1hLHvkGj4bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k3aSqF0a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k3aSqF0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B23DC4CEF7;
	Tue, 17 Feb 2026 12:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771331648;
	bh=j6m6cqD8ofdjC8ZN7L7rV9XANZF18p9TJcWdlw33juE=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=k3aSqF0aJiukdxeXcmYRY6udZc8h011TsPPszBSIygrCmk0NgPI7pBHz/TuKeayvP
	 qGME+x73EebAEmas9MsQtBnqnqabojR2Q1pkeCSWTIa4PF0dwSGYikfumTCby2Rv8p
	 XWuqgOeS5GbXdVlMNX0xCZSZLFnH9r0YRgU+aS7g=
Subject: Patch "xsk: Fix race condition in AF_XDP generic RX path" has been added to the 6.1-stable tree
To: ast@kernel.org,bjorn@kernel.org,daniel@iogearbox.net,davem@davemloft.net,e.kubanski@partner.samsung.com,edumazet@google.com,gregkh@linuxfoundation.org,hawk@kernel.org,i.maximets@samsung.com,jianqkang@sina.cn,john.fastabend@gmail.com,jonathan.lemon@gmail.com,kuba@kernel.org,maciej.fijalkowski@intel.com,magnus.karlsson@intel.com,pabeni@redhat.com,patches@lists.linux.dev
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 17 Feb 2026 13:33:43 +0100
In-Reply-To: <20260210091251.1690056-1-jianqkang@sina.cn>
Message-ID: <2026021743-disobey-coach-7520@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    xsk: Fix race condition in AF_XDP generic RX path

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xsk-fix-race-condition-in-af_xdp-generic-rx-path.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-215625-greg=kroah.com@vger.kernel.org Tue Feb 10 10:14:03 2026
From: Jianqiang kang <jianqkang@sina.cn>
Date: Tue, 10 Feb 2026 17:12:51 +0800
Subject: xsk: Fix race condition in AF_XDP generic RX path
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, e.kubanski@partner.samsung.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, bjorn@kernel.org, magnus.karlsson@intel.com, maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com, i.maximets@samsung.com, netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <20260210091251.1690056-1-jianqkang@sina.cn>

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
 include/net/xdp_sock.h      |    2 --
 include/net/xsk_buff_pool.h |    2 ++
 net/xdp/xsk.c               |    6 +++---
 net/xdp/xsk_buff_pool.c     |    1 +
 4 files changed, 6 insertions(+), 5 deletions(-)

--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -59,8 +59,6 @@ struct xdp_sock {
 
 	struct xsk_queue *tx ____cacheline_aligned_in_smp;
 	struct list_head tx_list;
-	/* Protects generic receive. */
-	spinlock_t rx_lock;
 
 	/* Statistics */
 	u64 rx_dropped;
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -48,6 +48,8 @@ struct xsk_buff_pool {
 	refcount_t users;
 	struct xdp_umem *umem;
 	struct work_struct work;
+	/* Protects generic receive in shared and non-shared umem mode. */
+	spinlock_t rx_lock;
 	struct list_head free_list;
 	u32 heads_cnt;
 	u16 queue_id;
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -237,13 +237,14 @@ int xsk_generic_rcv(struct xdp_sock *xs,
 {
 	int err;
 
-	spin_lock_bh(&xs->rx_lock);
 	err = xsk_rcv_check(xs, xdp);
 	if (!err) {
+		spin_lock_bh(&xs->pool->rx_lock);
 		err = __xsk_rcv(xs, xdp);
 		xsk_flush(xs);
+		spin_unlock_bh(&xs->pool->rx_lock);
 	}
-	spin_unlock_bh(&xs->rx_lock);
+
 	return err;
 }
 
@@ -1448,7 +1449,6 @@ static int xsk_create(struct net *net, s
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
 	INIT_LIST_HEAD(&pool->xsk_tx_list);
 	spin_lock_init(&pool->xsk_tx_list_lock);


Patches currently in stable-queue which might be from jianqkang@sina.cn are

queue-6.1/xsk-fix-race-condition-in-af_xdp-generic-rx-path.patch
queue-6.1/nfsd-don-t-ignore-the-return-code-of-svc_proc_register.patch
