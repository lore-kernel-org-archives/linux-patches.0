Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023471;
	b=JbvFaA6ZCdV/bkAYHB8WC7k77ntvXXe4eVP4emwkaFOyn8rKwvgOQY4QBeqOBC4rJP48
	 3EB047AnuZbd39bwMOrBVhcc9iPuzdC4Pzfg1rBb7ApCnpUHmra997eD3z/JytvwJH8O5
	 ajGttO6l2UsFxtisb2zhqzXsa+/0/KTWWl7cPlj4+dKdCR4StpTfQ1VsTz5GeTfmxRt6x
	 /solPUrr7juPRkYGPPZ9uN8Z56P+sUkISfrdfiuIg2HCHtCujdFcPG28g9PP6+v/hYzHA
	 Fx6nT2dRgEeFy2gKtY49VeO+4QKvgZCX6K0i/1ljQlYPHQJGpgDo7wnnp5ju/86TT+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023471;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lmNHWe3nERyk+CDQMKedN84jyYs9wLxFn9RFUkFmzws=;
	b=Mb8hjRW7n4gV2Yr+yvRLLfDYJuu3UclDbk4XsRHirqEexPTL3bKgmu/Dmxspi1JOUyQd
	 Xjb3Jy6MLiy2k4tfHIHIvTLbWP/Qiv3i8pdGBu0mqVfhA8V049uSWpViwMz4u2LqqXz+Y
	 YBcvjlz9VHZCMgAnjTk7M450BNPIl+jClu+kln4p8sfSxjDKgozXbAGpbsF7ZsAI1BDHa
	 wkkug5mhszSIDRUgfCtB4+asIUHeiBgQKcdxRypjPw6s69erBcLyTsvPPs4bfQ9Tr5iCQ
	 EjYiSXnYsY1f59H6TDHL8VeU22FhRqp1+DdT8mhg/Tgdj5+gqsS61/niuZum/vcrlbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5WA5yLZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159C9606A334;
	Wed, 18 Nov 2026 17:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5WA5yLZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D42D1F000C4;
	Wed, 18 Nov 2026 17:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023470;
	bh=lmNHWe3nERyk+CDQMKedN84jyYs9wLxFn9RFUkFmzws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u5WA5yLZIWJ6tG47GxGRB0Zg/bkUgsxjTW51HPYcUf24nvfrb5i96b943MfEtfiJB
	 BkxkU052Nkv2gmrQj1IIxy9dc0KggfTDKGCKHUDoXQoyhyDVmPn3dAKtp4GNaaRqhS
	 Wj9fC5bFm5HYsbw3658s1WqRgbvSnGZgQ9grl8iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0379/2151] sit: fix UAF in ipip6_tunnel_del_prl()
Date: Wed, 18 Nov 2026 15:35:14 +0100
Message-ID: <20261118150135.889256452@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5145bb6a2c2683d541828f86d5321e0565f2e30c ]

When flushing all potential router list (PRL) entries,
ipip6_tunnel_del_prl() called call_rcu(&x->rcu_head, prl_list_destroy_rcu)
before clearing t->prl.

A concurrent reader in isatap_chksrc() could enter an RCU read-side
critical section after call_rcu() but before t->prl is set to NULL,
allowing prl_list_destroy_rcu() to free nodes while the reader traverses
them.

Clear t->prl using RCU_INIT_POINTER() before invoking call_rcu().
Also use rcu_assign_pointer() when unlinking individual entries.

Fixes: ef9a9d1183b3 ("ipv6 sit: RCU conversion phase I")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260907075846.2913645-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/sit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index ae39e4c5d463a..590b54e9b947d 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -435,7 +435,7 @@ ipip6_tunnel_del_prl(struct ip_tunnel *t, struct ip_tunnel_prl *a)
 		     (x = rtnl_dereference(*p)) != NULL;
 		     p = &x->next) {
 			if (x->addr == a->addr) {
-				*p = x->next;
+				rcu_assign_pointer(*p, rtnl_dereference(x->next));
 				kfree_rcu(x, rcu_head);
 				t->prl_count--;
 				goto out;
@@ -446,8 +446,8 @@ ipip6_tunnel_del_prl(struct ip_tunnel *t, struct ip_tunnel_prl *a)
 		x = rtnl_dereference(t->prl);
 		if (x) {
 			t->prl_count = 0;
+			RCU_INIT_POINTER(t->prl, NULL);
 			call_rcu(&x->rcu_head, prl_list_destroy_rcu);
-			t->prl = NULL;
 		}
 	}
 out:
-- 
2.53.0



