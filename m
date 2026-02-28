Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C295359A90
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302483; cv=none; b=ls3V796uCbkW3eJ9kdUSLtm5jdt3jWC6hL0pFRMLZFMM8nbl6zo8d0BBVERPEbUkdmSKNmT0m92IbS9DIFlt+7aOxVcdFpGfesTHJW8VZmvE8Pi7YQHjE8DPB++Zsv4WwsgfcrqFmu22b/32AQlBA+RoedUDcgjwE8GMV40iTkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302483; c=relaxed/simple;
	bh=jnRecfv/XJqnUIMxF0RgIoxzmy+NlndjokjRF9Sli5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQM/N4xSFwYA6LdaA6EsnRHtnX6imPv9iOx6OB41OFlhMuKwXsajfRH093o44BeVxlzGN1IfsQPC3QaOftQovk2ZTjIhHId5NCiB/7F9V1JmkSnvrWkqqmwj6REkv+bsHqAZdaq2fmLifm7DZHjlAqWwvwPX//xP94w7WuulxfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iLTwKvb7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iLTwKvb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63900C19424;
	Sat, 28 Feb 2026 18:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302483;
	bh=jnRecfv/XJqnUIMxF0RgIoxzmy+NlndjokjRF9Sli5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLTwKvb7lnuH88hl8VoscA4j57vkGuGVNQ3OPNy1RvxjpR51r/5QajWJ4wodRhf6X
	 qnvA7fenW2TPbkV6ZzSfxwEymUUHCL1/CQD+MG5erIBKewLOMhYJxh8BTxrbflWPAu
	 zLTtWdIGd/cvdIe3ve9in77YTVUK41HNlxsgAGXDbzybmaDBNrpzex3fLIR7WUk1FD
	 bHNnc6ahw89yQzMDDC6vYXpC19c0apmmcR1yHESTQ3SPWdOpaJB9qNMerV/DvTWkWc
	 GAurb9hn8q3zHqpO72CUlWpdFesGd3b5fq2tYXzCD5RLdzVZdmG9UPmmiAGovUYNDF
	 9Kj37Z3itubBQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Yue Haibing <yuehaibing@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 230/232] inet: ping: check sock_net() in ping_get_port() and ping_lookup()
Date: Sat, 28 Feb 2026 13:11:23 -0500
Message-ID: <20260228181127.1592657-230-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
Stable-dep-of: ad5dfde2a573 ("ping: annotate data-races in ping_lookup()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ping.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index aae5ad6303a97..ee0e2df5d62e0 100644
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

