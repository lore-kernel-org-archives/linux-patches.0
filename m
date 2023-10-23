Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443D115E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMoHk5H9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F04C433C7;
	Mon, 23 Oct 2023 11:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061148;
	bh=LQeyb/HApqH0UlfDleIwtyX4pbx6jaK83CDn7dnX6mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMoHk5H910B3MtyhSUD77eBRBvPb6dHML0qKaLTd3hsrC41PdvMG/buZeaHV3P/YF
	 XvjwLHK1l7DDNa7QBXLRym58uoDrocEt9Cyn2WMKCfRXkOJJEqEHwxiTOYPeeTCab/
	 7rEJiDAvA61xjIRJCVPLvEZ+4uIaP65bAsTQfJRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Haller <thaller@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/137] ipv4/fib: send notify when delete source address routes
Date: Mon, 23 Oct 2023 12:57:26 +0200
Message-ID: <20231023104823.904881422@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 4b2b606075e50cdae62ab2356b0a1e206947c354 ]

After deleting an interface address in fib_del_ifaddr(), the function
scans the fib_info list for stray entries and calls fib_flush() and
fib_table_flush(). Then the stray entries will be deleted silently and no
RTM_DELROUTE notification will be sent.

This lack of notification can make routing daemons, or monitor like
`ip monitor route` miss the routing changes. e.g.

+ ip link add dummy1 type dummy
+ ip link add dummy2 type dummy
+ ip link set dummy1 up
+ ip link set dummy2 up
+ ip addr add 192.168.5.5/24 dev dummy1
+ ip route add 7.7.7.0/24 dev dummy2 src 192.168.5.5
+ ip -4 route
7.7.7.0/24 dev dummy2 scope link src 192.168.5.5
192.168.5.0/24 dev dummy1 proto kernel scope link src 192.168.5.5
+ ip monitor route
+ ip addr del 192.168.5.5/24 dev dummy1
Deleted 192.168.5.0/24 dev dummy1 proto kernel scope link src 192.168.5.5
Deleted broadcast 192.168.5.255 dev dummy1 table local proto kernel scope link src 192.168.5.5
Deleted local 192.168.5.5 dev dummy1 table local proto kernel scope host src 192.168.5.5

As Ido reminded, fib_table_flush() isn't only called when an address is
deleted, but also when an interface is deleted or put down. The lack of
notification in these cases is deliberate. And commit 7c6bb7d2faaf
("net/ipv6: Add knob to skip DELROUTE message on device down") introduced
a sysctl to make IPv6 behave like IPv4 in this regard. So we can't send
the route delete notify blindly in fib_table_flush().

To fix this issue, let's add a new flag in "struct fib_info" to track the
deleted prefer source address routes, and only send notify for them.

After update:
+ ip monitor route
+ ip addr del 192.168.5.5/24 dev dummy1
Deleted 192.168.5.0/24 dev dummy1 proto kernel scope link src 192.168.5.5
Deleted broadcast 192.168.5.255 dev dummy1 table local proto kernel scope link src 192.168.5.5
Deleted local 192.168.5.5 dev dummy1 table local proto kernel scope host src 192.168.5.5
Deleted 7.7.7.0/24 dev dummy2 scope link src 192.168.5.5

Suggested-by: Thomas Haller <thaller@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20230922075508.848925-1-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_fib.h     | 1 +
 net/ipv4/fib_semantics.c | 1 +
 net/ipv4/fib_trie.c      | 4 ++++
 3 files changed, 6 insertions(+)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index c3324a1949c3a..9f6e2a476dc28 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -151,6 +151,7 @@ struct fib_info {
 	int			fib_nhs;
 	bool			fib_nh_is_v6;
 	bool			nh_updated;
+	bool			pfsrc_removed;
 	struct nexthop		*nh;
 	struct rcu_head		rcu;
 	struct fib_nh		fib_nh[];
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 91a3d6d338874..735901b8c9f69 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1908,6 +1908,7 @@ int fib_sync_down_addr(struct net_device *dev, __be32 local)
 			continue;
 		if (fi->fib_prefsrc == local) {
 			fi->fib_flags |= RTNH_F_DEAD;
+			fi->pfsrc_removed = true;
 			ret++;
 		}
 	}
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 22531aac0ccbf..0b74debeecbb1 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2021,6 +2021,7 @@ void fib_table_flush_external(struct fib_table *tb)
 int fib_table_flush(struct net *net, struct fib_table *tb, bool flush_all)
 {
 	struct trie *t = (struct trie *)tb->tb_data;
+	struct nl_info info = { .nl_net = net };
 	struct key_vector *pn = t->kv;
 	unsigned long cindex = 1;
 	struct hlist_node *tmp;
@@ -2083,6 +2084,9 @@ int fib_table_flush(struct net *net, struct fib_table *tb, bool flush_all)
 
 			fib_notify_alias_delete(net, n->key, &n->leaf, fa,
 						NULL);
+			if (fi->pfsrc_removed)
+				rtmsg_fib(RTM_DELROUTE, htonl(n->key), fa,
+					  KEYLENGTH - fa->fa_slen, tb->tb_id, &info, 0);
 			hlist_del_rcu(&fa->fa_list);
 			fib_release_info(fa->fa_info);
 			alias_free_mem_rcu(fa);
-- 
2.40.1



