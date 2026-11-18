Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054987;
	b=ngdMQpYp4/Acr7we6lzF19oSQO+as7BzZHv0HbpB/u3elYKLuJGM4hRSUiyA59Sa+wqm
	 vKG5DbWBrFK7CNYAc0M70rOGb8u3Lx2cuKdL2gXYHlnYoM9CtPLrbuB0LKHmdLUrNqrMb
	 wvp84dVphIAbn98LIAIT9vtuE4LPipmVQB5/hRmZo/EEAQS5GFJn9Ose03DNJ+VJx8luR
	 V45xngoZXsIxYW5k9PgUp0nR50DqqbpuVqyKfi3mxYhTOMwIye1+7WUUv2lnwm2GnAmu1
	 aXtCHSyG7HUXWvNyfIftm2L6zTxU5+jlFMtX6NQA1dL7nNNKB5rZbZ1FIBJyofjc+JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Bg84jcLTHu2pgfaceUqoFOP6Y1IRJQvhLETMSF09sk=;
	b=IAYF9LBQWHXiC9saqT1N/ZCr54YuBrrJFQbx3XNPmT3LYO8wSnkItXs+jVBROmNM5lJh
	 ZvD17Jp1hKuyEpzGS49E0J5l7m3G+5gbfbjw/NjR9egPZ/g2aD4n8DR+JQ4o5dl0Evkjj
	 LO3AAFyKR1JXtzIPUjhCGiN8tVSbhXirxK9XMvw7laL0KdiYYXmC5qptoYmcAL8kmCJ4C
	 LJfZgOVi1eyuqWJ+jnU9D3qbkE1xKl6ZlGxj4QBVCBtI+mAQuN+VLH8IDh7MeEOjPo8Gd
	 ym7+SDEMNa+B0aPzQu/uBwbNrCgxdkpxZswH6qg7tW4RiPETjNxXfRMEpe8eXsGRKcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ILkL/pHy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F1F606A31C;
	Thu, 19 Nov 2026 02:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILkL/pHy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DB51F000C4;
	Thu, 19 Nov 2026 02:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054986;
	bh=7Bg84jcLTHu2pgfaceUqoFOP6Y1IRJQvhLETMSF09sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILkL/pHynhMp0tpvXZMA3vsFHCRR6L83veGtR1tlJ1zLjnJWXwTExLBsxGda/qgWQ
	 xEiQqobksLCtloFybCUTVSqsQE09k7pMheierwIf/v1Av9PMXtF+VXzkUsyzkkGZ4Y
	 jYeXfx7m6cuLFhNBHdbpZCIqU0mWv5VjkFZEJsiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1471/2214] sit: fix UAF in ipip6_tunnel_del_prl()
Date: Wed, 18 Nov 2026 15:52:27 +0100
Message-ID: <20261118150110.033114970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d700789fb9d8e..52001a858c1f8 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -432,7 +432,7 @@ ipip6_tunnel_del_prl(struct ip_tunnel *t, struct ip_tunnel_prl *a)
 		     (x = rtnl_dereference(*p)) != NULL;
 		     p = &x->next) {
 			if (x->addr == a->addr) {
-				*p = x->next;
+				rcu_assign_pointer(*p, rtnl_dereference(x->next));
 				kfree_rcu(x, rcu_head);
 				t->prl_count--;
 				goto out;
@@ -443,8 +443,8 @@ ipip6_tunnel_del_prl(struct ip_tunnel *t, struct ip_tunnel_prl *a)
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



