Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3056F6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6542C433EF;
	Mon, 16 Jan 2023 16:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887040;
	bh=LUkhsISi78/oVMK7aY/bVdABaTLc3Ba0egGlKjOyXN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VcxZzu3y8KYk9FutznBBFst8Snp2udiEF9PIubYQFXAnbJicjCbwnd8L0zj3arJrj
	 +fbxJQcG+erYuaYF8v5WUgjIFvSrfyEBzcH0hXV+zg4rzWhLb3lt+ElAZM4HTxort2
	 okKSrmFrBN+uMWP+Yb52uS0jb5WMZFBPYl1vuMtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuang Li <shuali@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.4 658/658] tipc: call tipc_lxc_xmit without holding node_read_lock
Date: Mon, 16 Jan 2023 16:52:26 +0100
Message-Id: <20230116154939.555214927@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xin Long <lucien.xin@gmail.com>

commit 88956177db179e4eba7cd590971961857d1565b8 upstream.

When sending packets between nodes in netns, it calls tipc_lxc_xmit() for
peer node to receive the packets where tipc_sk_mcast_rcv()/tipc_sk_rcv()
might be called, and it's pretty much like in tipc_rcv().

Currently the local 'node rw lock' is held during calling tipc_lxc_xmit()
to protect the peer_net not being freed by another thread. However, when
receiving these packets, tipc_node_add_conn() might be called where the
peer 'node rw lock' is acquired. Then a dead lock warning is triggered by
lockdep detector, although it is not a real dead lock:

    WARNING: possible recursive locking detected
    --------------------------------------------
    conn_server/1086 is trying to acquire lock:
    ffff8880065cb020 (&n->lock#2){++--}-{2:2}, \
                     at: tipc_node_add_conn.cold.76+0xaa/0x211 [tipc]

    but task is already holding lock:
    ffff8880065cd020 (&n->lock#2){++--}-{2:2}, \
                     at: tipc_node_xmit+0x285/0xb30 [tipc]

    other info that might help us debug this:
     Possible unsafe locking scenario:

           CPU0
           ----
      lock(&n->lock#2);
      lock(&n->lock#2);

     *** DEADLOCK ***

     May be due to missing lock nesting notation

    4 locks held by conn_server/1086:
     #0: ffff8880036d1e40 (sk_lock-AF_TIPC){+.+.}-{0:0}, \
                          at: tipc_accept+0x9c0/0x10b0 [tipc]
     #1: ffff8880036d5f80 (sk_lock-AF_TIPC/1){+.+.}-{0:0}, \
                          at: tipc_accept+0x363/0x10b0 [tipc]
     #2: ffff8880065cd020 (&n->lock#2){++--}-{2:2}, \
                          at: tipc_node_xmit+0x285/0xb30 [tipc]
     #3: ffff888012e13370 (slock-AF_TIPC){+...}-{2:2}, \
                          at: tipc_sk_rcv+0x2da/0x1b40 [tipc]

    Call Trace:
     <TASK>
     dump_stack_lvl+0x44/0x5b
     __lock_acquire.cold.77+0x1f2/0x3d7
     lock_acquire+0x1d2/0x610
     _raw_write_lock_bh+0x38/0x80
     tipc_node_add_conn.cold.76+0xaa/0x211 [tipc]
     tipc_sk_finish_conn+0x21e/0x640 [tipc]
     tipc_sk_filter_rcv+0x147b/0x3030 [tipc]
     tipc_sk_rcv+0xbb4/0x1b40 [tipc]
     tipc_lxc_xmit+0x225/0x26b [tipc]
     tipc_node_xmit.cold.82+0x4a/0x102 [tipc]
     __tipc_sendstream+0x879/0xff0 [tipc]
     tipc_accept+0x966/0x10b0 [tipc]
     do_accept+0x37d/0x590

This patch avoids this warning by not holding the 'node rw lock' before
calling tipc_lxc_xmit(). As to protect the 'peer_net', rcu_read_lock()
should be enough, as in cleanup_net() when freeing the netns, it calls
synchronize_rcu() before the free is continued.

Also since tipc_lxc_xmit() is like the RX path in tipc_rcv(), it makes
sense to call it under rcu_read_lock(). Note that the right lock order
must be:

   rcu_read_lock();
   tipc_node_read_lock(n);
   tipc_node_read_unlock(n);
   tipc_lxc_xmit();
   rcu_read_unlock();

instead of:

   tipc_node_read_lock(n);
   rcu_read_lock();
   tipc_node_read_unlock(n);
   tipc_lxc_xmit();
   rcu_read_unlock();

and we have to call tipc_node_read_lock/unlock() twice in
tipc_node_xmit().

Fixes: f73b12812a3d ("tipc: improve throughput between nodes in netns")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/5bdd1f8fee9db695cfff4528a48c9b9d0523fb00.1670110641.git.lucien.xin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/node.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1546,6 +1546,7 @@ int tipc_node_xmit(struct net *net, stru
 	struct tipc_node *n;
 	struct sk_buff_head xmitq;
 	bool node_up = false;
+	struct net *peer_net;
 	int bearer_id;
 	int rc;
 
@@ -1562,18 +1563,23 @@ int tipc_node_xmit(struct net *net, stru
 		return -EHOSTUNREACH;
 	}
 
+	rcu_read_lock();
 	tipc_node_read_lock(n);
 	node_up = node_is_up(n);
-	if (node_up && n->peer_net && check_net(n->peer_net)) {
+	peer_net = n->peer_net;
+	tipc_node_read_unlock(n);
+	if (node_up && peer_net && check_net(peer_net)) {
 		/* xmit inner linux container */
-		tipc_lxc_xmit(n->peer_net, list);
+		tipc_lxc_xmit(peer_net, list);
 		if (likely(skb_queue_empty(list))) {
-			tipc_node_read_unlock(n);
+			rcu_read_unlock();
 			tipc_node_put(n);
 			return 0;
 		}
 	}
+	rcu_read_unlock();
 
+	tipc_node_read_lock(n);
 	bearer_id = n->active_links[selector & 1];
 	if (unlikely(bearer_id == INVALID_BEARER_ID)) {
 		tipc_node_read_unlock(n);


