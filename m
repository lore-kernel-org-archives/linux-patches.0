Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED1716F8E9
	for <patches@lists.linux.dev>; Wed, 11 Sep 2024 08:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726043753; cv=none; b=f+54dHThy88OoL7wvD/h3nfAQqnZ9z+myeUTMbTl1/W+rw95S2aVWnc2J3WjF7MByE+RCoxnUo412PvJAzjEwTtd+rV0YRvLlv1trF8navUxN6DzvMiVmyr1tXa8yUBJG+r8gjGPvkmoWO2MFkmlqn1G6E2Fn5Fj4k9RMMhIqn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726043753; c=relaxed/simple;
	bh=fS0/TQEfsBq11o4gEntfeFOaR1kB5IpuIzfVoCfvsQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9ukfHT3jzOyaGfaXF3BJxg7ELkYP+gGPgEuzKuyb1vkLGVV+b5ZRIX1catkUWsu3uh6cJ59M5N+IXmHcUHcAXED23Ho09wjippdcdYcjrsYfR4sECiMZOX22obc9Ph8yfxluh9/QtsXqM4f41EDPZ5TNxUA8NMt44c/2vVa0i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PqxdTF3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PqxdTF3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FBAC4CECC;
	Wed, 11 Sep 2024 08:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726043753;
	bh=fS0/TQEfsBq11o4gEntfeFOaR1kB5IpuIzfVoCfvsQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PqxdTF3iRvNYR4tun9DAhHqslau7qlGUbqDxZPH46KKZwAkpvsh2iHevBEspTAoC7
	 vdr6q0VzFz2T+FZlfTDBe9+pFpHI8OGjSnAmiMR5qo6H9ubsfzTasD9qgxn/BTusZA
	 m3n2V69M84SCtxRjjmueaK6CyGOaVEp6nr/3ikxn7vH8CjbEj9raR/uTCAolUe6WbJ
	 tIDEo2095d6ZxFqYqH4nfNdJhMJj7VlMITpZcDrG9XSvlfOYQReF0+TwlGnINLl1b3
	 35y0V5ZkUBuTRVz7T2L/tKnq8bNIa8S6Pmn5hRO8+1zLZMi46J5VfF7FmHq/QMIeMH
	 zT28ht/kFqg/g==
From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>
To: syzbot+f4aacdfef2c6a6529c3e@syzkaller.appspotmail.com
Cc: patches@lists.linux.dev
Subject: [PATCH net v2] mptcp: initialize sock lock with its own lockdep keys
Date: Wed, 11 Sep 2024 10:35:50 +0200
Message-ID: <20240911083550.290915-2-matttbe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <00000000000047043b0621624565@google.com>
References: <00000000000047043b0621624565@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5779; i=matttbe@kernel.org; h=from:subject; bh=+vx8TDphq+IZDaMq3ANbRPxHG0Q3v9XNGklm3oE2GQ4=; b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBm4VZmik8xlc2Fx7i86FHddibKaGeSJXwKiH1yW 4h4EMWdZoyJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZuFWZgAKCRD2t4JPQmmg c+moEACDB7LJrZcJOb5Ffkz3yNkBntTt6ATkHevS39jkH7eO2XgiafGWh205Z4ND9PiQyAgL3ZB FsxsMzEwsZx3O3tsbhfZ66pTrVJl1wJRsa0f/icTMftx7XRAWZ5/VVjmE28y9lhmDtnAGVFMQip qEEZ5XuyDqzclf0/Fz6WTAB8t1LUqZIjU5+ip/mz8mXNtlf9DTni3mxdahrpUC1CG4Yz9wAoPi0 36A17SVFclkH4SmfKhlMGs0LDm1CaSLJ/naoM7TdrY9LSxqmLOPgjVgUmuozB3LD6bxk//FDosT tHZnWVf96M6joy8mi3b+GvW1+3CiXTXqP9BmWlJBM0oNJNSkCneGuf64Zs/E/MtCcMqXjg4tvVq +APajDLVKX9nZOH9a20VurtXKkGZk/9jB9Ai0Ee2noIfYDeHKKAagyOBgFvmvLo2G99kOe+6/mT kmOSiWTK69nKLqsS09WNFqczEJSNVSCCGiYwHNy9RhOhsSx+1nbxKq5iQb/YzqSmqr109u7qf6V hJ9GsXo6u1uMH6i5nPDfH/wOrLRtfph56btRMGv2Xj8DpecwLDlyhGWXrtSorDqGqeILDr4mrgf 6xNvX+tzi/WstmxwofS4AwAx047mNvhe9CizGnHZX+7g+Flpf/iHJ+qk2Vt0+leGcsKvCeXk/CF iRGQuOhj4y1hVrQ==
X-Developer-Key: i=matttbe@kernel.org; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit

From: Cong Wang <cong.wang@bytedance.com>

In mptcp_pm_nl_create_listen_socket(), we already initialize mptcp sock
lock with mptcp_slock_keys and mptcp_keys. But that is not sufficient,
at least mptcp_init_sock() and mptcp_sk_clone_init() still miss it.

As reported by syzbot, mptcp_sk_clone_init() is challenging due to that
sk_clone_lock() immediately locks the new sock after preliminary
initialization. To amend that, introduce ->init_clone() for struct proto
and call it right after the sock_lock_init(), so now mptcp sock could
initialize the sock lock again with its own lockdep keys.

This patch does not fix any real deadlock, it only makes lockdep happy.

