Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF9B44A701;
	Tue, 16 Jun 2026 15:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623445; cv=none; b=QqkiwKjh/SDL/5uS/Dd4uLzVM759MPJi38AUxqxR0/9cVvuTkZ8VdqYY9Zzi7LyriT8SF/vaD4bR9gCfbx40PiDuArEpwivaKZ1h8kGP33kEuNGDs4cQSOhRaHTH7CSzBZKFS+G+61xe/G3Obh7LtYh6LTGTg/iqe51aifq2cCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623445; c=relaxed/simple;
	bh=G5zofYfEIOLuYAVNtZ2igIybCbE7lbFdeh/Cc/n/4Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIUvzECxI/31y5ttY8TaPR8Fdjv+AwimSK1OMOxlkFE73Ll5svdf0s8PRFadpBH4WWo9GRh2VfrSgtVj9AgoOYYLXqKPmrC4jlUfHqd9jPajjDioW3cxIsl3ZizOudVrX2BrdKp8zucaHGnHxxtPnPiBHa28dgaCGe/19Auy9Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1+JjMex; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1+JjMex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEAA1F000E9;
	Tue, 16 Jun 2026 15:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623444;
	bh=v+jOJOUH0BSsqLKPbxqNBIlnAshxBBePW/9bIEhnY6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u1+JjMexWCxoQDW20gqRXMgHosVz3E1MnxDKtx1sO4eb1npSnrLfj49aQfBY7Fd5f
	 FI2to8ZSpivjPkT4jlJiGFyblQkwzvCqVPKhebz47WC6o24VCLnkFG6zgnRtArwYVV
	 /8Hjg5/0gR8bQqdeSsscPtp2ZoEmSxitqzG03cjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 142/378] netfilter: nf_conntrack: destroy stale expectfn expectations on unregister
Date: Tue, 16 Jun 2026 20:26:13 +0530
Message-ID: <20260616145117.746966220@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit c3009418f9fa1dcb3eb86f4d8c92583537b5faa3 ]

NAT helpers such as nf_nat_h323 store a raw pointer to module text in
exp->expectfn (e.g. ip_nat_q931_expect). nf_ct_helper_expectfn_unregister()
only unlinks the callback descriptor and never walks the expectation table,
so an expectation pending at module removal survives with a dangling
exp->expectfn into freed module text.

