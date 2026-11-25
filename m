Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625199;
	b=EY22nz1cgqkd2+a2E0oTj7OjbpVgzzDrjIXhjrlcU3QbXQ+DDtllpZyiCNe22f3V1NSu
	 xTCtbdZxnKul5kRgNrkqNU0XjUEXk0oVf4yNzuVrKliUZVvXv0X7BcmtZH/vKIgen8hP0
	 n4VrZwJkwTqqTs5j6iXWL3EiPUvlZ9a1c51FxAwwSMM1iY9a9WKam5S0RjeLEytTYOXid
	 HLoeE4w24cRL+i34DKilPfQGu0en6wE/W66iaAFWykBRt6mD/e3qQSVSptbb72rXf+ArV
	 +ksck8eiRxDKK/Zaf1dBQJs9bwdpUJZY2v72IQXIG6JXVmiCXPxtDcbwzmOuZGJZq+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qwrbkaqljMJ8usONFQF7RTh2HD2NRHk6TR06SW85SBc=;
	b=z2Myj+H8u4j/i/QrrMnV73RKpUk56IqMNylX5lPKAQKDUjryhVOsSNWJO+nGzA6hculm
	 9lUgCtR5qnBhgasNAUlcGz3Jiw4paVwuP+HNh+MI/CdGYzYKMxqASBWJwgkcKsGpfAMDZ
	 1be0W5escnoaRNAk/4ARj31fA/FgFG5qB4j37qMhf8kdlVZtp5zYZh/PbpLeAYRk+2GDe
	 wjcnxeHKTka6/QCUl4lsdnbs/N+vgEPdzebdp0QSXBGmgqsQrwngT2He6B1MRHJFtWluR
	 1D7gDTwoq9WSoFibdLS9B367YM4Fdiu9DqQx9dPsCPQbQl5Pqy17YGRUuk71R6SkHjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HX9KHzej;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2391606A323;
	Wed, 25 Nov 2026 16:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HX9KHzej
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2AE1F000D1;
	Wed, 25 Nov 2026 16:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625198;
	bh=qwrbkaqljMJ8usONFQF7RTh2HD2NRHk6TR06SW85SBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HX9KHzejaNHhI+dWotkIizOcfuz0dtF+aKfGqxRV876isul9LqUfdd937Zu+SECoM
	 Ku+qYo90syeW2qXhHdx7cl2fPudTddRPxvk1q26P6jYmQR90PVGgHVtRDiZorpB8AC
	 yvgqojRs37MkyN9PtOoByWp7I0WpRsFwm0FrmJbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 438/816] netfilter: nfnetlink: Fix for interrupted hook dumps
Date: Wed, 25 Nov 2026 15:33:06 +0100
Message-ID: <20261125143859.328413738@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit d3950004ba90350bcdf414c5f804da277178564a ]

Handling of concurrent hook changes with a dump in progress was
problematic in nfnl_hook_dump and entirely broken in nfnl_hook_dump_nat.
Address all issues in a single patch to please the review LLM.

Introduce sequence numbers in struct netns_nf to replace pointer
value-based modification detection which may fail due to memory buffer
reuse. This also eliminates the need for most manual cb->seq updates and
excessive array index value checks.

Since nat hook updates are protected by a different mutex than others,
they have to bump their own sequence number. nfnl_hook_dump_nat
therefore open-codes what nl_dump_check_consistent does but bumps
cb->seq instead of setting NLM_F_DUMP_INTR flag.

Dumps of many nat hooks was entirely broken since the array index was
not (re)stored. Use cb->args[1] for that and make sure it is reset upon
completion as the same dump may loop over multiple arrays of nat hooks.

In nfnl_hook_dump, don't signal NLM_F_DUMP_INTR if
nfnl_hook_entries_head returns error: This is a permanent condition
which does not change during a dump. It is already caught by
nfnl_hook_dump_start though, so should not happen anyway.

In general, access ops array pointer values using READ_ONCE since they
are assigned to using WRITE_ONCE.

Avoid setting NLM_F_DUMP_INTR flag in garbage memory by calling
nl_dump_check_consistent only for non-empty skbs. If not a single
netlink message was created, nfnetlink code will take care of setting
the flag.

