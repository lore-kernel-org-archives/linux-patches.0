Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98DE1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38219C433C8;
	Mon, 21 Aug 2023 20:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648463;
	bh=bDeBIluEu48zdvXuNIrsdh7FPBbB03Jw7qi4wWWp7ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZM+7FSixvntfy1sBoUqbh1nDoetOlcdjB42KF3yQRtlVqo6fpJoN1nfPIA1y1gws
	 5NOCgrSnopetnXWqWWiVGgw2BIYx4GIfOBCzxzDremycuWzAFKwfGhvGb+cEYdGZ2N
	 /8aD+uHjhs5A5LgTJU2UVAzIHE8PXZ57qXXChG7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 157/234] netfilter: nf_tables: fix false-positive lockdep splat
Date: Mon, 21 Aug 2023 21:42:00 +0200
Message-ID: <20230821194135.765219349@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit b9f052dc68f69dac89fe1e24693354c033daa091 ]

->abort invocation may cause splat on debug kernels:

WARNING: suspicious RCU usage
net/netfilter/nft_set_pipapo.c:1697 suspicious rcu_dereference_check() usage!
[..]
rcu_scheduler_active = 2, debug_locks = 1
1 lock held by nft/133554: [..] (nft_net->commit_mutex){+.+.}-{3:3}, at: nf_tables_valid_genid
[..]
 lockdep_rcu_suspicious+0x1ad/0x260
 nft_pipapo_abort+0x145/0x180
 __nf_tables_abort+0x5359/0x63d0
 nf_tables_abort+0x24/0x40
 nfnetlink_rcv+0x1a0a/0x22c0
 netlink_unicast+0x73c/0x900
 netlink_sendmsg+0x7f0/0xc20
 ____sys_sendmsg+0x48d/0x760

Transaction mutex is held, so parallel updates are not possible.
Switch to _protected and check mutex is held for lockdep enabled builds.

Fixes: 212ed75dc5fb ("netfilter: nf_tables: integrate pipapo into commit protocol")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 92b108e3000eb..3b5c3919fff9c 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1698,6 +1698,17 @@ static void nft_pipapo_commit(const struct nft_set *set)
 	priv->clone = new_clone;
 }
 
+static bool nft_pipapo_transaction_mutex_held(const struct nft_set *set)
+{
+#ifdef CONFIG_PROVE_LOCKING
+	const struct net *net = read_pnet(&set->net);
+
+	return lockdep_is_held(&nft_pernet(net)->commit_mutex);
+#else
+	return true;
+#endif
+}
+
 static void nft_pipapo_abort(const struct nft_set *set)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
@@ -1706,7 +1717,7 @@ static void nft_pipapo_abort(const struct nft_set *set)
 	if (!priv->dirty)
 		return;
 
-	m = rcu_dereference(priv->match);
+	m = rcu_dereference_protected(priv->match, nft_pipapo_transaction_mutex_held(set));
 
 	new_clone = pipapo_clone(m);
 	if (IS_ERR(new_clone))
-- 
2.40.1



