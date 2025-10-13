Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35AA270568;
	Mon, 13 Oct 2025 15:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369586; cv=none; b=F6pzpLS8ZD8PdvSZgYaQc//xme0xBZfgKGOZ/PINqMOM3IfIvNdWZrgo9T/GNMVlrZvMWzdquAlSfK24s354uBfQLmmKwWkBXLkitO5k6t/KLnuioad04gKawV/ZkcfZ0kbXyblicxrglOy12YZM07Ud7SYXeo2k5gcIrhNUgtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369586; c=relaxed/simple;
	bh=bYYZvU9ktkNEZ4yHO/0h3oj5biW4LQzI/5E8U0pIaXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVxn7xDqbDUN1YNKU7JdECcpbHfs9LeAmEns2xURPlSpuW95jH0+++SrY4e3aIBZq+IvtpH7w+S/PVpzlriWQc4xs4UAdsOs34hVVo+v8Ckebu6ueP0H0PNlp2EPTm7giOmYkWiXDJVaYoavFYwD3KC5dF+EZgLqUL0otY5W62M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvirrEDB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvirrEDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E6AC4CEE7;
	Mon, 13 Oct 2025 15:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369585;
	bh=bYYZvU9ktkNEZ4yHO/0h3oj5biW4LQzI/5E8U0pIaXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvirrEDBZ/x7ekqSeV0SMcE6x91XbKWF/EssnFr7JKr0XUGgD/mYSiu+0ryVmQoNI
	 raQWHgLl4MMlqYi+IRr3JcJkSNbo4GBubrFeEn/AymCrcHITxnowwuotJVXSRV4J0h
	 64YtwMAoty1m48dyP8vRngUaqOfmeCyYjILkcEXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Yue Haibing <yuehaibing@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 297/563] inet: ping: check sock_net() in ping_get_port() and ping_lookup()
Date: Mon, 13 Oct 2025 16:42:38 +0200
Message-ID: <20251013144422.027970728@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 59f26d86b2a16f1406f3b42025062b6d1fba5dd5 ]

We need to check socket netns before considering them in ping_get_port().
Otherwise, one malicious netns could 'consume' all ports.

Add corresponding check in ping_lookup().

Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Yue Haibing <yuehaibing@huawei.com>
Link: https://patch.msgid.link/20250829153054.474201-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ping.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 031df4c19fcc5..d2c3480df8f77 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -77,6 +77,7 @@ static inline struct hlist_head *ping_hashslot(struct ping_table *table,
 
 int ping_get_port(struct sock *sk, unsigned short ident)
 {
+	struct net *net = sock_net(sk);
 	struct inet_sock *isk, *isk2;
 	struct hlist_head *hlist;
 	struct sock *sk2 = NULL;
@@ -90,9 +91,10 @@ int ping_get_port(struct sock *sk, unsigned short ident)
 		for (i = 0; i < (1L << 16); i++, result++) {
 			if (!result)
 				result++; /* avoid zero */
-			hlist = ping_hashslot(&ping_table, sock_net(sk),
-					    result);
+			hlist = ping_hashslot(&ping_table, net, result);
 			sk_for_each(sk2, hlist) {
+				if (!net_eq(sock_net(sk2), net))
+					continue;
 				isk2 = inet_sk(sk2);
 
 				if (isk2->inet_num == result)
@@ -108,8 +110,10 @@ int ping_get_port(struct sock *sk, unsigned short ident)
 		if (i >= (1L << 16))
 			goto fail;
 	} else {
-		hlist = ping_hashslot(&ping_table, sock_net(sk), ident);
+		hlist = ping_hashslot(&ping_table, net, ident);
 		sk_for_each(sk2, hlist) {
+			if (!net_eq(sock_net(sk2), net))
+				continue;
 			isk2 = inet_sk(sk2);
 
 			/* BUG? Why is this reuse and not reuseaddr? ping.c
@@ -129,7 +133,7 @@ int ping_get_port(struct sock *sk, unsigned short ident)
 		pr_debug("was not hashed\n");
 		sk_add_node_rcu(sk, hlist);
 		sock_set_flag(sk, SOCK_RCU_FREE);
-		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
+		sock_prot_inuse_add(net, sk->sk_prot, 1);
 	}
 	spin_unlock(&ping_table.lock);
 	return 0;
@@ -188,6 +192,8 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 	}
 
 	sk_for_each_rcu(sk, hslot) {
+		if (!net_eq(sock_net(sk), net))
+			continue;
 		isk = inet_sk(sk);
 
 		pr_debug("iterate\n");
-- 
2.51.0



