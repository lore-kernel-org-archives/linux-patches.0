Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAD4384CED;
	Sat, 17 Oct 2026 16:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254446; cv=none; b=LmU2Xr1oIsDCQ/HwvbRcIY4UEP1CCjWQUuU25SnHtLKe++VVFlOBu7QDkPG5mH3xs0sPYFzCLtW9HCO1FwdMXSzavTvedB+ZFIZVsstvePrcFsFIwAEJG3J5dkgcY+gIHCczNzzvM8sl6Sav1BOi11Yf1mfgKUVAG0zg9cwAyGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254446; c=relaxed/simple;
	bh=xOsm8HyavRjhNdnieBHKgDcHFqNxlTPY1argi6C7M3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=At4Qo9TP8upyIp+J0s5eP5q+VAvpVtr3lE0+kc77lIUw9AvYlrHEc44YfZUK2Pg2XLFZFrwqQdOn43Q3WC6d4w3hmWxoeAKk5x0Cp/Rx2PFWQn+1TBVQZmBisqNHVysV2JZ3eA5cdjk4js0Q1wxrHTVfeqKJEcUWbsUq5d5VuGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUzYuqpg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUzYuqpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE861F000C4;
	Sat, 17 Oct 2026 16:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254445;
	bh=IGMVm0NPXf/N0S0QCsyA94RDn2oJowanwYxvFEX3YYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CUzYuqpgTdB6Unju99tzsscVFtKahR4tx0zvK1R5pRUTU8RGH2SG7GSA4C+x1kExB
	 +BUKVa4iXZeKHbYTY4yl3Y5G7/vRjcRGK5Ez1hMB+JKMe4Ok7VQuTbRYY3R4cuT7Yu
	 6VeC6ZRYR6+u1bCP0+3fGGF1rMW4JSFsXLNW6oOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e14bc5d4942756023b77@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jon Maloy <jmaloy@redhat.com>,
	tipc-discussion@lists.sourceforge.net,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 449/869] tipc: fix UAF in cleanup_bearer() due to premature dst_cache_destroy()
Date: Sat, 17 Oct 2026 17:54:50 +0200
Message-ID: <20261017160048.653458820@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7116764ca53ff529335d7ab7c364a69f094b23a5 ]

TIPC UDP media bearer teardown calls dst_cache_destroy() on its
replicast caches before calling synchronize_net() to wait for
concurrent RCU readers (transmitters) to finish:

static void cleanup_bearer(struct work_struct *work)
{
...
	list_for_each_entry_safe(rcast, tmp, &ub->rcast.list, list) {
		dst_cache_destroy(&rcast->dst_cache);
		list_del_rcu(&rcast->list);
		kfree_rcu(rcast, rcu);
	}
...
	dst_cache_destroy(&ub->rcast.dst_cache);
	udp_tunnel_sock_release(ub->sk);
	synchronize_net();
...
}

This is highly buggy because dst_cache_destroy() immediately frees the
per-CPU cache memory (free_percpu()) and releases the cached dst
entries without any synchronization.

If a concurrent transmitter (e.g., tipc_udp_xmit()) is running on another
CPU under RCU protection, it can call dst_cache_get() concurrently,
leading to:
1. Use-After-Free on the per-CPU cache pointer itself (crash).
2. "rcuref - imbalanced put()" warning if it attempts to release a
   dst that was concurrently released by dst_cache_destroy().

Furthermore, calling kfree(ub) immediately after synchronize_net() without
closing the socket first (or waiting after closing it) leaves a window
where a concurrent receiver (tipc_udp_recv()) could start after
synchronize_net(), access ub, and suffer a UAF when kfree(ub) runs.

To fix this, we must defer dst_cache_destroy() and kfree(ub) until after
we have ensured that no more readers can see the bearer/socket and all
existing readers have finished:

1. Defer rcast entry destruction (both dst_cache_destroy() and kfree())
   to an RCU callback using call_rcu_hurry().
   Using call_rcu_hurry() ensures the dst entries are released quickly.

2. Release the bearer socket using udp_tunnel_sock_release() (stops
   new receive readers).

3. Call synchronize_net() to wait for all outstanding RCU readers
   (both transmit and receive) to finish.

4. Now that it is safe, call dst_cache_destroy() on the main bearer
   cache, and free ub.

Note: 3) and 4) can be changed later in net-next to also use
call_rcu_hurry() and get rid of the synchronize_net() latency.

Fixes: e9c1a793210f ("tipc: add dst_cache support for udp media")
Reported-by: syzbot+e14bc5d4942756023b77@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a396a66.52ae72c2.136ac7.0003.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: tipc-discussion@lists.sourceforge.net
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260623173030.2925059-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/udp_media.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index 2a37b274bcb95..311ebc6163855 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -797,6 +797,14 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
 	return err;
 }
 
+static void rcast_free_rcu(struct rcu_head *rcu)
+{
+	struct udp_replicast *rcast = container_of(rcu, struct udp_replicast, rcu);
+
+	dst_cache_destroy(&rcast->dst_cache);
+	kfree(rcast);
+}
+
 /* cleanup_bearer - break the socket/bearer association */
 static void cleanup_bearer(struct work_struct *work)
 {
@@ -806,20 +814,19 @@ static void cleanup_bearer(struct work_struct *work)
 
 	spin_lock_bh(&ub->rcast_lock);
 	list_for_each_entry_safe(rcast, tmp, &ub->rcast.list, list) {
-		dst_cache_destroy(&rcast->dst_cache);
 		list_del_rcu(&rcast->list);
-		kfree_rcu(rcast, rcu);
+		call_rcu_hurry(&rcast->rcu, rcast_free_rcu);
 	}
 	ub->disabled = true;
 	spin_unlock_bh(&ub->rcast_lock);
 
 	tn = tipc_net(sock_net(ub->ubsock->sk));
 
-	dst_cache_destroy(&ub->rcast.dst_cache);
 	udp_tunnel_sock_release(ub->ubsock);
 
-	/* Note: could use a call_rcu() to avoid another synchronize_net() */
 	synchronize_net();
+
+	dst_cache_destroy(&ub->rcast.dst_cache);
 	atomic_dec(&tn->wq_count);
 	kfree(ub);
 }
-- 
2.53.0