When the expected connection arrives, init_conntrack() invokes
exp->expectfn(), now a stale pointer into the unloaded module. Reproduced
on a KASAN build by loading the H.323 helpers, creating a Q.931
expectation, unloading nf_nat_h323, then connecting to the expected port:

 Oops: int3: 0000 [#1] SMP KASAN NOPTI
 RIP: 0010:0xffffffffa06102d1
  init_conntrack.isra.0 (net/netfilter/nf_conntrack_core.c:1862)
  nf_conntrack_in (net/netfilter/nf_conntrack_core.c:2049)
  ipv4_conntrack_local (net/netfilter/nf_conntrack_proto.c:223)
  nf_hook_slow (net/netfilter/core.c:619)
  __ip_local_out (net/ipv4/ip_output.c:120)
  __tcp_transmit_skb (net/ipv4/tcp_output.c:1715)
  tcp_connect (net/ipv4/tcp_output.c:4374)
  tcp_v4_connect (net/ipv4/tcp_ipv4.c:345)
  __sys_connect (net/socket.c:2167)
 Modules linked in: nf_conntrack_h323 [last unloaded: nf_nat_h323]

Reaching the dangling state requires CAP_SYS_MODULE in the initial user
namespace to remove a NAT helper that still has live expectations, so this
is a robustness fix; leaving an expectation pointing at freed text is wrong
regardless.

Add nf_ct_helper_expectfn_destroy(), which walks the expectation table and
drops every expectation whose ->expectfn matches the descriptor being torn
down. Call it from each NAT helper's exit path after the existing RCU grace
period, so no expectation outlives the code it points at and no extra
synchronize_rcu() is introduced. With the fix, the same reproducer runs to
completion without the Oops.

Fixes: f587de0e2feb ("[NETFILTER]: nf_conntrack/nf_nat: add H.323 helper port")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_conntrack_helper.h |  1 +
 net/ipv4/netfilter/nf_nat_h323.c            |  2 ++
 net/netfilter/nf_conntrack_helper.c         | 19 +++++++++++++++++++
 net/netfilter/nf_nat_core.c                 |  2 ++
 net/netfilter/nf_nat_sip.c                  |  1 +
 5 files changed, 25 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index de2f956abf3480..24cf3d2d97450f 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -155,6 +155,7 @@ void nf_ct_helper_log(struct sk_buff *skb, const struct nf_conn *ct,
 
 void nf_ct_helper_expectfn_register(struct nf_ct_helper_expectfn *n);
 void nf_ct_helper_expectfn_unregister(struct nf_ct_helper_expectfn *n);
+void nf_ct_helper_expectfn_destroy(const struct nf_ct_helper_expectfn *n);
 struct nf_ct_helper_expectfn *
 nf_ct_helper_expectfn_find_by_name(const char *name);
 struct nf_ct_helper_expectfn *
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index faee20af485613..10e1b0837731b7 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -555,6 +555,8 @@ static void __exit nf_nat_h323_fini(void)
 	nf_ct_helper_expectfn_unregister(&q931_nat);
 	nf_ct_helper_expectfn_unregister(&callforwarding_nat);
 	synchronize_rcu();
+	nf_ct_helper_expectfn_destroy(&q931_nat);
+	nf_ct_helper_expectfn_destroy(&callforwarding_nat);
 }
 
 /****************************************************************************/
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index b594cd244fe1d4..ea0cdb7ec91512 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -283,6 +283,25 @@ void nf_ct_helper_expectfn_unregister(struct nf_ct_helper_expectfn *n)
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_unregister);
 
+static bool expect_iter_expectfn(struct nf_conntrack_expect *exp, void *data)
+{
+	const struct nf_ct_helper_expectfn *n = data;
+
+	/* Relies on registered expectfn descriptors having unique ->expectfn
+	 * pointers, which holds for the in-tree NAT helpers.
+	 */
+	return exp->expectfn == n->expectfn;
+}
+
+/* Destroy expectations still pointing at @n->expectfn; call after the
+ * caller's RCU grace period so none outlives the (often modular) callback.
+ */
+void nf_ct_helper_expectfn_destroy(const struct nf_ct_helper_expectfn *n)
+{
+	nf_ct_expect_iterate_destroy(expect_iter_expectfn, (void *)n);
+}
+EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_destroy);
+
 /* Caller should hold the rcu lock */
 struct nf_ct_helper_expectfn *
 nf_ct_helper_expectfn_find_by_name(const char *name)
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index b30ca94c2bb7ff..4f41311b868b47 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1347,6 +1347,7 @@ static int __init nf_nat_init(void)
 		RCU_INIT_POINTER(nf_nat_hook, NULL);
 		nf_ct_helper_expectfn_unregister(&follow_master_nat);
 		synchronize_net();
+		nf_ct_helper_expectfn_destroy(&follow_master_nat);
 		unregister_pernet_subsys(&nat_net_ops);
 		kvfree(nf_nat_bysource);
 	}
@@ -1364,6 +1365,7 @@ static void __exit nf_nat_cleanup(void)
 	RCU_INIT_POINTER(nf_nat_hook, NULL);
 
 	synchronize_net();
+	nf_ct_helper_expectfn_destroy(&follow_master_nat);
 	kvfree(nf_nat_bysource);
 	unregister_pernet_subsys(&nat_net_ops);
 }
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index 9fbfc6bff0c221..00838c0cc5bb28 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -655,6 +655,7 @@ static void __exit nf_nat_sip_fini(void)
 	RCU_INIT_POINTER(nf_nat_sip_hooks, NULL);
 	nf_ct_helper_expectfn_unregister(&sip_nat);
 	synchronize_rcu();
+	nf_ct_helper_expectfn_destroy(&sip_nat);
 }
 
 static const struct nf_nat_sip_hooks sip_hooks = {
-- 
2.53.0



