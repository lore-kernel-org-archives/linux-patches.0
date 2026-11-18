Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027499;
	b=vhmmqu2oEQhNQvvszrp2u2e8AZp61u9WNU7aNsVoKuBfLsAf0T0r556ry5T1C7mbfDWt
	 zh32WOe377QjQygd34/xRymGgD4+x3jM5KHK+g+voUMAStT5m+2YEfKkVcIB7LX3Vnyhl
	 R7YfqaICLmSjI0Exe1cpMe4tNLe0pwci9EcvZZV2TkGQq8e4uD9wRc0DCWN+/7xx9zy/h
	 hYqLZfkSyMUfezoWnMKRwY2QZhJlSJOyVW3qYluLs+aMn+a29Xut9XcKBD8JPJ7aiM16a
	 n00y1B4GvxvEW2pdbxfV9JUswnZ3omOS5GkAHrTnPU7qV5aPvhNXqaUBsVanmWDNY5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fdLP5IJnbIQlK99LKiVHW7al0YqJF4gG3xx1Fr3X528=;
	b=G2qKP+s67sW57EGs/spshLEmGUx3joCZBAOY9eu+Wfcf/Vy5ShDHMdI2KnFmG1qwDaOq
	 zm/ItoS56IGjvAlU0TRr+QD5il6dbggWY4ned5+iClD7RBr/ZpLOZPLxIVPP/8GZQY/E3
	 JbqZudS9rUlAooa/sclNJJaXgv5HPJN+bgRKYlyklxU1vIzKLYoVz58SMork1fN3OI9HP
	 5bM7AMSFhJ8ANnfCqosPee3HyRSRt6FiakbWo6slGbDD+xBfFE6uIdmJSzfs7m53YhtgE
	 y2N29hb8zE831AlnKU3iBLFOrWDAg8rORqUsyVY72QJogbWiZri8rOqNSVYvHm/HarQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DN2Q67t2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CE160A2603;
	Wed, 18 Nov 2026 18:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DN2Q67t2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A131F000C4;
	Wed, 18 Nov 2026 18:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027498;
	bh=fdLP5IJnbIQlK99LKiVHW7al0YqJF4gG3xx1Fr3X528=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DN2Q67t2r7FJV+09LHRuUw44Fv/f9D6jjUdpZOgVUVX4LzJOv0h+uqz7MnKuzaSvW
	 DshajeYWk46fqAqkUK6LSftK6rxww/98eufpuIS8Vi3EOnNhgRvXNIifqNlqNg6Hn9
	 Pk79h/+nDaimwg5c/V78Allc9VKj1vSqSLmFO47M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1810/2151] tcp: tcp_metrics: use the socket netns, not the dst device netns
Date: Wed, 18 Nov 2026 15:59:05 +0100
Message-ID: <20261118150227.737702721@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 504bdcb8c1566a6f887f9accebe1aa99b502ae97 ]

tcp_get_metrics(), __tcp_get_metrics_req() and tcpm_new() look up and
create metrics entries in the netns of the cached dst device rather than
in the netns of the socket.

These usually match, but not after the device has been moved to another
netns or unregistered: a socket can keep a stale dst in sk_dst_cache
until it is checked again, and tcp_update_metrics() reads it with
__sk_dst_get() without any dst_check(). Once dst_dev_put() has run, the
dst device is blackhole_netdev and the entry is created in init_net.
Before that, for instance for routes through nexthop objects whose
cached dsts are released from a nested RCU callback, it is the netns the
device has just been moved to.

A TCP socket of netns A that enters TIME_WAIT in that window then
creates or updates an entry carrying A's addresses and RTT in another
netns, where TCP_METRICS_CMD_GET can dump it and where new connections
to the same peer inherit those metrics.

The metrics belong to the netns of the socket, so use sock_net() for
full sockets and request sockets, and pass it to tcpm_new().

Kernel sockets that do not hold a netns reference can still reach
tcp_time_wait() after tcp_net_metrics_exit_batch() has flushed the
entries of their dismantling netns, and an entry created then would
never be flushed and would keep a dangling tcpm_net. Make tcpm_new()
refuse to create entries when check_net() fails. Its callers are in
an RCU read-side section, and cleanup_net() waits for a grace period
between the refcount reaching zero and the flush, so an entry added
after a successful check is always seen by the flush.

Fixes: 51c5d0c4b169 ("tcp: Maintain dynamic metrics in local cache.")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Cc: Qiliang Yuan <odys.yuan@gmail.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261016084802.2725187-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_metrics.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 7b08d3e58a741..276127902f154 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -161,16 +161,26 @@ static void tcpm_check_stamp(struct tcp_metrics_block *tm,
 	rcu_dereference_protected(p, lockdep_is_held(&tcp_metrics_lock))
 
 static struct tcp_metrics_block *tcpm_new(struct dst_entry *dst,
+					  struct net *net,
 					  struct inetpeer_addr *saddr,
 					  struct inetpeer_addr *daddr,
 					  unsigned int hash)
 {
 	struct tcp_metrics_block *tm;
 	bool reclaim = false;
-	struct net *net;
 
 	spin_lock_bh(&tcp_metrics_lock);
-	net = dst_dev_net_rcu(dst);
+
+	/* Do not add entries to a dismantling netns: they would not be
+	 * flushed again. Callers are in an RCU read-side section, and
+	 * cleanup_net() waits for a grace period after the netns refcount
+	 * reached zero and before tcp_metrics_flush_all(NULL) runs, so an
+	 * entry added after a successful check_net() is seen by the flush.
+	 */
+	if (unlikely(!check_net(net))) {
+		tm = NULL;
+		goto out_unlock;
+	}
 
 	/* While waiting for the spin-lock the cache might have been populated
 	 * with this entry and so we have to check again.
@@ -273,7 +283,7 @@ static struct tcp_metrics_block *__tcp_get_metrics_req(struct request_sock *req,
 		return NULL;
 	}
 
-	net = dst_dev_net_rcu(dst);
+	net = sock_net(req_to_sk(req));
 	hash ^= net_hash_mix(net);
 	hash = hash_32(hash, tcp_metrics_hash_log);
 
@@ -318,7 +328,7 @@ static struct tcp_metrics_block *tcp_get_metrics(struct sock *sk,
 	else
 		return NULL;
 
-	net = dst_dev_net_rcu(dst);
+	net = sock_net(sk);
 	hash ^= net_hash_mix(net);
 	hash = hash_32(hash, tcp_metrics_hash_log);
 
@@ -326,7 +336,7 @@ static struct tcp_metrics_block *tcp_get_metrics(struct sock *sk,
 	if (tm == TCP_METRICS_RECLAIM_PTR)
 		tm = NULL;
 	if (!tm && create)
-		tm = tcpm_new(dst, &saddr, &daddr, hash);
+		tm = tcpm_new(dst, net, &saddr, &daddr, hash);
 	else
 		tcpm_check_stamp(tm, dst);
 
-- 
2.53.0



