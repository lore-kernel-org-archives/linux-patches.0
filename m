Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32690175A6B;
	Mon, 17 Aug 2026 15:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978959; cv=none; b=pirVUSOXevm7kkWYBBbpARGn8t4sBewRMFAItkH8JgA+vr1wSNEpflCyUW3H5UtZSf1MxkkaaRUgrqvsgBvmbyK4urqtD0FyzFaMd+oN2H8SQe93x0smHzLgvK+t6Tak2Z2IAho642ePLR4V0/Wm1rpOX+3XRu3d0iqxcNSIHI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978959; c=relaxed/simple;
	bh=jJ8q24To6HIV7/tq4jjw3S2b2Dzi8CoLjfaUbYC6TD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHftZtpAMmFtzqiJ3WQunKv7K2Nhlrq0Ed6Rak/UbfD5Zam3F+emoaCyWJVbXeNE2gBBW5+p/PSexQcs6lfCeQYrN8EYnGFugX4RcByfTtpWJLLfFm/o3sLqmmOtjwIJtw5030oMV5QKm6WjbzDIu7uGOutYwwInhKL5UNsyZjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rUhRdF8k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rUhRdF8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4931F000E9;
	Mon, 17 Aug 2026 15:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978958;
	bh=J2aMGEKQJRtD7bB1CGVoBTDlUV9SAoalqDoHclC4zC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rUhRdF8k+dwaK9xpc9KrMfy2C3fUtdu8saIKsesAL18qpMSnNjy2yc598BfpRv8Yn
	 N0MD25yZ6LCgxMMn+dqLoASJ4LiMvj8a167h+ElrSbkkC7C3++1VqBBDLCUAfWG9Ju
	 QlVQqIr8aS3NNspA7n5RaXX3Dd9E3HDtD5NaGTIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/609] ipv4: fib: free fib_alias with kfree_rcu() on insert error path
Date: Mon, 17 Aug 2026 15:25:54 +0200
Message-ID: <20260817132545.395755984@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit f2f152e94a67bc746afaf05a1b2702c195553112 ]

fib_table_insert() publishes new_fa into the leaf's fa_list with
fib_insert_alias() before calling the fib entry notifiers. When a
notifier fails, the error path removes new_fa with fib_remove_alias()
(hlist_del_rcu) and frees it right away with kmem_cache_free().

fib_table_lookup() walks that list under rcu_read_lock() only, so a
concurrent lookup that already reached new_fa keeps reading it after the
free:

 BUG: KASAN: slab-use-after-free in fib_table_lookup (net/ipv4/fib_trie.c:1601)
 Read of size 1 at addr ffff88810676d4eb by task exploit/297
 Call Trace:
  fib_table_lookup (net/ipv4/fib_trie.c:1601)
  ip_route_output_key_hash_rcu (net/ipv4/route.c:2814)
  ip_route_output_key_hash (net/ipv4/route.c:2705)
  __ip4_datagram_connect (net/ipv4/datagram.c:49)
  udp_connect (net/ipv4/udp.c:2144)
  __sys_connect (net/socket.c:2167)
  __x64_sys_connect (net/socket.c:2173)
  do_syscall_64
  entry_SYSCALL_64_after_hwframe
 which belongs to the cache ip_fib_alias of size 56

Triggering the error path needs CAP_NET_ADMIN and a registered fib
notifier that can reject a route; a netdevsim device whose IPv4 FIB
resource is exhausted is enough.

Free new_fa with alias_free_mem_rcu(), as fib_table_delete() already
does for a fib_alias removed from the trie.

Fixes: a6c76c17df02 ("ipv4: Notify route after insertion to the routing table")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260704171421.1786806-1-bestswngs@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_trie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index c9e1526e749b2b..53e7664eeb0a2a 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1390,7 +1390,7 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 out_remove_new_fa:
 	fib_remove_alias(t, tp, l, new_fa);
 out_free_new_fa:
-	kmem_cache_free(fn_alias_kmem, new_fa);
+	alias_free_mem_rcu(new_fa);
 out:
 	fib_release_info(fi);
 err:
-- 
2.53.0



