Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039624;
	b=1zzY8hbCqBEGQbD4EEFXkSpr1+TSaor6fDGpChP0AGFu8ysmD0pGOIGbmehbQ3XmolV1
	 pPAl6qFInq2ZNldrjO+fzJhzk8vE7gfudOrz6YsQ4r4Dz88deryJoVTc2ZRBpMFurBe0j
	 BS0Kj135Iy59qtVGpUVSPwiX6JD5f2KAGc9RkgbQtCnGL1U2OqMI5qKHqL+86F2Pr9QH7
	 JLJibVuVK0xnrAYsbbch8z60Il3KPP5oGrgJJGWvaWpgcO17mum+XHLStqEWfgWfbAcEQ
	 d6gD6K2raox6VSudAVNHsHqHUtFZapIyqOz1WgV3D9ljH08gifKIzWwPVWXfO3u4/1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8BPIk9QXxHlia/o7oJ8Kvc8Cjz8AnW9J1KI23LAFH4g=;
	b=AgOU+pfFqVJmaJg3Tyd4NKKXGgnbf69L/IkxaBLansjJWigp3fMkKg96pylYLnCfcb6C
	 CKuBJ44SqyNEMjbzHqkD98fIECdnOh7qypqX8y4SYXVm46+mzp9Y1pITjG7KxjL8l8kTf
	 gOGAramx6WBbMs/34mZ75tkR0gtiXpeCb2PdleXe906Gu2/iMy0vM/xpfyYpWPNqciDp6
	 dpYzHh9iuVFugEFcL6wkqGKocII5Qw6eChkkGE4P7RZb6KHyp0vLuWP/C7Q7+MQW3rbaV
	 v8DOz1vfRpY6OLG+SvWZszyqsuvrg+MNgPFG6hlcv7nA82gnN/BTvTA5PNJk00zCwcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MlLK3egi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12321606A31C;
	Wed, 18 Nov 2026 22:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MlLK3egi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2541F000C5;
	Wed, 18 Nov 2026 22:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039623;
	bh=8BPIk9QXxHlia/o7oJ8Kvc8Cjz8AnW9J1KI23LAFH4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MlLK3egitKnatgzF0JlroHDzbmoezlOAtwaGGoCPhyh5N7/cqnobnQcuV5gSGNlcO
	 fU4snSi+QnCY3AG5o3dkP8UyHKkGnwnBxDCiPlMwPps5h2WceubHaQFM36v15kuYT5
	 2U8q57eZ5Fu/FTRvRuM2AaK54K5VO5IYLyN0NV88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2167/3318] sit: fix UAF in ipip6_tunnel_del_prl()
Date: Wed, 18 Nov 2026 15:46:29 +0100
Message-ID: <20261118150427.006663602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



