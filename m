Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060518;
	b=Nh7NnyHqRNrJjMy1Xkp+CA2G9aT5KxnaYIMMATrTZQwJUsHPCzqBAH8gNPkrxf7WHpIU
	 PyikIgsstNu63ZraoHZ2evcsaUjzHzKhijZBMQ94MsCWzueoXrPXtI77/3yOALK4kMRS0
	 Z+klW/1AVj7TkKzQx7ec2ssy/FRcb1gTApPW+fjViu47nmBFIYlEiLgaMQZaRQO53iOxs
	 uxA4tUNxwl9k06oXVvIOamGFtmi+UR5IYMzCWGbFVQDXXTuZD42mVAgfdVjG/1PPpqwLx
	 aDL//o0HGqr3r9Pq+5mKw2/EczQKak1oZNRutaxciQIPeDI40oXF3MKsbDI6ZLz0JhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kM5cGArgepWNH8W73mG0ln7aO+kuBM1F0b7bk09svYM=;
	b=LGuz7BDW7VXOeQ5NI8+xjQ6nMnlPOdHCI3Q56KmcEPIWHHId7VEAW7mbcXq7vvnfEMFv
	 DCK7aP7ZoVZ/1ICaHNwQufJDAnDLVJ5NJLeUZIe+5x/9aT3xwb970W6/iCReCz3hgoMty
	 ZRcOwX7lx2cY8p3hUcHFfOMS7DQfOa6z9TWpRdnmCpZZvJ9yfYESWf9irTmMfxk8MW4Di
	 apCCMJ+hMjSOd3qVJUZsHOjPQdN9hhVBLK/ED39zxv33jh4/xXKgNuyLeZ0ATIfI/QV1X
	 Y4BUUqYGFI0E7UrO5jQgzcUa0V4OlNu/mNjnwmCKIr9PfOZS9fvA74T1agl/8lUFtoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="x/oN3P4C";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258B1606A325;
	Thu, 19 Nov 2026 03:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x/oN3P4C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DD21F000C4;
	Thu, 19 Nov 2026 03:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060518;
	bh=kM5cGArgepWNH8W73mG0ln7aO+kuBM1F0b7bk09svYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/oN3P4CwjJFpbsMLeQO+bH4/jfLgIWZpTRzgSn5ojbc+Ub+H698BPaf56+NKWWMc
	 ldB3zURZroJ3K59NTEZOFx+rJwYWYGHNM+7n4As03b5m601Dwu3xKEweveb2hUrplf
	 5G02+4OOrq/oMJswR2qdU4By9dcx8rmigfFCo6Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1226/1848] sit: fix UAF in ipip6_tunnel_del_prl()
Date: Wed, 18 Nov 2026 15:54:24 +0100
Message-ID: <20261118150011.245926433@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9e991d2a4c99b..54fa3715d620c 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -429,7 +429,7 @@ ipip6_tunnel_del_prl(struct ip_tunnel *t, struct ip_tunnel_prl *a)
 		     (x = rtnl_dereference(*p)) != NULL;
 		     p = &x->next) {
 			if (x->addr == a->addr) {
-				*p = x->next;
+				rcu_assign_pointer(*p, rtnl_dereference(x->next));
 				kfree_rcu(x, rcu_head);
 				t->prl_count--;
 				goto out;
@@ -440,8 +440,8 @@ ipip6_tunnel_del_prl(struct ip_tunnel *t, struct ip_tunnel_prl *a)
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