Fixes: e2cf17d3774c ("netfilter: add new hook nfnl subsystem")
Fixes: b010e2a4a9ac ("netfilter: nfnetlink_hook: Dump nat type chains")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[ sashal: Dropped the NAT-hook parts (nat_hook_base_seq, bump_nat_hook_base_seq, nfnl_hook_dump_nat rewrite) since the NAT dump feature isn't in this tree, keeping only the non-NAT sequence-number fix. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netns/netfilter.h  |  1 +
 net/netfilter/core.c           | 17 ++++++++++++++++-
 net/netfilter/nfnetlink_hook.c | 20 +++++---------------
 3 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index a6a0bf4a247e5..6de1006a48655 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -33,5 +33,6 @@ struct netns_nf {
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 	unsigned int defrag_ipv6_users;
 #endif
+	unsigned int hook_base_seq;
 };
 #endif
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index b9f551f02c813..f8346fee36b6b 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -393,6 +393,15 @@ static void nf_static_key_dec(const struct nf_hook_ops *reg, int pf)
 #endif
 }
 
+static void bump_hook_base_seq(struct net *net)
+{
+	unsigned int base_seq = READ_ONCE(net->nf.hook_base_seq);
+
+	while (++base_seq == 0)
+		;
+	smp_store_release(&net->nf.hook_base_seq, base_seq);
+}
+
 static int __nf_register_net_hook(struct net *net, int pf,
 				  const struct nf_hook_ops *reg)
 {
@@ -437,6 +446,7 @@ static int __nf_register_net_hook(struct net *net, int pf,
 	if (!IS_ERR(new_hooks)) {
 		hooks_validate(new_hooks);
 		rcu_assign_pointer(*pp, new_hooks);
+		bump_hook_base_seq(net);
 	}
 
 	mutex_unlock(&nf_hook_mutex);
@@ -490,6 +500,7 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 {
 	struct nf_hook_entries __rcu **pp;
 	struct nf_hook_entries *p;
+	bool found;
 
 	pp = nf_hook_entry_head(net, pf, reg->hooknum, reg->dev);
 	if (!pp)
@@ -503,7 +514,8 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 		return;
 	}
 
-	if (nf_remove_net_hook(p, reg)) {
+	found = nf_remove_net_hook(p, reg);
+	if (found) {
 #ifdef CONFIG_NETFILTER_INGRESS
 		if (nf_ingress_hook(reg, pf))
 			net_dec_ingress_queue();
@@ -518,6 +530,8 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 	}
 
 	p = __nf_hook_entries_try_shrink(p, pp);
+	if (found)
+		bump_hook_base_seq(net);
 	mutex_unlock(&nf_hook_mutex);
 	if (!p)
 		return;
@@ -791,6 +805,7 @@ static int __net_init netfilter_net_init(struct net *net)
 		return -ENOMEM;
 	}
 #endif
+	net->nf.hook_base_seq = 1;
 
 	return 0;
 }
diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index ade8ee1988b1e..9d9468ec700de 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -54,7 +54,6 @@ static int nf_netlink_dump_start_rcu(struct sock *nlsk, struct sk_buff *skb,
 
 struct nfnl_dump_hook_data {
 	char devname[IFNAMSIZ];
-	unsigned long headv;
 	u8 hook;
 };
 
@@ -311,30 +310,24 @@ static int nfnl_hook_dump(struct sk_buff *nlskb,
 	unsigned int i = cb->args[0];
 
 	rcu_read_lock();
+	cb->seq = smp_load_acquire(&net->nf.hook_base_seq);
 
 	e = nfnl_hook_entries_head(family, ctx->hook, net, ctx->devname);
-	if (!e)
+	if (!e || IS_ERR(e))
 		goto done;
 
-	if (IS_ERR(e)) {
-		cb->seq++;
-		goto done;
-	}
-
-	if ((unsigned long)e != ctx->headv || i >= e->num_hook_entries)
-		cb->seq++;
-
 	ops = nf_hook_entries_get_hook_ops(e);
 
 	for (; i < e->num_hook_entries; i++) {
-		err = nfnl_hook_dump_one(nlskb, ctx, ops[i], family,
+		err = nfnl_hook_dump_one(nlskb, ctx, READ_ONCE(ops[i]), family,
 					 cb->nlh->nlmsg_seq);
 		if (err)
 			break;
 	}
 
 done:
-	nl_dump_check_consistent(cb, nlmsg_hdr(nlskb));
+	if (nlskb->len > 0)
+		nl_dump_check_consistent(cb, nlmsg_hdr(nlskb));
 	rcu_read_unlock();
 	cb->args[0] = i;
 	return nlskb->len;
@@ -375,10 +368,7 @@ static int nfnl_hook_dump_start(struct netlink_callback *cb)
 		return -ENOMEM;
 
 	strscpy(ctx->devname, name, sizeof(ctx->devname));
-	ctx->headv = (unsigned long)head;
 	ctx->hook = hooknum;
-
-	cb->seq = 1;
 	cb->data = ctx;
 
 	return 0;
-- 
2.53.0



