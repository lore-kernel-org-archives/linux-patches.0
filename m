Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048151;
	b=Nhj9E3rR8dM/F0FOEy5SeNbunAAIZ14IZQWi+99wBGgv8fXtyWl/HKz47D/NpI+cjYeh
	 2klEKYiyr8L01JWJecJkD79NLgjltQgerIOW7wdGneXOeoc02apDNmG1nzV652SLmt02+
	 GOfkQAXHkhbNlQQ1n7lIRuZcOKGPOa3YYB+NXq03ZMUXMlqBiBRHVEeRUpLqPTDEKckNj
	 4OhY106pnWXGl1qlei1xFsnJz176eJrGNcpLJYi+96ZUE8NyPCrdYk25aE1lczNJcOarF
	 1VW7zdiv/m/m9Vi7TvYNe+ztEyF/50MbgXr+iNUFn0ugR+7f0bRa3Y8sa8QewqMXTdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r4t2VgWNyeiQgpedFFuoEDKXAhDEMFXOo0J0tHYoVA4=;
	b=H5UoTHSB3yBb6OfxbQbbGRMut0DclUYRPQSWqFgwKF2fhd06fMRUQZT3aX0z3ISq9q1l
	 iH90szWrjw/Eu7ViVD5GNxbInZ77btaL9pui7IIBPeiybRjlIuB8bWw8RGhmYjCF/CzWP
	 44ZoFj4XmLG4ZqgrFeBa2u1fqc8x6uJjU5mD4YXiLR3FA3cBq+BL87UKioOrl857UrzL7
	 YPD1XoDJ/FVnZEOHyMiDSMNZ0YNFol66YD5nKuFOPxF7ivwF5S126ZqCDoioRuQfGeJ/k
	 V8cif9n2Q8XTWyvq2y/B5SiE9CHFISVF0fIMDR2845r5YdjK5ep+wzrQPg+cRbj7B+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SXKgyRp2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B53606A332;
	Thu, 19 Nov 2026 00:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SXKgyRp2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8EE1F000C7;
	Thu, 19 Nov 2026 00:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048151;
	bh=r4t2VgWNyeiQgpedFFuoEDKXAhDEMFXOo0J0tHYoVA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SXKgyRp2a/Jhz4K9UH/wVLa9qabz6xwzx1PM7IQPSosAT3LTs29MwpaiDsbi2gNzo
	 bgCRcdAo4Nqd7cIRN0vLFrs1A7/DTdYqNsP+C6gQAjdHADxqiKjboDGD6odajSghWr
	 p+cQ1B6CmlYta7pRYR5sfu9YS4azGvRkfI4TmuE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1892/2857] sit: fix UAF in ipip6_tunnel_del_prl()
Date: Wed, 18 Nov 2026 15:48:46 +0100
Message-ID: <20261118150309.357527532@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bc1f0d3de34e1..2c0d62ec8ec4f 100644
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



