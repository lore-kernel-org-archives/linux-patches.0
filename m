Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016157;
	b=M4cBPo1uYXWnzu7avJc0GmvPrHEgtHMewxnF1F3C5qgKUQabLVW934PLimi0SkrjTUjI
	 YfxQOskKPASxSgtpVYoN8MiUf3F+EfzLMpGeV+zbN9urMIGTipMKU29LG/LY8aQy41Wgb
	 ip7s7o4Jrl9Ea9W98HbTPJ/mSCg+oUFhxPedY+AgjzjfiUq3tPPbI4psWRH6ZZyWpYI28
	 GgmYEPo9vL1wZByfJzbgC6HF7tKEBaSn7nK+fylsVAZilRgglof8vDN/f8mLPGreS4ZAm
	 ilNjtT2OAab8ruIRWMXRfCIYfNv7OKOg+nm8grpQMrJQDH8EZS2U/Y57UH+sQpCo+Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oPzg1KNA8XLxosS+hBTzj+SQPvlZAxOxpE05wdroCNk=;
	b=TVByJATfxjLIo0Y8clXL+cwDbIz8pLG29eQrNyo0NmOF9Tljmhy8fGrASkwi8FUn5VQc
	 TxwGOnDhLfyuSj3iXS1D2V2xdSF78H/WQ+IMGJ0hG5ng+K6OqN6B495HzVCd5XRJj8xSo
	 9INcsdJ+Gu0qemulkgHW9IgXZdkRP1mtV87KpbLNax4dyrybBV+/Ar0TdAX57f1X2jmnS
	 y/aiOh5UKXbXLjRDiFf3p+qUUQElie9GY2+WU92H6eAuYLrzEGvlp0z9ytZx4/tv9tQJG
	 zStUpymq97lPvotduWbVzOWnGTTvQjdFjNmc4IoVjIr/4Aexn5XCd/u4vOiVyLh0oVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lDC/msTK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2316606A335;
	Wed, 18 Nov 2026 15:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lDC/msTK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A971F000C9;
	Wed, 18 Nov 2026 15:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016156;
	bh=oPzg1KNA8XLxosS+hBTzj+SQPvlZAxOxpE05wdroCNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lDC/msTK9hn5U34393PFB8MtyK6+ItXIlxFt+UAVdqtEFJysTIE9ERaiyqAlQChwj
	 yMvdZffg1FDI4XAeFms4864Xc/wsovbEFpqOoREMNV1LC2uznKA0lHn4CIDxTZ8Qtg
	 it388KF0oW4yiD4R29HsoQhxXQvwP2qAqZcZeh7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0387/2651] sit: fix UAF in ipip6_tunnel_del_prl()
Date: Wed, 18 Nov 2026 15:27:07 +0100
Message-ID: <20261118150301.765388581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 19b7fa8d1a2a0..4438b2472b287 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -436,7 +436,7 @@ ipip6_tunnel_del_prl(struct ip_tunnel *t, struct ip_tunnel_prl *a)
 		     (x = rtnl_dereference(*p)) != NULL;
 		     p = &x->next) {
 			if (x->addr == a->addr) {
-				*p = x->next;
+				rcu_assign_pointer(*p, rtnl_dereference(x->next));
 				kfree_rcu(x, rcu_head);
 				t->prl_count--;
 				goto out;
@@ -447,8 +447,8 @@ ipip6_tunnel_del_prl(struct ip_tunnel *t, struct ip_tunnel_prl *a)
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