Fixes: 58b09919626b ("mptcp: create msk early")
Reported-by: syzbot+f4aacdfef2c6a6529c3e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f4aacdfef2c6a6529c3e
Cc: Matthieu Baerts <matttbe@kernel.org>
Cc: Mat Martineau <martineau@kernel.org>
Cc: Geliang Tang <geliang@kernel.org>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Link: https://lore.kernel.org/r/20240911042425.978665-1-xiyou.wangcong@gmail.com
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
---
 include/net/sock.h     |  1 +
 net/core/sock.c        |  2 ++
 net/mptcp/pm_netlink.c | 16 +---------------
 net/mptcp/protocol.c   | 22 ++++++++++++++++++++++
 net/mptcp/protocol.h   |  1 +
 5 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index f51d61fab059..2e06e720071a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1226,6 +1226,7 @@ struct proto {
 	int			(*ioctl)(struct sock *sk, int cmd,
 					 int *karg);
 	int			(*init)(struct sock *sk);
+	void			(*init_clone)(struct sock *sk);
 	void			(*destroy)(struct sock *sk);
 	void			(*shutdown)(struct sock *sk, int how);
 	int			(*setsockopt)(struct sock *sk, int level,
diff --git a/net/core/sock.c b/net/core/sock.c
index 468b1239606c..d37e6efc7f91 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2325,6 +2325,8 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 	}
 	sk_node_init(&newsk->sk_node);
 	sock_lock_init(newsk);
+	if (prot->init_clone)
+		prot->init_clone(newsk);
 	bh_lock_sock(newsk);
 	newsk->sk_backlog.head	= newsk->sk_backlog.tail = NULL;
 	newsk->sk_backlog.len = 0;
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index fe34297ea6dc..a82b68cc1faf 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1067,13 +1067,9 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 	return ret;
 }
 
-static struct lock_class_key mptcp_slock_keys[2];
-static struct lock_class_key mptcp_keys[2];
-
 static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 					    struct mptcp_pm_addr_entry *entry)
 {
-	bool is_ipv6 = sk->sk_family == AF_INET6;
 	int addrlen = sizeof(struct sockaddr_in);
 	struct sockaddr_storage addr;
 	struct sock *newsk, *ssk;
@@ -1089,17 +1085,7 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	if (!newsk)
 		return -EINVAL;
 
-	/* The subflow socket lock is acquired in a nested to the msk one
-	 * in several places, even by the TCP stack, and this msk is a kernel
-	 * socket: lockdep complains. Instead of propagating the _nested
-	 * modifiers in several places, re-init the lock class for the msk
-	 * socket to an mptcp specific one.
-	 */
-	sock_lock_init_class_and_name(newsk,
-				      is_ipv6 ? "mlock-AF_INET6" : "mlock-AF_INET",
-				      &mptcp_slock_keys[is_ipv6],
-				      is_ipv6 ? "msk_lock-AF_INET6" : "msk_lock-AF_INET",
-				      &mptcp_keys[is_ipv6]);
+	mptcp_sock_lock_init(newsk);
 
 	lock_sock(newsk);
 	ssk = __mptcp_nmpc_sk(mptcp_sk(newsk));
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3b837765c84b..7ecaa83794b2 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2839,6 +2839,7 @@ static int mptcp_init_sock(struct sock *sk)
 	int ret;
 
 	__mptcp_init_sock(sk);
+	mptcp_sock_lock_init(sk);
 
 	if (!mptcp_is_enabled(net))
 		return -ENOPROTOOPT;
@@ -2865,6 +2866,26 @@ static int mptcp_init_sock(struct sock *sk)
 	return 0;
 }
 
+static struct lock_class_key mptcp_slock_keys[2];
+static struct lock_class_key mptcp_keys[2];
+
+void mptcp_sock_lock_init(struct sock *sk)
+{
+	bool is_ipv6 = sk->sk_family == AF_INET6;
+
+	/* The subflow socket lock is acquired in a nested to the msk one
+	 * in several places, even by the TCP stack, and this msk is a kernel
+	 * socket: lockdep complains. Instead of propagating the _nested
+	 * modifiers in several places, re-init the lock class for the msk
+	 * socket to an mptcp specific one.
+	 */
+	sock_lock_init_class_and_name(sk,
+				      is_ipv6 ? "mlock-AF_INET6" : "mlock-AF_INET",
+				      &mptcp_slock_keys[is_ipv6],
+				      is_ipv6 ? "msk_lock-AF_INET6" : "msk_lock-AF_INET",
+				      &mptcp_keys[is_ipv6]);
+}
+
 static void __mptcp_clear_xmit(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -3797,6 +3818,7 @@ static struct proto mptcp_prot = {
 	.name		= "MPTCP",
 	.owner		= THIS_MODULE,
 	.init		= mptcp_init_sock,
+	.init_clone	= mptcp_sock_lock_init,
 	.connect	= mptcp_connect,
 	.disconnect	= mptcp_disconnect,
 	.close		= mptcp_close,
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index c3942416fa3a..819a193c0d88 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -812,6 +812,7 @@ void __init mptcp_proto_init(void);
 int __init mptcp_proto_v6_init(void);
 #endif
 
+void mptcp_sock_lock_init(struct sock *sk);
 struct sock *mptcp_sk_clone_init(const struct sock *sk,
 				 const struct mptcp_options_received *mp_opt,
 				 struct sock *ssk,
-- 
2.45.2

