Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215506;
	b=S3PTnS1PODc+0NydM8m2srNgdD1Ah1TRJby30jH7qRcnA/YufLGmJGiA82LHMgHvANvs
	 LJw6wPTu/6AKeO47G3dlC+Ucaj3G/lh+qspfyBnmHIQhFv3i7nHtUhgJPIfhMbGiISteh
	 rUOB6nfGWuWk2H43MdNC1E+JVwmID/jDxO5qWHDrdjRpgq284dCCCmX4zJiCa0vACW1/s
	 zVXLK7+qjc+GKN750KS9mD/GFnXan6loZRv2egJFLAx+Ghq85NiSH27dpY3Ey4pMjGhny
	 2YOEwC7rOWX7bLRtTT4iljO2CVEOKwRg1aBhNK60VpBIYxwdZ/PuP74OMzrG5fa/mCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wE8AoNZcnq7M1Cr8OrQ9I3d1piXiNSt+9oAjEHdOYIs=;
	b=HRh0uc9lP1qUQ1PT0PrZHbCLfWEH7JvfAgAZk0oKpSjRYTePeV8CgXoN0KqM61TQTHBg
	 yWZcFErykw+t8r0hEjpkBlrmCdyNEbOoyHgsQmXLvstTYRNEDdna8h3iq5BzBrHcwexXF
	 D+BtuxaM1fl8Q56Bo3WMJ+almN6hMJmzYrD9CXqmTGZRE/n2SvnuOMHsCy68ovEH5Owpw
	 +DMhSWvCeL23OSXCXPRTfOPVqLt4ELucomXdw0Za0Cy6DwxotLV6ZLsgutNVvQzaJ67Qe
	 D4/4PU4QbAX74hOi7L0GctseIKfT51MEfdmwskDHS9ODROBjcVCUBxF+5pS/IiwwP+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N7tsYh5I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A3A606A31E;
	Wed, 28 Oct 2026 19:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N7tsYh5I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D2D1F01828;
	Wed, 28 Oct 2026 19:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215505;
	bh=wE8AoNZcnq7M1Cr8OrQ9I3d1piXiNSt+9oAjEHdOYIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7tsYh5Ik2DgwitLuBoQVOPTI/Fb4WcVRKP3rnrDDRGbAmU3IIifKgb0O8Y4laa2S
	 eFGOI7RW0mYA9SQJiany24tGnw2tC0/rgZ3Seu4N8XWazPOJeoIHLEL26zTdmiHw9u
	 C1d9ZD5D3P11PEPjOpBLLkSMnx5DVs3XCr8rX8cI=
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
Subject: [PATCH 6.1 1235/1887] tipc: fix UAF in cleanup_bearer() due to premature dst_cache_destroy()
Date: Wed, 28 Oct 2026 17:55:31 +0100
Message-ID: <20261028170527.527642064@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9c4f75a93e637..dc067731ce2e0 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -801,6 +801,14 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
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
@@ -810,20 +818,19 @@ static void cleanup_bearer(struct work_struct *work)
 
 	spin_lock_bh(&ub->rcast_lock);
 	list_for_each_entry_safe(rcast, tmp, &ub->rcast.list, list) {
-		dst_cache_destroy(&rcast->dst_cache);
 		list_del_rcu(&rcast->list);
-		kfree_rcu(rcast, rcu);
+		call_rcu(&rcast->rcu, rcast_free_rcu);
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



