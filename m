Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029444;
	b=gY2x3lYPY9CuW+3kkIJWt72/7nD+T8ok8I48GicXK62tfChwRCx/uemgOzZpTxBTFDVB
	 2BfqYBch+RBmoOFOcXYf7dwfJ9WLEAetU7wM9ebvhr1c7eku2T/rHy/sBlJ7U166TpImX
	 X79T+lE8GjEb6IaG6ygTeelXBXqva4dTZ1ErvdolbKkM5r27TTV5L26TJSQOMZqi/SID7
	 Z5zp2h5++OSl388dE7CaJHQ/tnyVxyj5b0mbeR6Ed1fXIVh5Eo0kFr5c/3GH8JmfJZOW/
	 Z+PoD6fS+ParK5CiA2OeWCoPh9m7Uj/dBS1CEHQeplyJlI2z/LTaBb7ZLIsUt+af9mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XYME2G4xDzlqfybDNhbUsqZORzeHpFmGAS1jxkDr9qw=;
	b=TCSZILDvkviVJ/SSWBLeDQlemoJJtSa/radPwg+u/NkRlPR9jUOH0rjiK7jTgKvzZ6V9
	 jkslPwYlGtrHKAwaHQOI3oJXYWi3oI7ej4daa8/sIkWvJ3pFBvU3omReP8V3a5ZLunqmS
	 5PnFwJBwq3YcAPIz+U0B1uLF+hR5iSJZJsay9xswog32DCXXK9tWq1YyzxfZrxev5hxdh
	 Cu3ehhxZBRbrDzAusWkVn1dvuAOOoRXipwY//m695cvtVugieUs8nPLZCatPH9D2swigv
	 UhsaJdkIv6hJf69+mjoH0GgHuw6/k3esEFCO1nj/4Sy2MCXDzagR9fuwnsfN+xKFksw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RrOycnvq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414FA606A320;
	Wed, 18 Nov 2026 19:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RrOycnvq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C271F000C5;
	Wed, 18 Nov 2026 19:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029444;
	bh=XYME2G4xDzlqfybDNhbUsqZORzeHpFmGAS1jxkDr9qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RrOycnvqM03taFKyWxCpw/DoHP5oqd/4pgyh7EZyHxs1jbhoOXf8x7yKjgBWvKDaR
	 znCPpuAHLMUyWY7O3ILbZeS9d7XvefvROKnaxsErZzD7wfgpHpBt5eQPN/MdCzFTwe
	 ylAcUGrj2Z0Fi/5tj4rdrrYBX8M6lC2T14dhXBVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0351/1756] sit: fix UAF in ipip6_tunnel_del_prl()
Date: Wed, 18 Nov 2026 15:41:18 +0100
Message-ID: <20261118150022.333542384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 614f7267dc9f8..eb42d3075e77d 100644
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



